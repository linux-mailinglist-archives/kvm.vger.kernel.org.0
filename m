Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D044422BDA
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 17:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbhJEPKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 11:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbhJEPKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 11:10:01 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E922DC061749
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 08:08:10 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id m3so86364810lfu.2
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 08:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gfNZfNwUJuypCW0p97c1ewxn6bpSqjVCmzxpI4oPhbM=;
        b=SIhjr28uhixoI7j8SX2mmlbQUd93wYChNWBSRLQooTUZjYmfacxuOuW/I9pXEGkhDw
         lmqyxyo+O59z538e3PhKxrvdKCMjc6w7jjNtrYs3fs0ZOIwMUNDLPYH7CYhm+a8mFuqv
         gib45O+EiQlRS3NQQJhzRbKQfNrSiw02k2nIfWKrWDqu2pQXZ+Ia1+XcvGamtSQ8nC4A
         MsryeeUw3sT3UTxzMLPC9AESdl1TR1oci/HFRDBpHTAwr2S9SGPNRStd3ufZshnXx7s7
         tn73V8mV2X8BYJxIvlwolSAAT2FkLJr6bwXXTqptCyKdZvTXiIASEFprqau/D7Po8IDC
         AvqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gfNZfNwUJuypCW0p97c1ewxn6bpSqjVCmzxpI4oPhbM=;
        b=i/X2nGQ0T9HnB3mF6z4my1ZnQ5pko44O9uCxh9fOYL0mJ5OgSwavqxPGSYfteJ8a0p
         DQEMrfqcAP4dub/EeQLDF7FczdDRcasGKW7qW71LlS0/Qraq/C4K5HG5u46SrpXGRgdI
         QSm+2rJVasXqajuXesrucOS947ICguDOVVEB+vCj4mEgXzMRhd67vA5WJMuID6AtuQBk
         N3Zd5Ua7d8FNz39nlY7CO99G9zZ/i/pbphc7zCtwSDEFiCq+UA/DZgupi3q50BfduDM0
         B6slOt0zHq/G2q7JPvpjE3bSSDodPbP6DgvlTbPQ7h1I9Ijf/35YtUt1xwRlTFicUAQ2
         Mzxw==
X-Gm-Message-State: AOAM533tmfNPv73FFZq5JWxak/pIwsCUsKrZvUUyc9Xf9QnELbpuU7fS
        stvk0ha+iRsNJ06Gr1/tRNQ5WpPdgWxSYMtbSm54ag==
X-Google-Smtp-Source: ABdhPJzLw9VojD9PEhGs/n1Z97cLSFAovX7mtdM5uGgz+hhV2EC9ZBbYqmMTTSdw3aKoUFNZ0qeRBTsklGTwa+oXQZA=
X-Received: by 2002:a2e:b88c:: with SMTP id r12mr23915173ljp.479.1633446458809;
 Tue, 05 Oct 2021 08:07:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com> <20210923191610.3814698-12-oupton@google.com>
 <20211005134930.dxej2lgcjklzouw7@gator.home>
In-Reply-To: <20211005134930.dxej2lgcjklzouw7@gator.home>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 5 Oct 2021 08:07:26 -0700
Message-ID: <CAOQ_Qsibr1dJUtY+h_GS0Gp=DF1G4JU2ECNO8=QFx7Xa6Q+nLQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] selftests: KVM: Test SYSTEM_SUSPEND PSCI call
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

On Tue, Oct 5, 2021 at 6:49 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Sep 23, 2021 at 07:16:10PM +0000, Oliver Upton wrote:
> > Assert that the vCPU exits to userspace with KVM_SYSTEM_EVENT_SUSPEND if
> > it correctly executes the SYSTEM_SUSPEND PSCI call. Additionally, assert
> > that the guest PSCI call fails if preconditions are not met (more than 1
> > running vCPU).
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/psci_test.c | 75 +++++++++++++++++++
> >  1 file changed, 75 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
> > index 90312be335da..5b881ca4d102 100644
> > --- a/tools/testing/selftests/kvm/aarch64/psci_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
> > @@ -45,6 +45,16 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
> >       return res.a0;
> >  }
> >
> > +static uint64_t psci_system_suspend(uint64_t entry_addr, uint64_t context_id)
> > +{
> > +     struct arm_smccc_res res;
> > +
> > +     smccc_hvc(PSCI_1_0_FN64_SYSTEM_SUSPEND, entry_addr, context_id,
> > +               0, 0, 0, 0, 0, &res);
> > +
> > +     return res.a0;
> > +}
> > +
> >  static void guest_test_cpu_on(uint64_t target_cpu)
> >  {
> >       GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
> > @@ -69,6 +79,13 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
> >       vcpu_set_mp_state(vm, vcpuid, &mp_state);
> >  }
> >
> > +static void guest_test_system_suspend(void)
> > +{
> > +     uint64_t r = psci_system_suspend(CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID);
> > +
> > +     GUEST_SYNC(r);
> > +}
> > +
> >  static struct kvm_vm *setup_vm(void *guest_code)
> >  {
> >       struct kvm_vcpu_init init;
> > @@ -136,8 +153,66 @@ static void host_test_cpu_on(void)
> >       kvm_vm_free(vm);
> >  }
> >
> > +static void enable_system_suspend(struct kvm_vm *vm)
> > +{
> > +     struct kvm_enable_cap cap = {
> > +             .cap = KVM_CAP_ARM_SYSTEM_SUSPEND,
> > +     };
> > +
> > +     vm_enable_cap(vm, &cap);
> > +}
> > +
> > +static void host_test_system_suspend(void)
> > +{
> > +     struct kvm_run *run;
> > +     struct kvm_vm *vm;
> > +
> > +     vm = setup_vm(guest_test_system_suspend);
> > +     enable_system_suspend(vm);
> > +
> > +     vcpu_power_off(vm, VCPU_ID_TARGET);
> > +     run = vcpu_state(vm, VCPU_ID_SOURCE);
> > +
> > +     enter_guest(vm, VCPU_ID_SOURCE);
> > +
> > +     TEST_ASSERT(run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
> > +                 "Unhandled exit reason: %u (%s)",
> > +                 run->exit_reason, exit_reason_str(run->exit_reason));
> > +     TEST_ASSERT(run->system_event.type == KVM_SYSTEM_EVENT_SUSPEND,
> > +                 "Unhandled system event: %u (expected: %u)",
> > +                 run->system_event.type, KVM_SYSTEM_EVENT_SUSPEND);
> > +
> > +     assert_vcpu_reset(vm, VCPU_ID_SOURCE);
> > +     kvm_vm_free(vm);
> > +}
> > +
> > +static void host_test_system_suspend_fails(void)
> > +{
> > +     struct kvm_vm *vm;
> > +     struct ucall uc;
> > +
> > +     vm = setup_vm(guest_test_system_suspend);
> > +     enable_system_suspend(vm);
> > +
> > +     enter_guest(vm, VCPU_ID_SOURCE);
> > +     TEST_ASSERT(get_ucall(vm, VCPU_ID_SOURCE, &uc) == UCALL_SYNC,
> > +                 "Unhandled ucall: %lu", uc.cmd);
> > +     TEST_ASSERT(uc.args[1] == PSCI_RET_DENIED,
> > +                 "Unrecognized PSCI return code: %lu (expected: %u)",
> > +                 uc.args[1], PSCI_RET_DENIED);
> > +
> > +     kvm_vm_free(vm);
> > +}
> > +
> >  int main(void)
> >  {
> > +     if (!kvm_check_cap(KVM_CAP_ARM_SYSTEM_SUSPEND)) {
> > +             print_skip("KVM_CAP_ARM_SYSTEM_SUSPEND not supported");
> > +             exit(KSFT_SKIP);
> > +     }
>
> How about only guarding the new tests with this, so we can still do the
> cpu_on test when this feature isn't present?
>

Great suggestion, thanks!

--
Best,
Oliver
