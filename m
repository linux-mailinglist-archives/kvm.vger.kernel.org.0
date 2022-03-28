Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2094E9E9A
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 20:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242997AbiC1SGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 14:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbiC1SGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 14:06:30 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C2A4BFFC
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 11:04:48 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t4so9757051pgc.1
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 11:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ym/L1wBpDfLtNFYglb5eik8J+ZADs+Mxo8dMLHDIgV0=;
        b=JWB0uri4NhVLpGuhzaP6omiJxFh+N6igYL2QbafBZatuK8GtgilikAUUQfcEkJl9wQ
         2skQvDSUo+QMjRe4Vq0ipUufHfPSE2C2fzWmL/E7sMtpWPWJFR1FLOsBmdCm9HOHzXEt
         yayMV6b+Awot34BckY+CuNWx864MNrfv4zC++1Mfxle2jUQHy4bUJTm97tdfZUR4A7dp
         9QdBiZK0g7wZ32cr9l81iMisnMhxmxy006GUhGTI9rOJQ1/HcMxwFZZn6DDGsY9E85hG
         P1FidWr4vXP/LzVnH7wc2TVdmAqGZvpuUuRA89S2j34ES3txBLDpPUa5NJrNlP5VLJfn
         X5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ym/L1wBpDfLtNFYglb5eik8J+ZADs+Mxo8dMLHDIgV0=;
        b=kOCq47PcQXPiL1SQ+TgMDuz1FCxhDfzJcPGpqoSr/jPNmdstQQNkyRqxgjg65kWl/z
         8LIzNlu30aL8A0s/kOCRaHzh5sqkaDlmZLAulR9hJ6N/CXXUo3n9vXJvRLe79xMIqTGC
         QkvRW0j0GZpyDQoigwkLF8NjyWy783rQ4nC5qYPNgopjk5tEZlj4/c4HiEulktHR8aIo
         QSMNeu5ruAtp7OqKVCMKCB7E0BLjca1qGY+sNdTjIXwmWlshoPJ54HZnGb+PqEfz9HKw
         IC9nEClZ00nU5yuyNYpdf0eF4BBm54IDM62w9tpR1Jax3TCASm9Mvp6or6Q2whX+XIqp
         vTtQ==
X-Gm-Message-State: AOAM530jQNlDf2mQg9qfbP8aUblP2yY4aKsifbfjdQjtVjhRvPbbaxAy
        ZosEclNWtHajw1oR59Ot9eBGoQ==
X-Google-Smtp-Source: ABdhPJz6cmAET3X2l8oi9XiqgexGDczM4h6l+4EdHGvw31KNYFpDUf/5HHI7EuZ0lQttFGrQKlsXbg==
X-Received: by 2002:a05:6a00:1496:b0:4fb:34a7:dcce with SMTP id v22-20020a056a00149600b004fb34a7dccemr11419180pfu.70.1648490687914;
        Mon, 28 Mar 2022 11:04:47 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id 21-20020a630115000000b00382a0895661sm13558768pgb.11.2022.03.28.11.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 11:04:46 -0700 (PDT)
Date:   Mon, 28 Mar 2022 18:04:43 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 6/9] KVM: x86/mmu: Factor out part of vmx_get_mt_mask
 which does not depend on vcpu
Message-ID: <YkH4u7O8uSNKl+eE@google.com>
References: <20220321224358.1305530-1-bgardon@google.com>
 <20220321224358.1305530-7-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321224358.1305530-7-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 21, 2022 at 03:43:55PM -0700, Ben Gardon wrote:
> Factor out the parts of vmx_get_mt_mask which do not depend on the vCPU
> argument. This also requires adding some error reporting to the helper
> function to say whether it was possible to generate the MT mask without
> a vCPU argument. This refactoring will allow the MT mask to be computed
> when noncoherent DMA is not enabled on a VM.

We could probably make vmx_get_mt_mask() entirely independent of
the kvm_vcpu, but it would take more work.

For MTRRs, the guest must update them on all CPUs at once (SDM 11.11.8)
so we could just cache vCPU 0's MTRRs at the VM level and use that here.
(From my experience, Intel CPUs implement MTRRs at the core level.
Properly emulating that would require a different EPT table for every
virtual core.)

For CR0.CD, I'm not exactly sure what the semantics are for MP systems
but I can't imagine it's valid for software to configure CR0.CD
differently on different cores. I would have to scoure the SDM closely
to confirm, but we could probably do something like cache
max(CR0.CD for all vCPUs) at the VM level and use that to indicate if
caching is disabled.

> 
> No functional change intended.
> 
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e8963f5af618..69c654567475 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7149,9 +7149,26 @@ static int __init vmx_check_processor_compat(void)
>  	return 0;
>  }
>  
> +static bool vmx_try_get_mt_mask(struct kvm *kvm, gfn_t gfn,
> +				bool is_mmio, u64 *mask)
> +{
> +	if (is_mmio) {
> +		*mask =  MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
> +		return true;
> +	}
> +
> +	if (!kvm_arch_has_noncoherent_dma(kvm)) {
> +		*mask = (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>  static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  {
>  	u8 cache;
> +	u64 mask;
>  
>  	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
>  	 * memory aliases with conflicting memory types and sometimes MCEs.
> @@ -7171,11 +7188,8 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  	 * EPT memory type is used to emulate guest CD/MTRR.
>  	 */
>  
> -	if (is_mmio)
> -		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
> -
> -	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
> -		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> +	if (vmx_try_get_mt_mask(vcpu->kvm, gfn, is_mmio, &mask))
> +		return mask;
>  
>  	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
>  		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
> -- 
> 2.35.1.894.gb6a874cedc-goog
> 
