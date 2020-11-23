Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C532C0243
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 10:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgKWJ1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 04:27:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgKWJ1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Nov 2020 04:27:10 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 952B720773;
        Mon, 23 Nov 2020 09:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606123629;
        bh=tKKya71aIfR/58bDPs9+LCebGD0IANotinwA5misRc8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OEHWSkSi7cMWAlYqNXglNL846Y+HLs2L4s5husu6wOMdHlTXHEyan0J/Uz0I4zhHS
         lw+1zMzIfKEQYuRRaLy6ylaou1f7r50dYjm/3NaECxQlTIo+beNuw0O3YoMdBiVr49
         sDyUBmAzkajfLoNUb79ttjP07S61K1o8Uk3g0hY8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kh87n-00CruO-KX; Mon, 23 Nov 2020 09:27:07 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 23 Nov 2020 09:27:07 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, Neo Jia <cjia@nvidia.com>,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
In-Reply-To: <20201123065410.1915-4-lushenming@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-4-lushenming@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <5c724bb83730cdd5dcf7add9a812fa92@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, christoffer.dall@arm.com, alex.williamson@redhat.com, kwankhede@nvidia.com, cohuck@redhat.com, cjia@nvidia.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-11-23 06:54, Shenming Lu wrote:
> From: Zenghui Yu <yuzenghui@huawei.com>
> 
> When setting the forwarding path of a VLPI, it is more consistent to

I'm not sure it is more consistent. It is a *new* behaviour, because it 
only
matters for migration, which has been so far unsupported.

> also transfer the pending state from irq->pending_latch to VPT 
> (especially
> in migration, the pending states of VLPIs are restored into kvm’s vgic
> first). And we currently send "INT+VSYNC" to trigger a VLPI to pending.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Shenming Lu <lushenming@huawei.com>
> ---
>  arch/arm64/kvm/vgic/vgic-v4.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c 
> b/arch/arm64/kvm/vgic/vgic-v4.c
> index b5fa73c9fd35..cc3ab9cea182 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> @@ -418,6 +418,18 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, 
> int virq,
>  	irq->host_irq	= virq;
>  	atomic_inc(&map.vpe->vlpi_count);
> 
> +	/* Transfer pending state */
> +	ret = irq_set_irqchip_state(irq->host_irq,
> +				    IRQCHIP_STATE_PENDING,
> +				    irq->pending_latch);
> +	WARN_RATELIMIT(ret, "IRQ %d", irq->host_irq);
> +
> +	/*
> +	 * Let it be pruned from ap_list later and don't bother
> +	 * the List Register.
> +	 */
> +	irq->pending_latch = false;

It occurs to me that calling into irq_set_irqchip_state() for a large
number of interrupts can take a significant amount of time. It is also
odd that you dump the VPT with the VPE unmapped, but rely on the VPE
being mapped for the opposite operation.

Shouldn't these be symmetric, all performed while the VPE is unmapped?
It would also save a lot of ITS traffic.

> +
>  out:
>  	mutex_unlock(&its->its_lock);
>  	return ret;

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
