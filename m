Return-Path: <kvm+bounces-57762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C2BBB59EB8
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 19:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D4B0188EC82
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 17:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F8332D5B1;
	Tue, 16 Sep 2025 17:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rrZXaxbh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972D432D5A6;
	Tue, 16 Sep 2025 17:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758042081; cv=none; b=BnfnWscYFBGdprPk0YQDPEU3ZOeo66tLNBZ8YrpamyNgucH8/dcRVTCKVBV+zQM/iKu+rQYfjqUAigUEsCoUWhCDS4T5WM7Le7HypKivMxAhhaS/ZreexqK9Zq/Hu8znKHTo8pIsZuNIx9h+BrF5K73tA7ZPQaojngLPwgkAPHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758042081; c=relaxed/simple;
	bh=c08ULWhSovFzkjR4MIDYzLxTq2VIaUbRfgWrKgXFAR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h6M1AlnQcImUASll9+QZy2xEoAyCcB0FhB3e9xjBNMj2e6touQOTCDI4y0tigpsuJtT8ErnM/6Tet++JVc4a1zZuBuJSIALngzlPOYjxLNIZLOBt/frscI++MBJjFNhim53wndNz+5hWb5TqBTjbm7wqj7cI1YGZin1k1wTMWYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rrZXaxbh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GEsp6B021118;
	Tue, 16 Sep 2025 17:01:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=oGk4a7
	Ji2TuIkeJ53r1UylgprJi5w3cLiXou3eLMb4E=; b=rrZXaxbhtDPTykbIvIJeIs
	2tObsAaIyehC/qidbn944tlojDMod3C9+p9reeyKpTMqOEEGy9tjo7uyba9fcfED
	b51+hEMMP0NfkKwUg4nReonhTBSNYvLHRm6BvlDCvMv4dumPMXzDnc/Ann2jLCMZ
	362Zn2fbPNma2nyD7ZVjPQEuDTZoZvZ+IBLEzfF2hQ9iaoshx8uYkHkRwuGU/hYk
	ggDD93ON7KImdm1j5wUbaFAvpFY7UToanLLIv5ykeG197FIjjShTF4HTmau795Gr
	IbOZu32NR6iYLfr4YaNnXgs6hOLn35ubc8hvzTCvuhz4uc2dNlIlfLYw3RypZvFA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496g538k9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 17:01:16 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58GEZdeo027268;
	Tue, 16 Sep 2025 17:01:16 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495men4xuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 17:01:16 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GH1Cca51380568
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 17:01:12 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 468212004B;
	Tue, 16 Sep 2025 17:01:12 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83E3D20040;
	Tue, 16 Sep 2025 17:01:11 +0000 (GMT)
Received: from [9.87.138.242] (unknown [9.87.138.242])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Sep 2025 17:01:11 +0000 (GMT)
Message-ID: <63e8c905-28b1-4e1f-be77-e0789bd75692@de.ibm.com>
Date: Tue, 16 Sep 2025 19:01:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management functions:
 allocation
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        david@redhat.com, gerald.schaefer@linux.ibm.com
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-9-imbrenda@linux.ibm.com>
 <20250916162653.27229G04-hca@linux.ibm.com>
 <20250916184737.47224f56@p-imbrenda>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20250916184737.47224f56@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5iZiNEjYuIpTO32MKe93rztYjBrOJVik
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDA4NiBTYWx0ZWRfX19/9WI1ywN4R
 CtucutniOcfyTauGOcmDYamq7RjK1yA+skluYWC68DmQVqg08tDJf8WjxeMtsVlyoidglOhUh1Y
 DYpkL3yL/Nz0w0FOfBCAZleoZ5Y7ay9Xzvl3zjt3hq8iV4L8mlsCfSqmqkFaBm4LruJylZKT9Hb
 RhiC40m01mzJtpcozVYAMBsz4O5USvGrjBVuDdAXJ4ZfFg2Y1Ws8wX8APGgw6KAfdAh+ue8JRWP
 0lulvNMO5Uux3tdEUsrkCPg2a6RI5jgTS05RkowDiENuB26fFamruYGixD0rt2WGzqk15mq6QaI
 cJiwgG06h2dxcf6entaQc2SvzOLKXK6ejR6SuwJkcsLD0yv0zZkUFsVs1+Lwq0fczF4k0TiOZXH
 x6LEtMQx
X-Proofpoint-ORIG-GUID: 5iZiNEjYuIpTO32MKe93rztYjBrOJVik
X-Authority-Analysis: v=2.4 cv=UJ7dHDfy c=1 sm=1 tr=0 ts=68c997dd cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=opiTKE2Bby9siTmdRhEA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150086



Am 16.09.25 um 18:47 schrieb Claudio Imbrenda:
> On Tue, 16 Sep 2025 18:26:53 +0200
> Heiko Carstens <hca@linux.ibm.com> wrote:
> 
>> On Wed, Sep 10, 2025 at 08:07:34PM +0200, Claudio Imbrenda wrote:
>>> Add page table management functions to be used for KVM guest (gmap)
>>> page tables.
>>>
>>> This patch adds the boilerplate and functions for the allocation and
>>> deallocation of DAT tables.
>>>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> ---
>>>   arch/s390/kvm/Makefile     |  1 +
>>>   arch/s390/kvm/dat.c        | 91 ++++++++++++++++++++++++++++++++++++++
>>>   arch/s390/kvm/dat.h        |  4 ++
>>>   arch/s390/mm/page-states.c |  1 +
>>>   4 files changed, 97 insertions(+)
>>>   create mode 100644 arch/s390/kvm/dat.c
>>
>> ...
>>
>>> +static inline struct page_table *dat_alloc_pt_noinit(void)
>>> +{
>>> +	struct page *page;
>>> +	void *virt;
>>> +
>>> +	page = alloc_pages(GFP_ATOMIC, 0);
>>> +	if (!page)
>>> +		return NULL;
>>> +
>>> +	virt = page_to_virt(page);
>>> +	__arch_set_page_dat(virt, 1);
>>> +	return virt;
>>> +}
>>
>> Is GFP_ATOMIC a typo, and this should have been GFP_KERNEL?
>>
>> Otherwise I would guess this will cause problems in the future when
>> under memory pressure allocating guest page tables fails easily,
>> while before this change such allocations never failed.
> 
> how so? the documentation in gfp_types.h says:
> 
>   * %GFP_ATOMIC users can not sleep and need the allocation to succeed. A lower
>   * watermark is applied to allow access to "atomic reserves".
>   * The current implementation doesn't support NMI and few other strict
>   * non-preemptive contexts (e.g. raw_spin_lock). The same applies to %GFP_NOWAIT.
>   *
>   * %GFP_KERNEL is typical for kernel-internal allocations. The caller requires
>   * %ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
> 
> 
> I think GFP_ATOMIC actually gives more guarantees?

In real life GFP_ATOMIC can fail, GFP_KERNEL does not.All gfp allocation failures
are usually the atomic ones.

