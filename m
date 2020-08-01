Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086C9235339
	for <lists+kvm@lfdr.de>; Sat,  1 Aug 2020 18:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgHAQOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Aug 2020 12:14:25 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31224 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725841AbgHAQOZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 1 Aug 2020 12:14:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596298464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wf28/+wlXdYgB9veI3c3RN2H8aZsx2Wnibm1Lushe+Q=;
        b=XoZHE726Q/8KCzVSiSNWftlQpmhlUK44pQran0//thCi5wTzyVtJTzN8eUmTYUXfthfODd
        GFYNYh+6lZfpH3szWjINTbMZo6eqyIc4x57UGfW9H5mMiH34ih/BMCa4Ls+ZD7nqP9vtHG
        0NBnEg5pXn+8XuOEkvn0aN5LqU6lEaM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66--WpcgJkzNvSjrdUtlu1sVg-1; Sat, 01 Aug 2020 12:14:20 -0400
X-MC-Unique: -WpcgJkzNvSjrdUtlu1sVg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9658801504;
        Sat,  1 Aug 2020 16:13:50 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EF0B261A1;
        Sat,  1 Aug 2020 16:13:44 +0000 (UTC)
Date:   Sat, 1 Aug 2020 18:13:41 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Jingyi Wang <wangjingyi11@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com,
        eric.auger@redhat.com, prime.zeng@hisilicon.com
Subject: Re: [kvm-unit-tests PATCH v3 07/10] arm64: microbench: Add time
 limit for each individual test
Message-ID: <20200801161341.cjaqe7tkw2y7uxjm@kamzik.brq.redhat.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
 <20200731074244.20432-8-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731074244.20432-8-wangjingyi11@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 31, 2020 at 03:42:41PM +0800, Jingyi Wang wrote:
> Besides using separate running times parameter, we add time limit
> for loop_test to make sure each test should be done in a certain
> time(5 sec here).
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arm/micro-bench.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 93bd855..09d9d53 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -22,6 +22,7 @@
>  #include <asm/gic.h>
>  #include <asm/gic-v3-its.h>
>  
> +#define NS_5_SECONDS (5 * 1000 * 1000 * 1000UL)
>  static u32 cntfrq;
>  
>  static volatile bool irq_ready, irq_received;
> @@ -267,23 +268,26 @@ static void loop_test(struct exit_test *test)
>  	uint64_t start, end, total_ticks, ntimes = 0;
>  	struct ns_time total_ns, avg_ns;
>  
> +	total_ticks = 0;
>  	if (test->prep) {
>  		if(!test->prep()) {
>  			printf("%s test skipped\n", test->name);
>  			return;
>  		}
>  	}
> -	isb();
> -	start = read_sysreg(cntpct_el0);
> -	while (ntimes < test->times) {
> +
> +	while (ntimes < test->times && total_ns.ns < NS_5_SECONDS) {

total_ns.ns is now being used uninitialized here. It needs to be
initialized to zero above with total_ns = {}.

I'll do this fixup myself.

Thanks,
drew

> +		isb();
> +		start = read_sysreg(cntpct_el0);
>  		test->exec();
> +		isb();
> +		end = read_sysreg(cntpct_el0);
> +
>  		ntimes++;
> +		total_ticks += (end - start);
> +		ticks_to_ns_time(total_ticks, &total_ns);
>  	}
> -	isb();
> -	end = read_sysreg(cntpct_el0);
>  
> -	total_ticks = end - start;
> -	ticks_to_ns_time(total_ticks, &total_ns);
>  	avg_ns.ns = total_ns.ns / ntimes;
>  	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
>  
> -- 
> 2.19.1
> 
> 

