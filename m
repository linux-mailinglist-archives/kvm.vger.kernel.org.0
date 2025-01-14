Return-Path: <kvm+bounces-35402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D557A10DDC
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 18:34:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E4B71883CD2
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 17:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B5291F942B;
	Tue, 14 Jan 2025 17:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="j+wJxt4b"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6FE232456;
	Tue, 14 Jan 2025 17:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736876072; cv=none; b=oumIribbcAudV5sn2gzQQNn3eCxFAYVanISB3h7ioj20sqN+5f6tLDCp5fmdOXSl05B3ZgQ+kBN1C+9AGc1ttw7CyG0vyE5GpSXXP69UQRcEmle7ys4Vz0QkYbHpyVxGETpYq910ID3MtirRf8Cu0LjrvQ43xIIzAn1G/LiodR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736876072; c=relaxed/simple;
	bh=4tgaV7/QtrKgElOy9K+p5OVZbHsWTACK89D/RKmpThA=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Subject:From:Cc:
	 References:In-Reply-To; b=K3tu+St9fgbdw1NikacS+Lv3fB46ilvkcuJgZj1fDsuqNLJmb0dRBs60+ThOsRsPrPROlp9NbKmnF8QHl+XIRaYBujqqa3UGzMcHNz9HnvJkg7LxAH89kTIbb26X3WcwJq1nlN6MJ45Wy4L7FJ9Y6hjcK0hFGcXhPfgRF/MHhjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=j+wJxt4b; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50E85kwm021279;
	Tue, 14 Jan 2025 17:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=PNvI0X
	lnsWUDByEi1VYVg759l+9FP1k7j5lMBB/ivQE=; b=j+wJxt4be0gPCD8PwJAqsk
	M4IArifBAlyKBYRuIKgoOAYKidNRsaGjgNAsG5I3W/bAOeZfLV9+Vfqrub+Q6HCD
	8prJ3j6KEbJxPx4v6qC3V0k5uJqD44G/dXP3o00plJwPAr9+VTkwDpFgfUMDzZ0X
	BhxTuOiqseuvWK6tTVcZVl0+x4dHqe2xWRhZASMmiKC/CKGs+2m/0L85aqvJStf8
	CiS2/WwZGyqkaxZyI9DmGD5p/lTkwWkTy8gstWUgTTVmZq4LWDdWPCKJ4hz1PsSz
	lxGYXdECoH7SINpKSf0SKzICTPnGhau9Dd4x0g+7hf35QeetrZ409JDMQpWkwoPQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 445m432b0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jan 2025 17:34:24 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50EE0eqW007519;
	Tue, 14 Jan 2025 17:34:23 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443yn48th-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jan 2025 17:34:23 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50EHYJeF50397662
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 17:34:19 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 61C7820043;
	Tue, 14 Jan 2025 17:34:19 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3433D20040;
	Tue, 14 Jan 2025 17:34:19 +0000 (GMT)
Received: from darkmoore (unknown [9.171.93.160])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Jan 2025 17:34:19 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Jan 2025 18:34:13 +0100
Message-Id: <D71Z6BW4A19F.3OQIPSERFIUCH@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v1 03/13] KVM: s390: use __kvm_faultin_pfn()
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>
X-Mailer: aerc 0.18.2
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
 <20250108181451.74383-4-imbrenda@linux.ibm.com>
In-Reply-To: <20250108181451.74383-4-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0RMxoIUluzqHNTirAazitC6qlxoNK_AS
X-Proofpoint-GUID: 0RMxoIUluzqHNTirAazitC6qlxoNK_AS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 impostorscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501140134

On Wed Jan 8, 2025 at 7:14 PM CET, Claudio Imbrenda wrote:
> Refactor the existing page fault handling code to use __kvm_faultin_pfn()=
.
>
> This possible now that memslots are always present.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 92 +++++++++++++++++++++++++++++++---------
>  arch/s390/mm/gmap.c      |  1 +
>  2 files changed, 73 insertions(+), 20 deletions(-)

With nits resolved:

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

>
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 797b8503c162..8e4e7e45238b 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4794,11 +4794,66 @@ static void kvm_s390_assert_primary_as(struct kvm=
_vcpu *vcpu)
>  		current->thread.gmap_int_code, current->thread.gmap_teid.val);
>  }
> =20
> +static int kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, g=
pa_t gaddr,
> +				     unsigned int flags)
> +{
> +	struct kvm_memory_slot *slot;
> +	unsigned int fault_flags;
> +	bool writable, unlocked;
> +	unsigned long vmaddr;
> +	struct page *page;
> +	kvm_pfn_t pfn;
> +	int rc;
> +
> +	slot =3D kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> +	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
> +		return vcpu_post_run_addressing_exception(vcpu);
> +
> +	fault_flags =3D flags & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
> +	if (vcpu->arch.gmap->pfault_enabled)
> +		flags |=3D FOLL_NOWAIT;
> +	vmaddr =3D __gfn_to_hva_memslot(slot, gfn);
> +
> +try_again:
> +	pfn =3D __kvm_faultin_pfn(slot, gfn, flags, &writable, &page);
> +
> +	/* Access outside memory, inject addressing exception */
> +	if (is_noslot_pfn(pfn))
> +		return vcpu_post_run_addressing_exception(vcpu);
> +	/* Signal pending: try again */
> +	if (pfn =3D=3D KVM_PFN_ERR_SIGPENDING)
> +		return -EAGAIN;
> +
> +	/* Needs I/O, try to setup async pfault (only possible with FOLL_NOWAIT=
) */
> +	if (pfn =3D=3D KVM_PFN_ERR_NEEDS_IO) {
> +		trace_kvm_s390_major_guest_pfault(vcpu);
> +		if (kvm_arch_setup_async_pf(vcpu))
> +			return 0;
> +		vcpu->stat.pfault_sync++;
> +		/* Could not setup async pfault, try again synchronously */
> +		flags &=3D ~FOLL_NOWAIT;
> +		goto try_again;
> +	}
> +	/* Any other error */
> +	if (is_error_pfn(pfn))
> +		return -EFAULT;
> +
> +	/* Success */
> +	mmap_read_lock(vcpu->arch.gmap->mm);
> +	/* Mark the userspace PTEs as young and/or dirty, to avoid page fault l=
oops */
> +	rc =3D fixup_user_fault(vcpu->arch.gmap->mm, vmaddr, fault_flags, &unlo=
cked);
> +	if (!rc)
> +		rc =3D __gmap_link(vcpu->arch.gmap, gaddr, vmaddr);
> +	kvm_release_faultin_page(vcpu->kvm, page, false, writable);
> +	mmap_read_unlock(vcpu->arch.gmap->mm);
> +	return rc;
> +}
> +
>  static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
>  {
> +	unsigned long gaddr, gaddr_tmp;
>  	unsigned int flags =3D 0;
> -	unsigned long gaddr;
> -	int rc =3D 0;
> +	gfn_t gfn;
> =20
>  	gaddr =3D current->thread.gmap_teid.addr * PAGE_SIZE;
>  	if (kvm_s390_cur_gmap_fault_is_write())
> @@ -4850,29 +4905,26 @@ static int vcpu_post_run_handle_fault(struct kvm_=
vcpu *vcpu)
>  	case PGM_REGION_SECOND_TRANS:
>  	case PGM_REGION_THIRD_TRANS:
>  		kvm_s390_assert_primary_as(vcpu);
> -		if (vcpu->arch.gmap->pfault_enabled) {
> -			rc =3D gmap_fault(vcpu->arch.gmap, gaddr, flags | FAULT_FLAG_RETRY_NO=
WAIT);
> -			if (rc =3D=3D -EFAULT)
> -				return vcpu_post_run_addressing_exception(vcpu);
> -			if (rc =3D=3D -EAGAIN) {
> -				trace_kvm_s390_major_guest_pfault(vcpu);
> -				if (kvm_arch_setup_async_pf(vcpu))
> -					return 0;
> -				vcpu->stat.pfault_sync++;
> -			} else {
> -				return rc;
> -			}
> -		}
> -		rc =3D gmap_fault(vcpu->arch.gmap, gaddr, flags);
> -		if (rc =3D=3D -EFAULT) {
> -			if (kvm_is_ucontrol(vcpu->kvm)) {
> +
> +		gfn =3D gpa_to_gfn(gaddr);
> +		if (kvm_is_ucontrol(vcpu->kvm)) {
> +			/*
> +			 * This translates the per-vCPU guest address into a
> +			 * fake guest address, which can then be used with the
> +			 * fake memslots that are identity mapping userspace.
> +			 * This allows ucontrol VMs to use the normal fault
> +			 * resolution path, like normal VMs.
> +			 */
> +			gaddr_tmp =3D gmap_translate(vcpu->arch.gmap, gaddr);
> +			if (gaddr_tmp =3D=3D -EFAULT) {
>  				vcpu->run->exit_reason =3D KVM_EXIT_S390_UCONTROL;
>  				vcpu->run->s390_ucontrol.trans_exc_code =3D gaddr;
>  				vcpu->run->s390_ucontrol.pgm_code =3D 0x10;

nit: s/0x10/PGM_SEGMENT_TRANSLATION/

>  				return -EREMOTE;
>  			}
> -			return vcpu_post_run_addressing_exception(vcpu);
> +			gfn =3D gpa_to_gfn(gaddr_tmp);
>  		}
> +		return kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, flags);
>  		break;

nit: Remove the break after the return here?

>  	default:
>  		KVM_BUG(1, vcpu->kvm, "Unexpected program interrupt 0x%x, TEID 0x%016l=
x",
> @@ -4880,7 +4932,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vc=
pu *vcpu)
>  		send_sig(SIGSEGV, current, 0);
>  		break;
>  	}
> -	return rc;
> +	return 0;
>  }
> =20
>  static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 16b8a36c56de..3aacef77c174 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -605,6 +605,7 @@ int __gmap_link(struct gmap *gmap, unsigned long gadd=
r, unsigned long vmaddr)
>  	radix_tree_preload_end();
>  	return rc;
>  }
> +EXPORT_SYMBOL(__gmap_link);
> =20
>  /**
>   * fixup_user_fault_nowait - manually resolve a user page fault without =
waiting


