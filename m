Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2B3187E4E
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 11:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgCQKaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 06:30:30 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:41557 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbgCQKa3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 06:30:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584441028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E3boV3yl7QUZP/2283Qn125pIkCavFJHZDCmoHG9RZ4=;
        b=QiHG9Qim1HeSBEtKzNWwOjlY0YQDv8LrWgObz/BMg5oMAdSRxT/vp8qIUeWbSl6Cm2xMRC
        NX8p/8Zb+X2IwNDXHaf71dqIiMtgQScPhRGKHhRaK007fpv7f5D8MqFby8WR/zW1C5z758
        df5ymeeXZWzSO0lUMaU6fwmaO+LXTdg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-q__xEIZcPW-S9ONrSCl3rA-1; Tue, 17 Mar 2020 06:30:27 -0400
X-MC-Unique: q__xEIZcPW-S9ONrSCl3rA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE6F68018A4;
        Tue, 17 Mar 2020 10:30:24 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C12419C58;
        Tue, 17 Mar 2020 10:30:21 +0000 (UTC)
Subject: Re: [PATCH v5 15/23] irqchip/gic-v4.1: Add VSGI property setup
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
 <20200304203330.4967-16-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <edfc4aa0-3e96-4fb2-731e-76a284c8ce17@redhat.com>
Date:   Tue, 17 Mar 2020 11:30:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-16-maz@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 3/4/20 9:33 PM, Marc Zyngier wrote:
> Add the SGI configuration entry point for KVM to use.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  drivers/irqchip/irq-gic-v3-its.c   |  2 +-
>  drivers/irqchip/irq-gic-v4.c       | 13 +++++++++++++
>  include/linux/irqchip/arm-gic-v4.h |  3 ++-
>  3 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index effb0e0b0c9d..b65fba67bd85 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -4039,7 +4039,7 @@ static int its_sgi_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
>  	struct its_cmd_info *info = vcpu_info;
>  
>  	switch (info->cmd_type) {
> -	case PROP_UPDATE_SGI:
> +	case PROP_UPDATE_VSGI:
This change rather belongs to
[PATCH v5 12/23] irqchip/gic-v4.1: Plumb set_vcpu_affinity SGI callbacks
>  		vpe->sgi_config[d->hwirq].priority = info->priority;
>  		vpe->sgi_config[d->hwirq].group = info->group;
>  		its_configure_sgi(d, false);
> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
> index 99b33f60ac63..0c18714ae13e 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c
> @@ -320,6 +320,19 @@ int its_prop_update_vlpi(int irq, u8 config, bool inv)
>  	return irq_set_vcpu_affinity(irq, &info);
>  }
>  
> +int its_prop_update_vsgi(int irq, u8 priority, bool group)
> +{
> +	struct its_cmd_info info = {
> +		.cmd_type = PROP_UPDATE_VSGI,
> +		{
> +			.priority	= priority,
> +			.group		= group,
> +		},
> +	};
> +
> +	return irq_set_vcpu_affinity(irq, &info);
> +}
> +
>  int its_init_v4(struct irq_domain *domain,
>  		const struct irq_domain_ops *vpe_ops,
>  		const struct irq_domain_ops *sgi_ops)
> diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
> index 0bb111b4a504..6976b8331b60 100644
> --- a/include/linux/irqchip/arm-gic-v4.h
> +++ b/include/linux/irqchip/arm-gic-v4.h
> @@ -105,7 +105,7 @@ enum its_vcpu_info_cmd_type {
>  	SCHEDULE_VPE,
>  	DESCHEDULE_VPE,
>  	INVALL_VPE,
> -	PROP_UPDATE_SGI,
> +	PROP_UPDATE_VSGI,
same
>  };
>  
>  struct its_cmd_info {
> @@ -134,6 +134,7 @@ int its_map_vlpi(int irq, struct its_vlpi_map *map);
>  int its_get_vlpi(int irq, struct its_vlpi_map *map);
>  int its_unmap_vlpi(int irq);
>  int its_prop_update_vlpi(int irq, u8 config, bool inv);
> +int its_prop_update_vsgi(int irq, u8 priority, bool group);
>  
>  struct irq_domain_ops;
>  int its_init_v4(struct irq_domain *domain,
> 
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

