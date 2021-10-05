Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7370C422B89
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 16:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbhJEO4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 10:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhJEO4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 10:56:07 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51AFC061749
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 07:54:16 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id y23so48031831lfb.0
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 07:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oeEs3eMOlEupf6UUcoQibPqVHwuKrUKDBy8LbYPEqoA=;
        b=aAdD3HDLKufLpxvfw0oGt+CD/52iSjYVFKTbMfXrcgeIWKy/ANG/EOvtDTstbiZjUD
         vHOWVCtkQiIVyOCjDOLKNQ9WRTDkTnW7pDJ8UuAmqg1CHUT16Xsmu0KoHfWZFvM+iuzN
         t8K7TSc5VrhuLZ76BwUsl54GmSEKEY3JVH/dze9QJSUviRrlxt4XKyzW4xsXjhqlT0Rf
         goG9zd8VWIGLcYdzg9gN7j2qPqssd5HfnKCj5jgv3HBDeA/+PE928o1AOtWyRAnCwxDZ
         nK/seETkoeRizucnfoDV+m96VScxwz1vVpiW3ajBDelpeQrufEGwu0B8DV5DL4ToNRzx
         yBeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oeEs3eMOlEupf6UUcoQibPqVHwuKrUKDBy8LbYPEqoA=;
        b=ypztME/ktT+ugTT1KFFKxWLml86FqRP6FJog8FIP9Wv1wEiFnzk+D3MqgQ0cKQSBnA
         utPql2+UR+pb2faNAmoRG84LtAGs1mvRlC3jk9zsNPJZ+pF925AH5ecTFK2ql/QmI5Db
         4jrlhNDsPxGGl+40pk6Z5/jeY71ggdpg2rIKDVlZKCo7xAMHV+LOT62Cmuhay+QFideX
         y17VIQB+ysCZ7IL61wdfghe2HbmUNgdqJLijKHtR8Rcm6aqRSCIPTbEBsV7vWpev3+Cl
         +XyDYOUJ+cmwAUM+Tw80V7Ze3j9qdScvy4JfrJGyCjuHS2RDsAPj4c3hd0nJcaxI0Jil
         fttg==
X-Gm-Message-State: AOAM531OHwXGsOP5UIjAufN+28iA7x7q0pURqLDCmA40UQ4yI5BX8Xnr
        fuCPhKqtT1szMqt+fVxgmWhXUZrui7h/Z13KD4/zbw==
X-Google-Smtp-Source: ABdhPJyMTR6su6M9JlR0TJe8fr8yMC+jDLWW2Ybj4JUSc+O7b6KU84U7G8Up+QrZwUDi/aCBdOK6JBGjZtL/iGUTRlg=
X-Received: by 2002:ac2:4217:: with SMTP id y23mr3879463lfh.361.1633445653503;
 Tue, 05 Oct 2021 07:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com> <20210923191610.3814698-11-oupton@google.com>
 <20211005134539.s7kzhqlg2pykfcam@gator.home>
In-Reply-To: <20211005134539.s7kzhqlg2pykfcam@gator.home>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 5 Oct 2021 07:54:01 -0700
Message-ID: <CAOQ_QsjQ28b8OXLR1o8QD=M8dsBKtPLyB-QRyd=D1UVMGy6o0w@mail.gmail.com>
Subject: Re: [PATCH v2 10/11] selftests: KVM: Refactor psci_test to make it
 amenable to new tests
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On Tue, Oct 5, 2021 at 6:45 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Sep 23, 2021 at 07:16:09PM +0000, Oliver Upton wrote:
> > Split up the current test into several helpers that will be useful to
> > subsequent test cases added to the PSCI test suite.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/psci_test.c | 68 ++++++++++++-------
> >  1 file changed, 45 insertions(+), 23 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
> > index 8d043e12b137..90312be335da 100644
> > --- a/tools/testing/selftests/kvm/aarch64/psci_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
> > @@ -45,7 +45,7 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
> >       return res.a0;
> >  }
> >
> > -static void guest_main(uint64_t target_cpu)
> > +static void guest_test_cpu_on(uint64_t target_cpu)
> >  {
> >       GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
> >       uint64_t target_state;
> > @@ -69,12 +69,10 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
> >       vcpu_set_mp_state(vm, vcpuid, &mp_state);
> >  }
> >
> > -int main(void)
> > +static struct kvm_vm *setup_vm(void *guest_code)
> >  {
> > -     uint64_t target_mpidr, obs_pc, obs_x0;
> >       struct kvm_vcpu_init init;
> >       struct kvm_vm *vm;
> > -     struct ucall uc;
> >
> >       vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> >       kvm_vm_elf_load(vm, program_invocation_name);
> > @@ -83,31 +81,28 @@ int main(void)
> >       vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> >       init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
> >
> > -     aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_main);
> > -     aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
> > +     aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_code);
> > +     aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_code);
> >
> > -     /*
> > -      * make sure the target is already off when executing the test.
> > -      */
> > -     vcpu_power_off(vm, VCPU_ID_TARGET);
> > +     return vm;
> > +}
> >
> > -     get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> > -     vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
> > -     vcpu_run(vm, VCPU_ID_SOURCE);
> > +static void enter_guest(struct kvm_vm *vm, uint32_t vcpuid)
> > +{
> > +     struct ucall uc;
> >
> > -     switch (get_ucall(vm, VCPU_ID_SOURCE, &uc)) {
> > -     case UCALL_DONE:
> > -             break;
> > -     case UCALL_ABORT:
> > +     vcpu_run(vm, vcpuid);
> > +     if (get_ucall(vm, vcpuid, &uc) == UCALL_ABORT)
> >               TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0], __FILE__,
> >                         uc.args[1]);
> > -             break;
> > -     default:
> > -             TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
> > -     }
> > +}
> >
> > -     get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.pc), &obs_pc);
> > -     get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
> > +static void assert_vcpu_reset(struct kvm_vm *vm, uint32_t vcpuid)
> > +{
> > +     uint64_t obs_pc, obs_x0;
> > +
> > +     get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), &obs_pc);
> > +     get_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
> >
> >       TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
> >                   "unexpected target cpu pc: %lx (expected: %lx)",
> > @@ -115,7 +110,34 @@ int main(void)
> >       TEST_ASSERT(obs_x0 == CPU_ON_CONTEXT_ID,
> >                   "unexpected target context id: %lx (expected: %lx)",
> >                   obs_x0, CPU_ON_CONTEXT_ID);
> > +}
> >
> > +static void host_test_cpu_on(void)
> > +{
> > +     uint64_t target_mpidr;
> > +     struct kvm_vm *vm;
> > +     struct ucall uc;
> > +
> > +     vm = setup_vm(guest_test_cpu_on);
> > +
> > +     /*
> > +      * make sure the target is already off when executing the test.
> > +      */
> > +     vcpu_power_off(vm, VCPU_ID_TARGET);
> > +
> > +     get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> > +     vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
> > +     enter_guest(vm, VCPU_ID_SOURCE);
> > +
> > +     if (get_ucall(vm, VCPU_ID_SOURCE, &uc) != UCALL_DONE)
> > +             TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
> > +
> > +     assert_vcpu_reset(vm, VCPU_ID_TARGET);
> >       kvm_vm_free(vm);
> > +}
> > +
> > +int main(void)
> > +{
> > +     host_test_cpu_on();
> >       return 0;
> >  }
> > --
> > 2.33.0.685.g46640cef36-goog
> >
>
> Hard to read diff, but I think the refactoring comes out right.

Yeah, this one's nasty, sorry about that. Thanks for parsing it out, heh.

> Please do this refactoring before adding the new test in the next revision, though.
>

This is 10/11 in the series, and the test is 11/11. I'm not seeing any
context belonging to the last patch, but perhaps I'm missing something
obvious.

> Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks!

--
Best,
Oliver
