Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB1C1881BB
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 12:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgCQLTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 07:19:15 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:21156 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728288AbgCQLEe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 07:04:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584443073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EzG/M8Z6pKqu/VY432HtCP1l4TbOCW1/V3h7h2TGD8o=;
        b=F9Ym/3eFcmbU9GC6FPGeDOTtDJGpdLZjYIAAZddhncNW4VVMPo+1GZTBbqQUDVteX1ZeOO
        5hutg/5jZbJ3WK6ztEU+sd12B7GoGltTatbipBEub/nGFV9DeV7MbTNko6aeMzZKai7jFH
        OpiJ7IUNxkA3gb5DViHHv7LfVIL9sRo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-6WXanJS8PgmMPO53GH65Hg-1; Tue, 17 Mar 2020 07:04:29 -0400
X-MC-Unique: 6WXanJS8PgmMPO53GH65Hg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3503B8018A2;
        Tue, 17 Mar 2020 11:04:27 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA6CB8F37B;
        Tue, 17 Mar 2020 11:04:23 +0000 (UTC)
Subject: Re: [PATCH v5 17/23] KVM: arm64: GICv4.1: Let doorbells be
 auto-enabled
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
 <20200304203330.4967-18-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <43848b89-29fe-eb34-b6d9-f9723f40a8f1@redhat.com>
Date:   Tue, 17 Mar 2020 12:04:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-18-maz@kernel.org>
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
> As GICv4.1 understands the life cycle of doorbells (instead of
> just randomly firing them at the most inconvenient time), just
> enable them at irq_request time, and be done with it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  virt/kvm/arm/vgic/vgic-v4.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> index 1eb0f8c76219..c2fcde104ea2 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -141,6 +141,7 @@ int vgic_v4_init(struct kvm *kvm)
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		int irq = dist->its_vm.vpes[i]->irq;
> +		unsigned long irq_flags = DB_IRQ_FLAGS;
>  
>  		/*
>  		 * Don't automatically enable the doorbell, as we're
> @@ -148,8 +149,14 @@ int vgic_v4_init(struct kvm *kvm)
>  		 * blocked. Also disable the lazy disabling, as the
>  		 * doorbell could kick us out of the guest too
>  		 * early...
> +		 *
> +		 * On GICv4.1, the doorbell is managed in HW and must
> +		 * be left enabled.
>  		 */
> -		irq_set_status_flags(irq, DB_IRQ_FLAGS);
> +		if (kvm_vgic_global_state.has_gicv4_1)
> +			irq_flags &= ~IRQ_NOAUTOEN;
> +		irq_set_status_flags(irq, irq_flags);
> +
>  		ret = request_irq(irq, vgic_v4_doorbell_handler,
>  				  0, "vcpu", vcpu);
>  		if (ret) {
> 

