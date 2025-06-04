Return-Path: <kvm+bounces-48391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DE61ACDDB7
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 14:17:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D0A83A2FC9
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 12:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D80F328ECFD;
	Wed,  4 Jun 2025 12:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZDG7755E"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB1B2C327E;
	Wed,  4 Jun 2025 12:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749039425; cv=none; b=IiYHdMQTsKlH6A8vk+cxq/ga5dPmwYQSkR03HcGYpb+/PFyg6/XovoVUrN0JYzgeBFP6DOQBNTGUZNnZ1u717IbhHHhIVooVDwNo0nj2T5vQDuZxa+dVSAlx0EPXgA5epgZn4IP36omXvHb9nYyUEOeSFiFHjDSK2L5mxHjulKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749039425; c=relaxed/simple;
	bh=BYEG8UxhrVg4vmXnOWAFZdFKVOOqkdCNcXJaeBUyLEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tKrNQ2AmsPFpzs7qriWRdgTL5FUM5wRWXf8c9UPDxGM+V2T/Eg5XaPSz7UCUnSzsw28henMCX7arJ0ui/aGJRIK7g+qooor2RD9N3zabLMAImqnvqIICjalwBY8aD0tBxa76SBJJuZH1wTBSEcGEA5SHNrpbY4BJu874z1tAutM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZDG7755E; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5543t1k6000498;
	Wed, 4 Jun 2025 12:17:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Lm/EAk
	8MgrTQ6UY9tgv52aZyMMIBuRgmYq2fBE2YC0E=; b=ZDG7755EGZieZn6nscDqtK
	3JH18HSi5iArGyxDVfWZwxSoZnV/q0+aYLuTKA50qFQfc3VukJta73g561xboQ5t
	1qM14Q0XiUmIjQNHGblpQRJtwosHui9uLw0WWjolBlNzgikdyHbCeF4iFkz4D8NO
	hUTXLMz5wrtKYKvq2ZYv9NnLlJPjgOljWiXlhVyP+ZUIFpppUdUyKwx65u3G4865
	tV/Rmka2JfFuOpcv1B7k9goGcoMLXJ5gtysUqLv69wtOXHf05NWE85F8HDkCziZA
	yitWvZgjG15hc5OgpzsNozHnzXUKFWryk4lpAvR2ZtzVOX9+SomLJy6pxehC2YaA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471geyt9tf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Jun 2025 12:17:01 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 554C4aLr019873;
	Wed, 4 Jun 2025 12:17:00 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470d3nymq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Jun 2025 12:17:00 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 554CGuvQ10092834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Jun 2025 12:16:56 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 44C5620049;
	Wed,  4 Jun 2025 12:16:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC0C520040;
	Wed,  4 Jun 2025 12:16:55 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Jun 2025 12:16:55 +0000 (GMT)
Date: Wed, 4 Jun 2025 14:16:43 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390/mm: Fix in_atomic() handling in
 do_secure_storage_access()
Message-ID: <20250604141643.3c04ae4e@p-imbrenda>
In-Reply-To: <20250603134936.1314139-1-hca@linux.ibm.com>
References: <20250603134936.1314139-1-hca@linux.ibm.com>
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
X-Proofpoint-GUID: _P9ZkWimBNBdfVwAV3mJrxSqWo5a6d15
X-Proofpoint-ORIG-GUID: _P9ZkWimBNBdfVwAV3mJrxSqWo5a6d15
X-Authority-Analysis: v=2.4 cv=X4dSKHTe c=1 sm=1 tr=0 ts=6840393d cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=RnnUVUEQLhJupq3Ke2AA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDA5MSBTYWx0ZWRfXwP53MNcpGtg6 G4L640dVTTsxnFjMXrZqQT+xljyvfB5WteVweKOJMhu2lnj+UGmrw1GQaq1fMU9iMsC7qkaDEN7 HKx65XdVHAYjzA7p/VztMfHS39VUIRfrFYMLI75v3WhTyv7xmc0Meko5Aw48uYe/Q42juPR7H8e
 Vu/AfGxbADat+OH/9jS6GpWLAxRYaabEohCsoOTVSaMQ1BNA76I9AWnfjX/8/r42EK43m8tbw/S pVsKKOD2kbW9aogqZpMYjBdMyZGu3kZCpvKRKTm7+3lTPNIji/EmtrxrRCWSJWr7Ndr5Fh5pDH6 v41B8ytHhW3ZNFCGqE4oD9ro4KmDEW+CIyzoCFV7C8mpSPcThfmd6iVghFf2aoE7hD7UOdOPcIA
 AoGrJnumstEbERMdaVJJpUl/g6cRYEKFk+QYK5h4VjEeXeadBxkefqVjszAwAYeUxGjfmd5f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_03,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=924 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506040091

On Tue,  3 Jun 2025 15:49:36 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> Kernel user spaces accesses to not exported pages in atomic context
> incorrectly try to resolve the page fault.
> With debug options enabled call traces like this can be seen:
> 
> BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1523
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 419074, name: qemu-system-s39
> preempt_count: 1, expected: 0
> RCU nest depth: 0, expected: 0
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<00000383ea47cfa2>] copy_page_from_iter_atomic+0xa2/0x8a0
> CPU: 12 UID: 0 PID: 419074 Comm: qemu-system-s39
> Tainted: G        W           6.16.0-20250531.rc0.git0.69b3a602feac.63.fc42.s390x+debug #1 PREEMPT
> Tainted: [W]=WARN
> Hardware name: IBM 3931 A01 703 (LPAR)
> Call Trace:
>  [<00000383e990d282>] dump_stack_lvl+0xa2/0xe8
>  [<00000383e99bf152>] __might_resched+0x292/0x2d0
>  [<00000383eaa7c374>] down_read+0x34/0x2d0
>  [<00000383e99432f8>] do_secure_storage_access+0x108/0x360
>  [<00000383eaa724b0>] __do_pgm_check+0x130/0x220
>  [<00000383eaa842e4>] pgm_check_handler+0x114/0x160
>  [<00000383ea47d028>] copy_page_from_iter_atomic+0x128/0x8a0
> ([<00000383ea47d016>] copy_page_from_iter_atomic+0x116/0x8a0)
>  [<00000383e9c45eae>] generic_perform_write+0x16e/0x310
>  [<00000383e9eb87f4>] ext4_buffered_write_iter+0x84/0x160
>  [<00000383e9da0de4>] vfs_write+0x1c4/0x460
>  [<00000383e9da123c>] ksys_write+0x7c/0x100
>  [<00000383eaa7284e>] __do_syscall+0x15e/0x280
>  [<00000383eaa8417e>] system_call+0x6e/0x90
> INFO: lockdep is turned off.
> 
> It is not allowed to take the mmap_lock while in atomic context. Therefore
> handle such a secure storage access fault as if the accessed page is not
> mapped: the uaccess function will return -EFAULT, and the caller has to
> deal with this. Usually this means that the access is retried in process
> context, which allows to resolve the page fault (or in this case export the
> page).
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/mm/fault.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index 3829521450dd..e1ad05bfd28a 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -441,6 +441,8 @@ void do_secure_storage_access(struct pt_regs *regs)
>  		if (rc)
>  			BUG();
>  	} else {
> +		if (faulthandler_disabled())
> +			return handle_fault_error_nolock(regs, 0);
>  		mm = current->mm;
>  		mmap_read_lock(mm);
>  		vma = find_vma(mm, addr);


