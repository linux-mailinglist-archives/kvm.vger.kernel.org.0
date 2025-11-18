Return-Path: <kvm+bounces-63553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D793C6A48F
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 16:22:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 54A884F5B2B
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 15:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6088364025;
	Tue, 18 Nov 2025 15:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="m+EI8vxC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491EA322DAF;
	Tue, 18 Nov 2025 15:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763478890; cv=none; b=kCdhvmDCl+snjRogPkb1ryNv0nOtlGcOYALL91WA+7eCr3zm6gA0jO9Mi4/SmFMfNtT0JIZb+MOgyleO3QiCxa2DEcw5H6dtJHZIW6BKAEuw1NMmm2GafnwemVolYys/4gBhSLViCdQCN1nRYZheJ9QT1hQ1JILF6ua3qAiRgCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763478890; c=relaxed/simple;
	bh=AEfIUr59wxFkNMNRHcMNbX7sz211ydcLJZKJMtEG4CI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OgKl6qcKyBE/h1yqNe36DuMn0n3mgwMBhkZFw5qe4tgfEYt9i91RTZeg/pQyb1CYoWhQ1UX8157Z+cA+vm9/9L81tT/YsZroEtUKEnXhbFtYGdWTj9yxFGkqEiaWM/KT4p+FbE1GwCqVm1Gvgs7YltI9ivTfbdBQvYtAG2Xq97U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=m+EI8vxC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI5lKw4032671;
	Tue, 18 Nov 2025 15:14:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=zGBMiHcaT/Am1sS6pJV7yC4y2zzZgr
	ltnxEiaH2w0mc=; b=m+EI8vxCzQWWFvz3SimR8094bbgfjVopC125h4sSfSJu9a
	02+0ejXAviHATee2cztxREB5i9t2r3Lz8SJcE32LlNAJ0XZW5yfyLyQFYVUTMRcu
	8gklZvP2ncEfQ/ZURvDJnZBt4KlmPFDmz8ccRcgDeCv9g7biuevcbD5fykJZCpBX
	rVi73/Z1MVRXy0QySW8PDDd/ZNHFqwB7c6IB6wnw3a3d4xQp834YqYgvnKRPsWkh
	a2dTbbnFIjwmAPuJHOdTvLIYH0OjewpbqelqCKaZXqpOvqRanUPRS3oHBfnXqYOn
	cdl6ljkwSMkUt9PBtlLOSTxLrINQ1kEveMSkBe3Q==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejk9uetu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 15:14:45 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AICBhPo005111;
	Tue, 18 Nov 2025 15:14:44 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af5bk3prc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 15:14:44 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AIFEe3r38600964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 15:14:40 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 38E8120043;
	Tue, 18 Nov 2025 15:14:40 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CBAD220040;
	Tue, 18 Nov 2025 15:14:39 +0000 (GMT)
Received: from osiris (unknown [9.155.211.25])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 18 Nov 2025 15:14:39 +0000 (GMT)
Date: Tue, 18 Nov 2025 16:14:38 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v3 18/23] KVM: s390: Switch to new gmap
Message-ID: <20251118151438.9674B91-hca@linux.ibm.com>
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
 <20251106161117.350395-19-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106161117.350395-19-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gk-RbKCf9PXepXFJRcXIhpk3eJWX39lj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXyJ6ETnBnWIDA
 ZLUw48jM+nbX3MwwA+Qqv/0NJokgC1asJr9VrCMSt6W5EAMD0fAgkOPpgHAD2DjBeuTiKc2hktS
 TQjFdbgxqHY8ZVw8dH+0GNWx5bYgVVkjQK+29pMxzwuhV778bVEDFudo47ZWw8MnxGzvCA1JObl
 Ej0fyHlmeo/uYoPQ1Wvteqk39WV2Rst0GtH97Oz6lSvh+agxLEOZDJG34FBIb9tTKJk/9120EOI
 cXyRvLWjVgeRhF2Dm8pmhfxeLgNkek8lrvwVEDpLdLYgtLSq60FcercUXndBQ2syKcc2JxWwQxO
 N+HRJ8h4J9R5HWC/s9jVqGzqih26katVSuL37iwObBG0o+QOpbMR3eTIAiCUhHeHTosn6X9Vzdc
 R/MfovSCR7pgJ3pOZ8mmZR6VxdJcLQ==
X-Proofpoint-ORIG-GUID: gk-RbKCf9PXepXFJRcXIhpk3eJWX39lj
X-Authority-Analysis: v=2.4 cv=XtL3+FF9 c=1 sm=1 tr=0 ts=691c8d65 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=e_HGUXRQ_x7VPZv6sDgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-18_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

On Thu, Nov 06, 2025 at 05:11:12PM +0100, Claudio Imbrenda wrote:
> Switch KVM/s390 to use the new gmap code.
> 
> Remove includes to <gmap.h> and include "gmap.h" instead; fix all the
> existing users of the old gmap functions to use the new ones instead.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/Kconfig                   |   2 +-
>  arch/s390/include/asm/kvm_host.h    |   5 +-
>  arch/s390/include/asm/mmu_context.h |   4 -
>  arch/s390/include/asm/tlb.h         |   3 -
>  arch/s390/kvm/Makefile              |   2 +-
>  arch/s390/kvm/diag.c                |   2 +-
>  arch/s390/kvm/gaccess.c             | 552 +++++++++++----------
>  arch/s390/kvm/gaccess.h             |  16 +-
>  arch/s390/kvm/gmap-vsie.c           | 141 ------
>  arch/s390/kvm/gmap.c                |   6 +-
>  arch/s390/kvm/intercept.c           |  15 +-
>  arch/s390/kvm/interrupt.c           |   2 +-
>  arch/s390/kvm/kvm-s390.c            | 727 ++++++++--------------------
>  arch/s390/kvm/kvm-s390.h            |  20 +-
>  arch/s390/kvm/priv.c                | 207 +++-----
>  arch/s390/kvm/pv.c                  |  64 +--
>  arch/s390/kvm/vsie.c                | 117 +++--
>  arch/s390/mm/gmap_helpers.c         |  29 --
>  18 files changed, 710 insertions(+), 1204 deletions(-)
>  delete mode 100644 arch/s390/kvm/gmap-vsie.c

...

> @@ -389,27 +358,13 @@ static int handle_sske(struct kvm_vcpu *vcpu)
> +		scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
> +			rc = dat_cond_set_storage_key(vcpu->arch.mc, vcpu->arch.gmap->asce,
> +						      gpa_to_gfn(start), key, &oldkey,
> +						      m3 & SSKE_NQ, m3 & SSKE_MR, m3 & SSKE_MC);

...

> @@ -1159,19 +1106,13 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
> +			scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
> +				rc = dat_cond_set_storage_key(vcpu->arch.mc, vcpu->arch.gmap->asce,
> +							      gpa_to_gfn(start), key,
> +							      NULL, nq, mr, mc);

For the above two users I don't see any code which fills the arch.mc
cache reliably. But chances are that I just missed it, since this
patch is huge.

