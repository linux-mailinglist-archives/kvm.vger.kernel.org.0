Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B67617DE09
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 11:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgCIK4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 06:56:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26439 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726217AbgCIK4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 06:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583751374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9KEMpMRCvbmPoDMJrLlIGlGrbBg9uKjS59wDa02j2VA=;
        b=SiIB3C4ER/QM9bVeXOtnUGdRHy/pTGdOQh/v6uRDsKz4F0LhpuKbdD6ywA0y18hQRRcvXQ
        ZhynJxu09+SL5GeEsm01IRKSVG2mph9sESnraZgSyiDM0V4k6JX2Q7iX9Ae5S/YrEQTOyB
        7wLD5I9Gyrd6K8XA8IhvQpOig1KM0QU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-cfS3j-H4Pq2WMi0xP_RiZw-1; Mon, 09 Mar 2020 06:56:11 -0400
X-MC-Unique: cfS3j-H4Pq2WMi0xP_RiZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8130C13F7;
        Mon,  9 Mar 2020 10:56:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D30A21001920;
        Mon,  9 Mar 2020 10:56:03 +0000 (UTC)
Date:   Mon, 9 Mar 2020 11:56:01 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 03/13] arm/arm64: gic: Introduce
 setup_irq() helper
Message-ID: <20200309105601.3hm2kfhuufgxoydl@kamzik.brq.redhat.com>
References: <20200309102420.24498-1-eric.auger@redhat.com>
 <20200309102420.24498-4-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309102420.24498-4-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 09, 2020 at 11:24:10AM +0100, Eric Auger wrote:
> ipi_enable() code would be reusable for other interrupts
> than IPI. Let's rename it setup_irq() and pass an interrupt
> handler pointer.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v2 -> v3:
> - do not export setup_irq anymore
> ---
>  arm/gic.c | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index fcf4c1f..abf08c7 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -34,6 +34,7 @@ static struct gic *gic;
>  static int acked[NR_CPUS], spurious[NR_CPUS];
>  static int bad_sender[NR_CPUS], bad_irq[NR_CPUS];
>  static cpumask_t ready;
> +typedef void (*handler_t)(struct pt_regs *regs __unused);

This is just irq_handler_fn, which is already defined in processor.h.
We don't need the __unused, not since 6b07148d06b1 ("Replace -Wextra
with a saner list of warning flags").

>  
>  static void nr_cpu_check(int nr)
>  {
> @@ -215,20 +216,20 @@ static void ipi_test_smp(void)
>  	report_prefix_pop();
>  }
>  
> -static void ipi_enable(void)
> +static void setup_irq(handler_t handler)
>  {
>  	gic_enable_defaults();
>  #ifdef __arm__
> -	install_exception_handler(EXCPTN_IRQ, ipi_handler);
> +	install_exception_handler(EXCPTN_IRQ, handler);
>  #else
> -	install_irq_handler(EL1H_IRQ, ipi_handler);
> +	install_irq_handler(EL1H_IRQ, handler);
>  #endif
>  	local_irq_enable();
>  }
>  
>  static void ipi_send(void)
>  {
> -	ipi_enable();
> +	setup_irq(ipi_handler);
>  	wait_on_ready();
>  	ipi_test_self();
>  	ipi_test_smp();
> @@ -238,7 +239,7 @@ static void ipi_send(void)
>  
>  static void ipi_recv(void)
>  {
> -	ipi_enable();
> +	setup_irq(ipi_handler);
>  	cpumask_set_cpu(smp_processor_id(), &ready);
>  	while (1)
>  		wfi();
> @@ -295,14 +296,7 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>  static void run_active_clear_test(void)
>  {
>  	report_prefix_push("active");
> -	gic_enable_defaults();
> -#ifdef __arm__
> -	install_exception_handler(EXCPTN_IRQ, ipi_clear_active_handler);
> -#else
> -	install_irq_handler(EL1H_IRQ, ipi_clear_active_handler);
> -#endif
> -	local_irq_enable();
> -
> +	setup_irq(ipi_clear_active_handler);
>  	ipi_test_self();
>  	report_prefix_pop();
>  }
> -- 
> 2.20.1
> 

