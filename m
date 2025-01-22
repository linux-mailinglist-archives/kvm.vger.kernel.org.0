Return-Path: <kvm+bounces-36242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AAC7A191BA
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 13:50:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEA0D3A40DB
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 12:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F32B212F90;
	Wed, 22 Jan 2025 12:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hhkp1nXl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EE9211A33;
	Wed, 22 Jan 2025 12:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737550246; cv=none; b=aYto8tmHOc17BenC1qq/mhZe0HEmi/AdvgnUJFgDBlJuT/ydLZhLH5YDrX32n6kz06hvfDUbT3jXKwWS7Mk70c46EFJu3Br1VKFNO82/WBeBA2lH7wcHuQ/GD0OI4Hda/GsgFDgfF2EzJGE8uzaUqw9HRUyk5zxVU3qLYr/ecNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737550246; c=relaxed/simple;
	bh=IsYYXgW1N0YF1gsybPl+Wq9x92nBogcFA6StnYnFUPg=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=NrWvWx1OOOA/lPZrHjECCkvITHNyKRbfCnzfmbUFdeHbVEUH3sJJLd9IoMaHP6cc/mrHGOTTMuRX/Vim1kf4BQvttF/9GVzpad8QxCwSSSHYemzDAiy+B9r5Gs2vtdy9r7HWi42efLfBkdicWj4vveQ/CIL07of8r5APo+3VvVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hhkp1nXl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50M7WhAk012551;
	Wed, 22 Jan 2025 12:50:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JUztsG
	8vzjM/cD4pGAeOhlMbvTF/lvr4HDjbW1e8/s4=; b=hhkp1nXl2xc2qZ9EVTziBb
	PlZaMpX73KwdbkuFb8k2djyHAAqyM3LEJE60LqyA0eC94GwyAvGAcV3eali0wPBd
	JCEnIkk5+Po3VThgLimGxu5hoFkLv4FMg6SZ6t1CnegkjzuXijQsxmWlkx/Kx0PD
	wpU8jV/bOq7AtMu01smmSjK2FLD9ejruaGjF0hWyMPXy8y70uJB1K5cwm/AlBiUZ
	uY+FPNTCq0nZAc6G2KOufBp5K1dK0tcXhBNBzRcBigtcKPWkwObyCKvOuuQb11W/
	f2MZdJC7njdtN3cOC/n9qlEuFTs7MA7jo47fPSL1vRItm1kA0N7lVUlH7sSuiu7w
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44avcp1bvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 12:50:38 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50MCjbkw007991;
	Wed, 22 Jan 2025 12:50:38 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44avcp1bv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 12:50:38 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50MBYrg5032274;
	Wed, 22 Jan 2025 12:50:37 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 448rujr54t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 12:50:37 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50MCoYtl57213402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jan 2025 12:50:34 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BD7720049;
	Wed, 22 Jan 2025 12:50:34 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3FD3C20040;
	Wed, 22 Jan 2025 12:50:34 +0000 (GMT)
Received: from darkmoore (unknown [9.155.210.150])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Jan 2025 12:50:34 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 22 Jan 2025 13:50:29 +0100
Message-Id: <D78M5FNORE1Y.1SJAXHNVZS9GL@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 09/15] KVM: s390: move some gmap shadowing functions
 away from mm/gmap.c
X-Mailer: aerc 0.18.2
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
 <20250117190938.93793-10-imbrenda@linux.ibm.com>
In-Reply-To: <20250117190938.93793-10-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: O7JFkylgBfIdAATK2BGziNzHrCOP3hkm
X-Proofpoint-GUID: ewvy0zc-iYfCb0ApTl4QTdAIWcA814K1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-22_05,2025-01-22_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 bulkscore=0 mlxlogscore=958 spamscore=0 phishscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501220093

On Fri Jan 17, 2025 at 8:09 PM CET, Claudio Imbrenda wrote:
> Move some gmap shadowing functions from mm/gmap.c to kvm/kvm-s390.c and
> the newly created kvm/gmap-vsie.c
>
> This is a step toward removing gmap from mm.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/include/asm/gmap.h |   9 +-
>  arch/s390/kvm/Makefile       |   2 +-
>  arch/s390/kvm/gmap-vsie.c    | 142 +++++++++++++++++++++
>  arch/s390/kvm/gmap.h         |  20 +++
>  arch/s390/kvm/kvm-s390.c     |  62 ++++++++-
>  arch/s390/kvm/kvm-s390.h     |   2 +
>  arch/s390/kvm/vsie.c         |   2 +
>  arch/s390/mm/gmap.c          | 238 +++++------------------------------
>  8 files changed, 259 insertions(+), 218 deletions(-)
>  create mode 100644 arch/s390/kvm/gmap-vsie.c
>

[...]

> diff --git a/arch/s390/kvm/gmap-vsie.c b/arch/s390/kvm/gmap-vsie.c
> new file mode 100644
> index 000000000000..90427f114995
> --- /dev/null
> +++ b/arch/s390/kvm/gmap-vsie.c
> @@ -0,0 +1,142 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Guest memory management for KVM/s390 nested VMs.
> + *
> + * Copyright IBM Corp. 2008, 2020, 2024
> + *
> + *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
> + *               Martin Schwidefsky <schwidefsky@de.ibm.com>
> + *               David Hildenbrand <david@redhat.com>
> + *               Janosch Frank <frankja@linux.vnet.ibm.com>
> + */
> +
> +#include <linux/compiler.h>
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <linux/pgtable.h>
> +#include <linux/pagemap.h>
> +#include <linux/mman.h>
> +
> +#include <asm/lowcore.h>
> +#include <asm/gmap.h>
> +#include <asm/uv.h>
> +
> +#include "kvm-s390.h"
> +#include "gmap.h"
> +
> +/**
> + * gmap_find_shadow - find a specific asce in the list of shadow tables
> + * @parent: pointer to the parent gmap
> + * @asce: ASCE for which the shadow table is created
> + * @edat_level: edat level to be used for the shadow translation
> + *
> + * Returns the pointer to a gmap if a shadow table with the given asce i=
s
> + * already available, ERR_PTR(-EAGAIN) if another one is just being crea=
ted,
> + * otherwise NULL
> + */
> +static struct gmap *gmap_find_shadow(struct gmap *parent, unsigned long =
asce,
> +				     int edat_level)
> +{
> +	struct gmap *sg;
> +
> +	list_for_each_entry(sg, &parent->children, list) {
> +		if (sg->orig_asce !=3D asce || sg->edat_level !=3D edat_level ||
> +		    sg->removed)

This is just:

if !gmap_shadow_valid(sg, asce, edat_level)

> +			continue;
> +		if (!sg->initialized)
> +			return ERR_PTR(-EAGAIN);
> +		refcount_inc(&sg->ref_count);
> +		return sg;
> +	}
> +	return NULL;
> +}

[...]

> diff --git a/arch/s390/kvm/gmap.h b/arch/s390/kvm/gmap.h
> index f2b52ce29be3..978f541059f0 100644
> --- a/arch/s390/kvm/gmap.h
> +++ b/arch/s390/kvm/gmap.h
> @@ -13,5 +13,25 @@
>  int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)=
;
>  int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
>  int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
> +struct gmap *gmap_shadow(struct gmap *parent, unsigned long asce, int ed=
at_level);
> +
> +/**
> + * gmap_shadow_valid - check if a shadow guest address space matches the
> + *                     given properties and is still valid
> + * @sg: pointer to the shadow guest address space structure
> + * @asce: ASCE for which the shadow table is requested
> + * @edat_level: edat level to be used for the shadow translation
> + *
> + * Returns 1 if the gmap shadow is still valid and matches the given
> + * properties, the caller can continue using it. Returns 0 otherwise, th=
e
> + * caller has to request a new shadow gmap in this case.
> + *
> + */
> +static inline int gmap_shadow_valid(struct gmap *sg, unsigned long asce,=
 int edat_level)
> +{
> +	if (sg->removed)
> +		return 0;
> +	return sg->orig_asce =3D=3D asce && sg->edat_level =3D=3D edat_level;

This can simply be a single return:

return !sg->removed && sg->orig_asce =3D=3D asce && sg->edat_level =3D=3D e=
dat_level;

> +}
> =20
>  #endif
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index b626c87480ed..482f0968abfa 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4509,6 +4509,63 @@ static bool ibs_enabled(struct kvm_vcpu *vcpu)
>  	return kvm_s390_test_cpuflags(vcpu, CPUSTAT_IBS);
>  }

[...]


