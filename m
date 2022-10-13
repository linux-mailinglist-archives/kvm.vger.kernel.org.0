Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975275FD787
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 11:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJMJ71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 05:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJMJ7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 05:59:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C32F984E
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 02:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665655155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xMvP2/XkBADyXsK5rGQw9LKR5LblGeQtr9PcIXwvmao=;
        b=ZqfF5TOJvjAKzPcZVTv1GUyypG84uAl19E5usPBX+Kce/k/O1R7dkm3lPq/oZrKpXNTzCl
        XKC1Ex0DAMfOu0HWa1Tqvn7HrN5Uw/tZVd/0QMu4F3f5WRgBZCycKnyR3rMdjotJYzXql8
        TKVaRYR+G3EjDCIJL9SQyAEwB38aWxY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-1GsG7_jnOdiPPjXK4a8jJQ-1; Thu, 13 Oct 2022 05:59:11 -0400
X-MC-Unique: 1GsG7_jnOdiPPjXK4a8jJQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D492C85A5A6;
        Thu, 13 Oct 2022 09:59:10 +0000 (UTC)
Received: from ovpn-194-196.brq.redhat.com (ovpn-194-196.brq.redhat.com [10.40.194.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 931BE4B400F;
        Thu, 13 Oct 2022 09:59:08 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 7/7] KVM: selftests: Test Hyper-V invariant TSC control
Date:   Thu, 13 Oct 2022 11:58:49 +0200
Message-Id: <20221013095849.705943-8-vkuznets@redhat.com>
In-Reply-To: <20221013095849.705943-1-vkuznets@redhat.com>
References: <20221013095849.705943-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 .../selftests/kvm/include/x86_64/hyperv.h     |  3 ++
 .../selftests/kvm/include/x86_64/processor.h  |  1 +
 .../selftests/kvm/x86_64/hyperv_features.c    | 47 +++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index 843748dde1ff..8368d65afbe4 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -232,4 +232,7 @@
 /* hypercall options */
 #define HV_HYPERCALL_FAST_BIT		BIT(16)
 
+/* HV_X64_MSR_TSC_INVARIANT_CONTROL bits */
+#define HV_INVARIANT_TSC_EXPOSED               BIT_ULL(0)
+
 #endif /* !SELFTEST_KVM_HYPERV_H */
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e8ca0d8a6a7e..39230e3add69 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -128,6 +128,7 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_GBPAGES		KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 26)
 #define	X86_FEATURE_RDTSCP		KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 27)
 #define	X86_FEATURE_LM			KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 29)
+#define	X86_FEATURE_INVTSC		KVM_X86_CPU_FEATURE(0x80000007, 0, EDX, 8)
 #define	X86_FEATURE_RDPRU		KVM_X86_CPU_FEATURE(0x80000008, 0, EBX, 4)
 #define	X86_FEATURE_AMD_IBPB		KVM_X86_CPU_FEATURE(0x80000008, 0, EBX, 12)
 #define	X86_FEATURE_NPT			KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 0)
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 0cfab315eb22..42fbd71c6489 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -82,6 +82,16 @@ static void guest_msr(struct msr_data *msr)
 	if (msr->write)
 		GUEST_ASSERT_3(msr_val == msr->write_val, msr->idx,
 			       msr_val, msr->write_val);
+
+	/* Invariant TSC bit appears when TSC invariant control MSR is written to */
+	if (msr->idx == HV_X64_MSR_TSC_INVARIANT_CONTROL) {
+		if (!this_cpu_has(HV_ACCESS_TSC_INVARIANT))
+			GUEST_ASSERT(this_cpu_has(X86_FEATURE_INVTSC));
+		else
+			GUEST_ASSERT(this_cpu_has(X86_FEATURE_INVTSC) ==
+				     !!(msr_val & HV_INVARIANT_TSC_EXPOSED));
+	}
+
 done:
 	GUEST_DONE();
 }
@@ -137,6 +147,7 @@ static void guest_test_msrs_access(void)
 	int stage = 0;
 	vm_vaddr_t msr_gva;
 	struct msr_data *msr;
+	bool has_invtsc = kvm_cpu_has(X86_FEATURE_INVTSC);
 
 	while (true) {
 		vm = vm_create_with_one_vcpu(&vcpu, guest_msr);
@@ -454,6 +465,42 @@ static void guest_test_msrs_access(void)
 			break;
 
 		case 44:
+			/* MSR is not available when CPUID feature bit is unset */
+			if (!has_invtsc)
+				continue;
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = false;
+			msr->fault_expected = true;
+			break;
+		case 45:
+			/* MSR is vailable when CPUID feature bit is set */
+			if (!has_invtsc)
+				continue;
+			vcpu_set_cpuid_feature(vcpu, HV_ACCESS_TSC_INVARIANT);
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = false;
+			msr->fault_expected = false;
+			break;
+		case 46:
+			/* Writing bits other than 0 is forbidden */
+			if (!has_invtsc)
+				continue;
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = true;
+			msr->write_val = 0xdeadbeef;
+			msr->fault_expected = true;
+			break;
+		case 47:
+			/* Setting bit 0 enables the feature */
+			if (!has_invtsc)
+				continue;
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = true;
+			msr->write_val = 1;
+			msr->fault_expected = false;
+			break;
+
+		default:
 			kvm_vm_free(vm);
 			return;
 		}
-- 
2.37.3

