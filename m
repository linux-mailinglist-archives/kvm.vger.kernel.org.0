Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEF18D0D58
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 13:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbfJILDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 07:03:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59816 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbfJILDv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 07:03:51 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D49C48E582
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 11:03:49 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id n18so941042wro.11
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 04:03:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pb/O8E31N8f47XxF5w4IpAcko3FGrh+v/nxG5c0T5ng=;
        b=dX7HS00u3vVMP2eKM+ssUYN1IJxDOQMf3LfwWX04teviZ/Q6qWlGEv3ZbP+jH8pz/v
         yQnotiJwQ+hhAKc3lBfhoQJptE0M5+OOuii7SF2QF6u3g71Vz/wxqfB+RHEd9YjA+gc9
         mz/Hdeb+3NttzvaY3J7UPZHMazVRZ0kc+2Wr0gVLfqNMlnLh3EYA/EXqlWJthAHfFyw0
         IpYVIFtS5+MM/Q770O9N7ca2Xlu9YtjBDR33iGiWqSIB3bdwzRmwE0V83CwIGn68UNrh
         nTAbZfi4L5HaMPqxbbcb8kxqr8c+soZN03WF/28ZzPQRuOC7tnqQGYozrvkiyoTjnLgO
         7QfQ==
X-Gm-Message-State: APjAAAWMB42yGCsOVZXJu1b0TD5f2Ib88F240gcMl59c0iwdRNRs/EqU
        ruu1lOqBhJuvbrESvRKWAGCjkwUEJx4ywTQKRrgz18KwD+0Sv9hD8XpSQf6NRzYtDU3LK/o5/jy
        cxhwt0mPyRCtV
X-Received: by 2002:a05:600c:3cb:: with SMTP id z11mr1999064wmd.134.1570619027442;
        Wed, 09 Oct 2019 04:03:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqymittw6qESQy42E4k0CeaUfigne1Jtc4trrmLymDzHrJXdYhNWxjepYdvUM6Zqspap5gdGnA==
X-Received: by 2002:a05:600c:3cb:: with SMTP id z11mr1999029wmd.134.1570619027057;
        Wed, 09 Oct 2019 04:03:47 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id h7sm2075946wrs.15.2019.10.09.04.03.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 04:03:46 -0700 (PDT)
Subject: Re: [PATCH v2 8/8] KVM: x86: Fold decache_cr3() into cache_reg()
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
 <20190927214523.3376-9-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e940bc7c-8930-b583-fecd-c2c7087aed0d@redhat.com>
Date:   Wed, 9 Oct 2019 13:03:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190927214523.3376-9-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/19 23:45, Sean Christopherson wrote:
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
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

BUG() is a bit heavy, I'll squash this instead:

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b8885bc0e7d7..e479ea9bc9da 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2376,7 +2376,7 @@ static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
 		break;
 	default:
-		BUG();
+		WARN_ON_ONCE(1);
 	}
 }
 

Since the value that is never cached, literally nothing could go wrong at
least in theory.

Paolo


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
> 

