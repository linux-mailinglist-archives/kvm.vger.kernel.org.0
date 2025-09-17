Return-Path: <kvm+bounces-57887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D7AEB7F40C
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:28:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B159E1C82F4E
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:21:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C93298CB7;
	Wed, 17 Sep 2025 13:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UQEdgnCM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA54B2C3253;
	Wed, 17 Sep 2025 13:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115229; cv=none; b=oKG1BftAbBjd+cz+7MZIf0G6FYBSplmI3MamGlnC6ajAhjYtpra0zweGrP5TuBKRnxmN6l9KqqAQaNlSP3DHypZR7DJzeDOJ4nck3TOJgOYGGTRH4z+HXRheTVECq3sQtTRQFzR+5e7Z1cWgMhftxIuP0+3JFoqVsWMhyi6VCVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115229; c=relaxed/simple;
	bh=dznAyfadciuuM8ximwKFL6xvdyA+qLFfYrW+OXUw5jU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pyg0c+TeWbhBy4HnMiL3G1ufBHrHFQa4Mrp7Cchrp5sm2J+KGNeZ4G9GP4/1IKCwC1hetbMFQlkNXqMtAsxS+98IJMQrgHa0WevofTHYa+bC8SVqzzmvEGHXpkrYtopwu59m75WbSYMlXTfIouFt88bPA6Elj9Ri5gD53WCzVTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UQEdgnCM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HABxPc011464;
	Wed, 17 Sep 2025 13:20:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=gfISNXUo10sYa44sE+JEexifau2HSV
	loSw/X179PtZE=; b=UQEdgnCM7pW3XnpYIuW8ECWKZFWXFOrsbpz30Fz7lulGBA
	Mel5ZG6XPnk4g8M5URjq8LNAahSh+s3OjLsuFcvMBx71z0i4KxaKaRfxBjvE1IGE
	BvALBOb+aKEiaBZ8mPO8dkmbrxE4aHNl1EtKFuKNpKnYHKhaftE2Czwz2z4v/oE0
	vdHxSi3Lh0PgN1uHR6Rdd2oUCXD0Z3iXiaJgv/hRWBjNQY5iZUL1wgiQCbAMygHR
	pNSG1NzTo1qWl+PiJZEzg8jvhc8dx8AA1/VSbfpoVrryRC69jFRvByrAEr7K1ZnU
	KRWiRDvC5nMCm7DhwZQBP69EKZ7gkvyW48IuqTHw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4j3wpg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 13:20:24 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HAA8Jq022297;
	Wed, 17 Sep 2025 13:20:23 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kxpsdmt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 13:20:23 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HDKJ7L48955818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 13:20:19 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A283F20043;
	Wed, 17 Sep 2025 13:20:19 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7146620040;
	Wed, 17 Sep 2025 13:20:19 +0000 (GMT)
Received: from osiris (unknown [9.152.212.133])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 17 Sep 2025 13:20:19 +0000 (GMT)
Date: Wed, 17 Sep 2025 15:20:18 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 16/20] KVM: s390: Switch to new gmap
Message-ID: <20250917132018.7515E2d-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-17-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910180746.125776-17-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Qf5mvtbv c=1 sm=1 tr=0 ts=68cab598 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=vaiu-sQmFw16sVCZt7IA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: _fXmE345djO6SEvt1iwAF5NxZRfuHteZ
X-Proofpoint-GUID: _fXmE345djO6SEvt1iwAF5NxZRfuHteZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX7VO1EjGZPcnJ
 m6w6aggFuDmZFwps04xnsgegh9vlZeETeV971SVd1x4EMbCMMNSajzte8h1PRXjLHeZpFCmCg7d
 XGG4HWIhkK9ls18MvOTYsTPMNn39XOV32OV6Vap76E+2k74IB0A3o4FhOkNCqdRlsGfYFraO4vP
 Tn/XadY+VKdkoa/08pm6/qka+vc6JkepO6p5+88dwjAO/CfDxc9+vMxOkNz7AR39asGObVMmS6y
 55IvSfJrZGcNgzpByLl++4/u/t9Lbz7OpmYHEbaVE9QRWHdnyNwZ4zmtNZg0AxhsqW6jsjAKUll
 NEiedkyJ/NUqjNrbSLDhFP1FVnLr4Ao7vF0u66dP3Z45Z1Qodu99f0XR/BWhaYs7JUWOuv+XpEn
 nPyJ/Qgg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Wed, Sep 10, 2025 at 08:07:42PM +0200, Claudio Imbrenda wrote:
> Switch KVM/s390 to use the new gmap code.
> 
> Remove includes to <gmap.h> and include "gmap.h" instead; fix all the
> existing users of the old gmap functions to use the new ones instead.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

...

> -static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
> -				  unsigned long *pgt, int *dat_protection,
> -				  int *fake)
> +static int walk_guest_tables(struct gmap *sg, unsigned long saddr, struct pgtwalk *w, bool wr)
...

> -		if (rfte.i)
> +		if (table.pgd.i)
>  			return PGM_REGION_FIRST_TRANS;
> -		if (rfte.tt != TABLE_TYPE_REGION1)
> +		if (table.pgd.tt != TABLE_TYPE_REGION1)
>  			return PGM_TRANSLATION_SPEC;
> -		if (vaddr.rsx01 < rfte.tf || vaddr.rsx01 > rfte.tl)
> +		if (vaddr.rsx01 < table.pgd.tf || vaddr.rsx01 > table.pgd.tl)
>  			return PGM_REGION_SECOND_TRANS;

This (and other places): this was easy to map 1:1 to the architecture. But
with the change to pgd & friends this is not the case anymore. From my point
of view this is clearly worse compared to before; and I don't see a pressing
need for such a change.

