Return-Path: <kvm+bounces-56821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 117FEB439A4
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 13:12:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA1DF587E62
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 11:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993372FC881;
	Thu,  4 Sep 2025 11:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bRPTOnXh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4CB2EC08B;
	Thu,  4 Sep 2025 11:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756984358; cv=none; b=rTksIZz9D7Iphvfp0hmD5XlelzhBi6Hw4krII1kF36FOZagZ+zEo6F6T8/4f+xArhPQeC2gpWmbScqjBIg9kw3Y/xSDV8oh+CrfIC4tnvHTpXa8DvyNUY3/eGncLdQEoZdFopc9JbsafL+WYlUVS0rp0TTEgx7Hrar4taN9sUmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756984358; c=relaxed/simple;
	bh=NUh4Ct3rcDGpktOBV6+CRcuN5e1CANyp9gZr1JFgsFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mrf/habRCGzUYiduJPwWML1wkLLFnnVUZDfJ17vXILjBnl+uczc1+lig8hYVgwJCKFBoY8MUniv4WU6fFPvl90k1FCIBjxAmYGgzWyqPVxaKVl/RETLP5M8WWTvVuAbSUJkShHfrlLnuCP2FPxzfLUMLPNqMF6MOPpu41BOxjig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bRPTOnXh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58493o0q001636;
	Thu, 4 Sep 2025 11:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=fJdoxL
	fUDXXsS/d69LQviT/kSS1XVQYsqlBlsnjzJQY=; b=bRPTOnXhvvfQjliamjrXZA
	JRZxYRQHQu4JTWNSbxihlku4vQ91bFKXgW2odznOK38B9O449LyCumbwoDgFqW5C
	XE1XolxAkgduV6EVXRmO0C8UN/tS6Z5uEIdbOwj0MopPnQeAm9Q8UqsR/1xCXoNw
	O14fLE25lODSFC26C6e3BdQlSqg58XQvGLuXN6Q4XgVzX1htcvcpij9YHG0DvfFv
	1q2pzpUcA2ahos6YmRnmjq4vPEnfp5wtCc59rvlD2XkmpQ3iTwJQOzxAJsRrc3yo
	vMNjPymryOBOprFAtXaJZfx1ajTF58er8oHHaIrtcip03MWe9iHmIxXI6Iwnr3zw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48wshf5fq6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Sep 2025 11:12:33 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 584916hH014345;
	Thu, 4 Sep 2025 11:12:33 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48veb3kv9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Sep 2025 11:12:33 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 584BCSQ851446232
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 4 Sep 2025 11:12:28 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CCC682004E;
	Thu,  4 Sep 2025 11:12:28 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC20420043;
	Thu,  4 Sep 2025 11:12:27 +0000 (GMT)
Received: from [9.87.130.193] (unknown [9.87.130.193])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  4 Sep 2025 11:12:27 +0000 (GMT)
Message-ID: <7b5c5629-49b1-42c0-ad88-e955be7b6e2b@linux.ibm.com>
Date: Thu, 4 Sep 2025 13:12:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: Fix access to unavailable adapter indicator
 pages during postcopy
To: Thomas Huth <thuth@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Freimuth <freimuth@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
References: <20250821152309.847187-1-thuth@redhat.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20250821152309.847187-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -DVYUYSDcWqDqcfSbqDpZA1CMZZZTQOk
X-Authority-Analysis: v=2.4 cv=do3bC0g4 c=1 sm=1 tr=0 ts=68b97422 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=20KFwNOVAAAA:8 a=XFCOAtceyYmSXJIPWGwA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: -DVYUYSDcWqDqcfSbqDpZA1CMZZZTQOk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTAyMDA0MCBTYWx0ZWRfX+OIuZGaxCPHI
 qqIuXuLPOGlefmOgGgmBsRpNE//VCq2m7SJamL6w4AZodUGQ0hBf/cOFRUg8lFZ4et1CEHIS0Fg
 DUH+qioJGH9clJNr9HB6BwkJHlDQUPRGl9Fac+U6bf0nTF0yTW1LENoRTUp3nHKzVRr4tONThnA
 Sna2b6IUChwuLb1o3xIgy30xJuB4qaYgHC5e4UHc9XEuwGRUEA6pIbDQhkDW+dAGRP3sjxy4Efi
 6ug6UFhJgA7+MO7mcSbjCMEQaw1XkhuJNz/GTnerobFKLcmusuFFzsxJ0w52J7peHgjXE2FeS21
 EpBwgxZjIau6JMkdgm86zu3F61jzJjL0aMCF59tENIyC52p/zRMlPccbv9Z3dUTCFJE2fOF6S3c
 yNDJSAam
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1011 impostorscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509020040

CC Douglas, since Doug is looking into kvm_arch_set_irq_inatomic and this might have implications.


Am 21.08.25 um 17:23 schrieb Thomas Huth:
> From: Thomas Huth <thuth@redhat.com>
> 
> When you run a KVM guest with vhost-net and migrate that guest to
> another host, and you immediately enable postcopy after starting the
> migration, there is a big chance that the network connection of the
> guest won't work anymore on the destination side after the migration.
> 
> With a debug kernel v6.16.0, there is also a call trace that looks
> like this:
> 
>   FAULT_FLAG_ALLOW_RETRY missing 881
>   CPU: 6 UID: 0 PID: 549 Comm: kworker/6:2 Kdump: loaded Not tainted 6.16.0 #56 NONE
>   Hardware name: IBM 3931 LA1 400 (LPAR)
>   Workqueue: events irqfd_inject [kvm]
>   Call Trace:
>    [<00003173cbecc634>] dump_stack_lvl+0x104/0x168
>    [<00003173cca69588>] handle_userfault+0xde8/0x1310
>    [<00003173cc756f0c>] handle_pte_fault+0x4fc/0x760
>    [<00003173cc759212>] __handle_mm_fault+0x452/0xa00
>    [<00003173cc7599ba>] handle_mm_fault+0x1fa/0x6a0
>    [<00003173cc73409a>] __get_user_pages+0x4aa/0xba0
>    [<00003173cc7349e8>] get_user_pages_remote+0x258/0x770
>    [<000031734be6f052>] get_map_page+0xe2/0x190 [kvm]
>    [<000031734be6f910>] adapter_indicators_set+0x50/0x4a0 [kvm]
>    [<000031734be7f674>] set_adapter_int+0xc4/0x170 [kvm]
>    [<000031734be2f268>] kvm_set_irq+0x228/0x3f0 [kvm]
>    [<000031734be27000>] irqfd_inject+0xd0/0x150 [kvm]
>    [<00003173cc00c9ec>] process_one_work+0x87c/0x1490
>    [<00003173cc00dda6>] worker_thread+0x7a6/0x1010
>    [<00003173cc02dc36>] kthread+0x3b6/0x710
>    [<00003173cbed2f0c>] __ret_from_fork+0xdc/0x7f0
>    [<00003173cdd737ca>] ret_from_fork+0xa/0x30
>   3 locks held by kworker/6:2/549:
>    #0: 00000000800bc958 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x7ee/0x1490
>    #1: 000030f3d527fbd0 ((work_completion)(&irqfd->inject)){+.+.}-{0:0}, at: process_one_work+0x81c/0x1490
>    #2: 00000000f99862b0 (&mm->mmap_lock){++++}-{3:3}, at: get_map_page+0xa8/0x190 [kvm]
> 
> The "FAULT_FLAG_ALLOW_RETRY missing" indicates that handle_userfaultfd()
> saw a page fault request without ALLOW_RETRY flag set, hence userfaultfd
> cannot remotely resolve it (because the caller was asking for an immediate
> resolution, aka, FAULT_FLAG_NOWAIT, while remote faults can take time).
> With that, get_map_page() failed and the irq was lost.
> 
> We should not be strictly in an atomic environment here and the worker
> should be sleepable (the call is done during an ioctl from userspace),
> so we can allow adapter_indicators_set() to just sleep waiting for the
> remote fault instead.
> 
> Link: https://issues.redhat.com/browse/RHEL-42486
> Signed-off-by: Peter Xu <peterx@redhat.com>
> [thuth: Assembled patch description and fixed some cosmetical issues]
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   Note: Instructions for reproducing the bug can be found in the ticket here:
>   https://issues.redhat.com/browse/RHEL-42486?focusedId=26661116#comment-26661116
> 
>   arch/s390/kvm/interrupt.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 60c360c18690f..dcce826ae9875 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -2777,12 +2777,19 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
>   
>   static struct page *get_map_page(struct kvm *kvm, u64 uaddr)
>   {
> +	struct mm_struct *mm = kvm->mm;
>   	struct page *page = NULL;
> +	int locked = 1;
> +
> +	if (mmget_not_zero(mm)) {
> +		mmap_read_lock(mm);
> +		get_user_pages_remote(mm, uaddr, 1, FOLL_WRITE,
> +				      &page, &locked);
> +		if (locked)
> +			mmap_read_unlock(mm);
> +		mmput(mm);
> +	}
>   
> -	mmap_read_lock(kvm->mm);
> -	get_user_pages_remote(kvm->mm, uaddr, 1, FOLL_WRITE,
> -			      &page, NULL);
> -	mmap_read_unlock(kvm->mm);
>   	return page;
>   }
>   


