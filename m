Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4428444306
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 15:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhKCOJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 10:09:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38769 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231924AbhKCOJF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 10:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635948388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GGrbkw3XhYbk2WgucA5MfHN0RoVuv/MUJyMftyX4yCg=;
        b=SIrJn6EHSs/DJUH7XJbHwReT1/4fcp5duUHrPQ/DERv2BQuvoHIyXAGnq1SaQzBRVlxscn
        TX/nvt1UT+P6fgcUN1pdVZAU/U7Dx5ldZ8I4luws3Ehr2j4cYLBvYYv0UgY1OT9yoZcCid
        7PbWtbTuBJX1bgMjm89gYDltlYhv5tg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193--yq-WoSaOu2AXY9W8xJSSA-1; Wed, 03 Nov 2021 10:06:24 -0400
X-MC-Unique: -yq-WoSaOu2AXY9W8xJSSA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FCDD806688;
        Wed,  3 Nov 2021 14:06:22 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9345D100239F;
        Wed,  3 Nov 2021 14:06:21 +0000 (UTC)
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
Subject: [PATCH v5 3/7] nSVM: rename nested_load_control_from_vmcb12 in nested_copy_vmcb_control_to_cache
Date:   Wed,  3 Nov 2021 10:05:23 -0400
Message-Id: <20211103140527.752797-4-eesposit@redhat.com>
In-Reply-To: <20211103140527.752797-1-eesposit@redhat.com>
References: <20211103140527.752797-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Following the same naming convention of the previous patch,
rename nested_load_control_from_vmcb12.
In addition, inline copy_vmcb_control_area as it is only called
by this function.

_nested_copy_vmcb_control_to_cache() works with vmcb_control_area
parameters and it will be useful in next patches, when we use
local variables instead of svm cached state.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 80 +++++++++++++++++++--------------------
 arch/x86/kvm/svm/svm.c    |  2 +-
 arch/x86/kvm/svm/svm.h    |  4 +-
 3 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ea64fea371c8..162b338a6c74 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -163,37 +163,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	vmcb_set_intercept(c, INTERCEPT_VMSAVE);
 }
 
-static void copy_vmcb_control_area(struct vmcb_control_area *dst,
-				   struct vmcb_control_area *from)
-{
-	unsigned int i;
-
-	for (i = 0; i < MAX_INTERCEPT; i++)
-		dst->intercepts[i] = from->intercepts[i];
-
-	dst->iopm_base_pa         = from->iopm_base_pa;
-	dst->msrpm_base_pa        = from->msrpm_base_pa;
-	dst->tsc_offset           = from->tsc_offset;
-	/* asid not copied, it is handled manually for svm->vmcb.  */
-	dst->tlb_ctl              = from->tlb_ctl;
-	dst->int_ctl              = from->int_ctl;
-	dst->int_vector           = from->int_vector;
-	dst->int_state            = from->int_state;
-	dst->exit_code            = from->exit_code;
-	dst->exit_code_hi         = from->exit_code_hi;
-	dst->exit_info_1          = from->exit_info_1;
-	dst->exit_info_2          = from->exit_info_2;
-	dst->exit_int_info        = from->exit_int_info;
-	dst->exit_int_info_err    = from->exit_int_info_err;
-	dst->nested_ctl           = from->nested_ctl;
-	dst->event_inj            = from->event_inj;
-	dst->event_inj_err        = from->event_inj_err;
-	dst->nested_cr3           = from->nested_cr3;
-	dst->virt_ext              = from->virt_ext;
-	dst->pause_filter_count   = from->pause_filter_count;
-	dst->pause_filter_thresh  = from->pause_filter_thresh;
-}
-
 static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 {
 	/*
@@ -317,15 +286,46 @@ static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
-				     struct vmcb_control_area *control)
+static
+void _nested_copy_vmcb_control_to_cache(struct vmcb_control_area *to,
+					struct vmcb_control_area *from)
 {
-	copy_vmcb_control_area(&svm->nested.ctl, control);
+	unsigned int i;
+
+	for (i = 0; i < MAX_INTERCEPT; i++)
+		to->intercepts[i] = from->intercepts[i];
+
+	to->iopm_base_pa        = from->iopm_base_pa;
+	to->msrpm_base_pa       = from->msrpm_base_pa;
+	to->tsc_offset          = from->tsc_offset;
+	to->tlb_ctl             = from->tlb_ctl;
+	to->int_ctl             = from->int_ctl;
+	to->int_vector          = from->int_vector;
+	to->int_state           = from->int_state;
+	to->exit_code           = from->exit_code;
+	to->exit_code_hi        = from->exit_code_hi;
+	to->exit_info_1         = from->exit_info_1;
+	to->exit_info_2         = from->exit_info_2;
+	to->exit_int_info       = from->exit_int_info;
+	to->exit_int_info_err   = from->exit_int_info_err;
+	to->nested_ctl          = from->nested_ctl;
+	to->event_inj           = from->event_inj;
+	to->event_inj_err       = from->event_inj_err;
+	to->nested_cr3          = from->nested_cr3;
+	to->virt_ext            = from->virt_ext;
+	to->pause_filter_count  = from->pause_filter_count;
+	to->pause_filter_thresh = from->pause_filter_thresh;
+
+	/* Copy asid here because nested_vmcb_check_controls will check it.  */
+	to->asid           = from->asid;
+	to->msrpm_base_pa &= ~0x0fffULL;
+	to->iopm_base_pa  &= ~0x0fffULL;
+}
 
-	/* Copy it here because nested_svm_check_controls will check it.  */
-	svm->nested.ctl.asid           = control->asid;
-	svm->nested.ctl.msrpm_base_pa &= ~0x0fffULL;
-	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
+void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
+				       struct vmcb_control_area *control)
+{
+	_nested_copy_vmcb_control_to_cache(&svm->nested.ctl, control);
 }
 
 static void _nested_copy_vmcb_save_to_cache(struct vmcb_save_area_cached *to,
@@ -691,7 +691,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(!svm->nested.initialized))
 		return -EINVAL;
 
-	nested_load_control_from_vmcb12(svm, &vmcb12->control);
+	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 
 	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
@@ -1438,7 +1438,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
 
 	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, save);
-	nested_load_control_from_vmcb12(svm, ctl);
+	nested_copy_vmcb_control_to_cache(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_vmcb02_prepare_control(svm);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6e5c2671e823..74d6db9017ea 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4437,7 +4437,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	 */
 
 	vmcb12 = map.hva;
-	nested_load_control_from_vmcb12(svm, &vmcb12->control);
+	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 	ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, false);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0897551d8868..a0609fe2e68c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -502,8 +502,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 int nested_svm_exit_special(struct vcpu_svm *svm);
 void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu);
 void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier);
-void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
-				     struct vmcb_control_area *control);
+void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
+				       struct vmcb_control_area *control);
 void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
 				    struct vmcb_save_area *save);
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
-- 
2.27.0

