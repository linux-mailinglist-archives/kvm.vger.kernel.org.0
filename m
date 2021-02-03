Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B1630DA6F
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 14:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhBCNBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 08:01:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230319AbhBCNAv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 08:00:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612357163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6vjgZYfdebB2rNvrrcFv58F1b/FTXBv4JzSMPzMFiNk=;
        b=FSpB/McsDBEGulK78nRM+8wbzX3N23VHLi95c9xtNSimUEehBdGsmipctDUe+0afZKm4zu
        snkTKZuYL1Jls2owvFxkRKcDXhMNEiZVNoW2k5kjwrgZffc/SlQvlBskE3SUVkz8IkyVIB
        yHHfmGkCO7EgaPS+TUjakRlKsFRuExI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-uyonL5-BPbW9udAa5FqFiw-1; Wed, 03 Feb 2021 07:59:21 -0500
X-MC-Unique: uyonL5-BPbW9udAa5FqFiw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E62180196C;
        Wed,  3 Feb 2021 12:59:18 +0000 (UTC)
Received: from [10.36.113.43] (ovpn-113-43.ams2.redhat.com [10.36.113.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F92F71C80;
        Wed,  3 Feb 2021 12:59:16 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 04/11] arm/arm64: gic: Remove
 unnecessary synchronization with stats_reset()
To:     Alexandru Elisei <alexandru.elisei@arm.com>, drjones@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com
References: <20210129163647.91564-1-alexandru.elisei@arm.com>
 <20210129163647.91564-5-alexandru.elisei@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <07ac6ebc-c217-36de-3511-3b2b0bca3de2@redhat.com>
Date:   Wed, 3 Feb 2021 13:59:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210129163647.91564-5-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/29/21 5:36 PM, Alexandru Elisei wrote:
> The GICv3 driver executes a DSB barrier before sending an IPI, which
> ensures that memory accesses have completed. This removes the need to
> enforce ordering with respect to stats_reset() in the IPI handler.
> 
> For GICv2, the same barrier is executed by readl() after the MMIO read.
> Together with the wmb() barrier from writel() when triggering the IPI,
> this ensures that the expected memory ordering is respected.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  arm/gic.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index 8bb804abf34d..db1417ae1ca1 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -59,7 +59,6 @@ static void stats_reset(void)
>  		bad_sender[i] = -1;
>  		bad_irq[i] = -1;
>  	}
> -	smp_wmb();
>  }
>  
>  static void check_acked(const char *testname, cpumask_t *mask)
> @@ -149,7 +148,6 @@ static void ipi_handler(struct pt_regs *regs __unused)
>  
>  	if (irqnr != GICC_INT_SPURIOUS) {
>  		gic_write_eoir(irqstat);
> -		smp_rmb(); /* pairs with wmb in stats_reset */
>  		++acked[smp_processor_id()];
>  		check_ipi_sender(irqstat);
>  		check_irqnr(irqnr);
> 

