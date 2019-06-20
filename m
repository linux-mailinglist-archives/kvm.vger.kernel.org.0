Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1AE44CD8C
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 14:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731823AbfFTMSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 08:18:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33226 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730886AbfFTMSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 08:18:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so2844256wru.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 05:18:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=4Enp7W0ESdkTTd9HBh/ANelF/DbInTnKEbgmPM5TYt4=;
        b=b0Z6O3OS7N847rUz8k6kvcybzEogwQWVNQN2H/fbyWDhG2kzk11CJqZ3VWxRDAJznO
         TUchu9ABmJdgqggE8D/95ZgUDU81u1l3sYVDT0hR06snkawEKF9FeXFKUDn8GF0oOAre
         X9MFnwzPo+Ol0knk+/i20rXP8EG2hc1xcq7fZx7q3IiYdErWnjAogArCTaL95AZpBxM4
         +k7zXTVudG1ijJKa2dDlTzz3r4WT0l84kEXI2tkzjTGDGsEFYwZwqtf8UpCJH1P+tXr9
         ug2q3Phb5s4Dn40RK3CjsdGgeK+fI+TtwaAPJ4LjFOt2RGcF26EB0mqi5Ay8HrbQEyd4
         w/BA==
X-Gm-Message-State: APjAAAVSWg2gDIZUASwrKDDA+bu5UjmqpwLtZQZ3poh2XFqqx4ekwd+o
        xy+4NcqjSdG+pmuyhMU1514vmggGdEA=
X-Google-Smtp-Source: APXvYqw0a0Atzq/xJ79+F6gAc8zeGL5JH3frFK3lbZdQKk6lxNUQWMXbkclgr9eyYNAX/Q6pZQKdcA==
X-Received: by 2002:adf:eacd:: with SMTP id o13mr19533546wrn.91.1561033120821;
        Thu, 20 Jun 2019 05:18:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id r5sm30834313wrg.10.2019.06.20.05.18.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 05:18:40 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: reorganize initial steps of vmx_set_nested_state
In-Reply-To: <1560959396-13969-1-git-send-email-pbonzini@redhat.com>
References: <1560959396-13969-1-git-send-email-pbonzini@redhat.com>
Date:   Thu, 20 Jun 2019 14:18:39 +0200
Message-ID: <87zhmcfo0w.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Commit 332d079735f5 ("KVM: nVMX: KVM_SET_NESTED_STATE - Tear down old EVMCS
> state before setting new state", 2019-05-02) broke evmcs_test because the
> eVMCS setup must be performed even if there is no VMXON region defined,
> as long as the eVMCS bit is set in the assist page.
>
> While the simplest possible fix would be to add a check on
> kvm_state->flags & KVM_STATE_NESTED_EVMCS in the initial "if" that
> covers kvm_state->hdr.vmx.vmxon_pa == -1ull, that is quite ugly.
>
> Instead, this patch moves checks earlier in the function and
> conditionalizes them on kvm_state->hdr.vmx.vmxon_pa, so that
> vmx_set_nested_state always goes through vmx_leave_nested
> and nested_enable_evmcs.
>
> Fixes: 332d079735f5

checkpatch.pl will likely complain here asking for full description, e.g.

Fixes: 332d079735f5 ("KVM: nVMX: KVM_SET_NESTED_STATE - Tear down old EVMCS state before setting new state")

There's also something wrong with the patch as it fails to apply because
of (not only?) whitespace issues or maybe I'm just applying it to the
wrong tree...

> Cc: Aaron Lewis <aaronlewis@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Enlightened VMCS migration is just a 'theoretical' feature atm, we don't
know if it actually works but it's good we have a selftest for it so we
know when it definitely doesn't :-)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

> ---
>  arch/x86/kvm/vmx/nested.c                          | 26 ++++++++++--------
>  .../kvm/x86_64/vmx_set_nested_state_test.c         | 32 ++++++++++++++--------
>  2 files changed, 35 insertions(+), 23 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index fb6d1f7b43f3..5f9c1a200201 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5343,9 +5343,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  	if (kvm_state->format != KVM_STATE_NESTED_FORMAT_VMX)
>  		return -EINVAL;
>  
> -	if (!nested_vmx_allowed(vcpu))
> -		return kvm_state->hdr.vmx.vmxon_pa == -1ull ? 0 : -EINVAL;
> -
>  	if (kvm_state->hdr.vmx.vmxon_pa == -1ull) {
>  		if (kvm_state->hdr.vmx.smm.flags)
>  			return -EINVAL;
> @@ -5353,12 +5350,15 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  		if (kvm_state->hdr.vmx.vmcs12_pa != -1ull)
>  			return -EINVAL;
>  
> -		vmx_leave_nested(vcpu);
> -		return 0;
> -	}
> +		if (kvm_state->flags & ~KVM_STATE_NESTED_EVMCS)
> +			return -EINVAL;
> +	} else {
> +		if (!nested_vmx_allowed(vcpu))
> +			return -EINVAL;
>  
> -	if (!page_address_valid(vcpu, kvm_state->hdr.vmx.vmxon_pa))
> -		return -EINVAL;
> +		if (!page_address_valid(vcpu, kvm_state->hdr.vmx.vmxon_pa))
> +			return -EINVAL;
> +    	}
>  
>  	if ((kvm_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_GUEST_MODE) &&
>  	    (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
> @@ -5381,11 +5381,15 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  		return -EINVAL;
>  
>  	vmx_leave_nested(vcpu);
> -	if (kvm_state->hdr.vmx.vmxon_pa == -1ull)
> -		return 0;
> +	if (kvm_state->flags & KVM_STATE_NESTED_EVMCS) {
> +		if (!nested_vmx_allowed(vcpu))
> +			return -EINVAL;
>  
> -	if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
>  		nested_enable_evmcs(vcpu, NULL);
> +	}
> +
> +	if (kvm_state->hdr.vmx.vmxon_pa == -1ull)
> +		return 0;
>  
>  	vmx->nested.vmxon_ptr = kvm_state->hdr.vmx.vmxon_pa;
>  	ret = enter_vmx_operation(vcpu);
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
> index 0648fe6df5a8..e64ca20b315a 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
> @@ -123,36 +123,44 @@ void test_vmx_nested_state(struct kvm_vm *vm)
>  	/*
>  	 * We cannot virtualize anything if the guest does not have VMX
>  	 * enabled.  We expect KVM_SET_NESTED_STATE to return 0 if vmxon_pa
> -	 * is set to -1ull.
> +	 * is set to -1ull, but the flags must be zero.
>  	 */
>  	set_default_vmx_state(state, state_sz);
>  	state->hdr.vmx.vmxon_pa = -1ull;
> +	test_nested_state_expect_einval(vm, state);
> +
> +	state->hdr.vmx.vmcs12_pa = -1ull;
> +	state->flags = KVM_STATE_NESTED_EVMCS;
> +	test_nested_state_expect_einval(vm, state);
> +
> +	state->flags = 0;
>  	test_nested_state(vm, state);
>  
>  	/* Enable VMX in the guest CPUID. */
>  	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
>  
> -	/* It is invalid to have vmxon_pa == -1ull and SMM flags non-zero. */
> +	/*
> +	 * Setting vmxon_pa == -1ull and vmcs_pa == -1ull exits early without
> +	 * setting the nested state but flags other than eVMCS must be clear.
> +	 */
>  	set_default_vmx_state(state, state_sz);
>  	state->hdr.vmx.vmxon_pa = -1ull;
> +	state->hdr.vmx.vmcs12_pa = -1ull;
> +	test_nested_state_expect_einval(vm, state);
> +
> +	state->flags = KVM_STATE_NESTED_EVMCS;
> +	test_nested_state(vm, state);
> +
> +	/* It is invalid to have vmxon_pa == -1ull and SMM flags non-zero. */
>  	state->hdr.vmx.smm.flags = 1;
>  	test_nested_state_expect_einval(vm, state);
>  
>  	/* It is invalid to have vmxon_pa == -1ull and vmcs_pa != -1ull. */
>  	set_default_vmx_state(state, state_sz);
>  	state->hdr.vmx.vmxon_pa = -1ull;
> -	state->hdr.vmx.vmcs12_pa = 0;
> +	state->flags = 0;
>  	test_nested_state_expect_einval(vm, state);
>  
> -	/*
> -	 * Setting vmxon_pa == -1ull and vmcs_pa == -1ull exits early without
> -	 * setting the nested state.
> -	 */
> -	set_default_vmx_state(state, state_sz);
> -	state->hdr.vmx.vmxon_pa = -1ull;
> -	state->hdr.vmx.vmcs12_pa = -1ull;
> -	test_nested_state(vm, state);
> -
>  	/* It is invalid to have vmxon_pa set to a non-page aligned address. */
>  	set_default_vmx_state(state, state_sz);
>  	state->hdr.vmx.vmxon_pa = 1;

-- 
Vitaly
