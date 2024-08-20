Return-Path: <kvm+bounces-24587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 083FD958320
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 11:46:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2468C1C22722
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 09:46:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77EBC18C34A;
	Tue, 20 Aug 2024 09:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o2CD5c9y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861BA18B462;
	Tue, 20 Aug 2024 09:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724147182; cv=none; b=fmQBEzDd02HSDNYJLToJjuKunXyCVdJNYbgSr3Y2E5MILL21q7LlV7fQPtS8hPJbeNa0pOPxEaAeDm+01Mm0Mo8byOmjGs0ZVVWiKfdSpwPAeqCweeoMFDL6EjS6W6UOQ+WEOFDXzdI86jJolAwQ/lJE+0ivAq2AfhQotLYoZB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724147182; c=relaxed/simple;
	bh=zOhBCXDijLbkaaV0VuMpXml9yRj/U1TCZ6LmM+RlFkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWwWUJGPI1PhWrXGPMovguquUud/DrT2b77bHWIVze8YjcAs6VyPKJVsBwgYoddR4AJontpaygHaPTXY7BHg4UHA5lfBk7WZUdGO4jzskHGKE0x6wZf5Uk5vhCJOzQ8E6rzKfUYaybJOrfe7KtwOVHeluT2u9eaP12g1VXOh3Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o2CD5c9y; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47K8UGsg011684;
	Tue, 20 Aug 2024 09:46:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:reply-to:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=vXFjPbmLIkqJtZVOGX2dXuKrjee
	sqOxCF4R5ltJkiNY=; b=o2CD5c9ynpfo8K/V7B4Jg7KCX4/I7xHOfMD/sAnTtjR
	9BaMBxQiI1yt+PEr4gqZlHhdGJHqTCWuJLd6IBGR2fYYhNMbZ3ZdMISzYBfc+mjO
	9nEWljhBESfLHaaD76+1mRfWWQKgEGFdR4tfcwGcemjeXec58QszHyhPrbMfsr2a
	0Ea2PtkhXFQmtxP7eNlWE1/WOhVX8vYRbp5w6g1oVfQxQWK5PipHNvv14KrrJWHF
	i7o58Zd7uIeLLY1ZCoUZweL7hE8t37cUyQwHugG8NMmHqV9p7qI2JIaWUNGaadnj
	Ca85Edyy5ztloPiuSls3+hjP7cFI3sqepxK25CrdZ0A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 412mcychak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Aug 2024 09:46:05 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 47K9k5Mu020704;
	Tue, 20 Aug 2024 09:46:05 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 412mcychaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Aug 2024 09:46:05 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 47K709j0019050;
	Tue, 20 Aug 2024 09:46:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41376pt8mn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Aug 2024 09:46:03 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 47K9jx1n44564880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Aug 2024 09:46:01 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9FDC920040;
	Tue, 20 Aug 2024 09:45:59 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BDB720043;
	Tue, 20 Aug 2024 09:45:56 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.126.150.29])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 20 Aug 2024 09:45:56 +0000 (GMT)
Date: Tue, 20 Aug 2024 15:15:55 +0530
From: Srikar Dronamraju <srikar@linux.ibm.com>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, joelaf@google.com,
        vineethrp@google.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, ssouhlal@freebsd.org
Subject: Re: [PATCH] sched: Don't try to catch up excess steal time.
Message-ID: <20240820094555.7gdb5ado35syu5me@linux.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.ibm.com>
References: <20240806111157.1336532-1-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20240806111157.1336532-1-suleiman@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cPxn1kO2NvksYzEG0w_TjSPI6hmDCQuS
X-Proofpoint-GUID: KVE_SRLuu4Ch3kvSR4pJOS9Lq3ER3o1y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-20_09,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=853 spamscore=0 lowpriorityscore=0 clxscore=1011
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2407110000 definitions=main-2408200070

* Suleiman Souhlal <suleiman@google.com> [2024-08-06 20:11:57]:

> When steal time exceeds the measured delta when updating clock_task, we
> currently try to catch up the excess in future updates.
> However, this results in inaccurate run times for the future clock_task
> measurements, as they end up getting additional steal time that did not
> actually happen, from the previous excess steal time being paid back.
> 
> For example, suppose a task in a VM runs for 10ms and had 15ms of steal
> time reported while it ran. clock_task rightly doesn't advance. Then, a
> different task runs on the same rq for 10ms without any time stolen.
> Because of the current catch up mechanism, clock_sched inaccurately ends
> up advancing by only 5ms instead of 10ms even though there wasn't any
> actual time stolen. The second task is getting charged for less time
> than it ran, even though it didn't deserve it.
> In other words, tasks can end up getting more run time than they should
> actually get.
> 
> So, we instead don't make future updates pay back past excess stolen time.
> 
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  kernel/sched/core.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index bcf2c4cc0522..42b37da2bda6 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -728,13 +728,15 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
>  #endif
>  #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
>  	if (static_key_false((&paravirt_steal_rq_enabled))) {
> -		steal = paravirt_steal_clock(cpu_of(rq));
> +		u64 prev_steal;
> +
> +		steal = prev_steal = paravirt_steal_clock(cpu_of(rq));
>  		steal -= rq->prev_steal_time_rq;
>  
>  		if (unlikely(steal > delta))
>  			steal = delta;
>  
> -		rq->prev_steal_time_rq += steal;
> +		rq->prev_steal_time_rq = prev_steal;
>  		delta -= steal;
>  	}
>  #endif


Agree with the change.

Probably, we could have achieved by just moving a line above
Something like this?

#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
	if (static_key_false((&paravirt_steal_rq_enabled))) {
		steal = paravirt_steal_clock(cpu_of(rq));
		steal -= rq->prev_steal_time_rq;
		rq->prev_steal_time_rq += steal;

		if (unlikely(steal > delta))
			steal = delta;

		delta -= steal;
	}
#endif


-- 
Thanks and Regards
Srikar Dronamraju

