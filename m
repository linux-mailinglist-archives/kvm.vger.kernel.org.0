Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF5E4E4518
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239679AbiCVR1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239654AbiCVR1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:27:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD0924A917
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647969924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ljE1Q1pDWFeHEafcYaJmat1sJuOoQ7xxJXxrlZIWhVE=;
        b=WTxzQ5dV3A6y6Gxlw6lgSnm/baOWT/lRjWRAixhalTkWXjC79HR6lYjuUPeJ7saotFUrbi
        SKmhgwpwjtqdMBipQ3dI1nmsGJKBMxnQfvNqgkkN4HG3yzFdXxN25Uwg4YAW6yBImb69ll
        jG0MW7hJrsYaywHZ+OTRcqOSyjepano=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-5yc3rfuCN3GmkPs4NLhyDA-1; Tue, 22 Mar 2022 13:25:21 -0400
X-MC-Unique: 5yc3rfuCN3GmkPs4NLhyDA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A2FD1C05B0C;
        Tue, 22 Mar 2022 17:25:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3557C2166B2D;
        Tue, 22 Mar 2022 17:25:17 +0000 (UTC)
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
Subject: [PATCH 5/8] KVM: x86: SVM: move tsc ratio definitions to svm.h
Date:   Tue, 22 Mar 2022 19:24:46 +0200
Message-Id: <20220322172449.235575-6-mlevitsk@redhat.com>
In-Reply-To: <20220322172449.235575-1-mlevitsk@redhat.com>
References: <20220322172449.235575-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Another piece of SVM spec which should be in the header file

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/svm.h |  6 ++++++
 arch/x86/kvm/svm/svm.c     | 15 +++++----------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ab572d8def2b..f70a5108d464 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -221,6 +221,12 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
 
 
+#define SVM_TSC_RATIO_RSVD	0xffffff0000000000ULL
+#define SVM_TSC_RATIO_MIN	0x0000000000000001ULL
+#define SVM_TSC_RATIO_MAX	0x000000ffffffffffULL
+#define SVM_TSC_RATIO_DEFAULT	0x0100000000ULL
+
+
 /* AVIC */
 #define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFFULL)
 #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e9a5c1e80889..ea3f0b2605e5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -72,10 +72,6 @@ MODULE_DEVICE_TABLE(x86cpu, svm_cpu_id);
 
 #define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
 
-#define TSC_RATIO_RSVD          0xffffff0000000000ULL
-#define TSC_RATIO_MIN		0x0000000000000001ULL
-#define TSC_RATIO_MAX		0x000000ffffffffffULL
-
 static bool erratum_383_found __read_mostly;
 
 u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
@@ -87,7 +83,6 @@ u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 static uint64_t osvw_len = 4, osvw_status;
 
 static DEFINE_PER_CPU(u64, current_tsc_ratio);
-#define TSC_RATIO_DEFAULT	0x0100000000ULL
 
 static const struct svm_direct_access_msrs {
 	u32 index;   /* Index of the MSR */
@@ -483,7 +478,7 @@ static void svm_hardware_disable(void)
 {
 	/* Make sure we clean up behind us */
 	if (tsc_scaling)
-		wrmsrl(MSR_AMD64_TSC_RATIO, TSC_RATIO_DEFAULT);
+		wrmsrl(MSR_AMD64_TSC_RATIO, SVM_TSC_RATIO_DEFAULT);
 
 	cpu_svm_disable();
 
@@ -529,8 +524,8 @@ static int svm_hardware_enable(void)
 		 * Set the default value, even if we don't use TSC scaling
 		 * to avoid having stale value in the msr
 		 */
-		wrmsrl(MSR_AMD64_TSC_RATIO, TSC_RATIO_DEFAULT);
-		__this_cpu_write(current_tsc_ratio, TSC_RATIO_DEFAULT);
+		wrmsrl(MSR_AMD64_TSC_RATIO, SVM_TSC_RATIO_DEFAULT);
+		__this_cpu_write(current_tsc_ratio, SVM_TSC_RATIO_DEFAULT);
 	}
 
 
@@ -2729,7 +2724,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			break;
 		}
 
-		if (data & TSC_RATIO_RSVD)
+		if (data & SVM_TSC_RATIO_RSVD)
 			return 1;
 
 		svm->tsc_ratio_msr = data;
@@ -4776,7 +4771,7 @@ static __init int svm_hardware_setup(void)
 		} else {
 			pr_info("TSC scaling supported\n");
 			kvm_has_tsc_control = true;
-			kvm_max_tsc_scaling_ratio = TSC_RATIO_MAX;
+			kvm_max_tsc_scaling_ratio = SVM_TSC_RATIO_MAX;
 			kvm_tsc_scaling_ratio_frac_bits = 32;
 		}
 	}
-- 
2.26.3

