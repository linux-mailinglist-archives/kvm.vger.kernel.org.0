Return-Path: <kvm+bounces-32436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 546799D869C
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:38:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A48928B363
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 13:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B0461AF0A4;
	Mon, 25 Nov 2024 13:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ojX6Tomq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70721A7275;
	Mon, 25 Nov 2024 13:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732541886; cv=none; b=S2n5xpVU++ZAVr0zvejM/1MZSC5PbqHVE3ZwKxV02lrCvcfkzD7YjA83LfRu/mbrblmRYC8M4TgvgBXUxUkleavfmaKfUTVLFS1IIIaETg2gsSEEyqPvvOLS9h7HjHF4wVBZj6uL/1SrclsHjnCCR3WKHVA9LeMdFg2Vn5cwu88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732541886; c=relaxed/simple;
	bh=UNc4TCLY1t3suxw3+Bgtvo1JMK8tsT9LQtmXTBpyIew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jURZRoMmk63MFAjInohdk6g4Xvu9sqrJxlsrQuamBx8jUdemgPBAYKenLopPxorBRilpkBHWD1GpvT++P7ddFM4XbhVxOBMxAU570ETZ5kqG2fHGjJGNxO+3ikibZME6NZhCoiwmwUQO/TvhTAWIgWcgFEUi+csK0mgLzuvhUEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ojX6Tomq; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4APCZFM1021731;
	Mon, 25 Nov 2024 13:38:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=LEsQ1C6OjR6pPGI2zXW5XqwepzfHfL
	RTb5loFVC9Ofc=; b=ojX6Tomq6gh79Kzq2saHlb7jRyv6MV6u+OI2wuSBtanyez
	Xm9aN1fFLoNRVizDtdo9//6T8Zgp0i3DPfNdaWcD+EDgt1wF4c3486ZxhqzmMMzH
	shadvZxvf6Iw4wDIWvCMBKaf+RzR1ZNXdZZiQtdqQZqTFxsLehGcC42EdOCVwpyR
	/ikMJTTSejdlSisZ1gBerZCoIF9NdLjJGgu+Hkzss44C7bRLndlqVSNK1ky4509f
	tPnofjkFUVOFD0ygdpo3zj6VsKvDY2u91NQdGaATp/icibLkAyDww4Gf3N9J7aog
	nSovWd4uF0lAzKrxqqgW0rFlHKTYzL8RzPvTbdXw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43386jrc7v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 13:38:02 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP5HH1Q002627;
	Mon, 25 Nov 2024 13:38:01 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 433tcmajt4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 13:38:01 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4APDbvXV61866484
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 13:37:57 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 932E120043;
	Mon, 25 Nov 2024 13:37:57 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3251520040;
	Mon, 25 Nov 2024 13:37:57 +0000 (GMT)
Received: from osiris (unknown [9.179.25.253])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 25 Nov 2024 13:37:57 +0000 (GMT)
Date: Mon, 25 Nov 2024 14:37:55 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: s390: Remove one byte cmpxchg() usage
Message-ID: <20241125133755.14417-D-hca@linux.ibm.com>
References: <20241125115039.1809353-1-hca@linux.ibm.com>
 <20241125115039.1809353-3-hca@linux.ibm.com>
 <20241125131617.13be742d@p-imbrenda>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125131617.13be742d@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sgq_zrl2iWWgqKfKqzJZimk0kaIAOyH-
X-Proofpoint-GUID: sgq_zrl2iWWgqKfKqzJZimk0kaIAOyH-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=851 spamscore=0 suspectscore=0 phishscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411250115

On Mon, Nov 25, 2024 at 01:16:17PM +0100, Claudio Imbrenda wrote:
> On Mon, 25 Nov 2024 12:50:38 +0100
> Heiko Carstens <hca@linux.ibm.com> wrote:
> > @@ -128,23 +126,16 @@ static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
> >  		struct esca_block *sca = vcpu->kvm->arch.sca;
> >  		union esca_sigp_ctrl *sigp_ctrl =
> >  			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> > -		union esca_sigp_ctrl old;
> >  
> > -		old = READ_ONCE(*sigp_ctrl);
> > -		expect = old.value;
> > -		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
> > +		WRITE_ONCE(sigp_ctrl->value, 9);
> 
> that's supposed to be a 0, right?

Duh... yes, of course. I added the "9" to better find the corresponding
code in assembly, and obviously forgot to replace it with 0 again.
Thanks for pointing this out!

Strange enough this still worked. Hmm.

