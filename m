Return-Path: <kvm+bounces-2173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AECB67F2BFB
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 12:45:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFECE1C21947
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 11:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 092BA487B1;
	Tue, 21 Nov 2023 11:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B0MCek+J"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ac])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3079E100
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 03:45:13 -0800 (PST)
Date: Tue, 21 Nov 2023 12:45:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700567111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m9WWccSpGejUdHZ25D17eXFhs6gmcy6GZLru96f1wf8=;
	b=B0MCek+J6bJ8Pnq5/JcUMGdi+OuicJy9YASljlKAzJRPlS47L63Pt0SqNrNrT320UehzDl
	3ycsbsIy+YkmNNneXMiGGneMhvlsPRKPBj4DimQrPQQhApEKJ7cvqi6pIrX1PEHklou2k1
	SPqClLRrRoQpdVW1hUeSBwxLI9onnjo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: heqiong <heqiong1557@phytium.com.cn>
Cc: alexandru.elisei@arm.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/1] arm64: microbench: Improve
 measurement accuracy of tests
Message-ID: <20231121-c0f2c8b7b9047d0b3fadb1cc@orel>
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

Merged into https://gitlab.com/kvm-unit-tests/kvm-unit-tests master

Thanks,
drew

