Return-Path: <kvm+bounces-57317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9966B532E4
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 14:57:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B2ED485A8B
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 12:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F208E322C60;
	Thu, 11 Sep 2025 12:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s35Fwrxw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF144324B2B;
	Thu, 11 Sep 2025 12:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757595439; cv=none; b=tk37O1BuGxyRxctxRFzNPvhWQLZEHfxRKUYiImcXduamVQeisctvyF7WlslrubqvTf2UX0qQV8xm3Dum/p5Uc95zZV4KCaOYOxUl/f/52WSNtFpslPj77Rq1y26qDIWlC74qxP4OAYr1EFG89P40qR0wCMFucKDs2ZV7yBBvbrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757595439; c=relaxed/simple;
	bh=D8mJ20nq5KVHZ3WwObG2jcxUSYVPuMGfWJ8gCeZ6d8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Isyk2mW0pz9G2IaVsgl6Ou5HEQRBeNmNtaXFGyf5HMyB7gu1yEzTcDM/W8uToiLks/+YfFOOfiqV7wf5RVal9JpREga/Wd6G/Cnl0UvLLuqOA+gh8XmbgsHIytA+pQO+qTbGC5yEJsUuIrnQudEUcDOaEb1NFfkiWY35fkjDDQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=s35Fwrxw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B9tek6005342;
	Thu, 11 Sep 2025 12:57:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hd6vmq
	mmavE59HNp9WygI4yYrrXDAdeVaff97XxRbJE=; b=s35FwrxwwrOgvhgadGerKq
	oyptUFK/McaKVJ2deS7CBHsjMYjE/Tl0qJUh3XBt9KHx0QiN65Bn1aPdPgj06FhR
	BFPWqwfubHsVPScXfCe87aWBKSilbHwu4SZLIHXct6RQHgExStvDnY03m+wCpA53
	W12mskhUyfmg9btPl3Gi8G+y49f86wJjWKcni6kIOU/6ofZqFTDnxgNqHX8F/gtD
	n912xcbXzfjkUiwF8WWmeQO3MzQqiIc20mxlR22/UYDNVhiBVvi6LuRFFJ/j9Kwn
	Ul4ydjg9KGcWTPPahPJk1ugbGXl095YPDDlcXbuy+RDWvRGjk3MHPjNIawpGhOJQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukesf2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 12:57:04 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58BCVtkK011457;
	Thu, 11 Sep 2025 12:57:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 490y9up4g1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 12:57:03 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BCv0AY58458420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 12:57:00 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 027C020043;
	Thu, 11 Sep 2025 12:57:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78A5F20040;
	Thu, 11 Sep 2025 12:56:59 +0000 (GMT)
Received: from [9.87.150.119] (unknown [9.87.150.119])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 12:56:59 +0000 (GMT)
Message-ID: <aeb461ff-90a1-4d6e-a779-1c6e885bdddb@linux.ibm.com>
Date: Thu, 11 Sep 2025 14:56:59 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/20] KVM: s390: KVM page table management functions:
 walks
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        david@redhat.com, gerald.schaefer@linux.ibm.com
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-11-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20250910180746.125776-11-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfX9noVrmUmwY5p
 FPZberpCZTyuJFXX4k2wzTAsDHhrKAkHFvOgiGjRTfIM8O8cuEKWeV08Ima7PM3oCOAnxok+zNx
 8vpOODMZ+xg1azCv7KNlwFitpocvVuSEA7IfxptYDWl5wb/I6hI7/Sc1v5j8skh4CcFM3E+/7b7
 syJJPw/xTZ8utdP9f1RmD/H7zlXTt92+roGA7kbVHNbb2sF7TLMfVsqDjszqL7xw5LQJpsy1uG7
 G+vLCKPbvdWI9KY7AJTmhlQ7YwellLpKI8Re6E5Kn5YK2B++1UBS5pxpPscox5dYz6rGXkV28WA
 1OMJfOKmcMuPGsLO1VTynVggCXahGBD131eMIVD1c4b+c7AZRbjf1iFT0aPfLc93bowUIA+aeof
 8qs/Eyqa
X-Proofpoint-ORIG-GUID: jMw-K2j7awnlcspzKEJOZdHrFlK6SBX-
X-Proofpoint-GUID: jMw-K2j7awnlcspzKEJOZdHrFlK6SBX-
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68c2c720 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=ZaHFFdLEXfJz46AHvcMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195

On 9/10/25 8:07 PM, Claudio Imbrenda wrote:
> Add page table management functions to be used for KVM guest (gmap)
> page tables.
> 
> This patch adds functions to walk to specific table entries, or to
> perform actions on a range of entries.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/kvm/dat.c | 351 ++++++++++++++++++++++++++++++++++++++++++++
>   arch/s390/kvm/dat.h |  38 +++++
>   2 files changed, 389 insertions(+)
> 
> diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
> index f26e3579bd77..fe93e1c07158 100644
> --- a/arch/s390/kvm/dat.c
> +++ b/arch/s390/kvm/dat.c
> @@ -209,3 +209,354 @@ union pgste __dat_ptep_xchg(union pte *ptep, union pgste pgste, union pte new, g
>   	WRITE_ONCE(*ptep, new);
>   	return pgste;
>   }
> +
> +/*
> + * dat_split_pmd is assumed to be called with mmap_lock held in read or write mode
> + */
> +static int dat_split_pmd(union pmd *pmdp, gfn_t gfn, union asce asce)
> +{
> +	struct page_table *pt;
> +	union pmd new, old;
> +	union pte init;
> +	int i;
> +
> +	old = READ_ONCE(*pmdp);
> +
> +	/* Already split, nothing to do */
> +	if (!old.h.i && !old.h.fc)
> +		return 0;
> +
> +	pt = dat_alloc_pt_noinit();
> +	if (!pt)
> +		return -ENOMEM;
> +	new.val = virt_to_phys(pt);
> +
> +	while (old.h.i || old.h.fc) {
> +		init.val = pmd_origin_large(old);
> +		init.h.p = old.h.p;
> +		init.h.i = old.h.i;
> +		init.s.d = old.s.fc1.d;
> +		init.s.w = old.s.fc1.w;
> +		init.s.y = old.s.fc1.y;
> +		init.s.sd = old.s.fc1.sd;
> +		init.s.pr = old.s.fc1.pr;

This looks horrible but I haven't found a better solution.

> +		if (old.h.fc) {
> +			for (i = 0; i < _PAGE_ENTRIES; i++)
> +				pt->ptes[i].val = init.val | i * PAGE_SIZE;
> +			/* no need to take locks as the page table is not installed yet */
> +			dat_init_pgstes(pt, old.s.fc1.prefix_notif ? PGSTE_IN_BIT : 0);

So, if the pmd had the IN bit, all PGSTEs will have it as well, right?
Why can't we notify and not copy this bit, so the notifier sets it for 
the ptes which actually need it? Or does it happen later?

> +		} else {
> +			dat_init_page_table(pt, init.val, 0);
> +		}
> +
> +		if (dat_pmdp_xchg_atomic(pmdp, old, new, gfn, asce))
> +			return 0;
> +		old = READ_ONCE(*pmdp);
> +	}
> +
> +	dat_free_pt(pt);
> +	return 0;
> +}

