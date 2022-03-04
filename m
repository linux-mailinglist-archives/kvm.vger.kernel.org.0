Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680D44CCA9F
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 01:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237336AbiCDAP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 19:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiCDAP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 19:15:27 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B39C17129D
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 16:14:41 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id i1so6282734plr.2
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 16:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IvoaNGPkENv/jpYoOps8a/sj29I1JuRH9su+WWmrhQ0=;
        b=gvIK1o6E82XtUfwyyxVnIbGFcitTrY2yXqiqikfq49qBL5y+ECFV/x5w66Cz3ulcZR
         XvCnh6apWFGmpsJltLSynQZZy4E9oXBWQgBZTXBRQCnRboKCJWHl2VS4yrAeI0BmHP9m
         RM/TLzp62tLx0v1eOJ7yE/XDC4MiTllnUHTgztH5W6OwNywXXPDr3pBVFqNpQWxVUQXy
         feTO7n4LXUIHEg//TcfWcSdHyAwbEWVv/G0CjT9WD7NWIkuDiJWGY7RM1Toa4pWJe5tp
         XeI+kk5Q/lUzPUO0CgeClCZ20L2pT39ZPR06wYNHDwteZcJgYzWS0vhf5pkggVPEwyf4
         h/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IvoaNGPkENv/jpYoOps8a/sj29I1JuRH9su+WWmrhQ0=;
        b=E46XpiJfAwV5IiQTP5mW2NINH1WIsI350f5o/PgVwhlOOXbJr17Qxb6cMjH1iU0vh9
         9jy/58jDRX7w5li982qu6gj3Obk6FBvzagBDMmu2YQ43R8obb7MLpe9Ry1sfU8XdTYvE
         xF88zIF+cx9U/P6U+SX/eO40O6Rz9U3YkZ36cacwiC32qVgAIf9YAZzxMp1EFukweLsI
         WxOreu3xkdxwW7yH31dmUnvc7Dr49vhWzWjcMr7jIkhfIJjcbT+6YB9XVgkfySdp7dkX
         xLiJtUcw5RvaYF/27djeAf39YGimL0ywEgqK1Z8SDIz1pmlJT+wkcqIOleLO7zYwb2+h
         yiuw==
X-Gm-Message-State: AOAM5320c/kLxVaR/6b7K0qejIL4abCgGDfHeIXhYQML+hnSrjMV6/Na
        gZKH+dfZaMlhbf2U9fox3Q4sVpgf4jxQWA==
X-Google-Smtp-Source: ABdhPJzqwSOfDivx5E7YQ97FvRShF9s4O7qxxwTfD+il2ZIQN6LB9jHBRhenSPsy3Pl9qcZAHvEtYQ==
X-Received: by 2002:a17:902:c3cc:b0:14f:cf9d:55e4 with SMTP id j12-20020a170902c3cc00b0014fcf9d55e4mr38701718plj.55.1646352880421;
        Thu, 03 Mar 2022 16:14:40 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id z35-20020a631923000000b00373520fddd5sm2969840pgl.83.2022.03.03.16.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 16:14:39 -0800 (PST)
Date:   Fri, 4 Mar 2022 00:14:36 +0000
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
Subject: Re: [PATCH v4 17/30] KVM: x86/mmu: Require mmu_lock be held for
 write to zap TDP MMU range
Message-ID: <YiFZ7IK2kKSgEgKj@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-18-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303193842.370645-18-pbonzini@redhat.com>
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

On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Now that all callers of zap_gfn_range() hold mmu_lock for write, drop
> support for zapping with mmu_lock held for read.  That all callers hold
> mmu_lock for write isn't a random coincidence; now that the paths that
> need to zap _everything_ have their own path, the only callers left are
> those that need to zap for functional correctness.  And when zapping is
> required for functional correctness, mmu_lock must be held for write,
> otherwise the caller has no guarantees about the state of the TDP MMU
> page tables after it has run, e.g. the SPTE(s) it zapped can be
> immediately replaced by a vCPU faulting in a page.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Message-Id: <20220226001546.360188-17-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 24 ++++++------------------
>  1 file changed, 6 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 970376297b30..f3939ce4a115 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -844,15 +844,9 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>   * function cannot yield, it will not release the MMU lock or reschedule and
>   * the caller must ensure it does not supply too large a GFN range, or the
>   * operation can cause a soft lockup.
> - *
> - * If shared is true, this thread holds the MMU lock in read mode and must
> - * account for the possibility that other threads are modifying the paging
> - * structures concurrently. If shared is false, this thread should hold the
> - * MMU lock in write mode.
>   */
>  static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> -			  gfn_t start, gfn_t end, bool can_yield, bool flush,
> -			  bool shared)
> +			  gfn_t start, gfn_t end, bool can_yield, bool flush)
>  {
>  	bool zap_all = (start == 0 && end >= tdp_mmu_max_gfn_host());
>  	struct tdp_iter iter;
> @@ -865,14 +859,13 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  
>  	end = min(end, tdp_mmu_max_gfn_host());
>  
> -	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
> +	lockdep_assert_held_write(&kvm->mmu_lock);
>  
>  	rcu_read_lock();
>  
>  	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
> -retry:
>  		if (can_yield &&
> -		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
> +		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
>  			flush = false;
>  			continue;
>  		}
> @@ -891,12 +884,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  		    !is_last_spte(iter.old_spte, iter.level))
>  			continue;
>  
> -		if (!shared) {
> -			tdp_mmu_set_spte(kvm, &iter, 0);
> -			flush = true;
> -		} else if (tdp_mmu_zap_spte_atomic(kvm, &iter)) {
> -			goto retry;
> -		}
> +		tdp_mmu_set_spte(kvm, &iter, 0);
> +		flush = true;
>  	}
>  
>  	rcu_read_unlock();
> @@ -915,8 +904,7 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
>  	struct kvm_mmu_page *root;
>  
>  	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
> -		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush,
> -				      false);
> +		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
>  
>  	return flush;
>  }
> -- 
> 2.31.1
> 
> 
