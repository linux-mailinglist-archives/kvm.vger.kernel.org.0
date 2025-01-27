Return-Path: <kvm+bounces-36642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85B74A1D1E9
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 09:07:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2840164141
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 08:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44A0186E40;
	Mon, 27 Jan 2025 08:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gas5TQC1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605F918EA2;
	Mon, 27 Jan 2025 08:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737965219; cv=none; b=O/pJHcmO6BB5+xVDBflFrRlQ8yceMlyAy3YqUwl2BlCiVgigwj+FNcckpBAYlut/Lqc8FAmjKXpk+TpSmja/UjJTkfN8N9A966P+KyxrNS6C0EGS+OtLdBbM4L1IHNYSPsB+4kvPGnQ2eFvz8f0NnxANIPwR0rR7u6MnUOAQG04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737965219; c=relaxed/simple;
	bh=Ff2RtQ4+RbjeGlcamSEmb7A2L2iA/+pCmCYh4YnmJDY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:Subject:From:
	 References:In-Reply-To; b=qgsBx6xHY7fKWpXwBGQda+h3WHKueZm9qqJ3lpSALKvjBZUwomAc/U5dpkN6ZgKvbg6Wzu2ZsA/fF97KdCpbp30h7XOLxqeTW3pNIrrNmRr/hP4LU8JhGXfosJODJVhg7fUxdIrJH+JRC/6SSjz5r8Uci7v1PGCIkug2xkBRyZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gas5TQC1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50R7kVHX001416;
	Mon, 27 Jan 2025 08:06:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=TMK7IN
	AnhVDUuZrvF3OJrWH2+39fjKMCS76Fh6CA84k=; b=gas5TQC1tfxUqGa+o+OEDZ
	NH2TG4muPytIgO7JUg9w5RTBGohRvph404rDvAtq8hvro7cGgmdoVbdpLRjEJBaH
	/pI0IRCR/UfcxlxRkaKnCgJwJ/+C9QkwITO5Br3IRvRG0rG6ra77ClsqAjRqcBXu
	aL3vB9hheqoBcXQhZU02duuKDVFQnhrCpMrkUPElv/ejMoRVqu7HRv68obv6V05e
	T7Cxr25CuVPSouQc0li3W0twVyF+TEUZXz040d4VZAuk9J5iPd6oLovGCZOjCEII
	ACOYzmnVWILm/zLYJZbofN/BzX3vDjLyAkC70CGdM8TRriz4igMHmURRdWQy46Fw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44dqvt2n52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 08:06:50 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50R86onJ030875;
	Mon, 27 Jan 2025 08:06:50 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44dqvt2n4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 08:06:50 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50R4PfRn022538;
	Mon, 27 Jan 2025 08:06:49 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44dcgjd2ns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 08:06:49 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50R86kRj33423774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 08:06:46 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F1F21200D2;
	Mon, 27 Jan 2025 08:06:45 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BEC35200CA;
	Mon, 27 Jan 2025 08:06:45 +0000 (GMT)
Received: from darkmoore (unknown [9.171.61.145])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Jan 2025 08:06:45 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 27 Jan 2025 09:06:40 +0100
Message-Id: <D7CP8UX2YCH5.2XFSVMPTJOBMA@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>, <pbonzini@redhat.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 05/15] KVM: s390: move pv gmap functions into kvm
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
X-Mailer: aerc 0.18.2
References: <20250123144627.312456-1-imbrenda@linux.ibm.com>
 <20250123144627.312456-6-imbrenda@linux.ibm.com>
In-Reply-To: <20250123144627.312456-6-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wLdUZP9zFrB38pCMn-smEJCGX7PgcL4D
X-Proofpoint-GUID: 5fxDwRe3xGwhbpyVVOxt9ryWvBwhNMKj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_03,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=697 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501270063

With below nit fixed:

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>


On Thu Jan 23, 2025 at 3:46 PM CET, Claudio Imbrenda wrote:
> Move gmap related functions from kernel/uv into kvm.
>
> Create a new file to collect gmap-related functions.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/gmap.h |   1 +
>  arch/s390/include/asm/uv.h   |   6 +-
>  arch/s390/kernel/uv.c        | 292 ++++-------------------------------
>  arch/s390/kvm/Makefile       |   2 +-
>  arch/s390/kvm/gmap.c         | 209 +++++++++++++++++++++++++
>  arch/s390/kvm/gmap.h         |  17 ++
>  arch/s390/kvm/intercept.c    |   1 +
>  arch/s390/kvm/kvm-s390.c     |   1 +
>  arch/s390/kvm/pv.c           |   1 +
>  arch/s390/mm/gmap.c          |  28 ++++
>  10 files changed, 291 insertions(+), 267 deletions(-)
>  create mode 100644 arch/s390/kvm/gmap.c
>  create mode 100644 arch/s390/kvm/gmap.h

[...]

> +int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
> +{
> +	struct kvm *kvm =3D gmap->private;
> +	struct page *page;
> +	int rc =3D 0;
> +
> +	mmap_read_lock(gmap->mm);
> +	scoped_guard(srcu, &kvm->srcu) {
> +		page =3D gfn_to_page(kvm, gpa_to_gfn(gaddr));
> +	}

nit: brackets are not desired for single line block

> +	if (page)
> +		rc =3D __gmap_make_secure(gmap, page, uvcb);
> +	kvm_release_page_clean(page);
> +	mmap_read_unlock(gmap->mm);
> +
> +	return rc;
> +}

[...]


