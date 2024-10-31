Return-Path: <kvm+bounces-30180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 447959B7B41
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 14:01:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07AB4283909
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 13:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2630119D8BB;
	Thu, 31 Oct 2024 13:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rN06I9Gs"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2305E1993B8;
	Thu, 31 Oct 2024 13:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730379685; cv=none; b=H4ykaCIHHIq7Bd0jR/z8Sz9YUs0/sn6OUL4MsDi61kEGpw2G0EXElWwT4p8g/DCu7QvQpjyAGLGW2AcW0zvDIlPeYUHuJtad8gN46qmQgwush2bqTrUvoM4Cko+BYEOfYqgFrs38Kz8tfKLiEQ56U+oPxVNONHF+OHtAuCXa+s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730379685; c=relaxed/simple;
	bh=rGbfQlvxOIBnio1glGZ6S7OGHst0uidBCoTgBtQWo1A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OjhXwnw7f0/g8Q6SPjlpI3+0MLQ2i6Qo4tB338WpJwKQ71cYMwNNdDP7Q1bWOprOnSvp1a1zfY2NLitVm4B7WZ5UJT3DRDIfyMlUZr/RuB6ODr7ADRFkFu31q51eAoWD6zTH4bssT55re80L89u7yM5iMMI3+BbEcNgV79u+8pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rN06I9Gs; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V3ap61020063;
	Thu, 31 Oct 2024 13:01:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=iCvJ6x
	hDa8zzog4s6D1T+YAvcVnnpjVu/GXqq1D8nbg=; b=rN06I9GsQNT+JAB7kmNpj1
	jtQ6biymaqxqWIUsMnScxnP/KTWPadCZ0o6TzPFfbcC7t8QslLa37byfF66H9AY5
	niTB4wdonEQt3Ec0qYjavkvx4lYB1jlOyPK7vpg+9s+AaATnbzi+qOEcAEW7pWAP
	ErB4O3SjdYBL6nLf5vJFeP7pciYhodSicJE5aBPI/LvVuESGjLpzUYkRAAbi5fB1
	A00VN+hzV9ycqK8sdDqmrv5NYyu0GRCTDY0U4PhY6vgh1hM7IeMEZDpVZXCIxSUW
	leczqOzdfCSwZbLeq792ZvCwVOVRWR9oXzzVDcGNT0EF5bkOBIbpHIFmQHXEh62Q
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42jyhbua9v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 13:01:21 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49VAoiM0024557;
	Thu, 31 Oct 2024 13:01:20 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42hcyjmn65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 13:01:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49VD1HxC52101552
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 13:01:17 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 26F8320040;
	Thu, 31 Oct 2024 13:01:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B44620043;
	Thu, 31 Oct 2024 13:01:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.69.120])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 31 Oct 2024 13:01:16 +0000 (GMT)
Date: Thu, 31 Oct 2024 14:01:13 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com, seiden@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390/kvm: mask extra bits from program interrupt
 code
Message-ID: <20241031140113.4123b8ee@p-imbrenda>
In-Reply-To: <20241031123815.8297-A-hca@linux.ibm.com>
References: <20241031120316.25462-1-imbrenda@linux.ibm.com>
	<20241031123815.8297-A-hca@linux.ibm.com>
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
X-Proofpoint-GUID: HGKRJ_HIWd9C1it-FL5xJoXD30_o_8zU
X-Proofpoint-ORIG-GUID: HGKRJ_HIWd9C1it-FL5xJoXD30_o_8zU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 phishscore=0 impostorscore=0 mlxlogscore=961 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410310099

On Thu, 31 Oct 2024 13:38:15 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Thu, Oct 31, 2024 at 01:03:16PM +0100, Claudio Imbrenda wrote:
> > The program interrupt code has some extra bits that are sometimes set
> > by hardware for various reasons; those bits should be ignored when the
> > program interrupt number is needed for interrupt handling.
> > 
> > Fixes: ce2b276ebe51 ("s390/mm/fault: Handle guest-related program interrupts in KVM")
> > Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 8b3afda99397..f2d1351f6992 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -4737,7 +4737,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
> >  	if (kvm_s390_cur_gmap_fault_is_write())
> >  		flags = FAULT_FLAG_WRITE;
> >  
> > -	switch (current->thread.gmap_int_code) {
> > +	switch (current->thread.gmap_int_code & PGM_INT_CODE_MASK) {  
> 
> Can you give an example? When reviewing your patch I was aware of this, but
> actually thought we do want to know when this happens, since the kernel did
> something which causes such bits to be set; e.g. single stepping with PER
> on the sie instruction. If that happens then such program interruptions
> should not be passed for kvm handling, since that would indicate a host
> kernel bug (the sie instruction is not allowed to be single stepped).
> 
> Or in other words: this should never happen. Of course I might have missed
> something; so when could this happen where this is not a bug and the bits
> should be ignored?

in some cases some guest indication bits might be set when a
host exception happens.

I was also unaware of those and found out the hard way.


