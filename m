Return-Path: <kvm+bounces-55613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE043B340D0
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 15:34:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D41C189B78F
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 13:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B63C27380A;
	Mon, 25 Aug 2025 13:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nSoNGub+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212E11A9F89;
	Mon, 25 Aug 2025 13:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756128861; cv=none; b=VlH6KHZZv739hrFZA+uwKPMgCf/6ET2GDoQt2ip2gzxjVr4K/CrU96iA8KEaj5Pf1AfJ6KGDLD2JIW7T8FX2bG2VlxRuNWMdFLs7WwQe2SCpNc9TvQIjmGnYxQBFpAGyBxWVNdxnkJq03CghNDWTcf9azLyZATL092l0qLM4MDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756128861; c=relaxed/simple;
	bh=CCGJkYhHv6r53MD0QIkrv3WyoU2uM4jlc1ErpFQQMIg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oqFIz4PpnlzpHf2PM+zV92GVKp0hUENrmJOgpAW6CNt6LFJhHr473kTQKpaoi7GEoIyWb7eMh8yikCXHzis+M90W5D+7rxemOxGbK7+4pV8tpslYrESjs8W4+xp2PFkR9vSmjjINswpu3xDo2NMsdr9oLk2OvhM+d5wUO2FZReg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nSoNGub+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PBD2cP019425;
	Mon, 25 Aug 2025 13:34:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=33mw3k
	9+Z7/3mpLUSaMOxp6CbqWVf4Vsc6++NrhwCSo=; b=nSoNGub+I/6+7orQEkiNXn
	aUW+sOmvDRD5RlZki1ebFp9FYqLI/Toeb/ucedSF8xr0E4Lw5z6Msw+6p7fjt3r0
	oNCOztHuqVBj+zu54I+iy4TQN5BHHS2cwjdatmLWg+Tl+vYVVbMWjUMwEE8HBq+B
	6tytZfts4JMhY+tSSoudkCc4EyZgxAdY+xaBDXAUNLSnuv8XtkaO4PwQcZET8TAR
	RjToHem5lKz59wrIbMCWSoBj+E0Tyr9bC8rd2QntBgJwd1gahkx0yQcSJFJYJwQW
	5NcxIV1uxI3j7EXuZftzOHP6yAzZo3/DC+z1XjGFJn8j0ZLCBNqi/HwFxk/zzAVQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q557s701-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 13:34:16 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57PD93re007451;
	Mon, 25 Aug 2025 13:34:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qqyu67xp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 13:34:15 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57PDYCPA20316726
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 13:34:12 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 171A320043;
	Mon, 25 Aug 2025 13:34:12 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4FFD320040;
	Mon, 25 Aug 2025 13:34:11 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.17.238])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 25 Aug 2025 13:34:11 +0000 (GMT)
Date: Mon, 25 Aug 2025 15:34:07 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        Peter Xu
 <peterx@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: Fix access to unavailable adapter indicator
 pages during postcopy
Message-ID: <20250825153407.5337aaa6@p-imbrenda>
In-Reply-To: <20250821152309.847187-1-thuth@redhat.com>
References: <20250821152309.847187-1-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dDvztKvdQcyIY1lgd-Kkk-12QFPLgLgS
X-Proofpoint-ORIG-GUID: dDvztKvdQcyIY1lgd-Kkk-12QFPLgLgS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyMSBTYWx0ZWRfX5M9SoNFqepBS
 FGGj8TizaT4m7vmTd/2jynReafkxR+GUmeESSL2tFW6+cMIzaWVgZRJ8ZjHckjuISROvMAL+wSo
 gwi/tnPTvZp87o0m/YLMWDC+voFB/+GiiW+h8g4+T7e0isLDmp1nM6+GyjuYdfxxoDaIGg00yTD
 UaQi5/Die8KKK3zoBQwp5wCdXglUAPLT7PBTGP1ueWkBYDvIHYLTarqFKdY6rFjVKSDYcbypJzp
 61CEotfB/o8rypLkK5+QROwJn+eB0Zip9eZ1MpVuXY1ut7SxjjtOQRp+NecHEu/troUiwyhDph/
 CLbKgODCzWgQPQ4Al3i3DhqDeJ6TFScjxSvvEOXt+1ZulBNnIyIqjPVu306HEQ9mMSUNC+8xglP
 tsMyCyLq
X-Authority-Analysis: v=2.4 cv=A8ZsP7WG c=1 sm=1 tr=0 ts=68ac6658 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=quq3VhT3AGQ69vMGiI4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_06,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230021

On Thu, 21 Aug 2025 17:23:09 +0200
Thomas Huth <thuth@redhat.com> wrote:

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
>  FAULT_FLAG_ALLOW_RETRY missing 881
>  CPU: 6 UID: 0 PID: 549 Comm: kworker/6:2 Kdump: loaded Not tainted 6.16.0 #56 NONE
>  Hardware name: IBM 3931 LA1 400 (LPAR)
>  Workqueue: events irqfd_inject [kvm]
>  Call Trace:
>   [<00003173cbecc634>] dump_stack_lvl+0x104/0x168
>   [<00003173cca69588>] handle_userfault+0xde8/0x1310
>   [<00003173cc756f0c>] handle_pte_fault+0x4fc/0x760
>   [<00003173cc759212>] __handle_mm_fault+0x452/0xa00
>   [<00003173cc7599ba>] handle_mm_fault+0x1fa/0x6a0
>   [<00003173cc73409a>] __get_user_pages+0x4aa/0xba0
>   [<00003173cc7349e8>] get_user_pages_remote+0x258/0x770
>   [<000031734be6f052>] get_map_page+0xe2/0x190 [kvm]
>   [<000031734be6f910>] adapter_indicators_set+0x50/0x4a0 [kvm]
>   [<000031734be7f674>] set_adapter_int+0xc4/0x170 [kvm]
>   [<000031734be2f268>] kvm_set_irq+0x228/0x3f0 [kvm]
>   [<000031734be27000>] irqfd_inject+0xd0/0x150 [kvm]
>   [<00003173cc00c9ec>] process_one_work+0x87c/0x1490
>   [<00003173cc00dda6>] worker_thread+0x7a6/0x1010
>   [<00003173cc02dc36>] kthread+0x3b6/0x710
>   [<00003173cbed2f0c>] __ret_from_fork+0xdc/0x7f0
>   [<00003173cdd737ca>] ret_from_fork+0xa/0x30
>  3 locks held by kworker/6:2/549:
>   #0: 00000000800bc958 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x7ee/0x1490
>   #1: 000030f3d527fbd0 ((work_completion)(&irqfd->inject)){+.+.}-{0:0}, at: process_one_work+0x81c/0x1490
>   #2: 00000000f99862b0 (&mm->mmap_lock){++++}-{3:3}, at: get_map_page+0xa8/0x190 [kvm]
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

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  Note: Instructions for reproducing the bug can be found in the ticket here:
>  https://issues.redhat.com/browse/RHEL-42486?focusedId=26661116#comment-26661116
> 
>  arch/s390/kvm/interrupt.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 60c360c18690f..dcce826ae9875 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -2777,12 +2777,19 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
>  
>  static struct page *get_map_page(struct kvm *kvm, u64 uaddr)
>  {
> +	struct mm_struct *mm = kvm->mm;
>  	struct page *page = NULL;
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
>  	return page;
>  }
>  


