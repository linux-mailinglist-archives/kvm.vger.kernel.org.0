Return-Path: <kvm+bounces-28802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3189399D6B2
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 20:44:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E602C284049
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 18:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BDB61CACD4;
	Mon, 14 Oct 2024 18:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BNEVfo2k"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D141B85CB;
	Mon, 14 Oct 2024 18:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728931438; cv=none; b=nZVNUwarbEuVtO1OwlQibzKBEkGR8fj7ojCjZRg/Uu33nkkr5NFFa+UARjdfLK8uQcAi83B7KIwoctMghUdF9nOoPhysFdKnBrikumbQL7rHZwEbMPOVYfhZHcdhUreqssei86AKTvxiyFTNTor9IYSQK06jij9pGlY0mktQoig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728931438; c=relaxed/simple;
	bh=L19KvoA+HG9Bh+eSb1zWXQsefgmXZ4DwOF4eyvQl9gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uAG8zOVyTr5I5fSzbSAdPr7aXIXk9ju49CK02ZikQJm+zHx8jLTs5z+QUAapOURk0S1Uuox8sSAf0wE4oPiVpNTEHvNvrWQ0tYH7XzP0owFenwRbow67cmdVRHRQ0kks7vtHB8kA+cNLljRgBXUJZZA0T4CXN+P/cN+lfRD3TrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BNEVfo2k; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EIT8I5008837;
	Mon, 14 Oct 2024 18:43:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=nuOiVE6YX5KLsvxa6zabqNtcQLT
	+k4suKXrkdqwky0Q=; b=BNEVfo2kvZctYwMwaWKTDgkcY8TPiXnU8sRf6l21EjH
	gQTnkx6pjY2qEIRnLgk/Pf04E5JqDWaloCkE1oAqB326tawgmvwaj4P+o7pDh4O6
	HymVXidHsweh/q9sznByDTIoywD1CbE81wmC7zhuKTWkHlQzHXhjB3pq/GCYRo3+
	eaPdz81Oe1HOWtJrxdijEG6f0Pkwr2D8mVVhFClXc0To9gPwcXFd4hA6EhKdXt+c
	9gATC7aoVmIywLCOnL+57C5crSrJE09DpPXe4oIVNWlo/HSAZEXN47st8Qup0Edu
	6yxB3qYuuMe4kQVvilrRCEFzudmoUlXfTquZHoguMLQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4298m7r281-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:43:48 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49EIhmQc007686;
	Mon, 14 Oct 2024 18:43:48 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4298m7r27u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:43:47 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49EIb2cG007025;
	Mon, 14 Oct 2024 18:43:46 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284xjyxfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:43:46 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49EIhg0R41288078
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 18:43:42 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9719F2004D;
	Mon, 14 Oct 2024 18:43:42 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 694AF20040;
	Mon, 14 Oct 2024 18:43:41 +0000 (GMT)
Received: from osiris (unknown [9.171.66.174])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 14 Oct 2024 18:43:41 +0000 (GMT)
Date: Mon, 14 Oct 2024 20:43:39 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
Subject: Re: [PATCH v2 4/7] s390/physmem_info: query diag500(STORAGE LIMIT)
 to support QEMU/KVM memory devices
Message-ID: <20241014184339.10447-E-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-5-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014144622.876731-5-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bdm0jANgH3licBgVzWntyxR77QM8XgPw
X-Proofpoint-GUID: mxM05b8kFTSUrO4aochPmncpoIkXsq_A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_12,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 spamscore=0 suspectscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=495 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410140131

On Mon, Oct 14, 2024 at 04:46:16PM +0200, David Hildenbrand wrote:
> To support memory devices under QEMU/KVM, such as virtio-mem,
> we have to prepare our kernel virtual address space accordingly and
> have to know the highest possible physical memory address we might see
> later: the storage limit. The good old SCLP interface is not suitable for
> this use case.
> 
> In particular, memory owned by memory devices has no relationship to
> storage increments, it is always detected using the device driver, and
> unaware OSes (no driver) must never try making use of that memory.
> Consequently this memory is located outside of the "maximum storage
> increment"-indicated memory range.
> 
> Let's use our new diag500 STORAGE_LIMIT subcode to query this storage
> limit that can exceed the "maximum storage increment", and use the
> existing interfaces (i.e., SCLP) to obtain information about the initial
> memory that is not owned+managed by memory devices.
> 
> If a hypervisor does not support such memory devices, the address exposed
> through diag500 STORAGE_LIMIT will correspond to the maximum storage
> increment exposed through SCLP.
> 
> To teach kdump on s390 to include memory owned by memory devices, there
> will be ways to query the relevant memory ranges from the device via a
> driver running in special kdump mode (like virtio-mem already implements
> to filter /proc/vmcore access so we don't end up reading from unplugged
> device blocks).
> 
> Tested-by: Mario Casquero <mcasquer@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/boot/physmem_info.c        | 46 ++++++++++++++++++++++++++--
>  arch/s390/include/asm/physmem_info.h |  3 ++
>  2 files changed, 46 insertions(+), 3 deletions(-)

...

> +static int diag500_storage_limit(unsigned long *max_physmem_end)
> +{
> +	register unsigned long __nr asm("1") = 0x4;
> +	register unsigned long __storage_limit asm("2") = 0;
> +	unsigned long reg1, reg2;
> +	psw_t old;

In general we do not allow register asm usage anymore in s390 code,
except for a very few defined places. This is due to all the problems
that we've seen with code instrumentation and register corruption.

The patch below changes your code accordingly, but it is
untested. Please verify that your code still works.

> @@ -157,7 +189,9 @@ unsigned long detect_max_physmem_end(void)
>  {
>  	unsigned long max_physmem_end = 0;
>  
> -	if (!sclp_early_get_memsize(&max_physmem_end)) {
> +	if (!diag500_storage_limit(&max_physmem_end)) {
> +		physmem_info.info_source = MEM_DETECT_DIAG500_STOR_LIMIT;
> +	} else if (!sclp_early_get_memsize(&max_physmem_end)) {
>  		physmem_info.info_source = MEM_DETECT_SCLP_READ_INFO;
>  	} else {
>  		max_physmem_end = search_mem_end();
> @@ -170,11 +204,17 @@ void detect_physmem_online_ranges(unsigned long max_physmem_end)
>  {
>  	if (!sclp_early_read_storage_info()) {
>  		physmem_info.info_source = MEM_DETECT_SCLP_STOR_INFO;
> +		return;
>  	} else if (!diag260()) {
>  		physmem_info.info_source = MEM_DETECT_DIAG260;
> -	} else if (max_physmem_end) {
> -		add_physmem_online_range(0, max_physmem_end);
> +		return;
> +	} else if (physmem_info.info_source == MEM_DETECT_DIAG500_STOR_LIMIT) {
> +		max_physmem_end = 0;
> +		if (!sclp_early_get_memsize(&max_physmem_end))
> +			physmem_info.info_source = MEM_DETECT_SCLP_READ_INFO;
>  	}
> +	if (max_physmem_end)
> +		add_physmem_online_range(0, max_physmem_end);
>  }

In general looks good to me, but I'd like to see that Vasily or
Alexander give an Ack to this patch.

diff --git a/arch/s390/boot/physmem_info.c b/arch/s390/boot/physmem_info.c
index fb4e66e80fd8..975fc478e0e3 100644
--- a/arch/s390/boot/physmem_info.c
+++ b/arch/s390/boot/physmem_info.c
@@ -109,10 +109,11 @@ static int diag260(void)
 	return 0;
 }
 
+#define DIAG500_SC_STOR_LIMIT 4
+
 static int diag500_storage_limit(unsigned long *max_physmem_end)
 {
-	register unsigned long __nr asm("1") = 0x4;
-	register unsigned long __storage_limit asm("2") = 0;
+	unsigned long storage_limit;
 	unsigned long reg1, reg2;
 	psw_t old;
 
@@ -123,21 +124,24 @@ static int diag500_storage_limit(unsigned long *max_physmem_end)
 		"	st	%[reg2],4(%[psw_pgm])\n"
 		"	larl	%[reg1],1f\n"
 		"	stg	%[reg1],8(%[psw_pgm])\n"
+		"	lghi	1,%[subcode]\n"
+		"	lghi	2,0\n"
 		"	diag	2,4,0x500\n"
 		"1:	mvc	0(16,%[psw_pgm]),0(%[psw_old])\n"
+		"	lgr	%[slimit],2\n"
 		: [reg1] "=&d" (reg1),
 		  [reg2] "=&a" (reg2),
-		  "+&d" (__storage_limit),
+		  [slimit] "=d" (storage_limit),
 		  "=Q" (get_lowcore()->program_new_psw),
 		  "=Q" (old)
 		: [psw_old] "a" (&old),
 		  [psw_pgm] "a" (&get_lowcore()->program_new_psw),
-		  "d" (__nr)
-		: "memory");
-	if (!__storage_limit)
-	        return -EINVAL;
-	/* convert inclusive end to exclusive end. */
-	*max_physmem_end = __storage_limit + 1;
+		  [subcode] "i" (DIAG500_SC_STOR_LIMIT)
+		: "memory", "1", "2");
+	if (!storage_limit)
+		return -EINVAL;
+	/* Convert inclusive end to exclusive end */
+	*max_physmem_end = storage_limit + 1;
 	return 0;
 }
 

