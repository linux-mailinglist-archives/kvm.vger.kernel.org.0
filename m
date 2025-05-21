Return-Path: <kvm+bounces-47296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1BABABFB2A
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 18:26:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E90DC1BA41D7
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 16:26:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B166A22CBC6;
	Wed, 21 May 2025 16:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ByYw0sTw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9D21E3769;
	Wed, 21 May 2025 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747844784; cv=none; b=fCV3ElM4IEgPZWzQ9BY27W1XqPp2rYuf2MKLQw68nZI3lKquvDjkeSOZa8rLETHhSZBp1QAGAvfmPPd8kdumhxnSe0Aeyj2evC2r08Pv3p/o8qIL0Zo3d4NJ+ITpIgvOcROyHXloLactJ+djXbSOiatCTNbn2RtAAQ0AVJch/c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747844784; c=relaxed/simple;
	bh=hJjThYydaCbJ7sV83f5nKFkvwJhkaPeXGcV4fO8cxq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h+/53PPFbUjLFCrf3pJf94wWEGoBiqCHA/KDbeqI7PakbpesRJfWILBEgsUZveV/VCS1vmUd5tMm2GNzWHE7HkvGewww41iZPckzry36SEblDptcbFaarArJX8rWUbcDlyh/fjh0pEjGEECR9sQzvGhyIwlvg6V9kH/t+PEZl3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ByYw0sTw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54LGK2Ua001532;
	Wed, 21 May 2025 16:26:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=2kosc1Hmo6Ti93DyTQXntsRImPFT4o
	qQzpEN6IuwiJo=; b=ByYw0sTwEf5CADp2X/fsU/DyssxXoxZ8OR6hhBBBg6bGOq
	LN+WVGiPm6JDx+0ZMTC8ztnrBslrZpwZHXn/LHQ0QxpfGGJ5GIsOgxMA3WOCMopp
	wxtgxk5ruP6rR2Yj8gWo2bvbqV7+Mmg8qDm5Z+14AvwHj9eOspdonQqzuCaNTeCj
	oWIEsaO8DAUwlNGfcLjJKl5ht0XGFeDl314cnmnRYtcsPBJTtH67pzqd4Llf2VpF
	uJOUalZ2NibxffmYa563s/xo2tkJiq2VB/JAHvgTSG0/Tsl28mcUUVDwmPsGARIp
	7EKu7e597Vf3Kov9vVc8/oFi/0spAYpYqj2HeI8g==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46s9estvc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 16:26:20 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54LDpXVq015487;
	Wed, 21 May 2025 16:26:19 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnnd0rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 16:26:19 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54LGQFXS35390202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 16:26:16 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D47812004E;
	Wed, 21 May 2025 16:26:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B8C020043;
	Wed, 21 May 2025 16:26:15 +0000 (GMT)
Received: from osiris (unknown [9.87.128.135])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 21 May 2025 16:26:15 +0000 (GMT)
Date: Wed, 21 May 2025 18:26:13 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com, schlameuss@linux.ibm.com
Subject: Re: [PATCH v2 4/5] KVM: s390: refactor and split some gmap helpers
Message-ID: <20250521162613.11483E44-hca@linux.ibm.com>
References: <20250520182639.80013-1-imbrenda@linux.ibm.com>
 <20250520182639.80013-5-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520182639.80013-5-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDE1OCBTYWx0ZWRfX7JC2r/fkkVEN h0WtDtFfRn/tOciv2j9Z5FdoEOHxNQmMrSbrwk9fsGaEIS+kUrofuX7a9I0DImzOo52aiPPmoLn 1t3jD+Ek1m9+nX4T6HUv5VNm5n+QHf500kLXYdbwG8zJlNl768HO0JEQ5EtfxIPc/2pKhxLTE1A
 pMpj2orX7I70nI24vLTm0Rl4htukIYudpGNLpWyfB5wJ7t/kcaQNzD38Uj5QtbUTVfJyyB+VEiX yx6tDKnnaj1HUpr+1ZylaHtkiDXWiuIjULoAXwyh97NsCD5n2Nnj60lrebSMs1i1H/vbw77I8Om 2T0OkmM3vQasqncwTkclXQ4sfavB40JRLtr8OyKZProSiu4kG8gvf7tlkbhcF2Kj2Ba4bwdvnck
 JVhLCptH7fUCyovktVO9xX4OqzBqLkMbs/CTlPFRoiuitqMfjIM5/ajC1fmatkEBu5bn0UqX
X-Proofpoint-ORIG-GUID: CVUCeWibiMU-q77Y6f54Lm89Hq3EQfZV
X-Proofpoint-GUID: CVUCeWibiMU-q77Y6f54Lm89Hq3EQfZV
X-Authority-Analysis: v=2.4 cv=PsWTbxM3 c=1 sm=1 tr=0 ts=682dfeac cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=hFxyhTWOyB1buIFPRroA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_05,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=636
 impostorscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505210158

On Tue, May 20, 2025 at 08:26:38PM +0200, Claudio Imbrenda wrote:
> +void __gmap_helper_set_unused(struct mm_struct *mm, unsigned long vmaddr)
> +{
> +	spinlock_t *ptl;
> +	pmd_t *pmdp;
> +	pte_t *ptep;
> +
> +	mmap_assert_locked(mm);
> +
> +	if (pmd_lookup(mm, vmaddr, &pmdp))
> +		return;
> +	ptl = pmd_lock(mm, pmdp);
> +	if (!pmd_present(*pmdp) || pmd_leaf(*pmdp)) {
> +		spin_unlock(ptl);
> +		return;
> +	}
> +	spin_unlock(ptl);
> +
> +	ptep = pte_offset_map_lock(mm, pmdp, vmaddr, &ptl);
> +	if (!ptep)
> +		return;
> +	/* The last byte of a pte can be changed freely without ipte */
> +	__atomic64_or(_PAGE_UNUSED, (long *)ptep);
> +	pte_unmap_unlock(ptep, ptl);
> +}
> +EXPORT_SYMBOL_GPL(__gmap_helper_set_unused);

This is unused, as far as I can tell. I'm not sure if it is a good approach to
do all this code movements / refactorings now. Especially if you also add
(now?) dead code. I guess that e.g. this function is required for your rework
that will come later?

Imho this series causes quite a bit confusion and is not about "cleanups and
small fixes" like advertised.

