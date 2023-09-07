Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022FC7977A5
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 18:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240169AbjIGQaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 12:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238413AbjIGQ37 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 12:29:59 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A63362D77
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 09:27:59 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 726861576;
        Thu,  7 Sep 2023 08:31:34 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 25E643F67D;
        Thu,  7 Sep 2023 08:30:55 -0700 (PDT)
Date:   Thu, 7 Sep 2023 16:30:52 +0100
From:   Joey Gouly <joey.gouly@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>
Subject: Re: [PATCH 0/5] KVM: arm64: Accelerate lookup of vcpus by MPIDR
 values
Message-ID: <20230907153052.GD69899@e124191.cambridge.arm.com>
References: <20230907100931.1186690-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230907100931.1186690-1-maz@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 07, 2023 at 11:09:26AM +0100, Marc Zyngier wrote:
> Xu Zhao recently reported[1] that sending SGIs on large VMs was slower
> than expected, specially if targeting vcpus that have a high vcpu
> index. They root-caused it to the way we walk the vcpu xarray in the
> search of the correct MPIDR, one vcpu at a time, which is of course
> grossly inefficient.
> 
> The solution they proposed was, unfortunately, less than ideal, but I
> was "nerd snipped" into doing something about it.
> 
> The main idea is to build a small hash table of MPIDR to vcpu
> mappings, using the fact that most of the time, the MPIDR values only
> use a small number of significant bits and that we can easily compute
> a compact index from it. Once we have that, accelerating vcpu lookup
> becomes pretty cheap, and we can in turn make SGIs great again.
> 
> It must be noted that since the MPIDR values are controlled by
> userspace, it isn't always possible to allocate the hash table
> (userspace could build a 32 vcpu VM and allocate one bit of affinity
> to each of them, making all the bits significant). We thus always have
> an iterative fallback -- if it hurts, don't do that.
> 
> Performance wise, this is very significant: using the KUT micro-bench
> test with the following patch (always IPI-ing the last vcpu of the VM)
> and running it with large number of vcpus shows a large improvement
> (from 3832ns to 2593ns for a 64 vcpu VM, a 32% reduction, measured on
> an Ampere Altra). I expect that IPI-happy workloads could benefit from
> this.
> 
> Thanks,
> 
> 	M.
> 
> [1] https://lore.kernel.org/r/20230825015811.5292-1-zhaoxu.35@bytedance.com
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index bfd181dc..f3ac3270 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -88,7 +88,7 @@ static bool test_init(void)
>  
>  	irq_ready = false;
>  	gic_enable_defaults();
> -	on_cpu_async(1, gic_secondary_entry, NULL);
> +	on_cpu_async(nr_cpus - 1, gic_secondary_entry, NULL);
>  
>  	cntfrq = get_cntfrq();
>  	printf("Timer Frequency %d Hz (Output in microseconds)\n", cntfrq);
> @@ -157,7 +157,7 @@ static void ipi_exec(void)
>  
>  	irq_received = false;
>  
> -	gic_ipi_send_single(1, 1);
> +	gic_ipi_send_single(1, nr_cpus - 1);
>  
>  	while (!irq_received && tries--)
>  		cpu_relax();
> 

Got a roughly similar perf improvement (about 28%).

Tested-by: Joey Gouly <joey.gouly@arm.com>

> 
> Marc Zyngier (5):
>   KVM: arm64: Simplify kvm_vcpu_get_mpidr_aff()
>   KVM: arm64: Build MPIDR to vcpu index cache at runtime
>   KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is
>     available
>   KVM: arm64: vgic-v3: Refactor GICv3 SGI generation
>   KVM: arm64: vgic-v3: Optimize affinity-based SGI injection
> 
>  arch/arm64/include/asm/kvm_emulate.h |   2 +-
>  arch/arm64/include/asm/kvm_host.h    |  28 ++++++
>  arch/arm64/kvm/arm.c                 |  66 +++++++++++++
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c   | 142 ++++++++++-----------------
>  4 files changed, 148 insertions(+), 90 deletions(-)
