Return-Path: <kvm+bounces-30008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 007EC9B5FB2
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 11:04:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 92AF5B22463
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 10:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF8C1E260C;
	Wed, 30 Oct 2024 10:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WpvEjBLh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F69A194151;
	Wed, 30 Oct 2024 10:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730282678; cv=none; b=KMoPTb+vkgA3Vtkz7ExwIIck9lzgfV1xATLAWQ/zG4IvJmMctYmTRfiipq2Lag5J78/A7QBh8vaphqYrI61QbeM3SNomgV8v32un4Z2MTISxOzZeJAH/Nqt/tLetKMYzM2ykQyvDslskILdFn4lFdAFZuJaaHkC13XTm3w8jEh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730282678; c=relaxed/simple;
	bh=x9327/y0ayjOlDpKWFFxaZgtxDwZhLqHbl7ht1HUnz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qi0pjV3LZL00fTVKIJx3YgxPDoqEJO62xry2+J7SDfUpGJPqVq0eH1mmzZIFMfDBbsAAbQAdp87Rv7j66WGeJFJFG9u8r7iSDVRyqzEWNBSEtk2TfdfyBf1qyUr4rdV5qyTyR/Oy7ad0W5LYsXixdzblBYHXa7XevTtxj3AeqoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WpvEjBLh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U2d2Zd012478;
	Wed, 30 Oct 2024 10:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=z32S3KqoArkKiV5/iHoKdn4+IX63mI
	RttPijudjwk+s=; b=WpvEjBLhEEaq3JqBZ628gSJNXMH+fEq+cwtdowOE5bZcZL
	WyPiUfkuhBLrEbNIM0Kcl6rr5nS8wPXQz7+sx+M/zjcvG6r5W3fOLy2UoOeM9d5o
	lyHayKJd6Uit8qQPOeKYclqe8EMA72rC7sLiHGrxaGaA2S4atpj3G9yNeVFx/F7i
	YFh6dGD6MUmFxsMuxEgUQkX/OIc47esSGDVyVFC2+bv+zA3paZEsT60UCq05MUqH
	U1tH/4KtNXcrDqve2q3ZPnQ2pHDcltma5Q7Zh2cIK1C20kJpPK+1FVCC95tB6y3E
	bfw1TgwakmD2Y78gwD3waZcTpd8v8CIg6773XKIA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42k6gt2uaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 10:04:26 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49UA4PB7003903;
	Wed, 30 Oct 2024 10:04:25 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42k6gt2uak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 10:04:25 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49U7po0N018404;
	Wed, 30 Oct 2024 10:04:24 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42hc8k7dsc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 10:04:24 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49UA4K8336438500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 10:04:20 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF22D20082;
	Wed, 30 Oct 2024 10:04:20 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C1A62007F;
	Wed, 30 Oct 2024 10:04:20 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 30 Oct 2024 10:04:20 +0000 (GMT)
Date: Wed, 30 Oct 2024 11:04:18 +0100
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
        Eric Farman <farman@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
Subject: Re: [PATCH v3 3/7] s390/physmem_info: query diag500(STORAGE LIMIT)
 to support QEMU/KVM memory devices
Message-ID: <20241030100418.6264-I-hca@linux.ibm.com>
References: <20241025141453.1210600-1-david@redhat.com>
 <20241025141453.1210600-4-david@redhat.com>
 <20241030092324.6264-E-hca@linux.ibm.com>
 <35fc960b-0013-4264-93d6-6511d54ab474@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35fc960b-0013-4264-93d6-6511d54ab474@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jMpsSJ9u4VEsnQ5qhNnomQE2ssfMG_fY
X-Proofpoint-ORIG-GUID: qENfN970vDa7Liz-_CUTkjbzzRihWYNV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 clxscore=1015 phishscore=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=593 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410300076

On Wed, Oct 30, 2024 at 10:42:05AM +0100, David Hildenbrand wrote:
> On 30.10.24 10:23, Heiko Carstens wrote:
> > Looks like I couldn't convince you to implement a query subcode.
> 
> Well, you convinced me that it might be useful, but after waiting on
> feedback from the KVM folks ... which didn't happen I moved on. In the cover
> letter I have "No query function for diag500 for now."
> 
> My thinking was that if we go for a query subcode, maybe we'd start "anew"
> with a new diag and use "0=query" like all similar instructions I am aware
> of. And that is then a bigger rework ...
> 
> ... and I am not particularly interested in extra work without a clear
> statement from KVM people what (a) if that work is required and; (b) what it
> should look like.

Yes, it is all good. Let's just move on.

