Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32FD423084
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 21:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhJETHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 15:07:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28872 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229684AbhJETHb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 15:07:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633460740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dl3aTJvWqGu6seveycGfN6caamqhyrUPV6cp3PR6dwA=;
        b=X4WXoYUgxZDIFZc0LT2ztx3ga9cWoetRanYI0F8r366HE0yRy065p8iP9YcmLQMpCht1Gd
        P86InLm1qYiI2v5s1PcCJgdZFtuAayGhGKbLJvTIJfKIUsw3aYs9ecvWUDteMB4pIzZXc3
        M8gD96VpJcQOpek9n6/eQXo5lbfVfHI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-UwAqCXXJObmOpSHPm4Hd7w-1; Tue, 05 Oct 2021 15:05:39 -0400
X-MC-Unique: UwAqCXXJObmOpSHPm4Hd7w-1
Received: by mail-ed1-f71.google.com with SMTP id k10-20020a508aca000000b003dad77857f7so120146edk.22
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 12:05:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dl3aTJvWqGu6seveycGfN6caamqhyrUPV6cp3PR6dwA=;
        b=klrj42RUXHq/+XgK9jZve5CZMHiNSTb0PKWGAT5MGK75vl6tL+60dDo5gfSYhqQNPy
         Y4DqzybFw800B+IGK+FsT1LwPIU58Zi1ZAkbeQLaLScxQptjjdR0SpAT90XmlfFHF51M
         IEcXV5dsfBhBM7stpSjuoG6aGh8TUvwnyN1w5B5Iz4AW0BwlT5F+sjAO3j3kRz2Xuwe2
         oR0R5+mcK7s4rceaLMSo/OK5gSkRWqPWBALPtqkQ6To4lS+GNECCRCr114AduXePpPdp
         petYmtTPKTwZorXRkP/b6JqPO/hZFEBuVmPizbmgE8/OfJuSflKiIr6TVtcxuP0+kn4e
         bJzw==
X-Gm-Message-State: AOAM53035h1MoJkUJbPg498M0mAJ1Dk+kSelNa1LHTg1nBkRX6yU0UBN
        3tLyrxumF/cSVBW6hC1S5DsvWbTfb9wetTYfeGL+SwhUY6CowncVKwPsSjKlqPWxZYF7kc2+n9r
        TM/YMi64B3BjJ
X-Received: by 2002:a17:907:3e03:: with SMTP id hp3mr26025552ejc.183.1633460738380;
        Tue, 05 Oct 2021 12:05:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyF8eNT+AVYZrVXza6mM5jC46JOKIEFUXE9ObrEwpUyLiPwySHkyfYF0utBleIoX6+4pNLMYw==
X-Received: by 2002:a17:907:3e03:: with SMTP id hp3mr26025507ejc.183.1633460738047;
        Tue, 05 Oct 2021 12:05:38 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id z8sm8114401ejd.94.2021.10.05.12.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 12:05:37 -0700 (PDT)
Date:   Tue, 5 Oct 2021 21:05:35 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 10/11] selftests: KVM: Refactor psci_test to make it
 amenable to new tests
Message-ID: <20211005190535.mxk6do6sbpf4j2c7@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-11-oupton@google.com>
 <20211005134539.s7kzhqlg2pykfcam@gator.home>
 <CAOQ_QsjQ28b8OXLR1o8QD=M8dsBKtPLyB-QRyd=D1UVMGy6o0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QsjQ28b8OXLR1o8QD=M8dsBKtPLyB-QRyd=D1UVMGy6o0w@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 05, 2021 at 07:54:01AM -0700, Oliver Upton wrote:
> Hi Drew,
> 
> On Tue, Oct 5, 2021 at 6:45 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Thu, Sep 23, 2021 at 07:16:09PM +0000, Oliver Upton wrote:
> > > Split up the current test into several helpers that will be useful to
> > > subsequent test cases added to the PSCI test suite.
> > >
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > ---
> > >  .../testing/selftests/kvm/aarch64/psci_test.c | 68 ++++++++++++-------
> > >  1 file changed, 45 insertions(+), 23 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
> > > index 8d043e12b137..90312be335da 100644
> > > --- a/tools/testing/selftests/kvm/aarch64/psci_test.c
> > > +++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
> > > @@ -45,7 +45,7 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
> > >       return res.a0;
> > >  }
> > >
> > > -static void guest_main(uint64_t target_cpu)
> > > +static void guest_test_cpu_on(uint64_t target_cpu)
> > >  {
> > >       GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
> > >       uint64_t target_state;
> > > @@ -69,12 +69,10 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
> > >       vcpu_set_mp_state(vm, vcpuid, &mp_state);
> > >  }

Context from last patch.

> > >
> > > -int main(void)
> > > +static struct kvm_vm *setup_vm(void *guest_code)
> > >  {
> > > -     uint64_t target_mpidr, obs_pc, obs_x0;
> > >       struct kvm_vcpu_init init;
> > >       struct kvm_vm *vm;
> > > -     struct ucall uc;
> > >
> > >       vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> > >       kvm_vm_elf_load(vm, program_invocation_name);
> > > @@ -83,31 +81,28 @@ int main(void)
> > >       vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> > >       init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
> > >
> > > -     aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_main);
> > > -     aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
> > > +     aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_code);
> > > +     aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_code);

Context from last patch.

> > >
> > > -     /*
> > > -      * make sure the target is already off when executing the test.
> > > -      */
> > > -     vcpu_power_off(vm, VCPU_ID_TARGET);
> > > +     return vm;
> > > +}
> > >
> > > -     get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> > > -     vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
> > > -     vcpu_run(vm, VCPU_ID_SOURCE);
> > > +static void enter_guest(struct kvm_vm *vm, uint32_t vcpuid)
> > > +{
> > > +     struct ucall uc;
> > >
> > > -     switch (get_ucall(vm, VCPU_ID_SOURCE, &uc)) {
> > > -     case UCALL_DONE:
> > > -             break;
> > > -     case UCALL_ABORT:
> > > +     vcpu_run(vm, vcpuid);
> > > +     if (get_ucall(vm, vcpuid, &uc) == UCALL_ABORT)
> > >               TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0], __FILE__,
> > >                         uc.args[1]);
> > > -             break;
> > > -     default:
> > > -             TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
> > > -     }
> > > +}
> > >
> > > -     get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.pc), &obs_pc);
> > > -     get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
> > > +static void assert_vcpu_reset(struct kvm_vm *vm, uint32_t vcpuid)
> > > +{
> > > +     uint64_t obs_pc, obs_x0;
> > > +
> > > +     get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), &obs_pc);
> > > +     get_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
> > >
> > >       TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
> > >                   "unexpected target cpu pc: %lx (expected: %lx)",
> > > @@ -115,7 +110,34 @@ int main(void)
> > >       TEST_ASSERT(obs_x0 == CPU_ON_CONTEXT_ID,
> > >                   "unexpected target context id: %lx (expected: %lx)",
> > >                   obs_x0, CPU_ON_CONTEXT_ID);
> > > +}
> > >
> > > +static void host_test_cpu_on(void)
> > > +{
> > > +     uint64_t target_mpidr;
> > > +     struct kvm_vm *vm;
> > > +     struct ucall uc;
> > > +
> > > +     vm = setup_vm(guest_test_cpu_on);
> > > +
> > > +     /*
> > > +      * make sure the target is already off when executing the test.
> > > +      */
> > > +     vcpu_power_off(vm, VCPU_ID_TARGET);
> > > +
> > > +     get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> > > +     vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
> > > +     enter_guest(vm, VCPU_ID_SOURCE);
> > > +
> > > +     if (get_ucall(vm, VCPU_ID_SOURCE, &uc) != UCALL_DONE)
> > > +             TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
> > > +
> > > +     assert_vcpu_reset(vm, VCPU_ID_TARGET);
> > >       kvm_vm_free(vm);
> > > +}
> > > +
> > > +int main(void)
> > > +{
> > > +     host_test_cpu_on();
> > >       return 0;
> > >  }
> > > --
> > > 2.33.0.685.g46640cef36-goog
> > >
> >
> > Hard to read diff, but I think the refactoring comes out right.
> 
> Yeah, this one's nasty, sorry about that. Thanks for parsing it out, heh.
> 
> > Please do this refactoring before adding the new test in the next revision, though.
> >
> 
> This is 10/11 in the series, and the test is 11/11. I'm not seeing any
> context belonging to the last patch, but perhaps I'm missing something
> obvious.

It's not much, but nicer to have none.

Thanks,
drew

> 
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> 
> Thanks!
> 
> --
> Best,
> Oliver
> 

