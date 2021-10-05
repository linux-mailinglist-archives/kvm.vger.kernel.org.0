Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3EA422833
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbhJENrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:47:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234274AbhJENrf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:47:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633441544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=42UgaX+yPPSur2IHewijgtsVBHiFLbM3G0lScESYZo4=;
        b=MhNY0cB+S5GAl0sjrZYMnJPhu65Wu+ZiM9lqAWbX9ewIFjEzt4EeswRZSPOoJwCCVNCSuc
        iuucxMoDStXMDupZmplWtVuzPTx1MjmqCwXtu5YK/E+M405NtVCtsVBerl49kxS2jwtfgu
        C/CdwO50MyFYuX18dcwgMi2R25ZZriQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-5BwHynIpP1SKrccsa-hgoQ-1; Tue, 05 Oct 2021 09:45:43 -0400
X-MC-Unique: 5BwHynIpP1SKrccsa-hgoQ-1
Received: by mail-ed1-f70.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so20645810ede.16
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 06:45:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=42UgaX+yPPSur2IHewijgtsVBHiFLbM3G0lScESYZo4=;
        b=elUB3KKVzrLMwDdR5m0KeJi1cZalyo+/CWEmjq1DAv47PCfVgfx62ZSFlsr7Y0vg8I
         fUph6GT7FIhsDrJsX1NneXpOhn4rFKppy6prYOMb09Yzx7Y407iIUCNL//ByyY4ESmvh
         fgm614cVdB0o2WAU7n5gShCp7fnNnZBFvhXZV1rLk7/Z5JOSWGBMIbXlYmY2GFSWNcsp
         SmVjEbgcRE23txyLuuSyohr5dGxdw5/xx5YDpC4qm7A6Ir5An7H4GCVOLnFh6FCh5Htq
         le5vNY5Y4BrfRogyyel3tAzurZgvIrtWKFlV+hbI/pmk5qYrbVg+O58QTw/ISehzWcEH
         IQzQ==
X-Gm-Message-State: AOAM532GnErkB5GzQewLEoEFujR0Y2AEytWEhWDyI1q2Jzz56WPI+niq
        8wONUX3V8GgNywWJfo33iV15AnoDA43fDJs8NnKlKj1c14h9zWA1l2H9uKwNxJNDrKIUAs7Y5ic
        GMeWAiSUFi/nu
X-Received: by 2002:a17:907:77c8:: with SMTP id kz8mr19917204ejc.406.1633441542552;
        Tue, 05 Oct 2021 06:45:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHs6aQU5utBmnbI84MI2Vww5ChForJLtR0LWAJm21f+VNfybnM0FYZWxhpyBNbkbiUjUdlGA==
X-Received: by 2002:a17:907:77c8:: with SMTP id kz8mr19917184ejc.406.1633441542365;
        Tue, 05 Oct 2021 06:45:42 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id de36sm8145995ejc.72.2021.10.05.06.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 06:45:41 -0700 (PDT)
Date:   Tue, 5 Oct 2021 15:45:39 +0200
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
Subject: Re: [PATCH v2 10/11] selftests: KVM: Refactor psci_test to make it
 amenable to new tests
Message-ID: <20211005134539.s7kzhqlg2pykfcam@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-11-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923191610.3814698-11-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 07:16:09PM +0000, Oliver Upton wrote:
> Split up the current test into several helpers that will be useful to
> subsequent test cases added to the PSCI test suite.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/psci_test.c | 68 ++++++++++++-------
>  1 file changed, 45 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
> index 8d043e12b137..90312be335da 100644
> --- a/tools/testing/selftests/kvm/aarch64/psci_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
> @@ -45,7 +45,7 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
>  	return res.a0;
>  }
>  
> -static void guest_main(uint64_t target_cpu)
> +static void guest_test_cpu_on(uint64_t target_cpu)
>  {
>  	GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
>  	uint64_t target_state;
> @@ -69,12 +69,10 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
>  	vcpu_set_mp_state(vm, vcpuid, &mp_state);
>  }
>  
> -int main(void)
> +static struct kvm_vm *setup_vm(void *guest_code)
>  {
> -	uint64_t target_mpidr, obs_pc, obs_x0;
>  	struct kvm_vcpu_init init;
>  	struct kvm_vm *vm;
> -	struct ucall uc;
>  
>  	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
>  	kvm_vm_elf_load(vm, program_invocation_name);
> @@ -83,31 +81,28 @@ int main(void)
>  	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
>  	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
>  
> -	aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_main);
> -	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
> +	aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_code);
> +	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_code);
>  
> -	/*
> -	 * make sure the target is already off when executing the test.
> -	 */
> -	vcpu_power_off(vm, VCPU_ID_TARGET);
> +	return vm;
> +}
>  
> -	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> -	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
> -	vcpu_run(vm, VCPU_ID_SOURCE);
> +static void enter_guest(struct kvm_vm *vm, uint32_t vcpuid)
> +{
> +	struct ucall uc;
>  
> -	switch (get_ucall(vm, VCPU_ID_SOURCE, &uc)) {
> -	case UCALL_DONE:
> -		break;
> -	case UCALL_ABORT:
> +	vcpu_run(vm, vcpuid);
> +	if (get_ucall(vm, vcpuid, &uc) == UCALL_ABORT)
>  		TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0], __FILE__,
>  			  uc.args[1]);
> -		break;
> -	default:
> -		TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
> -	}
> +}
>  
> -	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.pc), &obs_pc);
> -	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
> +static void assert_vcpu_reset(struct kvm_vm *vm, uint32_t vcpuid)
> +{
> +	uint64_t obs_pc, obs_x0;
> +
> +	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), &obs_pc);
> +	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
>  
>  	TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
>  		    "unexpected target cpu pc: %lx (expected: %lx)",
> @@ -115,7 +110,34 @@ int main(void)
>  	TEST_ASSERT(obs_x0 == CPU_ON_CONTEXT_ID,
>  		    "unexpected target context id: %lx (expected: %lx)",
>  		    obs_x0, CPU_ON_CONTEXT_ID);
> +}
>  
> +static void host_test_cpu_on(void)
> +{
> +	uint64_t target_mpidr;
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +
> +	vm = setup_vm(guest_test_cpu_on);
> +
> +	/*
> +	 * make sure the target is already off when executing the test.
> +	 */
> +	vcpu_power_off(vm, VCPU_ID_TARGET);
> +
> +	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> +	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
> +	enter_guest(vm, VCPU_ID_SOURCE);
> +
> +	if (get_ucall(vm, VCPU_ID_SOURCE, &uc) != UCALL_DONE)
> +		TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
> +
> +	assert_vcpu_reset(vm, VCPU_ID_TARGET);
>  	kvm_vm_free(vm);
> +}
> +
> +int main(void)
> +{
> +	host_test_cpu_on();
>  	return 0;
>  }
> -- 
> 2.33.0.685.g46640cef36-goog
>

Hard to read diff, but I think the refactoring comes out right. Please do
this refactoring before adding the new test in the next revision, though.

Anyway, ignoring the new test context, which I think is changing with the
next revision

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

