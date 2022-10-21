Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84AC0607AD6
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 17:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiJUPfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 11:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiJUPfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 11:35:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA96625CDA7
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666366530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vDjvgcJfnv+LNcb8j5LXRNfVJkiFIB3wM6wCj7P711Y=;
        b=Z0H+NEUhfC5gl+oXgn/WP+QqUNfCyCaHgaCjF885106pWa6z7PTFh4oAZOA0zVJ8U2U1sR
        zdLzsuqcn3O+b08PnQBoTBIkgXb6WUdyX0PZ1RrcgnyTGuFvDoRvbu2Y6UqJoKAesrW1Hk
        JtZQ4A2RlBQHHhT/4EwTspPzWLv8gBg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-fk4iCBFxMwiV2bLReFfjwQ-1; Fri, 21 Oct 2022 11:35:29 -0400
X-MC-Unique: fk4iCBFxMwiV2bLReFfjwQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1939F1C06911;
        Fri, 21 Oct 2022 15:35:29 +0000 (UTC)
Received: from ovpn-192-65.brq.redhat.com (ovpn-192-65.brq.redhat.com [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D48E540CA41F;
        Fri, 21 Oct 2022 15:35:25 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 01/46] x86/hyperv: Move VMCB enlightenment definitions to hyperv-tlfs.h
Date:   Fri, 21 Oct 2022 17:34:36 +0200
Message-Id: <20221021153521.1216911-2-vkuznets@redhat.com>
In-Reply-To: <20221021153521.1216911-1-vkuznets@redhat.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Move Hyper-V's VMCB enlightenment definitions to the TLFS header; the
definitions come directly from the TLFS[*], not from KVM.

No functional change intended.

[*] https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/datatypes/hv_svm_enlightened_vmcb_fields

Signed-off-by: Sean Christopherson <seanjc@google.com>
[vitaly: rename VMCB_HV_ -> HV_VMCB_ to match the rest of
hyperv-tlfs.h, keep svm/hyperv.h]
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/hyperv-tlfs.h            | 22 +++++++++++++++++++
 arch/x86/kvm/svm/hyperv.h                     | 22 -------------------
 arch/x86/kvm/svm/nested.c                     |  2 +-
 arch/x86/kvm/svm/svm_onhyperv.c               |  2 +-
 arch/x86/kvm/svm/svm_onhyperv.h               |  4 ++--
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |  6 ++---
 6 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 3089ec352743..245a806a9717 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -598,6 +598,28 @@ struct hv_enlightened_vmcs {
 
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL			0xFFFF
 
+/*
+ * Hyper-V uses the software reserved 32 bytes in VMCB control area to expose
+ * SVM enlightenments to guests.
+ */
+struct hv_enlightenments {
+	struct __packed hv_enlightenments_control {
+		u32 nested_flush_hypercall:1;
+		u32 msr_bitmap:1;
+		u32 enlightened_npt_tlb: 1;
+		u32 reserved:29;
+	} __packed hv_enlightenments_control;
+	u32 hv_vp_id;
+	u64 hv_vm_id;
+	u64 partition_assist_page;
+	u64 reserved;
+} __packed;
+
+/*
+ * Hyper-V uses the software reserved clean bit in VMCB.
+ */
+#define HV_VMCB_NESTED_ENLIGHTENMENTS		31
+
 struct hv_partition_assist_pg {
 	u32 tlb_lock_count;
 };
diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
index 7d6d97968fb9..c59544cdf03b 100644
--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -10,26 +10,4 @@
 
 #include "../hyperv.h"
 
-/*
- * Hyper-V uses the software reserved 32 bytes in VMCB
- * control area to expose SVM enlightenments to guests.
- */
-struct hv_enlightenments {
-	struct __packed hv_enlightenments_control {
-		u32 nested_flush_hypercall:1;
-		u32 msr_bitmap:1;
-		u32 enlightened_npt_tlb: 1;
-		u32 reserved:29;
-	} __packed hv_enlightenments_control;
-	u32 hv_vp_id;
-	u64 hv_vm_id;
-	u64 partition_assist_page;
-	u64 reserved;
-} __packed;
-
-/*
- * Hyper-V uses the software reserved clean bit in VMCB
- */
-#define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
-
 #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 4c620999d230..3131c4476b7b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -194,7 +194,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	if (!svm->nested.force_msr_bitmap_recalc &&
 	    kvm_hv_hypercall_enabled(&svm->vcpu) &&
 	    hve->hv_enlightenments_control.msr_bitmap &&
-	    (svm->nested.ctl.clean & BIT(VMCB_HV_NESTED_ENLIGHTENMENTS)))
+	    (svm->nested.ctl.clean & BIT(HV_VMCB_NESTED_ENLIGHTENMENTS)))
 		goto set_msrpm_base_pa;
 
 	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 8cdc62c74a96..ed5e79392544 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -32,7 +32,7 @@ int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 	hve->hv_vm_id = (unsigned long)vcpu->kvm;
 	if (!hve->hv_enlightenments_control.nested_flush_hypercall) {
 		hve->hv_enlightenments_control.nested_flush_hypercall = 1;
-		vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
+		vmcb_mark_dirty(to_svm(vcpu)->vmcb, HV_VMCB_NESTED_ENLIGHTENMENTS);
 	}
 
 	return 0;
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index e2fc59380465..66e61a73caeb 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -64,7 +64,7 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
 		(struct hv_enlightenments *)vmcb->control.reserved_sw;
 
 	if (hve->hv_enlightenments_control.msr_bitmap)
-		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
+		vmcb_mark_dirty(vmcb, HV_VMCB_NESTED_ENLIGHTENMENTS);
 }
 
 static inline void svm_hv_update_vp_id(struct vmcb *vmcb,
@@ -76,7 +76,7 @@ static inline void svm_hv_update_vp_id(struct vmcb *vmcb,
 
 	if (hve->hv_vp_id != vp_index) {
 		hve->hv_vp_id = vp_index;
-		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
+		vmcb_mark_dirty(vmcb, HV_VMCB_NESTED_ENLIGHTENMENTS);
 	}
 }
 #else
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index a380ad7bb9b3..5060fcfe1760 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -39,7 +39,7 @@ struct hv_enlightenments {
 /*
  * Hyper-V uses the software reserved clean bit in VMCB
  */
-#define VMCB_HV_NESTED_ENLIGHTENMENTS (1U << 31)
+#define HV_VMCB_NESTED_ENLIGHTENMENTS (1U << 31)
 
 void l2_guest_code(void)
 {
@@ -98,14 +98,14 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
 	/* Intercept RDMSR 0xc0000101 without telling KVM about it */
 	set_bit(2 * (MSR_GS_BASE & 0x1fff), svm->msr + 0x800);
 	/* Make sure HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP is set */
-	vmcb->control.clean |= VMCB_HV_NESTED_ENLIGHTENMENTS;
+	vmcb->control.clean |= HV_VMCB_NESTED_ENLIGHTENMENTS;
 	run_guest(vmcb, svm->vmcb_gpa);
 	/* Make sure we don't see SVM_EXIT_MSR here so eMSR bitmap works */
 	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
 	vmcb->save.rip += 3; /* vmcall */
 
 	/* Now tell KVM we've changed MSR-Bitmap */
-	vmcb->control.clean &= ~VMCB_HV_NESTED_ENLIGHTENMENTS;
+	vmcb->control.clean &= ~HV_VMCB_NESTED_ENLIGHTENMENTS;
 	run_guest(vmcb, svm->vmcb_gpa);
 	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
 	vmcb->save.rip += 2; /* rdmsr */
-- 
2.37.3

