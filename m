Return-Path: <kvm+bounces-882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 084027E3F21
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 13:49:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94E47B20DB6
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 12:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D13A1A5BB;
	Tue,  7 Nov 2023 12:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5D8624
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:49:06 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32C8F3C38
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 04:49:05 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DD2913D5;
	Tue,  7 Nov 2023 04:49:49 -0800 (PST)
Received: from monolith (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 49B823F6C4;
	Tue,  7 Nov 2023 04:49:04 -0800 (PST)
Date: Tue, 7 Nov 2023 12:49:46 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: heqiong <heqiong1557@phytium.com.cn>
Cc: kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/1] arm64: microbench: Move the read of
 the count register and the ISB operation out of the while loop
Message-ID: <ZUoyajE2wZ2sPD8c@monolith>
References: <20231107064007.958944-1-heqiong1557@phytium.com.cn>
 <20231107095115.43077-1-heqiong1557@phytium.com.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231107095115.43077-1-heqiong1557@phytium.com.cn>

Hi,

On Tue, Nov 07, 2023 at 05:51:15PM +0800, heqiong wrote:
> Reducing the impact of the cntvct_el0 register and isb() operation
> on microbenchmark test results to improve testing accuracy and reduce
> latency in test results.
> ---
>  arm/micro-bench.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index fbe59d03..65f4c4dd 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -346,17 +346,21 @@ static void loop_test(struct exit_test *test)
>  		}
>  	}
>  
> +	dsb(ish);
> +	isb();
> +	start = read_sysreg(cntvct_el0);
> +	isb();
>  	while (ntimes < test->times && total_ns.ns < NS_5_SECONDS) {
				       ^^^^^^^^^^^^^^^^^^^^^^^^^^
This will always evaluate to true because total_ns is now computed at the
end of the loop instead of every iteration.

Do we want to drop the upper bound on how long a test takes to execute? I
don't have an opinion about it.

Thanks,
Alex

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

