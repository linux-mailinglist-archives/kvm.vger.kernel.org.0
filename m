Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A9218BA54
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 16:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgCSPGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 11:06:24 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:21750 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727116AbgCSPGX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 11:06:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584630382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=74WKfLExhu1TCeh0PZbO5Glf65zWrT+Fd+frCpLn2rU=;
        b=C33tuJOEj8Hlasjv69LeiytjxO7tpBAglDwSwHffEaq0xgep7yocdVPEMZOyFKekCcgBUO
        BMvP4zrm3JZ1oJB8rRDiznKqUwBT5ElmW8IFOsv98XJrUmGbVs6yrQVtYk4F48vVJG62Hx
        02OKW4QXxy0LFguL6Xk5MI5XTLNgw6g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-jfJBNrxdPtCgGuFEhYASkA-1; Thu, 19 Mar 2020 11:06:06 -0400
X-MC-Unique: jfJBNrxdPtCgGuFEhYASkA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5FA3100550E;
        Thu, 19 Mar 2020 15:06:03 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 906618D55E;
        Thu, 19 Mar 2020 15:06:00 +0000 (UTC)
Subject: Re: [PATCH v5 23/23] KVM: arm64: GICv4.1: Expose HW-based SGIs in
 debugfs
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
 <20200304203330.4967-24-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <4cb4c3d4-7b02-bb77-cd7a-c185346b6a2f@redhat.com>
Date:   Thu, 19 Mar 2020 16:05:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-24-maz@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 3/4/20 9:33 PM, Marc Zyngier wrote:
> The vgic-state debugfs file could do with showing the pending state
> of the HW-backed SGIs. Plug it into the low-level code.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/arm/vgic/vgic-debug.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
> index cc12fe9b2df3..b13a9e3f99dd 100644
> --- a/virt/kvm/arm/vgic/vgic-debug.c
> +++ b/virt/kvm/arm/vgic/vgic-debug.c
> @@ -178,6 +178,8 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
>  			    struct kvm_vcpu *vcpu)
>  {
>  	char *type;
> +	bool pending;
nit: can be directly initialized to irq->pending_latch
> +
>  	if (irq->intid < VGIC_NR_SGIS)
>  		type = "SGI";
>  	else if (irq->intid < VGIC_NR_PRIVATE_IRQS)
> @@ -190,6 +192,16 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
>  	if (irq->intid ==0 || irq->intid == VGIC_NR_PRIVATE_IRQS)
>  		print_header(s, irq, vcpu);
>  
> +	pending = irq->pending_latch;
> +	if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> +		int err;
> +
> +		err = irq_get_irqchip_state(irq->host_irq,
> +					    IRQCHIP_STATE_PENDING,
> +					    &pending);
> +		WARN_ON_ONCE(err);
> +	}
> +
>  	seq_printf(s, "       %s %4d "
>  		      "    %2d "
>  		      "%d%d%d%d%d%d%d "
> @@ -201,7 +213,7 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
>  		      "\n",
>  			type, irq->intid,
>  			(irq->target_vcpu) ? irq->target_vcpu->vcpu_id : -1,
> -			irq->pending_latch,
> +			pending,
>  			irq->line_level,
>  			irq->active,
>  			irq->enabled,
> 
The patch looks good to me but I am now lost about how we retrieve the
pending stat of other hw mapped interrupts. Looks we use
irq->pending_latch always. Is that correct?

For the patch:
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

