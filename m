Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A31B40579B
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 15:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357301AbhIINi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 09:38:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32897 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377052AbhIINff (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 09:35:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631194466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2Q7pFBb41mM6ea1MZnjVghiyEWdoCaTiHYJmPRbmHnQ=;
        b=Z8aDLShh1s0kRe4EiMauK5n6/U7dtFYZDLpJUc/ytFT+9DI3losV71SF/KH158S1VVZjGc
        yGyLnrQV7X1CkhZF8TLPAwoLO86y9VazRljPvKbgkFqAcsInX4U6NMoGSeaRbbdra5d2wD
        MAb+L1iCTHsfg8/gc6loRi+TbQc1VmY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-w0eo5HvbOcmqi1fyNStISw-1; Thu, 09 Sep 2021 09:34:25 -0400
X-MC-Unique: w0eo5HvbOcmqi1fyNStISw-1
Received: by mail-wm1-f72.google.com with SMTP id b139-20020a1c8091000000b002fb33c467c8so776311wmd.5
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 06:34:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2Q7pFBb41mM6ea1MZnjVghiyEWdoCaTiHYJmPRbmHnQ=;
        b=gTkIs7ACYMSKF+CyJ0Wu5xO/aY43EIY4IseimmRSc03I7ubbRJPO6+RqWOPZsTNCep
         yHDBmyP1xZ17/2hLQtQ5zp9vFbFldXLbPdG0UdtXcA7cwMAq5M4Lpum54PPkrPGeeewq
         6NLwhqZYabs/bfem4m9nqBYOqOGKrUnr7RBLh53lkkeHMgYa+1gZaYH8gN/6HLPDuRnr
         QXstgSXLBQflBtnr5yh4naQf1pXAOHHSuR/J4lqm4I3RjLc9xfhIx2/37Uij+0DXySJ4
         KyCikDEwOFA0Oi2U5bL2B7a7ISAuUDa76Hd1VeDAeNbrmN22FNSqX3w53sWj2NIXS88H
         13CQ==
X-Gm-Message-State: AOAM531caI96weWxN7j9i+cHv8DLGzd127tekQAWzSD7fAt3G310/OB2
        DG7pca1p93BFQn//uM5SXhfDXZWgUodC9Jiin43tS/c/74OkFYJbNsrOdzRRDjtfxPFwZGkk8M6
        U4QZW75hO60zc
X-Received: by 2002:adf:b60f:: with SMTP id f15mr3665005wre.257.1631194463942;
        Thu, 09 Sep 2021 06:34:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAa/35Y8EeWRcAEuDGOq75zQKTD2hppp6pTHEcWPqQ1zyn1QeYm1M8X/dALPxOElMhuVHRDQ==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr3664972wre.257.1631194463710;
        Thu, 09 Sep 2021 06:34:23 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id o10sm2053571wrc.16.2021.09.09.06.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 06:34:23 -0700 (PDT)
Date:   Thu, 9 Sep 2021 15:34:21 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Raghavendra Rao Ananta <rananta@google.com>,
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
Subject: Re: [PATCH v4 14/18] KVM: arm64: selftests: Add host support for vGIC
Message-ID: <20210909133421.rdkueb627glve6uz@gator>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-15-rananta@google.com>
 <YTmce6Xn+ymngA+r@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTmce6Xn+ymngA+r@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 05:32:43AM +0000, Oliver Upton wrote:
> Hi Raghu,
> 
> On Thu, Sep 09, 2021 at 01:38:14AM +0000, Raghavendra Rao Ananta wrote:
> > Implement a simple library to perform vGIC-v3 setup
> > from a host point of view. This includes creating a
> > vGIC device, setting up distributor and redistributor
> > attributes, and mapping the guest physical addresses.
> > 
> > The definition of REDIST_REGION_ATTR_ADDR is taken
> > from aarch64/vgic_init test.
> >
> 
> Consider dropping the macro from vgic_init.c and have it just include
> vgic.h

Yes, I agree 18/18 should be squashed into this one.

> 
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |  2 +-
> >  .../selftests/kvm/include/aarch64/vgic.h      | 20 +++++++
> >  .../testing/selftests/kvm/lib/aarch64/vgic.c  | 60 +++++++++++++++++++
> >  3 files changed, 81 insertions(+), 1 deletion(-)
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
> > index 000000000000..3a776af958a0
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> > @@ -0,0 +1,20 @@
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
> > +#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) \
> > +	(((uint64_t)(count) << 52) | \
> > +	((uint64_t)((base) >> 16) << 16) | \
> > +	((uint64_t)(flags) << 12) | \
> > +	index)
> > +
> > +int vgic_v3_setup(struct kvm_vm *vm,
> > +				uint64_t gicd_base_gpa, uint64_t gicr_base_gpa);
> > +
> > +#endif /* SELFTEST_KVM_VGIC_H */
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > new file mode 100644
> > index 000000000000..2318912ab134
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > @@ -0,0 +1,60 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * ARM Generic Interrupt Controller (GIC) v3 host support
> > + */
> > +
> > +#include <linux/kvm.h>
> > +#include <linux/sizes.h>
> > +
> > +#include "kvm_util.h"
> > +#include "vgic.h"
> > +
> > +#define VGIC_V3_GICD_SZ		(SZ_64K)
> > +#define VGIC_V3_GICR_SZ		(2 * SZ_64K)
> 
> These values are UAPI, consider dropping them in favor of the
> definitions from asm/kvm.h

Yes, please.

> 
> > +
> > +/*
> > + * vGIC-v3 default host setup
> > + *
> > + * Input args:
> > + *	vm - KVM VM
> > + *	gicd_base_gpa - Guest Physical Address of the Distributor region
> > + *	gicr_base_gpa - Guest Physical Address of the Redistributor region
> > + *
> > + * Output args: None
> > + *
> > + * Return: GIC file-descriptor or negative error code upon failure
> > + *
> > + * The function creates a vGIC-v3 device and maps the distributor and
> > + * redistributor regions of the guest. Since it depends on the number of
> > + * vCPUs for the VM, it must be called after all the vCPUs have been created.
> 
> You could avoid the ordering dependency by explicitly taking nr_vcpus as
> an arg. It would also avoid the need for 12/18.

All the vcpus need to be created prior to calling
KVM_DEV_ARM_VGIC_CTRL_INIT, so even though I don't disagree with
simply passing nr_vcpus to this function, we should still assert
if the VM's idea of the number doesn't match. But, this is a lib
file, so there's no reason not to do

#include "../kvm_util_internal.h"

and just access the vcpu list to get the count or, if we add a
new internal nr_vcpus member, access it directly. IOW, so far
I don't believe we need vm_get_nr_vcpus().

> 
> Also note the required alignment on the GPA arguments you're taking.
> 
> > + */
> > +int vgic_v3_setup(struct kvm_vm *vm,
> > +		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
> > +{
> > +	uint64_t redist_attr;
> > +	int gic_fd, nr_vcpus;
> > +	unsigned int nr_gic_pages;
> > +
> > +	nr_vcpus = vm_get_nr_vcpus(vm);
> > +	TEST_ASSERT(nr_vcpus > 0, "Invalid number of CPUs: %u\n", nr_vcpus);
> > +
> > +	/* Distributor setup */
> > +	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> > +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
> > +	nr_gic_pages = vm_calc_num_guest_pages(vm_get_mode(vm), VGIC_V3_GICD_SZ);
> > +	virt_map(vm, gicd_base_gpa, gicd_base_gpa,  nr_gic_pages);
> > +
> > +	/* Redistributor setup */
> > +	redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
> > +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr, true);
> > +	nr_gic_pages = vm_calc_num_guest_pages(vm_get_mode(vm),
> > +						VGIC_V3_GICR_SZ * nr_vcpus);
> > +	virt_map(vm, gicr_base_gpa, gicr_base_gpa,  nr_gic_pages);
> > +
> > +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> > +				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> > +
> > +	return gic_fd;
> > +}
> > -- 
> > 2.33.0.153.gba50c8fa24-goog
> > 
>

Thanks,
drew 

