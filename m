Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6592657C6
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 15:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbfGKNRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 09:17:05 -0400
Received: from foss.arm.com ([217.140.110.172]:46022 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728219AbfGKNRF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 09:17:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 279D52B;
        Thu, 11 Jul 2019 06:17:05 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D6103F59C;
        Thu, 11 Jul 2019 06:17:04 -0700 (PDT)
Subject: Re: [PATCH 48/59] KVM: arm64: nv: Load timer before the GIC
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-49-marc.zyngier@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ca6b0bf9-078f-fcc4-e689-46490153cc3f@arm.com>
Date:   Thu, 11 Jul 2019 14:17:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-49-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/21/19 10:38 AM, Marc Zyngier wrote:
> In order for vgic_v3_load_nested to be able to observe which
> which timer interrupts have the HW bit set for the current

s/which which/which

> context, the timers must have been loaded in the new mode
> and the right timer mapped to their corresponding HW IRQs.
>
> At the moment, we load the GIC first, meaning that timer
> interrupts injected to an L2 guest will never have the HW
> HW bit set (we see the old configuration).

s/HW HW/HW

> Swapping the two loads solves this particular problem.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/arm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index e8b584b79847..ca10a11e044e 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -361,8 +361,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	vcpu->arch.host_cpu_context = &cpu_data->host_ctxt;
>  
>  	kvm_arm_set_running_vcpu(vcpu);
> -	kvm_vgic_load(vcpu);
>  	kvm_timer_vcpu_load(vcpu);
> +	kvm_vgic_load(vcpu);
>  	kvm_vcpu_load_sysregs(vcpu);
>  	kvm_arch_vcpu_load_fp(vcpu);
>  	kvm_vcpu_pmu_restore_guest(vcpu);
