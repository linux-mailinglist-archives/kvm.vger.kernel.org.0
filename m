Return-Path: <kvm+bounces-28860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D73999E175
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 10:47:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2B24B21C4B
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 08:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2BFC1CF28D;
	Tue, 15 Oct 2024 08:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="InFSyYf4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8D9757FC;
	Tue, 15 Oct 2024 08:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728982010; cv=none; b=hbivh35Xe6dzXJKMABKWc42ckFHDnALtyo6VasjsUkQUC3vcyshA19S+gLaQUwGhpC7+W0/0SBunYC99SDQBmDzUtO07pp5YolJmrjiO+SgZ4GssYT0VXJXxBvuIb+v9lu9jNBUEltv3AHmMt4luxKR+LfHKlLSMXOLoHMMyOEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728982010; c=relaxed/simple;
	bh=q9Z4RrNUTo34g9ozTwIEV3B8Ve8Qma2UdhZF9OyGV8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qTkQsJHGnR/0k4+51oVeIhKNwPTqS/TilLnivHJoNBAOG5YOiERM0OWtECNcLXAx4Bq9jhNdWIPtWNQ16Lc7sAtRhQ37VvP0r4Qhvxt2N19cs168yVoaHzNio5KkraawOGqNfgPiNx6Ss8UZy1f8FVhclZ1Wo6v3FrHUI3NUM6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=InFSyYf4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F7teQ3025076;
	Tue, 15 Oct 2024 08:46:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=2O8GnyJm4G3jGvPQJzneXovEocBj+f
	NJloVLUU/yom4=; b=InFSyYf4TD/FUicAQBNVy2EH6YhWbMoFpfM8I7B7t6d8GX
	QkbVvDBgC+YbA02E9/SFuCK9T/7SCecnSUcehBKB9iUwq1DVxXkURcVIgW05EFOR
	jgfVdlU5UAWUuibXdCJyjuI7fYvGvCFzSqalpD6HXWYOp3WUDTKnus12iMV+e5T1
	g1HJGfWmbcYKPZasQA6x/SIZXwf9sJ7qOuaz25k9bxrqqvgBYQuX8MZyNt0U7nGj
	DiKTnpABJpVTlukTR56PIXNX6mWU/UFCcgwDwqCbS3xpyUGV+XnXwYUObXdo+hjY
	HJFdZiRMUs3dA0kVxvjUts30mmxocYe9EMxMJmKg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429me108ap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 08:46:42 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49F8jB4A014163;
	Tue, 15 Oct 2024 08:46:41 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429me108ah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 08:46:41 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49F7TuNN002473;
	Tue, 15 Oct 2024 08:46:40 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284emju4d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 08:46:40 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49F8kbVa25559804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 08:46:37 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E6462004B;
	Tue, 15 Oct 2024 08:46:37 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A47C020040;
	Tue, 15 Oct 2024 08:46:36 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 15 Oct 2024 08:46:36 +0000 (GMT)
Date: Tue, 15 Oct 2024 10:46:34 +0200
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
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 2/7] Documentation: s390-diag.rst: make diag500 a
 generic KVM hypercall
Message-ID: <20241015084634.7641-E-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-3-david@redhat.com>
 <20241014180410.10447-C-hca@linux.ibm.com>
 <78e8794a-d89f-4ded-b102-afc7cea20d1d@redhat.com>
 <20241015081212.7641-A-hca@linux.ibm.com>
 <8e39522c-2853-4d1f-b5ec-64fabcca968b@redhat.com>
 <20241015082148.7641-B-hca@linux.ibm.com>
 <d90566ac-dbe3-486b-bdc7-ece6c2ec6928@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d90566ac-dbe3-486b-bdc7-ece6c2ec6928@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5SQSHlUPWxfh2tLy-cwM-LSq5IpV_QTl
X-Proofpoint-ORIG-GUID: 9aniXcWNp1HHXnm-P4vux2xj9Q6hltgG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=313 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410150056

On Tue, Oct 15, 2024 at 10:32:43AM +0200, David Hildenbrand wrote:
> On 15.10.24 10:21, Heiko Carstens wrote:
> > On Tue, Oct 15, 2024 at 10:16:20AM +0200, David Hildenbrand wrote:
> > > On 15.10.24 10:12, Heiko Carstens wrote:
> > > > On Mon, Oct 14, 2024 at 09:35:27PM +0200, David Hildenbrand wrote:
> > > > > On 14.10.24 20:04, Heiko Carstens wrote:
> > > > "If only there would be a query subcode available, so that the program
> > > > check handling would not be necessary; but in particular my new subcode
> > > > is not worth adding it" :)
> > > > 
> > > > Anyway, I do not care too much.
> > > > 
> > > 
> > > Okay, I see your point: it would allow for removing the program check
> > > handling from the STORAGE LIMIT invocation.
> > > 
> > > ... if only we wouldn't need the exact same program check handling for the
> > > new query subfunction :P
> > 
> > Yeah yeah, but I think you got that this might help in the future.
> 
> Right. Adding it later also doesn't quite help to get rid of the checks
> here, because some user space might implement STORAGE LIMIT without QUERY.

This would only help if the diag500 documentation would state that
implementation of the QUERY subcode is mandatory. That is: for every
new subcode larger than the QUERY subcode QUERY must also exist.

That way we only would have to implement program check handling once,
if a program check happens on QUERY none of the newer subcodes is
available, otherwise the return value would indicate that.

Otherwise this whole excercise would be pointless.

