Return-Path: <kvm+bounces-63552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D664C6A432
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 16:16:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id DE3A22B95A
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 15:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2FF0364049;
	Tue, 18 Nov 2025 15:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WVgcwR4J"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA623570B6;
	Tue, 18 Nov 2025 15:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763478616; cv=none; b=NtsnJno98IfihfqE2Hg2Ri0zalYHBwv+4PN3BE3bSP3BLWnmTEoDeZCiR/PwFIXg41jR/KXrK00qF0CQfwUXPcLgGzVqP2L0vC3ofmid0LHpj/312hbgubpWyzWHeO8gWc/tVzCaIo2a8KhVMmHSYtkk8tos7YffkGTcTSuhZ1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763478616; c=relaxed/simple;
	bh=rEawjm9u5UijAwjWwmbN29yDeUrwDQnyS0lfriD+hGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d5E4j0tOZzT5InrR9+RKiCDSbD2IjuVerckoKXEf+KdPgdKz0eUHoF4feixtKJ2HEr/9vSTu9SOPQoCdC90Xr7xW6V6JgD/EaqQiFqQrsLN6dXIumpPvU7vYRgUK52KZ7ZrETzpWxLStKBcCrRlnZ3nhvN98LzlIrioBoSlLk38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WVgcwR4J; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI27KbE007914;
	Tue, 18 Nov 2025 15:10:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=aVy8SIlcNprNYlIhTVjg2VLEHQR9xO
	DuYfOxUrv7+Io=; b=WVgcwR4J/+Hbm5Ql/v1G0si2UyeYqDdzhi1ijcAruBkNiG
	rGHT6n19JYGSePw78/KvVENiUEdsrXiSRogznicqUtIsmGEjR1o9d+91GVBS/p5O
	fBGm5eKORgUqA7dfEw7dIKIKoy8ptUUSi9d2xp3Yl+rXZNyOPgcu/P+Ky/qcFxTR
	Jy3YuJW0WShxHIMlByuYA7zQDxZQCa/Zd5WhZPlYH5cVDMPVKd9lom/cpLLsoRFs
	A8gE1Fs+Lxkf7Nq2Mnbd71XlI9uEwnBr6+ExuSvSG7EOjoAqWjt4KT9wMPuHOXy/
	Cnz8C1ZOGrxR4UhYdoTXNFURNECmGbF6UemSUqRQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejk1bf6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 15:10:11 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIBUqrG010392;
	Tue, 18 Nov 2025 15:10:10 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af3us3ud9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 15:10:10 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AIFA6MI37093838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 15:10:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C88D020043;
	Tue, 18 Nov 2025 15:10:06 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B01620040;
	Tue, 18 Nov 2025 15:10:06 +0000 (GMT)
Received: from osiris (unknown [9.155.211.25])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 18 Nov 2025 15:10:06 +0000 (GMT)
Date: Tue, 18 Nov 2025 16:10:05 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v3 15/23] KVM: s390: Add helper functions for fault
 handling
Message-ID: <20251118151005.9674Af1-hca@linux.ibm.com>
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
 <20251106161117.350395-16-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106161117.350395-16-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=C/nkCAP+ c=1 sm=1 tr=0 ts=691c8c53 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=LOPTmjPZaZTW9MxM_NgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: Yo6vZMqycVNGyNQgPrl6gW2JfRUnoGw2
X-Proofpoint-ORIG-GUID: Yo6vZMqycVNGyNQgPrl6gW2JfRUnoGw2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX8pmXOInEZomW
 Zur1nUH9imTJ1lTT+H7WyUY7e/ZmRFBPbCwtkq5vgBwVdIXHUZDHy7Re2884WoRpMkhB9wwzedd
 ePeZvnQBoZ7/SdD7g4ovz200UgdqZpN7f0Wj7rI4lLsXVLwwWuS/tyXJtDZ9c/9VgGmsnHxMb8U
 GbwGFYvA0VQuRNR5Tr/XDjXZH7GccdR+mDnEiDpgSp787buxyzRJBbqynyUZNkoLlkBas4xz8NO
 pVRhdTAakMq5XOJXu7hpGOxi98SwpYQVtGPL5z25Rw59pV8S8NpKXgB1yyxoXT+FvtsIM/BOXQO
 vcOMq+gFCvgT7OMJoglwthFNe3hFCwltoXeRz//fFgi6d8sAeNizSGSrsthLUqAs9ULP/3kSN2H
 Y9BdIIXqB4shIMaJNb5tAhoc2dJXhw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-18_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 spamscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

On Thu, Nov 06, 2025 at 05:11:09PM +0100, Claudio Imbrenda wrote:
> Add some helper functions for handling multiple guest faults at the
> same time.
> 
> This will be needed for VSIE, where a nested guest access also needs to
> access all the page tables that map it.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |   1 +
>  arch/s390/kvm/Makefile           |   2 +-
>  arch/s390/kvm/faultin.c          | 148 +++++++++++++++++++++++++++++++
>  arch/s390/kvm/faultin.h          |  92 +++++++++++++++++++
>  arch/s390/kvm/kvm-s390.c         |   2 +-
>  arch/s390/kvm/kvm-s390.h         |   2 +
>  6 files changed, 245 insertions(+), 2 deletions(-)
>  create mode 100644 arch/s390/kvm/faultin.c
>  create mode 100644 arch/s390/kvm/faultin.h

...

> +int kvm_s390_faultin_gfn(struct kvm_vcpu *vcpu, struct kvm *kvm, struct guest_fault *f)
> +{

...

> +		scoped_guard(read_lock, &kvm->mmu_lock) {
> +			if (!mmu_invalidate_retry_gfn(kvm, inv_seq, f->gfn)) {
> +				f->valid = true;
> +				rc = gmap_link(mc, kvm->arch.gmap, f);
> +				kvm_release_faultin_page(kvm, f->page, !!rc, f->write_attempt);
> +				f->page = NULL;
> +			}
> +		}
> +		kvm_release_faultin_page(kvm, f->page, true, false);
> +
> +		if (rc == -ENOMEM) {
> +			rc = kvm_s390_mmu_cache_topup(mc);

If I'm not mistaken then gmap_link() -> dat_link() maps the possible -ENOMEM
return value of dat_entry() to -EAGAIN. So the case where -ENOMEM leads to a
kvm_s390_mmu_cache_topup() call will never happen.

