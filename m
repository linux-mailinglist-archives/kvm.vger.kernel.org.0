Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348164A6E28
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 10:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245693AbiBBJwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 04:52:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245638AbiBBJwY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 04:52:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643795543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fKKUKbYAx10NZBmqUNI8MqZqdsr2f4RjKNSF3VFdLUk=;
        b=Dq6dVJt7osLqjWP5Zqu5AvxRSLnwmvxdSzVRUCHv2OzmhqJNmgKhbu2mfld2FQOI3ZaqFc
        NdA8axvs2WauuMd9UyxFY6cTL1kV1nfQUE9BemGP9e3MKguYlVXMyI3cUoCpvG5dAZe9sP
        8qZsyXciEj7qFZ/YFZdx8shEhyu/PhY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-8McRE6-iPW-k7kuGaVqgAg-1; Wed, 02 Feb 2022 04:52:22 -0500
X-MC-Unique: 8McRE6-iPW-k7kuGaVqgAg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BBD4363A6;
        Wed,  2 Feb 2022 09:52:21 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DBF1752C8;
        Wed,  2 Feb 2022 09:52:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] KVM: nSVM: Implement Enlightened MSR-Bitmap feature
Date:   Wed,  2 Feb 2022 10:51:00 +0100
Message-Id: <20220202095100.129834-5-vkuznets@redhat.com>
In-Reply-To: <20220202095100.129834-1-vkuznets@redhat.com>
References: <20220202095100.129834-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to nVMX commit 502d2bf5f2fd ("KVM: nVMX: Implement Enlightened MSR
Bitmap feature"), add support for the feature for nSVM (Hyper-V on KVM).

Notable differences from nVMX implementation:
- As the feature uses SW reserved fields in VMCB control, KVM needs to
make sure it's dealing with a Hyper-V guest (kvm_hv_hypercall_enabled()).

- 'msrpm_base_pa' needs to be always be overwritten in
nested_svm_vmrun_msrpm(), even when the update is skipped. As an
optimization, nested_vmcb02_prepare_control() copies it from VMCB01
so when MSR-Bitmap feature for L2 is disabled nothing needs to be done.

- 'struct vmcb_ctrl_area_cached' needs to be extended with clean
fields/sw reserved data and __nested_copy_vmcb_control_to_cache() needs to
copy it so nested_svm_vmrun_msrpm() can use it later.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c     |  7 +------
 arch/x86/kvm/svm/nested.c | 41 ++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.h    |  2 ++
 3 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index ec01ec9992d4..9192b706be58 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2412,10 +2412,6 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 	if (kvm_x86_ops.nested_ops->get_evmcs_version)
 		evmcs_ver = kvm_x86_ops.nested_ops->get_evmcs_version(vcpu);
 
-	/* Skip NESTED_FEATURES if eVMCS is not supported */
-	if (!evmcs_ver)
-		--nent;
-
 	if (cpuid->nent < nent)
 		return -E2BIG;
 
@@ -2515,8 +2511,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 		case HYPERV_CPUID_NESTED_FEATURES:
 			ent->eax = evmcs_ver;
-			if (evmcs_ver)
-				ent->eax |= HV_X64_NESTED_MSR_BITMAP;
+			ent->eax |= HV_X64_NESTED_MSR_BITMAP;
 
 			break;
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f27323728be2..7b26a4b518f7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -28,6 +28,7 @@
 #include "cpuid.h"
 #include "lapic.h"
 #include "svm.h"
+#include "hyperv.h"
 
 #define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
 
@@ -165,14 +166,30 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	vmcb_set_intercept(c, INTERCEPT_VMSAVE);
 }
 
+/*
+ * Merge L0's (KVM) and L1's (Nested VMCB) MSR permission bitmaps. The function
+ * is optimized in that it only merges the parts where KVM MSR permission bitmap
+ * may contain zero bits.
+ */
 static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 {
+	struct hv_enlightenments *hve =
+		(struct hv_enlightenments *)svm->nested.ctl.reserved_sw;
+	int i;
+
 	/*
-	 * This function merges the msr permission bitmaps of kvm and the
-	 * nested vmcb. It is optimized in that it only merges the parts where
-	 * the kvm msr permission bitmap may contain zero bits
+	 * MSR bitmap update can be skipped when:
+	 * - MSR bitmap for L1 hasn't changed.
+	 * - Nested hypervisor (L1) is attempting to launch the same L2 as
+	 *   before.
+	 * - Nested hypervisor (L1) is using Hyper-V emulation interface and
+	 * tells KVM (L0) there were no changes in MSR bitmap for L2.
 	 */
-	int i;
+	if (!svm->nested.force_msr_bitmap_recalc &&
+	    kvm_hv_hypercall_enabled(&svm->vcpu) &&
+	    hve->hv_enlightenments_control.msr_bitmap &&
+	    (svm->nested.ctl.clean & VMCB_HV_NESTED_ENLIGHTENMENTS))
+		goto set_msrpm_base_pa;
 
 	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
 		return true;
@@ -195,6 +212,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 
 	svm->nested.force_msr_bitmap_recalc = false;
 
+set_msrpm_base_pa:
 	svm->vmcb->control.msrpm_base_pa = __sme_set(__pa(svm->nested.msrpm));
 
 	return true;
@@ -300,7 +318,8 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
 }
 
 static
-void __nested_copy_vmcb_control_to_cache(struct vmcb_ctrl_area_cached *to,
+void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
+					 struct vmcb_ctrl_area_cached *to,
 					 struct vmcb_control_area *from)
 {
 	unsigned int i;
@@ -333,12 +352,19 @@ void __nested_copy_vmcb_control_to_cache(struct vmcb_ctrl_area_cached *to,
 	to->asid           = from->asid;
 	to->msrpm_base_pa &= ~0x0fffULL;
 	to->iopm_base_pa  &= ~0x0fffULL;
+
+	/* Hyper-V extensions (Enlightened VMCB) */
+	if (kvm_hv_hypercall_enabled(vcpu)) {
+		to->clean = from->clean;
+		memcpy(to->reserved_sw, from->reserved_sw,
+		       sizeof(struct hv_enlightenments));
+	}
 }
 
 void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
 				       struct vmcb_control_area *control)
 {
-	__nested_copy_vmcb_control_to_cache(&svm->nested.ctl, control);
+	__nested_copy_vmcb_control_to_cache(&svm->vcpu, &svm->nested.ctl, control);
 }
 
 static void __nested_copy_vmcb_save_to_cache(struct vmcb_save_area_cached *to,
@@ -1305,6 +1331,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->virt_ext              = from->virt_ext;
 	dst->pause_filter_count   = from->pause_filter_count;
 	dst->pause_filter_thresh  = from->pause_filter_thresh;
+	/* 'clean' and 'reserved_sw' are not changed by KVM */
 }
 
 static int svm_get_nested_state(struct kvm_vcpu *vcpu,
@@ -1437,7 +1464,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		goto out_free;
 
 	ret = -EINVAL;
-	__nested_copy_vmcb_control_to_cache(&ctl_cached, ctl);
+	__nested_copy_vmcb_control_to_cache(vcpu, &ctl_cached, ctl);
 	if (!__nested_vmcb_check_controls(vcpu, &ctl_cached))
 		goto out_free;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 92fc4f554634..96473ecb2c6e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -137,6 +137,8 @@ struct vmcb_ctrl_area_cached {
 	u32 event_inj_err;
 	u64 nested_cr3;
 	u64 virt_ext;
+	u32 clean;
+	u8 reserved_sw[32];
 };
 
 struct svm_nested_state {
-- 
2.34.1

