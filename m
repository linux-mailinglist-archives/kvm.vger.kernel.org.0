Return-Path: <kvm+bounces-733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C4767E2026
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:39:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DF8EB20C24
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:39:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61BF219BA3;
	Mon,  6 Nov 2023 11:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mX5kSS/j"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E62218044
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:39:06 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5623790;
	Mon,  6 Nov 2023 03:39:05 -0800 (PST)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6BAbEu010721;
	Mon, 6 Nov 2023 11:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ICj3P6eMP+Mhk0orSrZ53yS5Wfr4XHPhaF3F54sYrOM=;
 b=mX5kSS/j+e9r9xcwYWOycrYQwjZDfaB2/+Dp3ZNA++IckX68vEk1iPLkHnS6NUqtXJxZ
 RUoVltlOUa1FY6Oyh1yqc1bIKryQasBvjSh4CwvK/Z8OwV/QHbmHED5+AYWOHeXPzgls
 qMvc0L12eGliAuAImKzjEcZpW8l4LpDJIWUFf3HjL+Q5EhcTPMS1Duvjhl6tNjhdLCna
 DESkSkOYr6O2AGmAGud3SVBBNbjopuCosPAkJIn+U9S+Y2fl4Xs2Gri+WhRXAjSTnSTB
 1RjDwhsD0NAH/ibqIqnpE84ZcB4IXGUeSdrO6loxtJOpxiV1nrMkJOY/ulAAn65jVUPR PA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6y1kgr6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 11:39:04 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6BBJGt012423;
	Mon, 6 Nov 2023 11:39:03 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6y1kgr6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 11:39:03 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6AU7ij012854;
	Mon, 6 Nov 2023 11:39:02 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u609sh5tc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 11:39:02 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6BcuPB22610656
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 11:38:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D62262004D;
	Mon,  6 Nov 2023 11:38:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2581F20043;
	Mon,  6 Nov 2023 11:38:56 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.179.20.192])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 11:38:56 +0000 (GMT)
Message-ID: <44148ab315f28a6d77627675cbde26977418c5df.camel@linux.ibm.com>
Subject: Re: [PATCH 4/4] KVM: s390: Minor refactor of base/ext facility lists
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
Date: Mon, 06 Nov 2023 12:38:55 +0100
In-Reply-To: <20231103193254.7deef2e5@p-imbrenda>
References: <20231103173008.630217-1-nsg@linux.ibm.com>
	 <20231103173008.630217-5-nsg@linux.ibm.com>
	 <20231103193254.7deef2e5@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xz2pHqH8C_FeYvL5ILPvGJE9Sk5zAqmE
X-Proofpoint-ORIG-GUID: deMo7KLZ4l95QYWQVAtVOh74LC4Kl66x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_09,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501 spamscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060095

On Fri, 2023-11-03 at 19:32 +0100, Claudio Imbrenda wrote:
> On Fri,  3 Nov 2023 18:30:08 +0100
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> > Directly use the size of the arrays instead of going through the
> > indirection of kvm_s390_fac_size().
> > Don't use magic number for the number of entries in the non hypervisor
> > managed facility bit mask list.
> > Make the constraint of that number on kvm_s390_fac_base obvious.
> > Get rid of implicit double anding of stfle_fac_list.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > ---
> >=20
> >=20
> > I found it confusing before and think it's nicer this way but
> > it might be needless churn.
>=20
> some things are probably overkill

I mostly wanted to get rid of kvm_s390_fac_size() since it's meaning
wasn't all that clear IMO. It's not the size of the host's facility list,
it's not the size of the guest's facility list (same as host right now,
but could be different in the future) it's the size of the arrays.

But like I said, none of it is necessary and while I'm reasonably sure
I didn't break anything, you never know :).

[...]

> >  arch/s390/kvm/kvm-s390.c | 44 +++++++++++++++++-----------------------
> >  1 file changed, 19 insertions(+), 25 deletions(-)
> >=20
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index b3f17e014cab..e00ab2f38c89 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c

[...]

> >  /*
> >   * Extended feature mask. Consists of the defines in FACILITIES_KVM_CP=
UMODEL
> >   * and defines the facilities that can be enabled via a cpu model.
> >   */
> > -static unsigned long kvm_s390_fac_ext[SIZE_INTERNAL] =3D { FACILITIES_=
KVM_CPUMODEL };
> > -
> > -static unsigned long kvm_s390_fac_size(void)
> > -{
> > -	BUILD_BUG_ON(SIZE_INTERNAL > S390_ARCH_FAC_MASK_SIZE_U64);
> > -	BUILD_BUG_ON(SIZE_INTERNAL > S390_ARCH_FAC_LIST_SIZE_U64);
> > -	BUILD_BUG_ON(SIZE_INTERNAL * sizeof(unsigned long) >
> > -		sizeof(stfle_fac_list));
> > -
> > -	return SIZE_INTERNAL;
> > -}
> > +static const unsigned long kvm_s390_fac_ext[] =3D { FACILITIES_KVM_CPU=
MODEL };
>=20
> this was sized to [SIZE_INTERNAL], now it doesn't have a fixed size. is
> this intentional?

Yes, it's as big as it needs to be, that way it cannot be too small, so one
less thing to consider.

[...]
> >  /* available cpu features supported by kvm */
> >  static DECLARE_BITMAP(kvm_s390_available_cpu_feat, KVM_S390_VM_CPU_FEA=
T_NR_BITS);
> > @@ -3341,13 +3333,16 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned =
long type)
> >  	kvm->arch.sie_page2->kvm =3D kvm;
> >  	kvm->arch.model.fac_list =3D kvm->arch.sie_page2->fac_list;
> > =20
> > -	for (i =3D 0; i < kvm_s390_fac_size(); i++) {
> > +	for (i =3D 0; i < ARRAY_SIZE(kvm_s390_fac_base); i++) {
> >  		kvm->arch.model.fac_mask[i] =3D stfle_fac_list[i] &
> > -					      (kvm_s390_fac_base[i] |
> > -					       kvm_s390_fac_ext[i]);
> > +					      kvm_s390_fac_base[i];
> >  		kvm->arch.model.fac_list[i] =3D stfle_fac_list[i] &
> >  					      kvm_s390_fac_base[i];
> >  	}
> > +	for (i =3D 0; i < ARRAY_SIZE(kvm_s390_fac_ext); i++) {
> > +		kvm->arch.model.fac_mask[i] |=3D stfle_fac_list[i] &
> > +					       kvm_s390_fac_ext[i];
> > +	}
>=20
> I like it better when it's all in one place, instead of having two loops

Hmm, it's the result of the arrays being different lengths now.

[...]

> > -	for (i =3D 0; i < 16; i++)
> > -		kvm_s390_fac_base[i] |=3D
> > -			stfle_fac_list[i] & nonhyp_mask(i);
> > +	for (i =3D 0; i < HMFAI_DWORDS; i++)
> > +		kvm_s390_fac_base[i] |=3D nonhyp_mask(i);
>=20
> where did the stfle_fac_list[i] go?

I deleted it. That's what I meant by "Get rid of implicit double
anding of stfle_fac_list".
Besides it being redundant I didn't like it conceptually.
kvm_s390_fac_base specifies the facilities we support, regardless
if they're installed in the configuration. The hypervisor managed
ones are unconditionally declared via FACILITIES_KVM and we can add
the non hypervisor managed ones unconditionally, too.

> >  	r =3D __kvm_s390_init();
> >  	if (r)
>=20


