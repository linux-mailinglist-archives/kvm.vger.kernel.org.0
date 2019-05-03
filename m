Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 030EB13264
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 18:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfECQoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 12:44:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:58063 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbfECQoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 12:44:23 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 May 2019 09:44:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,426,1549958400"; 
   d="scan'208";a="141014395"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga006.jf.intel.com with ESMTP; 03 May 2019 09:44:22 -0700
Date:   Fri, 3 May 2019 09:44:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        marcorr@google.com, kvm@vger.kernel.org,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 3/3] tests: kvm: Add tests for KVM_SET_NESTED_STATE
Message-ID: <20190503164422.GC32628@linux.intel.com>
References: <20190502183141.258667-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502183141.258667-1-aaronlewis@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 02, 2019 at 11:31:41AM -0700, Aaron Lewis wrote:
> Add tests for KVM_SET_NESTED_STATE and for various code paths in its implementation in vmx_set_nested_state().
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---

...

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

Hmm, probably better to check KVM_CAP_NESTED_STATE.  If/when support for
AMD is added it'd be good to automatically pick up whatever testing we can.
As a bonus it'll test the cap code.

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
> -- 
> 2.21.0.593.g511ec345e18-goog
> 
