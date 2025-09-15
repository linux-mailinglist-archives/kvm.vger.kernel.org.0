Return-Path: <kvm+bounces-57565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C288BB578FD
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 547F9188B81B
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F13A2FFDD3;
	Mon, 15 Sep 2025 11:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="e1Yjwpnu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38A6245021;
	Mon, 15 Sep 2025 11:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936999; cv=none; b=CvyXL/gutCyBhaNZg5old+wSJw4SAaK6hTnh2AUWWOR/0W1Nn3wCUOOEnc454E1Ubhr+5iSdAh4n4YSPloFqs7QdSKYgPms4Yikvxk7nMoAMwerj4Rk3V/qVnZhVrIWCJWLFJXF/6/kP1M+JD7WdFzKW111jtRBM1BwkJZ8VPUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936999; c=relaxed/simple;
	bh=uY39ZIzGKEhc4Y9Shm1Y9OktsF+HqLgC73t0zliixo4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KpiwNUxebMnImffTJcOEDDjiONPp8NMZTkQY/DvyLqB0Lkj4qguJeXNMyXb+YjwokHqXCRjt0rSH1Q4KgP54bx3W9Y73sEP7qAu1GiGQo9ivO65SOQMbvSOndniXExFyYu2UOqvEUwq3lH59ZERJX3bJccuNvqwjnIPWJABYwlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=e1Yjwpnu; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F0HHCh013147;
	Mon, 15 Sep 2025 11:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IhGiez
	wY6TmuhJ3QqReDvGXhaQzf+lWZpEzqvsnmMSg=; b=e1YjwpnuDk9wX3JL92Yghk
	EbSehhRGWqku3Om+FvNx4qPvTf77RnrMejI2MOnqgrw8V29ud2dzipCF5iGgxlgd
	SVfeRUkhHn1eygUw/0TecUqxh1PT37ZVXmBxwmm2oU49USLH6O/MhZ5CynsUELV5
	KyUlUXZ0MaMr6hjW9G//VXGB81E0EjQsHpaFuA6TSXFbidMSBpOH9m6foZKWTKWc
	ufk0KAN1IZ2eId2hSx0g+BuC3kzrvV0KYKvZtOVMYpz0YCelpf9eLM+mM8iSQU8h
	kPTdibRBqya/B+aoQG0recKxbhCm+TvXzao9xgsHHMXEFPIUUU8OodMCBQ1BCmdA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 494x1ta0sv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 11:49:55 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58FBHlgq022297;
	Mon, 15 Sep 2025 11:49:54 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kxpe8ev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 11:49:54 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58FBnoeH25887054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 11:49:50 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD78D20043;
	Mon, 15 Sep 2025 11:49:50 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E13CC20040;
	Mon, 15 Sep 2025 11:49:49 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.29.90])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 15 Sep 2025 11:49:49 +0000 (GMT)
Date: Mon, 15 Sep 2025 13:49:43 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 05/20] KVM: s390: Add helper functions for fault
 handling
Message-ID: <20250915134943.315694f2@p-imbrenda>
In-Reply-To: <92285479bc2b97b418b0efe8a52f0711a95cbf36.camel@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-6-imbrenda@linux.ibm.com>
	<92285479bc2b97b418b0efe8a52f0711a95cbf36.camel@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=OMsn3TaB c=1 sm=1 tr=0 ts=68c7fd63 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=0H-RXLddAXZImbQXutMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: g5kMwtBUpmUThfAS9bq3ezVNV4DpYi86
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAwMSBTYWx0ZWRfX2tmvkI4M711Q
 hv5KxR6A/KvDQZabVNSnz4qawSxFaiuT/waU1/3IjoIwHXUQyIUL3Rr3pXWbHOY9TAYN1AOvLmS
 gv/mzkP+aA7wxl93r8XYdI7gPmFrro7td4gBNMvtBM6jL3/1NnAA3SmW9tGneYfslBMqltzyFA9
 qcSlnZ4/AZyvGwtlvV+9T09w/t4GhioTOdaWrCs3irBVPdViCnh4DPLoqjCD6zIygoTDvdpTfhJ
 ta7HIDibFU7j0WHLOxOTDzEcANQ7Qtb/CMw16sR0JtTWxuD0HOOMZhUCK6kUtF6szI9wOyI4mne
 OWZbYBRKhFfxK7oFPO3LhfdqVOOCSJcB+2HYqNH6QgF/Lz7I5ZiSzKD10hWGeZfC0LhnaQaHh+G
 ZLYEiiIk
X-Proofpoint-GUID: g5kMwtBUpmUThfAS9bq3ezVNV4DpYi86
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_05,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130001

On Fri, 12 Sep 2025 19:56:02 +0200
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> On Wed, 2025-09-10 at 20:07 +0200, Claudio Imbrenda wrote:
> > Add some helper functions for handling multiple guest faults at the
> > same time.
> > 
> > This will be needed for VSIE, where a nested guest access also needs to
> > access all the page tables that map it.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/kvm/gaccess.h  | 14 ++++++++++
> >  arch/s390/kvm/kvm-s390.c | 44 +++++++++++++++++++++++++++++++
> >  arch/s390/kvm/kvm-s390.h | 56 ++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 114 insertions(+)
> >   
> [...]
> 
> > diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> > index c44fe0c3a097..dabcf65f58ff 100644
> > --- a/arch/s390/kvm/kvm-s390.h
> > +++ b/arch/s390/kvm/kvm-s390.h
> > @@ -22,6 +22,15 @@
> >   
> [...]
> 
> > +static inline void release_faultin_multiple(struct kvm *kvm, struct guest_fault *guest_faults,
> > +					    int n, bool ignore)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < n; i++) {
> > +		kvm_release_faultin_page(kvm, guest_faults[i].page, ignore,
> > +					 guest_faults[i].write_attempt);
> > +		guest_faults[i].page = NULL;
> > +	}
> > +}
> > +
> > +static inline bool __kvm_s390_multiple_faults_need_retry(struct kvm *kvm, unsigned long seq,
> > +							 struct guest_fault *guest_faults, int n,
> > +							 bool unsafe)  
> 
> The name of the function does not at all suggest that it releases guest pages.
> Can you remove that and use
> 
> if (__kvm_s390_fault_array_needs_retry(...))
> 	release_faultin_array(...);
> 
> in the caller?

yes and no, it would make the caller harder to read, because other
things need to happen too, and it's easier to have a wrapper that takes
care of cleanup.

I can surely give the function a better name, and add some comments; if
you insist, I can also split it as you mentioned above -- if you think
it's more readable after splitting, then so be it

> (I haven't yet looked at those)
> "needs_retry" isn't telling me much right now, either.
> What is being retried and why?

that's the name of the already existing common code function (actually,
the existing function has an even more confusing name)

the whole fault-in needs to be retried; something happened while we
were not holding locks, we don't know what, and the physical address we
want to fault-in might now be incorrect. hence we need to retry

> Comments would not hurt :)

will add some

> 
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < n; i++) {
> > +		if (!guest_faults[i].valid)
> > +			continue;
> > +		if ((unsafe && mmu_invalidate_retry_gfn_unsafe(kvm, seq, guest_faults[i].gfn)) ||
> > +		    (!unsafe && mmu_invalidate_retry_gfn(kvm, seq, guest_faults[i].gfn))) {
> > +			release_faultin_multiple(kvm, guest_faults, n, true);
> > +			return true;
> > +		}
> > +	}
> > +	return false;
> > +}
> > +
> > +static inline int __kvm_s390_faultin_gfn_range(struct kvm *kvm, struct guest_fault *guest_faults,
> > +					       gfn_t start, int n_pages, bool write_attempt)
> > +{
> > +	int i, rc = 0;
> > +
> > +	for (i = 0; !rc && i < n_pages; i++)
> > +		rc = __kvm_s390_faultin_gfn(kvm, guest_faults + i, start + i, write_attempt);
> > +	return rc;
> > +}
> > +
> > +#define release_faultin_array(kvm, array, ignore) \
> > +	release_faultin_multiple(kvm, array, ARRAY_SIZE(array), ignore)
> > +
> > +#define __kvm_s390_fault_array_needs_retry(kvm, seq, array, unsafe) \
> > +	__kvm_s390_multiple_faults_need_retry(kvm, seq, array, ARRAY_SIZE(array), unsafe)
> > +
> >  /* implemented in diag.c */
> >  int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
> >    
> 


