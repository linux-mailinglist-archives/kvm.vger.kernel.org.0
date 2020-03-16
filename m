Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6022118712E
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 18:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731809AbgCPRdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 13:33:03 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:24419 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731136AbgCPRdD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 13:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584379981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=14nagzG00kW25fpr2NHXBqWB0Eexn4LV6EB16qmcCL8=;
        b=fJrpDMRho0DKHwpfFUFIwIDbsKiI3mP9O+r9/LaQx5WqGBxtWbE+w4eLZxn/dS3f/Uz5Hw
        fhnIRNORnX70BIogODgbdzGU7vmfw+JamfVJVf3MKuSShn8HlRFGRV9zTKdSCEA/1B61wl
        5ij9G3exfxDqdiQuV+QqgC19MTjNWJM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-ciCPNaszOSCGf2ATooge6Q-1; Mon, 16 Mar 2020 13:25:54 -0400
X-MC-Unique: ciCPNaszOSCGf2ATooge6Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D116126CBE7;
        Mon, 16 Mar 2020 17:10:28 +0000 (UTC)
Received: from [10.36.118.12] (ovpn-118-12.ams2.redhat.com [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C032560BFB;
        Mon, 16 Mar 2020 17:10:23 +0000 (UTC)
Subject: Re: [PATCH v5 07/23] irqchip/gic-v4.1: Map the ITS SGIR register page
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
 <20200304203330.4967-8-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <0f0b3613-0306-a43c-b935-c842c1025b6b@redhat.com>
Date:   Mon, 16 Mar 2020 18:10:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-8-maz@kernel.org>
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
> One of the new features of GICv4.1 is to allow virtual SGIs to be
> directly signaled to a VPE. For that, the ITS has grown a new
> 64kB page containing only a single register that is used to
> signal a SGI to a given VPE.
> 
> Add a second mapping covering this new 64kB range, and take this
> opportunity to limit the original mapping to 64kB, which is enough
> to cover the span of the ITS registers.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  drivers/irqchip/irq-gic-v3-its.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index bcc1a0957cda..54d6fdf7a28e 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -96,6 +96,7 @@ struct its_node {
>  	struct mutex		dev_alloc_lock;
>  	struct list_head	entry;
>  	void __iomem		*base;
> +	void __iomem		*sgir_base;
>  	phys_addr_t		phys_base;
>  	struct its_cmd_block	*cmd_base;
>  	struct its_cmd_block	*cmd_write;
> @@ -4456,7 +4457,7 @@ static int __init its_probe_one(struct resource *res,
>  	struct page *page;
>  	int err;
>  
> -	its_base = ioremap(res->start, resource_size(res));
> +	its_base = ioremap(res->start, SZ_64K);
>  	if (!its_base) {
>  		pr_warn("ITS@%pa: Unable to map ITS registers\n", &res->start);
>  		return -ENOMEM;
> @@ -4507,6 +4508,13 @@ static int __init its_probe_one(struct resource *res,
>  
>  		if (is_v4_1(its)) {
>  			u32 svpet = FIELD_GET(GITS_TYPER_SVPET, typer);
> +
> +			its->sgir_base = ioremap(res->start + SZ_128K, SZ_64K);
> +			if (!its->sgir_base) {
> +				err = -ENOMEM;
> +				goto out_free_its;
> +			}
> +
>  			its->mpidr = readl_relaxed(its_base + GITS_MPIDR);
>  
>  			pr_info("ITS@%pa: Using GICv4.1 mode %08x %08x\n",
> @@ -4520,7 +4528,7 @@ static int __init its_probe_one(struct resource *res,
>  				get_order(ITS_CMD_QUEUE_SZ));
>  	if (!page) {
>  		err = -ENOMEM;
> -		goto out_free_its;
> +		goto out_unmap_sgir;
>  	}
>  	its->cmd_base = (void *)page_address(page);
>  	its->cmd_write = its->cmd_base;
> @@ -4587,6 +4595,9 @@ static int __init its_probe_one(struct resource *res,
>  	its_free_tables(its);
>  out_free_cmd:
>  	free_pages((unsigned long)its->cmd_base, get_order(ITS_CMD_QUEUE_SZ));
> +out_unmap_sgir:
> +	if (its->sgir_base)
> +		iounmap(its->sgir_base);
>  out_free_its:
>  	kfree(its);
>  out_unmap:
> 

