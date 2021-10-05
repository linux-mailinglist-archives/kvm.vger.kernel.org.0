Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3854228A3
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbhJENxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:53:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33693 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235200AbhJENvZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633441774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sN1cJhbytrAM9N4QAPFZhEFWhJvN3WJabYiHuROOQxA=;
        b=HoWWg1XoCDtURU6JQisAVf+WMecfn4jtWUTlduuDMjGB/amz3hSbL+5xuVYR7ZkNOVq9ZW
        EbaL9Wsgvag/PZoXoZyFdSvw7owDSoe161UrllLfAZxR3gCUmvFzO8BuCPQy6L6c6MWdhf
        a/Wtj8+I0u6Ldx6ri3Wmz8KlxKJf2mQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-mUmEXwLUNsK-pO_7t_anKQ-1; Tue, 05 Oct 2021 09:49:33 -0400
X-MC-Unique: mUmEXwLUNsK-pO_7t_anKQ-1
Received: by mail-ed1-f71.google.com with SMTP id c30-20020a50f61e000000b003daf3955d5aso6155578edn.4
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 06:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sN1cJhbytrAM9N4QAPFZhEFWhJvN3WJabYiHuROOQxA=;
        b=hlNQgtJq7qmYjjX9Q7gELTwChnsGu28vpUSZtqx7K0Rl/koQcI6/ugclJ9JtPJ7n5r
         HiDySvS+l4STDCNu3XR2fbDSxHCJ4EDxFQjQmw1ClOJLt59+aDuxZliaO2M/898oG1CP
         UlKGMSHD409phuk89fR2D+bXzK+pWW15/Ft44njpsFum//g1dxcHykKpeC9mSW0nLgGU
         1sRBSRRrRCw/HiKzMilIGuKxLrOOfwxwvmFkfjchR9hzJdufn3DsCMNsrhLheDthu+3+
         bsWLjz62JUpdtE3pVIuMC+slIX4UHdh6MrukOgjjV+UgiMy3zQfu4H3snDzav2JKQOys
         dD5g==
X-Gm-Message-State: AOAM5333Fyd7icoBuuqLqtFpCiXR66HY0l9u0qXFhMOFqCNQ+Bcmq1lK
        lxxkBKADayH4IsggVhcFxK+2LQM5gTsel7VqFByknYoX5psJcUg+g0eTUJ30oKtVS7TAdxO6CC2
        UlKPWoMWmzrnL
X-Received: by 2002:a17:906:318f:: with SMTP id 15mr25069225ejy.206.1633441772657;
        Tue, 05 Oct 2021 06:49:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJym9/EkDza9wFdcmrvx39UdAtrbdx4cJu7y3elXK/ktXDerwTAkh0WABPphiEFfAEMKQcp2gA==
X-Received: by 2002:a17:906:318f:: with SMTP id 15mr25069192ejy.206.1633441772425;
        Tue, 05 Oct 2021 06:49:32 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id q17sm8857129edd.57.2021.10.05.06.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 06:49:32 -0700 (PDT)
Date:   Tue, 5 Oct 2021 15:49:30 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 11/11] selftests: KVM: Test SYSTEM_SUSPEND PSCI call
Message-ID: <20211005134930.dxej2lgcjklzouw7@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-12-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923191610.3814698-12-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 07:16:10PM +0000, Oliver Upton wrote:
> Assert that the vCPU exits to userspace with KVM_SYSTEM_EVENT_SUSPEND if
> it correctly executes the SYSTEM_SUSPEND PSCI call. Additionally, assert
> that the guest PSCI call fails if preconditions are not met (more than 1
> running vCPU).
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/psci_test.c | 75 +++++++++++++++++++
>  1 file changed, 75 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
> index 90312be335da..5b881ca4d102 100644
> --- a/tools/testing/selftests/kvm/aarch64/psci_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
> @@ -45,6 +45,16 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
>  	return res.a0;
>  }
>  
> +static uint64_t psci_system_suspend(uint64_t entry_addr, uint64_t context_id)
> +{
> +	struct arm_smccc_res res;
> +
> +	smccc_hvc(PSCI_1_0_FN64_SYSTEM_SUSPEND, entry_addr, context_id,
> +		  0, 0, 0, 0, 0, &res);
> +
> +	return res.a0;
> +}
> +
>  static void guest_test_cpu_on(uint64_t target_cpu)
>  {
>  	GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
> @@ -69,6 +79,13 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
>  	vcpu_set_mp_state(vm, vcpuid, &mp_state);
>  }
>  
> +static void guest_test_system_suspend(void)
> +{
> +	uint64_t r = psci_system_suspend(CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID);
> +
> +	GUEST_SYNC(r);
> +}
> +
>  static struct kvm_vm *setup_vm(void *guest_code)
>  {
>  	struct kvm_vcpu_init init;
> @@ -136,8 +153,66 @@ static void host_test_cpu_on(void)
>  	kvm_vm_free(vm);
>  }
>  
> +static void enable_system_suspend(struct kvm_vm *vm)
> +{
> +	struct kvm_enable_cap cap = {
> +		.cap = KVM_CAP_ARM_SYSTEM_SUSPEND,
> +	};
> +
> +	vm_enable_cap(vm, &cap);
> +}
> +
> +static void host_test_system_suspend(void)
> +{
> +	struct kvm_run *run;
> +	struct kvm_vm *vm;
> +
> +	vm = setup_vm(guest_test_system_suspend);
> +	enable_system_suspend(vm);
> +
> +	vcpu_power_off(vm, VCPU_ID_TARGET);
> +	run = vcpu_state(vm, VCPU_ID_SOURCE);
> +
> +	enter_guest(vm, VCPU_ID_SOURCE);
> +
> +	TEST_ASSERT(run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
> +		    "Unhandled exit reason: %u (%s)",
> +		    run->exit_reason, exit_reason_str(run->exit_reason));
> +	TEST_ASSERT(run->system_event.type == KVM_SYSTEM_EVENT_SUSPEND,
> +		    "Unhandled system event: %u (expected: %u)",
> +		    run->system_event.type, KVM_SYSTEM_EVENT_SUSPEND);
> +
> +	assert_vcpu_reset(vm, VCPU_ID_SOURCE);
> +	kvm_vm_free(vm);
> +}
> +
> +static void host_test_system_suspend_fails(void)
> +{
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +
> +	vm = setup_vm(guest_test_system_suspend);
> +	enable_system_suspend(vm);
> +
> +	enter_guest(vm, VCPU_ID_SOURCE);
> +	TEST_ASSERT(get_ucall(vm, VCPU_ID_SOURCE, &uc) == UCALL_SYNC,
> +		    "Unhandled ucall: %lu", uc.cmd);
> +	TEST_ASSERT(uc.args[1] == PSCI_RET_DENIED,
> +		    "Unrecognized PSCI return code: %lu (expected: %u)",
> +		    uc.args[1], PSCI_RET_DENIED);
> +
> +	kvm_vm_free(vm);
> +}
> +
>  int main(void)
>  {
> +	if (!kvm_check_cap(KVM_CAP_ARM_SYSTEM_SUSPEND)) {
> +		print_skip("KVM_CAP_ARM_SYSTEM_SUSPEND not supported");
> +		exit(KSFT_SKIP);
> +	}

How about only guarding the new tests with this, so we can still do the
cpu_on test when this feature isn't present?

> +
>  	host_test_cpu_on();
> +	host_test_system_suspend();
> +	host_test_system_suspend_fails();
>  	return 0;
>  }
> -- 
> 2.33.0.685.g46640cef36-goog
> 

Thanks,
drew

