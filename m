Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A346167BF79
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 23:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjAYWAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 17:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjAYWAt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 17:00:49 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A7572AD
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 14:00:48 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id v23so252815plo.1
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 14:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CjT1dbymEsx/nGo8Ff/gbWc2laNtpBN8+A+ebSAuNHI=;
        b=Gdb/5Hi9ySGuGRi/Z8KzsQyFYvMd8fDtuwa+PCyu31w2O6MVApq40hq4jYhUHIQRC7
         S6ZteyTZbjtrXfNgIShVQJ/uUERQox3PB1cuCfPFrpDbrnNbvHeQS32u6RbdffX6ww2q
         DQhlvbs8PBHTO+W5qvEudZszpwpyyUXbBA8/UO2ahPtjIL6VKIXWTQH4s0LNj9G9TzPW
         XloPFQFBKXSxBH1GHCO8wfkDwbKa0J6v6iMkAVYmWpqGmROXc8Ti6hM2czVgWFx/gOrt
         U+eTDr3W/dbC2jiNRZYoPRzMoiNw98QrqascfpBqoO4Wz1C1Kg8c+YY3LITuvcy6sVSG
         J0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CjT1dbymEsx/nGo8Ff/gbWc2laNtpBN8+A+ebSAuNHI=;
        b=UjNFWowAXRxmfzuSwkhlQPb9QeDr4/cSDqLUTMcA/YohsS4oxLd+bHekJJnVkaffHS
         Lqb/RR5KialwxIxCTfzu8EZb2Du9RlyVBa7Ngnn2ffyr2SX1xYtEa5DyxKscwDxR3iU3
         V4ZORwFQP1yO2oWBcv+bi8ggk9nuAR3oqM+f9g+deLZoUWpO9+Jpmh0mVQ73FlEBOg/E
         HvoMinBLG761Tpqno324eIgqsbW1SKQanSyFwbWC+sSxe0GGOlqM+vlL2Hw1pEFGkXhd
         oDeJk4xLXjEuJdj5AdjhLm5/hO6e6RTte4IWZG3mfM+us98hSf2pbMCMgLtludMMaEIp
         w4wg==
X-Gm-Message-State: AFqh2kov2whDp03i7p/KJPjPZ/wHcyLZB34PRpQn0CV2cd/1txP2J3YY
        vuqu+OGKR02iWbG9Sl3uTInh1Yba9tE4Amztgw8=
X-Google-Smtp-Source: AMrXdXvE2rm8GMTJHJLuJ1uZDGfVwEDBYVLDWbVVmmO/mbrwhHQYNj67+yLr01fhTU5WmWT3Wci6dw==
X-Received: by 2002:a17:90b:3a82:b0:22b:b67b:3266 with SMTP id om2-20020a17090b3a8200b0022bb67b3266mr20388876pjb.19.1674684048181;
        Wed, 25 Jan 2023 14:00:48 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id j23-20020a17090a7e9700b0022bfbb26bbcsm2147494pjl.0.2023.01.25.14.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 14:00:47 -0800 (PST)
Date:   Wed, 25 Jan 2023 14:00:43 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch] KVM: x86/mmu: Make optimized __handle_changed_spte() for
 clear dirty log
Message-ID: <Y9GmiyRQ6sULCjEG@google.com>
References: <20230125213857.824959-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125213857.824959-1-vipinsh@google.com>
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

On Wed, Jan 25, 2023 at 01:38:57PM -0800, Vipin Sharma wrote:
> Use a tone down version of __handle_changed_spte() when clearing dirty
> log. Remove checks which will not be needed when dirty logs are cleared.
> 
> This change shows ~13% improvement in clear dirty log calls in
> dirty_log_perf_test
> 
> Before tone down version:
> Clear dirty log over 3 iterations took 10.006764203s. (Avg 3.335588067s/iteration)
> 
> After tone down version:
> Clear dirty log over 3 iterations took 8.686433554s. (Avg 2.895477851s/iteration)
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index bba33aea0fb0..ca21b33c4386 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -504,6 +504,19 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>  	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
>  
> +static void handle_changed_spte_clear_dirty_log(int as_id, gfn_t gfn,
> +						u64 old_spte, u64 new_spte,
> +						int level)
> +{
> +	if (old_spte == new_spte)
> +		return;
> +
> +	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
> +
> +	if (is_dirty_spte(old_spte) &&  !is_dirty_spte(new_spte))
> +		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
> +}
> +
>  /**
>   * __handle_changed_spte - handle bookkeeping associated with an SPTE change
>   * @kvm: kvm instance
> @@ -736,7 +749,12 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>  
>  	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
>  
> -	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
> +	if (record_dirty_log)
> +		__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte,
> +				      level, false);
> +	else
> +		handle_changed_spte_clear_dirty_log(as_id, gfn, old_spte,
> +						    new_spte, level);

I find it very non-intuitive to tie this behavior to !record_dirty_log,
even though it happens to work. It's also risky if any future calls are
added that pass record_dirty_log=false but change other bits in the
SPTE.

I wonder if we could get the same effect by optimizing
__handle_changed_spte() to check for a cleared D-bit *first* and if
that's the only diff between the old and new SPTE, bail immediately
rather than doing all the other checks.
