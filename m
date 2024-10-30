Return-Path: <kvm+bounces-30067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DE4C9B6A8D
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 18:14:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 243A0B22CCD
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 17:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16ABC218595;
	Wed, 30 Oct 2024 17:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NBeN2iH4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4480D1BD9F5;
	Wed, 30 Oct 2024 17:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730307872; cv=none; b=Zk90IYIbFGQP8eY+IWRDfcMaJoSmWpk2L6hyXSs63xlS9lNQ/cibcKYFTvElPQI+iyULH9aA+yPnXMNLhtT/bOCyIUdQsynYFNi71k5ES5Xs2MqG0MnpRnRZEB46T8kXpnHuR+sXXUh54XI1thWPy9zQiGScrbKV26Fa97LlQUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730307872; c=relaxed/simple;
	bh=FPRK52XV0KpnITMJN+TLYYsaE2jwFTUfuEG4/UqRKBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pNS3JDrFlT8gvp3CTQfWLNB/pfxKC9WZFY6QieHyvVL5fRwmARURlFVUi+OTFuJ/S7+q50D+7HZhEv+wukvY7TQbpSh9jiOKzn2IwA6XNHWFxHntO0GHrW+RStSVnMxJn4cUrAQsrKD6UNFeaYeU09WJmWiDi4/FdFVzKJ/UjcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NBeN2iH4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49UDw8L5013455;
	Wed, 30 Oct 2024 17:04:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=o7Wm/diziBNbkc0jCSm4yxC7c6P5xq
	0Z4y+8Ih/41fg=; b=NBeN2iH4Il8KuDPURNw+kC1goR7HXHCJ/zIHFb7EpF9KR2
	OHulXrQ9O4EkQvZngc/FZm8vjH2LZ7r/Of3Uf5qCj1i6at7r4yQ5RkBc9UuMEfZs
	in1BwelXe2rthWuLWQlkm0RUBQ4VVlipUqedVEWw78/HiImgV74e42VRiV/PEeD4
	/546GaV6Jt08MrR0xT6tUUdRTu2YH1Ec0jXkSmvlw7HlSk8kwed2R4RQvd2pgzxR
	aQeJAjP1Saw8sZ7/o+xm+FMdzXzS+o0ilaoGm551aEvp4EJ5WHaMLjSklPLBXQA8
	+x/1hEFiJ2wLkRu5/LGC9k7LAJL6HvhEgNn5V8qA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42jb65kr2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 17:04:28 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49UFoMtB028211;
	Wed, 30 Oct 2024 17:04:28 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42hb4y12yq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 17:04:28 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49UH4Oxs57868758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 17:04:24 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A55820043;
	Wed, 30 Oct 2024 17:04:24 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5703820040;
	Wed, 30 Oct 2024 17:04:23 +0000 (GMT)
Received: from osiris (unknown [9.171.52.21])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 30 Oct 2024 17:04:23 +0000 (GMT)
Date: Wed, 30 Oct 2024 18:04:21 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com, seiden@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390/kvm: initialize uninitialized flags variable
Message-ID: <20241030170421.8451-A-hca@linux.ibm.com>
References: <20241030161906.85476-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030161906.85476-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8JPGj-7HwIGVZguBViesQBlqTMHOjilC
X-Proofpoint-GUID: 8JPGj-7HwIGVZguBViesQBlqTMHOjilC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=495
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410300131

On Wed, Oct 30, 2024 at 05:19:06PM +0100, Claudio Imbrenda wrote:
> The flags variable was being used uninitialized.
> Initialize it to 0 as expected.
> 
> For some reason neither gcc nor clang reported a warning.
> 
> Fixes: ce2b276ebe51 ("s390/mm/fault: Handle guest-related program interrupts in KVM")
> Reported-by: Janosch Frank <frankja@linux.ibm.com>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks!

