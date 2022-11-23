Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740C3634DD4
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 03:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbiKWC1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 21:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235548AbiKWC07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 21:26:59 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158B3DAD14;
        Tue, 22 Nov 2022 18:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669170418; x=1700706418;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8nd3ujAlM1sOL0NbL4+FOKaQgAUWEqXW1PRj4z6f9WA=;
  b=nYyUa7j5yD5U9SxqoIHFdzGYn3CtN6Wofm2S4VuEd9PpYjNcFAccHhCv
   fQN6+V/nyR+Dzqv3iu9s151KPL5juraScTT9J51c1Klq+Eh4pnq/KzxYR
   CyQ8n2kPhgdVIVLKVaqPlXIcA39MMh+5JJSXYn5FfZsmVKs0iNk9o4943
   d0wBBjD+DmzQgnY/IFKtLvxf4kDKlyaOu7h3G4SEVu6BzwDaueuM/vTLT
   lopaaOoZPyYxZJN8HOw83pfokG0ytU68LvwvRlr/wzkpT9pofLq978A3H
   fX0UIer2V6RjqjvQbiGC5mtiNDGUrp0kLZ2WOrwTtfZsDXc1JYLs+sNdO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="311591323"
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="311591323"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 18:26:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="766548419"
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="766548419"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.238.5.72]) ([10.238.5.72])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 18:26:45 -0800
Message-ID: <e6fdcfeb-bd78-6906-f2b2-94c765be7902@intel.com>
Date:   Wed, 23 Nov 2022 10:26:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH v2 036/144] KVM: selftest: Add proper helpers for
 x86-specific save/restore ioctls
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-37-seanjc@google.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <20220603004331.1523888-37-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/3/2022 8:41 AM, Sean Christopherson wrote:
> Add helpers for the various one-off helpers used by x86's vCPU state
> save/restore helpers, and convert the other open coded ioctl()s to use
> existing helpers.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h  |  54 ++++++++
>  .../selftests/kvm/lib/x86_64/processor.c      | 126 +++++-------------
>  2 files changed, 91 insertions(+), 89 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index e4268432cfe8..1d46d60bb480 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -432,6 +432,60 @@ const struct kvm_msr_list *kvm_get_feature_msr_index_list(void);
>  bool kvm_msr_is_in_save_restore_list(uint32_t msr_index);
>  uint64_t kvm_get_feature_msr(uint64_t msr_index);
>  
> +static inline void vcpu_msrs_get(struct kvm_vm *vm, uint32_t vcpuid,
> +				 struct kvm_msrs *msrs)
> +{
> +	int r = __vcpu_ioctl(vm, vcpuid, KVM_GET_MSRS, msrs);
> +
> +	TEST_ASSERT(r == msrs->nmsrs,
> +		    "KVM_GET_MSRS failed, r: %i (failed on MSR %x)",
> +		    r, r < 0 || r >= msrs->nmsrs ? -1 : msrs->entries[r].index);
> +}
> +static inline void vcpu_msrs_set(struct kvm_vm *vm, uint32_t vcpuid,
> +				 struct kvm_msrs *msrs)
> +{
> +	int r = __vcpu_ioctl(vm, vcpuid, KVM_SET_MSRS, msrs);
> +
> +	TEST_ASSERT(r == msrs->nmsrs,
> +		    "KVM_GET_MSRS failed, r: %i (failed on MSR %x)",

Hi, Sean, this should be the "KVM_SET_MSRS failed", right?

> +		    r, r < 0 || r >= msrs->nmsrs ? -1 : msrs->entries[r].index);
> +}
> +static inline void vcpu_debugregs_get(struct kvm_vm *vm, uint32_t vcpuid,
> +				      struct kvm_debugregs *debugregs)
> +{
> +	vcpu_ioctl(vm, vcpuid, KVM_GET_DEBUGREGS, debugregs);
> +}
> +static inline void vcpu_debugregs_set(struct kvm_vm *vm, uint32_t vcpuid,
> +				      struct kvm_debugregs *debugregs)
> +{
> +	vcpu_ioctl(vm, vcpuid, KVM_SET_DEBUGREGS, debugregs);
> +}
> +static inline void vcpu_xsave_get(struct kvm_vm *vm, uint32_t vcpuid,
> +				  struct kvm_xsave *xsave)
> +{
> +	vcpu_ioctl(vm, vcpuid, KVM_GET_XSAVE, xsave);
> +}
> +static inline void vcpu_xsave2_get(struct kvm_vm *vm, uint32_t vcpuid,
> +				   struct kvm_xsave *xsave)
> +{
> +	vcpu_ioctl(vm, vcpuid, KVM_GET_XSAVE2, xsave);
> +}
> +static inline void vcpu_xsave_set(struct kvm_vm *vm, uint32_t vcpuid,
> +				  struct kvm_xsave *xsave)
> +{
> +	vcpu_ioctl(vm, vcpuid, KVM_SET_XSAVE, xsave);
> +}
> +static inline void vcpu_xcrs_get(struct kvm_vm *vm, uint32_t vcpuid,
> +				 struct kvm_xcrs *xcrs)
> +{
> +	vcpu_ioctl(vm, vcpuid, KVM_GET_XCRS, xcrs);
> +}
> +static inline void vcpu_xcrs_set(struct kvm_vm *vm, uint32_t vcpuid,
> +				 struct kvm_xcrs *xcrs)
> +{
> +	vcpu_ioctl(vm, vcpuid, KVM_SET_XCRS, xcrs);
> +}
> +
>  struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
>  struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
>  
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 9268537f9bd7..5c92e96300c5 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -815,13 +815,11 @@ uint64_t vcpu_get_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index)
>  		struct kvm_msrs header;
>  		struct kvm_msr_entry entry;
>  	} buffer = {};
> -	int r;
>  
>  	buffer.header.nmsrs = 1;
>  	buffer.entry.index = msr_index;
>  
> -	r = __vcpu_ioctl(vm, vcpuid, KVM_GET_MSRS, &buffer.header);
> -	TEST_ASSERT(r == 1, KVM_IOCTL_ERROR(KVM_GET_MSRS, r));
> +	vcpu_msrs_get(vm, vcpuid, &buffer.header);
>  
>  	return buffer.entry.data;
>  }
> @@ -958,28 +956,26 @@ bool kvm_msr_is_in_save_restore_list(uint32_t msr_index)
>  	return false;
>  }
>  
> -static int vcpu_save_xsave_state(struct kvm_vm *vm, struct vcpu *vcpu,
> -				 struct kvm_x86_state *state)
> +static void vcpu_save_xsave_state(struct kvm_vm *vm, uint32_t vcpuid,
> +				  struct kvm_x86_state *state)
>  {
> -	int size;
> +	int size = vm_check_cap(vm, KVM_CAP_XSAVE2);
>  
> -	size = vm_check_cap(vm, KVM_CAP_XSAVE2);
> -	if (!size)
> -		size = sizeof(struct kvm_xsave);
> -
> -	state->xsave = malloc(size);
> -	if (size == sizeof(struct kvm_xsave))
> -		return ioctl(vcpu->fd, KVM_GET_XSAVE, state->xsave);
> -	else
> -		return ioctl(vcpu->fd, KVM_GET_XSAVE2, state->xsave);
> +	if (size) {
> +		state->xsave = malloc(size);
> +		vcpu_xsave2_get(vm, vcpuid, state->xsave);
> +	} else {
> +		state->xsave = malloc(sizeof(struct kvm_xsave));
> +		vcpu_xsave_get(vm, vcpuid, state->xsave);
> +	}
>  }
>  
>  struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
>  {
>  	const struct kvm_msr_list *msr_list = kvm_get_msr_index_list();
> -	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
>  	struct kvm_x86_state *state;
> -	int r, i;
> +	int i;
> +
>  	static int nested_size = -1;
>  
>  	if (nested_size == -1) {
> @@ -998,102 +994,54 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
>  	vcpu_run_complete_io(vm, vcpuid);
>  
>  	state = malloc(sizeof(*state) + msr_list->nmsrs * sizeof(state->msrs.entries[0]));
> -	r = ioctl(vcpu->fd, KVM_GET_VCPU_EVENTS, &state->events);
> -	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_VCPU_EVENTS, r: %i",
> -		    r);
>  
> -	r = ioctl(vcpu->fd, KVM_GET_MP_STATE, &state->mp_state);
> -	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_MP_STATE, r: %i",
> -		    r);
> +	vcpu_events_get(vm, vcpuid, &state->events);
> +	vcpu_mp_state_get(vm, vcpuid, &state->mp_state);
> +	vcpu_regs_get(vm, vcpuid, &state->regs);
> +	vcpu_save_xsave_state(vm, vcpuid, state);
>  
> -	r = ioctl(vcpu->fd, KVM_GET_REGS, &state->regs);
> -	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_REGS, r: %i",
> -		    r);
> +	if (kvm_check_cap(KVM_CAP_XCRS))
> +		vcpu_xcrs_get(vm, vcpuid, &state->xcrs);
>  
> -	r = vcpu_save_xsave_state(vm, vcpu, state);
> -	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_XSAVE, r: %i",
> -		    r);
> -
> -	if (kvm_check_cap(KVM_CAP_XCRS)) {
> -		r = ioctl(vcpu->fd, KVM_GET_XCRS, &state->xcrs);
> -		TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_XCRS, r: %i",
> -			    r);
> -	}
> -
> -	r = ioctl(vcpu->fd, KVM_GET_SREGS, &state->sregs);
> -	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_SREGS, r: %i",
> -		    r);
> +	vcpu_sregs_get(vm, vcpuid, &state->sregs);
>  
>  	if (nested_size) {
>  		state->nested.size = sizeof(state->nested_);
> -		r = ioctl(vcpu->fd, KVM_GET_NESTED_STATE, &state->nested);
> -		TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_NESTED_STATE, r: %i",
> -			    r);
> +
> +		vcpu_nested_state_get(vm, vcpuid, &state->nested);
>  		TEST_ASSERT(state->nested.size <= nested_size,
>  			    "Nested state size too big, %i (KVM_CHECK_CAP gave %i)",
>  			    state->nested.size, nested_size);
> -	} else
> +	} else {
>  		state->nested.size = 0;
> +	}
>  
>  	state->msrs.nmsrs = msr_list->nmsrs;
>  	for (i = 0; i < msr_list->nmsrs; i++)
>  		state->msrs.entries[i].index = msr_list->indices[i];
> -	r = ioctl(vcpu->fd, KVM_GET_MSRS, &state->msrs);
> -	TEST_ASSERT(r == msr_list->nmsrs, "Unexpected result from KVM_GET_MSRS, r: %i (failed MSR was 0x%x)",
> -		    r, r == msr_list->nmsrs ? -1 : msr_list->indices[r]);
> +	vcpu_msrs_get(vm, vcpuid, &state->msrs);
>  
> -	r = ioctl(vcpu->fd, KVM_GET_DEBUGREGS, &state->debugregs);
> -	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_DEBUGREGS, r: %i",
> -		    r);
> +	vcpu_debugregs_get(vm, vcpuid, &state->debugregs);
>  
>  	return state;
>  }
>  
>  void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *state)
>  {
> -	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
> -	int r;
> +	vcpu_sregs_set(vm, vcpuid, &state->sregs);
> +	vcpu_msrs_set(vm, vcpuid, &state->msrs);
>  
> -	r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
> -	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i",
> -		    r);
> +	if (kvm_check_cap(KVM_CAP_XCRS))
> +		vcpu_xcrs_set(vm, vcpuid, &state->xcrs);
>  
> -	r = ioctl(vcpu->fd, KVM_SET_MSRS, &state->msrs);
> -	TEST_ASSERT(r == state->msrs.nmsrs,
> -		"Unexpected result from KVM_SET_MSRS, r: %i (failed at %x)",
> -		r, r == state->msrs.nmsrs ? -1 : state->msrs.entries[r].index);
> +	vcpu_xsave_set(vm, vcpuid,  state->xsave);
> +	vcpu_events_set(vm, vcpuid, &state->events);
> +	vcpu_mp_state_set(vm, vcpuid, &state->mp_state);
> +	vcpu_debugregs_set(vm, vcpuid, &state->debugregs);
> +	vcpu_regs_set(vm, vcpuid, &state->regs);
>  
> -	if (kvm_check_cap(KVM_CAP_XCRS)) {
> -		r = ioctl(vcpu->fd, KVM_SET_XCRS, &state->xcrs);
> -		TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XCRS, r: %i",
> -			    r);
> -	}
> -
> -	r = ioctl(vcpu->fd, KVM_SET_XSAVE, state->xsave);
> -	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i",
> -		    r);
> -
> -	r = ioctl(vcpu->fd, KVM_SET_VCPU_EVENTS, &state->events);
> -	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_VCPU_EVENTS, r: %i",
> -		    r);
> -
> -	r = ioctl(vcpu->fd, KVM_SET_MP_STATE, &state->mp_state);
> -	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_MP_STATE, r: %i",
> -		    r);
> -
> -	r = ioctl(vcpu->fd, KVM_SET_DEBUGREGS, &state->debugregs);
> -	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_DEBUGREGS, r: %i",
> -		    r);
> -
> -	r = ioctl(vcpu->fd, KVM_SET_REGS, &state->regs);
> -	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_REGS, r: %i",
> -		    r);
> -
> -	if (state->nested.size) {
> -		r = ioctl(vcpu->fd, KVM_SET_NESTED_STATE, &state->nested);
> -		TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_NESTED_STATE, r: %i",
> -			    r);
> -	}
> +	if (state->nested.size)
> +		vcpu_nested_state_set(vm, vcpuid, &state->nested);
>  }
>  
>  void kvm_x86_state_cleanup(struct kvm_x86_state *state)
