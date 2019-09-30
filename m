Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD8CCC1FA5
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 12:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730889AbfI3K66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 06:58:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60872 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730621AbfI3K66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 06:58:58 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 65B8DC04BD48
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 10:58:57 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id v18so4331971wro.16
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 03:58:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=j0qxT1IXvt9wIAlUjN9ddY7lEd1GUitjNHLdt8EqWYQ=;
        b=I5fXtCODibgMo4EIDnUCKgIA2BhRUTjPL2VOGNhGDPHRaMNIQ3hdaN8iDXHhz8Un4O
         gCN0BJnsDwYUHaJI0VL3IUSyjpYXFgE3u38WAhdLnBVj+haUaD81Rb7Qusg4kF0jhhvb
         fxyMkj6gzQ2DQibiR6Z9Zb95g7PHXxwQqd4Nv+dGwHJGo2zC/kB+J7bFPh07EzFsSFZp
         DmScm5qkMG7R+TnJGFQxfKkUSqOul4zShEEDKGRIx8KvqxtDQos5OZZoiJHcoyUHceX8
         0MGXY1t//pU4mwM1Ht6z6fFetO17cxWh7iy3A+PQhCnKPgMxNHn2qa7V/Gjoy+fTQdKL
         HlPQ==
X-Gm-Message-State: APjAAAWvt/s5vLj47K5TYKJkQTa6jGkpyN+qBHl6iVHkkoEDxZKcelrT
        C8mUtfMEeZ1WtMSrtAKM8uiCbIO5YY8R24L/ei6J8iblh8h0wbiCge08wCeQmvV0fMcdJvS3suX
        sx075pd/I8HXN
X-Received: by 2002:adf:ff8a:: with SMTP id j10mr13252877wrr.334.1569841135513;
        Mon, 30 Sep 2019 03:58:55 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxHekuj02R8XtQy2iPD4+dRVTghrwvfXckbudnn8NOFFGFICy/+KtRZsKtOcn3qGWRNQi1jjw==
X-Received: by 2002:adf:ff8a:: with SMTP id j10mr13252857wrr.334.1569841135272;
        Mon, 30 Sep 2019 03:58:55 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b194sm35531293wmg.46.2019.09.30.03.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 03:58:54 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 8/8] KVM: x86: Fold decache_cr3() into cache_reg()
In-Reply-To: <20190927214523.3376-9-sean.j.christopherson@intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com> <20190927214523.3376-9-sean.j.christopherson@intel.com>
Date:   Mon, 30 Sep 2019 12:58:53 +0200
Message-ID: <87a7am3v9u.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Handle caching CR3 (from VMX's VMCS) into struct kvm_vcpu via the common
> cache_reg() callback and drop the dedicated decache_cr3().  The name
> decache_cr3() is somewhat confusing as the caching behavior of CR3
> follows that of GPRs, RFLAGS and PDPTRs, (handled via cache_reg()), and
> has nothing in common with the caching behavior of CR0/CR4 (whose
> decache_cr{0,4}_guest_bits() likely provided the 'decache' verbiage).
>
> Note, this effectively adds a BUG() if KVM attempts to cache CR3 on SVM.
> Opportunistically add a WARN_ON_ONCE() in VMX to provide an equivalent
> check.

Just to justify my idea of replacing such occasions with
KVM_INTERNAL_ERROR by setting a special 'kill ASAP' bit somewhere:

This WARN_ON_ONCE() falls in the same category (IMO).

>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/kvm_cache_regs.h   |  2 +-
>  arch/x86/kvm/svm.c              |  5 -----
>  arch/x86/kvm/vmx/vmx.c          | 15 ++++++---------
>  4 files changed, 7 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a27f7f6b6b7a..0411dc0a27b0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1040,7 +1040,6 @@ struct kvm_x86_ops {
>  			    struct kvm_segment *var, int seg);
>  	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
>  	void (*decache_cr0_guest_bits)(struct kvm_vcpu *vcpu);
> -	void (*decache_cr3)(struct kvm_vcpu *vcpu);
>  	void (*decache_cr4_guest_bits)(struct kvm_vcpu *vcpu);
>  	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
>  	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 9c2bc528800b..f18177cd0030 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -145,7 +145,7 @@ static inline ulong kvm_read_cr4_bits(struct kvm_vcpu *vcpu, ulong mask)
>  static inline ulong kvm_read_cr3(struct kvm_vcpu *vcpu)
>  {
>  	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
> -		kvm_x86_ops->decache_cr3(vcpu);
> +		kvm_x86_ops->cache_reg(vcpu, VCPU_EXREG_CR3);
>  	return vcpu->arch.cr3;
>  }
>  
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index f8ecb6df5106..3102c44c12c6 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2517,10 +2517,6 @@ static void svm_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
>  {
>  }
>  
> -static void svm_decache_cr3(struct kvm_vcpu *vcpu)
> -{
> -}
> -
>  static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
>  {
>  }
> @@ -7208,7 +7204,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  	.get_cpl = svm_get_cpl,
>  	.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
>  	.decache_cr0_guest_bits = svm_decache_cr0_guest_bits,
> -	.decache_cr3 = svm_decache_cr3,
>  	.decache_cr4_guest_bits = svm_decache_cr4_guest_bits,
>  	.set_cr0 = svm_set_cr0,
>  	.set_cr3 = svm_set_cr3,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ed03d0cd1cc8..c84798026e85 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2188,7 +2188,12 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
>  		if (enable_ept)
>  			ept_save_pdptrs(vcpu);
>  		break;
> +	case VCPU_EXREG_CR3:
> +		if (enable_unrestricted_guest || (enable_ept && is_paging(vcpu)))
> +			vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
> +		break;
>  	default:
> +		WARN_ON_ONCE(1);
>  		break;
>  	}
>  }
> @@ -2859,13 +2864,6 @@ static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
>  	vcpu->arch.cr0 |= vmcs_readl(GUEST_CR0) & cr0_guest_owned_bits;
>  }
>  
> -static void vmx_decache_cr3(struct kvm_vcpu *vcpu)
> -{
> -	if (enable_unrestricted_guest || (enable_ept && is_paging(vcpu)))
> -		vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
> -	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
> -}
> -
>  static void vmx_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
>  {
>  	ulong cr4_guest_owned_bits = vcpu->arch.cr4_guest_owned_bits;
> @@ -2910,7 +2908,7 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
>  	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
> -		vmx_decache_cr3(vcpu);
> +		vmx_cache_reg(vcpu, VCPU_EXREG_CR3);
>  	if (!(cr0 & X86_CR0_PG)) {
>  		/* From paging/starting to nonpaging */
>  		exec_controls_setbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
> @@ -7792,7 +7790,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>  	.get_cpl = vmx_get_cpl,
>  	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
>  	.decache_cr0_guest_bits = vmx_decache_cr0_guest_bits,
> -	.decache_cr3 = vmx_decache_cr3,
>  	.decache_cr4_guest_bits = vmx_decache_cr4_guest_bits,
>  	.set_cr0 = vmx_set_cr0,
>  	.set_cr3 = vmx_set_cr3,

Reviewed (and Tested-On-Amd-By:): Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
