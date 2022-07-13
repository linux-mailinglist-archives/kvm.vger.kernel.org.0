Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235695739B1
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 17:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbiGMPGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 11:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236889AbiGMPGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 11:06:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 658A84AD51
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 08:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657724751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wt6TibhmG/TacD1oT2u3w+WDpsmGT8tGDLJapcaM0D4=;
        b=Fy+1jrOSZp/bcXwz8hOtRGPUtZOMC+DNZOtnUWxLTCaIOrI5BaOfpaVhFgLm2Ls8rj8/Mm
        44SUYaYtRPdwPVsjjGc38OzxcAoPBVPhqoOfe+RAjNVjna2aPdLXxEf2Jlk1JMmfE1TwzC
        QMFn3IvF8FC0Xx6tOfmtDvH7XN6VWjU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-SyrsVqpOMRSbE8z4WARQrA-1; Wed, 13 Jul 2022 11:05:48 -0400
X-MC-Unique: SyrsVqpOMRSbE8z4WARQrA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3DBF3817A81;
        Wed, 13 Jul 2022 15:05:39 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CA42492C3B;
        Wed, 13 Jul 2022 15:05:38 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: selftests: Test Hyper-V invariant TSC control
Date:   Wed, 13 Jul 2022 17:05:32 +0200
Message-Id: <20220713150532.1012466-4-vkuznets@redhat.com>
In-Reply-To: <20220713150532.1012466-1-vkuznets@redhat.com>
References: <20220713150532.1012466-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test for the newly introduced Hyper-V invariant TSC control feature:
- HV_X64_MSR_TSC_INVARIANT_CONTROL is not available without
 HV_ACCESS_TSC_INVARIANT CPUID bit set and available with it.
- BIT(0) of HV_X64_MSR_TSC_INVARIANT_CONTROL controls the filtering of
architectural invariant TSC (CPUID.80000007H:EDX[8]) bit.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/hyperv_features.c    | 73 ++++++++++++++++++-
 1 file changed, 69 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index c05acd78548f..9599eecdedff 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -15,6 +15,9 @@
 
 #define LINUX_OS_ID ((u64)0x8100 << 48)
 
+/* CPUID.80000007H:EDX */
+#define X86_FEATURE_INVTSC (1 << 8)
+
 static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
 				vm_vaddr_t output_address, uint64_t *hv_status)
 {
@@ -60,6 +63,24 @@ static void guest_msr(struct msr_data *msr)
 		GUEST_ASSERT_2(!vector, msr->idx, vector);
 	else
 		GUEST_ASSERT_2(vector == GP_VECTOR, msr->idx, vector);
+
+	/* Invariant TSC bit appears when TSC invariant control MSR is written to */
+	if (msr->idx == HV_X64_MSR_TSC_INVARIANT_CONTROL) {
+		u32 eax = 0x80000007, ebx = 0, ecx = 0, edx = 0;
+
+		cpuid(&eax, &ebx, &ecx, &edx);
+
+		/*
+		 * TSC invariant bit is present without the feature (legacy) or
+		 * when the feature is present and enabled.
+		 */
+		if ((!msr->available && !msr->write) || (msr->write && msr->write_val == 1))
+			GUEST_ASSERT(edx & X86_FEATURE_INVTSC);
+		else
+			GUEST_ASSERT(!(edx & X86_FEATURE_INVTSC));
+	}
+
+
 	GUEST_DONE();
 }
 
@@ -105,6 +126,15 @@ static void hv_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 	vcpu_set_cpuid(vcpu, cpuid);
 }
 
+static bool guest_has_invtsc(void)
+{
+	struct kvm_cpuid_entry2 *cpuid;
+
+	cpuid = kvm_get_supported_cpuid_entry(0x80000007);
+
+	return cpuid->edx & X86_FEATURE_INVTSC;
+}
+
 static void guest_test_msrs_access(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -124,6 +154,7 @@ static void guest_test_msrs_access(void)
 	struct kvm_cpuid2 *best;
 	vm_vaddr_t msr_gva;
 	struct msr_data *msr;
+	bool has_invtsc = guest_has_invtsc();
 
 	while (true) {
 		vm = vm_create_with_one_vcpu(&vcpu, guest_msr);
@@ -136,8 +167,7 @@ static void guest_test_msrs_access(void)
 		vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
 
 		vcpu_set_hv_cpuid(vcpu);
-
-		best = kvm_get_supported_hv_cpuid();
+		best = vcpu_get_cpuid(vcpu);
 
 		vm_init_descriptor_tables(vm);
 		vcpu_init_descriptor_tables(vcpu);
@@ -431,6 +461,42 @@ static void guest_test_msrs_access(void)
 			break;
 
 		case 44:
+			/* MSR is not available when CPUID feature bit is unset */
+			if (!has_invtsc)
+				continue;
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = 0;
+			msr->available = 0;
+			break;
+		case 45:
+			/* MSR is vailable when CPUID feature bit is set */
+			if (!has_invtsc)
+				continue;
+			feat.eax |= HV_ACCESS_TSC_INVARIANT;
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = 0;
+			msr->available = 1;
+			break;
+		case 46:
+			/* Writing bits other than 0 is forbidden */
+			if (!has_invtsc)
+				continue;
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = 1;
+			msr->write_val = 0xdeadbeef;
+			msr->available = 0;
+			break;
+		case 47:
+			/* Setting bit 0 enables the feature */
+			if (!has_invtsc)
+				continue;
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = 1;
+			msr->write_val = 1;
+			msr->available = 1;
+			break;
+
+		default:
 			kvm_vm_free(vm);
 			return;
 		}
@@ -502,8 +568,7 @@ static void guest_test_hcalls_access(void)
 		vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
 
 		vcpu_set_hv_cpuid(vcpu);
-
-		best = kvm_get_supported_hv_cpuid();
+		best = vcpu_get_cpuid(vcpu);
 
 		run = vcpu->run;
 
-- 
2.35.3

