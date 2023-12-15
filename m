Return-Path: <kvm+bounces-4563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 168E88149B4
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 14:53:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CBA71C23D6B
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 13:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E062E2E623;
	Fri, 15 Dec 2023 13:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="itSgg6dx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEE93032A;
	Fri, 15 Dec 2023 13:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BFDWGEi025313;
	Fri, 15 Dec 2023 13:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=H6yZpc3BMnyjSerBunkM1D0tshz0Ql9l+tZ5BE1jz7U=;
 b=itSgg6dxKdJAbYdJMyt8wcGHy0YLmm8BebA2TevejUR4Yhv0GRmjJVtUXky9/644fGmg
 np4sXk3vCs+gS59Hqhdc5M/YPX3/cVjUYcbhsyLMZpC28hA+fCDRzKGxKwN9zE72A1g+
 TY9YuhCal+hp9lfL94oyFWk2OdUnYopukH4qD/IZTWvjOmzLdhTAe0OtbpZevS1/roC7
 TsTEe8CLX2NGf8Tn+diJsmgNcDPs4Czk40nREM0kxhEAuMc5GtWkm6U3QCwSZgzUj3BW
 TbRcC1T9vQUmkyHiAuT2lc/T510Gi/ufZ3MTOSrK52W5CG0KiHIjqoOkrNz801Kqj5Pr 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v0qs1ghrh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 13:53:39 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BFDW9V1025055;
	Fri, 15 Dec 2023 13:53:38 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v0qs1ghr1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 13:53:38 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BFCmb2U013937;
	Fri, 15 Dec 2023 13:53:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uw592qtm7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 13:53:37 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BFDrYvf17302212
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Dec 2023 13:53:34 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 912462004B;
	Fri, 15 Dec 2023 13:53:34 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4FD9420043;
	Fri, 15 Dec 2023 13:53:34 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 15 Dec 2023 13:53:34 +0000 (GMT)
Date: Fri, 15 Dec 2023 13:37:31 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Nico =?UTF-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        Thomas Huth
 <thuth@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Andrew Jones
 <andrew.jones@linux.dev>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 3/5] s390x: Add library functions for
 exiting from snippet
Message-ID: <20231215133731.006e9510@p-imbrenda>
In-Reply-To: <b61da0ed88a86d0823ac26d72f9914a7c392b415.camel@linux.ibm.com>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
	<20231213124942.604109-4-nsg@linux.ibm.com>
	<20231213174222.542e11c6@p-imbrenda>
	<b61da0ed88a86d0823ac26d72f9914a7c392b415.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MlKixnpkNCrhVRvKWt7l4e7Kq-Mxge-9
X-Proofpoint-ORIG-GUID: CgUoHmHXTYlSHrEJeaAQ1C0rAkq9qQ8y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-15_08,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 impostorscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312150094

On Thu, 14 Dec 2023 21:02:53 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> On Wed, 2023-12-13 at 17:42 +0100, Claudio Imbrenda wrote:
> > On Wed, 13 Dec 2023 13:49:40 +0100
> > Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
> >   
> > > It is useful to be able to force an exit to the host from the snippet,
> > > as well as do so while returning a value.
> > > Add this functionality, also add helper functions for the host to check
> > > for an exit and get or check the value.
> > > Use diag 0x44 and 0x9c for this.
> > > Add a guest specific snippet header file and rename the host's.  
> > 
> > you should also mention here that you are splitting snippet.h into a
> > host-only part and a guest-only part  
> 
> Well, I'm not splitting anything. Is it not clear that "the host's"
> refers to snippet.h?
> 
> How about:
> Add a guest specific snippet header file and rename snippet.h to reflect
> that it is host specific.

sounds good

[...]

> > > diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> > > index 40936bd2..908b0130 100644
> > > --- a/lib/s390x/sie.c
> > > +++ b/lib/s390x/sie.c
> > > @@ -42,6 +42,34 @@ void sie_check_validity(struct vm *vm, uint16_t vir_exp)
> > >  	report(vir_exp == vir, "VALIDITY: %x", vir);
> > >  }
> > >  
> > > +bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
> > > +{
> > > +	uint32_t ipb = vm->sblk->ipb;
> > > +	uint64_t code;  
> > 
> > uint64_t code = 0;
> >   
> > > +	uint16_t displace;
> > > +	uint8_t base;
> > > +	bool ret = true;  
> > 
> > bool ret;
> >   
> > > +
> > > +	ret = ret && vm->sblk->icptcode == ICPT_INST;
> > > +	ret = ret && (vm->sblk->ipa & 0xff00) == 0x8300;  
> > 

something like this:

assert(diag == 0x44 || diag == 0x9c);

if (vm->sblk->icptcode != ICPT_INST)
	return false;
if ((vm->sblk->ipa & 0xff00) != 0x8300)
	return false;
if (vm->sblk->ipb & 0xffff)
	return false;

code = ....

return code == diag;

> > ret = vm->sblk->icptcode == ICPT_INST && (vm->sblk->ipa & 0xff00) ==
> > 0x8300;  
> 
> (*) see below
> >   
> > > +	switch (diag) {
> > > +	case 0x44:
> > > +	case 0x9c:
> > > +		ret = ret && !(ipb & 0xffff);
> > > +		ipb >>= 16;
> > > +		displace = ipb & 0xfff;  
> > 
> > maybe it's more readable to avoid shifting thigs around all the time:  
> 
> I don't know, now I gotta be able to do rudimentary arithmetic :D
> I don't really have a preference.
> I wonder if defining a bit field would be worth it.

I think it would.

maybe something like:

union ip_text {
	struct {
		unsigned long ipa:16;
		unsigned long ipb:32;
	};
	struct {
		unsigned long opcode:8;
		...
	};
}

then you can do this at the beginning of the function:

union ip_text ip = { .ipa = vm->sblk->ipa, .ipb = ... };

and then use only the bitfields

[...]

