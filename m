Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734104E4525
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239684AbiCVR1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239695AbiCVR1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:27:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF4B84B840
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647969930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q8as9H1HZf7aEv/ALL6no45LqVp0BSMxnSHwKmtFgbg=;
        b=ILOGrrv1+X8cI25VD0/vnoYh8eMW9340jP2yoiGCwqTbs7fwSHHs/Sy5evSkR+pg5Z4rAG
        c9aHcERpIbojmf1b063DaESM0wxxEsIf5cHA4ngifgxVSsjsEGdSQMs6Se/8bSzDoBhaAV
        WKC32owZu+x8QKNIlfdGnM76z6/5jpg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-_IGqjONjPyORBbMY1V1xUw-1; Tue, 22 Mar 2022 13:25:28 -0400
X-MC-Unique: _IGqjONjPyORBbMY1V1xUw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB4F3811E78;
        Tue, 22 Mar 2022 17:25:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 991382166B44;
        Tue, 22 Mar 2022 17:25:24 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 7/8] KVM: x86: SVM: fix tsc scaling when the host doesn't support it
Date:   Tue, 22 Mar 2022 19:24:48 +0200
Message-Id: <20220322172449.235575-8-mlevitsk@redhat.com>
In-Reply-To: <20220322172449.235575-1-mlevitsk@redhat.com>
References: <20220322172449.235575-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It was decided that when TSC scaling is not supported,
the virtual MSR_AMD64_TSC_RATIO should still have the default '1.0'
value.

However in this case kvm_max_tsc_scaling_ratio is not set,
which breaks various assumptions.

Fix this by always calculating kvm_max_tsc_scaling_ratio
regardless of host support.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 arch/x86/kvm/vmx/vmx.c | 7 +++----
 arch/x86/kvm/x86.c     | 4 +---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fb31ed01086c..acf04cf4ed2a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4763,10 +4763,10 @@ static __init int svm_hardware_setup(void)
 		} else {
 			pr_info("TSC scaling supported\n");
 			kvm_has_tsc_control = true;
-			kvm_max_tsc_scaling_ratio = SVM_TSC_RATIO_MAX;
-			kvm_tsc_scaling_ratio_frac_bits = 32;
 		}
 	}
+	kvm_max_tsc_scaling_ratio = SVM_TSC_RATIO_MAX;
+	kvm_tsc_scaling_ratio_frac_bits = 32;
 
 	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 84a7500cd80c..e3a311b9ba34 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7980,12 +7980,11 @@ static __init int hardware_setup(void)
 	if (!enable_apicv)
 		vmx_x86_ops.sync_pir_to_irr = NULL;
 
-	if (cpu_has_vmx_tsc_scaling()) {
+	if (cpu_has_vmx_tsc_scaling())
 		kvm_has_tsc_control = true;
-		kvm_max_tsc_scaling_ratio = KVM_VMX_TSC_MULTIPLIER_MAX;
-		kvm_tsc_scaling_ratio_frac_bits = 48;
-	}
 
+	kvm_max_tsc_scaling_ratio = KVM_VMX_TSC_MULTIPLIER_MAX;
+	kvm_tsc_scaling_ratio_frac_bits = 48;
 	kvm_has_bus_lock_exit = cpu_has_vmx_bus_lock_detection();
 
 	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ba920e537ddf..9c27239f987f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11631,10 +11631,8 @@ int kvm_arch_hardware_setup(void *opaque)
 		u64 max = min(0x7fffffffULL,
 			      __scale_tsc(kvm_max_tsc_scaling_ratio, tsc_khz));
 		kvm_max_guest_tsc_khz = max;
-
-		kvm_default_tsc_scaling_ratio = 1ULL << kvm_tsc_scaling_ratio_frac_bits;
 	}
-
+	kvm_default_tsc_scaling_ratio = 1ULL << kvm_tsc_scaling_ratio_frac_bits;
 	kvm_init_msr_list();
 	return 0;
 }
-- 
2.26.3

