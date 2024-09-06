Return-Path: <kvm+bounces-26039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E9E996FDE2
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 00:19:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48DAE28267E
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 22:19:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0417615B987;
	Fri,  6 Sep 2024 22:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VuKtquP3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A76F15B0F8
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 22:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725661121; cv=none; b=CSUnkt/CViG5pey5BmaJe08RrSgkkmRwUNmLRCMnME6nw/BgO+DduRKQm8TFtxqLFAYDeI1n1JAITU8tvKD7aBIKhyp1D7LRmt/nemREI1mghBOsKdNZW/uD7qN7gLw6ATXJZxqhJ9Wnd+NYSMJAh1TxMRG4n818AY+mhg0IuS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725661121; c=relaxed/simple;
	bh=RS7D6mC4Da90DJpRr6QUg5QrkEyp0IY6qq6xuCpONVk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sVjWAOphkcBKZle1qOgh3lesob9oLhYsBK9ZiJH+iTOew8++Do2ZpFfRynP4+JqC+yena4FnArwAgAcaCbcXTsn5DNnuq1LjaUpfTDTJ8lmUkpcSSXDelrybEB2p0c1a/ku8hYU8L1Z6AQTrpUiBC9UOx8rlcrUA7sjkxokHpm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VuKtquP3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725661118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LI5BD+pBOFIg79aPAmGwcLGYrtd2fLuNLyhnq+3LnKk=;
	b=VuKtquP3jKAzv1aXAikQ1y2llKNzr21BPhuWhBP5orCag6LzWXV14KL1uiuorSEwjwHCWv
	r448YPR20Lmjd8yT7lc/CFT6OdxlzkIVZtrcHfSr4hGC9IvKFrry8g3UWMDhyPJi6nlc8N
	7E1JWFmpQ8taCcNFDdgXcs84611fiVo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-675-1t18F8_JMZGW5uTg1IDnng-1; Fri,
 06 Sep 2024 18:18:35 -0400
X-MC-Unique: 1t18F8_JMZGW5uTg1IDnng-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50A5F1956077;
	Fri,  6 Sep 2024 22:18:33 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.51])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9E2B019560AA;
	Fri,  6 Sep 2024 22:18:30 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 2/4] KVM: x86: implement emul_is_noncanonical_address using is_noncanonical_address
Date: Fri,  6 Sep 2024 18:18:22 -0400
Message-Id: <20240906221824.491834-3-mlevitsk@redhat.com>
In-Reply-To: <20240906221824.491834-1-mlevitsk@redhat.com>
References: <20240906221824.491834-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Implement the emul_is_noncanonical_address() using
is_noncanonical_address().

This will allow to extend the is_noncanonical_address() to support
different flavors of canonical checks.

Also add X86EMUL_F_MSR and X86EMUL_F_DT_LOAD emulation flags which will be
used to indicate an emulation of a msr or a segment base load, which
will affect the required canonical check.

No functional change is intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c     | 15 +++++++++------
 arch/x86/kvm/kvm_emulate.h |  5 +++++
 arch/x86/kvm/x86.c         |  7 +++++++
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e72aed25d7212..8c8061884a019 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -651,9 +651,10 @@ static inline u8 ctxt_virt_addr_bits(struct x86_emulate_ctxt *ctxt)
 }
 
 static inline bool emul_is_noncanonical_address(u64 la,
-						struct x86_emulate_ctxt *ctxt)
+						struct x86_emulate_ctxt *ctxt,
+						unsigned int flags)
 {
-	return !__is_canonical_address(la, ctxt_virt_addr_bits(ctxt));
+	return !ctxt->ops->is_canonical_addr(ctxt, la, 0);
 }
 
 /*
@@ -1733,7 +1734,8 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 		if (ret != X86EMUL_CONTINUE)
 			return ret;
 		if (emul_is_noncanonical_address(get_desc_base(&seg_desc) |
-						 ((u64)base3 << 32), ctxt))
+						 ((u64)base3 << 32), ctxt,
+						 X86EMUL_F_DT_LOAD))
 			return emulate_gp(ctxt, err_code);
 	}
 
@@ -2516,8 +2518,8 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
 		ss_sel = cs_sel + 8;
 		cs.d = 0;
 		cs.l = 1;
-		if (emul_is_noncanonical_address(rcx, ctxt) ||
-		    emul_is_noncanonical_address(rdx, ctxt))
+		if (emul_is_noncanonical_address(rcx, ctxt, 0) ||
+		    emul_is_noncanonical_address(rdx, ctxt, 0))
 			return emulate_gp(ctxt, 0);
 		break;
 	}
@@ -3494,7 +3496,8 @@ static int em_lgdt_lidt(struct x86_emulate_ctxt *ctxt, bool lgdt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 	if (ctxt->mode == X86EMUL_MODE_PROT64 &&
-	    emul_is_noncanonical_address(desc_ptr.address, ctxt))
+	    emul_is_noncanonical_address(desc_ptr.address, ctxt,
+					 X86EMUL_F_DT_LOAD))
 		return emulate_gp(ctxt, 0);
 	if (lgdt)
 		ctxt->ops->set_gdt(ctxt, &desc_ptr);
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 55a18e2f2dcd9..86bde1c9d9183 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -94,6 +94,8 @@ struct x86_instruction_info {
 #define X86EMUL_F_FETCH			BIT(1)
 #define X86EMUL_F_IMPLICIT		BIT(2)
 #define X86EMUL_F_INVLPG		BIT(3)
+#define X86EMUL_F_MSR			BIT(4)
+#define X86EMUL_F_DT_LOAD		BIT(5)
 
 struct x86_emulate_ops {
 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
@@ -235,6 +237,9 @@ struct x86_emulate_ops {
 
 	gva_t (*get_untagged_addr)(struct x86_emulate_ctxt *ctxt, gva_t addr,
 				   unsigned int flags);
+
+	bool (*is_canonical_addr)(struct x86_emulate_ctxt *ctxt,
+				  gva_t addr, unsigned int flags);
 };
 
 /* Type, address-of, and value of an instruction's operand. */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f72e5d89e942d..f496830445355 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8617,6 +8617,12 @@ static gva_t emulator_get_untagged_addr(struct x86_emulate_ctxt *ctxt,
 					       addr, flags);
 }
 
+static bool emulator_is_canonical_addr(struct x86_emulate_ctxt *ctxt,
+				       gva_t addr, unsigned int flags)
+{
+	return !is_noncanonical_address(addr, emul_to_vcpu(ctxt));
+}
+
 static const struct x86_emulate_ops emulate_ops = {
 	.vm_bugged           = emulator_vm_bugged,
 	.read_gpr            = emulator_read_gpr,
@@ -8663,6 +8669,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
 	.get_untagged_addr   = emulator_get_untagged_addr,
+	.is_canonical_addr   = emulator_is_canonical_addr,
 };
 
 static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
-- 
2.26.3


