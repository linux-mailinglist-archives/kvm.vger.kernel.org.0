Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B71153C318
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbiFCAvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240311AbiFCAqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:46:00 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F4E3465E
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:51 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id t1-20020a62ea01000000b0051be221a3ebso118393pfh.17
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nBXYPby3wQYMmU1zAC8L3BCfmsSbMK1J9bnjhYnJ/Uo=;
        b=ArelePAV/cTNiUXUf/fFsGGo9+O34PfITXBAJjg5iwhReaNo1hGGJrpdaZB07DuyGS
         ZsvbPG1nyx7zu4Dng3ICKBPqpL8iEthA2+96EbozaCQCRyIeDAlUvjE+65hrqCygLnyK
         P9mifMDmsp/9UtTKoR3DiajiZpZJTpKMqddnNmUYW4xJQnu1zuTcpfP3+ZgwAvkpH8Uq
         Ilr1w+R7wOeQDtyx7qLG1/dL/mpC3yC8uFsFNiqWxDabLkfWEyEPVVg/xVYi50shpMVv
         0eDP0HO/pAnNVn4cr8QuFQcPcSIuybCcpih6mo7xkCb/66oDlgdE62EeRT5GzYn68HZV
         IzxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nBXYPby3wQYMmU1zAC8L3BCfmsSbMK1J9bnjhYnJ/Uo=;
        b=8MTC1bViEW5v1DWhwtiXT5jwiXz7kc0+v84w9DKy0fUTmNE2MIDtkbJw3t3s796YQ2
         8dbTKdvJKVOMnNxujEGp/mJJ3xdsKO0KZ7b0RoQVWCX/uQEnsRycntrBATWen4vFo0b3
         oPErFQCZDkJ4h4aITCkey7ZA7hp9qhtpzPQx/BxnDldtofKa14Ng47lQxyEUSHkpNfGH
         oHHfoauLJUiAOX9QTrYJQp2aqxVTAZJChfXCmCvjRXuqvbuFSY6J8hPuRxaeVppDXjtR
         0NQtMCsqGZodlrAh6Mu9mHCbSoauwKRrcuarlMvsFmRnaJccnY/46hZGFHAXGlUlDNMa
         0/sw==
X-Gm-Message-State: AOAM530ydJXsdPOuBHc5BaXeXUBlF2n7pTB2221P1Tg+HFjprjYH3y9S
        wxik9REEHIKzJlUYXcqk1/Bz9xVotfo=
X-Google-Smtp-Source: ABdhPJwNJhjR1hacn4P3CyUig+xVNDD54GBx0sqPkoH+gcx2WhsJ7jcqBljDKzixLxShwZF9fhKv7EDE+HI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:246:b0:153:84fe:a9b0 with SMTP id
 j6-20020a170903024600b0015384fea9b0mr7568191plh.163.1654217151393; Thu, 02
 Jun 2022 17:45:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:21 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-75-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 074/144] KVM: selftests: Convert tsc_msrs_test away from VCPU_ID
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

Convert tsc_msrs_test to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/tsc_msrs_test.c      | 35 +++++++++----------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
index a426078b16a3..3b7bf660eced 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
@@ -9,14 +9,12 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define VCPU_ID 0
-
 #define UNITY                  (1ull << 30)
 #define HOST_ADJUST            (UNITY * 64)
 #define GUEST_STEP             (UNITY * 4)
 #define ROUND(x)               ((x + UNITY / 2) & -UNITY)
 #define rounded_rdmsr(x)       ROUND(rdmsr(x))
-#define rounded_host_rdmsr(x)  ROUND(vcpu_get_msr(vm, 0, x))
+#define rounded_host_rdmsr(x)  ROUND(vcpu_get_msr(vm, vcpu->id, x))
 
 static void guest_code(void)
 {
@@ -66,15 +64,13 @@ static void guest_code(void)
 	GUEST_DONE();
 }
 
-static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid, int stage)
+static void run_vcpu(struct kvm_vcpu *vcpu, int stage)
 {
 	struct ucall uc;
 
-	vcpu_args_set(vm, vcpuid, 1, vcpuid);
+	vcpu_run(vcpu->vm, vcpu->id);
 
-	vcpu_ioctl(vm, vcpuid, KVM_RUN, NULL);
-
-	switch (get_ucall(vm, vcpuid, &uc)) {
+	switch (get_ucall(vcpu->vm, vcpu->id, &uc)) {
 	case UCALL_SYNC:
 		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
 			    uc.args[1] == stage + 1, "Stage %d: Unexpected register values vmexit, got %lx",
@@ -88,29 +84,30 @@ static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid, int stage)
 			    __FILE__, uc.args[1], uc.args[2], uc.args[3]);
 	default:
 		TEST_ASSERT(false, "Unexpected exit: %s",
-			    exit_reason_str(vcpu_state(vm, vcpuid)->exit_reason));
+			    exit_reason_str(vcpu->run->exit_reason));
 	}
 }
 
 int main(void)
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	uint64_t val;
 
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	val = 0;
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
 
 	/* Guest: writes to MSR_IA32_TSC affect both MSRs.  */
-	run_vcpu(vm, VCPU_ID, 1);
+	run_vcpu(vcpu, 1);
 	val = 1ull * GUEST_STEP;
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
 
 	/* Guest: writes to MSR_IA32_TSC_ADJUST affect both MSRs.  */
-	run_vcpu(vm, VCPU_ID, 2);
+	run_vcpu(vcpu, 2);
 	val = 2ull * GUEST_STEP;
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
@@ -119,18 +116,18 @@ int main(void)
 	 * Host: writes to MSR_IA32_TSC set the host-side offset
 	 * and therefore do not change MSR_IA32_TSC_ADJUST.
 	 */
-	vcpu_set_msr(vm, 0, MSR_IA32_TSC, HOST_ADJUST + val);
+	vcpu_set_msr(vm, vcpu->id, MSR_IA32_TSC, HOST_ADJUST + val);
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
-	run_vcpu(vm, VCPU_ID, 3);
+	run_vcpu(vcpu, 3);
 
 	/* Host: writes to MSR_IA32_TSC_ADJUST do not modify the TSC.  */
-	vcpu_set_msr(vm, 0, MSR_IA32_TSC_ADJUST, UNITY * 123456);
+	vcpu_set_msr(vm, vcpu->id, MSR_IA32_TSC_ADJUST, UNITY * 123456);
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
-	ASSERT_EQ(vcpu_get_msr(vm, 0, MSR_IA32_TSC_ADJUST), UNITY * 123456);
+	ASSERT_EQ(vcpu_get_msr(vm, vcpu->id, MSR_IA32_TSC_ADJUST), UNITY * 123456);
 
 	/* Restore previous value.  */
-	vcpu_set_msr(vm, 0, MSR_IA32_TSC_ADJUST, val);
+	vcpu_set_msr(vm, vcpu->id, MSR_IA32_TSC_ADJUST, val);
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
 
@@ -138,7 +135,7 @@ int main(void)
 	 * Guest: writes to MSR_IA32_TSC_ADJUST do not destroy the
 	 * host-side offset and affect both MSRs.
 	 */
-	run_vcpu(vm, VCPU_ID, 4);
+	run_vcpu(vcpu, 4);
 	val = 3ull * GUEST_STEP;
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
@@ -147,7 +144,7 @@ int main(void)
 	 * Guest: writes to MSR_IA32_TSC affect both MSRs, so the host-side
 	 * offset is now visible in MSR_IA32_TSC_ADJUST.
 	 */
-	run_vcpu(vm, VCPU_ID, 5);
+	run_vcpu(vcpu, 5);
 	val = 4ull * GUEST_STEP;
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val - HOST_ADJUST);
-- 
2.36.1.255.ge46751e96f-goog

