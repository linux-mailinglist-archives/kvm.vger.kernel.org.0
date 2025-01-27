Return-Path: <kvm+bounces-36648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62A39A1D3AB
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 10:41:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B15251614C7
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 09:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F26C1FDA92;
	Mon, 27 Jan 2025 09:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EAaVhcaC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1349D1FCFC5;
	Mon, 27 Jan 2025 09:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737970853; cv=none; b=AyG4TIfdxH9VuFHqY9ElRBoVvWTX5AqPifRTYV3e8DnT4iHa+j8fjNaT0TB/WbTv7P4uvwyMqoC/ssGVfAR4Gl3WA77QVk5z+bv86jxqK8YSnskDJV2pPMOipKCuC1Bd3adUqVeCfwF4P61tSkilimZ25jESI4jmRcWPlEJC5iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737970853; c=relaxed/simple;
	bh=dgWx2Hzc92QK11spezyLJ8wBBaJw2ORyZZyUnSp/uw4=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=rSPn+At5putR7UUOSfmFXSr2lx2M3kOUd/+BpyEJgd2FA5IXTUQJMGD3ddHQuKgnDR6zdCotDqo+zgFoS2KfP5/7mt9VI1Kn9T9KeAZmacFzjp8LCqVh4yXqJb0xFLHWiKQjhbxVSaAF+u7odrJ8kVnPXxnpRcYsBuAeV4yj95k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EAaVhcaC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50R19GOE002161;
	Mon, 27 Jan 2025 09:40:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VsPdhj
	EohFr0KzdSdacg9uFiDy0HnrBAcuwOJAAL0wM=; b=EAaVhcaC2XZwf8u4BJtIFB
	hUTqTnE9Ad05JoVb5lSew3U3YIH+FlbiVUUB+7ucNO38tPAbNmLYdc3ZHK7vvZla
	gAPZ1t2e8JJKiYU7Es9lRC2Mm8N7oJGDKdhMdZnrwlIf8uEJRfl3mdq/IKzoLQ5y
	1z9mUW/B1d3cWP7VHAQhVPie2+PS5AdpyJjSeqZmsLuJPesqFRSKjgN0qouM1dhe
	dC/gmGUveohMynwhQ45mdrJElUa6WK4DX9YQEwGQU39v8IF+C9DXRqnRIskl3Eic
	v1lhPRdB15NFBRPN8fxrO+phFM5B20sFGtvIUIZSA/yTIdc02dYbftl2GmmX3/gg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44e0799w72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:40:47 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50R9XxPX007113;
	Mon, 27 Jan 2025 09:40:47 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44e0799w6w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:40:47 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50R93Wio022193;
	Mon, 27 Jan 2025 09:40:46 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44dcgjdc7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:40:46 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50R9egBm51511652
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 09:40:42 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D8B8220203;
	Mon, 27 Jan 2025 09:17:04 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6A5120202;
	Mon, 27 Jan 2025 09:17:04 +0000 (GMT)
Received: from darkmoore (unknown [9.171.61.145])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Jan 2025 09:17:04 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 27 Jan 2025 10:16:59 +0100
Message-Id: <D7CQQP1ENKYJ.2C55CHLY61X32@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>, <pbonzini@redhat.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 09/15] KVM: s390: move some gmap shadowing functions
 away from mm/gmap.c
X-Mailer: aerc 0.18.2
References: <20250123144627.312456-1-imbrenda@linux.ibm.com>
 <20250123144627.312456-10-imbrenda@linux.ibm.com>
In-Reply-To: <20250123144627.312456-10-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: b8AT9km_wiSbJRT9UFMvP8dvwvxVwLNZ
X-Proofpoint-GUID: ceic0BWmU4H3PaDL4d3U5m2ooIqBXEwQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_04,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=762 mlxscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501270076

LGTM, but maybe add some more comments about the required locks?

On Thu Jan 23, 2025 at 3:46 PM CET, Claudio Imbrenda wrote:
> Move some gmap shadowing functions from mm/gmap.c to kvm/kvm-s390.c and
> the newly created kvm/gmap-vsie.c
>
> This is a step toward removing gmap from mm.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/include/asm/gmap.h |   9 +-
>  arch/s390/kvm/Makefile       |   2 +-
>  arch/s390/kvm/gmap-vsie.c    | 139 ++++++++++++++++++++
>  arch/s390/kvm/gmap.h         |  20 +++
>  arch/s390/kvm/kvm-s390.c     |  62 ++++++++-
>  arch/s390/kvm/kvm-s390.h     |   2 +
>  arch/s390/kvm/vsie.c         |   2 +
>  arch/s390/mm/gmap.c          | 238 +++++------------------------------
>  8 files changed, 256 insertions(+), 218 deletions(-)
>  create mode 100644 arch/s390/kvm/gmap-vsie.c

[...]

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

nit: Called with parent->shadow_lock

> + */
> +static struct gmap *gmap_find_shadow(struct gmap *parent, unsigned long =
asce, int edat_level)
> +{
> +	struct gmap *sg;
> +
> +	list_for_each_entry(sg, &parent->children, list) {
> +		if (!gmap_shadow_valid(sg, asce, edat_level))
> +			continue;
> +		if (!sg->initialized)
> +			return ERR_PTR(-EAGAIN);
> +		refcount_inc(&sg->ref_count);
> +		return sg;
> +	}
> +	return NULL;
> +}

[...]

nit: add comment:

Called with vcpu->kvm->srcu and vcpu->arch.gmap->mm in read

> +int __kvm_s390_mprotect_many(struct gmap *gmap, gpa_t gpa, u8 npages, un=
signed int prot,
> +			     unsigned long bits)
> +{
> +	unsigned int fault_flag =3D (prot & PROT_WRITE) ? FAULT_FLAG_WRITE : 0;
> +	gpa_t end =3D gpa + npages * PAGE_SIZE;
> +	int rc;
> +
> +	for (; gpa < end; gpa =3D ALIGN(gpa + 1, rc)) {
> +		rc =3D gmap_protect_one(gmap, gpa, prot, bits);
> +		if (rc =3D=3D -EAGAIN) {
> +			__kvm_s390_fixup_fault_sync(gmap, gpa, fault_flag);
> +			rc =3D gmap_protect_one(gmap, gpa, prot, bits);
> +		}
> +		if (rc < 0)
> +			return rc;
> +	}
> +
> +	return 0;
> +}

[...]


