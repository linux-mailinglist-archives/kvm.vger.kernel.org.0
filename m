Return-Path: <kvm+bounces-53979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E028B1B2FA
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:00:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F5D03BA0CE
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 11:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F834262D0C;
	Tue,  5 Aug 2025 11:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bdVLTXvm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD841259CB9;
	Tue,  5 Aug 2025 11:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754395182; cv=none; b=Q3UKFr+3vk2I1b1Xy5DK3eNqdJQAFqRlG7TCy3teRJ3DWmewSRoE3tFc4SwSw9oNAJ+er1p6AoMTW7kXSPS6qvFnqQUwPdjXMuTMd00FUdabckG9oQe0Nl6TGXiQsgUwTbDVwrtZri1DFLFsMlp5ubthnoIE4KSND8RVvtwi8nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754395182; c=relaxed/simple;
	bh=9y2t835x/9yCwwNVrk4m/m3iHjWBH6yRxgRIwXvDjK8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AU0ZCoYjl1tVS9gZUnD/pmTEtIY/UxyRE2zWyHFOT2oHXinltg1R4pgflfB8s6RClSA8dpThEYv0+MSHCa2yZntvQBWz+770yE0PoidgY1kyJve12swf6RmEf1nLg24QJLSA8MycpDuY+BQdNaLr2P3WRQU04HCohhkIwEp6LtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bdVLTXvm; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 575BpKpx001419;
	Tue, 5 Aug 2025 11:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=SJKo6g
	1XjouCbq46KEPHh8y1sxs4mdQJURz9BSU8RLk=; b=bdVLTXvmbhBCAQ8b36hekx
	PiJRKJlTjPB7TtZiCnyWlI/D87Rcnq6A6ve3Qt/aDRZojvvfmxPzFppB/P5voX36
	pRJgQoMNd45aA5OmbyfN7isy0ItOj1A8cuPqQnm/6hl34oqiXw5IS4gFyogY/TW6
	7C3Y1BIrTAt6MX1c/usZceWAiox3Sx+u+Jkx+nhtOO0uDuDMwcq71dqOY7x1j/8/
	4CTCIZWxluk1x62N3gjikX2OJNOzMIlVxsdQZ8sbGeekb5pH4PeuDylZQAwJrw0P
	9QrLNCcHIliFIWNaRSnjLK1We7RF39SDBWEMGI9ZRhIcSjtkxySA//mRMIftKF7g
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48983t6k6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 11:59:38 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5758moEV006810;
	Tue, 5 Aug 2025 11:59:37 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 489xgmj5dd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 11:59:37 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 575BxXwc50397658
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Aug 2025 11:59:33 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 550C02004B;
	Tue,  5 Aug 2025 11:59:33 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E98020049;
	Tue,  5 Aug 2025 11:59:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Aug 2025 11:59:33 +0000 (GMT)
Date: Tue, 5 Aug 2025 13:59:31 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, david@redhat.com, frankja@linux.ibm.com,
        seiden@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, mhartmay@linux.ibm.com
Subject: Re: [PATCH v1 2/2] KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion
Message-ID: <20250805135931.0dbcf0f2@p-imbrenda>
In-Reply-To: <5b0b8d5e-efab-4c5b-be1e-93d8a8f155b3@de.ibm.com>
References: <20250805111446.40937-1-imbrenda@linux.ibm.com>
	<20250805111446.40937-3-imbrenda@linux.ibm.com>
	<5b0b8d5e-efab-4c5b-be1e-93d8a8f155b3@de.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDA4NiBTYWx0ZWRfX8E31I8aytwpE
 j6S7VSAIbKTz0SWsweYOhOwPovtyusbke+DSD2YVpYRyBIyOsztAhIUr1CmPQTBV9MV8PMfimif
 NLfVyuvzr/u1Cy/exxqfzyZlcclwnZFkgp7X/91SSXZJzdshXdq147Me4g0kw5jdR9JMeWs9FkF
 /Mz/LqfYztic8ITAHFHYVNO5hYS9Gctxq5VTvL8r3JN2dflDcpM9tCNeviyZd7mFheK67+CtgEC
 SYe3efxEBV2PfVTxXbLvfw9gRd8KSnomAA14NfAdJhrQ8XZnDrLr3dsA/MHffWk1HRP+blqeRV8
 YPoxCkNFOYlRVuKzTjyKA/BU4s6vUvWHF7M5n+6derKV7PZmQ2hBkBIpR2KoN/21FW3dviEr4eJ
 ufS0Gqvc/QEDgfWP5kPvjBwKzMPg/RNaYAfQVMGRkWaGSsVJk/xj+JwEnBQJkjoywmvaC+vh
X-Proofpoint-GUID: 9EHhLsbnER1ONKRekT8vN5DvEqTSvgpU
X-Proofpoint-ORIG-GUID: 9EHhLsbnER1ONKRekT8vN5DvEqTSvgpU
X-Authority-Analysis: v=2.4 cv=AZSxH2XG c=1 sm=1 tr=0 ts=6891f22a cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=rfCcW7z_6SUoAgKhWwcA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 impostorscore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2508050086

On Tue, 5 Aug 2025 13:44:04 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am 05.08.25 um 13:14 schrieb Claudio Imbrenda:
> > Pass the right type of flag to vcpu_dat_fault_handler(); it expects a
> > FOLL_* flag (in particular FOLL_WRITE), but FAULT_FLAG_WRITE is passed
> > instead.
> > 
> > This still works because they happen to have the same integer value,
> > but it's a mistake, thus the fix.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Fixes: 05066cafa925 ("s390/mm/fault: Handle guest-related program interrupts in KVM")  
> 
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> 
> Shouldnt we rename the parameter to __kvm_s390_handle_dat_fault and
> vcpu_dat_fault_handler from flags to foll as well in their
> implementation and prototypes to keep this consistent?

that's a fair point

a patch in an upcoming series will do that, but I guess I can move that
change here instead.

I'll send a v2 later on today

> 
> > ---
> >   arch/s390/kvm/kvm-s390.c | 8 ++++----
> >   1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index d5ad10791c25..d41d77f2c7cd 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -4954,13 +4954,13 @@ static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, un
> >   
> >   static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
> >   {
> > -	unsigned int flags = 0;
> > +	unsigned int foll = 0;
> >   	unsigned long gaddr;
> >   	int rc;
> >   
> >   	gaddr = current->thread.gmap_teid.addr * PAGE_SIZE;
> >   	if (kvm_s390_cur_gmap_fault_is_write())
> > -		flags = FAULT_FLAG_WRITE;
> > +		foll = FOLL_WRITE;
> >   
> >   	switch (current->thread.gmap_int_code & PGM_INT_CODE_MASK) {
> >   	case 0:
> > @@ -5002,7 +5002,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
> >   			send_sig(SIGSEGV, current, 0);
> >   		if (rc != -ENXIO)
> >   			break;
> > -		flags = FAULT_FLAG_WRITE;
> > +		foll = FOLL_WRITE;
> >   		fallthrough;
> >   	case PGM_PROTECTION:
> >   	case PGM_SEGMENT_TRANSLATION:
> > @@ -5012,7 +5012,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
> >   	case PGM_REGION_SECOND_TRANS:
> >   	case PGM_REGION_THIRD_TRANS:
> >   		kvm_s390_assert_primary_as(vcpu);
> > -		return vcpu_dat_fault_handler(vcpu, gaddr, flags);
> > +		return vcpu_dat_fault_handler(vcpu, gaddr, foll);
> >   	default:
> >   		KVM_BUG(1, vcpu->kvm, "Unexpected program interrupt 0x%x, TEID 0x%016lx",
> >   			current->thread.gmap_int_code, current->thread.gmap_teid.val);  
> 


