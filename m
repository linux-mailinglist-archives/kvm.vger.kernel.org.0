Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBA82124DD
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 15:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgGBNg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 09:36:59 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36632 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729115AbgGBNg6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Jul 2020 09:36:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593697017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UBt7WDGG3AuC3POK4Z/zy7X33K5DaaqbcL+Q5p9yjSY=;
        b=Lr1u6vWe8MZcLOm2qFGHEp3ljRDCehHmZLtKw0PvawGBl/NJp/sAaRN7mndAWWyb24owd3
        G7lr4VCPk6KWLGzIX9PD0rD13ObQxJoI7yBljCHBqlH1FggMLwuIZuOjI5vsBnlXHFwDvs
        h/wJINarrDKHT2jDvpfQpkkSdFv2BcY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-xeZLLrofP3W9P8xs8rOW7A-1; Thu, 02 Jul 2020 09:36:55 -0400
X-MC-Unique: xeZLLrofP3W9P8xs8rOW7A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF7F7100CD11;
        Thu,  2 Jul 2020 13:36:53 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F8B460BE1;
        Thu,  2 Jul 2020 13:36:52 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 8/8] arm64: microbench: Add vtimer
 latency test
To:     Jingyi Wang <wangjingyi11@huawei.com>, drjones@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-9-wangjingyi11@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <88eacd00-1951-f6de-aa7c-bda48ece4fde@redhat.com>
Date:   Thu, 2 Jul 2020 15:36:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200702030132.20252-9-wangjingyi11@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jingyi,

On 7/2/20 5:01 AM, Jingyi Wang wrote:
> Trigger PPIs by setting up a 10msec timer and test the latency.

so for each iteration the accumulated valued is 10 ms + latency, right?
and what is printed at the end does include the accumulated periods.
Wouldn't it make sense to have a test->post() that substract this value.
You would need to store the actual number of iterations.

Thanks

Eric
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>  arm/micro-bench.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 4c962b7..6822084 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -23,8 +23,13 @@
>  #include <asm/gic-v3-its.h>
>  
>  #define NTIMES (1U << 16)
> +#define NTIMES_MINOR (1U << 8)
>  #define MAX_NS (5 * 1000 * 1000 * 1000UL)
>  
> +#define IRQ_VTIMER		27
> +#define ARCH_TIMER_CTL_ENABLE	(1 << 0)
> +#define ARCH_TIMER_CTL_IMASK	(1 << 1)
> +
>  static u32 cntfrq;
>  
>  static volatile bool irq_ready, irq_received;
> @@ -33,9 +38,16 @@ static void (*write_eoir)(u32 irqstat);
>  
>  static void gic_irq_handler(struct pt_regs *regs)
>  {
> +	u32 irqstat = gic_read_iar();
>  	irq_ready = false;
>  	irq_received = true;
> -	gic_write_eoir(gic_read_iar());
> +	gic_write_eoir(irqstat);
> +
> +	if (irqstat == IRQ_VTIMER) {
> +		write_sysreg((ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE),
> +			     cntv_ctl_el0);
> +		isb();
> +	}
>  	irq_ready = true;
>  }
>  
> @@ -189,6 +201,47 @@ static void lpi_exec(void)
>  	assert_msg(irq_received, "failed to receive LPI in time, but received %d successfully\n", received);
>  }
>  
> +static bool timer_prep(void)
> +{
> +	static void *gic_isenabler;
> +
> +	gic_enable_defaults();
> +	install_irq_handler(EL1H_IRQ, gic_irq_handler);
> +	local_irq_enable();
> +
> +	gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
> +	writel(1 << 27, gic_isenabler);
> +	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
> +	isb();
> +
> +	gic_prep_common();
> +	return true;
> +}
> +
> +static void timer_exec(void)
> +{
> +	u64 before_timer;
> +	u64 timer_10ms;
> +	unsigned tries = 1 << 28;
> +	static int received = 0;
> +
> +	irq_received = false;
> +
> +	before_timer = read_sysreg(cntvct_el0);
> +	timer_10ms = cntfrq / 100;
> +	write_sysreg(before_timer + timer_10ms, cntv_cval_el0);
> +	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
> +	isb();
> +
> +	while (!irq_received && tries--)
> +		cpu_relax();
> +
> +	if (irq_received)
> +		++received;
> +
> +	assert_msg(irq_received, "failed to receive PPI in time, but received %d successfully\n", received);
> +}
> +
>  static void hvc_exec(void)
>  {
>  	asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
> @@ -236,6 +289,7 @@ static struct exit_test tests[] = {
>  	{"ipi",			ipi_prep,	ipi_exec,		NTIMES,		true},
>  	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		NTIMES,		true},
>  	{"lpi",			lpi_prep,	lpi_exec,		NTIMES,		true},
> +	{"timer_10ms",		timer_prep,	timer_exec,		NTIMES_MINOR,	true},
>  };
>  
>  struct ns_time {
> 

