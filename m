Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB4A21247F
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 15:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgGBNXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 09:23:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22442 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729067AbgGBNXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 09:23:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593696204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lt+MVol6YDoR2oUdOzFWj33k5KFHukA6bYuMZo4OVHM=;
        b=Py7ZifIlRVcamu0mblQjNuJdJTt/1RahgxAhAwpWTIrI8xGsgZQN9rcJN8VDKVZ8gcPJli
        Fow0vRM5f3hwPxy+3B55hyQEc9DxpvtCa9SY+UWERrwklMUpJ48kPrS917AVuI9TV3bicx
        F9qMcuPCNt9ki7yuG4xzs7mmZ9N1Ahw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-60C4cSREMq2bFAXkYNTVzA-1; Thu, 02 Jul 2020 09:23:22 -0400
X-MC-Unique: 60C4cSREMq2bFAXkYNTVzA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD7C218B6474;
        Thu,  2 Jul 2020 13:23:20 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D9CAD60BE1;
        Thu,  2 Jul 2020 13:23:18 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 7/8] arm64: microbench: Add time limit
 for each individual test
To:     Jingyi Wang <wangjingyi11@huawei.com>, drjones@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-8-wangjingyi11@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <49bf0b58-38b9-1cd6-8396-b8561d6f90cb@redhat.com>
Date:   Thu, 2 Jul 2020 15:23:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200702030132.20252-8-wangjingyi11@huawei.com>
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
> Besides using separate running times parameter, we add time limit
> for loop_test to make sure each test should be done in a certain
> time(5 sec here).
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>  arm/micro-bench.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 506d2f9..4c962b7 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -23,6 +23,7 @@
>  #include <asm/gic-v3-its.h>
>  
>  #define NTIMES (1U << 16)
> +#define MAX_NS (5 * 1000 * 1000 * 1000UL)
>  
>  static u32 cntfrq;
>  
> @@ -258,22 +259,26 @@ static void loop_test(struct exit_test *test)
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
> +	while (ntimes < test->times && total_ns.ns < MAX_NS) {
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
you don't need the
ticks_to_ns_time(total_ticks, &total_ns);

after the loop
> -	isb();
> -	end = read_sysreg(cntpct_el0);
>  
> -	total_ticks = end - start;
>  	ticks_to_ns_time(total_ticks, &total_ns);
>  	avg_ns.ns = total_ns.ns / ntimes;
>  	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
> 

Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

