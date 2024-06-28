Return-Path: <kvm+bounces-20679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48B1891C202
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 17:03:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 792DC1C2359E
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 15:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EE481C2304;
	Fri, 28 Jun 2024 15:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JOWrDo4A"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292321BE852;
	Fri, 28 Jun 2024 15:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719586974; cv=none; b=VC/WWS2CWBJUmCuIHFcvmyaa4GcEeIFGS+FR2r3iIiywIfDS1OVY/U1F9RZw3BrozfVu9RpxKj4ZwLPrARlvAe23vCPt1Rcpt7/ihmFruXClkMoqWdwEpfmKyNHC8tqEpQ7nub6VQ9ayW/mMym2IgJ+IxGQxpDRVzkgbq5O5/Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719586974; c=relaxed/simple;
	bh=h8CENfX13icOCM1isIZvTQ8Bz2u9DqrZABF2hfOTApY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y1jPtYFm9LYa1AeYGzXDpmwd8bvyMJPOmP2CzhHJd1fQ+wo/t8x1+1wGzpyw2O2Tae+mVVl9NiCGv99n7n5KlTva7TYCGVGY01e0VskEGoTk9CzcRLAtZ9NBwWL5329EApCd/OWtNolqa9j3Zqlr3FAq46+mG3ClYk9wdNyCIFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JOWrDo4A; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45SDujGa005501;
	Fri, 28 Jun 2024 15:02:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=LDdy16kwG34SwvPav3SPj5P8e/C
	6w+di8NbkikVkXMc=; b=JOWrDo4AVPozqJvYRq9pgaZu8+aA3PmkqO6IZX/4MJ9
	3jhKmsKn8NYD7UfdxA+RgUOP4WPO1pfzVhdL9DvtMhCdarAjtsLClI2sqEcn8v1W
	hhHF4Juzk4QPfOblzrhItyJxMfgz4Ow5fh4YEU39Q6QTfNWZTbsk11/d8NBgbXKN
	LEydb86ZqBadZFHnbkQuy93DKvQy6cF0wMpEG1ziNUP+JdPYOlRGjBS7+TDioLEL
	5vuNBMtssuNssHGLK0O9oTiH+Q0fOmlawa931KPMyBzBMnMXCJ0DOorcXZrh1AzC
	BhOnAhssV0lZdgrR/GE0yCefsmPq5Tvj2cNxPBzkURg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401vtrrd7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 15:02:50 +0000 (GMT)
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45SF2oK3006321;
	Fri, 28 Jun 2024 15:02:50 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401vtrrd7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 15:02:50 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45SE8aOC000674;
	Fri, 28 Jun 2024 15:02:49 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yxaengu65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 15:02:49 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45SF2hU754264130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jun 2024 15:02:45 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 811A220063;
	Fri, 28 Jun 2024 15:02:43 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D2EBA2004F;
	Fri, 28 Jun 2024 15:02:42 +0000 (GMT)
Received: from osiris (unknown [9.171.26.144])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 28 Jun 2024 15:02:42 +0000 (GMT)
Date: Fri, 28 Jun 2024 17:02:41 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH 1/1] KVM: s390: fix LPSWEY handling
Message-ID: <20240628150241.14360-H-hca@linux.ibm.com>
References: <20240627090520.4667-1-borntraeger@linux.ibm.com>
 <20240627095720.8660-D-hca@linux.ibm.com>
 <23e861e2-d184-4367-acc9-3e72c48c3282@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23e861e2-d184-4367-acc9-3e72c48c3282@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: N7cfRYhJ6QfCCK1Q389XJAVAk2MqRGH5
X-Proofpoint-GUID: 6ga52a4ELBoomtmblpEoiozbtt1cQdVj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-28_10,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0 impostorscore=0
 mlxlogscore=382 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2406140001 definitions=main-2406280111

On Fri, Jun 28, 2024 at 04:53:20PM +0200, Christian Borntraeger wrote:
> > > +static inline u64 kvm_s390_get_base_disp_siy(struct kvm_vcpu *vcpu, u8 *ar)
> > > +{
> > > +	u32 base1 = vcpu->arch.sie_block->ipb >> 28;
> > > +	u32 disp1 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16) +
> > > +			((vcpu->arch.sie_block->ipb & 0xff00) << 4);
> > > +
> > > +	/* The displacement is a 20bit _SIGNED_ value */
> > > +	if (disp1 & 0x80000)
> > > +		disp1+=0xfff00000;
> > > +
> > > +	if (ar)
> > > +		*ar = base1;
> > > +
> > > +	return (base1 ? vcpu->run->s.regs.gprs[base1] : 0) + (long)(int)disp1;
> > > +}
> > 
> > You may want to use sign_extend32() or sign_extend64() instead of open-coding.
> 
> Something like sign_extend64(disp1, 31)
> I actually find that harder to read, but I am open for other opinions.

Feel free to ignore my suggestion. It was just a comment that this
helper exists. If you prefer the open-coded variant then that's fine
too of course.

