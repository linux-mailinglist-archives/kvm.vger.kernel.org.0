Return-Path: <kvm+bounces-840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF1547E36D8
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 09:40:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77321280F91
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 08:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5A6CA4E;
	Tue,  7 Nov 2023 08:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d5sX5zey"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D04163BD
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 08:40:36 +0000 (UTC)
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A42FD
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 00:40:34 -0800 (PST)
Date: Tue, 7 Nov 2023 09:40:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699346432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QDCCvu78PUb8haQalPU9KYf68BUBV0RrdFZncWpVhek=;
	b=d5sX5zeyYLHpMttdazQlLsP4cvYe552dhmWN2Xyv4jUdel8jDbBAG72NmdhP2xrGhQX3sQ
	3Msan2DAS7FzdgwgQYfoAJ8zVc8SD/l+wDS+aGaMb9ROHwM5BBQoZMi4G5s0HSV5GuxhuD
	BooZSLGIShA1Mu2Qa0vlpPhcaGAbOHk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: heqiong <heqiong1557@phytium.com.cn>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests 1/1] arm64: microbench: Move the read of the
 count register and the ISB operation out of the while loop
Message-ID: <20231107-9b361591b5d43284d4394f8a@orel>
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
X-Migadu-Flow: FLOW_OUT


Thanks for submitting the patch more correctly, but there's still two
more problems with the patch submission. The patch summary (email subject)
is too long. It also simply describes the change of implementation, which
is easy to see when looking at the patch. It should instead describe the
purpose of the patch, e.g.

  arm64: microbench: Improve measurement accuracy of tests

The second problem is it's missing your signed-off-by (which I think I
pointed out last time too).

Please see [1] for more information about patch formatting. You can also
run the Linux kernel's scripts/checkpatch.pl on the patch to catch these
types of things as well as other code style issues.

[1] https://www.kernel.org/doc/html/latest/process/submitting-patches.html#the-canonical-patch-format

Thanks,
drew

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

