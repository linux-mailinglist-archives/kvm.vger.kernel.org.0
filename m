Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003B2211B89
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 07:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgGBF0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 01:26:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22855 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725872AbgGBF0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 01:26:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593667567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hnUTCTY6NdGdbPB6aBT0lOt3P76ysCTotJmS6UnYM1o=;
        b=de78KAoJRPS4erzJe4hnCbwwbGe8mPopjmqr47JrkXe/4w6qc6paAtRy5nzxxpEIE4oqRo
        7o86G0+2PRPUBkt/E1VnzmzD1Bew1jsBVTeNbx0gnRnfKqP7EZlCeySxMe/xAY7sxQuuwT
        OwBfxQiTRwi+36BxcF25+HQ/M2Jr/6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238--_ef87yQOQayjnuKQTEXnw-1; Thu, 02 Jul 2020 01:26:03 -0400
X-MC-Unique: -_ef87yQOQayjnuKQTEXnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18141800C60;
        Thu,  2 Jul 2020 05:26:02 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 256F1500DE;
        Thu,  2 Jul 2020 05:25:56 +0000 (UTC)
Date:   Thu, 2 Jul 2020 07:25:54 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Jingyi Wang <wangjingyi11@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com,
        eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/8] arm64: microbench: Use the
 funcions for ipi test as the general functions for gic(ipi/lpi/timer) test
Message-ID: <20200702052554.2be22pr3wa2nximf@kamzik.brq.redhat.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-3-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702030132.20252-3-wangjingyi11@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Jingyi,

This patch has quite a long summary. How about instead of

 arm64: microbench: Use the funcions for ipi test as the general functions for gic(ipi/lpi/timer) test

we use

 arm64: microbench: Generalize ipi test names

and then in the commit message, instead of

 The following patches will use that.

we use

 Later patches will use these functions for gic(ipi/lpi/timer) tests.

Thanks,
drew

On Thu, Jul 02, 2020 at 11:01:26AM +0800, Jingyi Wang wrote:
> The following patches will use that.
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>  arm/micro-bench.c | 39 ++++++++++++++++++++++-----------------
>  1 file changed, 22 insertions(+), 17 deletions(-)
> 
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
> -- 
> 2.19.1
> 
> 

