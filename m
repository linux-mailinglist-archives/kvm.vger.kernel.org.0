Return-Path: <kvm+bounces-28779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 275C899D40C
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 17:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4955AB2A450
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 15:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE1FE1AE016;
	Mon, 14 Oct 2024 15:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H4y6RVpg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7F549659;
	Mon, 14 Oct 2024 15:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920891; cv=none; b=ljCqNPhQWYwSd8YYMh7FcyQgtzsCT3HnINW/pZ5HU0VPabVvkfC4GP5PXWM2WsdWc6DZCPDL+2RgYJxePKU4K8Gwgo2a2MjXKlFEHcZ+kHXRxWPP3B87GxezZbtDlIJatZeT+Z6e+7CpHz1YhCNvokxwUANH0is1kBXJF2PYoaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920891; c=relaxed/simple;
	bh=E8NAc1rPlB54YfCHnEK8PZkZMrzWKd3HqcptMOAU8OQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R3Rs9HMVYbqkYXZw143DhmByrXPXcXQDIQIgJ9c7tnOcFgkW7j9bkNN3CMBo2xH/TeEflu4OqgBwLyGbqbaWvi+1eqZLMA64V7NhaGA7lxm7ZsjciulnVYP87qg1X02EmMDEqk1kxVbS0/SeMvJ7JZz38nCSX8d8g+KwTKoHUho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H4y6RVpg; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EEPArw027489;
	Mon, 14 Oct 2024 15:47:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=m
	qTXyRWMB3w0HH0XDXzBsU9A4VKm9qePpWykY6DK43Q=; b=H4y6RVpgiYsGQPpOt
	gCmJWd1gzeYNZXLvt79UsOUMjRQdZ+WMQ/53slT8i3a38gIhXaFemfkm0zyYL2TS
	P5P4D3iM0Q+ap9Z4LcjU6eyqcRBcZ+zfIC8wrAmF7z0hjDzPLR68TjQcViLj0m2B
	6Q+toG7DuodZPn44U974gKIG43fRx55fyfCgtDDULyu/MC0PxKWap7OV1uSc3P/F
	vfeoOdiNwWBGPMs9ReMQBE/isePJG/b1bepAlYtfgmbL9HAepNZhoTDQlc/tTCBi
	QOHnn1FGyKqkqYsXGViVAUXQvxWc0kNFXdouKCQ+1D+2uWSDh+vLjMMImLXuX/PQ
	C9zhg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42951u8d9f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 15:47:05 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49EFggWY013650;
	Mon, 14 Oct 2024 15:47:05 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42951u8d98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 15:47:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49ECgom4005930;
	Mon, 14 Oct 2024 15:47:03 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 428650q0jk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 15:47:03 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49EFl2FM41484626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 15:47:02 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 43ED75805E;
	Mon, 14 Oct 2024 15:47:02 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1171758050;
	Mon, 14 Oct 2024 15:46:41 +0000 (GMT)
Received: from [9.43.6.16] (unknown [9.43.6.16])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 14 Oct 2024 15:46:40 +0000 (GMT)
Message-ID: <43eacfd6-e1a3-4d2c-9511-9b5a5707bdcf@linux.ibm.com>
Date: Mon, 14 Oct 2024 21:16:38 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/5] powerpc: perf: Use perf_arch_instruction_pointer()
To: Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>, Will Deacon <will@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Naveen N Rao <naveen@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
References: <20240920174740.781614-1-coltonlewis@google.com>
 <20240920174740.781614-4-coltonlewis@google.com>
Content-Language: en-US
From: Madhavan Srinivasan <maddy@linux.ibm.com>
In-Reply-To: <20240920174740.781614-4-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Jwz0y2srETrJq5vnDrTRMrnGUJsrEiit
X-Proofpoint-ORIG-GUID: ZjFOQbPfI4aepiuQmLev7nPPg0fy7QCF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_10,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 clxscore=1015 adultscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2410140113



On 9/20/24 11:17 PM, Colton Lewis wrote:
> Make sure powerpc uses the arch-specific function now that those have
> been reorganized.
>

Changes looks fine to me.
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>

 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  arch/powerpc/perf/callchain.c    | 2 +-
>  arch/powerpc/perf/callchain_32.c | 2 +-
>  arch/powerpc/perf/callchain_64.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/perf/callchain.c b/arch/powerpc/perf/callchain.c
> index 6b4434dd0ff3..26aa26482c9a 100644
> --- a/arch/powerpc/perf/callchain.c
> +++ b/arch/powerpc/perf/callchain.c
> @@ -51,7 +51,7 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
>  
>  	lr = regs->link;
>  	sp = regs->gpr[1];
> -	perf_callchain_store(entry, perf_instruction_pointer(regs));
> +	perf_callchain_store(entry, perf_arch_instruction_pointer(regs));
>  
>  	if (!validate_sp(sp, current))
>  		return;
> diff --git a/arch/powerpc/perf/callchain_32.c b/arch/powerpc/perf/callchain_32.c
> index ea8cfe3806dc..ddcc2d8aa64a 100644
> --- a/arch/powerpc/perf/callchain_32.c
> +++ b/arch/powerpc/perf/callchain_32.c
> @@ -139,7 +139,7 @@ void perf_callchain_user_32(struct perf_callchain_entry_ctx *entry,
>  	long level = 0;
>  	unsigned int __user *fp, *uregs;
>  
> -	next_ip = perf_instruction_pointer(regs);
> +	next_ip = perf_arch_instruction_pointer(regs);
>  	lr = regs->link;
>  	sp = regs->gpr[1];
>  	perf_callchain_store(entry, next_ip);
> diff --git a/arch/powerpc/perf/callchain_64.c b/arch/powerpc/perf/callchain_64.c
> index 488e8a21a11e..115d1c105e8a 100644
> --- a/arch/powerpc/perf/callchain_64.c
> +++ b/arch/powerpc/perf/callchain_64.c
> @@ -74,7 +74,7 @@ void perf_callchain_user_64(struct perf_callchain_entry_ctx *entry,
>  	struct signal_frame_64 __user *sigframe;
>  	unsigned long __user *fp, *uregs;
>  
> -	next_ip = perf_instruction_pointer(regs);
> +	next_ip = perf_arch_instruction_pointer(regs);
>  	lr = regs->link;
>  	sp = regs->gpr[1];
>  	perf_callchain_store(entry, next_ip);


