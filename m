Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E670C4CB386
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 01:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiCCAAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 19:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiCCAAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 19:00:20 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054EF4969A
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 15:59:36 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gb21so3201801pjb.5
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 15:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ckCBduCU8rIC3xMm3IAzUST/V5HZeQGdJRo5tI2p308=;
        b=KxhA+CG1r0bDnPfRKPRFC4gWUhhykeI8AD5VmSGys12v1gnCr1jqlAXuyRGCQEa5xu
         MbxFpEqZObEdVp9jxGfe67+QSPDRS3eTe7Knh2vk8ZwqewwaTmNiZmbGTB/JCDGJrzt0
         Kr7KUS9mo0vj05w/YDjQlaHpwIy5/BKQoglm9GVlHLe0e4jDc9EG8M1vN6BPd19TwktT
         pHCwVpH0nat/DKrUdcH21H5XA8rHzH3vn0zpKjYPLfTLOEMlOaAZ0yu03RSIvjMik4iU
         sFJFW8xyL7nOO3FV/nd6fHVCtBIXYCUvAn3UTVbbMXXgOaEBUf210V2B8LzHhtVXpqXm
         CD6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ckCBduCU8rIC3xMm3IAzUST/V5HZeQGdJRo5tI2p308=;
        b=R5hftLossW2u8G1Px+fg1TfYO2kvcX0Y7gDUHezYxdHh2ZvlN5PJ1ju/u+7zVeG4xy
         sC6jN3k99Px+VaTN2UOFgm3T7lzyHG6dxDMxNYzvpPYb1cdEsHAfemEjYjww/vfM5MXx
         FTRP8OoTMC3MqX0dkumL2kJB5cPd2rH40tBqdD+mc7t2alhzuOe2ACZQVbfRVR2h91GZ
         hiPn1xtD0L4Kp2yu0WAX3/7GIJ1va5mXlJWvFkga4EaFQWZMbcSh9G2my4nYTfNRXSTL
         AT2exdNC6/+irNtr3lmrL1A0BsRJec7GfwkuYDfNvWwUVMIwcPdFmq6E+68UZEb9rcph
         hrqg==
X-Gm-Message-State: AOAM533tmYiJ3Esuh5Hd5uFtUvoX0+OnQE8C8Siv2pLREszd66d1ONks
        Vi2TyfsftZnNaCMGxpMIaI5TjQ==
X-Google-Smtp-Source: ABdhPJwnOxGOxT+j0GWCzApEGE5efrNfWQ84mPA2upSypv5fvtV9FoH1ielmix1ygb7LhabIpUzT8A==
X-Received: by 2002:a17:902:8306:b0:14f:a386:6a44 with SMTP id bd6-20020a170902830600b0014fa3866a44mr33123916plb.140.1646265575211;
        Wed, 02 Mar 2022 15:59:35 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm299171pfl.44.2022.03.02.15.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 15:59:34 -0800 (PST)
Date:   Wed, 2 Mar 2022 23:59:30 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 04/28] KVM: x86/mmu: Formalize TDP MMU's (unintended?)
 deferred TLB flush logic
Message-ID: <YiAE4ju0a3MWXr31@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-5-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226001546.360188-5-seanjc@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 26, 2022, Sean Christopherson wrote:
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
Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     |  8 ++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c | 10 +++++++++-
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 80607513a1f2..5a931c89d27b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5069,6 +5069,14 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  	kvm_mmu_sync_roots(vcpu);
>  
>  	kvm_mmu_load_pgd(vcpu);
> +
> +	/*
> +	 * Flush any TLB entries for the new root, the provenance of the root
> +	 * is unknown.  In theory, even if KVM ensures there are no stale TLB
> +	 * entries for a freed root, in theory, an out-of-tree hypervisor could
> +	 * have left stale entries.  Flushing on alloc also allows KVM to skip
> +	 * the TLB flush when freeing a root (see kvm_tdp_mmu_put_root()).
> +	 */
>  	static_call(kvm_x86_flush_tlb_current)(vcpu);
>  out:
>  	return r;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 12866113fb4f..e35bd88d92fd 100644
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

Understood that we could avoid the TLB flush here. Just curious why the
"(void)" is needed here? Is it for compile time reason?
>  
>  	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
> -- 
> 2.35.1.574.g5d30c73bfb-goog
> 
