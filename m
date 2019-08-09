Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4996887F30
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437189AbfHIQPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:10 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52914 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437117AbfHIQPG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:06 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9C3CC305D36A;
        Fri,  9 Aug 2019 19:01:44 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 56DAA305B7A0;
        Fri,  9 Aug 2019 19:01:44 +0300 (EEST)
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
Subject: [RFC PATCH v6 91/92] kvm: x86: emulate lock cmpxchg16b m128
Date:   Fri,  9 Aug 2019 19:00:46 +0300
Message-Id: <20190809160047.8319-92-alazar@bitdefender.com>
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

This patch adds support for lock cmpxchg16b m128 by extending the
existent emulation for lock cmpxchg8b m64.

For implementing the atomic operation, we use an explicit assembler
statement, as cmpxchg_double() does not provide the contents of the
memory on failure. As before, writeback is completely disabled as the
operation is executed directly on guest memory, unless the architecture
does not advertise CMPXCHG16B in CPUID.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/emulate.c | 117 ++++++++++++++++++++++++++++++-----------
 arch/x86/kvm/x86.c     |  37 ++++++++++++-
 2 files changed, 122 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2038e42c1eae..a37ad63836ea 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2318,46 +2318,103 @@ static int em_call_near_abs(struct x86_emulate_ctxt *ctxt)
 	return rc;
 }
 
-static int em_cmpxchg8b(struct x86_emulate_ctxt *ctxt)
+static int em_cmpxchg8b_locked(struct x86_emulate_ctxt *ctxt)
 {
-	u64 old;
+	int rc;
+	ulong linear;
+	u64 new = (reg_read(ctxt, VCPU_REGS_RBX) & (u32)-1) |
+		((reg_read(ctxt, VCPU_REGS_RCX) & (u32)-1) << 32);
+	u64 old = (reg_read(ctxt, VCPU_REGS_RAX) & (u32)-1) |
+		((reg_read(ctxt, VCPU_REGS_RDX) & (u32)-1) << 32);
 
-	if (ctxt->lock_prefix) {
-		int rc;
-		ulong linear;
-		u64 new = (reg_read(ctxt, VCPU_REGS_RBX) & (u32)-1) |
-			((reg_read(ctxt, VCPU_REGS_RCX) & (u32)-1) << 32);
+	/* disable writeback altogether */
+	ctxt->d |= NoWrite;
 
-		old = (reg_read(ctxt, VCPU_REGS_RAX) & (u32)-1) |
-			((reg_read(ctxt, VCPU_REGS_RDX) & (u32)-1) << 32);
+	rc = linearize(ctxt, ctxt->dst.addr.mem, 8, true, &linear);
+	if (rc != X86EMUL_CONTINUE)
+		return rc;
 
-		/* disable writeback altogether */
-		ctxt->d &= ~SrcWrite;
-		ctxt->d |= NoWrite;
+	rc = ctxt->ops->cmpxchg_emulated(ctxt, linear, &old, &new,
+					 8, &ctxt->exception);
 
-		rc = linearize(ctxt, ctxt->dst.addr.mem, 8, true, &linear);
-		if (rc != X86EMUL_CONTINUE)
-			return rc;
 
-		rc = ctxt->ops->cmpxchg_emulated(ctxt, linear, &old, &new,
-						 ctxt->dst.bytes,
-						 &ctxt->exception);
+	switch (rc) {
+	case X86EMUL_CONTINUE:
+		ctxt->eflags |= X86_EFLAGS_ZF;
+		break;
+	case X86EMUL_CMPXCHG_FAILED:
+		*reg_write(ctxt, VCPU_REGS_RAX) = old & (u32)-1;
+		*reg_write(ctxt, VCPU_REGS_RDX) = (old >> 32) & (u32)-1;
 
-		switch (rc) {
-		case X86EMUL_CONTINUE:
-			ctxt->eflags |= X86_EFLAGS_ZF;
-			break;
-		case X86EMUL_CMPXCHG_FAILED:
-			*reg_write(ctxt, VCPU_REGS_RAX) = old & (u32)-1;
-			*reg_write(ctxt, VCPU_REGS_RDX) = (old >> 32) & (u32)-1;
+		ctxt->eflags &= ~X86_EFLAGS_ZF;
 
-			ctxt->eflags &= ~X86_EFLAGS_ZF;
+		rc = X86EMUL_CONTINUE;
+		break;
+	}
 
-			rc = X86EMUL_CONTINUE;
-			break;
-		}
+	return rc;
+}
+
+#ifdef CONFIG_X86_64
+static int em_cmpxchg16b_locked(struct x86_emulate_ctxt *ctxt)
+{
+	int rc;
+	ulong linear;
+	u64 new[2] = {
+		reg_read(ctxt, VCPU_REGS_RBX),
+		reg_read(ctxt, VCPU_REGS_RCX)
+	};
+	u64 old[2] = {
+		reg_read(ctxt, VCPU_REGS_RAX),
+		reg_read(ctxt, VCPU_REGS_RDX)
+	};
 
+	/* disable writeback altogether */
+	ctxt->d |= NoWrite;
+
+	rc = linearize(ctxt, ctxt->dst.addr.mem, 16, true, &linear);
+	if (rc != X86EMUL_CONTINUE)
 		return rc;
+
+	if (linear % 16)
+		return emulate_gp(ctxt, 0);
+
+	rc = ctxt->ops->cmpxchg_emulated(ctxt, linear, old, new,
+					 16, &ctxt->exception);
+
+	switch (rc) {
+	case X86EMUL_CONTINUE:
+		ctxt->eflags |= X86_EFLAGS_ZF;
+		break;
+	case X86EMUL_CMPXCHG_FAILED:
+		*reg_write(ctxt, VCPU_REGS_RAX) = old[0];
+		*reg_write(ctxt, VCPU_REGS_RDX) = old[1];
+
+		ctxt->eflags &= ~X86_EFLAGS_ZF;
+
+		rc = X86EMUL_CONTINUE;
+		break;
+	}
+
+	return rc;
+}
+#else
+static int em_cmpxchg16b_locked(struct x86_emulate_ctxt *ctxt)
+{
+	return X86EMUL_UNHANDLEABLE;
+}
+#endif
+
+static int em_cmpxchg8_16b(struct x86_emulate_ctxt *ctxt)
+{
+	u64 old;
+
+	if (ctxt->lock_prefix) {
+		if (ctxt->dst.bytes == 8)
+			return em_cmpxchg8b_locked(ctxt);
+		else if (ctxt->dst.bytes == 16)
+			return em_cmpxchg16b_locked(ctxt);
+		return X86EMUL_UNHANDLEABLE;
 	}
 
 	old = ctxt->dst.orig_val64;
@@ -4679,7 +4736,7 @@ static const struct gprefix pfx_0f_c7_7 = {
 
 
 static const struct group_dual group9 = { {
-	N, I(DstMem64 | Lock | PageTable, em_cmpxchg8b), N, N, N, N, N, N,
+	N, I(DstMem64 | Lock | PageTable, em_cmpxchg8_16b), N, N, N, N, N, N,
 }, {
 	N, N, N, N, N, N, N,
 	GP(0, &pfx_0f_c7_7),
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 346ce6c5887b..0e904782d303 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5665,8 +5665,17 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	char *kaddr;
 	bool exchanged = false;
 
-	/* guests cmpxchg8b have to be emulated atomically */
-	if (bytes > 8 || (bytes & (bytes - 1)))
+#ifdef CONFIG_X86_64
+#define CMPXCHG_MAX_BYTES 16
+#else
+#define CMPXCHG_MAX_BYTES 8
+#endif
+
+	/* guests cmpxchg{8,16}b have to be emulated atomically */
+	if (bytes > CMPXCHG_MAX_BYTES || (bytes & (bytes - 1)))
+		goto emul_write;
+
+	if (bytes == 16 && !system_has_cmpxchg_double())
 		goto emul_write;
 
 	gpa = kvm_mmu_gva_to_gpa_write(vcpu, addr, NULL);
@@ -5724,6 +5733,30 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 			*((u64 *)old) = val;
 		break;
 	}
+#ifdef CONFIG_X86_64
+	case 16: {
+		u64 *p1 = (u64 *)kaddr;
+		u64 *p2 = p1 + 1;
+		u64 *o1 = old;
+		u64 *o2 = o1 + 1;
+		const u64 *n1 = new;
+		const u64 *n2 = n1 + 1;
+		const u64 __o1 = *o1;
+		const u64 __o2 = *o2;
+
+		/*
+		 * We use an explicit asm statement because cmpxchg_double()
+		 * does not return the previous memory contents on failure
+		 */
+		asm volatile ("lock cmpxchg16b %2\n"
+			      : "+a"(*o1), "+d"(*o2), "+m"(*p1), "+m"(*p2)
+			      : "b"(*n1), "c"(*n2) : "memory");
+
+		if (__o1 == *o1 && __o2 == *o2)
+			exchanged = true;
+		break;
+	}
+#endif
 	default:
 		BUG();
 	}
