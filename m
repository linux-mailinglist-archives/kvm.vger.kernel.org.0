Return-Path: <kvm+bounces-2129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D67E7F19C9
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 18:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC35B2819FB
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 17:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0D9420B0E;
	Mon, 20 Nov 2023 17:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id C5A1DD8
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 09:25:58 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B532E1042;
	Mon, 20 Nov 2023 09:26:44 -0800 (PST)
Received: from arm.com (e121798.cambridge.arm.com [10.1.197.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D5EDD3F7A6;
	Mon, 20 Nov 2023 09:25:57 -0800 (PST)
Date: Mon, 20 Nov 2023 17:25:55 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: heqiong <heqiong1557@phytium.com.cn>
Cc: andrew.jones@linux.dev, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/1] arm64: microbench: Improve
 measurement accuracy of tests
Message-ID: <ZVuWo+07reF55eXj@arm.com>
References: <20231107-9b361591b5d43284d4394f8a@orel>
 <20231116045355.2045483-1-heqiong1557@phytium.com.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231116045355.2045483-1-heqiong1557@phytium.com.cn>

Hi,

On Thu, Nov 16, 2023 at 12:53:55PM +0800, heqiong wrote:
> Reducing the impact of the cntvct_el0 register and isb() operation
> on microbenchmark test results to improve testing accuracy and reduce
> latency in test results.

Sorry, lost track of which version is the latest - that's why patch version
numbers are really useful!

Everything look alright to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> 
> Signed-off-by: heqiong <heqiong1557@phytium.com.cn>
> ---
>  arm/micro-bench.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index fbe59d03..22408955 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -24,7 +24,6 @@
>  #include <asm/gic-v3-its.h>
>  #include <asm/timer.h>
>  
> -#define NS_5_SECONDS		(5 * 1000 * 1000 * 1000UL)
>  #define QEMU_MMIO_ADDR		0x0a000008
>  
>  static u32 cntfrq;
> @@ -346,17 +345,21 @@ static void loop_test(struct exit_test *test)
>  		}
>  	}
>  
> -	while (ntimes < test->times && total_ns.ns < NS_5_SECONDS) {
> -		isb();
> -		start = read_sysreg(cntvct_el0);
> +	dsb(ish);
> +	isb();
> +	start = read_sysreg(cntvct_el0);
> +	isb();
> +	while (ntimes < test->times) {
>  		test->exec();
> -		isb();
> -		end = read_sysreg(cntvct_el0);
>  
>  		ntimes++;
> -		total_ticks += (end - start);
> -		ticks_to_ns_time(total_ticks, &total_ns);
>  	}
> +	dsb(ish);
> +	isb();
> +	end = read_sysreg(cntvct_el0);
> +
> +	total_ticks = end - start;
> +	ticks_to_ns_time(total_ticks, &total_ns);
>  
>  	if (test->post) {
>  		test->post(ntimes, &total_ticks);
> -- 
> 2.39.3
> 

