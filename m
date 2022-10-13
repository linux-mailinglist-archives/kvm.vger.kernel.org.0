Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3462C5FD782
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 11:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiJMJ7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 05:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiJMJ7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 05:59:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A384FF9840
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 02:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665655151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b6Z6/Y7SQY6YFMVx5unI7FqXOUW61hhnC9sYEB8RTww=;
        b=gzTv4pZHX5LpG+DnQENn2fZkTt12PqMZ9D+jO2H5emPqXKSuYG4u5UnCFlpQBRCOdGhw68
        DleEo5bK0nkL9jsju+0AUvKl8uBYHzC/wTqeGa2bAuOVY6lfmC7hT7WrhoA9hs7M9yOrnO
        FNz6IHmjkOryz5h0Zl6K+TIgEZgt7cg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-C3mE10GjP62lsBzcjFQZ_Q-1; Thu, 13 Oct 2022 05:59:06 -0400
X-MC-Unique: C3mE10GjP62lsBzcjFQZ_Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B80F080280D;
        Thu, 13 Oct 2022 09:59:05 +0000 (UTC)
Received: from ovpn-194-196.brq.redhat.com (ovpn-194-196.brq.redhat.com [10.40.194.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EBF94B400F;
        Thu, 13 Oct 2022 09:59:03 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 5/7] KVM: selftests: Convert hyperv_features test to using KVM_X86_CPU_FEATURE()
Date:   Thu, 13 Oct 2022 11:58:47 +0200
Message-Id: <20221013095849.705943-6-vkuznets@redhat.com>
In-Reply-To: <20221013095849.705943-1-vkuznets@redhat.com>
References: <20221013095849.705943-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hyperv_features test needs to set certain CPUID bits in Hyper-V feature
leaves but instead of open coding this, common KVM_X86_CPU_FEATURE()
infrastructure can be used.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/hyperv.h     | 141 ++++++++++++------
 .../selftests/kvm/x86_64/hyperv_features.c    |  67 ++++-----
 2 files changed, 127 insertions(+), 81 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index b66910702c0a..843748dde1ff 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -83,61 +83,108 @@
 #define HV_X64_MSR_SYNDBG_OPTIONS		0x400000FF
 
 /* HYPERV_CPUID_FEATURES.EAX */
-#define HV_MSR_VP_RUNTIME_AVAILABLE		BIT(0)
-#define HV_MSR_TIME_REF_COUNT_AVAILABLE		BIT(1)
-#define HV_MSR_SYNIC_AVAILABLE			BIT(2)
-#define HV_MSR_SYNTIMER_AVAILABLE		BIT(3)
-#define HV_MSR_APIC_ACCESS_AVAILABLE		BIT(4)
-#define HV_MSR_HYPERCALL_AVAILABLE		BIT(5)
-#define HV_MSR_VP_INDEX_AVAILABLE		BIT(6)
-#define HV_MSR_RESET_AVAILABLE			BIT(7)
-#define HV_MSR_STAT_PAGES_AVAILABLE		BIT(8)
-#define HV_MSR_REFERENCE_TSC_AVAILABLE		BIT(9)
-#define HV_MSR_GUEST_IDLE_AVAILABLE		BIT(10)
-#define HV_ACCESS_FREQUENCY_MSRS		BIT(11)
-#define HV_ACCESS_REENLIGHTENMENT		BIT(13)
-#define HV_ACCESS_TSC_INVARIANT			BIT(15)
+#define HV_MSR_VP_RUNTIME_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 0)
+#define HV_MSR_TIME_REF_COUNT_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 1)
+#define HV_MSR_SYNIC_AVAILABLE			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 2)
+#define HV_MSR_SYNTIMER_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 3)
+#define HV_MSR_APIC_ACCESS_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 4)
+#define HV_MSR_HYPERCALL_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 5)
+#define HV_MSR_VP_INDEX_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 6)
+#define HV_MSR_RESET_AVAILABLE			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 7)
+#define HV_MSR_STAT_PAGES_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 8)
+#define HV_MSR_REFERENCE_TSC_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 9)
+#define HV_MSR_GUEST_IDLE_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 10)
+#define HV_ACCESS_FREQUENCY_MSRS		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 11)
+#define HV_ACCESS_REENLIGHTENMENT		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 13)
+#define HV_ACCESS_TSC_INVARIANT			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EAX, 15)
 
 /* HYPERV_CPUID_FEATURES.EBX */
-#define HV_CREATE_PARTITIONS			BIT(0)
-#define HV_ACCESS_PARTITION_ID			BIT(1)
-#define HV_ACCESS_MEMORY_POOL			BIT(2)
-#define HV_ADJUST_MESSAGE_BUFFERS		BIT(3)
-#define HV_POST_MESSAGES			BIT(4)
-#define HV_SIGNAL_EVENTS			BIT(5)
-#define HV_CREATE_PORT				BIT(6)
-#define HV_CONNECT_PORT				BIT(7)
-#define HV_ACCESS_STATS				BIT(8)
-#define HV_DEBUGGING				BIT(11)
-#define HV_CPU_MANAGEMENT			BIT(12)
-#define HV_ISOLATION				BIT(22)
+#define HV_CREATE_PARTITIONS		        \
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 0)
+#define HV_ACCESS_PARTITION_ID			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 1)
+#define HV_ACCESS_MEMORY_POOL			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 2)
+#define HV_ADJUST_MESSAGE_BUFFERS		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 3)
+#define HV_POST_MESSAGES			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 4)
+#define HV_SIGNAL_EVENTS			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 5)
+#define HV_CREATE_PORT				\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 6)
+#define HV_CONNECT_PORT				\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 7)
+#define HV_ACCESS_STATS				\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 8)
+#define HV_DEBUGGING				\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 11)
+#define HV_CPU_MANAGEMENT			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 12)
+#define HV_ISOLATION				\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EBX, 22)
 
 /* HYPERV_CPUID_FEATURES.EDX */
-#define HV_X64_MWAIT_AVAILABLE				BIT(0)
-#define HV_X64_GUEST_DEBUGGING_AVAILABLE		BIT(1)
-#define HV_X64_PERF_MONITOR_AVAILABLE			BIT(2)
-#define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE	BIT(3)
-#define HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE		BIT(4)
-#define HV_X64_GUEST_IDLE_STATE_AVAILABLE		BIT(5)
-#define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
-#define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
-#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
-#define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
+#define HV_X64_MWAIT_AVAILABLE				\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 0)
+#define HV_X64_GUEST_DEBUGGING_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 1)
+#define HV_X64_PERF_MONITOR_AVAILABLE			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 2)
+#define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE	\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 3)
+#define HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 4)
+#define HV_X64_GUEST_IDLE_STATE_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 5)
+#define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 8)
+#define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 10)
+#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 11)
+#define HV_STIMER_DIRECT_MODE_AVAILABLE			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_FEATURES, 0, EDX, 19)
 
 /* HYPERV_CPUID_ENLIGHTMENT_INFO.EAX */
-#define HV_X64_AS_SWITCH_RECOMMENDED			BIT(0)
-#define HV_X64_LOCAL_TLB_FLUSH_RECOMMENDED		BIT(1)
-#define HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED		BIT(2)
-#define HV_X64_APIC_ACCESS_RECOMMENDED			BIT(3)
-#define HV_X64_SYSTEM_RESET_RECOMMENDED			BIT(4)
-#define HV_X64_RELAXED_TIMING_RECOMMENDED		BIT(5)
-#define HV_DEPRECATING_AEOI_RECOMMENDED			BIT(9)
-#define HV_X64_CLUSTER_IPI_RECOMMENDED			BIT(10)
-#define HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED		BIT(11)
-#define HV_X64_ENLIGHTENED_VMCS_RECOMMENDED		BIT(14)
+#define HV_X64_AS_SWITCH_RECOMMENDED			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 0)
+#define HV_X64_LOCAL_TLB_FLUSH_RECOMMENDED		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 1)
+#define HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 2)
+#define HV_X64_APIC_ACCESS_RECOMMENDED			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 3)
+#define HV_X64_SYSTEM_RESET_RECOMMENDED			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 4)
+#define HV_X64_RELAXED_TIMING_RECOMMENDED		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 5)
+#define HV_DEPRECATING_AEOI_RECOMMENDED			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 9)
+#define HV_X64_CLUSTER_IPI_RECOMMENDED			\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 10)
+#define HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 11)
+#define HV_X64_ENLIGHTENED_VMCS_RECOMMENDED		\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EAX, 14)
 
 /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
-#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	BIT(1)
+#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	\
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES, 0, EAX, 1)
 
 /* Hypercalls */
 #define HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE	0x0002
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 3a93e0eb7c6e..d4549830c9d6 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -15,6 +15,14 @@
 
 #define LINUX_OS_ID ((u64)0x8100 << 48)
 
+/*
+ * HYPERV_CPUID_ENLIGHTMENT_INFO.EBX is not a 'feature' CPUID leaf
+ * but to activate the feature it is sufficient to set it to a non-zero
+ * value. Use BIT(0) for that.
+ */
+#define HV_PV_SPINLOCKS_TEST            \
+	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EBX, 0)
+
 static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
 				vm_vaddr_t output_address, uint64_t *hv_status)
 {
@@ -108,7 +116,6 @@ static void vcpu_reset_hv_cpuid(struct kvm_vcpu *vcpu)
 static void guest_test_msrs_access(void)
 {
 	struct kvm_cpuid2 *prev_cpuid = NULL;
-	struct kvm_cpuid_entry2 *feat, *dbg;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
@@ -135,9 +142,6 @@ static void guest_test_msrs_access(void)
 			vcpu_init_cpuid(vcpu, prev_cpuid);
 		}
 
-		feat = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES);
-		dbg = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES);
-
 		vm_init_descriptor_tables(vm);
 		vcpu_init_descriptor_tables(vcpu);
 
@@ -162,7 +166,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 2:
-			feat->eax |= HV_MSR_HYPERCALL_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_HYPERCALL_AVAILABLE);
 			/*
 			 * HV_X64_MSR_GUEST_OS_ID has to be written first to make
 			 * HV_X64_MSR_HYPERCALL available.
@@ -189,7 +193,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 6:
-			feat->eax |= HV_MSR_VP_RUNTIME_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_VP_RUNTIME_AVAILABLE);
 			msr->idx = HV_X64_MSR_VP_RUNTIME;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -208,7 +212,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 9:
-			feat->eax |= HV_MSR_TIME_REF_COUNT_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_TIME_REF_COUNT_AVAILABLE);
 			msr->idx = HV_X64_MSR_TIME_REF_COUNT;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -227,7 +231,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 12:
-			feat->eax |= HV_MSR_VP_INDEX_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_VP_INDEX_AVAILABLE);
 			msr->idx = HV_X64_MSR_VP_INDEX;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -246,7 +250,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 15:
-			feat->eax |= HV_MSR_RESET_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_RESET_AVAILABLE);
 			msr->idx = HV_X64_MSR_RESET;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -264,7 +268,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 18:
-			feat->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_REFERENCE_TSC_AVAILABLE);
 			msr->idx = HV_X64_MSR_REFERENCE_TSC;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -291,7 +295,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 22:
-			feat->eax |= HV_MSR_SYNIC_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_SYNIC_AVAILABLE);
 			msr->idx = HV_X64_MSR_EOM;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -309,7 +313,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 25:
-			feat->eax |= HV_MSR_SYNTIMER_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_SYNTIMER_AVAILABLE);
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -328,7 +332,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 28:
-			feat->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_STIMER_DIRECT_MODE_AVAILABLE);
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = true;
 			msr->write_val = 1 << 12;
@@ -341,7 +345,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 30:
-			feat->eax |= HV_MSR_APIC_ACCESS_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_APIC_ACCESS_AVAILABLE);
 			msr->idx = HV_X64_MSR_EOI;
 			msr->write = true;
 			msr->write_val = 1;
@@ -354,7 +358,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 32:
-			feat->eax |= HV_ACCESS_FREQUENCY_MSRS;
+			vcpu_set_cpuid_feature(vcpu, HV_ACCESS_FREQUENCY_MSRS);
 			msr->idx = HV_X64_MSR_TSC_FREQUENCY;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -373,7 +377,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 35:
-			feat->eax |= HV_ACCESS_REENLIGHTENMENT;
+			vcpu_set_cpuid_feature(vcpu, HV_ACCESS_REENLIGHTENMENT);
 			msr->idx = HV_X64_MSR_REENLIGHTENMENT_CONTROL;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -398,7 +402,7 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 39:
-			feat->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE);
 			msr->idx = HV_X64_MSR_CRASH_P0;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -416,8 +420,8 @@ static void guest_test_msrs_access(void)
 			msr->fault_expected = true;
 			break;
 		case 42:
-			feat->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
-			dbg->eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
+			vcpu_set_cpuid_feature(vcpu, HV_FEATURE_DEBUG_MSRS_AVAILABLE);
+			vcpu_set_cpuid_feature(vcpu, HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING);
 			msr->idx = HV_X64_MSR_SYNDBG_STATUS;
 			msr->write = false;
 			msr->fault_expected = false;
@@ -464,7 +468,6 @@ static void guest_test_msrs_access(void)
 
 static void guest_test_hcalls_access(void)
 {
-	struct kvm_cpuid_entry2 *feat, *recomm, *dbg;
 	struct kvm_cpuid2 *prev_cpuid = NULL;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
@@ -499,15 +502,11 @@ static void guest_test_hcalls_access(void)
 			vcpu_init_cpuid(vcpu, prev_cpuid);
 		}
 
-		feat = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES);
-		recomm = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO);
-		dbg = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES);
-
 		run = vcpu->run;
 
 		switch (stage) {
 		case 0:
-			feat->eax |= HV_MSR_HYPERCALL_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_MSR_HYPERCALL_AVAILABLE);
 			hcall->control = 0xbeef;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_CODE;
 			break;
@@ -517,7 +516,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 2:
-			feat->ebx |= HV_POST_MESSAGES;
+			vcpu_set_cpuid_feature(vcpu, HV_POST_MESSAGES);
 			hcall->control = HVCALL_POST_MESSAGE;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
@@ -527,7 +526,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 4:
-			feat->ebx |= HV_SIGNAL_EVENTS;
+			vcpu_set_cpuid_feature(vcpu, HV_SIGNAL_EVENTS);
 			hcall->control = HVCALL_SIGNAL_EVENT;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
@@ -537,12 +536,12 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_CODE;
 			break;
 		case 6:
-			dbg->eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
+			vcpu_set_cpuid_feature(vcpu, HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING);
 			hcall->control = HVCALL_RESET_DEBUG_SESSION;
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 7:
-			feat->ebx |= HV_DEBUGGING;
+			vcpu_set_cpuid_feature(vcpu, HV_DEBUGGING);
 			hcall->control = HVCALL_RESET_DEBUG_SESSION;
 			hcall->expect = HV_STATUS_OPERATION_DENIED;
 			break;
@@ -552,7 +551,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 9:
-			recomm->eax |= HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED;
+			vcpu_set_cpuid_feature(vcpu, HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED);
 			hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
@@ -561,7 +560,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 11:
-			recomm->eax |= HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED;
+			vcpu_set_cpuid_feature(vcpu, HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED);
 			hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
@@ -571,7 +570,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 13:
-			recomm->eax |= HV_X64_CLUSTER_IPI_RECOMMENDED;
+			vcpu_set_cpuid_feature(vcpu, HV_X64_CLUSTER_IPI_RECOMMENDED);
 			hcall->control = HVCALL_SEND_IPI;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
@@ -586,7 +585,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 16:
-			recomm->ebx = 0xfff;
+			vcpu_set_cpuid_feature(vcpu, HV_PV_SPINLOCKS_TEST);
 			hcall->control = HVCALL_NOTIFY_LONG_SPIN_WAIT;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
@@ -596,7 +595,7 @@ static void guest_test_hcalls_access(void)
 			hcall->ud_expected = true;
 			break;
 		case 18:
-			feat->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
+			vcpu_set_cpuid_feature(vcpu, HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE);
 			hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT;
 			hcall->ud_expected = false;
 			hcall->expect = HV_STATUS_SUCCESS;
-- 
2.37.3

