Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE3271B3E
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 17:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390818AbfGWPPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 11:15:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34928 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728605AbfGWPPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 11:15:01 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E9CE530BD1B5;
        Tue, 23 Jul 2019 15:15:00 +0000 (UTC)
Received: from [10.36.116.111] (ovpn-116-111.ams2.redhat.com [10.36.116.111])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5908A5C25A;
        Tue, 23 Jul 2019 15:14:58 +0000 (UTC)
Subject: Re: [PATCH v2 9/9] KVM: arm/arm64: vgic-irqfd: Implement
 kvm_arch_set_irq_inatomic
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Saidi, Ali" <alisaidi@amazon.com>
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-10-marc.zyngier@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <a63b08b8-9539-09b4-1060-7c0d2f2eacac@redhat.com>
Date:   Tue, 23 Jul 2019 17:14:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190611170336.121706-10-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 23 Jul 2019 15:15:01 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/11/19 7:03 PM, Marc Zyngier wrote:
> Now that we have a cache of MSI->LPI translations, it is pretty
> easy to implement kvm_arch_set_irq_inatomic (this cache can be
> parsed without sleeping).
> 
> Hopefully, this will improve some LPI-heavy workloads.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-irqfd.c | 36 ++++++++++++++++++++++++++++------
>  1 file changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
> index 99e026d2dade..9f203ed8c8f3 100644
> --- a/virt/kvm/arm/vgic/vgic-irqfd.c
> +++ b/virt/kvm/arm/vgic/vgic-irqfd.c
> @@ -77,6 +77,15 @@ int kvm_set_routing_entry(struct kvm *kvm,
>  	return r;
>  }
>  
> +static void kvm_populate_msi(struct kvm_kernel_irq_routing_entry *e,
> +			     struct kvm_msi *msi)
> +{
> +	msi->address_lo = e->msi.address_lo;
> +	msi->address_hi = e->msi.address_hi;
> +	msi->data = e->msi.data;
> +	msi->flags = e->msi.flags;
> +	msi->devid = e->msi.devid;
> +}
>  /**
>   * kvm_set_msi: inject the MSI corresponding to the
s/:/ -
>   * MSI routing entry
> @@ -90,21 +99,36 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>  {
>  	struct kvm_msi msi;
>  
> -	msi.address_lo = e->msi.address_lo;
> -	msi.address_hi = e->msi.address_hi;
> -	msi.data = e->msi.data;
> -	msi.flags = e->msi.flags;
> -	msi.devid = e->msi.devid;
> -
>  	if (!vgic_has_its(kvm))
>  		return -ENODEV;
>  
>  	if (!level)
>  		return -1;
>  
> +	kvm_populate_msi(e, &msi);
>  	return vgic_its_inject_msi(kvm, &msi);
>  }
>  
> +/**
> + * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
s/:/ -
> + *
> + * Currently only direct MSI injecton is supported.
injection
> + */
> +int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
> +			      struct kvm *kvm, int irq_source_id, int level,
> +			      bool line_status)
> +{
> +	if (e->type == KVM_IRQ_ROUTING_MSI && vgic_has_its(kvm) && level) {
> +		struct kvm_msi msi;
> +
> +		kvm_populate_msi(e, &msi);
> +		if (!vgic_its_inject_cached_translation(kvm, &msi))
> +			return 0;
if this fails since its->enabled is false we will re-attempt the
injection though the normal injection path but that's not a big deal.
> +	}
> +
> +	return -EWOULDBLOCK;
> +}
> +
>  int kvm_vgic_setup_default_irq_routing(struct kvm *kvm)
>  {
>  	struct kvm_irq_routing_entry *entries;
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
