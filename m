Return-Path: <kvm+bounces-21207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A52A92BD95
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 16:58:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDFD11F21D2C
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 14:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF09819D892;
	Tue,  9 Jul 2024 14:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Iq3ddSGX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1294E19CCE8;
	Tue,  9 Jul 2024 14:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720537043; cv=none; b=bojNvYchhVIyUACd3A4WuTaLBEFkrn0mvd28LTNZpFo8f8KE4Wzk3PurficYRZj0DnsGZguwXLFXAAwdHASLtWFgAKTyYH9lF0i8byTyCvj//W6Pjpj6gF7FfJ54R/BpYP9Q+sMFU7GhClKNf+VjXdC8H00pKsS+Pv0gecEl6DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720537043; c=relaxed/simple;
	bh=WdwMKjFPBFNjPxN6MKagA6dZvwLBADCz1idopeZtbzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CpmnA9cEk7DJd35T961zPU93tkO6nSv403+9OeYmGpGLhioelTzjoQzEIMwNWZwI/m37cYDnKd/to02mUq/f4+a12rZUe+IWwT6DqBDIKglU2/30wuGvSCKEQBSBlo2tSJqjRIVYUt3YMtzg5sO1dnfaMWVuYhpS8MPLX/jc0kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Iq3ddSGX; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469DQk5a024025;
	Tue, 9 Jul 2024 14:57:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=/lzIJVTCuRvpdWI49uaC1epKPy5
	0bVXehmHsdWfr5NQ=; b=Iq3ddSGX238VzVknKY3YrZqKeZi/Jbh+eS4+crQhs80
	Y4z9xJ+z3Vt2ZRUxINB2HIUPrFATinrxDVr7bsKv2EZJtUZSff6DN5gF08p7dStA
	DvuKbzvYh8pg4POgCCgwIP+P2yglXrjKmkrPC7bcVhsjGn/+MkkoY7t4/9CL/MKY
	pTnBT3OtLA49i0XwAWAMQ+hVCOyBwkQZM/ykDkCzOjgR/ZTH+kXPoS0HgGDZFbpN
	R91z38C+7VLbRAegGYLk18CZeO8RXakQ6DUj9etyhc1CPeg1tajvoN57ZkCULFbb
	cAYXuFQQ0JWr2mlLIevVAL2f+e8bQk/0aUZn4mwdq/A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4093258u2e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jul 2024 14:57:20 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 469Eoixa026536;
	Tue, 9 Jul 2024 14:57:19 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4093258u1y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jul 2024 14:57:19 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 469EPBqE024664;
	Tue, 9 Jul 2024 14:53:04 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 407g8u5afv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jul 2024 14:53:04 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 469EqxW332506382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Jul 2024 14:53:01 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1354420071;
	Tue,  9 Jul 2024 14:52:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B3D022006C;
	Tue,  9 Jul 2024 14:52:58 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  9 Jul 2024 14:52:58 +0000 (GMT)
Date: Tue, 9 Jul 2024 16:52:57 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, svens@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seiden@linux.ibm.com, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com
Subject: Re: [PATCH v1 1/2] s390/entry: Pass the asce as parameter to sie64a()
Message-ID: <Zo1OyZnwzuFUksMa@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240703155900.103783-1-imbrenda@linux.ibm.com>
 <20240703155900.103783-2-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703155900.103783-2-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MsS9E6B9fUC2K9ztKTN7fCK1monehg9z
X-Proofpoint-GUID: Xi6sMVGuqcPfnln-HHiB-bNqoiVVYADz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-09_04,2024-07-09_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=759 priorityscore=1501
 malwarescore=0 suspectscore=0 adultscore=0 impostorscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407090097

On Wed, Jul 03, 2024 at 05:58:59PM +0200, Claudio Imbrenda wrote:
> Pass the guest ASCE explicitly as parameter, instead of having sie64a()
> take it from lowcore.
> 
> This removes hidden state from lowcore, and makes things look cleaner.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h   | 7 ++++---
>  arch/s390/include/asm/stacktrace.h | 1 +
>  arch/s390/kernel/asm-offsets.c     | 1 +
>  arch/s390/kernel/entry.S           | 8 +++-----
>  arch/s390/kvm/kvm-s390.c           | 3 ++-
>  arch/s390/kvm/vsie.c               | 2 +-
>  6 files changed, 12 insertions(+), 10 deletions(-)

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>

