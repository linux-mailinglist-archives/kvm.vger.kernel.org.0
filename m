Return-Path: <kvm+bounces-28804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98B1399D6D4
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 20:54:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD54F1C22A4C
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 18:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ECBF1CACF9;
	Mon, 14 Oct 2024 18:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EU4NiTB0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7AD1C9EDB;
	Mon, 14 Oct 2024 18:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728932037; cv=none; b=ig1Cvfl+Ba0UBrANiCYpRfWFEINLI1X9lHqDlUyQ9HvFHu4hrj83tfpz7CyWRn18Qoypf2TADrI6wSQp69mRSt4Bm310WlXUA5O3qKcOTOTJcQQ8BZl1o0bVKlG9a9JkF4P8yYwiyZtnJDyogmmeJRA+7B0MGUT4oQwYuPtPDsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728932037; c=relaxed/simple;
	bh=Q23Dqecm4rQW4LbmLu/fWqBs/g2VUgntNVy/XHd1CiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U9JymTX31oKHX12ZQB8upF/HYMeMpEH0rW/ufyb8OqHtFa2NNz4CkUUwtxrjCD/1qMvZT3C4gwOlGHdqbHs6KgWqUCaV9XH5uK8dcoBG1f6EZ9PI/2ZG+bWMT/mWPreZk0v7/cQ6RSkGaLEkL1BZGYy+YEocfjnRmEES0w1WDL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EU4NiTB0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EGLr5W024481;
	Mon, 14 Oct 2024 18:53:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=qli9+AqdmrYjqn+I9SUah+tTjB2
	z+FoJZ2DPQzlDrTY=; b=EU4NiTB02AP+nBsUzH3YrsoNJoQJJLvgBgartXQslh/
	VZPgKbRTlO2YMs/6IXykmT3npBElHcFI6m7qKXQfyhxVaTpJDX3bONmGHSNGFqjU
	NmkAuutJkQkf4LyS7jO66DXit5SdyMNuKzU8hexRErSnTdn+t3LcuoHeynuGd38K
	RU7M5wNBM9EGLZA1efsV6JsdKwCg3+eO3+d2IrMmVCJS10TSMtwZb5/JQhkmpucN
	aLTmntYTdHitdYJY132t+Mo0KL8w9tvLpk4Dx9cv7jXP0E9lRb+tlZSCPm+PVtCT
	wrfrx8PSJis4VRLIQBahyPeib6a4smO18I5cMGW0nrw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4296r30nd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:53:48 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49EIrlD7020744;
	Mon, 14 Oct 2024 18:53:47 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4296r30ncy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:53:47 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49EHtfve002408;
	Mon, 14 Oct 2024 18:53:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284emg2ys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:53:45 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49EIrgPS43123138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 18:53:42 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 38CE92004B;
	Mon, 14 Oct 2024 18:53:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A39C20040;
	Mon, 14 Oct 2024 18:53:41 +0000 (GMT)
Received: from osiris (unknown [9.171.66.174])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 14 Oct 2024 18:53:40 +0000 (GMT)
Date: Mon, 14 Oct 2024 20:53:39 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
Subject: Re: [PATCH v2 6/7] lib/Kconfig.debug: default STRICT_DEVMEM to "y"
 on s390
Message-ID: <20241014185339.10447-G-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-7-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014144622.876731-7-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mAW_T_fBPvj4hf4pGvS0idwYV0lYsd3R
X-Proofpoint-GUID: cFbrqvSxhg3gJUt9lCJvsb6mg8EdgPi_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_12,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=457 spamscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410140135

On Mon, Oct 14, 2024 at 04:46:18PM +0200, David Hildenbrand wrote:
> virtio-mem currently depends on !DEVMEM | STRICT_DEVMEM. Let's default
> STRICT_DEVMEM to "y" just like we do for arm64 and x86.
> 
> There could be ways in the future to filter access to virtio-mem device
> memory even without STRICT_DEVMEM, but for now let's just keep it
> simple.
> 
> Tested-by: Mario Casquero <mcasquer@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  lib/Kconfig.debug | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Heiko Carstens <hca@linux.ibm.com>

