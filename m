Return-Path: <kvm+bounces-28846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21D4999E0E8
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 10:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DDB71C2104E
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 08:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A4FE18A92A;
	Tue, 15 Oct 2024 08:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="anUFVOvv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986FE1C9B87;
	Tue, 15 Oct 2024 08:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728980525; cv=none; b=ZBSgAFS24tsYQIXvYT0K7KHMqmxWTSxLUEEc7Ac02wKUvcFNEE3SpN9ndP5fdlwofQuVnUdEPVjrjubSn3ZU/Ratoso20bYFKQfb+mHEOM63Nk5e9XRU4/tFcvgOBta8+HX0O59fb/DLheUK1K7G3/UwNYwyv9ecTjn3kTfp0ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728980525; c=relaxed/simple;
	bh=ZyMJa6Jwuka2TO342RkLAb6dF7EpFvQESmiJFUd2SSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oyx9/V5yr/C6AjZZiiFKiHZpSBALJBe3iDf66DWGV3JlVqTkThZ49RnyEd02XtS8zdvZ7mAls4qsrTmOWfn4ZRlsXIKdOS5nUvpQpp221idE2iLT5GrGxQ0QlHNFCgPuI8x6VIkW5Nqgb6I1dOK0HVJjlU67iYtKTqowz6ggtuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=anUFVOvv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F7PlOs027400;
	Tue, 15 Oct 2024 08:21:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=c5lhar7v4eLS49jskAhJTfiKUSi6Am
	BfPG1gKlXciwU=; b=anUFVOvvzBObet737suFF6+eMr94CEC/9Sqz5ahW4205AX
	EwkNqsEyF73bGMJwQl5p78s7HluYc7ZF9rTKACz3eAG/HtvzwQDUOAEV/dAHj7aH
	Gz/B+VKzY9GjviSfgbetNlxdVQRF93NFIAfiSrY2NrC3JP/692+b/eLKNTTCYXdu
	iBqVABhfIcN6FNEhGMFnCwoC1TrdeOzlvyUgDSQEO5ZE3p4kJEe8fKCxupAzpxnr
	wOcfZDhLAVLlV7cWfJ1R5sNwPPuJscXsm3M8/8FPQWcJ/B2hMcHNPkvf9SPlj2q6
	9der7guBj0iBo28mqi8VZKz9ORQy43i0HdhsLNgQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429m0588nk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 08:21:56 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49F8LtqZ015991;
	Tue, 15 Oct 2024 08:21:56 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429m0588nc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 08:21:55 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49F7gvOI027451;
	Tue, 15 Oct 2024 08:21:54 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4283txjsbe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 08:21:54 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49F8LoqK19988858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 08:21:50 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A276120043;
	Tue, 15 Oct 2024 08:21:50 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CE2820040;
	Tue, 15 Oct 2024 08:21:50 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 15 Oct 2024 08:21:49 +0000 (GMT)
Date: Tue, 15 Oct 2024 10:21:48 +0200
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
Message-ID: <20241015082148.7641-B-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-3-david@redhat.com>
 <20241014180410.10447-C-hca@linux.ibm.com>
 <78e8794a-d89f-4ded-b102-afc7cea20d1d@redhat.com>
 <20241015081212.7641-A-hca@linux.ibm.com>
 <8e39522c-2853-4d1f-b5ec-64fabcca968b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e39522c-2853-4d1f-b5ec-64fabcca968b@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 84a_QRz4QyxkwKqhc4fD72zEUsnc0y0v
X-Proofpoint-GUID: oPIUMjN_VobXTVvYRnEV425WV2FcuVkA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxlogscore=398 phishscore=0 spamscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150052

On Tue, Oct 15, 2024 at 10:16:20AM +0200, David Hildenbrand wrote:
> On 15.10.24 10:12, Heiko Carstens wrote:
> > On Mon, Oct 14, 2024 at 09:35:27PM +0200, David Hildenbrand wrote:
> > > On 14.10.24 20:04, Heiko Carstens wrote:
> > "If only there would be a query subcode available, so that the program
> > check handling would not be necessary; but in particular my new subcode
> > is not worth adding it" :)
> > 
> > Anyway, I do not care too much.
> > 
> 
> Okay, I see your point: it would allow for removing the program check
> handling from the STORAGE LIMIT invocation.
> 
> ... if only we wouldn't need the exact same program check handling for the
> new query subfunction :P

Yeah yeah, but I think you got that this might help in the future.

