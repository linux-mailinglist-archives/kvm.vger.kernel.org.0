Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E1B4FE8D6
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 21:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238647AbiDLTmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 15:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358965AbiDLTlx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 15:41:53 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0286713D41
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:39:12 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id e8-20020a17090a118800b001cb13402ea2so4137563pja.0
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=euXbcICELCNFPb9NBiqFJCEuBEWWOkR4DndDT7gTpQQ=;
        b=MEUidB8DRj9fvi4cnMSZFKz23b/gyy6G5lF7tUbIfoRKu+hViqyxc12v1DaVxBFwy3
         8UNesJ3m4RFrySu3SXyzfsaS2d6PyoWV92NsSrh6AD1FRQ/LBPMFFAv2YxzrQtFyB5OP
         C6kOzg3jV+cq9U+8RVcayv8E58sCsTQeJ0IQtZMoopC9B+2u/+L1CB4WROIWNxNf9DT7
         E1p06+IL2OttQ5APRHPKAbPvh5VfCM//f6VTrP1s+8VmsQqdv+wslnoqX8mCoh5WGtbe
         7j0lb+Sdyp6DHYJOmScCgaURKU0V+WJZ3CmgI+zYNUSaRWUMVnRtM8Z/QnTn999c6QBR
         nCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=euXbcICELCNFPb9NBiqFJCEuBEWWOkR4DndDT7gTpQQ=;
        b=G4P3FnJUK9cmfknuDsmE2mopbCQM4AV0xmJx0Tj+B7+Thl3CDUXYbJKltknWqolmUS
         wVEhMUSkKpAEMMnk4LBLCrFrYn0dnG++dNnj/qMlJGRsLfmV65O7mpdgZAjRpHoEFb+A
         oSjQeNFlZQGiK8ZA8sgr6CSJNulVSWktRvDpm6bUKDbSVBIYV1ygcss+VZudUZ7eqW71
         eSn/YfcWOLpZ+TVmC3MxJZm4F/Mv/vpDsCGdud3gsYIG9eOD5HhJLzcx6RNXVYNbZ2fH
         hVksBntFFJbEGALjQXmd+lQrJCKB+565CMM/zEn+dt4DJGBXYKEFXNdZ56ERNTD0rtu3
         v6FQ==
X-Gm-Message-State: AOAM533yaq1U0ewDGLMD6a8LakqUMHaFPeUmeG2OuZOgW1fCqUxAuxUS
        6OrIbWHIL6/4TpZpWHG+oIANcvTydLviyw==
X-Google-Smtp-Source: ABdhPJxObF/XqrzfeblL0RaWjUwlj5fpWsIjxCqmAsdJihfUXGpRFtkqISHwT6NUzBLoIX9tEZLeLw==
X-Received: by 2002:a17:902:f702:b0:156:aaa8:7479 with SMTP id h2-20020a170902f70200b00156aaa87479mr39406836plo.161.1649792352219;
        Tue, 12 Apr 2022 12:39:12 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w14-20020a63474e000000b0039cce486b9bsm3578406pgk.13.2022.04.12.12.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 12:39:11 -0700 (PDT)
Date:   Tue, 12 Apr 2022 19:39:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 8/9] KVM: x86/mmu: Make kvm_is_mmio_pfn usable outside
 of spte.c
Message-ID: <YlXVW/qma/w50Y89@google.com>
References: <20220321224358.1305530-1-bgardon@google.com>
 <20220321224358.1305530-9-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321224358.1305530-9-bgardon@google.com>
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

On Mon, Mar 21, 2022, Ben Gardon wrote:
> Export kvm_is_mmio_pfn from spte.c. It will be used in a subsequent
> commit for in-place lpage promotion when disabling dirty logging.

Rather than force the promotion path to call kvm_is_mmio_pfn(), what about:

  a. Truly exporting the helper, i.e. EXPORT_SYMBOL_GPL
  b. Move this patch earlier in the series, before "KVM: x86/mmu: Factor out part of
     vmx_get_mt_mask which does not depend on vcpu"
  c. In the same patch, drop the "is_mmio" param from kvm_x86_ops.get_mt_mask()
     and have vmx_get_mt_mask() call it directly.

That way the call to kvm_is_mmio_pfn() is avoided when running on AMD hosts
(ignoring the shadow_me_mask thing, which I have a separate tweak for).  The
worst case scenario for a lookup is actually quite expensive, e.g. retpoline and
a spinlock.

> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/spte.c | 2 +-
>  arch/x86/kvm/mmu/spte.h | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 45e9c0c3932e..8e9b827c4ed5 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -69,7 +69,7 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
>  	return spte;
>  }
>  
> -static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
> +bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
>  {
>  	if (pfn_valid(pfn))
>  		return !is_zero_pfn(pfn) && PageReserved(pfn_to_page(pfn)) &&
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index cee02fe63429..e058a85e6c66 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -443,4 +443,5 @@ u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn);
>  
>  void kvm_mmu_reset_all_pte_masks(void);
>  
> +bool kvm_is_mmio_pfn(kvm_pfn_t pfn);
>  #endif
> -- 
> 2.35.1.894.gb6a874cedc-goog
> 
