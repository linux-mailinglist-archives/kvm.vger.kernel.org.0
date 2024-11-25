Return-Path: <kvm+bounces-32432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A4D409D8545
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 13:18:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 643B128648D
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8FB199947;
	Mon, 25 Nov 2024 12:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lCqf8FOT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511761552E3;
	Mon, 25 Nov 2024 12:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732537118; cv=none; b=IRwIeO4HinoiMcuDpz7C5KWafuk+I1IxtTN57sApE06pnxpkA9jo7f5LxjGV546lqa4Y11R6WfUtU5BIrOxJ/gjTcDd7NPMCpdRc26vQDUFJJzUyw2a18MNmGzCOITjGE+91eMeBRNef/qg4u+6h0WQ9ZJwsNq4/s3v02wFLSOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732537118; c=relaxed/simple;
	bh=rPnECGCtmHOKnSr8XtEgfgHEBwuyCiB9r6c/aIvdhOI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FuhumZ+gHdRqo+rBt61V7vR5CEbphdcMewq4qEGDuibgV5TJauZMDkxWr0SLjsKKwigsik5e/LSLzMAKoCsHt6qo4wBBfxFgE9yLL415KSuyoBIehoiDO8jvElpzaXGtp+yN5EYt2TPDz7C5KtHM9Ulk46F0tDvsAbdDPLN3/sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lCqf8FOT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4APBuua3002007;
	Mon, 25 Nov 2024 12:18:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/ZVYil
	oCOy44xCvooYML2mPZFBGpWkYWq8DFd1i+p5w=; b=lCqf8FOTM8EiXGIa4hvUlr
	GVQLqMgpd4JmWJBLNhsOafKgsvxQVKNz5733Gbkq1SYFguNctnVNcHBNhsiMapnl
	ycrdwpZrIfMKJ8sIKxq70I58QUqN680PusTFCR5Br5+PYOXryotU0C2Bx8lNphxo
	s6A6/xFvLTyl6lDVvFC+z/dW/lSIhkogP6B7yrxs7+vTqelaHmlCUzon4LO8oZdm
	qsmrhdaGReVA005EcJyR0W49PG8BfZ41IG8/CNtoMBB9sVt6nqMgbjFNpMWVEqtg
	6E2dUXgBV2BQoGzZUORs/vFchYRHQgxQDqkF2I7pnniHGiDH7KGn9wyI7Ui2I6Ug
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43387br93t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 12:18:34 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP89fLw025088;
	Mon, 25 Nov 2024 12:18:33 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 433v30tbbd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 12:18:33 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4APCIUmY53150004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 12:18:30 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0BE5120043;
	Mon, 25 Nov 2024 12:18:30 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D4DEF20040;
	Mon, 25 Nov 2024 12:18:29 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Nov 2024 12:18:29 +0000 (GMT)
Date: Mon, 25 Nov 2024 13:18:28 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: s390: Use try_cmpxchg() instead of cmpxchg()
 loops
Message-ID: <20241125131828.6d49ad3f@p-imbrenda>
In-Reply-To: <20241125115039.1809353-2-hca@linux.ibm.com>
References: <20241125115039.1809353-1-hca@linux.ibm.com>
	<20241125115039.1809353-2-hca@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -y2FaxQ8exjqEY4q_PXb8rUlrZzRELcd
X-Proofpoint-ORIG-GUID: -y2FaxQ8exjqEY4q_PXb8rUlrZzRELcd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=712 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411250103

On Mon, 25 Nov 2024 12:50:37 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> Convert all cmpxchg() loops to try_cmpxchg() loops. With gcc 14 and the
> usage of flag output operands in try_cmpxchg() this allows the compiler to
> generate slightly better code.
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Looks straightforward

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/gaccess.c   | 16 ++++++++--------
>  arch/s390/kvm/interrupt.c | 12 ++++++------
>  arch/s390/kvm/kvm-s390.c  |  4 ++--
>  arch/s390/kvm/pci.c       |  5 ++---
>  4 files changed, 18 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index a688351f4ab5..9816b0060fbe 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -129,8 +129,8 @@ static void ipte_lock_simple(struct kvm *kvm)
>  retry:
>  	read_lock(&kvm->arch.sca_lock);
>  	ic = kvm_s390_get_ipte_control(kvm);
> +	old = READ_ONCE(*ic);
>  	do {
> -		old = READ_ONCE(*ic);
>  		if (old.k) {
>  			read_unlock(&kvm->arch.sca_lock);
>  			cond_resched();
> @@ -138,7 +138,7 @@ static void ipte_lock_simple(struct kvm *kvm)
>  		}
>  		new = old;
>  		new.k = 1;
> -	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
> +	} while (!try_cmpxchg(&ic->val, &old.val, new.val));
>  	read_unlock(&kvm->arch.sca_lock);
>  out:
>  	mutex_unlock(&kvm->arch.ipte_mutex);
> @@ -154,11 +154,11 @@ static void ipte_unlock_simple(struct kvm *kvm)
>  		goto out;
>  	read_lock(&kvm->arch.sca_lock);
>  	ic = kvm_s390_get_ipte_control(kvm);
> +	old = READ_ONCE(*ic);
>  	do {
> -		old = READ_ONCE(*ic);
>  		new = old;
>  		new.k = 0;
> -	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
> +	} while (!try_cmpxchg(&ic->val, &old.val, new.val));
>  	read_unlock(&kvm->arch.sca_lock);
>  	wake_up(&kvm->arch.ipte_wq);
>  out:
> @@ -172,8 +172,8 @@ static void ipte_lock_siif(struct kvm *kvm)
>  retry:
>  	read_lock(&kvm->arch.sca_lock);
>  	ic = kvm_s390_get_ipte_control(kvm);
> +	old = READ_ONCE(*ic);
>  	do {
> -		old = READ_ONCE(*ic);
>  		if (old.kg) {
>  			read_unlock(&kvm->arch.sca_lock);
>  			cond_resched();
> @@ -182,7 +182,7 @@ static void ipte_lock_siif(struct kvm *kvm)
>  		new = old;
>  		new.k = 1;
>  		new.kh++;
> -	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
> +	} while (!try_cmpxchg(&ic->val, &old.val, new.val));
>  	read_unlock(&kvm->arch.sca_lock);
>  }
>  
> @@ -192,13 +192,13 @@ static void ipte_unlock_siif(struct kvm *kvm)
>  
>  	read_lock(&kvm->arch.sca_lock);
>  	ic = kvm_s390_get_ipte_control(kvm);
> +	old = READ_ONCE(*ic);
>  	do {
> -		old = READ_ONCE(*ic);
>  		new = old;
>  		new.kh--;
>  		if (!new.kh)
>  			new.k = 0;
> -	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
> +	} while (!try_cmpxchg(&ic->val, &old.val, new.val));
>  	read_unlock(&kvm->arch.sca_lock);
>  	if (!new.kh)
>  		wake_up(&kvm->arch.ipte_wq);
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 4f0e7f61edf7..eff69018cbeb 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -247,12 +247,12 @@ static inline int gisa_set_iam(struct kvm_s390_gisa *gisa, u8 iam)
>  {
>  	u64 word, _word;
>  
> +	word = READ_ONCE(gisa->u64.word[0]);
>  	do {
> -		word = READ_ONCE(gisa->u64.word[0]);
>  		if ((u64)gisa != word >> 32)
>  			return -EBUSY;
>  		_word = (word & ~0xffUL) | iam;
> -	} while (cmpxchg(&gisa->u64.word[0], word, _word) != word);
> +	} while (!try_cmpxchg(&gisa->u64.word[0], &word, _word));
>  
>  	return 0;
>  }
> @@ -270,10 +270,10 @@ static inline void gisa_clear_ipm(struct kvm_s390_gisa *gisa)
>  {
>  	u64 word, _word;
>  
> +	word = READ_ONCE(gisa->u64.word[0]);
>  	do {
> -		word = READ_ONCE(gisa->u64.word[0]);
>  		_word = word & ~(0xffUL << 24);
> -	} while (cmpxchg(&gisa->u64.word[0], word, _word) != word);
> +	} while (!try_cmpxchg(&gisa->u64.word[0], &word, _word));
>  }
>  
>  /**
> @@ -291,14 +291,14 @@ static inline u8 gisa_get_ipm_or_restore_iam(struct kvm_s390_gisa_interrupt *gi)
>  	u8 pending_mask, alert_mask;
>  	u64 word, _word;
>  
> +	word = READ_ONCE(gi->origin->u64.word[0]);
>  	do {
> -		word = READ_ONCE(gi->origin->u64.word[0]);
>  		alert_mask = READ_ONCE(gi->alert.mask);
>  		pending_mask = (u8)(word >> 24) & alert_mask;
>  		if (pending_mask)
>  			return pending_mask;
>  		_word = (word & ~0xffUL) | alert_mask;
> -	} while (cmpxchg(&gi->origin->u64.word[0], word, _word) != word);
> +	} while (!try_cmpxchg(&gi->origin->u64.word[0], &word, _word));
>  
>  	return 0;
>  }
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 442d4a227c0e..d8080c27d45b 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1937,11 +1937,11 @@ static void kvm_s390_update_topology_change_report(struct kvm *kvm, bool val)
>  
>  	read_lock(&kvm->arch.sca_lock);
>  	sca = kvm->arch.sca;
> +	old = READ_ONCE(sca->utility);
>  	do {
> -		old = READ_ONCE(sca->utility);
>  		new = old;
>  		new.mtcr = val;
> -	} while (cmpxchg(&sca->utility.val, old.val, new.val) != old.val);
> +	} while (!try_cmpxchg(&sca->utility.val, &old.val, new.val));
>  	read_unlock(&kvm->arch.sca_lock);
>  }
>  
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index a61518b549f0..9b9e7fdd5380 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -208,13 +208,12 @@ static inline int account_mem(unsigned long nr_pages)
>  
>  	page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>  
> +	cur_pages = atomic_long_read(&user->locked_vm);
>  	do {
> -		cur_pages = atomic_long_read(&user->locked_vm);
>  		new_pages = cur_pages + nr_pages;
>  		if (new_pages > page_limit)
>  			return -ENOMEM;
> -	} while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
> -					new_pages) != cur_pages);
> +	} while (!atomic_long_try_cmpxchg(&user->locked_vm, &cur_pages, new_pages));
>  
>  	atomic64_add(nr_pages, &current->mm->pinned_vm);
>  


