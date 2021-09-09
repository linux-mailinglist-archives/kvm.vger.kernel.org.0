Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7867405BCF
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 19:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241273AbhIIRM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 13:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240958AbhIIRMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 13:12:19 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82592C061575
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 10:11:09 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id v17so5288770ybs.9
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 10:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gt9YsGEHPd9blquFdpY+rNn/Ktkd0FJBPDXVSwWfzVA=;
        b=mBPX6UaRDah3B9oEWW40eU8dcRn8RO27Gpz202oHuPyfN6E2FVjsIyHQoLooajZXzz
         WKvlB4pyuqZBiH941evKKdmhjzotDrTrIRW9b+f/vYXimmZkfY6Pw5n/D8soGbl93xhg
         6nVfZ8UUE5zyPdNVLOU4y4m7Lgi9SEHC2RqUhV/PzfFnjly+5Q33ymAQTsfyG1DjjyJs
         qfW+e20g4OTXBCKsm7HSZ0jOHZHeavkx+lNQd6d463MFJZOUwDO9DaXCzYCYcrQoiupo
         vm8+36L8qF8U0YQ4dc4r38X0yCdYMJT5QcfnRv563cdHCRSyVu1FKpPWoKabCSgssWOu
         i0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gt9YsGEHPd9blquFdpY+rNn/Ktkd0FJBPDXVSwWfzVA=;
        b=0xQcc8xnr0ENMl4z+pENEt75FiS4nwvbn1xJEGS8tf472dYDE5MPQ3B8pWge38Rx1k
         OYgej9BkL6IvMQSdKZnNTfI1DIVg4cJqabQ3x/fO9AGfpgw8fYbHAn9P4VgaHu3yh7kv
         V6LCSTc/EJ/mcCWj7KFH8NExJFGGLHWcIM1u8WFwrVkf0ibShxHjx6oavII/9+TP2+Yl
         BENdmXYnLTS10SJTxCYKjxDvHsXg5i5LHcENkgE79zu2AJVsX2wUln3q8zfWqzn+Ca/D
         m+Y5AboAf2T/XgWwxNrIqeW0yUsCE04WpaZrAMeU+rooiXwj9pdWtyfZ7t1x3PVOcIii
         zrpA==
X-Gm-Message-State: AOAM532OyV/sulukp5kVOx60UqaWLLLmtRAtD1lOit1f/scXInEUFQUc
        7+TLwR9J/dvLo0pEMWzU/AS67QCEf/E+Tl9LECyxcw==
X-Google-Smtp-Source: ABdhPJyjeZVZ5OBHHfB/gVgbY4kEHNdlHJNCyRZ8a5HkSMk3+pNJRkf1F8zHY9JBbnAAyeMDADYnnps15uTm9MTGWF8=
X-Received: by 2002:a25:1c09:: with SMTP id c9mr5447528ybc.350.1631207468411;
 Thu, 09 Sep 2021 10:11:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com> <20210909013818.1191270-10-rananta@google.com>
 <20210909075643.fhngqu6tqrpe33gl@gator>
In-Reply-To: <20210909075643.fhngqu6tqrpe33gl@gator>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 9 Sep 2021 10:10:56 -0700
Message-ID: <CAJHc60wRkUyKEdY0ok0uC7r=P0FME+Lb7oapz+AKbjaNDhFHyA@mail.gmail.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 9, 2021 at 12:56 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Sep 09, 2021 at 01:38:09AM +0000, Raghavendra Rao Ananta wrote:
> > At times, such as when in the interrupt handler, the guest wants
> > to get the vcpuid that it's running on. As a result, introduce
> > get_vcpuid() that returns the vcpuid of the calling vcpu. At its
> > backend, the VMM prepares a map of vcpuid and mpidr during VM
> > initialization and exports the map to the guest for it to read.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/kvm/include/aarch64/processor.h |  3 ++
> >  .../selftests/kvm/lib/aarch64/processor.c     | 46 +++++++++++++++++++
> >  2 files changed, 49 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > index b6088c3c67a3..150f63101f4c 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -133,6 +133,7 @@ void vm_install_exception_handler(struct kvm_vm *vm,
> >               int vector, handler_fn handler);
> >  void vm_install_sync_handler(struct kvm_vm *vm,
> >               int vector, int ec, handler_fn handler);
> > +void vm_vcpuid_map_init(struct kvm_vm *vm);
> >
> >  static inline void cpu_relax(void)
> >  {
> > @@ -194,4 +195,6 @@ static inline void local_irq_disable(void)
> >       asm volatile("msr daifset, #3" : : : "memory");
> >  }
> >
> > +int get_vcpuid(void);
> > +
> >  #endif /* SELFTEST_KVM_PROCESSOR_H */
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > index 632b74d6b3ca..9844b62227b1 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > @@ -13,9 +13,17 @@
> >  #include "processor.h"
> >
> >  #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN  0xac0000
> > +#define VM_VCPUID_MAP_INVAL                  -1
> >
> >  static vm_vaddr_t exception_handlers;
> >
> > +struct vm_vcpuid_map {
> > +     uint64_t mpidr;
> > +     int vcpuid;
> > +};
>
> I'd prefer we create an arch neutral map structure that has arch specific
> vm_vcpuid_map_add() functions to populate them. So, instead of calling the
> 'mpidr' member mpidr, we should call it 'cpuid'. On x86, for example,
> cpuid would be the APIC ID.
>
Great idea. Let me think about it..

> > +
> > +static struct vm_vcpuid_map vcpuid_map[KVM_MAX_VCPUS];
> > +
> >  static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> >  {
> >       return (v + vm->page_size) & ~(vm->page_size - 1);
> > @@ -426,3 +434,41 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
> >       assert(vector < VECTOR_NUM);
> >       handlers->exception_handlers[vector][0] = handler;
> >  }
> > +
> > +void vm_vcpuid_map_init(struct kvm_vm *vm)
> > +{
> > +     int i = 0;
> > +     struct vcpu *vcpu;
> > +     struct vm_vcpuid_map *map;
> > +
> > +     list_for_each_entry(vcpu, &vm->vcpus, list) {
> > +             map = &vcpuid_map[i++];
> > +             map->vcpuid = vcpu->id;
> > +             get_reg(vm, vcpu->id,
> > +                     ARM64_SYS_KVM_REG(SYS_MPIDR_EL1), &map->mpidr);
> > +             map->mpidr &= MPIDR_HWID_BITMASK;
> > +     }
>
> Here we should assert that i is no longer zero. If it is, then we should
> complain that vcpus need to be added before this call is made.
>
Makes sense, I'll add an ASSERT to be safe.
> But, rather than providing an init function that inits the whole map
> after all vcpus are created, I think we should add each vcpu's map entry
> as we add vcpus to the vm. So we need to call the arch-specific
> vm_vcpuid_map_add() from vm_vcpu_add(). We can just create stubs
> for x86 and s390 for now. Also, in vm_vcpu_rm() we should find the
> corresponding entry in the vcpuid map and set it to VM_VCPUID_MAP_INVAL
> in order to remove it.
>
> > +
> > +     if (i < KVM_MAX_VCPUS)
> > +             vcpuid_map[i].vcpuid = VM_VCPUID_MAP_INVAL;
> > +
> > +     sync_global_to_guest(vm, vcpuid_map);
>
> We can't do this synch part for the test code at vcpu add time since we
> don't know if the guest page tables are ready. I think it's OK to require
> the test code to do this when the guest code needs it though. We should
> document that requirement above the vm_vcpuid_map struct declaration,
> which will be in kvm_util.h.
>
Sure, I'll add a comment.
> > +}
> > +
> > +int get_vcpuid(void)
> > +{
> > +     int i, vcpuid;
> > +     uint64_t mpidr = read_sysreg(mpidr_el1) & MPIDR_HWID_BITMASK;
> > +
> > +     for (i = 0; i < KVM_MAX_VCPUS; i++) {
> > +             vcpuid = vcpuid_map[i].vcpuid;
> > +             GUEST_ASSERT_1(vcpuid != VM_VCPUID_MAP_INVAL, mpidr);
>
> We don't want this assert if it's possible to have sparse maps, which
> it probably isn't ever going to be, but...
>
If you look at the way the array is arranged, the element with
VM_VCPUID_MAP_INVAL acts as a sentinel for us and all the proper
elements would lie before this. So, I don't think we'd have a sparse
array here.

Regards,
Raghavendra
> > +
> > +             if (mpidr == vcpuid_map[i].mpidr)
> > +                     return vcpuid;
> > +     }
> > +
> > +     /* We should not be reaching here */
> > +     GUEST_ASSERT_1(0, mpidr);
>
> ...this assert should be good enough to sanity check the map by itself
> anyway.
>
> Also, the only arch-specific aspect of get_vcpuid() is the looking up
> the cpuid. So we should make get_vcpuid arch-neutral and call an arch-
> specific get_cpuid() from it.
>
> > +     return -1;
> > +}
> > --
> > 2.33.0.153.gba50c8fa24-goog
> >
>
> Thanks,
> drew
>
