Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82AD47890AD
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 23:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjHYVqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 17:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjHYVqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 17:46:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145C926BD
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 14:46:10 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d74a0f88457so1684373276.2
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 14:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692999969; x=1693604769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=odPHPe5zFeL7gaKGcaVYt3urnmLAQ3hctBtrMI+qFRc=;
        b=x1X+gq2MNHdyg+JX1qqtqdxcUO2kaBiy8tBfkhCZ5MaylnPkC1GsPQ8OpPHi+1l820
         bEwH8077zlnSdeqmpEIEREwJG2y+nCXOovwBkUnhk5QkIAh67hYH4nQxVK1otd2WsaNw
         DYmZ6Mae7mBldaxAWYa04JztrC6TURexrrEupK6c5Ws+ARn6OTOLCk1l2IO8C4m8/w5c
         AORM1FdX49kt2Ke0s8mhvpQTvuIFdVRj2oMg71710PuZBsple7IW3WOkQa5Ke2y84KsD
         HTcJevzkKblSp+wkytY84gdV0jayyYyl+3HJnTs969ZCY89aeNoNmcrgOKPazKgL2Xhg
         iecQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692999969; x=1693604769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=odPHPe5zFeL7gaKGcaVYt3urnmLAQ3hctBtrMI+qFRc=;
        b=Kxtunsac03fQ7OTIZj5LEnHeLivmGB9FZWrpwe/rgEBoFvbx/DUXA67dmxgvBweUlN
         bomGA43f3nf3VxqaiAakF+sv97zo8bGK5c9BBYHYpKvfpj57UgYQV8sYeNO+kC2+Q3mN
         aE89hXKEkxno4Ne0uUL4wObRg6LvrHk83hAg3aYOZ2Ma6zBHkEYlzvNDlkcnTUeOUy5H
         dM5FbpsZaxyYajn0SYxDCYZNjosnncbYXuTfwj2ShSWYoydQB5nlGmiY4De0CKBC6OEz
         WRXdwCo9PAGZbFKf6kwVuSWGvthLIrGxgOQ0sGGhgVJBqfOBu7ybfeUdx8V8oTnsWxzD
         VhIw==
X-Gm-Message-State: AOJu0Yy+tNsCpxieg6CCyEvNYGL0U2iDBF6idSk8uXfe2/EUDb0HDghm
        sBwciVElkVvNIF8umF7s7VTOZ0PK4OY=
X-Google-Smtp-Source: AGHT+IFQHGmjTYl5KU/LvfBJtGvqeIT1isPlUH0UyZjHzrJ0Bsc+pqJxN+QJLl9WGVAC9fNl/+TvuiUlzNY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:41c1:0:b0:d45:daf4:1fc5 with SMTP id
 o184-20020a2541c1000000b00d45daf41fc5mr482574yba.3.1692999969352; Fri, 25 Aug
 2023 14:46:09 -0700 (PDT)
Date:   Fri, 25 Aug 2023 14:46:07 -0700
In-Reply-To: <20230714065356.20620-1-yan.y.zhao@intel.com>
Mime-Version: 1.0
References: <20230714064656.20147-1-yan.y.zhao@intel.com> <20230714065356.20620-1-yan.y.zhao@intel.com>
Message-ID: <ZOkhH9A2ghtUb96U@google.com>
Subject: Re: [PATCH v4 08/12] KVM: x86: centralize code to get CD=1 memtype
 when guest MTRRs are honored
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com, yuan.yao@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 14, 2023, Yan Zhao wrote:
> Centralize the code to get cache disabled memtype when guest MTRRs are
> honored. If a TDP honors guest MTRRs, it is required to call the provided
> API to get the memtype for CR0.CD=1.
> 
> This is the preparation patch for later implementation of fine-grained gfn
> zap for CR0.CD toggles when guest MTRRs are honored.
> 
> No functional change intended.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  arch/x86/kvm/mtrr.c    | 16 ++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c | 10 +++++-----
>  arch/x86/kvm/x86.h     |  2 ++
>  3 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> index 3ce58734ad22..64c6daa659c8 100644
> --- a/arch/x86/kvm/mtrr.c
> +++ b/arch/x86/kvm/mtrr.c
> @@ -721,3 +721,19 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
>  
>  	return type == mtrr_default_type(mtrr_state);
>  }
> +
> +/*
> + * this routine is supposed to be called when guest mtrrs are honored
> + */
> +void kvm_honors_guest_mtrrs_get_cd_memtype(struct kvm_vcpu *vcpu,
> +					   u8 *type, bool *ipat)

I really don't like this helper.  IMO it's a big net negative for the readability
of vmx_get_mt_mask().  As I said in the previous version, I agree that splitting
logic is generally undesirable, but in this case I strongly believe it's the
lesser evil.

> +{
> +	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED)) {
> +		*type = MTRR_TYPE_WRBACK;
> +		*ipat = false;
> +	} else {
> +		*type = MTRR_TYPE_UNCACHABLE;
> +		*ipat = true;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(kvm_honors_guest_mtrrs_get_cd_memtype);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c1e93678cea4..7fec1ee23b54 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7573,11 +7573,11 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
>  
>  	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
> -		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
> -			return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
> -		else
> -			return (MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT) |
> -				VMX_EPT_IPAT_BIT;
> +		bool ipat;
> +		u8 cache;
> +
> +		kvm_honors_guest_mtrrs_get_cd_memtype(vcpu, &cache, &ipat);
> +		return cache << VMX_EPT_MT_EPTE_SHIFT | (ipat ? VMX_EPT_IPAT_BIT : 0);
>  	}
>  
>  	return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 82e3dafc5453..e7733dc4dccc 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -313,6 +313,8 @@ int kvm_mtrr_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data);
>  int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
>  bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
>  					  int page_num);
> +void kvm_honors_guest_mtrrs_get_cd_memtype(struct kvm_vcpu *vcpu,
> +					   u8 *type, bool *ipat);
>  bool kvm_vector_hashing_enabled(void);
>  void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
>  int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
> -- 
> 2.17.1
> 
