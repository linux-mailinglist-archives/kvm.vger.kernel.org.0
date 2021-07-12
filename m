Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC5A3C5F98
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 17:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbhGLPrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 11:47:04 -0400
Received: from foss.arm.com ([217.140.110.172]:57294 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233648AbhGLPrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 11:47:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E1141FB;
        Mon, 12 Jul 2021 08:44:15 -0700 (PDT)
Received: from [10.57.36.240] (unknown [10.57.36.240])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 580EE3F774;
        Mon, 12 Jul 2021 08:44:13 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: arm64: Disabling disabled PMU counters wastes a
 lot of time
To:     Alexandre Chartre <alexandre.chartre@oracle.com>, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, alexandru.elisei@arm.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     konrad.wilk@oracle.com
References: <20210712151700.654819-1-alexandre.chartre@oracle.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <d4646297-da3a-c629-d0b2-b830cce6a656@arm.com>
Date:   Mon, 12 Jul 2021 16:44:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712151700.654819-1-alexandre.chartre@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-07-12 16:17, Alexandre Chartre wrote:
> In a KVM guest on arm64, performance counters interrupts have an
> unnecessary overhead which slows down execution when using the "perf
> record" command and limits the "perf record" sampling period.
> 
> The problem is that when a guest VM disables counters by clearing the
> PMCR_EL0.E bit (bit 0), KVM will disable all counters defined in
> PMCR_EL0 even if they are not enabled in PMCNTENSET_EL0.
> 
> KVM disables a counter by calling into the perf framework, in particular
> by calling perf_event_create_kernel_counter() which is a time consuming
> operation. So, for example, with a Neoverse N1 CPU core which has 6 event
> counters and one cycle counter, KVM will always disable all 7 counters
> even if only one is enabled.
> 
> This typically happens when using the "perf record" command in a guest
> VM: perf will disable all event counters with PMCNTENTSET_EL0 and only
> uses the cycle counter. And when using the "perf record" -F option with
> a high profiling frequency, the overhead of KVM disabling all counters
> instead of one on every counter interrupt becomes very noticeable.
> 
> The problem is fixed by having KVM disable only counters which are
> enabled in PMCNTENSET_EL0. If a counter is not enabled in PMCNTENSET_EL0
> then KVM will not enable it when setting PMCR_EL0.E and it will remain
> disabled as long as it is not enabled in PMCNTENSET_EL0. So there is
> effectively no need to disable a counter when clearing PMCR_EL0.E if it
> is not enabled PMCNTENSET_EL0.
> 
> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> ---
> The patch is based on https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu/reset-values
> 
>   arch/arm64/kvm/pmu-emul.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index fae4e95b586c..1f317c3dac61 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -563,21 +563,23 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
>    */
>   void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
>   {
> -	unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
> +	unsigned long mask;
>   	int i;
>   
>   	if (val & ARMV8_PMU_PMCR_E) {
>   		kvm_pmu_enable_counter_mask(vcpu,
>   		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
>   	} else {
> -		kvm_pmu_disable_counter_mask(vcpu, mask);
> +		kvm_pmu_disable_counter_mask(vcpu,
> +		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
>   	}
>   
>   	if (val & ARMV8_PMU_PMCR_C)
>   		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
>   
>   	if (val & ARMV8_PMU_PMCR_P) {
> -		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
> +		mask = kvm_pmu_valid_counter_mask(vcpu)
> +			& BIT(ARMV8_PMU_CYCLE_IDX);

This looks suspiciously opposite of what it replaces; however did we 
even need to do a bitwise operation here in the first place? Couldn't we 
skip the cycle counter by just limiting the for_each_set_bit iteration 
below to 31 bits?

Robin.

>   		for_each_set_bit(i, &mask, 32)
>   			kvm_pmu_set_counter_value(vcpu, i, 0);
>   	}
> 
> base-commit: 83f870a663592797c576846db3611e0a1664eda2
> 
