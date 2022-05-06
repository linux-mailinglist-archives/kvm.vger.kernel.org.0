Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDFE51DFCC
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 21:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391876AbiEFTvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 15:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391826AbiEFTvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 15:51:02 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D626AA5D
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 12:47:18 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so11672079pjb.5
        for <kvm@vger.kernel.org>; Fri, 06 May 2022 12:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nmr+AH6GUiQVKg/lqAG1BcDa6rkwmcO9PiTJLcm3vjM=;
        b=U2bwdDOISPfpNSZR7/BlxGhBrUPE80tEwKwbP78OiiiqRJAS7GEuBM4FtQq0mbcwwK
         1eJ07Uq+ALubHgrrirJAgrVh3bK0cxESTZ41vWBDRSSoQ4p+EUYwSeotKxB+qT5dflR/
         0bFjJQ++RP9GZ5CVlPHE7PUiV/zMVIvci8VDwW4+WVe5sP8iSYBwZ+CKqsBFvWgCL5XZ
         nhFyG8n+bNq4qzsVlIdX7CMJQzQPgQ0fuIKbiEXUwvOZ/+9gtadOW9UAfhFV+VjXFGAa
         oVoukit96tPbVfrWQ4mpFiFvUPZ2xpqRuq5IRIU93CVwGPX5dIzahsTxzlYlw1wfxEoO
         uZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nmr+AH6GUiQVKg/lqAG1BcDa6rkwmcO9PiTJLcm3vjM=;
        b=TIym39zKyD30RJIuyImUq+T4ZD3J3PAZU8p014U0FZAodfZoYPL53D3mep3ZQrkpDj
         8H+Xe4/M8wmL7OpUF8LxweF9694BjtgffVrXqoe6h92d/2gk315hk6WcPgKPyLWxxW79
         oC5haMM30zMO2NJkUwJ+GLZ8whc57IDDqcnfol+dui/9yTF/+JXtQ/5lun33OPaeyg/u
         vKLur6/ZVLgNRWT/R/wsQ6Vqq/z8OLCSqAJxQI4eMHPlL5Lgz7YlYLy/QOAUe83Hm/W4
         pocdj0kjqhx3bwYj0vD5Xf3GW4bUXg+sBeSVNL6FrsweCqXiDhX+hmDaHp0kFM4dMZci
         53nQ==
X-Gm-Message-State: AOAM53320bQ+J/CYuD9+yFDkXEmjibugSHSjLLKaNOabmfn9PybDQybb
        +80ano69csweKNWMxBiOqWemiw==
X-Google-Smtp-Source: ABdhPJx2W2s0XDr5knnrxjU/QOn2nWMZ5XriOwGOqf4NFEZIHnzgq+6wjY1bPlgr+nIx5/fnbHXnhA==
X-Received: by 2002:a17:902:ef45:b0:155:cede:5a9d with SMTP id e5-20020a170902ef4500b00155cede5a9dmr5107832plx.93.1651866437748;
        Fri, 06 May 2022 12:47:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gt9-20020a17090af2c900b001dc1e6db7c2sm7599741pjb.57.2022.05.06.12.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 12:47:16 -0700 (PDT)
Date:   Fri, 6 May 2022 19:47:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v4 15/20] KVM: x86/mmu: Cache the access bits of shadowed
 translations
Message-ID: <YnV7QUOkYVg+Ktnl@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-16-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-16-dmatlack@google.com>
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

On Fri, Apr 22, 2022, David Matlack wrote:
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index a8a755e1561d..97bf53b29b88 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -978,7 +978,8 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  }
>  
>  /*
> - * Using the cached information from sp->gfns is safe because:
> + * Using the information in sp->shadowed_translation (kvm_mmu_page_get_gfn()
> + * and kvm_mmu_page_get_access()) is safe because:
>   * - The spte has a reference to the struct page, so the pfn for a given gfn
>   *   can't change unless all sptes pointing to it are nuked first.
>   *
> @@ -1052,12 +1053,15 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
>  			continue;
>  
> -		if (gfn != sp->gfns[i]) {
> +		if (gfn != kvm_mmu_page_get_gfn(sp, i)) {
>  			drop_spte(vcpu->kvm, &sp->spt[i]);
>  			flush = true;
>  			continue;
>  		}
>  
> +		if (pte_access != kvm_mmu_page_get_access(sp, i))
> +			kvm_mmu_page_set_access(sp, i, pte_access);

Very tangentially related, and more an FYI than anything else (I'll send a patch
separately)...   Replying here because this got me wondering about the validity of
pte_access.

There's an existing bug for nEPT here, which I proved after 3 hours of fighting
with KUT's EPT tests (ugh).

  1. execute-only EPT entries are supported
  2. L1 creates a upper-level RW EPTE and a 4kb leaf RW EPTE
  3. L2 accesses the address; KVM installs a SPTE
  4. L1 modifies the leaf EPTE to be X-only, and does INVEPT
  5. ept_sync_page() creates a SPTE with pte_access=0 / RWX=0

The logic for pte_access (just above this code) is:

		pte_access = sp->role.access;
		pte_access &= FNAME(gpte_access)(gpte);

The parent guest EPTE is 'RW', and so sp->role.access is 'RW'.  When the new 'X'
EPTE is ANDed with the 'RW' parent protections, the result is a RWX=0 SPTE.  This
is only possible if execute-only is supported, because otherwise PTEs are always
readable, i.e. shadow_present_mask is non-zero.

I don't think anything bad happens per se, but it's odd to have a !PRESENT in
hardware, shadow-present SPTE.  I think the correct/easiest fix is:

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index b025decf610d..f8ea881cfce6 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1052,7 +1052,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
                if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
                        continue;

-               if (gfn != sp->gfns[i]) {
+               if ((!pte_access && !shadow_present_mask) || gfn != sp->gfns[i]) {
                        drop_spte(vcpu->kvm, &sp->spt[i]);
                        flush = true;
                        continue;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 75c9e87d446a..9ad60662beac 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -101,6 +101,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
        u64 spte = SPTE_MMU_PRESENT_MASK;
        bool wrprot = false;

+       WARN_ON_ONCE(!pte_access && !shadow_present_mask);
+
        if (sp->role.ad_disabled)
                spte |= SPTE_TDP_AD_DISABLED_MASK;
        else if (kvm_mmu_page_ad_need_write_protect(sp))


> +
>  		sptep = &sp->spt[i];
>  		spte = *sptep;
>  		host_writable = spte & shadow_host_writable_mask;
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
