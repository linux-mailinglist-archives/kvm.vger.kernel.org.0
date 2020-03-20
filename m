Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 897CD18D069
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 15:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgCTOYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 10:24:01 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:37622 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727448AbgCTOYA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 10:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584714239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1p3RF/uo8TYxiZRcGBLV1Qt5le5LuOGxE0TdWNhAnKc=;
        b=F6NPPXw3JRDB7VVSvqTgFA/jVKFVm9k0SZCEsfTt+buzmgtb4Tuy8DE+wSUqMpuTpTg0jq
        RWYIIicybe3gDTxDKvJz9uuxQgHd2mfoh4UUZ1W+oZozO5W6QPv5oive8GoqNrsdfyXqCM
        xN8bgeGux0Hz1u3hz0jeyTIFO6+tmfM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-bbA7gwh2NHyIupKzLH8_mQ-1; Fri, 20 Mar 2020 10:23:57 -0400
X-MC-Unique: bbA7gwh2NHyIupKzLH8_mQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FCDCA0CBF;
        Fri, 20 Mar 2020 14:23:55 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 10CA95C1B0;
        Fri, 20 Mar 2020 14:23:49 +0000 (UTC)
Subject: Re: [PATCH v5 05/23] irqchip/gic-v4.1: Ensure mutual exclusion betwen
 invalidations on the same RD
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
 <20200304203330.4967-6-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <1722e947-2af8-7137-7e71-f6647cdf91d7@redhat.com>
Date:   Fri, 20 Mar 2020 15:23:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-6-maz@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 3/4/20 9:33 PM, Marc Zyngier wrote:
> The GICv4.1 spec says that it is CONTRAINED UNPREDICTABLE to write to
> any of the GICR_INV{LPI,ALL}R registers if GICR_SYNCR.Busy == 1.
> 
> To deal with it, we must ensure that only a single invalidation can
> happen at a time for a given redistributor. Add a per-RD lock to that
> effect and take it around the invalidation/syncr-read to deal with this.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  drivers/irqchip/irq-gic-v3-its.c   | 6 ++++++
>  drivers/irqchip/irq-gic-v3.c       | 1 +
>  include/linux/irqchip/arm-gic-v3.h | 1 +
>  3 files changed, 8 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index c84370245bea..fc5788584df7 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -1373,10 +1373,12 @@ static void direct_lpi_inv(struct irq_data *d)
>  
>  	/* Target the redistributor this LPI is currently routed to */
>  	cpu = irq_to_cpuid_lock(d, &flags);
> +	raw_spin_lock(&gic_data_rdist_cpu(cpu)->rd_lock);
>  	rdbase = per_cpu_ptr(gic_rdists->rdist, cpu)->rd_base;
>  	gic_write_lpir(val, rdbase + GICR_INVLPIR);
>  
>  	wait_for_syncr(rdbase);
> +	raw_spin_unlock(&gic_data_rdist_cpu(cpu)->rd_lock);
>  	irq_to_cpuid_unlock(d, flags);
>  }
>  
> @@ -3662,9 +3664,11 @@ static void its_vpe_send_inv(struct irq_data *d)
>  		void __iomem *rdbase;
>  
>  		/* Target the redistributor this VPE is currently known on */
> +		raw_spin_lock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
>  		rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
>  		gic_write_lpir(d->parent_data->hwirq, rdbase + GICR_INVLPIR);
>  		wait_for_syncr(rdbase);
> +		raw_spin_unlock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
>  	} else {
>  		its_vpe_send_cmd(vpe, its_send_inv);
>  	}
> @@ -3825,10 +3829,12 @@ static void its_vpe_4_1_invall(struct its_vpe *vpe)
>  	val |= FIELD_PREP(GICR_INVALLR_VPEID, vpe->vpe_id);
>  
>  	/* Target the redistributor this vPE is currently known on */
> +	raw_spin_lock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
>  	rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
>  	gic_write_lpir(val, rdbase + GICR_INVALLR);
>  
>  	wait_for_syncr(rdbase);
> +	raw_spin_unlock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
>  }
>  
>  static int its_vpe_4_1_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 73e87e176d76..ba405becab53 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -835,6 +835,7 @@ static int __gic_populate_rdist(struct redist_region *region, void __iomem *ptr)
>  	typer = gic_read_typer(ptr + GICR_TYPER);
>  	if ((typer >> 32) == aff) {
>  		u64 offset = ptr - region->redist_base;
> +		raw_spin_lock_init(&gic_data_rdist()->rd_lock);
>  		gic_data_rdist_rd_base() = ptr;
>  		gic_data_rdist()->phys_base = region->phys_base + offset;
>  
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index c29a02678a6f..b28acfa71f82 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -652,6 +652,7 @@
>  
>  struct rdists {
>  	struct {
> +		raw_spinlock_t	rd_lock;
>  		void __iomem	*rd_base;
>  		struct page	*pend_page;
>  		phys_addr_t	phys_base;
> 

