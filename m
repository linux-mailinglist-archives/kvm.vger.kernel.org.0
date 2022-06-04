Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6244753D482
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350188AbiFDBXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350126AbiFDBWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:22:49 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D2D12ABE
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:22:01 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id j10-20020aa783ca000000b00518265c7cacso4730932pfn.3
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=C53+Egq7YgeyPc3n0sW99y912mVxgbiYdI3cg6bBp3Y=;
        b=YQ35grmHKogo6yHynJeqazwUVXYivB7A7lM1euznZIPJ1nYUpn6qMs29JHsaZUK+WV
         T6vYhuIYqNPDzlVfYWE3s/74hkO4+BzxGcmQfmAzje2XAIyB4ogYUQqlwkpvvmpiBSex
         X2PNMeFVFxNvDWMiEMyAlh72iP6vhHi2IJnh6vMnyucF2UXwFJV0LjQ/jmmPOvyiAo7S
         Q3+bmolDurEEG10vlRHMUQbbaJxVa9umVVewmZtXsNLPNOI2MTtFRKUsG1Up16e0SntQ
         4NN2s0MBc2zDucN94t8hPVPXkcdMPRYU1zX4BMpztnJ1KcKbv2wOGwu8FJvfzqXtxAgw
         Iqxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=C53+Egq7YgeyPc3n0sW99y912mVxgbiYdI3cg6bBp3Y=;
        b=AZdOL0KPu/vimqmHBrLnbRdCPji6aUK2n7/OYDMmvtKoe0d2d/XEO/1s0kiCgoUnTR
         cgbPshO2WWuq5V65X6DVug4v8OO90bC1YnjayeO/Og5yiA55S+lbmNyXdSJ+khcBwI5y
         11nA2gDZDuaNmVCfhvd5QLREaxqRZFXpn/Pn3YLcUPEZzttkYU4vHkdkfnYEKcMxSsrw
         wiY47M1d5hE6hgqZk4jRT/PHkf/X0a8wgqrYwOA1WHIL4KQqESEw2uP1ItMvj/v3PRIq
         6kRQGjAAVIpDyPdJAcm7dBtWG7g/RGwpfxqiZ+rCAj/LZVgGrqfC1kyV3+C7GJYJe8Fq
         DNWA==
X-Gm-Message-State: AOAM530ivs8v9D1lh/XZ7/vYfmUl6w/32BwElmlJAqI9QqBHhlwLeQxs
        WAxjkYbSlYgbBanEDObtuJ8LpriLd6M=
X-Google-Smtp-Source: ABdhPJwoVZ/DfpEUafi7wNXwlwv+xcp9j6CMW2CRh+7EtyfsPfWQBXF5IfKjniLizsErHWXtVP3JFE0v0Sk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:1c5c:0:b0:3fc:109e:8386 with SMTP id
 c28-20020a631c5c000000b003fc109e8386mr11290697pgm.133.1654305706289; Fri, 03
 Jun 2022 18:21:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:42 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-27-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 26/42] KVM: selftests: Use vCPU's CPUID directly in Hyper-V test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the vCPU's persistent CPUID array directly when manipulating the set
of exposed Hyper-V CPUID features.  Drop set_cpuid() to route all future
modification through the vCPU helpers; the Hyper-V features test was the
last user.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |   9 --
 .../selftests/kvm/lib/x86_64/processor.c      |  18 ---
 .../selftests/kvm/x86_64/hyperv_features.c    | 126 +++++++++---------
 3 files changed, 64 insertions(+), 89 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 22e2eaf42360..b9b3a19895aa 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -727,15 +727,6 @@ uint64_t vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 void vm_set_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 			     uint64_t vaddr, uint64_t pte);
 
-/*
- * set_cpuid() - overwrites a matching cpuid entry with the provided value.
- *		 matches based on ent->function && ent->index. returns true
- *		 if a match was found and successfully overwritten.
- * @cpuid: the kvm cpuid list to modify.
- * @ent: cpuid entry to insert
- */
-bool set_cpuid(struct kvm_cpuid2 *cpuid, struct kvm_cpuid_entry2 *ent);
-
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 		       uint64_t a3);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 69239b3613f7..1812b14de3dd 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1208,24 +1208,6 @@ struct kvm_cpuid_entry2 *get_cpuid_entry(struct kvm_cpuid2 *cpuid,
 	return NULL;
 }
 
-bool set_cpuid(struct kvm_cpuid2 *cpuid,
-	       struct kvm_cpuid_entry2 *ent)
-{
-	int i;
-
-	for (i = 0; i < cpuid->nent; i++) {
-		struct kvm_cpuid_entry2 *cur = &cpuid->entries[i];
-
-		if (cur->function != ent->function || cur->index != ent->index)
-			continue;
-
-		memcpy(cur, ent, sizeof(struct kvm_cpuid_entry2));
-		return true;
-	}
-
-	return false;
-}
-
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 		       uint64_t a3)
 {
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index f08f51bad68b..3d0df079496b 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -150,37 +150,28 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 	GUEST_DONE();
 }
 
-static void hv_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
-			 struct kvm_cpuid_entry2 *feat,
-			 struct kvm_cpuid_entry2 *recomm,
-			 struct kvm_cpuid_entry2 *dbg)
+static void vcpu_reset_hv_cpuid(struct kvm_vcpu *vcpu)
 {
-	TEST_ASSERT(set_cpuid(cpuid, feat),
-		    "failed to set KVM_CPUID_FEATURES leaf");
-	TEST_ASSERT(set_cpuid(cpuid, recomm),
-		    "failed to set HYPERV_CPUID_ENLIGHTMENT_INFO leaf");
-	TEST_ASSERT(set_cpuid(cpuid, dbg),
-		    "failed to set HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES leaf");
-	vcpu_init_cpuid(vcpu, cpuid);
+	/*
+	 * Enable all supported Hyper-V features, then clear the leafs holding
+	 * the features that will be tested one by one.
+	 */
+	vcpu_set_hv_cpuid(vcpu);
+
+	vcpu_clear_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES);
+	vcpu_clear_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO);
+	vcpu_clear_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES);
 }
 
 static void guest_test_msrs_access(void)
 {
+	struct kvm_cpuid2 *prev_cpuid = NULL;
+	struct kvm_cpuid_entry2 *feat, *dbg;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage = 0;
-	struct kvm_cpuid_entry2 feat = {
-		.function = HYPERV_CPUID_FEATURES
-	};
-	struct kvm_cpuid_entry2 recomm = {
-		.function = HYPERV_CPUID_ENLIGHTMENT_INFO
-	};
-	struct kvm_cpuid_entry2 dbg = {
-		.function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES
-	};
-	struct kvm_cpuid2 *best;
 	vm_vaddr_t msr_gva;
 	struct msr_data *msr;
 
@@ -194,9 +185,16 @@ static void guest_test_msrs_access(void)
 		vcpu_args_set(vcpu, 1, msr_gva);
 		vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
 
-		vcpu_set_hv_cpuid(vcpu);
+		if (!prev_cpuid) {
+			vcpu_reset_hv_cpuid(vcpu);
 
-		best = kvm_get_supported_hv_cpuid();
+			prev_cpuid = allocate_kvm_cpuid2(vcpu->cpuid->nent);
+		} else {
+			vcpu_init_cpuid(vcpu, prev_cpuid);
+		}
+
+		feat = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES);
+		dbg = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES);
 
 		vm_init_descriptor_tables(vm);
 		vcpu_init_descriptor_tables(vcpu);
@@ -219,7 +217,7 @@ static void guest_test_msrs_access(void)
 			msr->available = 0;
 			break;
 		case 2:
-			feat.eax |= HV_MSR_HYPERCALL_AVAILABLE;
+			feat->eax |= HV_MSR_HYPERCALL_AVAILABLE;
 			/*
 			 * HV_X64_MSR_GUEST_OS_ID has to be written first to make
 			 * HV_X64_MSR_HYPERCALL available.
@@ -246,7 +244,7 @@ static void guest_test_msrs_access(void)
 			msr->available = 0;
 			break;
 		case 6:
-			feat.eax |= HV_MSR_VP_RUNTIME_AVAILABLE;
+			feat->eax |= HV_MSR_VP_RUNTIME_AVAILABLE;
 			msr->write = 0;
 			msr->available = 1;
 			break;
@@ -263,7 +261,7 @@ static void guest_test_msrs_access(void)
 			msr->available = 0;
 			break;
 		case 9:
-			feat.eax |= HV_MSR_TIME_REF_COUNT_AVAILABLE;
+			feat->eax |= HV_MSR_TIME_REF_COUNT_AVAILABLE;
 			msr->write = 0;
 			msr->available = 1;
 			break;
@@ -280,7 +278,7 @@ static void guest_test_msrs_access(void)
 			msr->available = 0;
 			break;
 		case 12:
-			feat.eax |= HV_MSR_VP_INDEX_AVAILABLE;
+			feat->eax |= HV_MSR_VP_INDEX_AVAILABLE;
 			msr->write = 0;
 			msr->available = 1;
 			break;
@@ -297,7 +295,7 @@ static void guest_test_msrs_access(void)
 			msr->available = 0;
 			break;
 		case 15:
-			feat.eax |= HV_MSR_RESET_AVAILABLE;
+			feat->eax |= HV_MSR_RESET_AVAILABLE;
 			msr->write = 0;
 			msr->available = 1;
 			break;
@@ -313,7 +311,7 @@ static void guest_test_msrs_access(void)
 			msr->available = 0;
 			break;
 		case 18:
-			feat.eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
+			feat->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
 			msr->write = 0;
 			msr->available = 1;
 			break;
@@ -336,7 +334,7 @@ static void guest_test_msrs_access(void)
 			vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_SYNIC2, 0);
 			break;
 		case 22:
-			feat.eax |= HV_MSR_SYNIC_AVAILABLE;
+			feat->eax |= HV_MSR_SYNIC_AVAILABLE;
 			msr->write = 0;
 			msr->available = 1;
 			break;
@@ -352,7 +350,7 @@ static void guest_test_msrs_access(void)
 			msr->available = 0;
 			break;
 		case 25:
-			feat.eax |= HV_MSR_SYNTIMER_AVAILABLE;
+			feat->eax |= HV_MSR_SYNTIMER_AVAILABLE;
 			msr->write = 0;
 			msr->available = 1;
 			break;
@@ -368,7 +366,7 @@ static void guest_test_msrs_access(void)
 			msr->available = 0;
 			break;
 		case 28:
-			feat.edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
+			feat->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
 			msr->available = 1;
 			break;
 
@@ -378,7 +376,7 @@ static void guest_test_msrs_access(void)
 			msr->available = 0;
 			break;
 		case 30:
-			feat.eax |= HV_MSR_APIC_ACCESS_AVAILABLE;
+			feat->eax |= HV_MSR_APIC_ACCESS_AVAILABLE;
 			msr->write = 1;
 			msr->write_val = 1;
 			msr->available = 1;
@@ -390,7 +388,7 @@ static void guest_test_msrs_access(void)
 			msr->available = 0;
 			break;
 		case 32:
-			feat.eax |= HV_ACCESS_FREQUENCY_MSRS;
+			feat->eax |= HV_ACCESS_FREQUENCY_MSRS;
 			msr->write = 0;
 			msr->available = 1;
 			break;
@@ -407,7 +405,7 @@ static void guest_test_msrs_access(void)
 			msr->available = 0;
 			break;
 		case 35:
-			feat.eax |= HV_ACCESS_REENLIGHTENMENT;
+			feat->eax |= HV_ACCESS_REENLIGHTENMENT;
 			msr->write = 0;
 			msr->available = 1;
 			break;
@@ -430,7 +428,7 @@ static void guest_test_msrs_access(void)
 			msr->available = 0;
 			break;
 		case 39:
-			feat.edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
+			feat->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
 			msr->write = 0;
 			msr->available = 1;
 			break;
@@ -446,8 +444,8 @@ static void guest_test_msrs_access(void)
 			msr->available = 0;
 			break;
 		case 42:
-			feat.edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
-			dbg.eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
+			feat->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
+			dbg->eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
 			msr->write = 0;
 			msr->available = 1;
 			break;
@@ -463,7 +461,9 @@ static void guest_test_msrs_access(void)
 			break;
 		}
 
-		hv_set_cpuid(vcpu, best, &feat, &recomm, &dbg);
+		vcpu_set_cpuid(vcpu);
+
+		memcpy(prev_cpuid, vcpu->cpuid, kvm_cpuid2_size(vcpu->cpuid->nent));
 
 		if (msr->idx)
 			pr_debug("Stage %d: testing msr: 0x%x for %s\n", stage,
@@ -497,24 +497,15 @@ static void guest_test_msrs_access(void)
 
 static void guest_test_hcalls_access(void)
 {
+	struct kvm_cpuid_entry2 *feat, *recomm, *dbg;
+	struct kvm_cpuid2 *prev_cpuid = NULL;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage = 0;
-	struct kvm_cpuid_entry2 feat = {
-		.function = HYPERV_CPUID_FEATURES,
-		.eax = HV_MSR_HYPERCALL_AVAILABLE
-	};
-	struct kvm_cpuid_entry2 recomm = {
-		.function = HYPERV_CPUID_ENLIGHTMENT_INFO
-	};
-	struct kvm_cpuid_entry2 dbg = {
-		.function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES
-	};
 	vm_vaddr_t hcall_page, hcall_params;
 	struct hcall_data *hcall;
-	struct kvm_cpuid2 *best;
 
 	while (true) {
 		vm = vm_create_with_one_vcpu(&vcpu, guest_hcall);
@@ -534,14 +525,23 @@ static void guest_test_hcalls_access(void)
 		vcpu_args_set(vcpu, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
 		vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
 
-		vcpu_set_hv_cpuid(vcpu);
+		if (!prev_cpuid) {
+			vcpu_reset_hv_cpuid(vcpu);
 
-		best = kvm_get_supported_hv_cpuid();
+			prev_cpuid = allocate_kvm_cpuid2(vcpu->cpuid->nent);
+		} else {
+			vcpu_init_cpuid(vcpu, prev_cpuid);
+		}
+
+		feat = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES);
+		recomm = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO);
+		dbg = vcpu_get_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES);
 
 		run = vcpu->run;
 
 		switch (stage) {
 		case 0:
+			feat->eax |= HV_MSR_HYPERCALL_AVAILABLE;
 			hcall->control = 0xdeadbeef;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_CODE;
 			break;
@@ -551,7 +551,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 2:
-			feat.ebx |= HV_POST_MESSAGES;
+			feat->ebx |= HV_POST_MESSAGES;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 
@@ -560,7 +560,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 4:
-			feat.ebx |= HV_SIGNAL_EVENTS;
+			feat->ebx |= HV_SIGNAL_EVENTS;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 
@@ -569,11 +569,11 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_CODE;
 			break;
 		case 6:
-			dbg.eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
+			dbg->eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 7:
-			feat.ebx |= HV_DEBUGGING;
+			feat->ebx |= HV_DEBUGGING;
 			hcall->expect = HV_STATUS_OPERATION_DENIED;
 			break;
 
@@ -582,7 +582,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 9:
-			recomm.eax |= HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED;
+			recomm->eax |= HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
 		case 10:
@@ -590,7 +590,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 11:
-			recomm.eax |= HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED;
+			recomm->eax |= HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
 
@@ -599,7 +599,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 13:
-			recomm.eax |= HV_X64_CLUSTER_IPI_RECOMMENDED;
+			recomm->eax |= HV_X64_CLUSTER_IPI_RECOMMENDED;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		case 14:
@@ -613,7 +613,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 16:
-			recomm.ebx = 0xfff;
+			recomm->ebx = 0xfff;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
 		case 17:
@@ -622,7 +622,7 @@ static void guest_test_hcalls_access(void)
 			hcall->ud_expected = true;
 			break;
 		case 18:
-			feat.edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
+			feat->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
 			hcall->ud_expected = false;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
@@ -633,7 +633,9 @@ static void guest_test_hcalls_access(void)
 			break;
 		}
 
-		hv_set_cpuid(vcpu, best, &feat, &recomm, &dbg);
+		vcpu_set_cpuid(vcpu);
+
+		memcpy(prev_cpuid, vcpu->cpuid, kvm_cpuid2_size(vcpu->cpuid->nent));
 
 		if (hcall->control)
 			pr_debug("Stage %d: testing hcall: 0x%lx\n", stage,
-- 
2.36.1.255.ge46751e96f-goog

