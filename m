Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7149E404504
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 07:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350764AbhIIFd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 01:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350686AbhIIFd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 01:33:57 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECE0C061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 22:32:48 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id q14so729019ils.5
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 22:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uO4bsB+6h1SkfyOTxGvMYZkgzROJsoMx/H8JH87r7zc=;
        b=OiARu9fb/JCEbCLzzQMjW6J0FA4zszahZpoHEclEKfKOaW6JuxVDZQrZrZf5QArzaB
         iJ7MxeVrpRzpv9Lgd3NLOPc2d6qx/RC5je4AQHR/+3MWrXylJrWTiKEKMeIgJDFAC3Ia
         slV3O6+G/0v1PHUg6nsVDdMsvb/l1pA6q2wergZMZMoM7fa2LVdtWK63nJhwG8wXxNP7
         OpKsCaM+fldL6j9cOsYNYugGBd0N8OzDQ3myXGcLw650G2MqWgqhYRdXhPg1dMSw2sk3
         J9cFaLtMqK/v6rkrVYJbp2AJEZfdD8XTio1HGx04p6wGSmsaLlk4wpVNfsgZOCASoMmL
         Xx5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uO4bsB+6h1SkfyOTxGvMYZkgzROJsoMx/H8JH87r7zc=;
        b=LAccemQifDL8HPC2Ntu6WIbpWy7klbL6Mvr3oZyxiA0fQcbMyDBsD0TAEbmKOQA5H1
         V3W5Cp8839elZf+f5KZU3JbH3mJX6lR9vtKEZyeiXdEe+r1sQcmt6p/vNlUdmsrp+mWn
         Yi8wLaS10EpFah5RnSSfurE8Fzev7C0qFZKgrGe6tj0NFtWWV1HZSLmJ4E45VcfmAcwU
         pp+pepLynpygs9Gnb4QhBfnEXpkdkD0W/PkW0iwuvMA3EqMIr6mAENSIXypYWUinA1P+
         Xi7szc0s1fJZlFwZPyWQWTo1/tuf/LNzKHGpF8/2XeJ5cDtLAQaW6YeOhxiEPAuP2T2Z
         uP9Q==
X-Gm-Message-State: AOAM532dW+rETsmdslXZ0G17T+4XEE7tipoHbaBkGPBPiG1RWL8Yuzwp
        FpjUsHOVYF+A+/lw1YEOrSbhHg==
X-Google-Smtp-Source: ABdhPJyldUzCYnCEedSh69MH8LQDrdOIyzOvQZd+tpElsGAiCL1xslKOQtA3IhhJdQHw3TeuD9OZ+Q==
X-Received: by 2002:a05:6e02:1a87:: with SMTP id k7mr1080474ilv.122.1631165567547;
        Wed, 08 Sep 2021 22:32:47 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id t10sm418026iol.34.2021.09.08.22.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 22:32:47 -0700 (PDT)
Date:   Thu, 9 Sep 2021 05:32:43 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
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
Subject: Re: [PATCH v4 14/18] KVM: arm64: selftests: Add host support for vGIC
Message-ID: <YTmce6Xn+ymngA+r@google.com>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-15-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-15-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghu,

On Thu, Sep 09, 2021 at 01:38:14AM +0000, Raghavendra Rao Ananta wrote:
> Implement a simple library to perform vGIC-v3 setup
> from a host point of view. This includes creating a
> vGIC device, setting up distributor and redistributor
> attributes, and mapping the guest physical addresses.
> 
> The definition of REDIST_REGION_ATTR_ADDR is taken
> from aarch64/vgic_init test.
>

Consider dropping the macro from vgic_init.c and have it just include
vgic.h

> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  2 +-
>  .../selftests/kvm/include/aarch64/vgic.h      | 20 +++++++
>  .../testing/selftests/kvm/lib/aarch64/vgic.c  | 60 +++++++++++++++++++
>  3 files changed, 81 insertions(+), 1 deletion(-)
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
> diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> new file mode 100644
> index 000000000000..3a776af958a0
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
> +int vgic_v3_setup(struct kvm_vm *vm,
> +				uint64_t gicd_base_gpa, uint64_t gicr_base_gpa);
> +
> +#endif /* SELFTEST_KVM_VGIC_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> new file mode 100644
> index 000000000000..2318912ab134
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> @@ -0,0 +1,60 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * ARM Generic Interrupt Controller (GIC) v3 host support
> + */
> +
> +#include <linux/kvm.h>
> +#include <linux/sizes.h>
> +
> +#include "kvm_util.h"
> +#include "vgic.h"
> +
> +#define VGIC_V3_GICD_SZ		(SZ_64K)
> +#define VGIC_V3_GICR_SZ		(2 * SZ_64K)

These values are UAPI, consider dropping them in favor of the
definitions from asm/kvm.h

> +
> +/*
> + * vGIC-v3 default host setup
> + *
> + * Input args:
> + *	vm - KVM VM
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

You could avoid the ordering dependency by explicitly taking nr_vcpus as
an arg. It would also avoid the need for 12/18.

Also note the required alignment on the GPA arguments you're taking.

> + */
> +int vgic_v3_setup(struct kvm_vm *vm,
> +		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
> +{
> +	uint64_t redist_attr;
> +	int gic_fd, nr_vcpus;
> +	unsigned int nr_gic_pages;
> +
> +	nr_vcpus = vm_get_nr_vcpus(vm);
> +	TEST_ASSERT(nr_vcpus > 0, "Invalid number of CPUs: %u\n", nr_vcpus);
> +
> +	/* Distributor setup */
> +	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
> +	nr_gic_pages = vm_calc_num_guest_pages(vm_get_mode(vm), VGIC_V3_GICD_SZ);
> +	virt_map(vm, gicd_base_gpa, gicd_base_gpa,  nr_gic_pages);
> +
> +	/* Redistributor setup */
> +	redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
> +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr, true);
> +	nr_gic_pages = vm_calc_num_guest_pages(vm_get_mode(vm),
> +						VGIC_V3_GICR_SZ * nr_vcpus);
> +	virt_map(vm, gicr_base_gpa, gicr_base_gpa,  nr_gic_pages);
> +
> +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> +				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> +
> +	return gic_fd;
> +}
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 
