Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E3840A8A0
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 09:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhINHva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 03:51:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231915AbhINHvQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 03:51:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631605799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R6Z78UAv1kninDvhZD/qhelNjlru3f9bIEDAEEJ+aas=;
        b=civYtNuqbQXIAvfT52tsD1J3Ww44wDSkPMYFSePm5Bwgul1qmANCIolgjwP76LGepo1Q+2
        JeF+Xx6JsKPXbvgFY77iCpVscZdkaZXzbaQb+MKOl9Tr9/YCCr7/t87OzWb4zfpvnKIiHr
        sD0W5ibmJ3Rfdw6KKnhnjGURhCSAJew=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-lc2ZcRV6OcqBkF-DXAvFsQ-1; Tue, 14 Sep 2021 03:49:57 -0400
X-MC-Unique: lc2ZcRV6OcqBkF-DXAvFsQ-1
Received: by mail-ed1-f69.google.com with SMTP id y19-20020a056402441300b003cd8ce2b987so6315453eda.6
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 00:49:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R6Z78UAv1kninDvhZD/qhelNjlru3f9bIEDAEEJ+aas=;
        b=vcf5rFyhg9bKbLDoHR3VRjou4yYGmKXkcG8iXc7erjcNFkt5bFpC3aAi14ytwuzBIQ
         W8aFQ2ybip5TqM7W8SJ3TZ1SjYNgJxJ1SS14cTkSn5sq96a9L/nn8AyboPBElQ+ckaOQ
         RHFpK4dW1lmLvf6g8UhRHvwqE2giqI4Pz5ybPROIt9crsnniUjKmxfCg0tMkvxzIVDOz
         NAiPiTWorl0CFt+El3qAK4Mz+iUdmSmLLxpQzHHTylVupglrr/qZ1REd1Pa9IJi9VZOn
         aUscsbmn9P/hLfwNE6pLUZLuucXu4ank403HXrSIB1CCfWeXubE9l5p99irpb0X24riO
         8s0Q==
X-Gm-Message-State: AOAM532oekIrh4qePR3GbzEPxY6BAb0gHrChFvmmYw/ASk/T0vPeptgZ
        Fz4bc9VqAZWY2TQDgeMmZHo5o19D3hVZqrlisaP8GZjT1rCctVKDyM4KIm6zS/CsK18YIwyjiQ0
        5UHPV5/46Z8NA
X-Received: by 2002:a17:906:50d:: with SMTP id j13mr10991466eja.58.1631605796665;
        Tue, 14 Sep 2021 00:49:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJTsoIi5L3KoB/sC54f49zilK1+Lotlu4FXZaBZwCghtwsY0aj86bOujiop9u3X1CIuwd6VQ==
X-Received: by 2002:a17:906:50d:: with SMTP id j13mr10991428eja.58.1631605796384;
        Tue, 14 Sep 2021 00:49:56 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id dj8sm3925587edb.53.2021.09.14.00.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 00:49:55 -0700 (PDT)
Date:   Tue, 14 Sep 2021 09:49:53 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
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
Subject: Re: [PATCH v6 12/14] KVM: arm64: selftests: Add host support for vGIC
Message-ID: <20210914074953.lijtspubonocwz4u@gator.home>
References: <20210913230955.156323-1-rananta@google.com>
 <20210913230955.156323-13-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913230955.156323-13-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 11:09:53PM +0000, Raghavendra Rao Ananta wrote:
> Implement a simple library to perform vGIC-v3 setup
> from a host point of view. This includes creating a
> vGIC device, setting up distributor and redistributor
> attributes, and mapping the guest physical addresses.
> 
> The definition of REDIST_REGION_ATTR_ADDR is taken from
> aarch64/vgic_init test. Hence, replace the definition
> by including vgic.h in the test file.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  2 +-
>  .../testing/selftests/kvm/aarch64/vgic_init.c |  3 +-
>  .../selftests/kvm/include/aarch64/vgic.h      | 20 ++++++
>  .../testing/selftests/kvm/lib/aarch64/vgic.c  | 70 +++++++++++++++++++
>  4 files changed, 92 insertions(+), 3 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 5476a8ddef60..8342f65c1d96 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -35,7 +35,7 @@ endif
>  
>  LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
>  LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
> -LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c
> +LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
>  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
>  
>  TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 623f31a14326..157fc24f39c5 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -13,11 +13,10 @@
>  #include "test_util.h"
>  #include "kvm_util.h"
>  #include "processor.h"
> +#include "vgic.h"
>  
>  #define NR_VCPUS		4
>  
> -#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) (((uint64_t)(count) << 52) | \
> -	((uint64_t)((base) >> 16) << 16) | ((uint64_t)(flags) << 12) | index)
>  #define REG_OFFSET(vcpu, offset) (((uint64_t)vcpu << 32) | offset)
>  
>  #define GICR_TYPER 0x8
> diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> new file mode 100644
> index 000000000000..0ecfb253893c
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * ARM Generic Interrupt Controller (GIC) host specific defines
> + */
> +
> +#ifndef SELFTEST_KVM_VGIC_H
> +#define SELFTEST_KVM_VGIC_H
> +
> +#include <linux/kvm.h>
> +
> +#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) \
> +	(((uint64_t)(count) << 52) | \
> +	((uint64_t)((base) >> 16) << 16) | \
> +	((uint64_t)(flags) << 12) | \
> +	index)
> +
> +int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
> +		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa);
> +
> +#endif /* SELFTEST_KVM_VGIC_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> new file mode 100644
> index 000000000000..9880caa8c7db
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> @@ -0,0 +1,70 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * ARM Generic Interrupt Controller (GIC) v3 host support
> + */
> +
> +#include <linux/kvm.h>
> +#include <linux/sizes.h>
> +#include <asm/kvm.h>
> +
> +#include "kvm_util.h"
> +#include "../kvm_util_internal.h"
> +#include "vgic.h"
> +
> +/*
> + * vGIC-v3 default host setup
> + *
> + * Input args:
> + *	vm - KVM VM
> + *	nr_vcpus - Number of vCPUs supported by this VM
> + *	gicd_base_gpa - Guest Physical Address of the Distributor region
> + *	gicr_base_gpa - Guest Physical Address of the Redistributor region
> + *
> + * Output args: None
> + *
> + * Return: GIC file-descriptor or negative error code upon failure
> + *
> + * The function creates a vGIC-v3 device and maps the distributor and
> + * redistributor regions of the guest. Since it depends on the number of
> + * vCPUs for the VM, it must be called after all the vCPUs have been created.
> + */
> +int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
> +		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
> +{
> +	int gic_fd;
> +	uint64_t redist_attr;
> +	struct list_head *iter;
> +	unsigned int nr_gic_pages, nr_vcpus_created = 0;
> +
> +	TEST_ASSERT(nr_vcpus, "Num of vCPUs cannot be empty\n");

nit: I'd rather spell out 'Number'

> +
> +	/*
> +	 * Make sure that the caller is infact calling this
> +	 * function after all the vCPUs are added.
> +	 */
> +	list_for_each(iter, &vm->vcpus)
> +		nr_vcpus_created++;
> +	TEST_ASSERT(nr_vcpus == nr_vcpus_created,
> +			"No. of vCPUs requested (%u) doesn't match with the ones created for the VM (%u)\n",

nit: Same nit here, s/No./Number/

> +			nr_vcpus, nr_vcpus_created);
> +
> +	/* Distributor setup */
> +	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
> +	nr_gic_pages = vm_calc_num_guest_pages(vm->mode, KVM_VGIC_V3_DIST_SIZE);
> +	virt_map(vm, gicd_base_gpa, gicd_base_gpa,  nr_gic_pages);
> +
> +	/* Redistributor setup */
> +	redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
> +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr, true);
> +	nr_gic_pages = vm_calc_num_guest_pages(vm->mode,
> +						KVM_VGIC_V3_REDIST_SIZE * nr_vcpus);
> +	virt_map(vm, gicr_base_gpa, gicr_base_gpa,  nr_gic_pages);
> +
> +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> +				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> +
> +	return gic_fd;
> +}
> -- 
> 2.33.0.309.g3052b89438-goog
>

Otherwise,

Reviewed-by: Andrew Jones <drjones@redhat.com>

