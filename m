Return-Path: <kvm+bounces-29266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3C809A6064
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 11:42:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 257BC1C21D97
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 09:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D98FE1E377E;
	Mon, 21 Oct 2024 09:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="R8x4cMH/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A14E1E2832;
	Mon, 21 Oct 2024 09:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729503702; cv=none; b=nAu83kNm731ZbKhzuDuOdWIjOJn5c8kARGkfKcpRGSLqpQsCbi/VGq+3dVFnI2duqgUTH4wfe1jYr09/dr51oKXhuwO38DX5N1pBngzqKfdsVZTzTqVNvJTsCFg8rndpFlWXeuNhj8vxTyzHBxD2InlA85vxlgGg/A5kwvnPc4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729503702; c=relaxed/simple;
	bh=P54tLI5YsgAA8zPPDJIZ/yBTq6jfjUxrUYiQ3cLFdzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TFhAeUURTUrR72lB3xGGJOqmOFNHvWZVvQp06UUjOvKkMYfRlnVIhKL3Nv6nQ1rmsTy4X608BZvbm24nCRsBQuSpwLSjAPld7HXGw/zaGZJdHPzDpq8quyJy2ntSJq41TlNXdOasRcGjXC6WYz1xLb3vK71SfgXb61OBmuHSq4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=R8x4cMH/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49L2L6QB032130;
	Mon, 21 Oct 2024 09:41:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=gppHrh53X6WMLkwMFn96MT3da38sjn
	e7HSCAYAud/+U=; b=R8x4cMH/31KpcjL1SPm1sMbhJFR1aB3OQp0vYpA+nxwLN6
	ZLFYTLS32wfKmJg0JMeEAHn3oUf/Z4d2mAedhDHXY8klVwY2whifCpwAOx1gKsUO
	O+XIruG5kxiMs8zhtMkyRdvynzWP/OpGnx8EkrwyLe/eBqEXCYvsG9Oe+G69wUgF
	WbMi/oiLKoGG0N+7q1iLJCOp503HoTBbNNN7kAPNltETUDjTSY/Lp3ibABKZGHCT
	IWo/QIFJ2htpdVuTfC8uIaGnl2yowqFhgsWJdJW326AuJPAOuDgzSZr3NSt2gsnl
	GEEdR5RDMSJM2QlRVnRbMmUgnkhqPQRx3KQbu0Ig==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5fsqxcw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 09:41:39 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49L87U9l028885;
	Mon, 21 Oct 2024 09:41:39 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42cqfxdp7n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 09:41:39 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49L9fZbv54854130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Oct 2024 09:41:35 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 71AB22004B;
	Mon, 21 Oct 2024 09:41:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D59D82004E;
	Mon, 21 Oct 2024 09:41:34 +0000 (GMT)
Received: from osiris (unknown [9.171.37.192])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 21 Oct 2024 09:41:34 +0000 (GMT)
Date: Mon, 21 Oct 2024 11:41:33 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com, seiden@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 03/11] s390/mm/gmap: Refactor gmap_fault() and add
 support for pfault
Message-ID: <20241021094133.6950-A-hca@linux.ibm.com>
References: <20241015164326.124987-1-imbrenda@linux.ibm.com>
 <20241015164326.124987-4-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015164326.124987-4-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Km2xh2AANfqiAEv46XevX-K-Bi7EIU9s
X-Proofpoint-ORIG-GUID: Km2xh2AANfqiAEv46XevX-K-Bi7EIU9s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 priorityscore=1501
 spamscore=0 mlxlogscore=754 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2410210068

On Tue, Oct 15, 2024 at 06:43:18PM +0200, Claudio Imbrenda wrote:
> When specifying FAULT_FLAG_RETRY_NOWAIT as flag for gmap_fault(), the
> gmap fault will be processed only if it can be resolved quickly and
> without sleeping. This will be needed for pfault.
> 
> Refactor gmap_fault() to improve readability.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  arch/s390/mm/gmap.c | 119 +++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 100 insertions(+), 19 deletions(-)
...

> +static int fixup_user_fault_nowait(struct mm_struct *mm, unsigned long address,
> +				   unsigned int fault_flags, bool *unlocked)
> +{
> +	struct vm_area_struct *vma;
> +	unsigned int test_flags;
> +	vm_fault_t fault;
> +	int rc;
> +
> +	fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
                                                ^^^^^^^^^^^^^^^^^^^^^^^

This is not necessary, because of

> +	if (fault_flags & FAULT_FLAG_RETRY_NOWAIT) {
> +		rc = fixup_user_fault_nowait(gmap->mm, vmaddr, fault_flags, &unlocked);

this.

In any case:
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>

