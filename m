Return-Path: <kvm+bounces-4564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0726F8149B6
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 14:54:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C15A1C23C28
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 13:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ABDE2EB12;
	Fri, 15 Dec 2023 13:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AMVKQCzT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6942E842;
	Fri, 15 Dec 2023 13:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BFDUuJU005205;
	Fri, 15 Dec 2023 13:53:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=qBuhIofhk+Ffb3UwS42Ma/N7XUYiqzaPWWjvryimHlw=;
 b=AMVKQCzT5f+mowrbX8ni3Ph/0oEwLjNusdJVp1vUA9Pl7SWNIXIHqWLEraIAuet+7Bc7
 8nxUQbUCbXpBCUMnFeRSDWmkXt/pwe1uXPEvgHCrnG55MANSf9bc+czQzQm3YZ0J+SXT
 jVLgLfHgFRGggHfwuO16pd3LbPLfLBbVMQyF0GyEfvhq/v1jUH9O5XxLYzAQz6ECLKkP
 pUOFWCI9pNLxrdvSSumSwdhTtOC44a4p1e/gdidVMjVJBy987bHF33ko40Mz2X0G5SdL
 6LKNcrzGY/X6dEwe1Nl79PfzO447xet1W73Pl2Obt254ck68q9tyxpbgbFZLGedCOmfg +w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v0p153gwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 13:53:37 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BFBXTqM013549;
	Fri, 15 Dec 2023 13:53:37 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v0p153gvr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 13:53:36 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BF6rkEM014799;
	Fri, 15 Dec 2023 13:53:36 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uw42kkaqf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 13:53:36 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BFDrXM626149216
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Dec 2023 13:53:33 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC33620043;
	Fri, 15 Dec 2023 13:53:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B3ABB20040;
	Fri, 15 Dec 2023 13:53:32 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 15 Dec 2023 13:53:32 +0000 (GMT)
Date: Fri, 15 Dec 2023 14:53:28 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Nico =?UTF-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        Thomas Huth 
 <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        David
 Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 4/5] s390x: Use library functions for
 snippet exit
Message-ID: <20231215145328.17f5b66e@p-imbrenda>
In-Reply-To: <5996caa1ea76bec45b446fc641237676d9534b3e.camel@linux.ibm.com>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
	<20231213124942.604109-5-nsg@linux.ibm.com>
	<20231213174500.77f3d26f@p-imbrenda>
	<5996caa1ea76bec45b446fc641237676d9534b3e.camel@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: ac1o94PsJrEJBJp6Wo8SMW7uxyWlTXXm
X-Proofpoint-GUID: ia4xyYYv01-vyZ7RavUQeSfokEvIr-9l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-15_08,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 phishscore=0 impostorscore=0 suspectscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312150094

On Fri, 15 Dec 2023 12:50:15 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> On Wed, 2023-12-13 at 17:45 +0100, Claudio Imbrenda wrote:
> > On Wed, 13 Dec 2023 13:49:41 +0100
> > Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
> >   
> > > Replace the existing code for exiting from snippets with the newly
> > > introduced library functionality.
> > > This causes additional report()s, otherwise no change in functionality
> > > intended.
> > > 
> > > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > > ---
> > >  s390x/sie-dat.c            | 10 ++--------
> > >  s390x/snippets/c/sie-dat.c | 19 +------------------
> > >  2 files changed, 3 insertions(+), 26 deletions(-)
> > > 
> > > diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
> > > index 9e60f26e..6b6e6868 100644
> > > --- a/s390x/sie-dat.c
> > > +++ b/s390x/sie-dat.c
> > > @@ -27,23 +27,17 @@ static void test_sie_dat(void)
> > >  	uint64_t test_page_gpa, test_page_hpa;
> > >  	uint8_t *test_page_hva, expected_val;
> > >  	bool contents_match;
> > > -	uint8_t r1;
> > >  
> > >  	/* guest will tell us the guest physical address of the test buffer */
> > >  	sie(&vm);
> > > -	assert(vm.sblk->icptcode == ICPT_INST &&
> > > -	       (vm.sblk->ipa & 0xff00) == 0x8300 && vm.sblk->ipb == 0x9c0000);
> > > -
> > > -	r1 = (vm.sblk->ipa & 0xf0) >> 4;
> > > -	test_page_gpa = vm.save_area.guest.grs[r1];
> > > +	assert(snippet_get_force_exit_value(&vm, &test_page_gpa));  
> > 
> > but the function inside the assert will already report a failure, right?
> > then why the assert? (the point I'm trying to make is that the function  
> 
> The assert makes sense, if it fails something has gone
> completely off the rails. The question is indeed rather if to report.
> There is no harm in it, but I'm thinking now that there should be
> _get_ functions that don't report and optionally also _check_ functions that do.
> 
> So:
> snippet_get_force_exit
> snippet_check_force_exit (exists, but only the _get_ variant is currently required)
> snippet_get_force_exit_value (exists, required)
> snippet_check_force_exit_value (exists, but unused)
> 
> So minimally, we could do:
> snippet_get_force_exit
> snippet_get_force_exit_value
> 
> I'm thinking we should go for the following:
> bool snippet_has_force_exit(...)
> bool snippet_has_force_exit_value(...)
> uint64_t snippet_get_force_exit_value(...) (internally does assert(snippet_has_forced_exit_value))
> void snippet_check_force_exit_value(...) (or whoever needs this in the future adds it)
> (Naming open to suggestions)

I like this.

I would call the bool ones "snippet_is_force_exit", in line with
similar functions. usually "has" is used for capabilities or features.

but I'm open to other suggestions/ideas 

> 
> Then this becomes:
>  	/* guest will tell us the guest physical address of the test buffer */
>  	sie(&vm);
> -	assert(vm.sblk->icptcode == ICPT_INST &&
> -	       (vm.sblk->ipa & 0xff00) == 0x8300 && vm.sblk->ipb == 0x9c0000);
> -
> +	assert(snippet_has_force_exit_value(&vm);
> -	r1 = (vm.sblk->ipa & 0xf0) >> 4;
> -	test_page_gpa = vm.save_area.guest.grs[r1];
> +	test_page_gpa = snippet_get_force_exit_value(&vm);
> 
> > should not report stuff, see my comments in the previous patch)
> >   
> > >  	test_page_hpa = virt_to_pte_phys(guest_root, (void*)test_page_gpa);
> > >  	test_page_hva = __va(test_page_hpa);
> > >  	report_info("test buffer gpa=0x%lx hva=%p", test_page_gpa, test_page_hva);
> > >  
> > >  	/* guest will now write to the test buffer and we verify the contents */
> > >  	sie(&vm);
> > > -	assert(vm.sblk->icptcode == ICPT_INST &&
> > > -	       vm.sblk->ipa == 0x8300 && vm.sblk->ipb == 0x440000);
> > > +	assert(snippet_check_force_exit(&vm));
> > >  
> > >  	contents_match = true;
> > >  	for (unsigned int i = 0; i < GUEST_TEST_PAGE_COUNT; i++) {  
> 
> [...]


