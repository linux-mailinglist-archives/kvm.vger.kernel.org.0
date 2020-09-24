Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6559276B15
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 09:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgIXHpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 03:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbgIXHpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 03:45:24 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE497C0613CE;
        Thu, 24 Sep 2020 00:45:24 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id h2so2166605ilo.12;
        Thu, 24 Sep 2020 00:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IxTyfqdQxLsGAMyRUvmRffvJyTeVBIXZuLoIIydSIMs=;
        b=L41Sz9YzaRenimIvko0cU8wwGfr7axecHDVXquVtPxNplBENOLzJAYg2IL9GaVUJ3i
         ntU0cx8dImDvNIZNvlPxt/ApaKQvmP+swKYbK4olUGDJquS1h2iHEoVstipvyGh1qjc0
         qd56UpqhXezSnGi07/FMvcgZOqdbOfz5zb6O7dChp61LZjuCzzJ570TzvVxOwKGtecsh
         ldTDFKT1pfdmdVvD3nPdi94L6EkuwpnTSVWSXEoLnOPp/j81CkGe5yUscPC2f3p522lm
         0rz8K2Zi36Z/ZLRF+JGQ9M/6z+z71XCtW4ud1vWNBHlSTzf7yBDDOcR8oQBk4VqkWmhW
         FORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IxTyfqdQxLsGAMyRUvmRffvJyTeVBIXZuLoIIydSIMs=;
        b=RG1Qf5M7U3ZE3ipNi3JcSBIQ0c4s/rrvgJeZcPPAw4pCWtEdBkpbaeORgqn6u93alj
         E98BS5LQI8KtVj2dn8VjIUX/dgcQqs3OBcU/Rk7qwVfP0xVtXW/q6rSitjl2eKzz3d8f
         dX9v6JWWCXSyq16XbKGt6V3sC1RrUwvrfLNSbk8hkIpkNSvex+UmajvpuC1E6HlvxMOI
         cz/wcNc758rTtCK0T4z3HDEZ+HW3aH2ZpMzvj4Tjdm3fUvEnovB3ZcIQ6wQdB+cUxeWy
         M9s8JcTsUNTSTlbt5aZowWcgfb5Ik8rN4vFGSuVU4kD+sr0Ih50eNPAOFmQwW/ZjoSzU
         yW0w==
X-Gm-Message-State: AOAM530+RH5smy4vLdQvaarBP7bS2zIOj4nJYFmLv+dDQoXNCAvkxobw
        DEeiHOr9BUCcWgboKmEHPizxRj6J23VJwkX1FKo=
X-Google-Smtp-Source: ABdhPJyNVTUNbHkzBWdwy2SAA9QTIAjXqOIuGAjXbewwl2m2fEAtO13LhCk7EBH3sWcbwi7iM8A7opzoamFgUSiML7c=
X-Received: by 2002:a05:6e02:d48:: with SMTP id h8mr2976131ilj.251.1600933524016;
 Thu, 24 Sep 2020 00:45:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200923185757.1806-1-sean.j.christopherson@intel.com>
 <CAAhV-H6QLRh8kWyt4KfVgS64nsixx_3er+qmeph3csxpq3scdw@mail.gmail.com> <11d4e52e-6bc2-934d-0487-561033b3ab87@redhat.com>
In-Reply-To: <11d4e52e-6bc2-934d-0487-561033b3ab87@redhat.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Thu, 24 Sep 2020 15:45:12 +0800
Message-ID: <CAAhV-H6rzcoJ_d=+yKzyAie_+T1aFgbqEWpSq438RKqvzajAnA@mail.gmail.com>
Subject: Re: [PATCH] KVM: Enable hardware before doing arch VM initialization
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>, kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo,

On Thu, Sep 24, 2020 at 2:50 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 24/09/20 08:31, Huacai Chen wrote:
> > Hi, Sean,
> >
> > On Thu, Sep 24, 2020 at 3:00 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> >>
> >> Swap the order of hardware_enable_all() and kvm_arch_init_vm() to
> >> accommodate Intel's Trust Domain Extension (TDX), which needs VMX to be
> >> fully enabled during VM init in order to make SEAMCALLs.
> >>
> >> This also provides consistent ordering between kvm_create_vm() and
> >> kvm_destroy_vm() with respect to calling kvm_arch_destroy_vm() and
> >> hardware_disable_all().
> > Do you means that hardware_enable_all() enable VMX, kvm_arch_init_vm()
> > enable TDX, and TDX depends on VMX enabled at first? If so, can TDX be
> > also enabled at hardware_enable_all()?
>
> kvm_arch_init_vm() enables TDX *for the VM*, and to do that it needs VMX
> instructions (specifically SEAMCALL, which is a hypervisor->"ultravisor"
> call).  Because that action is VM-specific it cannot be done in
> hardware_enable_all().
>
> Paolo
OK, I know.

Reviewed-by: Huacai Chen <chenhc@lemote.com>

>
> > The swapping seems not affect MIPS, but I observed a fact:
> > kvm_arch_hardware_enable() not only be called at
> > hardware_enable_all(), but also be called at kvm_starting_cpu(). Even
> > if you swap the order, new starting CPUs are not enabled VMX before
> > kvm_arch_init_vm(). (Maybe I am wrong because I'm not familiar with
> > VMX/TDX).
> >
> > Huacai
> >>
> >> Cc: Marc Zyngier <maz@kernel.org>
> >> Cc: James Morse <james.morse@arm.com>
> >> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> >> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> >> Cc: linux-arm-kernel@lists.infradead.org
> >> Cc: Huacai Chen <chenhc@lemote.com>
> >> Cc: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> >> Cc: linux-mips@vger.kernel.org
> >> Cc: Paul Mackerras <paulus@ozlabs.org>
> >> Cc: kvm-ppc@vger.kernel.org
> >> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> >> Cc: Janosch Frank <frankja@linux.ibm.com>
> >> Cc: David Hildenbrand <david@redhat.com>
> >> Cc: Cornelia Huck <cohuck@redhat.com>
> >> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> Cc: Wanpeng Li <wanpengli@tencent.com>
> >> Cc: Jim Mattson <jmattson@google.com>
> >> Cc: Joerg Roedel <joro@8bytes.org>
> >> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >> ---
> >>
> >> Obviously not required until the TDX series comes along, but IMO KVM
> >> should be consistent with respect to enabling and disabling virt support
> >> in hardware.
> >>
> >> Tested only on Intel hardware.  Unless I missed something, this only
> >> affects x86, Arm and MIPS as hardware enabling is a nop for s390 and PPC.
> >> Arm looks safe (based on my mostly clueless reading of the code), but I
> >> have no idea if this will cause problem for MIPS, which is doing all kinds
> >> of things in hardware_enable() that I don't pretend to fully understand.
> >>
> >>  virt/kvm/kvm_main.c | 16 ++++++++--------
> >>  1 file changed, 8 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >> index cf88233b819a..58fa19bcfc90 100644
> >> --- a/virt/kvm/kvm_main.c
> >> +++ b/virt/kvm/kvm_main.c
> >> @@ -766,7 +766,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
> >>                 struct kvm_memslots *slots = kvm_alloc_memslots();
> >>
> >>                 if (!slots)
> >> -                       goto out_err_no_arch_destroy_vm;
> >> +                       goto out_err_no_disable;
> >>                 /* Generations must be different for each address space. */
> >>                 slots->generation = i;
> >>                 rcu_assign_pointer(kvm->memslots[i], slots);
> >> @@ -776,19 +776,19 @@ static struct kvm *kvm_create_vm(unsigned long type)
> >>                 rcu_assign_pointer(kvm->buses[i],
> >>                         kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACCOUNT));
> >>                 if (!kvm->buses[i])
> >> -                       goto out_err_no_arch_destroy_vm;
> >> +                       goto out_err_no_disable;
> >>         }
> >>
> >>         kvm->max_halt_poll_ns = halt_poll_ns;
> >>
> >> -       r = kvm_arch_init_vm(kvm, type);
> >> -       if (r)
> >> -               goto out_err_no_arch_destroy_vm;
> >> -
> >>         r = hardware_enable_all();
> >>         if (r)
> >>                 goto out_err_no_disable;
> >>
> >> +       r = kvm_arch_init_vm(kvm, type);
> >> +       if (r)
> >> +               goto out_err_no_arch_destroy_vm;
> >> +
> >>  #ifdef CONFIG_HAVE_KVM_IRQFD
> >>         INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
> >>  #endif
> >> @@ -815,10 +815,10 @@ static struct kvm *kvm_create_vm(unsigned long type)
> >>                 mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
> >>  #endif
> >>  out_err_no_mmu_notifier:
> >> -       hardware_disable_all();
> >> -out_err_no_disable:
> >>         kvm_arch_destroy_vm(kvm);
> >>  out_err_no_arch_destroy_vm:
> >> +       hardware_disable_all();
> >> +out_err_no_disable:
> >>         WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
> >>         for (i = 0; i < KVM_NR_BUSES; i++)
> >>                 kfree(kvm_get_bus(kvm, i));
> >> --
> >> 2.28.0
> >>
> >
>
