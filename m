Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F37B17908
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 14:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbfEHMFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 08:05:37 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55559 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727614AbfEHMFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 08:05:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id y2so2934358wmi.5
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 05:05:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r/i9MCe8LG0OrtGGjdrG1mtwjsf3GeVWNo1SHB2AHe0=;
        b=Nw1U9Il9IreGFf4gmTXEP4zt0QCNs6YFkBavNNejcYOx3liEDUepfXg79bSKOb5uZM
         GUFnEUb++ZDupt8ZkwWLuPW+/hKgQA0v4KGK8Qin0gtRNEede7iwL7o8klz9QtxEFYLd
         yZavUE4SfP6DUuWBZJSZt/VHtMWShNu4lUXdrUIDeLjGxsThCHeeejetxSCu6Zje20c2
         BkFIvpzo/CTG8b4AqVGSgfyGNR/Nq3/4eCStgixlP1cMAvHnTodVSPWeztZ+fs651Abl
         IO3l4dS/HD9v8fWq0FVOs536wWDfUYrdD198z5GsE6laefGmXafx/5WGp+0Wjw3cJtBW
         8ymA==
X-Gm-Message-State: APjAAAWoTYXO52v8NZE2QJ9lZ+QD9LjeNc+316Sm2PwsfZdtrj4FHTlN
        wEyNZSsuwjtxEgf4wF4jXwUO6A==
X-Google-Smtp-Source: APXvYqzW0B3n7iyUSNgR9SA5jPTUWUhc3Mmpv2svyQzOVPuqpBubG1G/k60F0A+7hhzjef77ffH/hg==
X-Received: by 2002:a1c:c004:: with SMTP id q4mr2629632wmf.131.1557317134120;
        Wed, 08 May 2019 05:05:34 -0700 (PDT)
Received: from [10.201.49.229] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id a15sm2457782wru.88.2019.05.08.05.05.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 05:05:33 -0700 (PDT)
Subject: Re: [PATCH 3/3] tests: kvm: Add tests for KVM_SET_NESTED_STATE
To:     Aaron Lewis <aaronlewis@google.com>, rkrcmar@redhat.com,
        jmattson@google.com, marcorr@google.com, kvm@vger.kernel.org
Cc:     Peter Shier <pshier@google.com>
References: <20190502183141.258667-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <120edfea-4200-8ab9-981b-d49cfea02d5d@redhat.com>
Date:   Wed, 8 May 2019 14:05:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502183141.258667-1-aaronlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/05/19 13:31, Aaron Lewis wrote:
> Add tests for KVM_SET_NESTED_STATE and for various code paths in its implementation in vmx_set_nested_state().
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   4 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  32 ++
>  .../kvm/x86_64/vmx_set_nested_state_test.c    | 275 ++++++++++++++++++
>  5 files changed, 313 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 2689d1ea6d7a..bbaa97dbd19e 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -6,4 +6,5 @@
>  /x86_64/vmx_close_while_nested_test
>  /x86_64/vmx_tsc_adjust_test
>  /x86_64/state_test
> +/x86_64/vmx_set_nested_state_test
>  /dirty_log_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index f8588cca2bef..10eff4317226 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -20,6 +20,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
>  TEST_GEN_PROGS_x86_64 += x86_64/smm_test
> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
>  TEST_GEN_PROGS_x86_64 += dirty_log_test
>  TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
>  
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 07b71ad9734a..8c6b9619797d 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -118,6 +118,10 @@ void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
>  		     struct kvm_vcpu_events *events);
>  void vcpu_events_set(struct kvm_vm *vm, uint32_t vcpuid,
>  		     struct kvm_vcpu_events *events);
> +void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t vcpuid,
> +			   struct kvm_nested_state *state);
> +int vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
> +			  struct kvm_nested_state *state, bool ignore_error);
>  
>  const char *exit_reason_str(unsigned int exit_reason);
>  
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 4ca96b228e46..e9113857f44e 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1250,6 +1250,38 @@ void vcpu_events_set(struct kvm_vm *vm, uint32_t vcpuid,
>  		ret, errno);
>  }
>  
> +void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t vcpuid,
> +			   struct kvm_nested_state *state)
> +{
> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +	int ret;
> +
> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> +
> +	ret = ioctl(vcpu->fd, KVM_GET_NESTED_STATE, state);
> +	TEST_ASSERT(ret == 0,
> +		"KVM_SET_NESTED_STATE failed, ret: %i errno: %i",
> +		ret, errno);
> +}
> +
> +int vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
> +			  struct kvm_nested_state *state, bool ignore_error)
> +{
> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +	int ret;
> +
> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> +
> +	ret = ioctl(vcpu->fd, KVM_SET_NESTED_STATE, state);
> +	if (!ignore_error) {
> +		TEST_ASSERT(ret == 0,
> +			"KVM_SET_NESTED_STATE failed, ret: %i errno: %i",
> +			ret, errno);
> +	}
> +
> +	return ret;
> +}
> +
>  /*
>   * VM VCPU System Regs Get
>   *
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
> new file mode 100644
> index 000000000000..5eea24087d19
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
> @@ -0,0 +1,275 @@
> +/*
> + * vmx_set_nested_state_test
> + *
> + * Copyright (C) 2019, Google LLC.
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.
> + *
> + * This test verifies the integrity of calling the ioctl KVM_SET_NESTED_STATE.
> + */
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "vmx.h"
> +
> +#include <errno.h>
> +#include <linux/kvm.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +#include <unistd.h>
> +
> +/*
> + * Mirror of VMCS12_REVISION in arch/x86/kvm/vmx/vmcs12.h. If that value
> + * changes this should be updated.
> + */
> +#define VMCS12_REVISION 0x11e57ed0
> +#define VCPU_ID 5
> +
> +void test_nested_state(struct kvm_vm *vm, struct kvm_nested_state *state)
> +{
> +	volatile struct kvm_run *run;
> +
> +	vcpu_nested_state_set(vm, VCPU_ID, state, false);
> +	run = vcpu_state(vm, VCPU_ID);
> +	vcpu_run(vm, VCPU_ID);
> +	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
> +		"Got exit_reason other than KVM_EXIT_SHUTDOWN: %u (%s),\n",
> +		run->exit_reason,
> +		exit_reason_str(run->exit_reason));
> +}
> +
> +void test_nested_state_expect_errno(struct kvm_vm *vm,
> +				    struct kvm_nested_state *state,
> +				    int expected_errno)
> +{
> +	volatile struct kvm_run *run;
> +	int rv;
> +
> +	rv = vcpu_nested_state_set(vm, VCPU_ID, state, true);
> +	TEST_ASSERT(rv == -1 && errno == expected_errno,
> +		"Expected %s (%d) from vcpu_nested_state_set but got rv: %i errno: %s (%d)",
> +		strerror(expected_errno), expected_errno, rv, strerror(errno),
> +		errno);
> +	run = vcpu_state(vm, VCPU_ID);
> +	vcpu_run(vm, VCPU_ID);
> +	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
> +		"Got exit_reason other than KVM_EXIT_SHUTDOWN: %u (%s),\n",
> +		run->exit_reason,
> +		exit_reason_str(run->exit_reason));
> +}
> +
> +void test_nested_state_expect_einval(struct kvm_vm *vm,
> +				     struct kvm_nested_state *state)
> +{
> +	test_nested_state_expect_errno(vm, state, EINVAL);
> +}
> +
> +void test_nested_state_expect_efault(struct kvm_vm *vm,
> +				     struct kvm_nested_state *state)
> +{
> +	test_nested_state_expect_errno(vm, state, EFAULT);
> +}
> +
> +void set_revision_id_for_vmcs12(struct kvm_nested_state *state,
> +				u32 vmcs12_revision)
> +{
> +	/* Set revision_id in vmcs12 to vmcs12_revision. */
> +	*(u32 *)(state->data) = vmcs12_revision;
> +}
> +
> +void set_default_state(struct kvm_nested_state *state)
> +{
> +	memset(state, 0, sizeof(*state));
> +	state->flags = KVM_STATE_NESTED_RUN_PENDING |
> +		       KVM_STATE_NESTED_GUEST_MODE;
> +	state->format = 0;
> +	state->size = sizeof(*state);
> +}
> +
> +void set_default_vmx_state(struct kvm_nested_state *state, int size)
> +{
> +	memset(state, 0, size);
> +	state->flags = KVM_STATE_NESTED_GUEST_MODE  |
> +			KVM_STATE_NESTED_RUN_PENDING |
> +			KVM_STATE_NESTED_EVMCS;
> +	state->format = 0;
> +	state->size = size;
> +	state->vmx.vmxon_pa = 0x1000;
> +	state->vmx.vmcs_pa = 0x2000;
> +	state->vmx.smm.flags = 0;
> +	set_revision_id_for_vmcs12(state, VMCS12_REVISION);
> +}
> +
> +void test_vmx_nested_state(struct kvm_vm *vm)
> +{
> +	/* Add a page for VMCS12. */
> +	const int state_sz = sizeof(struct kvm_nested_state) + getpagesize();
> +	struct kvm_nested_state *state =
> +		(struct kvm_nested_state *)malloc(state_sz);
> +
> +	/* The format must be set to 0. 0 for VMX, 1 for SVM. */
> +	set_default_vmx_state(state, state_sz);
> +	state->format = 1;
> +	test_nested_state_expect_einval(vm, state);
> +
> +	/*
> +	 * We cannot virtualize anything if the guest does not have VMX
> +	 * enabled.
> +	 */
> +	set_default_vmx_state(state, state_sz);
> +	test_nested_state_expect_einval(vm, state);
> +
> +	/*
> +	 * We cannot virtualize anything if the guest does not have VMX
> +	 * enabled.  We expect KVM_SET_NESTED_STATE to return 0 if vmxon_pa
> +	 * is set to -1ull.
> +	 */
> +	set_default_vmx_state(state, state_sz);
> +	state->vmx.vmxon_pa = -1ull;
> +	test_nested_state(vm, state);
> +
> +	/* Enable VMX in the guest CPUID. */
> +	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> +
> +	/* It is invalid to have vmxon_pa == -1ull and SMM flags non-zero. */
> +	set_default_vmx_state(state, state_sz);
> +	state->vmx.vmxon_pa = -1ull;
> +	state->vmx.smm.flags = 1;
> +	test_nested_state_expect_einval(vm, state);
> +
> +	/* It is invalid to have vmxon_pa == -1ull and vmcs_pa != -1ull. */
> +	set_default_vmx_state(state, state_sz);
> +	state->vmx.vmxon_pa = -1ull;
> +	state->vmx.vmcs_pa = 0;
> +	test_nested_state_expect_einval(vm, state);
> +
> +	/*
> +	 * Setting vmxon_pa == -1ull and vmcs_pa == -1ull exits early without
> +	 * setting the nested state.
> +	 */
> +	set_default_vmx_state(state, state_sz);
> +	state->vmx.vmxon_pa = -1ull;
> +	state->vmx.vmcs_pa = -1ull;
> +	test_nested_state(vm, state);
> +
> +	/* It is invalid to have vmxon_pa set to a non-page aligned address. */
> +	set_default_vmx_state(state, state_sz);
> +	state->vmx.vmxon_pa = 1;
> +	test_nested_state_expect_einval(vm, state);
> +
> +	/*
> +	 * It is invalid to have KVM_STATE_NESTED_SMM_GUEST_MODE and
> +	 * KVM_STATE_NESTED_GUEST_MODE set together.
> +	 */
> +	set_default_vmx_state(state, state_sz);
> +	state->flags = KVM_STATE_NESTED_GUEST_MODE  |
> +		      KVM_STATE_NESTED_RUN_PENDING;
> +	state->vmx.smm.flags = KVM_STATE_NESTED_SMM_GUEST_MODE;
> +	test_nested_state_expect_einval(vm, state);
> +
> +	/*
> +	 * It is invalid to have any of the SMM flags set besides:
> +	 *	KVM_STATE_NESTED_SMM_GUEST_MODE
> +	 *	KVM_STATE_NESTED_SMM_VMXON
> +	 */
> +	set_default_vmx_state(state, state_sz);
> +	state->vmx.smm.flags = ~(KVM_STATE_NESTED_SMM_GUEST_MODE |
> +				KVM_STATE_NESTED_SMM_VMXON);
> +	test_nested_state_expect_einval(vm, state);
> +
> +	/* Outside SMM, SMM flags must be zero. */
> +	set_default_vmx_state(state, state_sz);
> +	state->flags = 0;
> +	state->vmx.smm.flags = KVM_STATE_NESTED_SMM_GUEST_MODE;
> +	test_nested_state_expect_einval(vm, state);
> +
> +	/* Size must be large enough to fit kvm_nested_state and vmcs12. */
> +	set_default_vmx_state(state, state_sz);
> +	state->size = sizeof(*state);
> +	test_nested_state(vm, state);
> +
> +	/* vmxon_pa cannot be the same address as vmcs_pa. */
> +	set_default_vmx_state(state, state_sz);
> +	state->vmx.vmxon_pa = 0;
> +	state->vmx.vmcs_pa = 0;
> +	test_nested_state_expect_einval(vm, state);
> +
> +	/* The revision id for vmcs12 must be VMCS12_REVISION. */
> +	set_default_vmx_state(state, state_sz);
> +	set_revision_id_for_vmcs12(state, 0);
> +	test_nested_state_expect_einval(vm, state);
> +
> +	/*
> +	 * Test that if we leave nesting the state reflects that when we get
> +	 * it again.
> +	 */
> +	set_default_vmx_state(state, state_sz);
> +	state->vmx.vmxon_pa = -1ull;
> +	state->vmx.vmcs_pa = -1ull;
> +	state->flags = 0;
> +	test_nested_state(vm, state);
> +	vcpu_nested_state_get(vm, VCPU_ID, state);
> +	TEST_ASSERT(state->size >= sizeof(*state) && state->size <= state_sz,
> +		    "Size must be between %d and %d.  The size returned was %d.",
> +		    sizeof(*state), state_sz, state->size);
> +	TEST_ASSERT(state->vmx.vmxon_pa == -1ull, "vmxon_pa must be -1ull.");
> +	TEST_ASSERT(state->vmx.vmcs_pa == -1ull, "vmcs_pa must be -1ull.");
> +
> +	free(state);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct kvm_vm *vm;
> +	struct kvm_nested_state state;
> +	struct kvm_cpuid_entry2 *entry = kvm_get_supported_cpuid_entry(1);
> +
> +	/*
> +	 * AMD currently does not implement set_nested_state, so for now we
> +	 * just early out.
> +	 */
> +	if (!(entry->ecx & CPUID_VMX)) {
> +		fprintf(stderr, "nested VMX not enabled, skipping test\n");
> +		exit(KSFT_SKIP);
> +	}
> +
> +	vm = vm_create_default(VCPU_ID, 0, 0);
> +
> +	/* Passing a NULL kvm_nested_state causes a EFAULT. */
> +	test_nested_state_expect_efault(vm, NULL);
> +
> +	/* 'size' cannot be smaller than sizeof(kvm_nested_state). */
> +	set_default_state(&state);
> +	state.size = 0;
> +	test_nested_state_expect_einval(vm, &state);
> +
> +	/*
> +	 * Setting the flags 0xf fails the flags check.  The only flags that
> +	 * can be used are:
> +	 *     KVM_STATE_NESTED_GUEST_MODE
> +	 *     KVM_STATE_NESTED_RUN_PENDING
> +	 *     KVM_STATE_NESTED_EVMCS
> +	 */
> +	set_default_state(&state);
> +	state.flags = 0xf;
> +	test_nested_state_expect_einval(vm, &state);
> +
> +	/*
> +	 * If KVM_STATE_NESTED_RUN_PENDING is set then
> +	 * KVM_STATE_NESTED_GUEST_MODE has to be set as well.
> +	 */
> +	set_default_state(&state);
> +	state.flags = KVM_STATE_NESTED_RUN_PENDING;
> +	test_nested_state_expect_einval(vm, &state);
> +
> +	/*
> +	 * TODO: When SVM support is added for KVM_SET_NESTED_STATE
> +	 *       add tests here to support it like VMX.
> +	 */
> +	if (entry->ecx & CPUID_VMX)
> +		test_vmx_nested_state(vm);
> +
> +	kvm_vm_free(vm);
> +	return 0;
> +}
> 

Queued all three, thanks.

Paolo
