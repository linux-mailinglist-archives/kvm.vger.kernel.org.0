Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9371053C1CC
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240408AbiFCArA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240158AbiFCApX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:23 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F546344C4
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:18 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z16-20020a17090a015000b001dbc8da29a1so3397954pje.7
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=yZxYSAtr71xlvrBZchZzB3lcdsCHEIIU+PCjxQzzr8U=;
        b=OBrLDXkWQUqAgmml2hBx1L2GpPfV4TPaH8cHlwuKTbhE/VyW3X+etNpJOY08kyDYPm
         123Wg3TQveeVTUrqZ3mZ+dWcEmK8RlppvQC2HAhWPjGFRh8KDcLD1C0zvqbY3nE5Ohbi
         cLiETGNe4atI1L+iufukw/V3JPsQbQMts9lmWW4Cv6UkkOLurO4G7Exu8C7wp0AklAJF
         sVO42rd+qfZsM6PGMVrfXH32Cnr8YUIAaSYTdpgjDgfBd2xzmIWRc2hYp4LX44Ds56xZ
         ii0Na01SNPfUqP/l2h6tyugI0JRrrjfuqNdeXa+CWG5pDSmgjbqJcLoK7MkR+UuLXZWo
         BJFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=yZxYSAtr71xlvrBZchZzB3lcdsCHEIIU+PCjxQzzr8U=;
        b=MQ/i5DtKX7xBqJZ+Exa4NgV5KrmUQ/X2rTJ1pka0xwFfyDdfrAjvGX3nAo2Kp3dVJX
         +Xd6f/RdItgjTj2cXvaujE4i/SAeuF3dEusAYoXsq2hHJksu7l3ZGd6vB7dKbhJK5D9R
         RvtZVoh0ydI+427tZGJ0Uz+5R7JLKz5IMS7r5JJRSxOXZz8LuCKrnLNuDnzo6HeKxElB
         jtNeJa1wZqETjKHfZjRvxjvFxUNBKC3tfsLcaRREb9sT5t2IS3j6OdUNeHPFPC125mpC
         f/XZHjVXusv10BxIjiqXP3JPGday5GTwtZGovWGIh8ZXc1veygJn3KLGRMpqAyYVQ+WU
         Cg1A==
X-Gm-Message-State: AOAM532YbWSqbNeBQvxFUR5/+AoJpm01fYGq98S1ZE5omCb0PmaD1mEO
        gdHkMBG0B+4Ougm+BpFY8YRYj/iD5EQ=
X-Google-Smtp-Source: ABdhPJx/eK3s/uqeInxR0Ve5kl02JEIy5ylAfcaJ4D9AiWRV/kdwOk/tdDQe73mdtQ3zSiPl1tXTy57lfU4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1acb:b0:518:986c:a7c4 with SMTP id
 f11-20020a056a001acb00b00518986ca7c4mr7746619pfv.2.1654217117892; Thu, 02 Jun
 2022 17:45:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:02 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-56-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 055/144] KVM: selftests: Convert vmx_set_nested_state_test
 away from VCPU_ID
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

Convert vmx_set_nested_state_test to use vm_create_with_one_vcpu() and
pass around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.
Note, this is a "functional" change in the sense that the test now
creates a vCPU with vcpu_id==0 instead of vcpu_id==5.  The non-zero
VCPU_ID was 100% arbitrary and added little to no validation coverage.
If testing non-zero vCPU IDs is desirable for generic tests, that can be
done in the future by tweaking the VM creation helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/vmx_set_nested_state_test.c    | 86 +++++++++----------
 1 file changed, 43 insertions(+), 43 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index af3b60eb35ec..de38f0e68153 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -23,38 +23,37 @@
  * changes this should be updated.
  */
 #define VMCS12_REVISION 0x11e57ed0
-#define VCPU_ID 5
 
 bool have_evmcs;
 
-void test_nested_state(struct kvm_vm *vm, struct kvm_nested_state *state)
+void test_nested_state(struct kvm_vcpu *vcpu, struct kvm_nested_state *state)
 {
-	vcpu_nested_state_set(vm, VCPU_ID, state);
+	vcpu_nested_state_set(vcpu->vm, vcpu->id, state);
 }
 
-void test_nested_state_expect_errno(struct kvm_vm *vm,
+void test_nested_state_expect_errno(struct kvm_vcpu *vcpu,
 				    struct kvm_nested_state *state,
 				    int expected_errno)
 {
 	int rv;
 
-	rv = __vcpu_nested_state_set(vm, VCPU_ID, state);
+	rv = __vcpu_nested_state_set(vcpu->vm, vcpu->id, state);
 	TEST_ASSERT(rv == -1 && errno == expected_errno,
 		"Expected %s (%d) from vcpu_nested_state_set but got rv: %i errno: %s (%d)",
 		strerror(expected_errno), expected_errno, rv, strerror(errno),
 		errno);
 }
 
-void test_nested_state_expect_einval(struct kvm_vm *vm,
+void test_nested_state_expect_einval(struct kvm_vcpu *vcpu,
 				     struct kvm_nested_state *state)
 {
-	test_nested_state_expect_errno(vm, state, EINVAL);
+	test_nested_state_expect_errno(vcpu, state, EINVAL);
 }
 
-void test_nested_state_expect_efault(struct kvm_vm *vm,
+void test_nested_state_expect_efault(struct kvm_vcpu *vcpu,
 				     struct kvm_nested_state *state)
 {
-	test_nested_state_expect_errno(vm, state, EFAULT);
+	test_nested_state_expect_errno(vcpu, state, EFAULT);
 }
 
 void set_revision_id_for_vmcs12(struct kvm_nested_state *state,
@@ -86,7 +85,7 @@ void set_default_vmx_state(struct kvm_nested_state *state, int size)
 	set_revision_id_for_vmcs12(state, VMCS12_REVISION);
 }
 
-void test_vmx_nested_state(struct kvm_vm *vm)
+void test_vmx_nested_state(struct kvm_vcpu *vcpu)
 {
 	/* Add a page for VMCS12. */
 	const int state_sz = sizeof(struct kvm_nested_state) + getpagesize();
@@ -96,14 +95,14 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	/* The format must be set to 0. 0 for VMX, 1 for SVM. */
 	set_default_vmx_state(state, state_sz);
 	state->format = 1;
-	test_nested_state_expect_einval(vm, state);
+	test_nested_state_expect_einval(vcpu, state);
 
 	/*
 	 * We cannot virtualize anything if the guest does not have VMX
 	 * enabled.
 	 */
 	set_default_vmx_state(state, state_sz);
-	test_nested_state_expect_einval(vm, state);
+	test_nested_state_expect_einval(vcpu, state);
 
 	/*
 	 * We cannot virtualize anything if the guest does not have VMX
@@ -112,17 +111,17 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	 */
 	set_default_vmx_state(state, state_sz);
 	state->hdr.vmx.vmxon_pa = -1ull;
-	test_nested_state_expect_einval(vm, state);
+	test_nested_state_expect_einval(vcpu, state);
 
 	state->hdr.vmx.vmcs12_pa = -1ull;
 	state->flags = KVM_STATE_NESTED_EVMCS;
-	test_nested_state_expect_einval(vm, state);
+	test_nested_state_expect_einval(vcpu, state);
 
 	state->flags = 0;
-	test_nested_state(vm, state);
+	test_nested_state(vcpu, state);
 
 	/* Enable VMX in the guest CPUID. */
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+	vcpu_set_cpuid(vcpu->vm, vcpu->id, kvm_get_supported_cpuid());
 
 	/*
 	 * Setting vmxon_pa == -1ull and vmcs_pa == -1ull exits early without
@@ -133,34 +132,34 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	set_default_vmx_state(state, state_sz);
 	state->hdr.vmx.vmxon_pa = -1ull;
 	state->hdr.vmx.vmcs12_pa = -1ull;
-	test_nested_state_expect_einval(vm, state);
+	test_nested_state_expect_einval(vcpu, state);
 
 	state->flags &= KVM_STATE_NESTED_EVMCS;
 	if (have_evmcs) {
-		test_nested_state_expect_einval(vm, state);
-		vcpu_enable_evmcs(vm, VCPU_ID);
+		test_nested_state_expect_einval(vcpu, state);
+		vcpu_enable_evmcs(vcpu->vm, vcpu->id);
 	}
-	test_nested_state(vm, state);
+	test_nested_state(vcpu, state);
 
 	/* It is invalid to have vmxon_pa == -1ull and SMM flags non-zero. */
 	state->hdr.vmx.smm.flags = 1;
-	test_nested_state_expect_einval(vm, state);
+	test_nested_state_expect_einval(vcpu, state);
 
 	/* Invalid flags are rejected. */
 	set_default_vmx_state(state, state_sz);
 	state->hdr.vmx.flags = ~0;
-	test_nested_state_expect_einval(vm, state);
+	test_nested_state_expect_einval(vcpu, state);
 
 	/* It is invalid to have vmxon_pa == -1ull and vmcs_pa != -1ull. */
 	set_default_vmx_state(state, state_sz);
 	state->hdr.vmx.vmxon_pa = -1ull;
 	state->flags = 0;
-	test_nested_state_expect_einval(vm, state);
+	test_nested_state_expect_einval(vcpu, state);
 
 	/* It is invalid to have vmxon_pa set to a non-page aligned address. */
 	set_default_vmx_state(state, state_sz);
 	state->hdr.vmx.vmxon_pa = 1;
-	test_nested_state_expect_einval(vm, state);
+	test_nested_state_expect_einval(vcpu, state);
 
 	/*
 	 * It is invalid to have KVM_STATE_NESTED_SMM_GUEST_MODE and
@@ -170,7 +169,7 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	state->flags = KVM_STATE_NESTED_GUEST_MODE  |
 		      KVM_STATE_NESTED_RUN_PENDING;
 	state->hdr.vmx.smm.flags = KVM_STATE_NESTED_SMM_GUEST_MODE;
-	test_nested_state_expect_einval(vm, state);
+	test_nested_state_expect_einval(vcpu, state);
 
 	/*
 	 * It is invalid to have any of the SMM flags set besides:
@@ -180,13 +179,13 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	set_default_vmx_state(state, state_sz);
 	state->hdr.vmx.smm.flags = ~(KVM_STATE_NESTED_SMM_GUEST_MODE |
 				KVM_STATE_NESTED_SMM_VMXON);
-	test_nested_state_expect_einval(vm, state);
+	test_nested_state_expect_einval(vcpu, state);
 
 	/* Outside SMM, SMM flags must be zero. */
 	set_default_vmx_state(state, state_sz);
 	state->flags = 0;
 	state->hdr.vmx.smm.flags = KVM_STATE_NESTED_SMM_GUEST_MODE;
-	test_nested_state_expect_einval(vm, state);
+	test_nested_state_expect_einval(vcpu, state);
 
 	/*
 	 * Size must be large enough to fit kvm_nested_state and vmcs12
@@ -195,13 +194,13 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	set_default_vmx_state(state, state_sz);
 	state->size = sizeof(*state);
 	state->flags = 0;
-	test_nested_state_expect_einval(vm, state);
+	test_nested_state_expect_einval(vcpu, state);
 
 	set_default_vmx_state(state, state_sz);
 	state->size = sizeof(*state);
 	state->flags = 0;
 	state->hdr.vmx.vmcs12_pa = -1;
-	test_nested_state(vm, state);
+	test_nested_state(vcpu, state);
 
 	/*
 	 * KVM_SET_NESTED_STATE succeeds with invalid VMCS
@@ -209,7 +208,7 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	 */
 	set_default_vmx_state(state, state_sz);
 	state->flags = 0;
-	test_nested_state(vm, state);
+	test_nested_state(vcpu, state);
 
 	/* Invalid flags are rejected, even if no VMCS loaded. */
 	set_default_vmx_state(state, state_sz);
@@ -217,13 +216,13 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	state->flags = 0;
 	state->hdr.vmx.vmcs12_pa = -1;
 	state->hdr.vmx.flags = ~0;
-	test_nested_state_expect_einval(vm, state);
+	test_nested_state_expect_einval(vcpu, state);
 
 	/* vmxon_pa cannot be the same address as vmcs_pa. */
 	set_default_vmx_state(state, state_sz);
 	state->hdr.vmx.vmxon_pa = 0;
 	state->hdr.vmx.vmcs12_pa = 0;
-	test_nested_state_expect_einval(vm, state);
+	test_nested_state_expect_einval(vcpu, state);
 
 	/*
 	 * Test that if we leave nesting the state reflects that when we get
@@ -233,8 +232,8 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	state->hdr.vmx.vmxon_pa = -1ull;
 	state->hdr.vmx.vmcs12_pa = -1ull;
 	state->flags = 0;
-	test_nested_state(vm, state);
-	vcpu_nested_state_get(vm, VCPU_ID, state);
+	test_nested_state(vcpu, state);
+	vcpu_nested_state_get(vcpu->vm, vcpu->id, state);
 	TEST_ASSERT(state->size >= sizeof(*state) && state->size <= state_sz,
 		    "Size must be between %ld and %d.  The size returned was %d.",
 		    sizeof(*state), state_sz, state->size);
@@ -244,7 +243,7 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	free(state);
 }
 
-void disable_vmx(struct kvm_vm *vm)
+void disable_vmx(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid2 *cpuid = kvm_get_supported_cpuid();
 	int i;
@@ -256,7 +255,7 @@ void disable_vmx(struct kvm_vm *vm)
 	TEST_ASSERT(i != cpuid->nent, "CPUID function 1 not found");
 
 	cpuid->entries[i].ecx &= ~CPUID_VMX;
-	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	vcpu_set_cpuid(vcpu->vm, vcpu->id, cpuid);
 	cpuid->entries[i].ecx |= CPUID_VMX;
 }
 
@@ -264,6 +263,7 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
 	struct kvm_nested_state state;
+	struct kvm_vcpu *vcpu;
 
 	have_evmcs = kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS);
 
@@ -278,20 +278,20 @@ int main(int argc, char *argv[])
 	 */
 	nested_vmx_check_supported();
 
-	vm = vm_create_default(VCPU_ID, 0, 0);
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
 
 	/*
 	 * First run tests with VMX disabled to check error handling.
 	 */
-	disable_vmx(vm);
+	disable_vmx(vcpu);
 
 	/* Passing a NULL kvm_nested_state causes a EFAULT. */
-	test_nested_state_expect_efault(vm, NULL);
+	test_nested_state_expect_efault(vcpu, NULL);
 
 	/* 'size' cannot be smaller than sizeof(kvm_nested_state). */
 	set_default_state(&state);
 	state.size = 0;
-	test_nested_state_expect_einval(vm, &state);
+	test_nested_state_expect_einval(vcpu, &state);
 
 	/*
 	 * Setting the flags 0xf fails the flags check.  The only flags that
@@ -302,7 +302,7 @@ int main(int argc, char *argv[])
 	 */
 	set_default_state(&state);
 	state.flags = 0xf;
-	test_nested_state_expect_einval(vm, &state);
+	test_nested_state_expect_einval(vcpu, &state);
 
 	/*
 	 * If KVM_STATE_NESTED_RUN_PENDING is set then
@@ -310,9 +310,9 @@ int main(int argc, char *argv[])
 	 */
 	set_default_state(&state);
 	state.flags = KVM_STATE_NESTED_RUN_PENDING;
-	test_nested_state_expect_einval(vm, &state);
+	test_nested_state_expect_einval(vcpu, &state);
 
-	test_vmx_nested_state(vm);
+	test_vmx_nested_state(vcpu);
 
 	kvm_vm_free(vm);
 	return 0;
-- 
2.36.1.255.ge46751e96f-goog

