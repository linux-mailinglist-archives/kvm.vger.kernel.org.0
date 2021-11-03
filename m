Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A32444430F
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 15:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhKCOJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 10:09:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232126AbhKCOJN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 10:09:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635948396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2MFPJWw/YjKcCf73i5MWKmjZYuiytYS8BGDfdfUb/ac=;
        b=bJ/MEnPzpjis7Mm3h/62Rw3O2rjWek69rVVZK33RTBfgYWVmqSk/wQsb1I73wnPhLf97We
        MRlsp0pZ1kTkD/oBNGhnaG47IUCNVKGs5zCNWQzrRUxDQ6DGvDTcagstlLWN/lg14OddBb
        TD18co/KqfEh8VY+4noCALtayvDKNQg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-BgLvsTENOUOGt6m2GrDhKw-1; Wed, 03 Nov 2021 10:06:24 -0400
X-MC-Unique: BgLvsTENOUOGt6m2GrDhKw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78B14DF8A4;
        Wed,  3 Nov 2021 14:06:21 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D60A100EA05;
        Wed,  3 Nov 2021 14:06:20 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH v5 2/7] nSVM: introduce smv->nested.save to cache save area fields
Date:   Wed,  3 Nov 2021 10:05:22 -0400
Message-Id: <20211103140527.752797-3-eesposit@redhat.com>
In-Reply-To: <20211103140527.752797-1-eesposit@redhat.com>
References: <20211103140527.752797-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is useful in next patch, to avoid having temporary
copies of vmcb12 registers and passing them manually.

Right now, instead of blindly copying everything,
we just copy EFER, CR0, CR3, CR4, DR6 and DR7. If more fields
will need to be added, it will be more obvious to see
that they must be added in struct vmcb_save_area_cached and
in nested_copy_vmcb_save_to_cache().

_nested_copy_vmcb_save_to_cache() takes a vmcb_save_area_cached
parameter, useful when we want to save the state to a local
variable instead of svm internals.

Note that in svm_set_nested_state() we want to cache the L2
save state only if we are in normal non guest mode, because
otherwise it is not touched.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 27 ++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c    |  1 +
 arch/x86/kvm/svm/svm.h    | 16 ++++++++++++++++
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 946c06a25d37..ea64fea371c8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -328,6 +328,28 @@ void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
 	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
 }
 
+static void _nested_copy_vmcb_save_to_cache(struct vmcb_save_area_cached *to,
+					    struct vmcb_save_area *from)
+{
+	/*
+	 * Copy only fields that are validated, as we need them
+	 * to avoid TOC/TOU races.
+	 */
+	to->efer = from->efer;
+	to->cr0 = from->cr0;
+	to->cr3 = from->cr3;
+	to->cr4 = from->cr4;
+
+	to->dr6 = from->dr6;
+	to->dr7 = from->dr7;
+}
+
+void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
+				    struct vmcb_save_area *save)
+{
+	_nested_copy_vmcb_save_to_cache(&svm->nested.save, save);
+}
+
 /*
  * Synchronize fields that are written by the processor, so that
  * they can be copied back into the vmcb12.
@@ -670,6 +692,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
+	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 
 	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
 	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
@@ -1402,8 +1425,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	if (is_guest_mode(vcpu))
 		svm_leave_nested(svm);
-	else
+	else {
 		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
+		nested_copy_vmcb_save_to_cache(svm, &svm->nested.vmcb02.ptr->save);
+	}
 
 	svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 21bb81710e0f..6e5c2671e823 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4438,6 +4438,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 
 	vmcb12 = map.hva;
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
+	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 	ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, false);
 
 unmap_save:
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0d7bbe548ac3..0897551d8868 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -103,6 +103,19 @@ struct kvm_vmcb_info {
 	uint64_t asid_generation;
 };
 
+/*
+ * This struct is not kept up-to-date, and it is only valid within
+ * svm_set_nested_state and nested_svm_vmrun.
+ */
+struct vmcb_save_area_cached {
+	u64 efer;
+	u64 cr4;
+	u64 cr3;
+	u64 cr0;
+	u64 dr7;
+	u64 dr6;
+};
+
 struct svm_nested_state {
 	struct kvm_vmcb_info vmcb02;
 	u64 hsave_msr;
@@ -119,6 +132,7 @@ struct svm_nested_state {
 
 	/* cache for control fields of the guest */
 	struct vmcb_control_area ctl;
+	struct vmcb_save_area_cached save;
 
 	bool initialized;
 };
@@ -490,6 +504,8 @@ void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu);
 void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier);
 void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
 				     struct vmcb_control_area *control);
+void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
+				    struct vmcb_save_area *save);
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
 void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
-- 
2.27.0

