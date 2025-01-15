Return-Path: <kvm+bounces-35542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B89DA12448
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 13:59:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D1473A7A5E
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 12:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516BD2459BD;
	Wed, 15 Jan 2025 12:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lFYge3Y1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6562459AE;
	Wed, 15 Jan 2025 12:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736945971; cv=none; b=OIMxo/uWYBxo21UHGZOIrIWTLrVPabJhRVYIyZPwkfifx8vZ58pweXMfD5gxxhVep6/SUod4Zb2hnuWh85cr0ToINxYgp+FlrpOpY0hdU0mh6d2X/C/oNCSc280Vo2X+SMhZwMfgL5sVQ9h6tlhOsZJ836Saw3leUamkMuMIjIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736945971; c=relaxed/simple;
	bh=xkMkVD9xk7g36ZYAaxYHK9tMepE396I8mqT5K8M4Efs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bSyQTcOqfr029vgxbGML9iuXkb38xPCZa6Pt2LAUsKePahtPlQZzy5WUo48lN9OO/V07L+JUog/U5rgK0M5ueVFaDZRoBPpMd0V/VbckNbN0nhhucqHT0d53SErkHOYtEY8lnfZlB+x+X9D9VKCSTj6318ze0EM2dSA2xspNUrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lFYge3Y1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FBe01x010168;
	Wed, 15 Jan 2025 12:59:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=B3UHFL
	1hJregBd/uvAz04MN0uEg15IhWrzj10MiMk24=; b=lFYge3Y1WVH0H+hGAC5dG6
	3f+9/CSW6wNbZr3VBTNuzGl8PHOpBhfHXHr+kQhMK8ol1rm1ML6AA2OxHX4yqz/p
	gkKAgLoHGpomxeqQrKYxDgIyfYxRI9NTms5FP8Azend1Ym375d4D9hxyV1wTzusm
	8gzxpAl6TC+WqgLUpTw/afHhW+LB16ipjxdWK9xVKd4r7AGqrv3et+e4N0pvXxhO
	73SEQaBqivSOTMyy6XXpJeyc5Ob0U+s60EtvmQ4rVhJBLSJaEOu5+OnpvkTX0Lj9
	QoMOAj5Pc2LLy4l58G9z6TEiyvw+NNUr+gAr3ZbGcxqlgiBA+abWwegeccW1+OaA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4461rbjt2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 12:59:25 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50FC7KUD016490;
	Wed, 15 Jan 2025 12:59:24 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4445p1r0b0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 12:59:24 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50FCxLNj39518618
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 12:59:21 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EFB9720043;
	Wed, 15 Jan 2025 12:59:20 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE9F120040;
	Wed, 15 Jan 2025 12:59:20 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Jan 2025 12:59:20 +0000 (GMT)
Date: Wed, 15 Jan 2025 13:59:19 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: Re: [PATCH v1 04/13] KVM: s390: move pv gmap functions into kvm
Message-ID: <20250115135919.57fac908@p-imbrenda>
In-Reply-To: <03d91fa8-6f3f-4052-9b03-de28e88f0001@linux.ibm.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
	<20250108181451.74383-5-imbrenda@linux.ibm.com>
	<03d91fa8-6f3f-4052-9b03-de28e88f0001@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mZO8pYyL7fLbHL1uuLpnITA_Mth8_vWK
X-Proofpoint-GUID: mZO8pYyL7fLbHL1uuLpnITA_Mth8_vWK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_05,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=867 adultscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501150099

On Wed, 15 Jan 2025 13:48:47 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

[...]

> > +static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
> > +{
> > +	struct folio *folio = page_folio(page);
> > +	int rc;
> > +
> > +	/*
> > +	 * Secure pages cannot be huge and userspace should not combine both.
> > +	 * In case userspace does it anyway this will result in an -EFAULT for
> > +	 * the unpack. The guest is thus never reaching secure mode. If
> > +	 * userspace is playing dirty tricky with mapping huge pages later  
> 
> s/tricky/tricks/
> 
> But the whole last sentence is a bit iffy.

hmm yes I'll reword it

> 
> > +	 * on this will result in a segmentation fault or in a -EFAULT return
> > +	 * code from the KVM_RUN ioctl.
> > +	 */
> > +	if (folio_test_hugetlb(folio))
> > +		return -EFAULT;
> > +	if (folio_test_large(folio)) {
> > +		mmap_read_unlock(gmap->mm);
> > +		rc = uv_wiggle_folio(folio, true);
> > +		mmap_read_lock(gmap->mm);  
> 
> You could move the unlock to uv_wiggle_folio() and add a 
> mmap_assert_locked() in front.

oh no, I don't want a function that drops a lock that has been acquired
outside of it.

by explicitly dropping and acquiring it, it's obvious what's going on,
and you can easily see that the lock is being dropped and re-acquired.

__gmap_destroy_page() does it, but it's called exactly in one spot,
namely gmap_destroy_page(), which is literally below it.

> 
> At least if you have no other users in upcoming series which don't need 
> the unlock.


