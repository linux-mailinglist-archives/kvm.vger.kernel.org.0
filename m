Return-Path: <kvm+bounces-8364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 900AC84E8C1
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 20:13:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C27DD1C29A95
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 19:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F1236121;
	Thu,  8 Feb 2024 19:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CRplLCjc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21CD360BA;
	Thu,  8 Feb 2024 19:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707419604; cv=none; b=M9Q92Qnp9b0tsGubilfV1tXkjwwpZTPWwgNVe6v5mE9a/c1f4n/OKJC1FZgmcHqPaVuat4TGOaziVmz8VJE450aythAWWYiWZlJkWaXtqSp91j94g0zSX7pP6RYJWPPZGTHP0c4viaAKhX51IZOhmVxlvH9KY7FR/S9qzbuRQH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707419604; c=relaxed/simple;
	bh=xMH9wuIcCLzlHGTirrlExygw0vEwucUhP0MkSoknnmA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lmWopj0NHKSVshaY6jFvx3MjxJLwK6ypklhRkZx7CAqco6sjM8Vqe7ZY/Yrlba8hux7s6yBBp9Az7QI2K0j257noTteJZo6uvZH7VCtAn8yu0dvXqFdPSS4A7DKobOw8hr3Vr6ZHM+WVHrJWQNKZoy5CatgTkhV3dYaPAaJsWKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CRplLCjc; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418IEgqF018519;
	Thu, 8 Feb 2024 19:13:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=xMH9wuIcCLzlHGTirrlExygw0vEwucUhP0MkSoknnmA=;
 b=CRplLCjck8YCGnmn3B9FJXY1Iu+z/14gl1tX94PZtviJeazjS4xoVZf2/H9vGbQ8avmY
 WKfVtD2G3s4eq99ApMmYM8BwlY0+WsgQro3d6XYyBbTMDSn9mgfYZVme4aSNFqZ703tn
 iM7pxjuaaRlqbyGZQwCt8G8Lyl6bVthk0GzfppVzJuT65k07PpjpYLp+SC5gBgOHKKhz
 Mr++xzzE/ljNsQlIP31gUGifDaK2rlffs9DafPDj4AYEMPv4ylWhCitUG7j+aLuUr6Zg
 GJ30JQEq4AtM4g+TsNBhHcsj3/6heILjgnyV6wUq7NJA4nhQUiugTrAdT/9so6fQdPYm bw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w53vx9jva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Feb 2024 19:13:21 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 418IEgpl018568;
	Thu, 8 Feb 2024 19:13:21 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w53vx9jur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Feb 2024 19:13:21 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 418HUb6B014865;
	Thu, 8 Feb 2024 19:13:20 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3w20tp6kqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Feb 2024 19:13:20 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 418JDIRN36045198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Feb 2024 19:13:19 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B028F5805D;
	Thu,  8 Feb 2024 19:13:18 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 32B3058057;
	Thu,  8 Feb 2024 19:13:18 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.186.237])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  8 Feb 2024 19:13:18 +0000 (GMT)
Message-ID: <6d2f157b432036d614eeb34525a538667e1fbd34.camel@linux.ibm.com>
Subject: Re: [RFC PATCH] KVM: s390: remove extra copy of access registers
 into KVM_RUN
From: Eric Farman <farman@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger
	 <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand
	 <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Date: Thu, 08 Feb 2024 14:13:17 -0500
In-Reply-To: <62f09f2b-ce42-4a80-9c46-3ed351b22d67@linux.ibm.com>
References: <20240131205832.2179029-1-farman@linux.ibm.com>
	 <62f09f2b-ce42-4a80-9c46-3ed351b22d67@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 (3.50.3-1.fc39) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MHCHYHS-Awb-FWAk9Yw-nhltq_2gN_fr
X-Proofpoint-ORIG-GUID: 6NEz_oSs4FOymZXTZ3XHjLXKOlq2QmH_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_08,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=721 adultscore=0
 spamscore=0 suspectscore=0 clxscore=1015 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402080101

On Thu, 2024-02-08 at 13:39 +0100, Janosch Frank wrote:
> On 1/31/24 21:58, Eric Farman wrote:
> > The routine ar_translation() is called by get_vcpu_asce(), which is
> > called from a handful of places, such as an interception that is
> > being handled during KVM_RUN processing. In that case, the access
> > registers of the vcpu had been saved to a host_acrs struct and then
> > the guest access registers loaded from the KVM_RUN struct prior to
> > entering SIE. Saving them back to KVM_RUN at this point doesn't do
> > any harm, since it will be done again at the end of the KVM_RUN
> > loop when the host access registers are restored.
> >=20
> > But that's not the only path into this code. The MEM_OP ioctl can
> > be used while specifying an access register, and will arrive here.
> >=20
> > Linux itself doesn't use the access registers for much, but it does
> > squirrel the thread local storage variable into ACRs 0 and 1 in
> > copy_thread() [1]. This means that the MEM_OP ioctl may copy
> > non-zero access registers (the upper- and lower-halves of the TLS
> > pointer) to the KVM_RUN struct, which will end up getting
> > propogated
> > to the guest once KVM_RUN ioctls occur. Since these are almost
> > certainly invalid as far as an ALET goes, an ALET Specification
> > Exception would be triggered if it were attempted to be used.
> >=20
> >=20
>=20
> Would you be able to come up with a kvm-unit-test to verify a fix and
> for regression? Hmmm, maybe a kselftest would be even easier.
>=20

Sure thing. I had started down the kselftest path as there's already
some building blocks there, but got distracted by some other things in
that space that were puzzling me. Will dig that branch back out.

