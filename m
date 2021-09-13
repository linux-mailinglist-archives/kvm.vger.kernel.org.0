Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22612409F04
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 23:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244129AbhIMVUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 17:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235017AbhIMVUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 17:20:34 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1811DC061760
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 14:19:18 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n4so6708785plh.9
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 14:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i/Jjfj1BpDVMPD66h9cOOp3YBPFZfQrclQlWPDsBWeQ=;
        b=VAqpQEpynREW1f7iQJmH5NV6JyX9arsySvNKuwJP8qH7ez9hcap4gMy9t27l6zgMJe
         yQMpd4yqU/OcKg2G70FAR3TZP2edZ0w/bMY+iZ6ha51AlCaYLt6bVm+hPopTd6J/oPJG
         QR0BhRW113jjQWMgokovvc0GqmQdwrmq4pnWehP5toQ5oN+rWedBdjK2vCw29SBvmlON
         n2REkqmPktveH60Z71cwJeJzaN21fXmm0dg6VIki4RySBk1Sh+k6jNNA1uUwEGlKf3YP
         kf5ZnuKPBQP5laaUtqlyjJmGIXE1STHD2N7Jne+uAu1gLX+OYNgMtxlDDy0vIIWO62XP
         i42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i/Jjfj1BpDVMPD66h9cOOp3YBPFZfQrclQlWPDsBWeQ=;
        b=o+OGiE7lgPwyMIJhz+Ak4DDIw0wMIUdplbw/rUdFtKMXAoQFB0aN4InqILlFBra4CW
         IUhkPyfJBB0BJCIwI0t37iOQAEuEKsXhip9DJfY5LZKEvJ7nnrbGFJU4dnuEbbm6pGpp
         X8RL3evqIRj7m8M+bRPqGSGyPpTm2Eui36FpwYywiyTVJxv7nLmI5yslpIiQvNR99S9L
         aQ0gviHzPbET9uyEmALHbM3tma6gyruPCzQ6SQb3mMeTEn0+VDXFnDke9kOmDHCrQhyc
         wWWonQvjls9RWCcPtz0FZxOANxuwK7JS/yAlW0bRbF6ylNlgbZJXoObwmbxMOUOJMWMh
         J9RQ==
X-Gm-Message-State: AOAM532eZM85qRo+g1aNui7AyS7jZgitNwPCUwmVHBcSF7lUl6GWSaHw
        FE6dwGC2UXYh5bA4iN0DRV5ckw==
X-Google-Smtp-Source: ABdhPJyEBTDlFTrOGN8EYLaXupB1lIwu62x3eGspmK3evPE4oId0aNZdXk2sA27q3e5zEqCe2vlLQg==
X-Received: by 2002:a17:902:e153:b0:13b:63ba:7288 with SMTP id d19-20020a170902e15300b0013b63ba7288mr11844243pla.33.1631567957322;
        Mon, 13 Sep 2021 14:19:17 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id x10sm8356833pfj.174.2021.09.13.14.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 14:19:16 -0700 (PDT)
Date:   Mon, 13 Sep 2021 14:19:12 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 12/14] KVM: arm64: selftests: Add host support for vGIC
Message-ID: <YT/AUOBJBN7TwbUc@google.com>
References: <20210913204930.130715-1-rananta@google.com>
 <20210913204930.130715-13-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913204930.130715-13-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 08:49:28PM +0000, Raghavendra Rao Ananta wrote:
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
> +
> +	/*
> +	 * Make sure that the caller is infact calling this
> +	 * function after all the vCPUs are added.
> +	 */
> +	list_for_each(iter, &vm->vcpus)
> +		nr_vcpus_created++;
> +	TEST_ASSERT(nr_vcpus == nr_vcpus_created,
> +			"No. of vCPUs requested (%u) doesn't match with the ones created for the VM (%u)\n",
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

Reviewed-by: Ricardo Koller <ricarkol@google.com>
