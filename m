Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE15F30C6B9
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 17:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbhBBQ5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 11:57:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236843AbhBBQxH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 11:53:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612284700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GnMIwa5VC9GXcb1HBbO5QLKdJCCfE3TtizlV41saPPo=;
        b=NZC2X0xOIBvXLWQjwvy9ESPBjxDurVe1OXL3gbbsHtgg9t/JtyWCWtPL7LQkMHJjQhDx9x
        eDTX/QfwUeCrFutTinEfu4Q2qLRPK4gmX1bd9jGgbdZQcIJefIZFVoPNMMsQp/jJoL5K/6
        DSCj0yV7pOGof+q3PKCtceQNAMvb96Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-AlDW1WwtN22QywYQNTlebw-1; Tue, 02 Feb 2021 11:51:38 -0500
X-MC-Unique: AlDW1WwtN22QywYQNTlebw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49C2185B660;
        Tue,  2 Feb 2021 16:51:37 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C240B5D9C6;
        Tue,  2 Feb 2021 16:51:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 0/3] use kvm_complete_insn_gp more
Date:   Tue,  2 Feb 2021 11:51:35 -0500
Message-Id: <20210202165135.88186-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_complete_insn_gp is a nice little function that dates back to more
than 10 years ago but was almost never used.

This simple series continues what was done for RDMSR/WRMSR in preparation
for SEV-ES support, using it in XSETBV, INVPCID and MOV to DR intercepts.

Paolo

Paolo Bonzini (3):
  KVM: x86: move kvm_inject_gp up from kvm_set_xcr to callers
  KVM: x86: move kvm_inject_gp up from kvm_handle_invpcid to callers
  KVM: x86: move kvm_inject_gp up from kvm_set_dr to callers

 arch/x86/kvm/svm/svm.c | 32 +++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.c | 35 ++++++++++++++++++-----------------
 arch/x86/kvm/x86.c     | 38 ++++++++++++--------------------------
 3 files changed, 45 insertions(+), 60 deletions(-)

-- 
2.26.2

From 54473e9148b13418d827019dcc70fa379e5458fb Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 14 Dec 2020 07:49:54 -0500
Subject: [PATCH 1/3] KVM: x86: move kvm_inject_gp up from kvm_set_xcr to
 callers

Push the injection of #GP up to the callers, so that they can just use
kvm_complete_insn_gp.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c |  7 ++-----
 arch/x86/kvm/vmx/vmx.c |  5 ++---
 arch/x86/kvm/x86.c     | 10 ++++------
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 687876211ebe..65d70b9691b4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2337,11 +2337,8 @@ static int xsetbv_interception(struct vcpu_svm *svm)
 	u64 new_bv = kvm_read_edx_eax(&svm->vcpu);
 	u32 index = kvm_rcx_read(&svm->vcpu);
 
-	if (kvm_set_xcr(&svm->vcpu, index, new_bv) == 0) {
-		return kvm_skip_emulated_instruction(&svm->vcpu);
-	}
-
-	return 1;
+	int err = kvm_set_xcr(&svm->vcpu, index, new_bv);
+	return kvm_complete_insn_gp(&svm->vcpu, err);
 }
 
 static int rdpru_interception(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9986a59f71a4..28daceb4f70d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5227,9 +5227,8 @@ static int handle_xsetbv(struct kvm_vcpu *vcpu)
 	u64 new_bv = kvm_read_edx_eax(vcpu);
 	u32 index = kvm_rcx_read(vcpu);
 
-	if (kvm_set_xcr(vcpu, index, new_bv) == 0)
-		return kvm_skip_emulated_instruction(vcpu);
-	return 1;
+	int err = kvm_set_xcr(vcpu, index, new_bv);
+	return kvm_complete_insn_gp(vcpu, err);
 }
 
 static int handle_apic_access(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d14230dd38d8..08568c47337c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -986,12 +986,10 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 
 int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
-	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 ||
-	    __kvm_set_xcr(vcpu, index, xcr)) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-	return 0;
+	if (static_call(kvm_x86_get_cpl)(vcpu) == 0)
+		return __kvm_set_xcr(vcpu, index, xcr);
+
+	return 1;
 }
 EXPORT_SYMBOL_GPL(kvm_set_xcr);
 
-- 
2.26.2


From 3433aae8a0ecf04478e9bf2a6df5f66b4aefe254 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 14 Dec 2020 07:49:54 -0500
Subject: [PATCH 2/3] KVM: x86: move kvm_inject_gp up from kvm_handle_invpcid
 to callers

Push the injection of #GP up to the callers, so that they can just use
kvm_complete_insn_gp.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 11 ++++++-----
 arch/x86/kvm/vmx/vmx.c | 11 ++++++-----
 arch/x86/kvm/x86.c     |  9 +++------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 65d70b9691b4..c0d41a6920f0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3057,6 +3057,7 @@ static int invpcid_interception(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	unsigned long type;
 	gva_t gva;
+	int err;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
@@ -3071,12 +3072,12 @@ static int invpcid_interception(struct vcpu_svm *svm)
 	type = svm->vmcb->control.exit_info_2;
 	gva = svm->vmcb->control.exit_info_1;
 
-	if (type > 3) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
+	if (type > 3)
+		err = 1;
+	else
+		err = kvm_handle_invpcid(vcpu, type, gva);
 
-	return kvm_handle_invpcid(vcpu, type, gva);
+	return kvm_complete_insn_gp(&svm->vcpu, err);
 }
 
 static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 28daceb4f70d..a07fce6d0bbb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5559,6 +5559,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 		u64 pcid;
 		u64 gla;
 	} operand;
+	int err = 1;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
@@ -5568,10 +5569,8 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	type = kvm_register_readl(vcpu, (vmx_instruction_info >> 28) & 0xf);
 
-	if (type > 3) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
+	if (type > 3)
+		goto out;
 
 	/* According to the Intel instruction reference, the memory operand
 	 * is read even if it isn't needed (e.g., for type==all)
@@ -5581,7 +5580,9 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 				sizeof(operand), &gva))
 		return 1;
 
-	return kvm_handle_invpcid(vcpu, type, gva);
+	err = kvm_handle_invpcid(vcpu, type, gva);
+out:
+	return kvm_complete_insn_gp(vcpu, err);
 }
 
 static int handle_pml_full(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 08568c47337c..edbeb162012b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11375,7 +11375,6 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 		return kvm_handle_memory_failure(vcpu, r, &e);
 
 	if (operand.pcid >> 12 != 0) {
-		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
 
@@ -11385,15 +11384,13 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 	case INVPCID_TYPE_INDIV_ADDR:
 		if ((!pcid_enabled && (operand.pcid != 0)) ||
 		    is_noncanonical_address(operand.gla, vcpu)) {
-			kvm_inject_gp(vcpu, 0);
 			return 1;
 		}
 		kvm_mmu_invpcid_gva(vcpu, operand.gla, operand.pcid);
-		return kvm_skip_emulated_instruction(vcpu);
+		return 0;
 
 	case INVPCID_TYPE_SINGLE_CTXT:
 		if (!pcid_enabled && (operand.pcid != 0)) {
-			kvm_inject_gp(vcpu, 0);
 			return 1;
 		}
 
@@ -11414,7 +11411,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 		 * resync will happen anyway before switching to any other CR3.
 		 */
 
-		return kvm_skip_emulated_instruction(vcpu);
+		return 0;
 
 	case INVPCID_TYPE_ALL_NON_GLOBAL:
 		/*
@@ -11427,7 +11424,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 		fallthrough;
 	case INVPCID_TYPE_ALL_INCL_GLOBAL:
 		kvm_mmu_unload(vcpu);
-		return kvm_skip_emulated_instruction(vcpu);
+		return 0;
 
 	default:
 		BUG(); /* We have already checked above that type <= 3 */
-- 
2.26.2


From 010ddc679488a7f65d16f5b6674f2ad20d65adf7 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 14 Dec 2020 07:49:54 -0500
Subject: [PATCH 3/3] KVM: x86: move kvm_inject_gp up from kvm_set_dr to
 callers

Push the injection of #GP up to the callers, so that they can just use
kvm_complete_insn_gp. __kvm_set_dr is pretty much what the callers can use
together with kvm_complete_insn_gp, so rename it to kvm_set_dr and drop
the old kvm_set_dr wrapper.

This allows nested VMX code, which really wanted to use __kvm_set_dr, to
use the right function.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 14 +++++++-------
 arch/x86/kvm/vmx/vmx.c | 19 ++++++++++---------
 arch/x86/kvm/x86.c     | 19 +++++--------------
 3 files changed, 22 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c0d41a6920f0..818cf3babef2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2599,6 +2599,7 @@ static int dr_interception(struct vcpu_svm *svm)
 {
 	int reg, dr;
 	unsigned long val;
+	int err;
 
 	if (svm->vcpu.guest_debug == 0) {
 		/*
@@ -2617,19 +2618,18 @@ static int dr_interception(struct vcpu_svm *svm)
 	reg = svm->vmcb->control.exit_info_1 & SVM_EXITINFO_REG_MASK;
 	dr = svm->vmcb->control.exit_code - SVM_EXIT_READ_DR0;
 
+	if (!kvm_require_dr(&svm->vcpu, dr & 15))
+		return 1;
+
 	if (dr >= 16) { /* mov to DRn */
-		if (!kvm_require_dr(&svm->vcpu, dr - 16))
-			return 1;
 		val = kvm_register_read(&svm->vcpu, reg);
-		kvm_set_dr(&svm->vcpu, dr - 16, val);
+		err = kvm_set_dr(&svm->vcpu, dr - 16, val);
 	} else {
-		if (!kvm_require_dr(&svm->vcpu, dr))
-			return 1;
-		kvm_get_dr(&svm->vcpu, dr, &val);
+		err = kvm_get_dr(&svm->vcpu, dr, &val);
 		kvm_register_write(&svm->vcpu, reg, val);
 	}
 
-	return kvm_skip_emulated_instruction(&svm->vcpu);
+	return kvm_complete_insn_gp(&svm->vcpu, err);
 }
 
 static int cr8_write_interception(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a07fce6d0bbb..41a26d98fb95 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5099,6 +5099,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qualification;
 	int dr, dr7, reg;
+	int err = 1;
 
 	exit_qualification = vmx_get_exit_qual(vcpu);
 	dr = exit_qualification & DEBUG_REG_ACCESS_NUM;
@@ -5107,9 +5108,9 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	if (!kvm_require_dr(vcpu, dr))
 		return 1;
 
-	/* Do not handle if the CPL > 0, will trigger GP on re-entry */
-	if (!kvm_require_cpl(vcpu, 0))
-		return 1;
+	if (kvm_x86_ops.get_cpl(vcpu) > 0)
+		goto out;
+
 	dr7 = vmcs_readl(GUEST_DR7);
 	if (dr7 & DR7_GD) {
 		/*
@@ -5146,14 +5147,14 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	if (exit_qualification & TYPE_MOV_FROM_DR) {
 		unsigned long val;
 
-		if (kvm_get_dr(vcpu, dr, &val))
-			return 1;
+		err = kvm_get_dr(vcpu, dr, &val);
 		kvm_register_write(vcpu, reg, val);
-	} else
-		if (kvm_set_dr(vcpu, dr, kvm_register_readl(vcpu, reg)))
-			return 1;
+	} else {
+		err = kvm_set_dr(vcpu, dr, kvm_register_readl(vcpu, reg));
+	}
 
-	return kvm_skip_emulated_instruction(vcpu);
+out:
+	return kvm_complete_insn_gp(vcpu, err);
 }
 
 static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index edbeb162012b..b748bf0d6d33 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1147,7 +1147,7 @@ static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
 	return fixed;
 }
 
-static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
+int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 {
 	size_t size = ARRAY_SIZE(vcpu->arch.db);
 
@@ -1160,13 +1160,13 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 	case 4:
 	case 6:
 		if (!kvm_dr6_valid(val))
-			return -1; /* #GP */
+			return 1; /* #GP */
 		vcpu->arch.dr6 = (val & DR6_VOLATILE) | kvm_dr6_fixed(vcpu);
 		break;
 	case 5:
 	default: /* 7 */
 		if (!kvm_dr7_valid(val))
-			return -1; /* #GP */
+			return 1; /* #GP */
 		vcpu->arch.dr7 = (val & DR7_VOLATILE) | DR7_FIXED_1;
 		kvm_update_dr7(vcpu);
 		break;
@@ -1174,15 +1174,6 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 
 	return 0;
 }
-
-int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
-{
-	if (__kvm_set_dr(vcpu, dr, val)) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-	return 0;
-}
 EXPORT_SYMBOL_GPL(kvm_set_dr);
 
 int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
@@ -6595,7 +6586,7 @@ static int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,
 			   unsigned long value)
 {
 
-	return __kvm_set_dr(emul_to_vcpu(ctxt), dr, value);
+	return kvm_set_dr(emul_to_vcpu(ctxt), dr, value);
 }
 
 static u64 mk_cr_64(u64 curr_cr, u32 new_val)
@@ -8636,7 +8627,7 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	dt.address = dt.size = 0;
 	static_call(kvm_x86_set_idt)(vcpu, &dt);
 
-	__kvm_set_dr(vcpu, 7, DR7_FIXED_1);
+	kvm_set_dr(vcpu, 7, DR7_FIXED_1);
 
 	cs.selector = (vcpu->arch.smbase >> 4) & 0xffff;
 	cs.base = vcpu->arch.smbase;
-- 
2.26.2

