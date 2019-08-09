Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3AA87F5F
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437111AbfHIQQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:16:15 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52906 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436993AbfHIQPC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:02 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id CE4CF305D368;
        Fri,  9 Aug 2019 19:01:43 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 8B2C3305B7A0;
        Fri,  9 Aug 2019 19:01:43 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 89/92] kvm: x86: make lock cmpxchg r, r/m atomic
Date:   Fri,  9 Aug 2019 19:00:44 +0300
Message-Id: <20190809160047.8319-90-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

The current emulation takes place in two steps: the first does all the
actions that an cmpxchg would do, sets ZF and saves all results in a
temporary storage (the emulation context). It's the second step that
does the actual atomic operation (actually uses cmpxchg). The problem
with this approach is that steps one and two can observe different
values in memory and when that happens RAX and RFLAGS will have invalid
values when returning to the guest as emulator_cmpxchg_emulated() does
not set these.

This patch modifies the prototype of emulator_cmpxchg_emulated() so that
when cmpxchg fails, it returns in *old the current value. We also modify
em_cmpxchg() so that if the LOCK prefix is present we invoke
emulator_cmpxchg_emulated() directly and set RAX and RFLAGS. Note that we
also disable writeback as it is no longer needed.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_emulate.h |  2 +-
 arch/x86/kvm/emulate.c             | 57 +++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c                 | 48 ++++++++++++++++++-------
 3 files changed, 89 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 97cb592687cb..863c04561a37 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -178,7 +178,7 @@ struct x86_emulate_ops {
 	 */
 	int (*cmpxchg_emulated)(struct x86_emulate_ctxt *ctxt,
 				unsigned long addr,
-				const void *old,
+				void *old,
 				const void *new,
 				unsigned int bytes,
 				struct x86_exception *fault);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 7261b94c6c00..dac4c0ca1ee3 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1547,11 +1547,15 @@ static int segmented_cmpxchg(struct x86_emulate_ctxt *ctxt,
 {
 	int rc;
 	ulong linear;
+	unsigned char buf[16];
 
 	rc = linearize(ctxt, addr, size, true, &linear);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
-	return ctxt->ops->cmpxchg_emulated(ctxt, linear, orig_data, data,
+	if (size > sizeof(buf))
+		return X86EMUL_UNHANDLEABLE;
+	memcpy(buf, orig_data, size);
+	return ctxt->ops->cmpxchg_emulated(ctxt, linear, buf, data,
 					   size, &ctxt->exception);
 }
 
@@ -1803,16 +1807,21 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 		/* CS(RPL) <- CPL */
 		selector = (selector & 0xfffc) | cpl;
 		break;
-	case VCPU_SREG_TR:
+	case VCPU_SREG_TR: {
+		struct desc_struct buf;
+
 		if (seg_desc.s || (seg_desc.type != 1 && seg_desc.type != 9))
 			goto exception;
-		old_desc = seg_desc;
+		buf = old_desc = seg_desc;
 		seg_desc.type |= 2; /* busy */
-		ret = ctxt->ops->cmpxchg_emulated(ctxt, desc_addr, &old_desc, &seg_desc,
-						  sizeof(seg_desc), &ctxt->exception);
+		ret = ctxt->ops->cmpxchg_emulated(ctxt, desc_addr, &buf,
+						  &seg_desc,
+						  sizeof(seg_desc),
+						  &ctxt->exception);
 		if (ret != X86EMUL_CONTINUE)
 			return ret;
 		break;
+	}
 	case VCPU_SREG_LDTR:
 		if (seg_desc.s || seg_desc.type != 2)
 			goto exception;
@@ -2384,6 +2393,44 @@ static int em_ret_far_imm(struct x86_emulate_ctxt *ctxt)
 
 static int em_cmpxchg(struct x86_emulate_ctxt *ctxt)
 {
+	if (ctxt->lock_prefix) {
+		int rc;
+		ulong linear;
+		u64 old = reg_read(ctxt, VCPU_REGS_RAX);
+		u64 new = ctxt->src.val64;
+
+		/* disable writeback altogether */
+		ctxt->d &= ~SrcWrite;
+		ctxt->d |= NoWrite;
+
+		rc = linearize(ctxt, ctxt->dst.addr.mem, ctxt->dst.bytes, true,
+			       &linear);
+		if (rc != X86EMUL_CONTINUE)
+			return rc;
+
+		rc = ctxt->ops->cmpxchg_emulated(ctxt, linear, &old, &new,
+						 ctxt->dst.bytes,
+						 &ctxt->exception);
+
+		switch (rc) {
+		case X86EMUL_CONTINUE:
+			ctxt->eflags |= X86_EFLAGS_ZF;
+			break;
+		case X86EMUL_CMPXCHG_FAILED: {
+			u64 mask = BITMAP_LAST_WORD_MASK(ctxt->dst.bytes * 8);
+
+			*reg_write(ctxt, VCPU_REGS_RAX) = old & mask;
+
+			ctxt->eflags &= ~X86_EFLAGS_ZF;
+
+			rc = X86EMUL_CONTINUE;
+			break;
+		}
+		}
+
+		return rc;
+	}
+
 	/* Save real source value, then compare EAX against destination. */
 	ctxt->dst.orig_val = ctxt->dst.val;
 	ctxt->dst.val = reg_read(ctxt, VCPU_REGS_RAX);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e09a76179c4b..346ce6c5887b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5643,18 +5643,18 @@ static int emulator_write_emulated(struct x86_emulate_ctxt *ctxt,
 }
 
 #define CMPXCHG_TYPE(t, ptr, old, new) \
-	(cmpxchg((t *)(ptr), *(t *)(old), *(t *)(new)) == *(t *)(old))
+	cmpxchg((t *)(ptr), *(t *)(old), *(t *)(new))
 
 #ifdef CONFIG_X86_64
 #  define CMPXCHG64(ptr, old, new) CMPXCHG_TYPE(u64, ptr, old, new)
 #else
 #  define CMPXCHG64(ptr, old, new) \
-	(cmpxchg64((u64 *)(ptr), *(u64 *)(old), *(u64 *)(new)) == *(u64 *)(old))
+	cmpxchg64((u64 *)(ptr), *(u64 *)(old), *(u64 *)(new))
 #endif
 
 static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 				     unsigned long addr,
-				     const void *old,
+				     void *old,
 				     const void *new,
 				     unsigned int bytes,
 				     struct x86_exception *exception)
@@ -5663,7 +5663,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	gpa_t gpa;
 	struct page *page;
 	char *kaddr;
-	bool exchanged;
+	bool exchanged = false;
 
 	/* guests cmpxchg8b have to be emulated atomically */
 	if (bytes > 8 || (bytes & (bytes - 1)))
@@ -5688,18 +5688,42 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	kaddr = kmap_atomic(page);
 	kaddr += offset_in_page(gpa);
 	switch (bytes) {
-	case 1:
-		exchanged = CMPXCHG_TYPE(u8, kaddr, old, new);
+	case 1: {
+		u8 val = CMPXCHG_TYPE(u8, kaddr, old, new);
+
+		if (*((u8 *)old) == val)
+			exchanged = true;
+		else
+			*((u8 *)old) = val;
 		break;
-	case 2:
-		exchanged = CMPXCHG_TYPE(u16, kaddr, old, new);
+	}
+	case 2: {
+		u16 val = CMPXCHG_TYPE(u16, kaddr, old, new);
+
+		if (*((u16 *)old) == val)
+			exchanged = true;
+		else
+			*((u16 *)old) = val;
 		break;
-	case 4:
-		exchanged = CMPXCHG_TYPE(u32, kaddr, old, new);
+	}
+	case 4: {
+		u32 val = CMPXCHG_TYPE(u32, kaddr, old, new);
+
+		if (*((u32 *)old) == val)
+			exchanged = true;
+		else
+			*((u32 *)old) = val;
 		break;
-	case 8:
-		exchanged = CMPXCHG64(kaddr, old, new);
+	}
+	case 8: {
+		u64 val = CMPXCHG64(kaddr, old, new);
+
+		if (*((u64 *)old) == val)
+			exchanged = true;
+		else
+			*((u64 *)old) = val;
 		break;
+	}
 	default:
 		BUG();
 	}
