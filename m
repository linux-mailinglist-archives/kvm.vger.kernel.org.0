Return-Path: <kvm+bounces-739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95A2C7E2128
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 13:18:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50073281451
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D031EB54;
	Mon,  6 Nov 2023 12:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="i5AHHhBn"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ED71EB36
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 12:18:16 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3112710DD;
	Mon,  6 Nov 2023 04:18:14 -0800 (PST)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Bkw2U008679;
	Mon, 6 Nov 2023 12:18:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=n1HCNS2C1DIwKMuK9T+3ZhC1Zs59rbEWAeWHmBM+lqw=;
 b=i5AHHhBnIONfmYlm0w/zpnikchMh3ADiH7/S4H+lS3sZrDzcNiJSkFoJuw/Oz8eb9WxL
 53MrMnOPDOVChRktJtMhh6O0EGh/6tEQTMWNt6LhjdzygTeWF/SX+LDNvg3Hs/sf4Fz7
 Q6WT+4Fl+VzABax5a3VhL55Oi4EmdJMWeYcjYYatPzRVT8Ngkzj7MEhjcew5alX2ZUOt
 VLhFHczCFOZ4ZmUNSywxM662PVtD8FwYgNhLBhLW1MNvGdVsfluIjfeHl00iNjtNLQrD
 vX23YBmWaohAPPfAzmbpYvn2YDz3i2ovWuwygV9omZurByskW9QQu4edo8iDXj+SGj1U 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6yjtrwn3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:18:13 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6BlZ8a011477;
	Mon, 6 Nov 2023 12:18:12 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6yjtrwmt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:18:12 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6AbsxW007958;
	Mon, 6 Nov 2023 12:18:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u60ny996j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 12:18:11 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6CI5P614090842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 12:18:05 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BBD492004B;
	Mon,  6 Nov 2023 12:18:05 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 620C620040;
	Mon,  6 Nov 2023 12:18:05 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 12:18:05 +0000 (GMT)
Date: Mon, 6 Nov 2023 13:18:03 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        David
 Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck
 <cornelia.huck@de.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Michael
 Mueller <mimu@linux.vnet.ibm.com>,
        David Hildenbrand
 <dahi@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/4] KVM: s390: Minor refactor of base/ext facility
 lists
Message-ID: <20231106131803.15985f2e@p-imbrenda>
In-Reply-To: <44148ab315f28a6d77627675cbde26977418c5df.camel@linux.ibm.com>
References: <20231103173008.630217-1-nsg@linux.ibm.com>
	<20231103173008.630217-5-nsg@linux.ibm.com>
	<20231103193254.7deef2e5@p-imbrenda>
	<44148ab315f28a6d77627675cbde26977418c5df.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zCB3qCG0MBJbK2Og1pgD2i0QNMNE7wAS
X-Proofpoint-ORIG-GUID: VNPB-bMD6Dt-6lDqQztXxZ7bqmVTtsQx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_10,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=773 clxscore=1015
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310240000 definitions=main-2311060100

On Mon, 06 Nov 2023 12:38:55 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

[...]

> > this was sized to [SIZE_INTERNAL], now it doesn't have a fixed size. is
> > this intentional?  
> 
> Yes, it's as big as it needs to be, that way it cannot be too small, so one
> less thing to consider.

fair enough
 
> [...]
> > >  /* available cpu features supported by kvm */
> > >  static DECLARE_BITMAP(kvm_s390_available_cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
> > > @@ -3341,13 +3333,16 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> > >  	kvm->arch.sie_page2->kvm = kvm;
> > >  	kvm->arch.model.fac_list = kvm->arch.sie_page2->fac_list;
> > >  
> > > -	for (i = 0; i < kvm_s390_fac_size(); i++) {
> > > +	for (i = 0; i < ARRAY_SIZE(kvm_s390_fac_base); i++) {
> > >  		kvm->arch.model.fac_mask[i] = stfle_fac_list[i] &
> > > -					      (kvm_s390_fac_base[i] |
> > > -					       kvm_s390_fac_ext[i]);
> > > +					      kvm_s390_fac_base[i];
> > >  		kvm->arch.model.fac_list[i] = stfle_fac_list[i] &
> > >  					      kvm_s390_fac_base[i];
> > >  	}
> > > +	for (i = 0; i < ARRAY_SIZE(kvm_s390_fac_ext); i++) {
> > > +		kvm->arch.model.fac_mask[i] |= stfle_fac_list[i] &
> > > +					       kvm_s390_fac_ext[i];
> > > +	}  
> > 
> > I like it better when it's all in one place, instead of having two loops  
> 
> Hmm, it's the result of the arrays being different lengths now.

ah, I had missed that, the names are very similar.

> 
> [...]
> 
> > > -	for (i = 0; i < 16; i++)
> > > -		kvm_s390_fac_base[i] |=
> > > -			stfle_fac_list[i] & nonhyp_mask(i);
> > > +	for (i = 0; i < HMFAI_DWORDS; i++)
> > > +		kvm_s390_fac_base[i] |= nonhyp_mask(i);  
> > 
> > where did the stfle_fac_list[i] go?  
> 
> I deleted it. That's what I meant by "Get rid of implicit double
> anding of stfle_fac_list".
> Besides it being redundant I didn't like it conceptually.
> kvm_s390_fac_base specifies the facilities we support, regardless
> if they're installed in the configuration. The hypervisor managed
> ones are unconditionally declared via FACILITIES_KVM and we can add
> the non hypervisor managed ones unconditionally, too.

makes sense

> 
> > >  	r = __kvm_s390_init();
> > >  	if (r)  
> >   
> 


