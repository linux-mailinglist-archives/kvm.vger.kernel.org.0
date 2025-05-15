Return-Path: <kvm+bounces-46681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 912D9AB84C6
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 13:27:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52B758C1EFC
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 11:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852C229827D;
	Thu, 15 May 2025 11:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="symGZTJ3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6A6298241;
	Thu, 15 May 2025 11:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747308411; cv=none; b=n2SDgow6XdllnAij07IFlNxhFvtXFAWRs8OdoqQqKMCjVCpYjjEd/IlYLn75UU57JN+aCn3ibAd5GxaDERZV0H0qpfvVVf/eNfbq+VpVARZIpLZjoPLM/UdzcQ+ngueYRuEJC8IUn7IOoskBkVSvX37EPxAhqwzOAZV2TG/TTWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747308411; c=relaxed/simple;
	bh=ARlWs6X/cdFkoTRsr8RCVnKl/AfdOb9phR7J9j9bpMU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GpdJHt8GuSRG7I0DPjVefu8t1cLgSxkIgkUr+RiouOFW9lI17lQNOYHr6bhDbKVuHZNciDcxbx+Ay7j2N7fpCQAgwq9UeBQfJF8BO9MZT94mT3HAHWuaKXhtLrE+BYikoNtlplPSTk38RQbOdbMsOjzH5x1Q3yWfhH6DMqjbnGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=symGZTJ3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54F6IpDp016686;
	Thu, 15 May 2025 11:26:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=GLeWW1
	AxRGdz2ieIDjyUIVK9+rc+ZIhct4/Y4SUIUPc=; b=symGZTJ34R/szM9f/MUeKU
	zW0pO6g8jVQvTByXn1NlK0C01zDt3BrI7LWQa51mD8KMIXKNttDA2/pCZGaY8eyG
	y3dbj+yEsKzxz2Fo+zCHyEHTColUPlmoSnmBh/P/kYcs58jJq9mDFFCfiogQIqqB
	uqLZ07Oa8/76PQkehUXrj4ijNtYlYcnv0DGG+5RsB6UO/0ntNbPVxM5P4ZGVtRBq
	DnCh/JYsbG2vPhFFpe7MUYyfKtzqx8cTO3TJGz65vHeVgfnPVnwVgcm9zKUZQ5G9
	EfJnGUJHYpD0zQg2hhSrhu6qISqiK7yxe4ndn9ZOV6Q0YAjhn7Pm0h3R7cq7VSLQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46navu1edv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 11:26:47 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54FAVjIC019466;
	Thu, 15 May 2025 11:26:46 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46mbfrswdg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 11:26:46 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54FBQgu355902696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 11:26:42 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9758020087;
	Thu, 15 May 2025 11:26:42 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B73D20085;
	Thu, 15 May 2025 11:26:42 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 May 2025 11:26:42 +0000 (GMT)
Date: Thu, 15 May 2025 13:25:42 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: kvm@vger.kernel.org, Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand
 <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven
 Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: s390: Specify kvm->arch.sca as esca_block
Message-ID: <20250515132542.2a1c4c89@p-imbrenda>
In-Reply-To: <20250514-rm-bsca-v1-3-6c2b065a8680@linux.ibm.com>
References: <20250514-rm-bsca-v1-0-6c2b065a8680@linux.ibm.com>
	<20250514-rm-bsca-v1-3-6c2b065a8680@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KXG9UCIuo05VwvJoTsK7oyO0Is-4KzUZ
X-Authority-Analysis: v=2.4 cv=XK4wSRhE c=1 sm=1 tr=0 ts=6825cf77 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=azY-gnguuONGBXNlzOEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: KXG9UCIuo05VwvJoTsK7oyO0Is-4KzUZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDEwOSBTYWx0ZWRfX62btgk+unMdU qKE6skubupVqfGD/rOBUrmwwypcsvPoxSqbPjl8F9aGpniL+CBNp9pgM+zCPV7+UxPrsWvhTPc4 z11Ph9GkxarW8Ovc3Q3LMlJZWfItO/UNQrF4j1NsImQSFJXGLVSEJYjxqOb+jYg721qKMlkswm8
 yFU0aSqQotMDR+6RdcA+RwfM2nJ0sLs8OsnITZC9I7NXD59ht+QwkBq25bKTiHKuxAeNC4G/a3c CT0sSERRob4B2wXs94qq/5UBRQhKnBGIvnKIyefG3OAHG5/fb+tgnwvobF56VkNSp2avb7B1z2z v4lP4msKJnCHGws2qy3XKq5mYF2qh5t8Pe7c6zFdzUGEhanjuiu7CDYoSFHTNxeJ6IDhi4tzGKD
 6Nt3snJzq2XOXCX1wecYOY1O4KFTdiL9txfmilV5EtY6RDmqY6CRxKjpSenA3du7DL9XqlH5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_05,2025-05-14_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505150109

On Wed, 14 May 2025 18:34:51 +0200
Christoph Schlameuss <schlameuss@linux.ibm.com> wrote:

> We are no longer referencing a bsca_block in kvm->arch.sca. This will
> always be esca_block instead.
> By specifying the type of the sca as esca_block we can simplify access
> to the sca and get rid of some helpers while making the code clearer.
> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/kvm_host.h |  4 ++--
>  arch/s390/kvm/gaccess.c          | 10 +++++-----
>  arch/s390/kvm/kvm-s390.c         |  4 ++--
>  arch/s390/kvm/kvm-s390.h         |  7 -------
>  4 files changed, 9 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index d03e354a63d9c931522c1a1607eba8685c24527f..2a2b557357c8e40c82022eb338c3e98aa8f03a2b 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -629,8 +629,8 @@ struct kvm_s390_pv {
>  	struct mmu_notifier mmu_notifier;
>  };
>  
> -struct kvm_arch{
> -	void *sca;
> +struct kvm_arch {
> +	struct esca_block *sca;
>  	rwlock_t sca_lock;
>  	debug_info_t *dbf;
>  	struct kvm_s390_float_interrupt float_int;
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index f6fded15633ad87f6b02c2c42aea35a3c9164253..ee37d397d9218a4d33c7a33bd877d0b974ca9003 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -112,7 +112,7 @@ int ipte_lock_held(struct kvm *kvm)
>  		int rc;
>  
>  		read_lock(&kvm->arch.sca_lock);
> -		rc = kvm_s390_get_ipte_control(kvm)->kh != 0;
> +		rc = kvm->arch.sca->ipte_control.kh != 0;
>  		read_unlock(&kvm->arch.sca_lock);
>  		return rc;
>  	}
> @@ -129,7 +129,7 @@ static void ipte_lock_simple(struct kvm *kvm)
>  		goto out;
>  retry:
>  	read_lock(&kvm->arch.sca_lock);
> -	ic = kvm_s390_get_ipte_control(kvm);
> +	ic = &kvm->arch.sca->ipte_control;
>  	old = READ_ONCE(*ic);
>  	do {
>  		if (old.k) {
> @@ -154,7 +154,7 @@ static void ipte_unlock_simple(struct kvm *kvm)
>  	if (kvm->arch.ipte_lock_count)
>  		goto out;
>  	read_lock(&kvm->arch.sca_lock);
> -	ic = kvm_s390_get_ipte_control(kvm);
> +	ic = &kvm->arch.sca->ipte_control;
>  	old = READ_ONCE(*ic);
>  	do {
>  		new = old;
> @@ -172,7 +172,7 @@ static void ipte_lock_siif(struct kvm *kvm)
>  
>  retry:
>  	read_lock(&kvm->arch.sca_lock);
> -	ic = kvm_s390_get_ipte_control(kvm);
> +	ic = &kvm->arch.sca->ipte_control;
>  	old = READ_ONCE(*ic);
>  	do {
>  		if (old.kg) {
> @@ -192,7 +192,7 @@ static void ipte_unlock_siif(struct kvm *kvm)
>  	union ipte_control old, new, *ic;
>  
>  	read_lock(&kvm->arch.sca_lock);
> -	ic = kvm_s390_get_ipte_control(kvm);
> +	ic = &kvm->arch.sca->ipte_control;
>  	old = READ_ONCE(*ic);
>  	do {
>  		new = old;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d610447dbf2c1caa084bd98eabf19c4ca8f1e972..9af8fe93ed3f093f4cce16771d095c08f770d44d 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1964,7 +1964,7 @@ static int kvm_s390_get_topo_change_indication(struct kvm *kvm,
>  		return -ENXIO;
>  
>  	read_lock(&kvm->arch.sca_lock);
> -	topo = ((struct esca_block *)kvm->arch.sca)->utility.mtcr;
> +	topo = kvm->arch.sca->utility.mtcr;
>  	read_unlock(&kvm->arch.sca_lock);
>  
>  	return put_user(topo, (u8 __user *)attr->addr);
> @@ -3303,7 +3303,7 @@ static void kvm_s390_crypto_init(struct kvm *kvm)
>  
>  static void sca_dispose(struct kvm *kvm)
>  {
> -	free_pages_exact(kvm->arch.sca, sizeof(struct esca_block));
> +	free_pages_exact(kvm->arch.sca, sizeof(*kvm->arch.sca));
>  	kvm->arch.sca = NULL;
>  }
>  
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 2c8e177e4af8f2dab07fd42a904cefdea80f6855..0c5e8ae07b77648d554668cc0536607545636a68 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -528,13 +528,6 @@ void kvm_s390_prepare_debug_exit(struct kvm_vcpu *vcpu);
>  int kvm_s390_handle_per_ifetch_icpt(struct kvm_vcpu *vcpu);
>  int kvm_s390_handle_per_event(struct kvm_vcpu *vcpu);
>  
> -/* support for Basic/Extended SCA handling */
> -static inline union ipte_control *kvm_s390_get_ipte_control(struct kvm *kvm)
> -{
> -	struct esca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
> -
> -	return &sca->ipte_control;
> -}
>  static inline int kvm_s390_use_sca_entries(void)
>  {
>  	/*
> 


