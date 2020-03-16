Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF43187140
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 18:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732207AbgCPRez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 13:34:55 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:58532 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731937AbgCPRez (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 13:34:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584380093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1P9Nk1ZdLZSesaSGCEClbdSWJfHJa0QYY/vWnJS45h8=;
        b=CQvEoNdv1ygBwrnpOCK7rbdfHGI2SAmAD7G2qB48qUtvp82E8cErNaDY1tGcYcJsl5Pu7S
        bjmPboTmTZa03Mkgo14igVYHQgfcI7bAPRjoHDd1JM3ZTwZDrLJWZzRNhS3ND7e2m1o0xC
        kJS3rzVw5PeeXDIQVq7W8ok/d7gLg0g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-N6pR0s2hNOmDLHZVF9tbvg-1; Mon, 16 Mar 2020 13:34:50 -0400
X-MC-Unique: N6pR0s2hNOmDLHZVF9tbvg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55CC21804541;
        Mon, 16 Mar 2020 17:10:26 +0000 (UTC)
Received: from [10.36.118.12] (ovpn-118-12.ams2.redhat.com [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 47AE060BE2;
        Mon, 16 Mar 2020 17:10:20 +0000 (UTC)
Subject: Re: [PATCH v5 08/23] irqchip/gic-v4.1: Plumb skeletal VSGI irqchip
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-9-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <67a863c1-1d68-458a-39b1-6c43b8730d60@redhat.com>
Date:   Mon, 16 Mar 2020 18:10:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-9-maz@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 3/4/20 9:33 PM, Marc Zyngier wrote:
> Since GICv4.1 has the capability to inject 16 SGIs into each VPE,
> and that I'm keen not to invent too many specific interfaces to
> manipulate these interrupts, let's pretend that each of these SGIs
> is an actual Linux interrupt.
> 
> For that matter, let's introduce a minimal irqchip and irqdomain
> setup that will get fleshed up in the following patches.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  drivers/irqchip/irq-gic-v3-its.c   | 68 +++++++++++++++++++++++++++++-
>  drivers/irqchip/irq-gic-v4.c       |  8 +++-
>  include/linux/irqchip/arm-gic-v4.h |  9 +++-
>  3 files changed, 81 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 54d6fdf7a28e..112b452fcb40 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -3870,6 +3870,67 @@ static struct irq_chip its_vpe_4_1_irq_chip = {
>  	.irq_set_vcpu_affinity	= its_vpe_4_1_set_vcpu_affinity,
>  };
>  
> +static int its_sgi_set_affinity(struct irq_data *d,
> +				const struct cpumask *mask_val,
> +				bool force)
> +{
> +	return -EINVAL;
> +}
> +
> +static struct irq_chip its_sgi_irq_chip = {
> +	.name			= "GICv4.1-sgi",
> +	.irq_set_affinity	= its_sgi_set_affinity,
> +};
nit: const?
> +
> +static int its_sgi_irq_domain_alloc(struct irq_domain *domain,
> +				    unsigned int virq, unsigned int nr_irqs,
> +				    void *args)
> +{
> +	struct its_vpe *vpe = args;
> +	int i;
> +
> +	/* Yes, we do want 16 SGIs */
> +	WARN_ON(nr_irqs != 16);
> +
> +	for (i = 0; i < 16; i++) {
> +		vpe->sgi_config[i].priority = 0;
> +		vpe->sgi_config[i].enabled = false;
> +		vpe->sgi_config[i].group = false;
> +
> +		irq_domain_set_hwirq_and_chip(domain, virq + i, i,
> +					      &its_sgi_irq_chip, vpe);
> +		irq_set_status_flags(virq + i, IRQ_DISABLE_UNLAZY);
> +	}
> +
> +	return 0;
> +}
> +
> +static void its_sgi_irq_domain_free(struct irq_domain *domain,
> +				    unsigned int virq,
> +				    unsigned int nr_irqs)
> +{
> +	/* Nothing to do */
> +}
> +
> +static int its_sgi_irq_domain_activate(struct irq_domain *domain,
> +				       struct irq_data *d, bool reserve)
> +{
> +	return 0;
> +}
> +
> +static void its_sgi_irq_domain_deactivate(struct irq_domain *domain,
> +					  struct irq_data *d)
> +{
> +	/* Nothing to do */
> +}
> +
> +static struct irq_domain_ops its_sgi_domain_ops = {
> +	.alloc		= its_sgi_irq_domain_alloc,
> +	.free		= its_sgi_irq_domain_free,
> +	.activate	= its_sgi_irq_domain_activate,
> +	.deactivate	= its_sgi_irq_domain_deactivate,
> +};
nit: const?
> +
>  static int its_vpe_id_alloc(void)
>  {
>  	return ida_simple_get(&its_vpeid_ida, 0, ITS_MAX_VPEID, GFP_KERNEL);
> @@ -4912,8 +4973,13 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
>  		rdists->has_rvpeid = false;
>  
>  	if (has_v4 & rdists->has_vlpis) {
> +		struct irq_domain_ops *sgi_ops = NULL;
> +
> +		if (has_v4_1)
> +			sgi_ops = &its_sgi_domain_ops;
> +
>  		if (its_init_vpe_domain() ||
> -		    its_init_v4(parent_domain, &its_vpe_domain_ops)) {
> +		    its_init_v4(parent_domain, &its_vpe_domain_ops, sgi_ops)) {
>  			rdists->has_vlpis = false;
>  			pr_err("ITS: Disabling GICv4 support\n");
>  		}
> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
> index 45969927cc81..c01910d53f9e 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c
> @@ -85,6 +85,7 @@
>  
>  static struct irq_domain *gic_domain;
>  static const struct irq_domain_ops *vpe_domain_ops;
> +static const struct irq_domain_ops *sgi_domain_ops;
>  
>  int its_alloc_vcpu_irqs(struct its_vm *vm)
>  {
> @@ -216,12 +217,15 @@ int its_prop_update_vlpi(int irq, u8 config, bool inv)
>  	return irq_set_vcpu_affinity(irq, &info);
>  }
>  
> -int its_init_v4(struct irq_domain *domain, const struct irq_domain_ops *ops)
> +int its_init_v4(struct irq_domain *domain,
> +		const struct irq_domain_ops *vpe_ops,
> +		const struct irq_domain_ops *sgi_ops)
>  {
>  	if (domain) {
>  		pr_info("ITS: Enabling GICv4 support\n");
>  		gic_domain = domain;
> -		vpe_domain_ops = ops;
> +		vpe_domain_ops = vpe_ops;
> +		sgi_domain_ops = sgi_ops;
>  		return 0;
>  	}
>  
> diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
> index 439963f4c66a..44e8c19e3d56 100644
> --- a/include/linux/irqchip/arm-gic-v4.h
> +++ b/include/linux/irqchip/arm-gic-v4.h
> @@ -49,6 +49,11 @@ struct its_vpe {
>  		};
>  		/* GICv4.1 implementations */
>  		struct {
> +			struct {
> +				u8	priority;
> +				bool	enabled;
> +				bool	group;
> +			}			sgi_config[16];
>  			atomic_t vmapp_count;
>  		};
>  	};
> @@ -123,6 +128,8 @@ int its_unmap_vlpi(int irq);
>  int its_prop_update_vlpi(int irq, u8 config, bool inv);
>  
>  struct irq_domain_ops;
> -int its_init_v4(struct irq_domain *domain, const struct irq_domain_ops *ops);
> +int its_init_v4(struct irq_domain *domain,
> +		const struct irq_domain_ops *vpe_ops,
> +		const struct irq_domain_ops *sgi_ops);
>  
>  #endif
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

