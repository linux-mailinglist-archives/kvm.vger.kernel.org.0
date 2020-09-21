Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936AD2725F0
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 15:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgIUNnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 09:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbgIUNnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 09:43:09 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 335472084C;
        Mon, 21 Sep 2020 13:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600695788;
        bh=ppWgQwIPJFgXvpl5SyaBDqV8l2T0GGovdfeRTgIHCFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WxRp7fNzBJpKQt2ftVmrIe0M00opXLZn+F2d5mDdpSKGn8lUe/l/M4uRs6n6sREdy
         bW0hA+DLr0AjQqCJBgrHPFgxzbq84ceM4vkef6/Rx84et6Iin19dgiliB/AzP8PonQ
         4ut8OFK2UunvFo4cAYtKyJOqaJGFdcG9RYMVTRe0=
Date:   Mon, 21 Sep 2020 14:43:02 +0100
From:   Will Deacon <will@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, maz@kernel.org, catalin.marinas@arm.com,
        swboyd@chromium.org, sumit.garg@linaro.org,
        Julien Thierry <julien.thierry@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v6 5/7] KVM: arm64: pmu: Make overflow handler NMI safe
Message-ID: <20200921134301.GJ2139@willie-the-truck>
References: <20200819133419.526889-1-alexandru.elisei@arm.com>
 <20200819133419.526889-6-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819133419.526889-6-alexandru.elisei@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 19, 2020 at 02:34:17PM +0100, Alexandru Elisei wrote:
> From: Julien Thierry <julien.thierry@arm.com>
> 
> kvm_vcpu_kick() is not NMI safe. When the overflow handler is called from
> NMI context, defer waking the vcpu to an irq_work queue.
> 
> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Suzuki K Pouloze <suzuki.poulose@arm.com>
> Cc: kvm@vger.kernel.org
> Cc: kvmarm@lists.cs.columbia.edu
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/pmu-emul.c | 25 ++++++++++++++++++++++++-
>  include/kvm/arm_pmu.h     |  1 +
>  2 files changed, 25 insertions(+), 1 deletion(-)

I'd like an Ack from the KVM side on this one, but some minor comments
inline.

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index f0d0312c0a55..30268397ed06 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -433,6 +433,22 @@ void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
>  	kvm_pmu_update_state(vcpu);
>  }
>  
> +/**
> + * When perf interrupt is an NMI, we cannot safely notify the vcpu corresponding
> + * to the event.
> + * This is why we need a callback to do it once outside of the NMI context.
> + */
> +static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_pmu *pmu;
> +
> +	pmu = container_of(work, struct kvm_pmu, overflow_work);
> +	vcpu = kvm_pmc_to_vcpu(&pmu->pmc[0]);

Can you spell this kvm_pmc_to_vcpu(pmu->pmc); ?

> +
> +	kvm_vcpu_kick(vcpu);

How do we guarantee that the vCPU is still around by the time this runs?
Sorry to ask such a horrible question, but I don't see anything associating
the workqueue with the lifetime of the vCPU.

Will
