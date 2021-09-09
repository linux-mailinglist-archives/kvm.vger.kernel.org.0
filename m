Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D16405B9C
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239011AbhIIRA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 13:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237002AbhIIRAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 13:00:55 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F45C061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 09:59:45 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id v17so5213433ybs.9
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 09:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h4cQqQOplk8x725n2ey4+/+BvWdK0UMLhYf+SNIozPk=;
        b=O4T0puoUdDmajej0EsClr36rF3VQEmHKZCjpSAvbYXv/PDlaYW5ih7hdSkYYVp7OFr
         fSx1buxVk+fhg4K25HNQdnT/A9V+/xIYvYmFJarVLEcx5aWSBN4DZ6vh8mVVandRdCrU
         n78NET/pRJfSbRKI/IBgztDqYkf6fmuwbmFxHkeKtxXTLc0OzyytfdT+28GXRIn6xG3d
         xawbnTEJRRRmUO6dG1qqIDPyKZ7yIYhluR4mcoXhFrgxE6eUCAiTkSm2v9NcJ+YDXCpF
         cW0PSEDndkk6pjoC0rCTTo6Ye+KEjIw5Ub2Au+s/+N0g+xnYoXjWOmpb83VnwNdi0Fej
         /wCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h4cQqQOplk8x725n2ey4+/+BvWdK0UMLhYf+SNIozPk=;
        b=Xkv0DdFh0M/xSX/lqVTLsy0G/AZvOomwCav+6qv3TxoQTAaah+s+8w7xK7lWkDohyR
         52Rk27gcTQbb9H0tTr7tQ3CvIObPRSVZbUbO3UOyIh3j5jZrdu9NDOZb4o0eD0dKHaXi
         1SnhXz8Q9nl+h/vVLfl22xGO6La20INzNwOo63MZyieMwa3k6wYbLLTHvdLfz9M2VVhq
         H7NilpwNIRmDiWep5kedNA9wkR9hik0GwjOgcG/ZLCdB1uenvtZWA5tLyWhlyoZ4sjc4
         EhX6/jOw9vAfxP6EhB7ycmhkBzwGWCZwNjnLrMnSYQY1c7tYB5X6+Tt0IqB685ggsp0b
         KTEw==
X-Gm-Message-State: AOAM530oe+7vWRFLqMhorU7wMnG9f7zGbn8yOu9cs8Gu8vAm6A2WXsKN
        OTdHSVmYpJ8EbrDkx9nLhRUYnOaJmT9iCCW+hFfWCQ==
X-Google-Smtp-Source: ABdhPJwD2J11x1YItUB+digmkHQyFDgrrRlsAAGKHfI7ALtSn12JHhwFekPsDwP18MY3PE58Vz8ZDU+XjV0cy/d+HSs=
X-Received: by 2002:a25:cd82:: with SMTP id d124mr5190323ybf.491.1631206784899;
 Thu, 09 Sep 2021 09:59:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com> <20210909013818.1191270-10-rananta@google.com>
 <YTmW7/pY0E9cHQ+c@google.com>
In-Reply-To: <YTmW7/pY0E9cHQ+c@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 9 Sep 2021 09:59:33 -0700
Message-ID: <CAJHc60zk6vJg4dj4hm7sCHK08TEr=GtXemDJHb22mgvg2eUfXA@mail.gmail.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
To:     Oliver Upton <oupton@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 8, 2021 at 10:09 PM Oliver Upton <oupton@google.com> wrote:
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
>
> I believe both of these functions could use some documentation. The
> former has implicit ordering requirements (can only be called after all
> vCPUs are created) and the latter can only be used within a guest.
>
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
> > +
> > +static struct vm_vcpuid_map vcpuid_map[KVM_MAX_VCPUS];
> > +
>
> Hmm.
>
> I'm not too big of a fan that the KVM_MAX_VCPUS macro is defined in the
> KVM selftests. Really, userspace should discover the limit from the
> kernel. Especially when we want to write tests that test behavior at
> KVM's limit.
>
> That being said, there are more instances of these static allocations in
> the selftests code, so you aren't to be blamed.
>
> Related: commit 074c82c8f7cf ("kvm: x86: Increase MAX_VCPUS to 1024")
> has raised this limit.
>
I'm not a fan of static allocations either, but the fact that
sync_global_to_guest() doesn't have a size argument (yet), makes me
want to take a shorter route. Anyway, if you want I can allocate it
dynamically and copy it to the guest's memory by hand, or come up with
a utility wrapper while I'm at it.
(Just wanted to make sure we are not over-engineering our needs here).

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
> > +
> > +     if (i < KVM_MAX_VCPUS)
> > +             vcpuid_map[i].vcpuid = VM_VCPUID_MAP_INVAL;
> > +
> > +     sync_global_to_guest(vm, vcpuid_map);
> > +}
> > +
> > +int get_vcpuid(void)
>
> nit: guest_get_vcpuid()
>
Sounds nice. Since we have a lot of guest utility functions now, I'm
fancying a world where we prefix guest_ with all of them to avoid
confusion.

Regards,
Raghavendra
> > +{
> > +     int i, vcpuid;
> > +     uint64_t mpidr = read_sysreg(mpidr_el1) & MPIDR_HWID_BITMASK;
> > +
> > +     for (i = 0; i < KVM_MAX_VCPUS; i++) {
> > +             vcpuid = vcpuid_map[i].vcpuid;
> > +             GUEST_ASSERT_1(vcpuid != VM_VCPUID_MAP_INVAL, mpidr);
> > +
> > +             if (mpidr == vcpuid_map[i].mpidr)
> > +                     return vcpuid;
> > +     }
> > +
> > +     /* We should not be reaching here */
> > +     GUEST_ASSERT_1(0, mpidr);
> > +     return -1;
> > +}
> > --
> > 2.33.0.153.gba50c8fa24-goog
> >
