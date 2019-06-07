Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 588A5389E7
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 14:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbfFGMMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 08:12:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727386AbfFGMMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 08:12:08 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2B4B085376;
        Fri,  7 Jun 2019 12:11:58 +0000 (UTC)
Received: from [10.36.116.67] (ovpn-116-67.ams2.redhat.com [10.36.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F2857D951;
        Fri,  7 Jun 2019 12:11:50 +0000 (UTC)
Subject: Re: [PATCH 2/8] KVM: arm/arm64: vgic: Add __vgic_put_lpi_locked
 primitive
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>
References: <20190606165455.162478-1-marc.zyngier@arm.com>
 <20190606165455.162478-3-marc.zyngier@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <8048ab7f-a429-df29-43da-05ef97c9dc7a@redhat.com>
Date:   Fri, 7 Jun 2019 14:11:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190606165455.162478-3-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 07 Jun 2019 12:12:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,
On 6/6/19 6:54 PM, Marc Zyngier wrote:
> Our LPI translation cache needs to be able to drop the refcount
> on an LPI whilst already holding the lpi_list_lock.
> 
> Let's add a new primitive for this.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  virt/kvm/arm/vgic/vgic.c | 26 +++++++++++++++++---------
>  virt/kvm/arm/vgic/vgic.h |  1 +
>  2 files changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 191deccf60bf..376a297e2169 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -130,6 +130,22 @@ static void vgic_irq_release(struct kref *ref)
>  {
>  }
>  
> +/*
> + * Drop the refcount on the LPI. Must be called with lpi_list_lock held.
> + */
> +void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +
> +	if (!kref_put(&irq->refcount, vgic_irq_release))
> +		return;
> +
> +	list_del(&irq->lpi_list);
> +	dist->lpi_list_count--;
> +
> +	kfree(irq);
> +}
> +
>  void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> @@ -139,16 +155,8 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>  		return;
>  
>  	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
> -	if (!kref_put(&irq->refcount, vgic_irq_release)) {
> -		raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
> -		return;
> -	};
> -
> -	list_del(&irq->lpi_list);
> -	dist->lpi_list_count--;
> +	__vgic_put_lpi_locked(kvm, irq);
>  	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
> -
> -	kfree(irq);
>  }
>  
>  void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index a58e1b263dca..80cd40575bc9 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -172,6 +172,7 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
>  		     gpa_t addr, int len);
>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  			      u32 intid);
> +void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq);
>  void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
>  bool vgic_get_phys_line_level(struct vgic_irq *irq);
>  void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending);
> 
