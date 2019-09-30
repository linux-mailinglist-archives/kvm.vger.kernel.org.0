Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF05C1D64
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 10:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730286AbfI3Isb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 04:48:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730131AbfI3Isa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 04:48:30 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2283D2A09B7
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 08:48:30 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id z17so4210571wru.13
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 01:48:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=z2zHybU21osOisPlhNSom+TBjgJpL+1v6taEXtPzqtg=;
        b=lvzuC36bu2sYObXl+ET7W8KTLVZK1w17KasgHvkCw2EVLk5GXbOdQ8AUj7BQyeOzhs
         sFJd+nnTYAPlzhBM32asaM5O5ty9223CMNeL275SAFeqfEqA23Ym+Bkp2ZBpsXVSwczb
         a47XjxdEULlBs2ZJx0B3m77tiqCz2jEKpwGfuYrDnfhk3F1tHkW+h8p1B0cWQd5Z7eVE
         aovBgqKWDSiGijuj4L7YwxnYCN7G7za1Zhzzvf9jDAwVMrXx8HAlcSFQ+9jR3jY2E3Bz
         86K7/ITKDlz3EITUwoC9MORSHArqGP+wxZCYg8E1o/m6+bKGgM6mW/wJLbqOnLg7FyCq
         0G7g==
X-Gm-Message-State: APjAAAXL8VBB1UANcwe/zi2fH1PXlnF7scqlCBm5SPbCKOoQNSpeLJyL
        MP+RsAo9l8cxHeON4kf7l9axQV1WjfE/owVQzzRwvWLv7pOty8147JhUYxDsIRPIkV2nKYcWsrT
        RaMcXCfXPAee0
X-Received: by 2002:a7b:c00e:: with SMTP id c14mr15719508wmb.158.1569833308871;
        Mon, 30 Sep 2019 01:48:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzKYydhyPSllr2kw+Hkb3I9DMukpo9Gxj9D4tgxaCb+MomXmOVx1GYs16JH8PvBVPcvxGLJ1A==
X-Received: by 2002:a7b:c00e:: with SMTP id c14mr15719495wmb.158.1569833308635;
        Mon, 30 Sep 2019 01:48:28 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b7sm10175881wrj.28.2019.09.30.01.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 01:48:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 3/8] KVM: VMX: Consolidate to_vmx() usage in RFLAGS accessors
In-Reply-To: <20190927214523.3376-4-sean.j.christopherson@intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com> <20190927214523.3376-4-sean.j.christopherson@intel.com>
Date:   Mon, 30 Sep 2019 10:48:27 +0200
Message-ID: <87pnji41b8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Capture struct vcpu_vmx in a local variable to improve the readability
> of vmx_{g,s}et_rflags().
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0b8dd9c315f8..83fe8b02b732 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1407,35 +1407,37 @@ static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu);
>  
>  unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long rflags, save_rflags;
>  
>  	if (!test_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail)) {
>  		__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
>  		rflags = vmcs_readl(GUEST_RFLAGS);
> -		if (to_vmx(vcpu)->rmode.vm86_active) {
> +		if (vmx->rmode.vm86_active) {
>  			rflags &= RMODE_GUEST_OWNED_EFLAGS_BITS;
> -			save_rflags = to_vmx(vcpu)->rmode.save_rflags;
> +			save_rflags = vmx->rmode.save_rflags;
>  			rflags |= save_rflags & ~RMODE_GUEST_OWNED_EFLAGS_BITS;
>  		}
> -		to_vmx(vcpu)->rflags = rflags;
> +		vmx->rflags = rflags;
>  	}
> -	return to_vmx(vcpu)->rflags;
> +	return vmx->rflags;
>  }
>  
>  void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>  {
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long old_rflags = vmx_get_rflags(vcpu);
>  
>  	__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
> -	to_vmx(vcpu)->rflags = rflags;
> -	if (to_vmx(vcpu)->rmode.vm86_active) {
> -		to_vmx(vcpu)->rmode.save_rflags = rflags;
> +	vmx->rflags = rflags;
> +	if (vmx->rmode.vm86_active) {
> +		vmx->rmode.save_rflags = rflags;
>  		rflags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
>  	}
>  	vmcs_writel(GUEST_RFLAGS, rflags);
>  
> -	if ((old_rflags ^ to_vmx(vcpu)->rflags) & X86_EFLAGS_VM)
> -		to_vmx(vcpu)->emulation_required = emulation_required(vcpu);
> +	if ((old_rflags ^ vmx->rflags) & X86_EFLAGS_VM)
> +		vmx->emulation_required = emulation_required(vcpu);
>  }
>  
>  u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
