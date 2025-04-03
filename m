Return-Path: <kvm+bounces-42606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6AA5A7B03A
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:11:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 427AA3B69F5
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB69254B17;
	Thu,  3 Apr 2025 20:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gATDW9Ax"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4AD253B59
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743710928; cv=none; b=Pxq+pUcbKtWHiCPEvZQ7sM9gBXJPKSUAobTI8C6dUYfR/olXye9w6PZv3lSTVgjpRjmwFh1rPVo6XYd8p8dkCbDONtwBkvmamFQPPhzFOA0nVmtZs/9pjDoQrDK4p2oq4dRaHm5TuKwqcrmP5nBiMdKzZ2dv4JIaydOH5eRtX0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743710928; c=relaxed/simple;
	bh=a6PmLn89ERhOga+OXGNgTpjRWan0ugOFJZI/1p+bLTU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ckWsv1ofqHm77v7m0yPGSaSprLWbOohfPyI0ozeiMVBso9adtsAbhvS6R4tNr7SO3wY9EazteL8b8+5Cfa/BPUXnACPTg+MoSzLhO+Tm2xYG/n7GE/2gVDydjtyxDxAi/mNTD8TwfnSJHMplh+pxEtcDWVQgR+ozx7zKFP0zzzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gATDW9Ax; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743710925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AMdPiGCwBwyxjjhmF4H8jrNRbe8gVzShRFf5L7XIVW4=;
	b=gATDW9AxtuR49sMi1T8qjyaSjL3U70KAUqqlfaqBrfzWaSWSQEpTx6P01smDNpu2/AL8Bw
	ozb+7GkTJNAsbQ1ZvpgYU0FDi4NFWaIajydBwtROIL0oNAmReqDmez7uA14czbbB4KnwB/
	GfmeJTygzwyFwmqVo90PFHg2utgHDvk=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-MyfcJai2Oj6Dn333HiLQsA-1; Thu, 03 Apr 2025 16:05:43 -0400
X-MC-Unique: MyfcJai2Oj6Dn333HiLQsA-1
X-Mimecast-MFC-AGG-ID: MyfcJai2Oj6Dn333HiLQsA_1743710743
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-523fd94a77cso368665e0c.0
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:05:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743710743; x=1744315543;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AMdPiGCwBwyxjjhmF4H8jrNRbe8gVzShRFf5L7XIVW4=;
        b=ESrDxurTj5dCcUZUkJIxtAL7SI+JEil2yA0VNUJ+vWmDtwnlWGd94BUjZQNbT+13Zn
         Af7wH2X+dtN1BdQQASOwCDeuWvQEH/lW9kUv9LhtugSmf+xYJJ9dHq/cVZNhDqRmueE1
         5XP+XADS1VkJzJHalLCA+42E1eyhW4v1mPsOJKp7Zp8AHoFYM/uwc/QZ5SaNeplMpjua
         Ez28qj594Pd20HtBBrcf+8wnl77nrl61g8jhTSdUWiPK3CgNrQ+SCngoffX7eKo9PtC6
         qiznzcMw27CEOPskIik5/qfFZlxyeAMsk8qVrpFpWDAyLKDYMUt2ImQH9oFeD06NdHMv
         ZQDg==
X-Forwarded-Encrypted: i=1; AJvYcCVjVeBFGr+Vy/cuScdrWefhygcBbQI9ELqaDz8s5e8KUDrdV1meI/AbW6qgDAic/w1RPIE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLy8+65q0yXnJkmlwktvgTbrFetOYvR7Mc+PFOnWqCwMVNwWkD
	AVuTP4Q3OXMqeujrBayUBAjBJqKU+I94LmMMaH6qaCaqtm28sM+5WA9Tgxu3D6zo2TPaeXa0EwJ
	JY/t+J+0ha9x4lM0V7y7wn8Cs0uul5cP/on09yZp1vF9wudUtww==
X-Gm-Gg: ASbGncuMf2J/090gVSHXiivsvq4p4MiTks0InDdyciNodsc+n/16zCBbOkyCE5RotOe
	piQxx62Ec79nJZMwjYoUqjRVuLGRIcbETWEriIU6ZSTqnwmqEuTKtWjvYd8Bbkj121GLNKFSYaz
	LtLDYvT6dN541wjJZORnvOqtUnizXa97sVSE/h5o8IJf+XW/z6/scIQobeE0CFfRKvmwWAp8OLh
	wr37vR9txTVNnYDLU588lp7TrxZ0FD6Mj9l93F4q0sgNhx3sfnKR62GTcM/7GSKD9iCEwhlC4CR
	ylOiG6EpldWW43Y=
X-Received: by 2002:a05:6122:308c:b0:526:1ddd:7603 with SMTP id 71dfb90a1353d-52764304316mr926606e0c.0.1743710743080;
        Thu, 03 Apr 2025 13:05:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSU/qa7mg6Eyfdk4tink6anfEVjTIh1AUjXc3ShX9qRAetdvhWb4CdVefyKkYNl8YjqlOh+Q==
X-Received: by 2002:a05:6122:308c:b0:526:1ddd:7603 with SMTP id 71dfb90a1353d-52764304316mr926553e0c.0.1743710742630;
        Thu, 03 Apr 2025 13:05:42 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5275ae30c1fsm422070e0c.14.2025.04.03.13.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:05:42 -0700 (PDT)
Message-ID: <3d54470accbfdb27b14ec6f0afdb9180ae43d1a6.camel@redhat.com>
Subject: Re: [RFC PATCH 10/24] KVM: SVM: Use a single ASID per VM
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:05:41 -0400
In-Reply-To: <20250326193619.3714986-11-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326193619.3714986-11-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-03-26 at 19:36 +0000, Yosry Ahmed wrote:
> The ASID generation and dynamic ASID allocation logic is now only used
> by initialization the generation to 0 to trigger a new ASID allocation
> per-vCPU on the first VMRUN, so the ASID is more-or-less static
> per-vCPU.
> 
> Moreover, having a unique ASID per-vCPU is not required. ASIDs are local
> to each physical CPU, and the ASID is flushed when a vCPU is migrated to
> a new physical CPU anyway. SEV VMs have been using a single ASID per VM
> already for other reasons.
> 
> Use a static ASID per VM and drop the dynamic ASID allocation logic. The
> ASID is allocated during vCPU reset (SEV allocates its own ASID), and
> the ASID is always flushed on first use in case it was used by another
> VM previously.
> 
> The existing check for whether the ASID in the VMCB matches the per-vCPU
> ASID is turned into a WARN because it is not expected behavior anymore,
> and is moved from svm_vcpu_run() to pre_svm_run() such that it's not
> checked for SEV guests. The check does not apply as-is for SEV, and a
> separate check is added in pre_sev_run() instead. These checks will be
> consolidated (among other code) in a followup change.
> 
> As ASIDs cannot be disabled (like how VPIDs can be disabled on Intel),
> handle ASID allocation failure by falling back to a single shared ASID
> allocated during hardware setup. This ASID is flushed on every VMRUN if
> it is in use to avoid sharing TLB entries between different guests. This
> should be unlikely with modern AMD CPUs as they have over 32k ASIDs.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c |   3 +-
>  arch/x86/kvm/svm/svm.c    | 129 ++++++++++++++++++++++----------------
>  arch/x86/kvm/svm/svm.h    |  10 +--
>  3 files changed, 80 insertions(+), 62 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 11b02a0340d9e..81184b2fb27fd 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -677,8 +677,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
>  	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
>  	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
> -
> -	/* Done at vmrun: asid.  */
> +	vmcb02->control.asid = svm_asid(vcpu->kvm);
>  
>  	/* Also overwritten later if necessary.  */
>  	vmcb_clr_flush_asid(vmcb02);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b740114a9d9bc..f028d006f69dc 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -249,6 +249,9 @@ static unsigned long iopm_base;
>  
>  DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
>  
> +static struct kvm_tlb_tags svm_asids;
> +static unsigned int fallback_asid;
> +
>  /*
>   * Only MSR_TSC_AUX is switched via the user return hook.  EFER is switched via
>   * the VMCB, and the SYSCALL/SYSENTER MSRs are handled by VMLOAD/VMSAVE.
> @@ -621,10 +624,6 @@ static int svm_enable_virtualization_cpu(void)
>  		return -EBUSY;
>  
>  	sd = per_cpu_ptr(&svm_data, me);
> -	sd->asid_generation = 1;
> -	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
> -	sd->next_asid = sd->max_asid + 1;
> -	sd->min_asid = max_sev_asid + 1;
>  
>  	wrmsrl(MSR_EFER, efer | EFER_SVME);
>  
> @@ -1119,6 +1118,7 @@ static void svm_hardware_unsetup(void)
>  
>  	__free_pages(__sme_pa_to_page(iopm_base), get_order(IOPM_SIZE));
>  	iopm_base = 0;
> +	kvm_tlb_tags_destroy(&svm_asids);
>  }
>  
>  static void init_seg(struct vmcb_seg *seg)
> @@ -1225,6 +1225,20 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +unsigned int svm_asid(struct kvm *kvm)
> +{
> +	return to_kvm_svm(kvm)->asid;
> +}
> +
> +static unsigned int svm_get_current_asid(struct vcpu_svm *svm)
> +{
> +	struct kvm *kvm = svm->vcpu.kvm;
> +
> +	if (sev_guest(kvm))
> +		return sev_get_asid(kvm);
> +	return svm_asid(kvm);
> +}
> +
>  static void init_vmcb(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -1300,6 +1314,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  	control->iopm_base_pa = iopm_base;
>  	control->msrpm_base_pa = __sme_set(__pa(svm->msrpm));
>  	control->int_ctl = V_INTR_MASKING_MASK;
> +	control->asid = svm_asid(vcpu->kvm);
> +	vmcb_set_flush_asid(svm->vmcb);
>  
>  	init_seg(&save->es);
>  	init_seg(&save->ss);
> @@ -1332,8 +1348,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  		save->g_pat = vcpu->arch.pat;
>  		save->cr3 = 0;
>  	}
> -	svm->current_vmcb->asid_generation = 0;
> -	svm->asid = 0;
>  
>  	svm->nested.vmcb12_gpa = INVALID_GPA;
>  	svm->nested.last_vmcb12_gpa = INVALID_GPA;
> @@ -1547,9 +1561,9 @@ static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)
>  
>  static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
> -	unsigned int asid;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
> +	unsigned int asid = svm_get_current_asid(svm);
>  	struct kvm_vcpu *prev;
>  
>  	if (vcpu->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
> @@ -1564,17 +1578,14 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	if (kvm_vcpu_apicv_active(vcpu))
>  		avic_vcpu_load(vcpu, cpu);
>  
> -	if (sev_guest(vcpu->kvm)) {
> -		/*
> -		 * Flush the TLB when a different vCPU using the same ASID is
> -		 * run on the same CPU. xa_store() should always succeed because
> -		 * the entry is reserved when the ASID is allocated.
> -		 */
> -		asid = sev_get_asid(vcpu->kvm);
> -		prev = xa_store(&sd->asid_vcpu, asid, vcpu, GFP_ATOMIC);
> -		if (prev != vcpu || WARN_ON_ONCE(xa_err(prev)))
> -			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> -	}
> +	/*
> +	 * Flush the TLB when a different vCPU using the same ASID is
> +	 * run on the same CPU. xa_store() should always succeed because
> +	 * the entry is reserved when the ASID is allocated.
> +	 */
> +	prev = xa_store(&sd->asid_vcpu, asid, vcpu, GFP_ATOMIC);
> +	if (prev != vcpu || WARN_ON_ONCE(xa_err(prev)))
> +		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>  }
>  
>  static void svm_vcpu_put(struct kvm_vcpu *vcpu)
> @@ -1989,19 +2000,6 @@ static void svm_update_exception_bitmap(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
> -{
> -	if (sd->next_asid > sd->max_asid) {
> -		++sd->asid_generation;
> -		sd->next_asid = sd->min_asid;
> -		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
> -		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
> -	}
> -
> -	svm->current_vmcb->asid_generation = sd->asid_generation;
> -	svm->asid = sd->next_asid++;
> -}
> -
>  static void svm_set_dr6(struct kvm_vcpu *vcpu, unsigned long value)
>  {
>  	struct vmcb *vmcb = to_svm(vcpu)->vmcb;
> @@ -3629,8 +3627,16 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  
>  static int pre_svm_run(struct kvm_vcpu *vcpu)
>  {
> -	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	unsigned int asid = svm_get_current_asid(svm);
> +
> +	/*
> +	 * Reject KVM_RUN if userspace attempts to run the vCPU with an invalid
> +	 * VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after an SNP
> +	 * AP Destroy event.
> +	 */
> +	if (sev_es_guest(vcpu->kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa))
> +		return -EINVAL;
>  
>  	/*
>  	 * If the previous VMRUN of the VMCB occurred on a different physical
> @@ -3643,25 +3649,20 @@ static int pre_svm_run(struct kvm_vcpu *vcpu)
>  		svm->current_vmcb->cpu = vcpu->cpu;
>          }
>  
> -	if (sev_guest(vcpu->kvm)) {
> -		/* Assign the asid allocated with this SEV guest */
> -		svm->asid = sev_get_asid(vcpu->kvm);
> +	/*
> +	 * If we run out of space and ASID allocation fails, we fallback to a
> +	 * shared fallback ASID. For that ASID, we need to flush the TLB on
> +	 * every VMRUN to avoid sharing TLB entries between different guests.
> +	 */
> +	if (unlikely(asid == fallback_asid))
> +		vmcb_set_flush_asid(svm->vmcb);
>  
> -		/*
> -		 * Reject KVM_RUN if userspace attempts to run the vCPU with an invalid
> -		 * VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after an SNP
> -		 * AP Destroy event.
> -		 */
> -		if (sev_es_guest(vcpu->kvm) &&
> -		    !VALID_PAGE(svm->vmcb->control.vmsa_pa))
> -			return -EINVAL;
> -		return 0;
> +	if (WARN_ON_ONCE(svm->vmcb->control.asid != asid)) {
> +		vmcb_set_flush_asid(svm->vmcb);
> +		svm->vmcb->control.asid = asid;
> +		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
>  	}
>  
> -	/* FIXME: handle wraparound of asid_generation */
> -	if (svm->current_vmcb->asid_generation != sd->asid_generation)
> -		new_asid(svm, sd);
> -
>  	return 0;
>  }
>  
> @@ -4062,7 +4063,7 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	invlpga(gva, svm->vmcb->control.asid);
> +	invlpga(gva, svm_get_current_asid(svm));
>  }
>  
>  static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
> @@ -4308,10 +4309,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>  
>  	sync_lapic_to_cr8(vcpu);
>  
> -	if (unlikely(svm->asid != svm->vmcb->control.asid)) {
> -		svm->vmcb->control.asid = svm->asid;
> -		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
> -	}
>  	svm->vmcb->save.cr2 = vcpu->arch.cr2;
>  
>  	svm_hv_update_vp_id(svm->vmcb, vcpu);
> @@ -5073,13 +5070,18 @@ bool svm_register_asid(unsigned int asid)
>  
>  static void svm_vm_destroy(struct kvm *kvm)
>  {
> +	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
> +
>  	avic_vm_destroy(kvm);
>  	sev_vm_destroy(kvm);
> +	kvm_tlb_tags_free(&svm_asids, kvm_svm->asid);
>  }
>  
>  static int svm_vm_init(struct kvm *kvm)
>  {
> +	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
>  	int type = kvm->arch.vm_type;
> +	unsigned int asid;
>  
>  	if (type != KVM_X86_DEFAULT_VM &&
>  	    type != KVM_X86_SW_PROTECTED_VM) {
> @@ -5100,6 +5102,13 @@ static int svm_vm_init(struct kvm *kvm)
>  			return ret;
>  	}
>  
> +	asid = kvm_tlb_tags_alloc(&svm_asids);
> +	if (asid && !svm_register_asid(asid)) {
> +		kvm_tlb_tags_free(&svm_asids, asid);
> +		asid = 0;
> +	}
> +	kvm_svm->asid = asid ?: fallback_asid;
> +
>  	return 0;
>  }
>  
> @@ -5381,6 +5390,7 @@ static __init int svm_hardware_setup(void)
>  	void *iopm_va;
>  	int r;
>  	unsigned int order = get_order(IOPM_SIZE);
> +	unsigned int min_asid, max_asid;
>  
>  	/*
>  	 * NX is required for shadow paging and for NPT if the NX huge pages
> @@ -5473,6 +5483,13 @@ static __init int svm_hardware_setup(void)
>  	 */
>  	sev_hardware_setup();
>  
> +	/* Consumes max_sev_asid initialized by sev_hardware_setup() */
> +	min_asid = max_sev_asid + 1;
> +	max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
> +	r = kvm_tlb_tags_init(&svm_asids, min_asid, max_asid);
> +	if (r)
> +		goto err;
> +
>  	svm_hv_hardware_setup();
>  
>  	for_each_possible_cpu(cpu) {
> @@ -5481,6 +5498,12 @@ static __init int svm_hardware_setup(void)
>  			goto err;
>  	}
>  
> +	fallback_asid = kvm_tlb_tags_alloc(&svm_asids);
> +	WARN_ON_ONCE(!fallback_asid);

Nitpick: This really can't happen unless there is some very bad bug lurking somewhere.
And if this happens, nothing will work, since likely that regular ASID allocation
will fail too.

So why not to fail svm_hardware_setup instead?


> +
> +	/* Needs to be after svm_cpu_init() initializes the per-CPU xarrays */
> +	svm_register_asid(fallback_asid);
> +
>  	enable_apicv = avic = avic && avic_hardware_setup();
>  
>  	if (!enable_apicv) {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 4929b96d3d700..436b7e83141b9 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -117,6 +117,8 @@ struct kvm_sev_info {
>  struct kvm_svm {
>  	struct kvm kvm;
>  
> +	unsigned int asid;
> +
>  	/* Struct members for AVIC */
>  	u32 avic_vm_id;
>  	struct page *avic_logical_id_table_page;
> @@ -132,7 +134,6 @@ struct kvm_vmcb_info {
>  	struct vmcb *ptr;
>  	unsigned long pa;
>  	int cpu;
> -	uint64_t asid_generation;
>  };
>  
>  struct vmcb_save_area_cached {
> @@ -247,7 +248,6 @@ struct vcpu_svm {
>  	struct vmcb *vmcb;
>  	struct kvm_vmcb_info vmcb01;
>  	struct kvm_vmcb_info *current_vmcb;
> -	u32 asid;
>  	u32 sysenter_esp_hi;
>  	u32 sysenter_eip_hi;
>  	uint64_t tsc_aux;
> @@ -330,11 +330,6 @@ struct vcpu_svm {
>  };
>  
>  struct svm_cpu_data {
> -	u64 asid_generation;
> -	u32 max_asid;
> -	u32 next_asid;
> -	u32 min_asid;
> -
>  	struct vmcb *save_area;
>  	unsigned long save_area_pa;
>  
> @@ -656,6 +651,7 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
>  				     int trig_mode, int vec);
>  bool svm_register_asid(unsigned int asid);
>  void svm_unregister_asid(unsigned int asid);
> +unsigned int svm_asid(struct kvm *kvm);
>  
>  /* nested.c */
>  

Overall looks good to me.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




