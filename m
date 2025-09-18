Return-Path: <kvm+bounces-58013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D352B854D8
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:42:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0856E7C16B4
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 14:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A3F2FFF99;
	Thu, 18 Sep 2025 14:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cVv/zHyT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1C834BA50;
	Thu, 18 Sep 2025 14:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758206526; cv=none; b=AjfZox9yoMdmySG1n3AFFSf6JIHU8RmOFr8EuW6ljR6BAWiX4rNPr40GJVYvqB8kDNK/9cDSzf/TRwVAA/a5PjeAZUnlSnR2dnA23DWrnS9SLTLYOexenO6ii2A4cIkrgmWEMwZT9AAwz4U3KyAXmnrVjgS6zVAWQ7DuHx4sDvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758206526; c=relaxed/simple;
	bh=wULbZJ39pnL88/OUZbNQ7RZxEyMpwW//jbeJqwoElXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A9pgC5eC8fY4M1JkzsWTCXPLEBllfUaMsT+KZTvnuxr2CLMMytrcFYGFC8MZ8Rvw0LbM7LoEgjSD11QUoVbqsTZ4v0yDMw3+A1qpczgEamN6hA4qumTMmKnct7w62UzrIvO/rTJzhEZHYCYJ3SYjweTi/OUwLDoLRoZnDbcBg24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cVv/zHyT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I6Vuqd031219;
	Thu, 18 Sep 2025 14:42:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=4HZrsQPlJP0Ejk05qtSLLEBK7MeCuL
	0NRjbGkK3vrUc=; b=cVv/zHyTZ3EhmUSU/aFRuOfpWjxkG3dGbmVoBhDS7MOSha
	jjuTUnbzgiTjd617IQNZ7YuK7mBv409YEhF72qMZ7AsAmCnPTP4KwIvBLJUaeyWW
	zcaVAgckOAx3yDyWtqdVzmYoH5YH7wVbu/92l9xEgUj3lcbvFVpKBarJ9xtcdnM7
	DHhHAXRu99kgyFH6nHJN2+d4Wj+3WpwzIcC7n6vyFnHr9EHtrfk5lo3Itt2bw8iv
	z+DFlTbNvj2eL18q5JVxAXDtuqCjrNnYJc5+TklAzFWQA+QTLYGLJFbsN9Mv2EoC
	4XIdrmzTOaKdDohe8jnbzpDqf1iaLaj02cFwVGFQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4htvvy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 14:42:02 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58IB2OqB019200;
	Thu, 18 Sep 2025 14:42:01 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 495n5mpwcg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 14:42:01 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58IEfvvB53674378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 14:41:57 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C15F320043;
	Thu, 18 Sep 2025 14:41:57 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6BF5D20040;
	Thu, 18 Sep 2025 14:41:57 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 18 Sep 2025 14:41:57 +0000 (GMT)
Date: Thu, 18 Sep 2025 16:41:56 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        svens@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 05/20] KVM: s390: Add helper functions for fault
 handling
Message-ID: <4b67fe70-efc7-46cb-a160-51e4fc1bc54c-agordeev@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-6-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910180746.125776-6-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fGWO9jupu8ohJGcOjCKFzCoN4Bd-ffa6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX5BY0o0okOvxP
 UVLXFvuZjg6+m7QqVNORfRLlZgpGIg2dpGxCHKORBGVwHiXhfsStIkABMvZiyycLgQ6iLHHbThA
 MhU8vrCbCawAnGtfXB7AtS5JxP32P0tZcH0v3DOLdhB5ElW7mmLIuRCyqgefCYRwydmOo4173Dl
 C9JF5eHHVhP1+Wl0uh/5eH2Vsq3hNOI+JsRby7NA1dkwDwpBAjoXi3hRp56t+KXqlBBUXjS706K
 O1ySQ4K9UJbJnLflDyRlI+iu9fekrHCdblJLEWZJR1DacCauK+BoDpnJdVLo9m7UXmrM2pEqoxO
 hmBmtxttVT/GQn7xf3Y0rP1T0B3F5MuEhTKELJhXHwUZoU2QQsva5oylrJ0Emu6Fz/3Y0YNxNsC
 MHQXp5jc
X-Proofpoint-GUID: fGWO9jupu8ohJGcOjCKFzCoN4Bd-ffa6
X-Authority-Analysis: v=2.4 cv=co2bk04i c=1 sm=1 tr=0 ts=68cc1a3a cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=nuKrPy9HrZ1A1beeUZ0A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509160204

On Wed, Sep 10, 2025 at 08:07:31PM +0200, Claudio Imbrenda wrote:
> Add some helper functions for handling multiple guest faults at the
> same time.
> 
> This will be needed for VSIE, where a nested guest access also needs to
> access all the page tables that map it.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/gaccess.h  | 14 ++++++++++
>  arch/s390/kvm/kvm-s390.c | 44 +++++++++++++++++++++++++++++++
>  arch/s390/kvm/kvm-s390.h | 56 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 114 insertions(+)
> 
> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
> index 3fde45a151f2..9c82f7460821 100644
> --- a/arch/s390/kvm/gaccess.h
> +++ b/arch/s390/kvm/gaccess.h
> @@ -457,4 +457,18 @@ int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra);
>  int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *shadow,
>  			  unsigned long saddr, unsigned long *datptr);
>  
> +static inline int __kvm_s390_faultin_read_gpa(struct kvm *kvm, struct guest_fault *f, gpa_t gaddr,
> +					      unsigned long *val)
> +{
> +	phys_addr_t phys_addr;
> +	int rc;
> +
> +	rc = __kvm_s390_faultin_gfn(kvm, f, gpa_to_gfn(gaddr), false);

Why not a "typical" flow (below)?

> +	if (!rc) {
> +		phys_addr = PFN_PHYS(f->pfn) | offset_in_page(gaddr);
> +		*val = *(unsigned long *)phys_to_virt(phys_addr);
> +	}
> +	return rc;

	if (rc)
		return rc;

	phys_addr = pfn_to_phys(f->pfn) | offset_in_page(gaddr);
	*val = *(unsigned long *)phys_to_virt(phys_addr);

	return 0;

> +}
> +
>  #endif /* __KVM_S390_GACCESS_H */
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 61aa64886c36..af8a62abec48 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4858,6 +4858,50 @@ static void kvm_s390_assert_primary_as(struct kvm_vcpu *vcpu)
>  		current->thread.gmap_int_code, current->thread.gmap_teid.val);
>  }
>  
> +/**
> + * __kvm_s390_faultin_gfn() - fault in and pin a guest address
> + * @kvm: the guest
> + * @guest_fault: will be filled with information on the pin operation
> + * @gfn: guest frame
> + * @wr: if true indicates a write access
> + *
> + * Fault in and pin a guest address using absolute addressing, and without
> + * marking the page referenced.
> + *
> + * Context: Called with mm->mmap_lock in read mode.
> + *
> + * Return:
> + * * 0 in case of success,
> + * * -EFAULT if reading using the virtual address failed,
> + * * -EINTR if a signal is pending,
> + * * -EAGAIN if FOLL_NOWAIT was specified, but IO is needed
> + * * PGM_ADDRESSING if the guest address lies outside of guest memory.
> + */
> +int __kvm_s390_faultin_gfn(struct kvm *kvm, struct guest_fault *guest_fault, gfn_t gfn, bool wr)
> +{
> +	struct kvm_memory_slot *slot;
> +	kvm_pfn_t pfn;
> +	int foll;
> +
> +	foll = wr ? FOLL_WRITE : 0;
> +	slot = gfn_to_memslot(kvm, gfn);
> +	pfn = __kvm_faultin_pfn(slot, gfn, foll, &guest_fault->writable, &guest_fault->page);
> +	if (is_noslot_pfn(pfn))
> +		return PGM_ADDRESSING;
> +	if (is_sigpending_pfn(pfn))
> +		return -EINTR;
> +	if (pfn == KVM_PFN_ERR_NEEDS_IO)
> +		return -EAGAIN;
> +	if (is_error_pfn(pfn))
> +		return -EFAULT;
> +
> +	guest_fault->pfn = pfn;
> +	guest_fault->gfn = gfn;
> +	guest_fault->write_attempt = wr;
> +	guest_fault->valid = true;
> +	return 0;
> +}
> +
>  /*
>   * __kvm_s390_handle_dat_fault() - handle a dat fault for the gmap of a vcpu
>   * @vcpu: the vCPU whose gmap is to be fixed up
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index c44fe0c3a097..dabcf65f58ff 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -22,6 +22,15 @@
>  
>  #define KVM_S390_UCONTROL_MEMSLOT (KVM_USER_MEM_SLOTS + 0)
>  
> +struct guest_fault {
> +	gfn_t gfn;		/* Guest frame */
> +	kvm_pfn_t pfn;		/* Host PFN */
> +	struct page *page;	/* Host page */
> +	bool writable;		/* Mapping is writable */
> +	bool write_attempt;	/* Write access attempted */
> +	bool valid;		/* This entry contains valid data */
> +};
> +
>  static inline void kvm_s390_fpu_store(struct kvm_run *run)
>  {
>  	fpu_stfpc(&run->s.regs.fpc);
> @@ -464,12 +473,59 @@ int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rc, u16 *rrc);
>  int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags);
>  int __kvm_s390_mprotect_many(struct gmap *gmap, gpa_t gpa, u8 npages, unsigned int prot,
>  			     unsigned long bits);
> +int __kvm_s390_faultin_gfn(struct kvm *kvm, struct guest_fault *f, gfn_t gfn, bool wr);
>  
>  static inline int kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gpa_t gaddr, unsigned int flags)
>  {
>  	return __kvm_s390_handle_dat_fault(vcpu, gpa_to_gfn(gaddr), gaddr, flags);
>  }
>  
> +static inline void release_faultin_multiple(struct kvm *kvm, struct guest_fault *guest_faults,
> +					    int n, bool ignore)
> +{
> +	int i;
> +
> +	for (i = 0; i < n; i++) {
> +		kvm_release_faultin_page(kvm, guest_faults[i].page, ignore,
> +					 guest_faults[i].write_attempt);
> +		guest_faults[i].page = NULL;
> +	}
> +}
> +
> +static inline bool __kvm_s390_multiple_faults_need_retry(struct kvm *kvm, unsigned long seq,
> +							 struct guest_fault *guest_faults, int n,
> +							 bool unsafe)
> +{
> +	int i;
> +
> +	for (i = 0; i < n; i++) {
> +		if (!guest_faults[i].valid)
> +			continue;
> +		if ((unsafe && mmu_invalidate_retry_gfn_unsafe(kvm, seq, guest_faults[i].gfn)) ||
> +		    (!unsafe && mmu_invalidate_retry_gfn(kvm, seq, guest_faults[i].gfn))) {
> +			release_faultin_multiple(kvm, guest_faults, n, true);
> +			return true;
> +		}
> +	}
> +	return false;
> +}
> +
> +static inline int __kvm_s390_faultin_gfn_range(struct kvm *kvm, struct guest_fault *guest_faults,
> +					       gfn_t start, int n_pages, bool write_attempt)
> +{
> +	int i, rc = 0;
> +
> +	for (i = 0; !rc && i < n_pages; i++)
> +		rc = __kvm_s390_faultin_gfn(kvm, guest_faults + i, start + i, write_attempt);
> +	return rc;
> +}
> +
> +#define release_faultin_array(kvm, array, ignore) \
> +	release_faultin_multiple(kvm, array, ARRAY_SIZE(array), ignore)
> +
> +#define __kvm_s390_fault_array_needs_retry(kvm, seq, array, unsafe) \
> +	__kvm_s390_multiple_faults_need_retry(kvm, seq, array, ARRAY_SIZE(array), unsafe)
> +
>  /* implemented in diag.c */
>  int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
>  
> -- 
> 2.51.0
> 

