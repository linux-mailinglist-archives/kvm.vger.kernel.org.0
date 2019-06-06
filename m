Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB2EA3740A
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 14:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfFFMYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 08:24:39 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54098 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfFFMYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 08:24:39 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so1584568wmj.3
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 05:24:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dKc3xHu0zr0AMomKCg1jaqQQEASIGHinqVK8mkKM3UY=;
        b=TYBO6iVAcjdbBo9yEaGHFpG71VfcWq9uj7+o0Vl9bxOcY3AWFcudZR8Q+MsEUehHOU
         JMyomasb1OD3RwHspEGj3gIcqPwDBHQbJcSMMff+GKiyuNTjyDRrXKsEmHkDVTGA2919
         zfUmiaoxv1bPTDV8QXqM149ow1qXb6/5OxP71rpcgPPium22CNsDiViRStH/s85GL40a
         tzdVTANUky+tYs7q1WSqJBUxiF9/UAILT5zYekiXkrkhWslTiWN6O/daR+p941qmErKX
         SnMuMH/wdiSQS/qC9UOrCcHOfkCjN7RLwzo5Ptg5tg80rAGa0qHt+cy6l4lDnHx18CQK
         2IEQ==
X-Gm-Message-State: APjAAAXz0g2dSK/m+skJ5KIC2RMeb5uTYNUkqCOm5ZggucYQhHI80iDC
        wJv1dVHSZPyGM6t8nbpght9/t3bdff4=
X-Google-Smtp-Source: APXvYqwD/2oM3Wecbps27wULAYS8SUAGrImWOPQ2F0sGYfUF3n3DhJolzmD9MNklT95ExaryyAXDvA==
X-Received: by 2002:a1c:a186:: with SMTP id k128mr17910007wme.125.1559823876879;
        Thu, 06 Jun 2019 05:24:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id p16sm2470273wrg.49.2019.06.06.05.24.34
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 05:24:35 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: nVMX: Stash L1's CR3 in vmcs01.GUEST_CR3 on
 nested entry w/o EPT
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190520201029.7126-1-sean.j.christopherson@intel.com>
 <20190520201029.7126-2-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <84e8d701-2513-2892-de59-2d60522e590d@redhat.com>
Date:   Thu, 6 Jun 2019 14:24:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520201029.7126-2-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 22:10, Sean Christopherson wrote:
> KVM does not have 100% coverage of VMX consistency checks, i.e. some
> checks that cause VM-Fail may only be detected by hardware during a
> nested VM-Entry.  In such a case, KVM must restore L1's state to the
> pre-VM-Enter state as L2's state has already been loaded into KVM's
> software model.
> 
> L1's CR3 and PDPTRs in particular are loaded from vmcs01.GUEST_*.  But
> when EPT is disabled, the associated fields hold KVM's shadow values,
> not L1's "real" values.  Fortunately, when EPT is disabled the PDPTRs
> come from memory, i.e. are not cached in the VMCS.  Which leaves CR3
> as the sole anomaly.  Handle CR3 by overwriting vmcs01.GUEST_CR3 with
> L1's CR3 during the nested VM-Entry when EPT is disabled *and* nested
> early checks are disabled, so that nested_vmx_restore_host_state() will
> naturally restore the correct vcpu->arch.cr3 from vmcs01.GUEST_CR3.
> 
> Note, these shenanigans work because nested_vmx_restore_host_state()
> does a full kvm_mmu_reset_context(), i.e. unloads the current MMU,
> which guarantees vmcs01.GUEST_CR3 will be rewritten with a new shadow
> CR3 prior to re-entering L1.  Writing vmcs01.GUEST_CR3 is done if and
> only if nested early checks are disabled as "late" VM-Fail should never
> happen in that case (KVM WARNs), and the conditional write avoids the
> need to restore the correct GUEST_CR3 when nested_vmx_check_vmentry_hw()
> fails.
> 
> Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> Fixes: bd18bffca353 ("KVM: nVMX: restore host state in nested_vmx_vmexit for VMFail")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 1032f068f0b9..92117092f6e9 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2963,6 +2963,8 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
>  	if (kvm_mpx_supported() &&
>  		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>  		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);

This hunk needs a comment that says basically the same things that are
in the commit message.

	/* Temporarily overwrite vmcs01.GUEST_CR3 with L1's CR3 during
	 * the nested VM-Entry when EPT is disabled *and* nested early
	 * checks are disabled, because nested_vmx_restore_host_state()
	 * wants to restore the correct vcpu->arch.cr3 from
	 * vmcs01.GUEST_CR3.  On nested vmexit, kvm_mmu_reset_context()
	 * will overwrite GUEST_CR3 with the shadow CR3 prior to
	 * re-entering L1.  This is not needed when nested early checks
	 * are enabled, because it doesn't reload the MMU until
	 * after the checks have succeeded.
	 */

And also, the restore of the correct vcpu->arch.cr3 from
vmcs01.GUEST_CR3 can be moved to this patch otherwise the comment would
not be accurate.

But, as I said in the review of patch 2, I'm a bit lost as to how
kvm_mmu_reset_context() is enough to reload the shadow CR3 into the vmcs01.

Paolo

> +	if (!enable_ept && !nested_early_check)
> +		vmcs_writel(GUEST_CR3, vcpu->arch.cr3);
>  
>  	vmx_switch_vmcs(vcpu, &vmx->nested.vmcs02);
>  
> @@ -3794,7 +3796,8 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
>  	 * VMFail, like everything else we just need to ensure our
>  	 * software model is up-to-date.
>  	 */
> -	ept_save_pdptrs(vcpu);
> +	if (enable_ept)
> +		ept_save_pdptrs(vcpu);
>  
>  	kvm_mmu_reset_context(vcpu);
>  
> 

