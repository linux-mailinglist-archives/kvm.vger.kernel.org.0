Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F852123E4
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 14:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgGBM6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 08:58:05 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43250 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729261AbgGBM6E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Jul 2020 08:58:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593694682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t9w4LZWNu2mt9GGRi97urEa0TOggkhGxJO5hmYE7QxM=;
        b=fYyHzoPCYssD1oF8qzpFlWcrv6o2lzKqaDZGtzjbSnyzIJot9mlbMvZ9aKyGO7qqFK2LLU
        wzBLQ+phsDOYoL7ct269oiULClH20NOvdCI/Lv1F4Z6OQC43b+K4KRYyFhVEL4Ly30LSMZ
        +La4ToFyMCGXSWAbFl/GN32EWZByQRg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-m7TNf4OkOJi80zD_ODUKnw-1; Thu, 02 Jul 2020 08:58:00 -0400
X-MC-Unique: m7TNf4OkOJi80zD_ODUKnw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 403FD107ACCD;
        Thu,  2 Jul 2020 12:57:59 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A4A1D10013D2;
        Thu,  2 Jul 2020 12:57:57 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
To:     Jingyi Wang <wangjingyi11@huawei.com>, drjones@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <087ef371-5e7b-e0b2-900f-67b2eacb4e0f@redhat.com>
Date:   Thu, 2 Jul 2020 14:57:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200702030132.20252-4-wangjingyi11@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jingyi,

On 7/2/20 5:01 AM, Jingyi Wang wrote:
> If gicv4.1(sgi hardware injection) supported, we test ipi injection
> via hw/sw way separately.
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>  arm/micro-bench.c    | 45 +++++++++++++++++++++++++++++++++++++++-----
>  lib/arm/asm/gic-v3.h |  3 +++
>  lib/arm/asm/gic.h    |  1 +
>  3 files changed, 44 insertions(+), 5 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index fc4d356..80d8db3 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -91,9 +91,40 @@ static void gic_prep_common(void)
>  	assert(irq_ready);
>  }
>  
> -static void ipi_prep(void)
> +static bool ipi_prep(void)
Any reason why the bool returned value is preferred over the standard int?
>  {
> +	u32 val;
> +
> +	val = readl(vgic_dist_base + GICD_CTLR);
> +	if (readl(vgic_dist_base + GICD_TYPER2) & GICD_TYPER2_nASSGIcap) {
> +		val &= ~GICD_CTLR_ENABLE_G1A;
> +		val &= ~GICD_CTLR_nASSGIreq;
> +		writel(val, vgic_dist_base + GICD_CTLR);
> +		val |= GICD_CTLR_ENABLE_G1A;
> +		writel(val, vgic_dist_base + GICD_CTLR);
Why do we need this G1A dance?
> +	}
> +
>  	gic_prep_common();
> +	return true;
> +}
> +
> +static bool ipi_hw_prep(void)
> +{
> +	u32 val;
> +
> +	val = readl(vgic_dist_base + GICD_CTLR);
> +	if (readl(vgic_dist_base + GICD_TYPER2) & GICD_TYPER2_nASSGIcap) {
> +		val &= ~GICD_CTLR_ENABLE_G1A;
> +		val |= GICD_CTLR_nASSGIreq;
> +		writel(val, vgic_dist_base + GICD_CTLR);
> +		val |= GICD_CTLR_ENABLE_G1A;
> +		writel(val, vgic_dist_base + GICD_CTLR);
> +	} else {
> +		return false;
> +	}
> +
> +	gic_prep_common();
> +	return true;
>  }
>  
>  static void ipi_exec(void)
> @@ -147,7 +178,7 @@ static void eoi_exec(void)
>  
>  struct exit_test {
>  	const char *name;
> -	void (*prep)(void);
> +	bool (*prep)(void);
>  	void (*exec)(void);
>  	bool run;
>  };
> @@ -158,6 +189,7 @@ static struct exit_test tests[] = {
>  	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	true},
>  	{"eoi",			NULL,		eoi_exec,		true},
>  	{"ipi",			ipi_prep,	ipi_exec,		true},
> +	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		true},
>  };
>  
>  struct ns_time {
> @@ -181,9 +213,12 @@ static void loop_test(struct exit_test *test)
>  	uint64_t start, end, total_ticks, ntimes = NTIMES;
>  	struct ns_time total_ns, avg_ns;
>  
> -	if (test->prep)
> -		test->prep();
> -
> +	if (test->prep) {
> +		if(!test->prep()) {
> +			printf("%s test skipped\n", test->name);
> +			return;
> +		}
> +	}
>  	isb();
>  	start = read_sysreg(cntpct_el0);
>  	while (ntimes--)
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index cb72922..b4ce130 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -20,10 +20,13 @@
>   */
>  #define GICD_CTLR			0x0000
>  #define GICD_CTLR_RWP			(1U << 31)
> +#define GICD_CTLR_nASSGIreq		(1U << 8)
>  #define GICD_CTLR_ARE_NS		(1U << 4)
>  #define GICD_CTLR_ENABLE_G1A		(1U << 1)
>  #define GICD_CTLR_ENABLE_G1		(1U << 0)
>  
> +#define GICD_TYPER2_nASSGIcap		(1U << 8)
> +
>  /* Re-Distributor registers, offsets from RD_base */
>  #define GICR_TYPER			0x0008
>  
> diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> index 38e79b2..1898400 100644
> --- a/lib/arm/asm/gic.h
> +++ b/lib/arm/asm/gic.h
> @@ -13,6 +13,7 @@
>  #define GICD_CTLR			0x0000
>  #define GICD_TYPER			0x0004
>  #define GICD_IIDR			0x0008
> +#define GICD_TYPER2			0x000C
>  #define GICD_IGROUPR			0x0080
>  #define GICD_ISENABLER			0x0100
>  #define GICD_ICENABLER			0x0180
> 

Thanks

Eric

