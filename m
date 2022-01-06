Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A21486D97
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 00:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245409AbiAFXOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 18:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234795AbiAFXOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 18:14:51 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F50CC061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 15:14:51 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id i6so3581870pla.0
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 15:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SI8DBL0o/aVm94tQ8JJ7SpLE3a1xQTYMxrG5MaI34+U=;
        b=FQBqK+rE2P4XQ84b096nWPwKAJLUgs7AVVLVBsb7duFOpbF531CCucvVppZxLk2I1d
         CRPirMRurXy4v+xc95vIFjvFgVUxzGNRnQ+irIfegDZTIuxnURNhhPAG72Drr0CGRwW/
         di557BYhHeAOVOgnpdX6tlMEW6k0o5yhkDU3XY4ysOe5XoAirCiYis0ORwtmqtnwJ0R3
         G0MguZWX9vUTtk0hGEbjHYxqeH8+mm8IuOusVLtI7Va8DKKmwXViEkiIS7Bs+GFY42x3
         qQTlNa5uxfaUDUw5puG2vCGQJN4xZeKzqaUiVwh9nb4ROQCyUiKwWduPLPpRzVd6zYOT
         gmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SI8DBL0o/aVm94tQ8JJ7SpLE3a1xQTYMxrG5MaI34+U=;
        b=e7vDI7s33nZOvo796xrfxCdqRRmwa77xfIYvQZvNTn9XKFcxTJPejotrjoGTi4Tke3
         vOZKMpIF49FvmnPAQQ6iUozggbmQGBVc33/fRJnTtgjuXatNfmw5ik93wYvToPh5jfsB
         VjfH90MbtXDGhiGUi7ahAbwCcc2x9DIzs7Sk3HBA6SgQ99al96ZaKv1PCRUID/vzbs7A
         3K0WBZ7YWrE/l4qIiFdjWfv/0CFFXWZNiwjOHNE1HbMpSKtLkohn77p+2H8/Gwv/eU8a
         BKbbYv6Ay7yDloeWyytX5/3J8gBUbv+q8NXfyYlz3Fe/JgaSniDzSivuXLMVS2ozSMBJ
         Rnnw==
X-Gm-Message-State: AOAM5318MLdYbmnWn5aYCdVr+CVzu9JM/2l1NBi+8YfCf5zeIjnfMvV5
        6CVyKBAUBJNcUO0yCEasIHZZTA==
X-Google-Smtp-Source: ABdhPJwJUikWM3T7ms39Jgc+akuxQABXr+06MTGDPLkqK2L/WqaiqaPayn4hVTTjRLzbnxjjl0Li2Q==
X-Received: by 2002:a17:90a:e7cc:: with SMTP id kb12mr12520257pjb.189.1641510890431;
        Thu, 06 Jan 2022 15:14:50 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h15sm3743324pfc.134.2022.01.06.15.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 15:14:49 -0800 (PST)
Date:   Thu, 6 Jan 2022 23:14:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 12/13] KVM: x86/mmu: Add tracepoint for splitting huge
 pages
Message-ID: <Ydd35kUoHp+7n272@google.com>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-13-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-13-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, David Matlack wrote:
> Add a tracepoint that records whenever KVM eagerly splits a huge page.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmutrace.h | 20 ++++++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c  |  2 ++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
> index de5e8e4e1aa7..4feabf773387 100644
> --- a/arch/x86/kvm/mmu/mmutrace.h
> +++ b/arch/x86/kvm/mmu/mmutrace.h
> @@ -416,6 +416,26 @@ TRACE_EVENT(
>  	)
>  );
>  
> +TRACE_EVENT(
> +	kvm_mmu_split_huge_page,
> +	TP_PROTO(u64 gfn, u64 spte, int level),
> +	TP_ARGS(gfn, spte, level),
> +
> +	TP_STRUCT__entry(
> +		__field(u64, gfn)
> +		__field(u64, spte)
> +		__field(int, level)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->gfn = gfn;
> +		__entry->spte = spte;
> +		__entry->level = level;
> +	),
> +
> +	TP_printk("gfn %llx spte %llx level %d", __entry->gfn, __entry->spte, __entry->level)
> +);
> +
>  #endif /* _TRACE_KVMMMU_H */
>  
>  #undef TRACE_INCLUDE_PATH
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index be5eb74ac053..e6910b9b5c12 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1325,6 +1325,8 @@ tdp_mmu_split_huge_page_atomic(struct kvm *kvm, struct tdp_iter *iter, struct kv
>  	u64 child_spte;
>  	int i;
>  
> +	trace_kvm_mmu_split_huge_page(iter->gfn, huge_spte, level);

This should either be called iff splitting is successful, or it should record
whether or not the split was successful.  The latter is probably useful info,
and easy to do, e.g. assuming this is changed to return an int like the lower
helpers:


	ret = tdp_mmu_install_sp_atomic(kvm, iter, sp, false);

	/*
	 * tdp_mmu_install_sp_atomic will handle subtracting the split huge
	 * page from stats, but we have to manually update the new present child
	 * pages on success.
	 */
	if (!ret)
		kvm_update_page_stats(kvm, level - 1, PT64_ENT_PER_PAGE);

	trace_kvm_mmu_split_huge_page(iter->gfn, huge_spte, level, ret);

	return ret;

and then the tracpoint can do 'ret ? "failed" : "succeeded"' or something.

> +
>  	init_child_tdp_mmu_page(sp, iter);
>  
>  	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
> -- 
> 2.34.1.173.g76aa8bc2d0-goog
> 
