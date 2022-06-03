Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4042053C27F
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241264AbiFCAuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240343AbiFCAqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:46:16 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C71D37A28
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:57 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id nn14-20020a17090b38ce00b001e00df82de8so6411679pjb.1
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=G0hCkDdDsVnTgIh6oVbF9iCXoBGfRnJfQdip0diLa0s=;
        b=Nkq5jgxMtOToKTu53KCADLaarHmSYIQe6nj2MrPb00R6dZk+rc2RmtQDTvW+Fc1unT
         9phEiobYSiipxhUad0+WR5DPzaKFZZQv1q3raIbYvCAOMM7kzAY78zJapDvGiP3hWifZ
         L7onxnH1UpPZZjzX4pd/bfLKHeGt1VoW12jUNX0OQ4Csp4N7Hv6ftRWA7HhAWkW2RUVG
         l+iFpY8KxGSp6pbwNDIDPh7Dc1zqckeRQ2yRdsiZiGlmsuA+amvRNcZ5noPR6v1gyu+w
         xeUO41DG0zhW/LBNWDfH+F+M1VlSOCdpG99KPr5f6T17L9w9LGLz0TUdyLWjP0swiIHN
         NrBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=G0hCkDdDsVnTgIh6oVbF9iCXoBGfRnJfQdip0diLa0s=;
        b=5ImwvFw5jn2BGtXOp3Y4CFrhjN+kM5vqQWJr+DVsFtZ4Sf1bvgPUqOBIr+z4qo1o1F
         X0qECgg1uI876NQX55sqMe+/iMNjdQCoefUlAD2L/LHLoCyL+X2uxIEBiHz/Brb3bTXH
         42t14hOYLYRA5BtJiFlERKbmJZhvtMRZEYvQSdDPkjN4IN2yf2upW1+2idXEejrtMYGN
         zSqlDPsgdij0vWAQQYCnxYnmcydUceKa7Mgy41ZlHMa/+JsWDLQYjMSAM8mkthpID16z
         5lOP8cJkhf2/yxu7u2SEvVtavLybQLlpcYR8a8QYnZ+J/SoudoKXOKu+0BItia2Fz1qy
         czzg==
X-Gm-Message-State: AOAM531inM1EPCkA550nmXdPInBJoHwijEYauaoE1LJbM352MaD+RG/d
        IrlJF5VVuYWI+rHcxMDTxExDbd1z1Lk=
X-Google-Smtp-Source: ABdhPJxmQLULqMpSQEhKMEKzc1sbA+GeCdqMy40AVLfJXgC6Psx7/CgzGZpirQxbUQmVVAxF29CraEzmf+8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:2312:b0:163:daf7:83a9 with SMTP id
 d18-20020a170903231200b00163daf783a9mr7634037plh.160.1654217156879; Thu, 02
 Jun 2022 17:45:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:24 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-78-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 077/144] KVM: selftests: Convert hyperv_features away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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
index 7ff6e4d70333..d0bd9d5e8a99 100644
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
@@ -185,24 +185,24 @@ static void guest_test_msrs_access(void)
 	struct msr_data *msr;
 
 	while (true) {
-		vm = vm_create_default(VCPU_ID, 0, guest_msr);
+		vm = vm_create_with_one_vcpu(&vcpu, guest_msr);
 
 		msr_gva = vm_vaddr_alloc_page(vm);
 		memset(addr_gva2hva(vm, msr_gva), 0x0, getpagesize());
 		msr = addr_gva2hva(vm, msr_gva);
 
-		vcpu_args_set(vm, VCPU_ID, 1, msr_gva);
-		vcpu_enable_cap(vm, VCPU_ID, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
+		vcpu_args_set(vm, vcpu->id, 1, msr_gva);
+		vcpu_enable_cap(vm, vcpu->id, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
 
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
@@ -333,7 +333,7 @@ static void guest_test_msrs_access(void)
 			 * Remains unavailable even with KVM_CAP_HYPERV_SYNIC2
 			 * capability enabled and guest visible CPUID bit unset.
 			 */
-			vcpu_enable_cap(vm, VCPU_ID, KVM_CAP_HYPERV_SYNIC2, 0);
+			vcpu_enable_cap(vm, vcpu->id, KVM_CAP_HYPERV_SYNIC2, 0);
 			break;
 		case 22:
 			feat.eax |= HV_MSR_SYNIC_AVAILABLE;
@@ -463,7 +463,7 @@ static void guest_test_msrs_access(void)
 			break;
 		}
 
-		hv_set_cpuid(vm, best, &feat, &recomm, &dbg);
+		hv_set_cpuid(vcpu, best, &feat, &recomm, &dbg);
 
 		if (msr->idx)
 			pr_debug("Stage %d: testing msr: 0x%x for %s\n", stage,
@@ -471,13 +471,12 @@ static void guest_test_msrs_access(void)
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
@@ -498,10 +497,11 @@ static void guest_test_msrs_access(void)
 
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
@@ -517,10 +517,10 @@ static void guest_test_hcalls_access(void)
 	struct kvm_cpuid2 *best;
 
 	while (true) {
-		vm = vm_create_default(VCPU_ID, 0, guest_hcall);
+		vm = vm_create_with_one_vcpu(&vcpu, guest_hcall);
 
 		vm_init_descriptor_tables(vm);
-		vcpu_init_descriptor_tables(vm, VCPU_ID);
+		vcpu_init_descriptor_tables(vm, vcpu->id);
 		vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
 
 		/* Hypercall input/output */
@@ -531,14 +531,14 @@ static void guest_test_hcalls_access(void)
 		hcall_params = vm_vaddr_alloc_page(vm);
 		memset(addr_gva2hva(vm, hcall_params), 0x0, getpagesize());
 
-		vcpu_args_set(vm, VCPU_ID, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
-		vcpu_enable_cap(vm, VCPU_ID, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
+		vcpu_args_set(vm, vcpu->id, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
+		vcpu_enable_cap(vm, vcpu->id, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
 
-		vcpu_set_hv_cpuid(vm, VCPU_ID);
+		vcpu_set_hv_cpuid(vm, vcpu->id);
 
 		best = kvm_get_supported_hv_cpuid();
 
-		run = vcpu_state(vm, VCPU_ID);
+		run = vcpu->run;
 
 		switch (stage) {
 		case 0:
@@ -633,7 +633,7 @@ static void guest_test_hcalls_access(void)
 			break;
 		}
 
-		hv_set_cpuid(vm, best, &feat, &recomm, &dbg);
+		hv_set_cpuid(vcpu, best, &feat, &recomm, &dbg);
 
 		if (hcall->control)
 			pr_debug("Stage %d: testing hcall: 0x%lx\n", stage,
@@ -641,13 +641,12 @@ static void guest_test_hcalls_access(void)
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
2.36.1.255.ge46751e96f-goog

