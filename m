Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E9F229E0D
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 19:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbgGVRLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 13:11:37 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21753 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726907AbgGVRLg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 13:11:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595437894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jgHkAgpp92rw0Wj8bzn64y2E1QZKk8swHW8VX3GHDZI=;
        b=Y+usRtI5SkXdU5VKbziU7IxULwLqDW7xSHisib6qzgcxmjels5XPVbSpL99nscOCPmerCK
        u2a7ztyDZchu85LMX/thgUz2ZrxSNEc0cC8tHz02DnAlE5qfg5RA8A15HDJ7QBcMw77CJT
        qMMee8wckuwr+dnsJE3LiFeZkz70fu0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-sg_9OhiVNLOQYKRLcueQZg-1; Wed, 22 Jul 2020 13:11:31 -0400
X-MC-Unique: sg_9OhiVNLOQYKRLcueQZg-1
Received: by mail-ed1-f70.google.com with SMTP id da18so991263edb.13
        for <kvm@vger.kernel.org>; Wed, 22 Jul 2020 10:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=jgHkAgpp92rw0Wj8bzn64y2E1QZKk8swHW8VX3GHDZI=;
        b=H3ZK/jWOkCejOtk1Mw/04uoINR9MHVh/HVW6beA9JHjRWZzg8xZ4kj/bc6FNG5WSyI
         jKVzLT7ZQJ1kkAAj/cVcL9sfpEKkhSEnrsbFrTmc18yVp6Ub7VWoiSF4dlFZOvqLNiP3
         ELnqIw3syUwT50ZXxDWpzhMPmnM060dESGvC8Q7iHkB+s9ZxWa0QIb33FvCJTmu40PYb
         ZKHkGIRWoZlPw76MnTGoyM0XfRSAdcCCxOIV8XJkSvvZBmWy3Y4MOCI3dZG9Jr8TCbmd
         T+nmM4xLvWWzE3EomCQQWXlBQdfYoExTr9v8QnnAemht6G4aZr5InQVYO4Zct49WBp7W
         zBvQ==
X-Gm-Message-State: AOAM533bOaC+L3h6zB+MyQPZrDke4cYHcDYwn8pztwJf+tdWhBkqK2qD
        hPujmz6Y6+Cf40P0eliy4kM7oK0q44XfjIGX+p0MivjhZXsv0YVz77T+jsz2jYoDvmnYSqHrpup
        xwrixJS62oKGV
X-Received: by 2002:a17:906:365a:: with SMTP id r26mr584689ejb.52.1595437889695;
        Wed, 22 Jul 2020 10:11:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIDQvaBXZjm8+nbGJrQMnFZKRGvGcs/2efdjyAdlvhOm2XaFuaDCx8DZIlSecIFUl/fN/0gw==
X-Received: by 2002:a17:906:365a:: with SMTP id r26mr584662ejb.52.1595437889370;
        Wed, 22 Jul 2020 10:11:29 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p4sm150601eji.123.2020.07.22.10.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 10:11:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] KVM: x86: Pull the PGD's level from the MMU instead of recalculating it
In-Reply-To: <20200716034122.5998-6-sean.j.christopherson@intel.com>
References: <20200716034122.5998-1-sean.j.christopherson@intel.com> <20200716034122.5998-6-sean.j.christopherson@intel.com>
Date:   Wed, 22 Jul 2020 19:11:26 +0200
Message-ID: <871rl3pj9d.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use the shadow_root_level from the current MMU as the root level for the
> PGD, i.e. for VMX's EPTP.  This eliminates the weird dependency between
> VMX and the MMU where both must independently calculate the same root
> level for things to work correctly.  Temporarily keep VMX's calculation
> of the level and use it to WARN if the incoming level diverges.
>
> Opportunistically refactor kvm_mmu_load_pgd() to avoid indentation hell,
> and rename a 'cr3' param in the load_mmu_pgd prototype that managed to
> survive the cr3 purge.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ++-
>  arch/x86/kvm/mmu.h              | 10 +++++++---
>  arch/x86/kvm/svm/svm.c          |  3 ++-
>  arch/x86/kvm/vmx/nested.c       |  2 +-
>  arch/x86/kvm/vmx/vmx.c          | 18 ++++++++++++------
>  arch/x86/kvm/vmx/vmx.h          |  3 ++-
>  6 files changed, 26 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1bab87a444d78..ce60f4c38843f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1136,7 +1136,8 @@ struct kvm_x86_ops {
>  	int (*get_tdp_level)(struct kvm_vcpu *vcpu);
>  	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
>  
> -	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, unsigned long cr3);
> +	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, unsigned long pgd,
> +			     int pgd_level);
>  
>  	bool (*has_wbinvd_exit)(void);
>  
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 9f6554613babc..5efc6081ca138 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -90,9 +90,13 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
>  
>  static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>  {
> -	if (VALID_PAGE(vcpu->arch.mmu->root_hpa))
> -		kvm_x86_ops.load_mmu_pgd(vcpu, vcpu->arch.mmu->root_hpa |
> -					       kvm_get_active_pcid(vcpu));
> +	u64 root_hpa = vcpu->arch.mmu->root_hpa;
> +
> +	if (!VALID_PAGE(root_hpa))
> +		return;
> +
> +	kvm_x86_ops.load_mmu_pgd(vcpu, root_hpa | kvm_get_active_pcid(vcpu),
> +				 vcpu->arch.mmu->shadow_root_level);
>  }
>  
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 783330d0e7b88..c70d7dd333061 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3541,7 +3541,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  	return exit_fastpath;
>  }
>  
> -static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root)
> +static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
> +			     int root_level)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	unsigned long cr3;
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4d561edf6f9ca..50b56622e16a6 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2162,7 +2162,7 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
>  	 * consistency checks.
>  	 */
>  	if (enable_ept && nested_early_check)
> -		vmcs_write64(EPT_POINTER, construct_eptp(&vmx->vcpu, 0));
> +		vmcs_write64(EPT_POINTER, construct_eptp(&vmx->vcpu, 0, 4));

Nit: could we use MMU's PT64_ROOT_4LEVEL instead of '4' here?

>  
>  	/* All VMFUNCs are currently emulated through L0 vmexits.  */
>  	if (cpu_has_vmx_vmfunc())
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 791baa73e5786..244053cff0a3a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2933,14 +2933,16 @@ static void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
>  
>  static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
>  {
> -	u64 root_hpa = vcpu->arch.mmu->root_hpa;
> +	struct kvm_mmu *mmu = vcpu->arch.mmu;
> +	u64 root_hpa = mmu->root_hpa;
>  
>  	/* No flush required if the current context is invalid. */
>  	if (!VALID_PAGE(root_hpa))
>  		return;
>  
>  	if (enable_ept)
> -		ept_sync_context(construct_eptp(vcpu, root_hpa));
> +		ept_sync_context(construct_eptp(vcpu, root_hpa,
> +						mmu->shadow_root_level));
>  	else if (!is_guest_mode(vcpu))
>  		vpid_sync_context(to_vmx(vcpu)->vpid);
>  	else
> @@ -3078,11 +3080,12 @@ static int get_ept_level(struct kvm_vcpu *vcpu)
>  	return vmx_get_tdp_level(vcpu);
>  }
>  
> -u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa)
> +u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa,
> +		   int root_level)
>  {
>  	u64 eptp = VMX_EPTP_MT_WB;
>  
> -	eptp |= (get_ept_level(vcpu) == 5) ? VMX_EPTP_PWL_5 : VMX_EPTP_PWL_4;
> +	eptp |= (root_level == 5) ? VMX_EPTP_PWL_5 : VMX_EPTP_PWL_4;
>  
>  	if (enable_ept_ad_bits &&
>  	    (!is_guest_mode(vcpu) || nested_ept_ad_enabled(vcpu)))
> @@ -3092,7 +3095,8 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa)
>  	return eptp;
>  }
>  
> -static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd)
> +static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
> +			     int pgd_level)
>  {
>  	struct kvm *kvm = vcpu->kvm;
>  	bool update_guest_cr3 = true;
> @@ -3100,7 +3104,9 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd)
>  	u64 eptp;
>  
>  	if (enable_ept) {
> -		eptp = construct_eptp(vcpu, pgd);
> +		WARN_ON(pgd_level != get_ept_level(vcpu));
> +
> +		eptp = construct_eptp(vcpu, pgd, pgd_level);
>  		vmcs_write64(EPT_POINTER, eptp);
>  
>  		if (kvm_x86_ops.tlb_remote_flush) {
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 3c55433ac1b21..26175a4759fa5 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -341,7 +341,8 @@ void set_cr4_guest_host_mask(struct vcpu_vmx *vmx);
>  void ept_save_pdptrs(struct kvm_vcpu *vcpu);
>  void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
>  void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
> -u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa);
> +u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa,
> +		   int root_level);
>  void update_exception_bitmap(struct kvm_vcpu *vcpu);
>  void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);
>  bool vmx_nmi_blocked(struct kvm_vcpu *vcpu);

-- 
Vitaly

