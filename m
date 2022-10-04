Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321285F430E
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 14:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiJDMk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 08:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiJDMkR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 08:40:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9597B17059
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 05:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664887212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=weUMpV8rLBIJE19g/7rH1MfNP/dxn0LjcTdx888tsxY=;
        b=caU4nuGckfk3Xlymtl3fC+CQuiTpaFUA/HkX3hzeCN34F36x1+0Qo0HfQyb0GmPmgZtGx0
        U+Eelw/SNrtcOImzEdDRUHkK60JfnHZ9f0WBCH4y5nYefWTmeqXFWVD3BsqxTFUhM+/Uu8
        QobCPHMnueg05oUNKb9a/fRTYcCscP4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-chHafl9vNS2rHQdJ6WuF-w-1; Tue, 04 Oct 2022 08:40:09 -0400
X-MC-Unique: chHafl9vNS2rHQdJ6WuF-w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4B89858282;
        Tue,  4 Oct 2022 12:40:08 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4030A7AE5;
        Tue,  4 Oct 2022 12:40:06 +0000 (UTC)
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
Subject: [PATCH v11 03/46] KVM: SVM: Add a proper field for Hyper-V VMCB enlightenments
Date:   Tue,  4 Oct 2022 14:39:13 +0200
Message-Id: <20221004123956.188909-4-vkuznets@redhat.com>
In-Reply-To: <20221004123956.188909-1-vkuznets@redhat.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Add a union to provide hv_enlightenments side-by-side with the sw_reserved
bytes that Hyper-V's enlightenments overlay.  Casting sw_reserved
everywhere is messy, confusing, and unnecessarily unsafe.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/svm.h                        |  7 ++++++-
 arch/x86/kvm/svm/nested.c                         |  9 ++++-----
 arch/x86/kvm/svm/svm.h                            |  5 ++++-
 arch/x86/kvm/svm/svm_onhyperv.c                   |  2 +-
 arch/x86/kvm/svm/svm_onhyperv.h                   | 15 +++++++--------
 tools/testing/selftests/kvm/include/x86_64/svm.h  |  5 ++++-
 .../selftests/kvm/x86_64/hyperv_svm_test.c        |  3 +--
 7 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 0361626841bc..6befed2b30a6 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -5,6 +5,8 @@
 #include <uapi/asm/svm.h>
 #include <uapi/asm/kvm.h>
 
+#include <asm/hyperv-tlfs.h>
+
 /*
  * 32-bit intercept words in the VMCB Control Area, starting
  * at Byte offset 000h.
@@ -161,7 +163,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	 * Offset 0x3e0, 32 bytes reserved
 	 * for use by hypervisor/software.
 	 */
-	u8 reserved_sw[32];
+	union {
+		struct hv_enlightenments hv_enlightenments;
+		u8 reserved_sw[32];
+	};
 };
 
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3131c4476b7b..c8e967f6cafe 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -179,8 +179,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
  */
 static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 {
-	struct hv_enlightenments *hve =
-		(struct hv_enlightenments *)svm->nested.ctl.reserved_sw;
+	struct hv_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
 	int i;
 
 	/*
@@ -369,8 +368,8 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	/* Hyper-V extensions (Enlightened VMCB) */
 	if (kvm_hv_hypercall_enabled(vcpu)) {
 		to->clean = from->clean;
-		memcpy(to->reserved_sw, from->reserved_sw,
-		       sizeof(struct hv_enlightenments));
+		memcpy(&to->hv_enlightenments, &from->hv_enlightenments,
+		       sizeof(to->hv_enlightenments));
 	}
 }
 
@@ -1479,7 +1478,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->virt_ext              = from->virt_ext;
 	dst->pause_filter_count   = from->pause_filter_count;
 	dst->pause_filter_thresh  = from->pause_filter_thresh;
-	/* 'clean' and 'reserved_sw' are not changed by KVM */
+	/* 'clean' and 'hv_enlightenments' are not changed by KVM */
 }
 
 static int svm_get_nested_state(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6a7686bf6900..9eb2fc76732f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -151,7 +151,10 @@ struct vmcb_ctrl_area_cached {
 	u64 nested_cr3;
 	u64 virt_ext;
 	u32 clean;
-	u8 reserved_sw[32];
+	union {
+		struct hv_enlightenments hv_enlightenments;
+		u8 reserved_sw[32];
+	};
 };
 
 struct svm_nested_state {
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index ed5e79392544..422d00fee24a 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -26,7 +26,7 @@ int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 	if (!*p_hv_pa_pg)
 		return -ENOMEM;
 
-	hve = (struct hv_enlightenments *)to_svm(vcpu)->vmcb->control.reserved_sw;
+	hve = &to_svm(vcpu)->vmcb->control.hv_enlightenments;
 
 	hve->partition_assist_page = __pa(*p_hv_pa_pg);
 	hve->hv_vm_id = (unsigned long)vcpu->kvm;
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index 66e61a73caeb..5c664dd7bee2 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -17,8 +17,10 @@ int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu);
 
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
-	struct hv_enlightenments *hve =
-		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
+
+	BUILD_BUG_ON(sizeof(vmcb->control.hv_enlightenments) !=
+		     sizeof(vmcb->control.reserved_sw));
 
 	if (npt_enabled &&
 	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)
@@ -60,18 +62,15 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
 		struct kvm_vcpu *vcpu)
 {
 	struct vmcb *vmcb = to_svm(vcpu)->vmcb;
-	struct hv_enlightenments *hve =
-		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
 
 	if (hve->hv_enlightenments_control.msr_bitmap)
 		vmcb_mark_dirty(vmcb, HV_VMCB_NESTED_ENLIGHTENMENTS);
 }
 
-static inline void svm_hv_update_vp_id(struct vmcb *vmcb,
-		struct kvm_vcpu *vcpu)
+static inline void svm_hv_update_vp_id(struct vmcb *vmcb, struct kvm_vcpu *vcpu)
 {
-	struct hv_enlightenments *hve =
-		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
 	u32 vp_index = kvm_hv_get_vpindex(vcpu);
 
 	if (hve->hv_vp_id != vp_index) {
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm.h b/tools/testing/selftests/kvm/include/x86_64/svm.h
index 89ce2c6b57fe..6e1527aa3419 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm.h
@@ -123,7 +123,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	 * Offset 0x3e0, 32 bytes reserved
 	 * for use by hypervisor/software.
 	 */
-	u8 reserved_sw[32];
+	union {
+		struct hv_enlightenments hv_enlightenments;
+		u8 reserved_sw[32];
+	};
 };
 
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index 2fd64b419928..8ef6a4c83cb1 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -46,8 +46,7 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
 {
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	struct vmcb *vmcb = svm->vmcb;
-	struct hv_enlightenments *hve =
-		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
 
 	GUEST_SYNC(1);
 
-- 
2.37.3

