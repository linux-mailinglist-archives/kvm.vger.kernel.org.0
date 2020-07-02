Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBC4212376
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 14:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgGBMgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 08:36:40 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26206 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728861AbgGBMgj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Jul 2020 08:36:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593693397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F6txGPJf3/pYs89gmu9iU2ZLMdOhpZiTs7tIqLOSO7M=;
        b=fD3+tp3NZI+r6czTU8muspqksHycEaFNgH502gt7nTSX4LXPykGPVowfVHZelI0/b2ERq3
        MERpX/xPpFsunxA2aDEPZMan7I6rxrcDMhQGfz4nM52DINPQ6PaJG8rTGRBR/BfGWNyDae
        mAmu78EueIQ3wM2YKQRiQO5fc2rToks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-RhTXJ50_Pp-MhGT2WywtGg-1; Thu, 02 Jul 2020 08:36:36 -0400
X-MC-Unique: RhTXJ50_Pp-MhGT2WywtGg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9C29107B7C9;
        Thu,  2 Jul 2020 12:36:34 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 39748741AF;
        Thu,  2 Jul 2020 12:36:33 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 2/8] arm64: microbench: Use the funcions
 for ipi test as the general functions for gic(ipi/lpi/timer) test
To:     Jingyi Wang <wangjingyi11@huawei.com>, drjones@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-3-wangjingyi11@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <c862d39b-37e7-472f-c5ce-5f47ce76af87@redhat.com>
Date:   Thu, 2 Jul 2020 14:36:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200702030132.20252-3-wangjingyi11@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 7/2/20 5:01 AM, Jingyi Wang wrote:
> The following patches will use that.
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>  arm/micro-bench.c | 39 ++++++++++++++++++++++-----------------
>  1 file changed, 22 insertions(+), 17 deletions(-)
> 
With commit message suggested by Drew,

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 794dfac..fc4d356 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -25,24 +25,24 @@
>  
>  static u32 cntfrq;
>  
> -static volatile bool ipi_ready, ipi_received;
> +static volatile bool irq_ready, irq_received;
>  static void *vgic_dist_base;
>  static void (*write_eoir)(u32 irqstat);
>  
> -static void ipi_irq_handler(struct pt_regs *regs)
> +static void gic_irq_handler(struct pt_regs *regs)
>  {
> -	ipi_ready = false;
> -	ipi_received = true;
> +	irq_ready = false;
> +	irq_received = true;
>  	gic_write_eoir(gic_read_iar());
> -	ipi_ready = true;
> +	irq_ready = true;
>  }
>  
> -static void ipi_secondary_entry(void *data)
> +static void gic_secondary_entry(void *data)
>  {
> -	install_irq_handler(EL1H_IRQ, ipi_irq_handler);
> +	install_irq_handler(EL1H_IRQ, gic_irq_handler);
>  	gic_enable_defaults();
>  	local_irq_enable();
> -	ipi_ready = true;
> +	irq_ready = true;
>  	while (true)
>  		cpu_relax();
>  }
> @@ -72,9 +72,9 @@ static bool test_init(void)
>  		break;
>  	}
>  
> -	ipi_ready = false;
> +	irq_ready = false;
>  	gic_enable_defaults();
> -	on_cpu_async(1, ipi_secondary_entry, NULL);
> +	on_cpu_async(1, gic_secondary_entry, NULL);
>  
>  	cntfrq = get_cntfrq();
>  	printf("Timer Frequency %d Hz (Output in microseconds)\n", cntfrq);
> @@ -82,13 +82,18 @@ static bool test_init(void)
>  	return true;
>  }
>  
> -static void ipi_prep(void)
> +static void gic_prep_common(void)
>  {
>  	unsigned tries = 1 << 28;
>  
> -	while (!ipi_ready && tries--)
> +	while (!irq_ready && tries--)
>  		cpu_relax();
> -	assert(ipi_ready);
> +	assert(irq_ready);
> +}
> +
> +static void ipi_prep(void)
> +{
> +	gic_prep_common();
>  }
>  
>  static void ipi_exec(void)
> @@ -96,17 +101,17 @@ static void ipi_exec(void)
>  	unsigned tries = 1 << 28;
>  	static int received = 0;
>  
> -	ipi_received = false;
> +	irq_received = false;
>  
>  	gic_ipi_send_single(1, 1);
>  
> -	while (!ipi_received && tries--)
> +	while (!irq_received && tries--)
>  		cpu_relax();
>  
> -	if (ipi_received)
> +	if (irq_received)
>  		++received;
>  
> -	assert_msg(ipi_received, "failed to receive IPI in time, but received %d successfully\n", received);
> +	assert_msg(irq_received, "failed to receive IPI in time, but received %d successfully\n", received);
>  }
>  
>  static void hvc_exec(void)
> 

