Return-Path: <kvm+bounces-845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A6517E3724
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 10:07:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79339B20C27
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 09:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF6A12E5D;
	Tue,  7 Nov 2023 09:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34F612E40
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 09:06:54 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1A75106
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 01:06:53 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0AC5AFEC;
	Tue,  7 Nov 2023 01:07:38 -0800 (PST)
Received: from monolith (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D869C3F703;
	Tue,  7 Nov 2023 01:06:52 -0800 (PST)
Date: Tue, 7 Nov 2023 09:07:36 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: heqiong <heqiong1557@phytium.com.cn>
Cc: kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests 1/1] arm64: microbench: Move the read of the
 count register and the ISB operation out of the while loop
Message-ID: <ZUn-WJpRYSqpuBe_@monolith>
References: <20231107064007.958944-1-heqiong1557@phytium.com.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231107064007.958944-1-heqiong1557@phytium.com.cn>

Hi,

On Tue, Nov 07, 2023 at 02:40:06PM +0800, heqiong wrote:
> Reducing the impact of the cntvct_el0 register and isb() operation
> on microbenchmark test results to improve testing accuracy and reduce
> latency in test results.
> ---
>  arm/micro-bench.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index fbe59d03..6b940d56 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -346,17 +346,21 @@ static void loop_test(struct exit_test *test)
>  		}
>  	}
>  
> +	dsb(ish);
> +	isb();
> +	start = read_sysreg(cntpct_el0);

I still think it would be interesting to have an explanation why CNTVCT_EL0
was replaced with CNTPCT_EL0.

Thanks,
Alex

> +	isb();
>  	while (ntimes < test->times && total_ns.ns < NS_5_SECONDS) {
> -		isb();
> -		start = read_sysreg(cntvct_el0);
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
> +	end = read_sysreg(cntpct_el0);
> +
> +	total_ticks = end - start;
> +	ticks_to_ns_time(total_ticks, &total_ns);
>  
>  	if (test->post) {
>  		test->post(ntimes, &total_ticks);
> -- 
> 2.31.1
> 

