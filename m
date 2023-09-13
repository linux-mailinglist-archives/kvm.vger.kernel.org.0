Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C5679F14F
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 20:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbjIMSmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 14:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjIMSmo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 14:42:44 -0400
Received: from out-210.mta1.migadu.com (out-210.mta1.migadu.com [IPv6:2001:41d0:203:375::d2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A440BA3
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 11:42:40 -0700 (PDT)
Date:   Wed, 13 Sep 2023 18:42:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694630556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zbGmeaiAhruCsTYtUBEjHjtu3fwpdJmWOhi1GQR/CuQ=;
        b=nB+4ixR36xp5mTADmigicU6BIarSlxQlccDXHV1SUJ7P8f6pFGZVg4OF/uIv7pcoe9hdad
        jBdPUyp1xeot1bSoOjjyBPz8i/wj52zbxAV3IaqQycfdzLdM2EIt0AnekYJXHBLP8UAI7J
        X8kE56ZheHYdxhuKrin2YEMhf5bFFtg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH kvmtool v3 00/17] aarch64: Handle PSCI calls in userspace
Message-ID: <ZQIClyAyD4Y67qng@linux.dev>
References: <20230802234255.466782-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230802234255.466782-1-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Will,

Haven't heard anything on v2 or v3 of this series and this has been on
the list for a while. Any thoughts?

I want to get a VMM using the SMCCC filtering UAPI ahead of CPU hotplug
on QEMU so we have some test coverage :) There's a knock-on benefit of
plugging some of the inherent races in system-scoped PSCI calls getting
out to userspace too.

--
Thanks,
Oliver

On Wed, Aug 02, 2023 at 11:42:38PM +0000, Oliver Upton wrote:
> v3 of the series to do PSCI calls in userspace, as an example for using
> the SMCCC filtering API added to KVM in 6.4.
> 
> v2 -> v3:
>  - Dropped some of the headers patches since they've already been
>    updated
>  - Redo header imports on top of 6.5-rc1
>  - Actually use the right subject prefix...
> 
> v2: https://lore.kernel.org/kvmarm/20230620163353.2688567-1-oliver.upton@linux.dev/
> 
> Oliver Upton (17):
>   Import arm-smccc.h from Linux 6.5-rc1
>   aarch64: Copy cputype.h from Linux 6.5-rc1
>   Update psci.h to Linux 6.5-rc1
>   arm: Stash kvm_vcpu_init for later use
>   arm: Use KVM_SET_MP_STATE ioctl to power off non-boot vCPUs
>   aarch64: Expose ARM64_CORE_REG() for general use
>   arm: Generalize execution state specific VM initialization
>   Add helpers to pause the VM from vCPU thread
>   aarch64: Add support for finding vCPU for given MPIDR
>   aarch64: Add skeleton implementation for PSCI
>   aarch64: psci: Implement CPU_SUSPEND
>   aarch64: psci: Implement CPU_OFF
>   aarch64: psci: Implement CPU_ON
>   aarch64: psci: Implement AFFINITY_INFO
>   aarch64: psci: Implement MIGRATE_INFO_TYPE
>   aarch64: psci: Implement SYSTEM_{OFF,RESET}
>   aarch64: smccc: Start sending PSCI to userspace
> 
>  Makefile                                  |   4 +-
>  arm/aarch32/include/kvm/kvm-arch.h        |   2 +-
>  arm/aarch32/kvm-cpu.c                     |   5 +
>  arm/aarch64/include/asm/cputype.h         | 186 +++++++++++++++++
>  arm/aarch64/include/asm/smccc.h           |  65 ++++++
>  arm/aarch64/include/kvm/kvm-arch.h        |   2 +-
>  arm/aarch64/include/kvm/kvm-config-arch.h |   6 +-
>  arm/aarch64/include/kvm/kvm-cpu-arch.h    |  28 ++-
>  arm/aarch64/kvm-cpu.c                     |  48 +++--
>  arm/aarch64/kvm.c                         |  25 ++-
>  arm/aarch64/psci.c                        | 207 +++++++++++++++++++
>  arm/aarch64/smccc.c                       |  81 ++++++++
>  arm/include/arm-common/kvm-arch.h         |   2 +
>  arm/include/arm-common/kvm-config-arch.h  |   1 +
>  arm/include/arm-common/kvm-cpu-arch.h     |   2 +-
>  arm/kvm-cpu.c                             |  21 +-
>  arm/kvm.c                                 |   2 +-
>  include/kvm/kvm-cpu.h                     |   3 +
>  include/linux/arm-smccc.h                 | 240 ++++++++++++++++++++++
>  include/linux/psci.h                      |  47 +++++
>  kvm-cpu.c                                 |  16 ++
>  21 files changed, 959 insertions(+), 34 deletions(-)
>  create mode 100644 arm/aarch64/include/asm/cputype.h
>  create mode 100644 arm/aarch64/include/asm/smccc.h
>  create mode 100644 arm/aarch64/psci.c
>  create mode 100644 arm/aarch64/smccc.c
>  create mode 100644 include/linux/arm-smccc.h
> 
> 
> base-commit: 106e2ea7756d980454d68631b87d5e25ba4e4881
> -- 
> 2.41.0.585.gd2178a4bd4-goog
> 

-- 
Thanks,
Oliver
