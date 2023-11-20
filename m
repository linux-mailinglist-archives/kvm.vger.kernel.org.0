Return-Path: <kvm+bounces-2041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A297F0DAA
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 09:36:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22ADC1F2211E
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 08:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28ECEDF4B;
	Mon, 20 Nov 2023 08:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xBJ9vFil"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5503A2
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 00:36:02 -0800 (PST)
Date: Mon, 20 Nov 2023 09:35:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700469359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SO8GAiXscNQ5WVjYbZ48LmZ0E29ylsfGBJ3XTCIIUDU=;
	b=xBJ9vFilqulUjruKeK8AHu3YG7zCv5Zahnn9rdlUT9ARoMLc7iWJd+JIFmcdIdgH+y6f5A
	ovk0O7MRPHsYSiGNHUIODN5T9AL8YqFTQEuXTJsGZzZUtHtPxr0yY9kwLlMYCY19Wggyrk
	Ga4JNyPLn4VJH2FcN3zSIGIeWldPDJg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: heqiong <heqiong1557@phytium.com.cn>
Cc: alexandru.elisei@arm.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/1] arm64: microbench: Improve
 measurement accuracy of tests
Message-ID: <20231120-a5e68a2b2d657ec3f2fc4e7e@orel>
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
X-Migadu-Flow: FLOW_OUT


Thanks, Heqiong. The patch is looking much better. The only thing missing
now is the patch version. This is v3, so it should have a prefix like this

 [kvm-unit-tests PATCH v3 1/1]

There's no need to respin for that though. afaict you've addressed
Alexandru's comments, but I'll let him take a look before merging.

Thanks,
drew

On Thu, Nov 16, 2023 at 12:53:55PM +0800, heqiong wrote:
> Reducing the impact of the cntvct_el0 register and isb() operation
> on microbenchmark test results to improve testing accuracy and reduce
> latency in test results.
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

