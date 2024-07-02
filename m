Return-Path: <kvm+bounces-20850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0342923FFD
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 16:11:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A2CF1F22E0D
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 14:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A217F1BA060;
	Tue,  2 Jul 2024 14:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YxCVCEV3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881641DDD6;
	Tue,  2 Jul 2024 14:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719929460; cv=none; b=WujGegQVCqUGD6wmCsnaE0Ixq3TjlXIOp6kkaeXZG+dF0ucSPVECFkRPkxn8zyx10yXdEh97abZTj9W4ShiVkBgDJ2kBGwbCuBae6rkvOifbnFdsKuX0DWjIMRc6RvX77g9No/ZuOXJhWp2uzTvD3QpYs6HM5dvtHEVsmo5yssg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719929460; c=relaxed/simple;
	bh=jB7e0BWJUYy8pnYPEEOc3nSFaGq1u1krnDozmi3jQjM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J+Iopty+QZYF2qTmEqqQGhEcD/Cystd5cr0Nlz263uruqWfRp+mDZD84X7eUG3XVuZkJGMt60SX8a8XLYqwPEraiQq4kQylJ0WhcSlu9jDdLkKXZgYop2JVJi2ekTE5IpylY7CFeC4w0u9tyQLj5UxAo3n02SnsSTZkkLD4X/Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YxCVCEV3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 462DwE8l027175;
	Tue, 2 Jul 2024 14:10:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=d
	DTSHAKS0Syv4Qne1bjB6vcqNRJn3LQKmhsFFS/Xv2k=; b=YxCVCEV36K5XqJKql
	BBR0a3hGZW6GKYPUpzCG+NsP1wRfGQWYXVNtpEFWxp828rN5xZPGqxQrLAwahztL
	RLGRkquw4gp/dn8iaxFgokebNU0fV8QzEvUVd6VJfnJUzKCnpXj2VdmuQ3MT6p3S
	tAQNl3bNcujBxRw22ImHCgSeTBtvGk+Q6rrSHKqFHtcJqg6vfVNOvBQ2tRvLJrX5
	axxs7WpQx0BiEnjjXiylWFTwlHy/KTxCS8vwfLTZqro88+BmaO35No6riat/Lkgw
	E6rXsYRdxAoXYMj+1ZYwPWjRPZPaCyBI+gJsI+B80+7Q15nRZ0/EeGdlQ+NioPvD
	DFX3g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 404jw9r1a9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jul 2024 14:10:10 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 462EAAj5013168;
	Tue, 2 Jul 2024 14:10:10 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 404jw9r1a1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jul 2024 14:10:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 462CAdDe024071;
	Tue, 2 Jul 2024 14:10:09 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 402ya3cttf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jul 2024 14:10:09 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 462EA5mm62128520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Jul 2024 14:10:08 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC03C58086;
	Tue,  2 Jul 2024 14:10:01 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4EFE258051;
	Tue,  2 Jul 2024 14:09:54 +0000 (GMT)
Received: from [9.195.35.111] (unknown [9.195.35.111])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  2 Jul 2024 14:09:54 +0000 (GMT)
Message-ID: <d9625965-6742-4d48-ab8a-60a5a8b6be30@linux.ibm.com>
Date: Tue, 2 Jul 2024 19:39:52 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 21/21] sched/cputime: Cope with steal time going
 backwards or negative
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Durrant
 <paul@xen.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira
 <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jalliste@amazon.co.uk, sveith@amazon.de,
        zide.chen@intel.com, Dongli Zhang <dongli.zhang@oracle.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org
References: <20240522001817.619072-1-dwmw2@infradead.org>
 <20240522001817.619072-22-dwmw2@infradead.org>
From: Shrikanth Hegde <sshegde@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20240522001817.619072-22-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8Kkr1ADykf2YsmO5WnLXu5WZuSB9XAYW
X-Proofpoint-ORIG-GUID: T3nKIhJIKBS1A199aUafYu2FD1DdVyo8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-02_09,2024-07-02_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 clxscore=1011
 impostorscore=0 suspectscore=0 spamscore=0 phishscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407020103



On 5/22/24 5:47 AM, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> In steal_account_process_time(), a delta is calculated between the value
> returned by paravirt_steal_clock(), and this_rq()->prev_steal_time which
> is assumed to be the *previous* value returned by paravirt_steal_clock().
> 
> However, instead of just assigning the newly-read value directly into
> ->prev_steal_time for use in the next iteration, ->prev_steal_time is
> *incremented* by the calculated delta.


Does this happen because ULONG_MAX and u64 aren't of same size? If so, 
would using the u64 variant of MAX would be a simpler fix?

> 
> This used to be roughly the same, modulo conversion to jiffies and back,
> until commit 807e5b80687c0 ("sched/cputime: Add steal time support to
> full dynticks CPU time accounting") started clamping that delta to a
> maximum of the actual time elapsed. So now, if the value returned by
> paravirt_steal_clock() jumps by a large amount, instead of a *single*
> period of reporting 100% steal time, the system will report 100% steal
> time for as long as it takes to "catch up" with the reported value.
> Which is up to 584 years.
> 
> But there is a benefit to advancing ->prev_steal_time only by the time
> which was *accounted* as having been stolen. It means that any extra
> time truncated by the clamping will be accounted in the next sample
> period rather than lost. Given the stochastic nature of the sampling,
> that is more accurate overall.
> 
> So, continue to advance ->prev_steal_time by the accounted value as
> long as the delta isn't egregiously large (for which, use maxtime * 2).
> If the delta is more than that, just set ->prev_steal_time directly to
> the value returned by paravirt_steal_clock().
> 
> Fixes: 807e5b80687c0 ("sched/cputime: Add steal time support to full dynticks CPU time accounting")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  kernel/sched/cputime.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index af7952f12e6c..3a8a8b38966d 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -254,13 +254,21 @@ static __always_inline u64 steal_account_process_time(u64 maxtime)
>  {
>  #ifdef CONFIG_PARAVIRT
>  	if (static_key_false(&paravirt_steal_enabled)) {
> -		u64 steal;
> -
> -		steal = paravirt_steal_clock(smp_processor_id());
> -		steal -= this_rq()->prev_steal_time;
> -		steal = min(steal, maxtime);
> +		u64 steal, abs_steal;
> +
> +		abs_steal = paravirt_steal_clock(smp_processor_id());
> +		steal = abs_steal - this_rq()->prev_steal_time;
> +		if (unlikely(steal > maxtime)) {
> +			/*
> +			 * If the delta isn't egregious, it can be counted
> +			 * in the next time period. Only advance by maxtime.
> +			 */
> +			if (steal < maxtime * 2)
> +				abs_steal = this_rq()->prev_steal_time + maxtime;
> +			steal = maxtime;
> +		}
>  		account_steal_time(steal);
> -		this_rq()->prev_steal_time += steal;
> +		this_rq()->prev_steal_time = abs_steal;
>  
>  		return steal;
>  	}

