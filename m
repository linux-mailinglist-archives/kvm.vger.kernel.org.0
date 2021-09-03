Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05399400713
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351067AbhICUtX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351041AbhICUtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 16:49:19 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5C6C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 13:48:19 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id c6so762799ybm.10
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 13:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jdumqdU9gNUc/p8x91c5FNRB2/icYIsDIBk+jupJSu0=;
        b=NWyK5pOQlXzw905KW8xs5oC0JiBsnohXgutz955HmXNdNbbfMyIIULufhAGSkJVOCY
         zjGyPA8gstB36oX7lPvPYgm7xM4O4QG21trj1UJYpXc6FHml6UwLrs4EjobqpWmLg+cU
         w1tqVEi2Ntgw8zF+WLhtAHZsQAnOwaLoK5xTqV+Rws3XvCDwcOp27DTmrbNAxFW86lB0
         s+FS2z3eem+dKeJOt/6WN0RBU6uA/4lDov8saHgbQNT8fKZCrhmXLTDBHZ9vMFNs9Cxn
         oW9g19Juw6ODzXfGomrWWXE8Ru2UBGKImLQ73dRVUwIJwhmWqTpMBBZ8gFQeNvYRstCZ
         Rhqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jdumqdU9gNUc/p8x91c5FNRB2/icYIsDIBk+jupJSu0=;
        b=HYS/Dr3J3/K7781J0cmCcnDPNu5esf4KXM/Z3pIYNxPlDcZAnSjDwtAXHis0gljsiv
         Rh2TBaRdrLgQNMokZRVumULbB97Be7TvnlPIufovP9qBYaWLqMLRdCWmPB4ZM2kHlMr5
         xKcw/dFghafTCooDZu0IqlRitu33eLCUffp5vKHvL4YahxfBgmiUi1V/NoVsij5jmjGw
         CwLGqSzCz+9H5jcCRZP6i/xRjHBUPcgWHN2lAubm4tTFg/J+90HXaYX4P316zuYeQKbh
         i/bMOlsc6+cpEnpH5OSXpdPuCKvAL6gBS+YhbDYJTBK9XBhaA5qeoEHkkGQ+7Mk4QWz/
         fdMg==
X-Gm-Message-State: AOAM530s73LV2DtajFjjpTZON/j2cifUIys/tdYHxghybw5sI5JTz+M1
        FCtRrgfKaCwWd0+KCW1NPlf6uTbI0ocZqzw3Cnf+W69fnGxvHQ==
X-Google-Smtp-Source: ABdhPJyuepYTpoYmEXPzK6HgxRPVtcxlu73WiwhNSpb1n3TcEnYmF7orWnAI3JSDsNV/K05sXAkceQ9pKbT1jr72OGE=
X-Received: by 2002:a25:2007:: with SMTP id g7mr1255987ybg.434.1630702098466;
 Fri, 03 Sep 2021 13:48:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com> <20210901211412.4171835-11-rananta@google.com>
 <20210903105155.dgu2bi765ngp3pgi@gator.home>
In-Reply-To: <20210903105155.dgu2bi765ngp3pgi@gator.home>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Fri, 3 Sep 2021 13:48:05 -0700
Message-ID: <CAJHc60yVDYUPCj2W6fhq6JkzxhPwCPON2M9vL44XNDTObRa1dA@mail.gmail.com>
Subject: Re: [PATCH v3 10/12] KVM: arm64: selftests: Add host support for vGIC
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 3, 2021 at 3:52 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Wed, Sep 01, 2021 at 09:14:10PM +0000, Raghavendra Rao Ananta wrote:
> > Implement a simple library to do perform vGIC-v3
> > setup from a host of view. This includes creating
> > a vGIC device, setting up distributor and redistributor
> > attributes, and mapping the guest physical addresses.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> >
> > ---
> >  tools/testing/selftests/kvm/Makefile          |  2 +-
> >  .../selftests/kvm/include/aarch64/vgic.h      | 14 ++++
> >  .../testing/selftests/kvm/lib/aarch64/vgic.c  | 67 +++++++++++++++++++
> >  3 files changed, 82 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
> >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 5476a8ddef60..8342f65c1d96 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -35,7 +35,7 @@ endif
> >
> >  LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
> >  LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
> > -LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c
> > +LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
> >  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
> >
> >  TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> > new file mode 100644
> > index 000000000000..45bbf238147a
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> > @@ -0,0 +1,14 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * ARM Generic Interrupt Controller (GIC) host specific defines
> > + */
> > +
> > +#ifndef SELFTEST_KVM_VGIC_H
> > +#define SELFTEST_KVM_VGIC_H
> > +
> > +#include <linux/kvm.h>
> > +
> > +int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
> > +             uint64_t gicd_base_gpa, uint64_t gicr_base_gpa, uint32_t slot);
>
> Having seen 5 arguments used in the vgic_v3_setup call in the next patch I
> came back here to refresh my memory on that parameter. 'slot' is the one I
> forgot, but...
>
> > +
> > +#endif /* SELFTEST_KVM_VGIC_H */
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > new file mode 100644
> > index 000000000000..a0e4b986d335
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > @@ -0,0 +1,67 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * ARM Generic Interrupt Controller (GIC) v3 host support
> > + */
> > +
> > +#include <linux/kvm.h>
> > +#include <linux/sizes.h>
> > +
> > +#include "kvm_util.h"
> > +
> > +#define VGIC_V3_GICD_SZ              (SZ_64K)
> > +#define VGIC_V3_GICR_SZ              (2 * SZ_64K)
> > +
> > +#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) \
> > +     (((uint64_t)(count) << 52) | \
> > +     ((uint64_t)((base) >> 16) << 16) | \
> > +     ((uint64_t)(flags) << 12) | \
> > +     index)
> > +
> > +static void vgic_v3_map(struct kvm_vm *vm, uint64_t addr, unsigned int size)
> > +{
> > +     unsigned int n_pages = DIV_ROUND_UP(size, vm_get_page_size(vm));
> > +
> > +     virt_map(vm, addr, addr, n_pages);
> > +}
> > +
> > +/*
> > + * vGIC-v3 default host setup
> > + *
> > + * Input args:
> > + *   vm - KVM VM
> > + *   nr_vcpus - Number of vCPUs for this VM
> > + *   gicd_base_gpa - Guest Physical Address of the Distributor region
> > + *   gicr_base_gpa - Guest Physical Address of the Redistributor region
> > + *
> > + * Output args: None
> > + *
> > + * Return: GIC file-descriptor or negative error code upon failure
> > + *
> > + * The function creates a vGIC-v3 device and maps the distributor and
> > + * redistributor regions of the guest.
> > + */
> > +int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
> > +             uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
>
> ...looks like it was forgotten here too.
>
You are right. I had 'slot' to try other mechanisms, but I guess I
forgot to clean it up.
Thanks for catching this.

Regards,
Raghavendra

> Thanks,
> drew
>
> > +{
> > +     uint64_t redist_attr;
> > +     int gic_fd;
> > +
> > +     TEST_ASSERT(nr_vcpus <= KVM_MAX_VCPUS,
> > +                     "Invalid number of CPUs: %u\n", nr_vcpus);
> > +
> > +     gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> > +
> > +     kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +                     KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
> > +     vgic_v3_map(vm, gicd_base_gpa, VGIC_V3_GICD_SZ);
> > +
> > +     redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
> > +     kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +                     KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr, true);
> > +     vgic_v3_map(vm, gicr_base_gpa, VGIC_V3_GICR_SZ * nr_vcpus);
> > +
> > +     kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> > +                             KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> > +
> > +     return gic_fd;
> > +}
> > --
> > 2.33.0.153.gba50c8fa24-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >
>
