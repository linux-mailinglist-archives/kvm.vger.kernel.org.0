Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F175A796B
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiHaIuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiHaIu2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:50:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FA2AB19E
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 01:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661935823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XHyUtmZKTvqRsLyAaBPYNj0r2rPPf5NCNaNATfvyTPs=;
        b=DdT74hKkZBZ+I4fV5xLSJJDiSKmR7BeZBaLDEluhGYgv1q4/HvLWNby7RSbD8W2Mpnn+rn
        ScZOeOZWRpuRtsJPQRUJzM2w/cAvQ4K41oW7YFQBkv08KDroPuvgBgrM71ELEqwvM9me++
        n7yIcxUuUQx9gWtw6t7avf1c5wi4wJU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-pEGGZMsOM7aC1VteFWclbQ-1; Wed, 31 Aug 2022 04:50:20 -0400
X-MC-Unique: pEGGZMsOM7aC1VteFWclbQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C131580A0B7;
        Wed, 31 Aug 2022 08:50:19 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B264FC15BB3;
        Wed, 31 Aug 2022 08:50:17 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] KVM: selftests: Test Hyper-V invariant TSC control
Date:   Wed, 31 Aug 2022 10:50:09 +0200
Message-Id: <20220831085009.1627523-4-vkuznets@redhat.com>
In-Reply-To: <20220831085009.1627523-1-vkuznets@redhat.com>
References: <20220831085009.1627523-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
 .../selftests/kvm/x86_64/hyperv_features.c    | 67 +++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 4ec4776662a4..26e8c5f7677e 100644
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
+		u32 eax, ebx, ecx, edx;
+
+		cpuid(0x80000007, &eax, &ebx, &ecx, &edx);
+
+		/*
+		 * TSC invariant bit is present without the feature (legacy) or
+		 * when the feature is present and enabled.
+		 */
+		if ((!msr->should_not_gp && !msr->write) || (msr->write && msr->write_val == 1))
+			GUEST_ASSERT(edx & X86_FEATURE_INVTSC);
+		else
+			GUEST_ASSERT(!(edx & X86_FEATURE_INVTSC));
+	}
+
+
 	GUEST_DONE();
 }
 
@@ -104,6 +125,15 @@ static void vcpu_reset_hv_cpuid(struct kvm_vcpu *vcpu)
 	vcpu_clear_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES);
 }
 
+static bool guest_has_invtsc(void)
+{
+	const struct kvm_cpuid_entry2 *cpuid;
+
+	cpuid = kvm_get_supported_cpuid_entry(0x80000007);
+
+	return cpuid->edx & X86_FEATURE_INVTSC;
+}
+
 static void guest_test_msrs_access(void)
 {
 	struct kvm_cpuid2 *prev_cpuid = NULL;
@@ -115,6 +145,7 @@ static void guest_test_msrs_access(void)
 	int stage = 0;
 	vm_vaddr_t msr_gva;
 	struct msr_data *msr;
+	bool has_invtsc = guest_has_invtsc();
 
 	while (true) {
 		vm = vm_create_with_one_vcpu(&vcpu, guest_msr);
@@ -429,6 +460,42 @@ static void guest_test_msrs_access(void)
 			break;
 
 		case 44:
+			/* MSR is not available when CPUID feature bit is unset */
+			if (!has_invtsc)
+				continue;
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = 0;
+			msr->should_not_gp = 0;
+			break;
+		case 45:
+			/* MSR is vailable when CPUID feature bit is set */
+			if (!has_invtsc)
+				continue;
+			feat->eax |= HV_ACCESS_TSC_INVARIANT;
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = 0;
+			msr->should_not_gp = 1;
+			break;
+		case 46:
+			/* Writing bits other than 0 is forbidden */
+			if (!has_invtsc)
+				continue;
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = 1;
+			msr->write_val = 0xdeadbeef;
+			msr->should_not_gp = 0;
+			break;
+		case 47:
+			/* Setting bit 0 enables the feature */
+			if (!has_invtsc)
+				continue;
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = 1;
+			msr->write_val = 1;
+			msr->should_not_gp = 1;
+			break;
+
+		default:
 			kvm_vm_free(vm);
 			return;
 		}
-- 
2.37.2

