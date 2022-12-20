Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9945D6525CE
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiLTRxr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiLTRxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:53:45 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9895BBE29
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 09:53:44 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d15so13021177pls.6
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 09:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7kMtd6mFHIc4lyhSJG2bAKq04EpZF7qYfB8BpwW0nVo=;
        b=DyCDc111EoEh+DmSSMOeFWtySplI1Ib9bmFK44m9bE1COHOn/+Kpk3ddIYdz7TdNMQ
         yRrGN+EFGsnSr94QcB+Cx9h31S1FQBPw4oQX+RGgzobFttJfsNTy8UAHqeLZFvFqGEN+
         7RGeBsCvFnl7JPXOS/s34AScNFaOG2gS7l9Q7eguuDtxIe5z3uE4l6CGby9Nw/dXHNFV
         N2RcO0kSJtmKNbHRTMfMynVCBSSOtsTRHbD8j0ucsT3hBp9fYZ9yVYTMpv0Cg84tOjr7
         S6HfQVcVmXGe1eltsbNywOdScXRVxOWL3iQBdLU+XAC8NXmWoA5528Bvt2bmFhRHCHPd
         5P6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7kMtd6mFHIc4lyhSJG2bAKq04EpZF7qYfB8BpwW0nVo=;
        b=eW/e214WC4ett38/cMcx40bu3s1BQue+cjvuOhC346YMqXaN/bCCv55MeX/7z2ovWv
         O83XWLR0tJwIUsHSyWSLsr9W3xpBqg9vPH9m4Lk1BznjMlCMClzb5NDmIyAYjU7eVcwX
         Iq7jkOesg+8Zxxt+ghPWeKMBg57OG5bJURX1mrIe+lLz48bdutxwVDR4xTE+yAzB2LWu
         2612wiI15r7tgX9yrCCImaAIChG19OIORweU0PqfuJmZwTc6/QfiL3Qy2JyvZd2aa2Xe
         3tcC5sDdSw2EjrZ3SiUF0TNfDLuUOe2cYPkS5dEvL1CAkoTEgPERKk+1l3HBC4wvwTFy
         gCgg==
X-Gm-Message-State: ANoB5pnA6xu+b8+sKAKNNcoI4lOUiD0niYZ9mo76AF5zuy8WPB9fNhck
        TKuoeciUo8r3+6QIZbMKHPDJNA==
X-Google-Smtp-Source: AA0mqf4eoxE+3oewFG3WTI/JCe7yAnoR/fzEyYECfgKB0p4Yu/W4BXjz/RNAe/cakHnILwsg49OuTw==
X-Received: by 2002:a17:90b:1484:b0:21b:e47f:2fb2 with SMTP id js4-20020a17090b148400b0021be47f2fb2mr47394121pjb.37.1671558823931;
        Tue, 20 Dec 2022 09:53:43 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id om7-20020a17090b3a8700b001fde655225fsm2216367pjb.2.2022.12.20.09.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 09:53:43 -0800 (PST)
Date:   Tue, 20 Dec 2022 09:53:39 -0800
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>,
        Greg Thelen <gthelen@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH 5/5] KVM: x86/mmu: Move kvm_tdp_mmu_map()'s prolog and
 epilog to its caller
Message-ID: <Y6H2o2ADCALDA2oL@google.com>
References: <20221213033030.83345-1-seanjc@google.com>
 <20221213033030.83345-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213033030.83345-6-seanjc@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 13, 2022 at 03:30:30AM +0000, Sean Christopherson wrote:
> Move the hugepage adjust, tracepoint, and RCU (un)lock logic out of
> kvm_tdp_mmu_map() and into its sole caller, kvm_tdp_mmu_page_fault(), to
> eliminate the gotos used to bounce through rcu_read_unlock() when bailing
> from the walk.
> 
> Opportunistically mark kvm_mmu_hugepage_adjust() as static as
> kvm_tdp_mmu_map() was the only external user.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          |  9 ++++++++-
>  arch/x86/kvm/mmu/mmu_internal.h |  1 -
>  arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++------------------
>  3 files changed, 12 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 254bc46234e0..99c40617d325 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3085,7 +3085,8 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
>  	return min(host_level, max_level);
>  }
>  
> -void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> +static void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu,
> +				    struct kvm_page_fault *fault)
>  {
>  	struct kvm_memory_slot *slot = fault->slot;
>  	kvm_pfn_t mask;
> @@ -4405,7 +4406,13 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
>  	if (is_page_fault_stale(vcpu, fault))
>  		goto out_unlock;
>  
> +	kvm_mmu_hugepage_adjust(vcpu, fault);

Can you also move the call to kvm_mmu_hugepage_adjust() from
direct_map() to direct_page_fault()? I do think it's worth the
maintenence burden to keep those functions consistent.

> +
> +	trace_kvm_mmu_spte_requested(fault);
> +
> +	rcu_read_lock();
>  	r = kvm_tdp_mmu_map(vcpu, fault);
> +	rcu_read_unlock();

I would prefer to keep these in tdp_mmu.c, to reduce the amount of TDP
MMU details that bleed into mmu.c (RCU) and for consistency with other
TDP MMU APIs that don't require the caller to acquire RCU.  This will
also be helpful for the Common MMU, as the tracepoint and RCU will be
common.

e.g.

static int __kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
{
	...
}

int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
{
	int r;

	trace_kvm_mmu_spte_requested(fault);

	rcu_read_lock();
	r = __kvm_tdp_mmu_map(vcpu, fault);
	rcu_read_unlock();

	return r;
}
