Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16AA543F66
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 00:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbiFHWpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 18:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbiFHWp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 18:45:26 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBC02509EF
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 15:45:24 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id j15-20020a17090a738f00b001e345e429d2so11290887pjg.0
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 15:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=07WAXpZ8zYpETI7/zyyHdKHPCaSNMRWniZB3LhzmunI=;
        b=n4NpljONrmuO8XHC+yhagdRPrE5285G0RXSdHOSmWK2IHXg+uKRc1NX6IIL/9Q1e0/
         eTT6gu0GDKeYFly+9WUIonxDDVnEks+0WK1ZiP1Xe5FKWYEQL0a+QiUwko0jFEN+FUqi
         RxXYrO+ek5Xy5E1Acdas5hE3AVgFWNpyQdkiR0iYTpN+WsakKEpLe5hGm7M3tD29encC
         M2TiOsC//mdu1Zu+Yz73MTylWILBWz/pFxNFdU2uztePhtcVYS8YUveNPsjJhkZWlZei
         ue+KYpaS98++kLbDqfV2Bb1R503KAe1cBuIifnEsXRxG/4LQZn/IqC1hSoggxEhgKHYi
         UmlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=07WAXpZ8zYpETI7/zyyHdKHPCaSNMRWniZB3LhzmunI=;
        b=gm1tSprDheGFEXNmrzUrthwsdwRTaDRbG7Ns193HS9hgnShmVMmDowlYrCNWK3xGlb
         87A2G9KvAAy/8C0aNlfWk/BFTVAeSbPnKjgoDX6Olz0LJFvLB4JhCGA75dv9coSXDPPI
         FkwQ3J/87+WpjDYwupo0deGe5Cw/vkci7NUDoz23ptHY9Q3W5KMPTmmTuf1muRxGIm3l
         7s6PWa14Oii71XX2HiTnV7aTga9lMPTjjclv9SHqslRPKAZsSAW73EhOml89eHQLSBPB
         0qSjrg2l7v26mmxtRTBD5jIuYBRl4CUYzpFo1+8kvVa9DWJ878Yn2FfHnQu74g/i7oE4
         W5fA==
X-Gm-Message-State: AOAM532jVjGqK09JQzXKrxEQqmbjgJub2CoWsptcooQj5meaUFuI/4cP
        OsReEwRMIYXnTxhEd2+KVddBZsIvi+c=
X-Google-Smtp-Source: ABdhPJzZ220X3EGihTs7WYUjhmHEiiWcHk7yzkTbOsrf6kQXHP5XoP3qtOADSq73ynOjcLGTWIuOgNfwIKc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8ce:b0:510:9298:ea26 with SMTP id
 s14-20020a056a0008ce00b005109298ea26mr36502407pfu.55.1654728324255; Wed, 08
 Jun 2022 15:45:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 22:45:14 +0000
In-Reply-To: <20220608224516.3788274-1-seanjc@google.com>
Message-Id: <20220608224516.3788274-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220608224516.3788274-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 3/5] KVM: selftests: Mostly fix comically broken Hyper-V
 Features test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Explicitly do all setup at every stage of the Hyper-V Features test, e.g.
set the MSR/hypercall, enable capabilities, etc...  Now that the VM is
recreated for every stage, values that are written into the VM's address
space, i.e. shared with the guest, are reset between sub-tests, as are
any capabilities, etc...

Fix the hypercall params as well, which were broken in the same rework.
The "hcall" struct/pointer needs to point at the hcall_params object, not
the set of hypercall pages.

The goofs were hidden by the test's dubious behavior of using '0' to
signal "done", i.e. the MSR test ran exactly one sub-test, and the
hypercall test was a gigantic nop.

Fixes: 6c1186430a80 ("KVM: selftests: Avoid KVM_SET_CPUID2 after KVM_RUN in hyperv_features test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/hyperv_features.c    | 146 ++++++++++--------
 1 file changed, 83 insertions(+), 63 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 3d0df079496b..5ec40422d72a 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -101,52 +101,44 @@ struct hcall_data {
 
 static void guest_msr(struct msr_data *msr)
 {
-	int i = 0;
-
-	while (msr->idx) {
-		WRITE_ONCE(nr_gp, 0);
-		if (!msr->write)
-			do_rdmsr(msr->idx);
-		else
-			do_wrmsr(msr->idx, msr->write_val);
-
-		if (msr->available)
-			GUEST_ASSERT(READ_ONCE(nr_gp) == 0);
-		else
-			GUEST_ASSERT(READ_ONCE(nr_gp) == 1);
-
-		GUEST_SYNC(i++);
-	}
-
+	GUEST_ASSERT(msr->idx);
+
+	WRITE_ONCE(nr_gp, 0);
+	if (!msr->write)
+		do_rdmsr(msr->idx);
+	else
+		do_wrmsr(msr->idx, msr->write_val);
+
+	if (msr->available)
+		GUEST_ASSERT(READ_ONCE(nr_gp) == 0);
+	else
+		GUEST_ASSERT(READ_ONCE(nr_gp) == 1);
 	GUEST_DONE();
 }
 
 static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 {
-	int i = 0;
 	u64 res, input, output;
 
+	GUEST_ASSERT(hcall->control);
+
 	wrmsr(HV_X64_MSR_GUEST_OS_ID, LINUX_OS_ID);
 	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
 
-	while (hcall->control) {
-		nr_ud = 0;
-		if (!(hcall->control & HV_HYPERCALL_FAST_BIT)) {
-			input = pgs_gpa;
-			output = pgs_gpa + 4096;
-		} else {
-			input = output = 0;
-		}
-
-		res = hypercall(hcall->control, input, output);
-		if (hcall->ud_expected)
-			GUEST_ASSERT(nr_ud == 1);
-		else
-			GUEST_ASSERT(res == hcall->expect);
-
-		GUEST_SYNC(i++);
+	nr_ud = 0;
+	if (!(hcall->control & HV_HYPERCALL_FAST_BIT)) {
+		input = pgs_gpa;
+		output = pgs_gpa + 4096;
+	} else {
+		input = output = 0;
 	}
 
+	res = hypercall(hcall->control, input, output);
+	if (hcall->ud_expected)
+		GUEST_ASSERT(nr_ud == 1);
+	else
+		GUEST_ASSERT(res == hcall->expect);
+
 	GUEST_DONE();
 }
 
@@ -202,6 +194,10 @@ static void guest_test_msrs_access(void)
 
 		run = vcpu->run;
 
+		/* TODO: Make this entire test easier to maintain. */
+		if (stage >= 21)
+			vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_SYNIC2, 0);
+
 		switch (stage) {
 		case 0:
 			/*
@@ -245,11 +241,13 @@ static void guest_test_msrs_access(void)
 			break;
 		case 6:
 			feat->eax |= HV_MSR_VP_RUNTIME_AVAILABLE;
+			msr->idx = HV_X64_MSR_VP_RUNTIME;
 			msr->write = 0;
 			msr->available = 1;
 			break;
 		case 7:
 			/* Read only */
+			msr->idx = HV_X64_MSR_VP_RUNTIME;
 			msr->write = 1;
 			msr->write_val = 1;
 			msr->available = 0;
@@ -262,11 +260,13 @@ static void guest_test_msrs_access(void)
 			break;
 		case 9:
 			feat->eax |= HV_MSR_TIME_REF_COUNT_AVAILABLE;
+			msr->idx = HV_X64_MSR_TIME_REF_COUNT;
 			msr->write = 0;
 			msr->available = 1;
 			break;
 		case 10:
 			/* Read only */
+			msr->idx = HV_X64_MSR_TIME_REF_COUNT;
 			msr->write = 1;
 			msr->write_val = 1;
 			msr->available = 0;
@@ -279,11 +279,13 @@ static void guest_test_msrs_access(void)
 			break;
 		case 12:
 			feat->eax |= HV_MSR_VP_INDEX_AVAILABLE;
+			msr->idx = HV_X64_MSR_VP_INDEX;
 			msr->write = 0;
 			msr->available = 1;
 			break;
 		case 13:
 			/* Read only */
+			msr->idx = HV_X64_MSR_VP_INDEX;
 			msr->write = 1;
 			msr->write_val = 1;
 			msr->available = 0;
@@ -296,10 +298,12 @@ static void guest_test_msrs_access(void)
 			break;
 		case 15:
 			feat->eax |= HV_MSR_RESET_AVAILABLE;
+			msr->idx = HV_X64_MSR_RESET;
 			msr->write = 0;
 			msr->available = 1;
 			break;
 		case 16:
+			msr->idx = HV_X64_MSR_RESET;
 			msr->write = 1;
 			msr->write_val = 0;
 			msr->available = 1;
@@ -312,10 +316,12 @@ static void guest_test_msrs_access(void)
 			break;
 		case 18:
 			feat->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
+			msr->idx = HV_X64_MSR_REFERENCE_TSC;
 			msr->write = 0;
 			msr->available = 1;
 			break;
 		case 19:
+			msr->idx = HV_X64_MSR_REFERENCE_TSC;
 			msr->write = 1;
 			msr->write_val = 0;
 			msr->available = 1;
@@ -331,14 +337,18 @@ static void guest_test_msrs_access(void)
 			 * Remains unavailable even with KVM_CAP_HYPERV_SYNIC2
 			 * capability enabled and guest visible CPUID bit unset.
 			 */
-			vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_SYNIC2, 0);
+			msr->idx = HV_X64_MSR_EOM;
+			msr->write = 0;
+			msr->available = 0;
 			break;
 		case 22:
 			feat->eax |= HV_MSR_SYNIC_AVAILABLE;
+			msr->idx = HV_X64_MSR_EOM;
 			msr->write = 0;
 			msr->available = 1;
 			break;
 		case 23:
+			msr->idx = HV_X64_MSR_EOM;
 			msr->write = 1;
 			msr->write_val = 0;
 			msr->available = 1;
@@ -351,22 +361,28 @@ static void guest_test_msrs_access(void)
 			break;
 		case 25:
 			feat->eax |= HV_MSR_SYNTIMER_AVAILABLE;
+			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = 0;
 			msr->available = 1;
 			break;
 		case 26:
+			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = 1;
 			msr->write_val = 0;
 			msr->available = 1;
 			break;
 		case 27:
 			/* Direct mode test */
+			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
 			msr->write = 1;
 			msr->write_val = 1 << 12;
 			msr->available = 0;
 			break;
 		case 28:
 			feat->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
+			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
+			msr->write = 1;
+			msr->write_val = 1 << 12;
 			msr->available = 1;
 			break;
 
@@ -377,6 +393,7 @@ static void guest_test_msrs_access(void)
 			break;
 		case 30:
 			feat->eax |= HV_MSR_APIC_ACCESS_AVAILABLE;
+			msr->idx = HV_X64_MSR_EOI;
 			msr->write = 1;
 			msr->write_val = 1;
 			msr->available = 1;
@@ -389,11 +406,13 @@ static void guest_test_msrs_access(void)
 			break;
 		case 32:
 			feat->eax |= HV_ACCESS_FREQUENCY_MSRS;
+			msr->idx = HV_X64_MSR_TSC_FREQUENCY;
 			msr->write = 0;
 			msr->available = 1;
 			break;
 		case 33:
 			/* Read only */
+			msr->idx = HV_X64_MSR_TSC_FREQUENCY;
 			msr->write = 1;
 			msr->write_val = 1;
 			msr->available = 0;
@@ -406,10 +425,12 @@ static void guest_test_msrs_access(void)
 			break;
 		case 35:
 			feat->eax |= HV_ACCESS_REENLIGHTENMENT;
+			msr->idx = HV_X64_MSR_REENLIGHTENMENT_CONTROL;
 			msr->write = 0;
 			msr->available = 1;
 			break;
 		case 36:
+			msr->idx = HV_X64_MSR_REENLIGHTENMENT_CONTROL;
 			msr->write = 1;
 			msr->write_val = 1;
 			msr->available = 1;
@@ -429,10 +450,12 @@ static void guest_test_msrs_access(void)
 			break;
 		case 39:
 			feat->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
+			msr->idx = HV_X64_MSR_CRASH_P0;
 			msr->write = 0;
 			msr->available = 1;
 			break;
 		case 40:
+			msr->idx = HV_X64_MSR_CRASH_P0;
 			msr->write = 1;
 			msr->write_val = 1;
 			msr->available = 1;
@@ -446,30 +469,28 @@ static void guest_test_msrs_access(void)
 		case 42:
 			feat->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
 			dbg->eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
+			msr->idx = HV_X64_MSR_SYNDBG_STATUS;
 			msr->write = 0;
 			msr->available = 1;
 			break;
 		case 43:
+			msr->idx = HV_X64_MSR_SYNDBG_STATUS;
 			msr->write = 1;
 			msr->write_val = 0;
 			msr->available = 1;
 			break;
 
 		case 44:
-			/* END */
-			msr->idx = 0;
-			break;
+			kvm_vm_free(vm);
+			return;
 		}
 
 		vcpu_set_cpuid(vcpu);
 
 		memcpy(prev_cpuid, vcpu->cpuid, kvm_cpuid2_size(vcpu->cpuid->nent));
 
-		if (msr->idx)
-			pr_debug("Stage %d: testing msr: 0x%x for %s\n", stage,
-				 msr->idx, msr->write ? "write" : "read");
-		else
-			pr_debug("Stage %d: finish\n", stage);
+		pr_debug("Stage %d: testing msr: 0x%x for %s\n", stage,
+			 msr->idx, msr->write ? "write" : "read");
 
 		vcpu_run(vcpu);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
@@ -477,16 +498,14 @@ static void guest_test_msrs_access(void)
 			    run->exit_reason, exit_reason_str(run->exit_reason));
 
 		switch (get_ucall(vcpu, &uc)) {
-		case UCALL_SYNC:
-			TEST_ASSERT(uc.args[1] == 0,
-				    "Unexpected stage: %ld (0 expected)\n",
-				    uc.args[1]);
-			break;
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
 				  __FILE__, uc.args[1]);
 			return;
 		case UCALL_DONE:
+			break;
+		default:
+			TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
 			return;
 		}
 
@@ -516,11 +535,11 @@ static void guest_test_hcalls_access(void)
 
 		/* Hypercall input/output */
 		hcall_page = vm_vaddr_alloc_pages(vm, 2);
-		hcall = addr_gva2hva(vm, hcall_page);
 		memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
 
 		hcall_params = vm_vaddr_alloc_page(vm);
 		memset(addr_gva2hva(vm, hcall_params), 0x0, getpagesize());
+		hcall = addr_gva2hva(vm, hcall_params);
 
 		vcpu_args_set(vcpu, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
 		vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
@@ -552,6 +571,7 @@ static void guest_test_hcalls_access(void)
 			break;
 		case 2:
 			feat->ebx |= HV_POST_MESSAGES;
+			hcall->control = HVCALL_POST_MESSAGE;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 
@@ -561,6 +581,7 @@ static void guest_test_hcalls_access(void)
 			break;
 		case 4:
 			feat->ebx |= HV_SIGNAL_EVENTS;
+			hcall->control = HVCALL_SIGNAL_EVENT;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 
@@ -570,10 +591,12 @@ static void guest_test_hcalls_access(void)
 			break;
 		case 6:
 			dbg->eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
+			hcall->control = HVCALL_RESET_DEBUG_SESSION;
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 7:
 			feat->ebx |= HV_DEBUGGING;
+			hcall->control = HVCALL_RESET_DEBUG_SESSION;
 			hcall->expect = HV_STATUS_OPERATION_DENIED;
 			break;
 
@@ -583,6 +606,7 @@ static void guest_test_hcalls_access(void)
 			break;
 		case 9:
 			recomm->eax |= HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED;
+			hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
 		case 10:
@@ -591,6 +615,7 @@ static void guest_test_hcalls_access(void)
 			break;
 		case 11:
 			recomm->eax |= HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED;
+			hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
 
@@ -600,6 +625,7 @@ static void guest_test_hcalls_access(void)
 			break;
 		case 13:
 			recomm->eax |= HV_X64_CLUSTER_IPI_RECOMMENDED;
+			hcall->control = HVCALL_SEND_IPI;
 			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		case 14:
@@ -613,6 +639,7 @@ static void guest_test_hcalls_access(void)
 			hcall->expect = HV_STATUS_ACCESS_DENIED;
 			break;
 		case 16:
+			hcall->control = HVCALL_NOTIFY_LONG_SPIN_WAIT;
 			recomm->ebx = 0xfff;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
@@ -622,26 +649,21 @@ static void guest_test_hcalls_access(void)
 			hcall->ud_expected = true;
 			break;
 		case 18:
+			hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT;
 			feat->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
 			hcall->ud_expected = false;
 			hcall->expect = HV_STATUS_SUCCESS;
 			break;
-
 		case 19:
-			/* END */
-			hcall->control = 0;
-			break;
+			kvm_vm_free(vm);
+			return;
 		}
 
 		vcpu_set_cpuid(vcpu);
 
 		memcpy(prev_cpuid, vcpu->cpuid, kvm_cpuid2_size(vcpu->cpuid->nent));
 
-		if (hcall->control)
-			pr_debug("Stage %d: testing hcall: 0x%lx\n", stage,
-				 hcall->control);
-		else
-			pr_debug("Stage %d: finish\n", stage);
+		pr_debug("Stage %d: testing hcall: 0x%lx\n", stage, hcall->control);
 
 		vcpu_run(vcpu);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
@@ -649,16 +671,14 @@ static void guest_test_hcalls_access(void)
 			    run->exit_reason, exit_reason_str(run->exit_reason));
 
 		switch (get_ucall(vcpu, &uc)) {
-		case UCALL_SYNC:
-			TEST_ASSERT(uc.args[1] == 0,
-				    "Unexpected stage: %ld (0 expected)\n",
-				    uc.args[1]);
-			break;
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
 				  __FILE__, uc.args[1]);
 			return;
 		case UCALL_DONE:
+			break;
+		default:
+			TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
 			return;
 		}
 
-- 
2.36.1.255.ge46751e96f-goog

