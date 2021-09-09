Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243E4405BFD
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 19:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241230AbhIIR1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 13:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbhIIR1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 13:27:10 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0DBC061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 10:26:00 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id v10so5405771ybm.5
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 10:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JVEsJeL6D9X5QjMN9PXa+48oXTHXTq43/22SMlTMNnQ=;
        b=Ec2zxk0h9f8q2blCfeHXIH5cZ4hlMlHiZj5QhBKpj5NmBYcAFw2WgZRE7lwNTIoiwI
         DTMFgXfdv6qjgBCfzcDJ4P14KFAPdb0gYXy3eappj9n0sMDPOlVrwCkeTG3SABvvUyJS
         sOqaxgpGWS/Dzkzj31Gs+FliXBqE1gF11xt2d2Zr3yrXnfsxVisesO4vzXujU0OMcguE
         o5zjKTimyGZ+Y1nUQ8CoO0avHfyTWxDT7IcX1P2p9vYSL2lOFNKT0k5VEc4lvEJcrNzh
         qw/pc6M/nPaGsnCZLulXhKTqwLZfyzppx0gdnlhKJcVeGC7KTMzOZR7nMtn/0p/03/i2
         VCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JVEsJeL6D9X5QjMN9PXa+48oXTHXTq43/22SMlTMNnQ=;
        b=8DQDgZ7UYoOyHXxqZeGg69m3U2qChmJo3UcXNMFEEtKeI4nsTLS2B1FKkcyjDxwsRs
         y0UUwdGzhLWVPtMo7Wtzre8MkxpuGbmkHi94oW4ivfdrnFbKnuYpd59sK7CcsHKILEWS
         LG7X23l+1JrHqJYMnkCq0WPhskjGLjedR+yhUY/foAl0/eMRMRYvGCm8vkpYsvT3LoXw
         H4eFaElNtJKEhfYILjd8NerVEyLCrmgsfhAhP44SkTj8t2+O/0lcnBhLDzCWwscXhqMP
         3nc767huFMqzz+j2JsycvPNzn/51zxl02kvSWcCVpJbPzUXg6VT1nIukalZayXLXHxtK
         AqmA==
X-Gm-Message-State: AOAM531weVaN8zokcOl7u08aGEkEqtn3Igmd3EjN2xG32empRcREJHHZ
        dlQzqJwDg6e7qAoDXej4KOGf2izO4x6sty7oMLiF0Q==
X-Google-Smtp-Source: ABdhPJwT4+E0jXvyHQvIQj+dAZBZB5xhW0l0CQVAti/qraDJbPO3HFvhBDZDVEFYAMJoW1YgJI/UNcRS2Ep/CO/KpPU=
X-Received: by 2002:a25:21c5:: with SMTP id h188mr4939725ybh.23.1631208359719;
 Thu, 09 Sep 2021 10:25:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com> <20210909013818.1191270-15-rananta@google.com>
 <YTmce6Xn+ymngA+r@google.com> <20210909133421.rdkueb627glve6uz@gator>
In-Reply-To: <20210909133421.rdkueb627glve6uz@gator>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 9 Sep 2021 10:25:48 -0700
Message-ID: <CAJHc60zMUS42+s9GG0qNeZeHOSC23yiUFje1Tz3PwZJM_fmfKw@mail.gmail.com>
Subject: Re: [PATCH v4 14/18] KVM: arm64: selftests: Add host support for vGIC
To:     Andrew Jones <drjones@redhat.com>
Cc:     Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
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

On Thu, Sep 9, 2021 at 6:34 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Sep 09, 2021 at 05:32:43AM +0000, Oliver Upton wrote:
> > Hi Raghu,
> >
> > On Thu, Sep 09, 2021 at 01:38:14AM +0000, Raghavendra Rao Ananta wrote:
> > > Implement a simple library to perform vGIC-v3 setup
> > > from a host point of view. This includes creating a
> > > vGIC device, setting up distributor and redistributor
> > > attributes, and mapping the guest physical addresses.
> > >
> > > The definition of REDIST_REGION_ATTR_ADDR is taken
> > > from aarch64/vgic_init test.
> > >
> >
> > Consider dropping the macro from vgic_init.c and have it just include
> > vgic.h
>
> Yes, I agree 18/18 should be squashed into this one.
>
> >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/Makefile          |  2 +-
> > >  .../selftests/kvm/include/aarch64/vgic.h      | 20 +++++++
> > >  .../testing/selftests/kvm/lib/aarch64/vgic.c  | 60 +++++++++++++++++++
> > >  3 files changed, 81 insertions(+), 1 deletion(-)
> > >  create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
> > >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > >
> > > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > > index 5476a8ddef60..8342f65c1d96 100644
> > > --- a/tools/testing/selftests/kvm/Makefile
> > > +++ b/tools/testing/selftests/kvm/Makefile
> > > @@ -35,7 +35,7 @@ endif
> > >
> > >  LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
> > >  LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
> > > -LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c
> > > +LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
> > >  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
> > >
> > >  TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
> > > diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> > > new file mode 100644
> > > index 000000000000..3a776af958a0
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> > > @@ -0,0 +1,20 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +/*
> > > + * ARM Generic Interrupt Controller (GIC) host specific defines
> > > + */
> > > +
> > > +#ifndef SELFTEST_KVM_VGIC_H
> > > +#define SELFTEST_KVM_VGIC_H
> > > +
> > > +#include <linux/kvm.h>
> > > +
> > > +#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) \
> > > +   (((uint64_t)(count) << 52) | \
> > > +   ((uint64_t)((base) >> 16) << 16) | \
> > > +   ((uint64_t)(flags) << 12) | \
> > > +   index)
> > > +
> > > +int vgic_v3_setup(struct kvm_vm *vm,
> > > +                           uint64_t gicd_base_gpa, uint64_t gicr_base_gpa);
> > > +
> > > +#endif /* SELFTEST_KVM_VGIC_H */
> > > diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > > new file mode 100644
> > > index 000000000000..2318912ab134
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > > @@ -0,0 +1,60 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * ARM Generic Interrupt Controller (GIC) v3 host support
> > > + */
> > > +
> > > +#include <linux/kvm.h>
> > > +#include <linux/sizes.h>
> > > +
> > > +#include "kvm_util.h"
> > > +#include "vgic.h"
> > > +
> > > +#define VGIC_V3_GICD_SZ            (SZ_64K)
> > > +#define VGIC_V3_GICR_SZ            (2 * SZ_64K)
> >
> > These values are UAPI, consider dropping them in favor of the
> > definitions from asm/kvm.h
>
> Yes, please.
>
Huh, I wasn't aware of this. Thanks! Will drop.
> >
> > > +
> > > +/*
> > > + * vGIC-v3 default host setup
> > > + *
> > > + * Input args:
> > > + * vm - KVM VM
> > > + * gicd_base_gpa - Guest Physical Address of the Distributor region
> > > + * gicr_base_gpa - Guest Physical Address of the Redistributor region
> > > + *
> > > + * Output args: None
> > > + *
> > > + * Return: GIC file-descriptor or negative error code upon failure
> > > + *
> > > + * The function creates a vGIC-v3 device and maps the distributor and
> > > + * redistributor regions of the guest. Since it depends on the number of
> > > + * vCPUs for the VM, it must be called after all the vCPUs have been created.
> >
> > You could avoid the ordering dependency by explicitly taking nr_vcpus as
> > an arg. It would also avoid the need for 12/18.
>
> All the vcpus need to be created prior to calling
> KVM_DEV_ARM_VGIC_CTRL_INIT, so even though I don't disagree with
> simply passing nr_vcpus to this function, we should still assert
> if the VM's idea of the number doesn't match. But, this is a lib
> file, so there's no reason not to do
>
Okay, I'll include it back in the args.

> #include "../kvm_util_internal.h"
>
> and just access the vcpu list to get the count or, if we add a
> new internal nr_vcpus member, access it directly. IOW, so far
> I don't believe we need vm_get_nr_vcpus().
>
Sure, I'll get rid of it.

Regards,
Raghavendra
> >
> > Also note the required alignment on the GPA arguments you're taking.
> >
> > > + */
> > > +int vgic_v3_setup(struct kvm_vm *vm,
> > > +           uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
> > > +{
> > > +   uint64_t redist_attr;
> > > +   int gic_fd, nr_vcpus;
> > > +   unsigned int nr_gic_pages;
> > > +
> > > +   nr_vcpus = vm_get_nr_vcpus(vm);
> > > +   TEST_ASSERT(nr_vcpus > 0, "Invalid number of CPUs: %u\n", nr_vcpus);
> > > +
> > > +   /* Distributor setup */
> > > +   gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> > > +   kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > > +                   KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
> > > +   nr_gic_pages = vm_calc_num_guest_pages(vm_get_mode(vm), VGIC_V3_GICD_SZ);
> > > +   virt_map(vm, gicd_base_gpa, gicd_base_gpa,  nr_gic_pages);
> > > +
> > > +   /* Redistributor setup */
> > > +   redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
> > > +   kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > > +                   KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr, true);
> > > +   nr_gic_pages = vm_calc_num_guest_pages(vm_get_mode(vm),
> > > +                                           VGIC_V3_GICR_SZ * nr_vcpus);
> > > +   virt_map(vm, gicr_base_gpa, gicr_base_gpa,  nr_gic_pages);
> > > +
> > > +   kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> > > +                           KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> > > +
> > > +   return gic_fd;
> > > +}
> > > --
> > > 2.33.0.153.gba50c8fa24-goog
> > >
> >
>
> Thanks,
> drew
>
