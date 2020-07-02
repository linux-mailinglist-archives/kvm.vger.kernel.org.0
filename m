Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30337211B8C
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 07:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgGBF3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 01:29:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58608 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726003AbgGBF3y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Jul 2020 01:29:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593667793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iGQdjHVib8qISNc7IzTrXVvygz3qc1VGj0SJ1dQqdgY=;
        b=UtOzSPZ5q6dKFLIQLnLVJ1vmfsNkjnBiK/v4UsKtdGDrbYyacEcPFlht4Fr1/4ZDarcrAi
        A/Gq/8b6HWcdmJvJGJJlxtLdv8Qm88L9TS/wmEn4RxsbFfLzNy+cuenSLEMzwHa5ocVgWV
        rSnhW/qIl3INw88ai+gxg6+ArTeiNFQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-pHsuURx5OMG-ZC5xX3kfIQ-1; Thu, 02 Jul 2020 01:29:51 -0400
X-MC-Unique: pHsuURx5OMG-ZC5xX3kfIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22F20802ED4;
        Thu,  2 Jul 2020 05:29:50 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 309AC60CD3;
        Thu,  2 Jul 2020 05:29:44 +0000 (UTC)
Date:   Thu, 2 Jul 2020 07:29:42 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Jingyi Wang <wangjingyi11@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com,
        eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 6/8] arm64: microbench: Allow each test
 to specify its running times
Message-ID: <20200702052942.laodlgq2yrlxwsh4@kamzik.brq.redhat.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-7-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702030132.20252-7-wangjingyi11@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 02, 2020 at 11:01:30AM +0800, Jingyi Wang wrote:
> For some test in micro-bench can be time consuming, we add a
> micro-bench test parameter to allow each individual test to specify
> its running times.
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>  arm/micro-bench.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index aeb60a7..506d2f9 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -223,17 +223,18 @@ struct exit_test {
>  	const char *name;
>  	bool (*prep)(void);
>  	void (*exec)(void);
> +	u32 times;
>  	bool run;
>  };
>  
>  static struct exit_test tests[] = {
> -	{"hvc",			NULL,		hvc_exec,		true},
> -	{"mmio_read_user",	NULL,		mmio_read_user_exec,	true},
> -	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	true},
> -	{"eoi",			NULL,		eoi_exec,		true},
> -	{"ipi",			ipi_prep,	ipi_exec,		true},
> -	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		true},
> -	{"lpi",			lpi_prep,	lpi_exec,		true},
> +	{"hvc",			NULL,		hvc_exec,		NTIMES,		true},
> +	{"mmio_read_user",	NULL,		mmio_read_user_exec,	NTIMES,		true},
> +	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	NTIMES,		true},
> +	{"eoi",			NULL,		eoi_exec,		NTIMES,		true},
> +	{"ipi",			ipi_prep,	ipi_exec,		NTIMES,		true},
> +	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		NTIMES,		true},
> +	{"lpi",			lpi_prep,	lpi_exec,		NTIMES,		true},

Now that we no longer use 'NTIMES' in functions we don't really need the
define at all. We can just put 65536 directly into the table here for
each test that needs 65536 times.

Thanks,
drew

>  };
>  
>  struct ns_time {
> @@ -254,7 +255,7 @@ static void ticks_to_ns_time(uint64_t ticks, struct ns_time *ns_time)
>  
>  static void loop_test(struct exit_test *test)
>  {
> -	uint64_t start, end, total_ticks, ntimes = NTIMES;
> +	uint64_t start, end, total_ticks, ntimes = 0;
>  	struct ns_time total_ns, avg_ns;
>  
>  	if (test->prep) {
> @@ -265,15 +266,17 @@ static void loop_test(struct exit_test *test)
>  	}
>  	isb();
>  	start = read_sysreg(cntpct_el0);
> -	while (ntimes--)
> +	while (ntimes < test->times) {
>  		test->exec();
> +		ntimes++;
> +	}
>  	isb();
>  	end = read_sysreg(cntpct_el0);
>  
>  	total_ticks = end - start;
>  	ticks_to_ns_time(total_ticks, &total_ns);
> -	avg_ns.ns = total_ns.ns / NTIMES;
> -	avg_ns.ns_frac = total_ns.ns_frac / NTIMES;
> +	avg_ns.ns = total_ns.ns / ntimes;
> +	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
>  
>  	printf("%-30s%15" PRId64 ".%-15" PRId64 "%15" PRId64 ".%-15" PRId64 "\n",
>  		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
> -- 
> 2.19.1
> 
> 

