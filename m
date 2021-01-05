Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9997E2EA73E
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 10:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbhAEJZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 04:25:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726394AbhAEJZz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 04:25:55 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3B9620756;
        Tue,  5 Jan 2021 09:25:13 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kwiaV-005Oa8-O2; Tue, 05 Jan 2021 09:25:11 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 05 Jan 2021 09:25:11 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [RFC PATCH v2 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
In-Reply-To: <20210104081613.100-4-lushenming@huawei.com>
References: <20210104081613.100-1-lushenming@huawei.com>
 <20210104081613.100-4-lushenming@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <76a7b9cca485dc8157d3be53189eac69@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, eric.auger@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, cohuck@redhat.com, lorenzo.pieralisi@arm.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-01-04 08:16, Shenming Lu wrote:
> From: Zenghui Yu <yuzenghui@huawei.com>
> 
> When setting the forwarding path of a VLPI (switch to the HW mode),
> we could also transfer the pending state from irq->pending_latch to
> VPT (especially in migration, the pending states of VLPIs are restored
> into kvm’s vgic first). And we currently send "INT+VSYNC" to trigger
> a VLPI to pending.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Shenming Lu <lushenming@huawei.com>
> ---
>  arch/arm64/kvm/vgic/vgic-v4.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c 
> b/arch/arm64/kvm/vgic/vgic-v4.c
> index f211a7c32704..7945d6d09cdd 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> @@ -454,6 +454,18 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, 
> int virq,
>  	irq->host_irq	= virq;
>  	atomic_inc(&map.vpe->vlpi_count);
> 
> +	/* Transfer pending state */
> +	ret = irq_set_irqchip_state(irq->host_irq,
> +				    IRQCHIP_STATE_PENDING,
> +				    irq->pending_latch);
> +	WARN_RATELIMIT(ret, "IRQ %d", irq->host_irq);

Why do this if pending_latch is 0, which is likely to be
the overwhelming case?

> +
> +	/*
> +	 * Let it be pruned from ap_list later and don't bother
> +	 * the List Register.
> +	 */
> +	irq->pending_latch = false;

What guarantees the pruning? Pruning only happens on vcpu exit,
which means we may have the same interrupt via both the LR and
the stream interface, which I don't believe is legal (it is
like having two LRs holding the same interrupt).

> +
>  out:
>  	mutex_unlock(&its->its_lock);
>  	return ret;

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
