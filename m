Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9120C51B2D0
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379670AbiEDW5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379624AbiEDWzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:55:37 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285F654BF1
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:31 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s68-20020a637747000000b003aaff19b95bso1353799pgc.1
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1MqmxGCi6E4xHxLpDPlYFabKR9MThqQQ1rORZfrgMkQ=;
        b=BqPiKgoWIZ53RzL5+VcOl/nKnPxkmUt/nKmc1Nwfk+cxabydo3KAsNPSdoN3OV4Cr5
         meVgkdBZ5gdRYn2axjzQyhH68vSO3c/xQLGqIhSBPnHQUj/x32/QpRvjvWdzPn/n+HDd
         ejjqlXpJKBG5Wwy17Xj/7UTh43+77UMlVx5GV1NhhixlefXvMlhy7tguGMoM2RhuU5D/
         wqandrMGtthHywGOfoRg7Ml7H5IwmU51vexY5zCZumm1NIvnX2xoWtUSzQREG7LojUHk
         uxOtveUHuR0P0f/IyElbjHFXlSsny3czzMxzI0Xl7mfKY+xhtPdBdv6UID/GYc9ZbU5a
         EgMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1MqmxGCi6E4xHxLpDPlYFabKR9MThqQQ1rORZfrgMkQ=;
        b=bawaLKhtncadBo+/oaNmv6EpTcWNiYi/+fuMnmcGjwgAi7WRpizbR7Qzd5dGeH/6J+
         4p/ebURPAgcUVrE5EQls0WEh6fOIP3k8xsm0oPhjPvuwcHLIqaJKdhr8DiD8aAbyXZ58
         557G6L/gcccTD9MDoJ0p0xQ7VSMLsHveI3nBhMCuMfnaKsP2W+JnYpW4dFbuvTtHpdc5
         aTC9jN/qmQX7DxA8mFYFTjWqZ5UhoyoxYD9cwI/INYpRdORQRTUW5D7bsGsqEnj5Vd6i
         4z4AiKiUH30m4V+4ZgyuLk9TNZBXSZwv6moegYSQhT0RifutfKSbhDaFXymGVMhKcMtg
         LBBw==
X-Gm-Message-State: AOAM530F8EgpA+m36P+qmJdiQEkawczhNKlu8/s0K2gns/rXAl1locF7
        Mx4m3Ti7QnTKL107AEoYc/ICqOjjPmI=
X-Google-Smtp-Source: ABdhPJxU3wAoTfaqWZDjnh36CxycWYsjQg2yJVjpqxhyL9OTePbK4i9hCOf98mt2BQsPiAvmZ4kePX6Lok4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:21c2:b0:4fe:81f:46c7 with SMTP id
 t2-20020a056a0021c200b004fe081f46c7mr22975752pfj.5.1651704690634; Wed, 04 May
 2022 15:51:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:15 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-70-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 069/128] KVM: selftests: Convert hyperv_features away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Convert hyperv_features to use vm_create_with_one_vcpu() and pass around
a 'struct kvm_vcpu' object instead of using a global VCPU_ID.

Opportunistically use vcpu_run() instead of _vcpu_run() with an open
coded assert that KVM_RUN succeeded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/hyperv_features.c    | 51 +++++++++----------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 672915ce73d8..52686e2f8d53 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -13,7 +13,6 @@
 #include "processor.h"
 #include "hyperv.h"
 
-#define VCPU_ID 0
 #define LINUX_OS_ID ((u64)0x8100 << 48)
 
 extern unsigned char rdmsr_start;
@@ -151,7 +150,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 	GUEST_DONE();
 }
 
-static void hv_set_cpuid(struct kvm_vm *vm, struct kvm_cpuid2 *cpuid,
+static void hv_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			 struct kvm_cpuid_entry2 *feat,
 			 struct kvm_cpuid_entry2 *recomm,
 			 struct kvm_cpuid_entry2 *dbg)
@@ -162,15 +161,16 @@ static void hv_set_cpuid(struct kvm_vm *vm, struct kvm_cpuid2 *cpuid,
 		    "failed to set HYPERV_CPUID_ENLIGHTMENT_INFO leaf");
 	TEST_ASSERT(set_cpuid(cpuid, dbg),
 		    "failed to set HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES leaf");
-	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	vcpu_set_cpuid(vcpu->vm, vcpu->id, cpuid);
 }
 
 static void guest_test_msrs_access(void)
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	int stage = 0, r;
+	int stage = 0;
 	struct kvm_cpuid_entry2 feat = {
 		.function = HYPERV_CPUID_FEATURES
 	};
@@ -189,24 +189,24 @@ static void guest_test_msrs_access(void)
 	struct msr_data *msr;
 
 	while (true) {
-		vm = vm_create_default(VCPU_ID, 0, guest_msr);
+		vm = vm_create_with_one_vcpu(&vcpu, guest_msr);
 
 		msr_gva = vm_vaddr_alloc_page(vm);
 		memset(addr_gva2hva(vm, msr_gva), 0x0, getpagesize());
 		msr = addr_gva2hva(vm, msr_gva);
 
-		vcpu_args_set(vm, VCPU_ID, 1, msr_gva);
-		vcpu_enable_cap(vm, VCPU_ID, &cap);
+		vcpu_args_set(vm, vcpu->id, 1, msr_gva);
+		vcpu_enable_cap(vm, vcpu->id, &cap);
 
-		vcpu_set_hv_cpuid(vm, VCPU_ID);
+		vcpu_set_hv_cpuid(vm, vcpu->id);
 
 		best = kvm_get_supported_hv_cpuid();
 
 		vm_init_descriptor_tables(vm);
-		vcpu_init_descriptor_tables(vm, VCPU_ID);
+		vcpu_init_descriptor_tables(vm, vcpu->id);
 		vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
 
-		run = vcpu_state(vm, VCPU_ID);
+		run = vcpu->run;
 
 		switch (stage) {
 		case 0:
@@ -339,7 +339,7 @@ static void guest_test_msrs_access(void)
 			 */
 			cap.cap = KVM_CAP_HYPERV_SYNIC2;
 			cap.args[0] = 0;
-			vcpu_enable_cap(vm, VCPU_ID, &cap);
+			vcpu_enable_cap(vm, vcpu->id, &cap);
 			break;
 		case 22:
 			feat.eax |= HV_MSR_SYNIC_AVAILABLE;
@@ -469,7 +469,7 @@ static void guest_test_msrs_access(void)
 			break;
 		}
 
-		hv_set_cpuid(vm, best, &feat, &recomm, &dbg);
+		hv_set_cpuid(vcpu, best, &feat, &recomm, &dbg);
 
 		if (msr->idx)
 			pr_debug("Stage %d: testing msr: 0x%x for %s\n", stage,
@@ -477,13 +477,12 @@ static void guest_test_msrs_access(void)
 		else
 			pr_debug("Stage %d: finish\n", stage);
 
-		r = _vcpu_run(vm, VCPU_ID);
-		TEST_ASSERT(!r, "vcpu_run failed: %d\n", r);
+		vcpu_run(vm, vcpu->id);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "unexpected exit reason: %u (%s)",
 			    run->exit_reason, exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_SYNC:
 			TEST_ASSERT(uc.args[1] == 0,
 				    "Unexpected stage: %ld (0 expected)\n",
@@ -504,10 +503,11 @@ static void guest_test_msrs_access(void)
 
 static void guest_test_hcalls_access(void)
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	int stage = 0, r;
+	int stage = 0;
 	struct kvm_cpuid_entry2 feat = {
 		.function = HYPERV_CPUID_FEATURES,
 		.eax = HV_MSR_HYPERCALL_AVAILABLE
@@ -527,10 +527,10 @@ static void guest_test_hcalls_access(void)
 	struct kvm_cpuid2 *best;
 
 	while (true) {
-		vm = vm_create_default(VCPU_ID, 0, guest_hcall);
+		vm = vm_create_with_one_vcpu(&vcpu, guest_hcall);
 
 		vm_init_descriptor_tables(vm);
-		vcpu_init_descriptor_tables(vm, VCPU_ID);
+		vcpu_init_descriptor_tables(vm, vcpu->id);
 		vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
 
 		/* Hypercall input/output */
@@ -541,14 +541,14 @@ static void guest_test_hcalls_access(void)
 		hcall_params = vm_vaddr_alloc_page(vm);
 		memset(addr_gva2hva(vm, hcall_params), 0x0, getpagesize());
 
-		vcpu_args_set(vm, VCPU_ID, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
-		vcpu_enable_cap(vm, VCPU_ID, &cap);
+		vcpu_args_set(vm, vcpu->id, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
+		vcpu_enable_cap(vm, vcpu->id, &cap);
 
-		vcpu_set_hv_cpuid(vm, VCPU_ID);
+		vcpu_set_hv_cpuid(vm, vcpu->id);
 
 		best = kvm_get_supported_hv_cpuid();
 
-		run = vcpu_state(vm, VCPU_ID);
+		run = vcpu->run;
 
 		switch (stage) {
 		case 0:
@@ -643,7 +643,7 @@ static void guest_test_hcalls_access(void)
 			break;
 		}
 
-		hv_set_cpuid(vm, best, &feat, &recomm, &dbg);
+		hv_set_cpuid(vcpu, best, &feat, &recomm, &dbg);
 
 		if (hcall->control)
 			pr_debug("Stage %d: testing hcall: 0x%lx\n", stage,
@@ -651,13 +651,12 @@ static void guest_test_hcalls_access(void)
 		else
 			pr_debug("Stage %d: finish\n", stage);
 
-		r = _vcpu_run(vm, VCPU_ID);
-		TEST_ASSERT(!r, "vcpu_run failed: %d\n", r);
+		vcpu_run(vm, vcpu->id);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "unexpected exit reason: %u (%s)",
 			    run->exit_reason, exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_SYNC:
 			TEST_ASSERT(uc.args[1] == 0,
 				    "Unexpected stage: %ld (0 expected)\n",
-- 
2.36.0.464.gb9c8b46e94-goog

