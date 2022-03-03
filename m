Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDD34CCA27
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 00:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbiCCXkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 18:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235893AbiCCXkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 18:40:23 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A951117C9C
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 15:39:35 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id z2so6186875plg.8
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 15:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zbrxoFXUbPPWy2OmGHM/87ehykZdoUkb/q8EdrCv/aE=;
        b=kPQFbEidLAFavoqL/HEOhmglZRBz4Q68Wjxv38L/nrQW38gsLkeVaoFz6YtOG/32CC
         EDGDXsVNNg1nhObKAgqVXBB7xfrgxb2R1m/hOZjoW7tqFVDqneF8nkYiy8694vo/9vt1
         J9JfkapL8D3Puoz4DNULTMQQdyanboKRrYace7dcwv6DsAJDK5sysjunkk1xM2qTj7dm
         yKMc4p9WW/u8pdzDdRfD6dqiv1UeFYAI5AvXEbocjxKD36IXqpF5y6RHHA6gq4fv/yKL
         tSWxu27g7bgHaof8/k6HMh+sbeDoxtVKxKTqhlpvhQASvR3TlH1GpCn+PUwvnANutGAS
         nSLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zbrxoFXUbPPWy2OmGHM/87ehykZdoUkb/q8EdrCv/aE=;
        b=fCHEPvIaIV1fguzOCMrx8VQKFHLbJzXoJNON3dfDkvYAMKIGwIcXdlLnqbFibApv6A
         JjhNUO56zHc/US2crngwy4ol4D74xTOL6GMcIR1a5BgC+gDPIHs57LDYdLxsTrRnr58t
         brrCys4+mk15HEwJnIuRLJkMnve50WPxnad+lgjHcVLCEFaVieNTaWpJkQcOB4PltK1g
         2KBfnQg7w96AvIW82jtroJxND9NyGa5QtU00Fg3NjjF3NjvZG/kEE4rQGVAL+2KSsXs3
         4xvvf+JkhyqdRFf8oSAg7msbBVh8IKvFC9s8x+STpE+jddIvH9CcyblLsaLm837DQ+1Q
         wDJw==
X-Gm-Message-State: AOAM531GMcb0IHebF16JLPtrcv+95yZ/Mc6NQlNSObwiQFLehokGOPzz
        qEO9RCEdUzWZ8IYTbalEPGJ46Q==
X-Google-Smtp-Source: ABdhPJxQjg95R9JFFXlStDH19lXfsnvZg9NnD6hwBMG0sCBaS1VHLy9LXud4G7o1/P38lPP3lZKi5A==
X-Received: by 2002:a17:90a:1108:b0:1be:e1bd:e2f0 with SMTP id d8-20020a17090a110800b001bee1bde2f0mr7787232pja.144.1646350774737;
        Thu, 03 Mar 2022 15:39:34 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id x7-20020a17090a1f8700b001bf1db72189sm1124311pja.23.2022.03.03.15.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 15:39:34 -0800 (PST)
Date:   Thu, 3 Mar 2022 23:39:30 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v4 03/30] KVM: x86/mmu: Formalize TDP MMU's (unintended?)
 deferred TLB flush logic
Message-ID: <YiFRskA4p1pwNAwS@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-4-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303193842.370645-4-pbonzini@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Explicitly ignore the result of zap_gfn_range() when putting the last
> reference to a TDP MMU root, and add a pile of comments to formalize the
> TDP MMU's behavior of deferring TLB flushes to alloc/reuse.  Note, this
> only affects the !shared case, as zap_gfn_range() subtly never returns
> true for "flush" as the flush is handled by tdp_mmu_zap_spte_atomic().
> 
> Putting the root without a flush is ok because even if there are stale
> references to the root in the TLB, they are unreachable because KVM will
> not run the guest with the same ASID without first flushing (where ASID
> in this context refers to both SVM's explicit ASID and Intel's implicit
> ASID that is constructed from VPID+PCID+EPT4A+etc...).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20220226001546.360188-5-seanjc@google.com>
> Reviewed-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     |  8 ++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c | 10 +++++++++-
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 32c041ed65cb..9a6df2d02777 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5083,6 +5083,14 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  	kvm_mmu_sync_roots(vcpu);
>  
>  	kvm_mmu_load_pgd(vcpu);
> +
> +	/*
> +	 * Flush any TLB entries for the new root, the provenance of the root
> +	 * is unknown.  Even if KVM ensures there are no stale TLB entries
> +	 * for a freed root, in theory another hypervisor could have left
> +	 * stale entries.  Flushing on alloc also allows KVM to skip the TLB
> +	 * flush when freeing a root (see kvm_tdp_mmu_put_root()).
> +	 */
>  	static_call(kvm_x86_flush_tlb_current)(vcpu);
>  out:
>  	return r;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index b97a4125feac..921fa386df99 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -93,7 +93,15 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  	list_del_rcu(&root->link);
>  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  
> -	zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
> +	/*
> +	 * A TLB flush is not necessary as KVM performs a local TLB flush when
> +	 * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
> +	 * to a different pCPU.  Note, the local TLB flush on reuse also
> +	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
> +	 * intermediate paging structures, that may be zapped, as such entries
> +	 * are associated with the ASID on both VMX and SVM.
> +	 */
> +	(void)zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);

Discussed offline with Sean. Now I get myself comfortable with the style
of mmu with multiple 'roots' and leaving TLB unflushed for invalidated
roots.

I guess one minor improvement on the comment could be:

"A TLB flush is not necessary as each vCPU performs a local TLB flush
when allocating or assigning a new root (see kvm_mmu_load()), and when
migrating to a different pCPU."

The above could be better since "KVM performs a local TLB flush" makes
readers think why we miss the 'remote' TLB flushes?
>  
>  	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
> -- 
> 2.31.1
> 
> 
