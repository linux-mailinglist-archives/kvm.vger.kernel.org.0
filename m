Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACDA03B8722
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 18:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhF3Qil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 12:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhF3Qik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 12:38:40 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9695CC061756
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 09:36:10 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id h4so2835033pgp.5
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 09:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gt4onubAx7G0CxXKHtUNgeuC3ZM/JmcMvLDBhaGnhv8=;
        b=ZPAlH+fu2F6ViOv2Y8BvrXaPW0CjFSxdpHtwCe0QsweafEjigEOOFhw98t62muaNvz
         HnRYgSnlRZoeh2HkTND9X2eetqyP+hWu/t4bXFYmV5S0c4GznZJAh1MTXn7NbfAgPGh/
         gFAYTlHvWM+9lsZQ4swAGLrEkOebnyws7iR4heQivOc4dQ6BX7WPccm7wbTn/nAF6rJf
         JxwEPni4ZrOz6eCIJLCNGr2ZyGMfW5/7wsIjdlGPCm0I1OML6n/+OsMnteCAvqo5jZX8
         7bixvJRq7/OifEaVuC6MEr4zuI1s8ZJYoUdyKDMluQcFOQIZfJ+haM14IG+NJdFmJRTQ
         Bfqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gt4onubAx7G0CxXKHtUNgeuC3ZM/JmcMvLDBhaGnhv8=;
        b=OJXvEYq/BXU5K/GrW/o1K3dN90tUSIBXN5UnuHgmKbEB+hCaKFtWZkRfiSeZY5++vC
         E6YpVdJblBS7h7RHcx/1eikTmy4vNUbl7segeO3PpeuMYYnK6jeXMSBejYv20KslF2DC
         T/oOqvP3CeSSOQYjQGx72nr78at2t14j/fEMgKUpccl7fKMO090Sq7AJzWMr6Ne/lV+F
         y+XRMT77L/uE4qi8qRPlwdLYIXfL1HrvB69DXGc1kPEQFNZw53NsMA5pCqqDh41gv457
         nRKoYVQpq07Tpx0PYmk8ffFJ1tbE3PxxVl79MYZ0o3ofHk8Vtxt3cnq6PYMzDFu9uvgj
         YDbQ==
X-Gm-Message-State: AOAM532vVZinL+mAuqrhtR9HOZJgqeAKOmd7ON0+Hv/24io6QJmA+G/k
        Iz+NZXlX+h84DGRBAXPGJGptTOzvJHjfyg==
X-Google-Smtp-Source: ABdhPJwecKj6H+NjwX8y5MJL/bw/FA4OiEOx9nTQk7FQWdW/jMHXnCOUS1I2DRrStXozT9jHEMvF7g==
X-Received: by 2002:a63:405:: with SMTP id 5mr4358178pge.132.1625070969980;
        Wed, 30 Jun 2021 09:36:09 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id w6sm40994pgh.56.2021.06.30.09.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 09:36:09 -0700 (PDT)
Date:   Wed, 30 Jun 2021 16:36:05 +0000
From:   David Matlack <dmatlack@google.com>
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org
Subject: Re: [PATCH 1/2] KVM: x86: Add kvm_x86_ops.get_exit_reason
Message-ID: <YNyddfOnfIMfakwI@google.com>
References: <20210628173152.2062988-1-david.edmondson@oracle.com>
 <20210628173152.2062988-2-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628173152.2062988-2-david.edmondson@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 06:31:51PM +0100, David Edmondson wrote:
> For later use.

Please add more context to the commit message.

> 
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 1 +
>  arch/x86/include/asm/kvm_host.h    | 1 +
>  arch/x86/kvm/svm/svm.c             | 6 ++++++
>  arch/x86/kvm/vmx/vmx.c             | 6 ++++++
>  4 files changed, 14 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index a12a4987154e..afb0917497c1 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -85,6 +85,7 @@ KVM_X86_OP_NULL(sync_pir_to_irr)
>  KVM_X86_OP(set_tss_addr)
>  KVM_X86_OP(set_identity_map_addr)
>  KVM_X86_OP(get_mt_mask)
> +KVM_X86_OP(get_exit_reason)
>  KVM_X86_OP(load_mmu_pgd)
>  KVM_X86_OP_NULL(has_wbinvd_exit)
>  KVM_X86_OP(get_l2_tsc_offset)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 974cbfb1eefe..0ee580c68839 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1365,6 +1365,7 @@ struct kvm_x86_ops {
>  	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
>  	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
>  	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
> +	u64 (*get_exit_reason)(struct kvm_vcpu *vcpu);
>  
>  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  			     int root_level);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 616b9679ddcc..408c854b4ac9 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4009,6 +4009,11 @@ static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  	return 0;
>  }
>  
> +static u64 svm_get_exit_reason(struct kvm_vcpu *vcpu)
> +{
> +	return to_svm(vcpu)->vmcb->control.exit_code;
> +}
> +
>  static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4573,6 +4578,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.set_tss_addr = svm_set_tss_addr,
>  	.set_identity_map_addr = svm_set_identity_map_addr,
>  	.get_mt_mask = svm_get_mt_mask,
> +	.get_exit_reason = svm_get_exit_reason,
>  
>  	.get_exit_info = svm_get_exit_info,
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 927a552393b9..a19b006c287a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6997,6 +6997,11 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  	return (cache << VMX_EPT_MT_EPTE_SHIFT) | ipat;
>  }
>  
> +static u64 vmx_get_exit_reason(struct kvm_vcpu *vcpu)
> +{
> +	return to_vmx(vcpu)->exit_reason.basic;

Why not the full exit reason?

> +}
> +
>  static void vmcs_set_secondary_exec_control(struct vcpu_vmx *vmx)
>  {
>  	/*
> @@ -7613,6 +7618,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.set_tss_addr = vmx_set_tss_addr,
>  	.set_identity_map_addr = vmx_set_identity_map_addr,
>  	.get_mt_mask = vmx_get_mt_mask,
> +	.get_exit_reason = vmx_get_exit_reason,
>  
>  	.get_exit_info = vmx_get_exit_info,
>  
> -- 
> 2.30.2
> 
