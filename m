Return-Path: <kvm+bounces-41575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98E87A6A9AF
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 16:23:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F3301882A08
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 15:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60DB91E9B1C;
	Thu, 20 Mar 2025 15:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="orwO8i1n"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41191E98E3;
	Thu, 20 Mar 2025 15:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742484175; cv=none; b=VHLvh3SL9wbEF1DgLy5siG0JK6MEU9cdatsoQX0C4e5Vd/tD7kiYMJqS9IyD3Fxjm+CKdd9sXhqgaOg4B0dI+dj08tkP7/ruEJ/KDD6mG6RdBdTaY76q4sMiDhbE28sTmw7zAr1/4JXftlNgZ295sjlV3DOQNcyM8LWZNdjHH00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742484175; c=relaxed/simple;
	bh=QcEKTvVCcmt+Mtl5LAj4p9CXTQljIa6E2wBgLOJl1RM=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=XdYJnzWctMnZcIIzcxpFAGzSMo1msQ//x/Enxp/BSsOY7RBIyylMnIkg34c8x7Vp64QmasQMoW76DOULP8CO+Ct66VW8Rfr8HKlwICY9Vk/rAtV/UPNiGwR8CBbRZqhNRwsonZ3CnzDNmJF5ZBhUu0CtiKZz9WYS5cKF/ZYNxb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=orwO8i1n; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52K8iB9M032154;
	Thu, 20 Mar 2025 15:22:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WOoXjn
	Jf/52FUL8/hywtI6TArPJFwJgYRU6NlJMbWnE=; b=orwO8i1necDpuF8OZxGIzi
	jS5xt9BEKSe856gNTck8sYC0CXKjQw4dN2+73ZYm7fN9X7kw60eAIvBRI5rb+oI3
	uj0Uz3jNQVaJxlTGf630rkaxVJm//Zexw1HPGdYlggW+q1EXQq/j1WwbZb+xiwOR
	4FW3LDgkO2nh3Wxem4dJ25qcdl8cnS6lNJSglUpmboDctC3xADfw7G8sSs6rp5L3
	P8DEPGxB6SBqjLOtFbryZfu7psGNk+hbF9xYik9+hy38DbsPG04+pl1RhlYn0QLB
	plV1fx3V149Y1w7Uo8sHU/3//aym8zJ7GALlrLMfU+oR+BfsI+RBUiVONaJxIM3Q
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45g5504wqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Mar 2025 15:22:51 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52KCp2fi005752;
	Thu, 20 Mar 2025 15:22:50 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 45dpk2r8tr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Mar 2025 15:22:50 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52KFMki456033614
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Mar 2025 15:22:46 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C985A20043;
	Thu, 20 Mar 2025 15:22:46 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D59F20040;
	Thu, 20 Mar 2025 15:22:46 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.23.86])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Mar 2025 15:22:46 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 20 Mar 2025 16:22:45 +0100
Message-Id: <D8L732XS5NQW.1M5J3D0TFMQMD@linux.ibm.com>
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Christoph Schlameuss" <schlameuss@linux.ibm.com>, <kvm@vger.kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>,
        "Janosch Frank"
 <frankja@linux.ibm.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Sven Schnelle"
 <svens@linux.ibm.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>, <linux-s390@vger.kernel.org>
Subject: Re: [PATCH RFC 3/5] KVM: s390: Shadow VSIE SCA in guest-1
X-Mailer: aerc 0.20.1
References: <20250318-vsieie-v1-0-6461fcef3412@linux.ibm.com>
 <20250318-vsieie-v1-3-6461fcef3412@linux.ibm.com>
In-Reply-To: <20250318-vsieie-v1-3-6461fcef3412@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ExGxd4PgYVwu4UMkCFPrfWMMlfoBj7bD
X-Proofpoint-ORIG-GUID: ExGxd4PgYVwu4UMkCFPrfWMMlfoBj7bD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-20_03,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=916 spamscore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503200093

On Tue Mar 18, 2025 at 7:59 PM CET, Christoph Schlameuss wrote:
[...]
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm=
_host.h
> index 0aca5fa01f3d772c3b3dd62a22134c0d4cb9dc22..4ab196caa9e79e4c4d295d23f=
ed65e1a142e6ab1 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
[...]
> +static struct ssca_vsie *get_ssca(struct kvm *kvm, struct vsie_page *vsi=
e_page)
> +{
> +	u64 sca_o_hva =3D vsie_page->sca_o;
> +	phys_addr_t sca_o_hpa =3D virt_to_phys((void *)sca_o_hva);
> +	struct ssca_vsie *ssca, *ssca_new =3D NULL;
> +
> +	/* get existing ssca */
> +	down_read(&kvm->arch.vsie.ssca_lock);
> +	ssca =3D get_existing_ssca(kvm, sca_o_hva);
> +	up_read(&kvm->arch.vsie.ssca_lock);
> +	if (ssca)
> +		return ssca;

I would assume this is the most common case, no?

And below only happens rarely, right?

> +	/*
> +	 * Allocate new ssca, it will likely be needed below.
> +	 * We want at least #online_vcpus shadows, so every VCPU can execute th=
e
> +	 * VSIE in parallel. (Worst case all single core VMs.)
> +	 */
> +	if (kvm->arch.vsie.ssca_count < atomic_read(&kvm->online_vcpus)) {
> +		BUILD_BUG_ON(offsetof(struct ssca_block, cpu) !=3D 64);
> +		BUILD_BUG_ON(offsetof(struct ssca_vsie, ref_count) !=3D 0x2200);
> +		BUILD_BUG_ON(sizeof(struct ssca_vsie) > ((1UL << SSCA_PAGEORDER)-1) * =
PAGE_SIZE);
> +		ssca_new =3D (struct ssca_vsie *)__get_free_pages(GFP_KERNEL_ACCOUNT |=
 __GFP_ZERO,
> +								SSCA_PAGEORDER);
> +		if (!ssca_new) {
> +			ssca =3D ERR_PTR(-ENOMEM);
> +			goto out;
> +		}
> +		init_ssca(vsie_page, ssca_new);
> +	}
> +
> +	/* enter write lock and recheck to make sure ssca has not been created =
by other cpu */
> +	down_write(&kvm->arch.vsie.ssca_lock);

I am wondering whether it's really worth having this optimization of trying=
 to
avoid taking the lock? Maybe we can accept a bit of contention on the rwloc=
k
since it shouldn't happen very often and keep the code a bit less complex?

