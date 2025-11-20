Return-Path: <kvm+bounces-63809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D6D8C72FA6
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 09:54:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EF84E357843
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 08:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0D53148D4;
	Thu, 20 Nov 2025 08:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DT3Ol23/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399653148AE;
	Thu, 20 Nov 2025 08:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763628645; cv=none; b=GGTSjUF5BcaiCcuFtdXs41jhOdmW2w0q9CCkQKw6FiMiwEtwtl4+xtZWCTK3i8ywnbyaKcLyAHkX+2TEHM+GKzFZCBcHE+jBBx+BU2ltnPCYNAwk4kqMOaQE0H9HaLajCSyIerHIQeWgbGOzQlZyFhsFrilOq6hucsDkqEFjvXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763628645; c=relaxed/simple;
	bh=r9m00BCpxi9s1JlhTFJ3nfpCzzInN2IR8Ty+omSlfAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mq8VZ8qW2/DGipAR/X1aLXv0Yonc5y/bpnK8w7+mcJI/0eVz2AlXqzK3izex/gvLL4JR+f6SZqaTrHCHfE8vFfA+ufZ3QwdHhgJMV5eg7BpgwbicojOxXxSbfr3pVwayk7KHeF7jtiLHLAsmDSFQgy+F4xIfTlff+QtdTxKtjSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DT3Ol23/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJLksWK002692;
	Thu, 20 Nov 2025 08:50:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=qEFcAPPfFlglQbRaV3NJCjiJABIxA8
	PP2/DHau2Cjoc=; b=DT3Ol23/SIv/iBvCpez5gEmd8jwR1HggK87qCAops1xgFM
	EijNAl491NKtK5y+9I9GO1lrGKaNHQep1VPwN6r+gD86RqOZeRUmBDR092peY0TD
	3cglA1U5EAFRHLfNvudnChC5qeeSc6cOWMdVMHi0eV0RaSJQOuRS9g4T+ltKcFAx
	F0+r/WYRpc2m48IIeshqXSFUVMqPfMBblra1d7VRrVrSEfF9ct/1wrrQZAsWXCTt
	60jm52xtE4XO/gg2XhZ0IeGl+p3Qy2oqDJmGodNeHoEzMEUSJfwCSY1vI0Fnn65S
	2tz7EPSKqw0uryoarhpXy/WB5WWjGii/0zWJkkTQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejju3yxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 08:50:41 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK5lDYo030778;
	Thu, 20 Nov 2025 08:50:40 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af47y5jf8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 08:50:40 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AK8oaPD26476880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 08:50:36 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A15C720043;
	Thu, 20 Nov 2025 08:50:36 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 247ED20040;
	Thu, 20 Nov 2025 08:50:36 +0000 (GMT)
Received: from osiris (unknown [9.155.211.25])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 20 Nov 2025 08:50:36 +0000 (GMT)
Date: Thu, 20 Nov 2025 09:50:33 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v3 08/23] KVM: s390: KVM page table management functions:
 allocation
Message-ID: <20251120085033.8934Bc9-hca@linux.ibm.com>
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
 <20251106161117.350395-9-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106161117.350395-9-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eC7yl3v2lpumsJtxE-xnbltQdi_TGEGg
X-Proofpoint-ORIG-GUID: eC7yl3v2lpumsJtxE-xnbltQdi_TGEGg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX602C2N/Cnt49
 K5c02Daa8oHnD+Q8Vz1YnJ9npi+pN+NSF5Bn7lGFn4xBIbsfBsKfu4k5U/QTnKNbdy+4xQwJvi/
 aGju7cUuuMv4zyvDTfRX0D+W+0U9NiGHHVQAFwwHOOLQq1UOkuVWXHr2vIJivqHahmBKaD6AN44
 UFSW4+aluBh0OUSBUOXwy8QproEV7/PMqSIqwDPcXbJcWJzD5LBNjClJVOGK3hqvRzr1YffEYgw
 tTMfY1dk7jB+KO/upgm6LAUn4EZuV5wDtk04HCSsj603SunOnsWNLjhSfWjk8Vg72YcMsGYALaj
 E6YQSmqyof0oIAgz5meWWkZRyxm3hEykSd8srOprejGq6dUD/mmBOWzoxHr9LPf16oh6BpX4Q2C
 lvAolcaXX8VtrvXkkWQTj94XM+zKoA==
X-Authority-Analysis: v=2.4 cv=SvOdKfO0 c=1 sm=1 tr=0 ts=691ed661 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=4fyli0tk0vq2GYx89EoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 clxscore=1015
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511150032

On Thu, Nov 06, 2025 at 05:11:02PM +0100, Claudio Imbrenda wrote:
> Add page table management functions to be used for KVM guest (gmap)
> page tables.
> 
> This patch adds the boilerplate and functions for the allocation and
> deallocation of DAT tables.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/Makefile     |   1 +
>  arch/s390/kvm/dat.c        | 103 +++++++++++++++++++++++++++++++++++++
>  arch/s390/kvm/dat.h        |  77 +++++++++++++++++++++++++++
>  arch/s390/mm/page-states.c |   1 +
>  4 files changed, 182 insertions(+)
>  create mode 100644 arch/s390/kvm/dat.c

...

> +#define GFP_KVM_S390_MMU_CACHE (GFP_ATOMIC | __GFP_ACCOUNT | __GFP_NOWARN)
> +
> +static inline struct page_table *kvm_s390_mmu_cache_alloc_pt(struct kvm_s390_mmu_cache *mc)
> +{
> +	if (mc->n_pts)
> +		return mc->pts[--mc->n_pts];
> +	return (void *)__get_free_page(GFP_KVM_S390_MMU_CACHE);
> +}
> +
> +static inline struct crst_table *kvm_s390_mmu_cache_alloc_crst(struct kvm_s390_mmu_cache *mc)
> +{
> +	if (mc->n_crsts)
> +		return mc->crsts[--mc->n_crsts];
> +	return (void *)__get_free_pages(GFP_KVM_S390_MMU_CACHE | __GFP_COMP, CRST_ALLOC_ORDER);
> +}
> +
> +static inline struct vsie_rmap *kvm_s390_mmu_cache_alloc_rmap(struct kvm_s390_mmu_cache *mc)
> +{
> +	if (mc->n_rmaps)
> +		return mc->rmaps[--mc->n_rmaps];
> +	return kzalloc(sizeof(struct vsie_rmap), GFP_KVM_S390_MMU_CACHE);
> +}

Given that the fallback allocation (cache empty), may also fail, but unlike
for other architectures also without printing any warning, this might be
difficult to debug, if there is any caller which handles the -ENOMEM case
incorrectly. Maybe it would make sense to save a calltrace (stackdepot?)
whenever that happens, so that in case a guest dies because of incorrect /
missing -ENOMEM handling you have an indication where this happened.

Otherwise you end up scanning the whole code for all users and potential bugs,
just like I did when I reviewed the new allocation paths.

