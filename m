Return-Path: <kvm+bounces-20681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D91BE91C29C
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 17:26:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07B391C211C9
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 15:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516D01C233D;
	Fri, 28 Jun 2024 15:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hzUkfmyS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDDB1E878;
	Fri, 28 Jun 2024 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719588410; cv=none; b=c72nCUaP7nZItKT9V7/Co/hQD0X6dl8ojrtUwN8eDwnry4ngbQGxSBePdxETTkLYSOE7GwfHCIpIbkwUOUVda3uCw1BxsK/SFsZeyJfJahdjRwMLieGqy38fhaU0Yza+lCD955NMYe5uYpH5PaCPdQMW8CyfgUdf94rxqgjAcoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719588410; c=relaxed/simple;
	bh=bOdk9e3ONqASY0ghc4ezQAiv5Knyu/QoY9p3DKOQ+xM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r3O48+vmG7WGhzr/hPB1BGXCM8awYcBEo01wNCWQLxAC+fXK8jsKpoJCo8rmjmfJKSSWUGQcp28AeugpYXph6ApqSI4XK5BKqNX5YjjW3msSkX1U8CEhA0nfT6e/MH0IWlvcruQaG+huq6+SegESwpu+gWLuIOHe0UZ4psNU0+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hzUkfmyS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45SFQlJB032083;
	Fri, 28 Jun 2024 15:26:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	U15gTK2jCnWsIlxP9h9R0Wj2ET/URq9jX8ATEMg3E/g=; b=hzUkfmyS+Nurt3K7
	gA9XfFHounlQI4AO9YV+1eGhWyAZaGUShRHMMbOddtkJZYo+C3nPO7UNl/J//w9j
	wJAKe1hAr6uE+aYw5rDc/svJdmWk/z68ElwoJEljw3FrEIjaLQ2lVXEovWW5F4IR
	gxlK6TTQe70k9DdG/JeqU1VRQh1dv1bO/PDZcXA6D131BjevFhaZafOnwozoKDg3
	1PEFyDmnV144FW1N9/TWNGuN+XfDASciPDSMAjAfo6pfz1XoDg+jrcJB2J4YNgNj
	K1KMIkkyHTQpdHfZ6K5GgfDt9+o6xGnhURZcI6zPHZZ+SVYN7sESe5gsA0l16t+P
	DRGICg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401wn7rdpp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 15:26:46 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45SFQk38032028;
	Fri, 28 Jun 2024 15:26:46 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401wn7rdng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 15:26:46 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45SDsBjV019672;
	Fri, 28 Jun 2024 15:23:06 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yx9xqh1rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 15:23:06 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45SFN0Bf33358406
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jun 2024 15:23:03 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E10622004D;
	Fri, 28 Jun 2024 15:23:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A0D720043;
	Fri, 28 Jun 2024 15:23:00 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 28 Jun 2024 15:23:00 +0000 (GMT)
Date: Fri, 28 Jun 2024 17:22:59 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, KVM <kvm@vger.kernel.org>,
        Janosch
 Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Sven
 Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH 1/1] KVM: s390: fix LPSWEY handling
Message-ID: <20240628172259.1e172f35@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <23e861e2-d184-4367-acc9-3e72c48c3282@linux.ibm.com>
References: <20240627090520.4667-1-borntraeger@linux.ibm.com>
	<20240627095720.8660-D-hca@linux.ibm.com>
	<23e861e2-d184-4367-acc9-3e72c48c3282@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1Mv0SV4VEbo4KrVI7m3F1rElxHrW7nPl
X-Proofpoint-ORIG-GUID: 6HGI77rFZ_rRchE5EORPFAGRPSdmhLyo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-28_10,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxlogscore=830 bulkscore=0 phishscore=0 clxscore=1015
 spamscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406280113

On Fri, 28 Jun 2024 16:53:20 +0200
Christian Borntraeger <borntraeger@linux.ibm.com> wrote:

> Am 27.06.24 um 11:57 schrieb Heiko Carstens:
> > On Thu, Jun 27, 2024 at 11:05:20AM +0200, Christian Borntraeger wrote:  
> >> in rare cases, e.g. for injecting a machine check we do intercept all
> >> load PSW instructions via ICTL_LPSW. With facility 193 a new variant
> >> LPSWEY was added. KVM needs to handle that as well.
> >>
> >> Fixes: a3efa8429266 ("KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196")
> >> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> >> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> >> ---
> >>   arch/s390/include/asm/kvm_host.h |  1 +
> >>   arch/s390/kvm/kvm-s390.c         |  1 +
> >>   arch/s390/kvm/kvm-s390.h         | 16 ++++++++++++++++
> >>   arch/s390/kvm/priv.c             | 32 ++++++++++++++++++++++++++++++++
> >>   4 files changed, 50 insertions(+)  
> > 
> > ...
> >   
> >> +static inline u64 kvm_s390_get_base_disp_siy(struct kvm_vcpu *vcpu, u8 *ar)
> >> +{
> >> +	u32 base1 = vcpu->arch.sie_block->ipb >> 28;
> >> +	u32 disp1 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16) +

long disp1 = ... 

> >> +			((vcpu->arch.sie_block->ipb & 0xff00) << 4);
> >> +
> >> +	/* The displacement is a 20bit _SIGNED_ value */
> >> +	if (disp1 & 0x80000)
> >> +		disp1+=0xfff00000;

disp1 = sign_extend64(disp1, 20);

> >> +
> >> +	if (ar)
> >> +		*ar = base1;
> >> +
> >> +	return (base1 ? vcpu->run->s.regs.gprs[base1] : 0) + (long)(int)disp1;

+ disp1;

> >> +}  
> > 
> > You may want to use sign_extend32() or sign_extend64() instead of open-coding.  
> 
> Something like sign_extend64(disp1, 31)
> I actually find that harder to read, but I am open for other opinions.

I think what he meant is what I wrote above, but it doesn't matter too
much.


with or without the above improvements:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

