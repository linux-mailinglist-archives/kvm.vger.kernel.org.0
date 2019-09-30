Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59BCCC1E02
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 11:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbfI3JcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 05:32:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34406 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727884AbfI3JcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 05:32:09 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A7F474ACA5
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:32:08 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id r187so7022736wme.0
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 02:32:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Q4nd1VqrkexVmRSFg81KtZVU3uZrT/qwjUj46akeywA=;
        b=oAulbdpZIJFl+G83VAnKDK5Uhb/+3RAw40E85I44nZhRya0ra2wLR+hzq2Yjpg0ctr
         pbAAL6QkyehSJV9LepYUkaEArELGO24GRCIfUs0NnJlBYw/Nud/wEpceCip3zHqnpj3w
         Zs0tdSHGsiInschbO2OzqrDiEw2JI+Zix0ocn7MmXd0VSWfMrm0lZ1PRXbLhC4VRfHTu
         W4r0+g7qVF9TRSLGtyiB9DDSJxQthavxuSWSjbeUdqFbgWa9dXtxGdD0MQJvkkdvu/3x
         lfsY3zNej5bkGoHL0cCaz7S6s918eLeh3WteQiEE/l8h+RzoQLgtrCxwe6shV0su1rZu
         2xQw==
X-Gm-Message-State: APjAAAVh6A8dAedvc40ugO1gp9t2qkhzhdI7eeFe8o6tPJssYUG1xhrm
        6X7xGus8DMXe67Sf+Esemuziw5rIQuqombUCMweq21isLyTcNlUq/SR+hkAZYaXxnIuy8fC0G7R
        WjHA7qct3OEDR
X-Received: by 2002:a1c:c789:: with SMTP id x131mr15947061wmf.20.1569835927234;
        Mon, 30 Sep 2019 02:32:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxMRvwaVSglCh7k1HHTC/fBshrNu99FMxoNh6Q3o9JGUW29VMIvW/NcpH+SRIzTuX/yHmzeEQ==
X-Received: by 2002:a1c:c789:: with SMTP id x131mr15947044wmf.20.1569835926933;
        Mon, 30 Sep 2019 02:32:06 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x5sm10520373wrt.75.2019.09.30.02.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 02:32:06 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v2 7/8] KVM: x86: Add helpers to test/mark reg availability and dirtiness
In-Reply-To: <20190927214523.3376-8-sean.j.christopherson@intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com> <20190927214523.3376-8-sean.j.christopherson@intel.com>
Date:   Mon, 30 Sep 2019 11:32:05 +0200
Message-ID: <87d0fi3zai.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Add helpers to prettify code that tests and/or marks whether or not a
> register is available and/or dirty.
>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/kvm_cache_regs.h | 45 +++++++++++++++++++++++++----------
>  arch/x86/kvm/vmx/nested.c     |  4 ++--
>  arch/x86/kvm/vmx/vmx.c        | 29 ++++++++++------------
>  arch/x86/kvm/x86.c            | 13 ++++------
>  4 files changed, 53 insertions(+), 38 deletions(-)
>
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index b85fc4b4e04f..9c2bc528800b 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -37,12 +37,37 @@ BUILD_KVM_GPR_ACCESSORS(r14, R14)
>  BUILD_KVM_GPR_ACCESSORS(r15, R15)
>  #endif
>  
> +static inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
> +					     enum kvm_reg reg)
> +{
> +	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
> +}
> +

(Interestingly enough, all call sites use !kvm_register_is_available()
but kvm_register_is_unavailable() sounds weird. So I'd prefer to keep it
as-is).

> +static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
> +					 enum kvm_reg reg)
> +{
> +	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
> +}
> +
> +static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
> +					       enum kvm_reg reg)
> +{
> +	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
> +}
> +
> +static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
> +					   enum kvm_reg reg)
> +{
> +	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
> +	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
> +}
> +

Personal preference again, but I would've named this
"kvm_register_mark_avail_dirty" to indicate what we're actually doing
(and maybe even shortened 'kvm_register_' to 'kvm_reg_' everywhere as I
can't see how 'reg' could be misread).

>  static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
>  {
>  	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
>  		return 0;
>  
> -	if (!test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail))
> +	if (!kvm_register_is_available(vcpu, reg))
>  		kvm_x86_ops->cache_reg(vcpu, reg);
>  
>  	return vcpu->arch.regs[reg];
> @@ -55,13 +80,12 @@ static inline void kvm_register_write(struct kvm_vcpu *vcpu, int reg,
>  		return;
>  
>  	vcpu->arch.regs[reg] = val;
> -	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
> -	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
> +	kvm_register_mark_dirty(vcpu, reg);
>  }
>  
>  static inline unsigned long kvm_rip_read(struct kvm_vcpu *vcpu)
>  {
> -	if (!test_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_avail))
> +	if (!kvm_register_is_available(vcpu, VCPU_REGS_RIP))
>  		kvm_x86_ops->cache_reg(vcpu, VCPU_REGS_RIP);
>  
>  	return vcpu->arch.regs[VCPU_REGS_RIP];
> @@ -70,13 +94,12 @@ static inline unsigned long kvm_rip_read(struct kvm_vcpu *vcpu)
>  static inline void kvm_rip_write(struct kvm_vcpu *vcpu, unsigned long val)
>  {
>  	vcpu->arch.regs[VCPU_REGS_RIP] = val;
> -	__set_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_dirty);
> -	__set_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_avail);
> +	kvm_register_mark_dirty(vcpu, VCPU_REGS_RIP);
>  }
>  
>  static inline unsigned long kvm_rsp_read(struct kvm_vcpu *vcpu)
>  {
> -	if (!test_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_avail))
> +	if (!kvm_register_is_available(vcpu, VCPU_REGS_RSP))
>  		kvm_x86_ops->cache_reg(vcpu, VCPU_REGS_RSP);
>  
>  	return vcpu->arch.regs[VCPU_REGS_RSP];
> @@ -85,16 +108,14 @@ static inline unsigned long kvm_rsp_read(struct kvm_vcpu *vcpu)
>  static inline void kvm_rsp_write(struct kvm_vcpu *vcpu, unsigned long val)
>  {
>  	vcpu->arch.regs[VCPU_REGS_RSP] = val;
> -	__set_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_dirty);
> -	__set_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_avail);
> +	kvm_register_mark_dirty(vcpu, VCPU_REGS_RSP);
>  }
>  
>  static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
>  {
>  	might_sleep();  /* on svm */
>  
> -	if (!test_bit(VCPU_EXREG_PDPTR,
> -		      (unsigned long *)&vcpu->arch.regs_avail))
> +	if (!kvm_register_is_available(vcpu, VCPU_EXREG_PDPTR))
>  		kvm_x86_ops->cache_reg(vcpu, VCPU_EXREG_PDPTR);
>  
>  	return vcpu->arch.walk_mmu->pdptrs[index];
> @@ -123,7 +144,7 @@ static inline ulong kvm_read_cr4_bits(struct kvm_vcpu *vcpu, ulong mask)
>  
>  static inline ulong kvm_read_cr3(struct kvm_vcpu *vcpu)
>  {
> -	if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
> +	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
>  		kvm_x86_ops->decache_cr3(vcpu);
>  	return vcpu->arch.cr3;
>  }
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b72a00b53e4a..8946f11c574c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1012,7 +1012,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
>  		kvm_mmu_new_cr3(vcpu, cr3, false);
>  
>  	vcpu->arch.cr3 = cr3;
> -	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
> +	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
>  
>  	kvm_init_mmu(vcpu, false);
>  
> @@ -3986,7 +3986,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
>  
>  	nested_ept_uninit_mmu_context(vcpu);
>  	vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
> -	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
> +	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
>  
>  	/*
>  	 * Use ept_save_pdptrs(vcpu) to load the MMU's cached PDPTRs
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 814d3e6d0264..ed03d0cd1cc8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -721,8 +721,8 @@ static bool vmx_segment_cache_test_set(struct vcpu_vmx *vmx, unsigned seg,
>  	bool ret;
>  	u32 mask = 1 << (seg * SEG_FIELD_NR + field);
>  
> -	if (!(vmx->vcpu.arch.regs_avail & (1 << VCPU_EXREG_SEGMENTS))) {
> -		vmx->vcpu.arch.regs_avail |= (1 << VCPU_EXREG_SEGMENTS);
> +	if (!kvm_register_is_available(&vmx->vcpu, VCPU_EXREG_SEGMENTS)) {
> +		kvm_register_mark_available(&vmx->vcpu, VCPU_EXREG_SEGMENTS);
>  		vmx->segment_cache.bitmask = 0;
>  	}
>  	ret = vmx->segment_cache.bitmask & mask;
> @@ -1410,8 +1410,8 @@ unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long rflags, save_rflags;
>  
> -	if (!test_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail)) {
> -		__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
> +	if (!kvm_register_is_available(vcpu, VCPU_EXREG_RFLAGS)) {
> +		kvm_register_mark_available(vcpu, VCPU_EXREG_RFLAGS);
>  		rflags = vmcs_readl(GUEST_RFLAGS);
>  		if (vmx->rmode.vm86_active) {
>  			rflags &= RMODE_GUEST_OWNED_EFLAGS_BITS;
> @@ -1429,7 +1429,7 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>  	unsigned long old_rflags;
>  
>  	if (enable_unrestricted_guest) {
> -		__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
> +		kvm_register_mark_available(vcpu, VCPU_EXREG_RFLAGS);
>  
>  		vmx->rflags = rflags;
>  		vmcs_writel(GUEST_RFLAGS, rflags);
> @@ -2175,7 +2175,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  
>  static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
>  {
> -	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
> +	kvm_register_mark_available(vcpu, reg);
> +
>  	switch (reg) {
>  	case VCPU_REGS_RSP:
>  		vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
> @@ -2862,7 +2863,7 @@ static void vmx_decache_cr3(struct kvm_vcpu *vcpu)
>  {
>  	if (enable_unrestricted_guest || (enable_ept && is_paging(vcpu)))
>  		vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
> -	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
> +	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
>  }
>  
>  static void vmx_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
> @@ -2877,8 +2878,7 @@ static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
>  
> -	if (!test_bit(VCPU_EXREG_PDPTR,
> -		      (unsigned long *)&vcpu->arch.regs_dirty))
> +	if (!kvm_register_is_dirty(vcpu, VCPU_EXREG_PDPTR))
>  		return;
>  
>  	if (is_pae_paging(vcpu)) {
> @@ -2900,10 +2900,7 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
>  		mmu->pdptrs[3] = vmcs_read64(GUEST_PDPTR3);
>  	}
>  
> -	__set_bit(VCPU_EXREG_PDPTR,
> -		  (unsigned long *)&vcpu->arch.regs_avail);
> -	__set_bit(VCPU_EXREG_PDPTR,
> -		  (unsigned long *)&vcpu->arch.regs_dirty);
> +	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
>  }
>  
>  static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
> @@ -2912,7 +2909,7 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> -	if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
> +	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
>  		vmx_decache_cr3(vcpu);
>  	if (!(cr0 & X86_CR0_PG)) {
>  		/* From paging/starting to nonpaging */
> @@ -6528,9 +6525,9 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (vmx->nested.need_vmcs12_to_shadow_sync)
>  		nested_sync_vmcs12_to_shadow(vcpu);
>  
> -	if (test_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_dirty))
> +	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RSP))
>  		vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
> -	if (test_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_dirty))
> +	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RIP))
>  		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
>  
>  	cr3 = __get_current_cr3_fast();
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0ed07d8d2caa..cd6bd7991c39 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -709,10 +709,8 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
>  	ret = 1;
>  
>  	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
> -	__set_bit(VCPU_EXREG_PDPTR,
> -		  (unsigned long *)&vcpu->arch.regs_avail);
> -	__set_bit(VCPU_EXREG_PDPTR,
> -		  (unsigned long *)&vcpu->arch.regs_dirty);
> +	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> +
>  out:
>  
>  	return ret;
> @@ -730,8 +728,7 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
>  	if (!is_pae_paging(vcpu))
>  		return false;
>  
> -	if (!test_bit(VCPU_EXREG_PDPTR,
> -		      (unsigned long *)&vcpu->arch.regs_avail))
> +	if (!kvm_register_is_available(vcpu, VCPU_EXREG_PDPTR))
>  		return true;
>  
>  	gfn = (kvm_read_cr3(vcpu) & 0xffffffe0ul) >> PAGE_SHIFT;
> @@ -976,7 +973,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  
>  	kvm_mmu_new_cr3(vcpu, cr3, skip_tlb_flush);
>  	vcpu->arch.cr3 = cr3;
> -	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
> +	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
>  
>  	return 0;
>  }
> @@ -8766,7 +8763,7 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  	vcpu->arch.cr2 = sregs->cr2;
>  	mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
>  	vcpu->arch.cr3 = sregs->cr3;
> -	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
> +	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
>  
>  	kvm_set_cr8(vcpu, sregs->cr8);

-- 
Vitaly
