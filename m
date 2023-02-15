Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC10698734
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 22:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjBOVPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 16:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjBOVPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 16:15:22 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4CA30FF
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 13:15:19 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id mg23so12965912pjb.0
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 13:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xyt90e59gy0D9v4MU/RGcEHWAuStwT4uR+WhtHVXIv8=;
        b=V2G72BrVvPYmH/82LD20y64j3/WlzRD2lTSl5WCxusI0i1D2EMSCeje9wjUEhGhyMu
         8G0XY3BF98G+drPxh6pbkbeiOIW+ysBrrqBHay3mrBlj3r12eXa3/prbsQBTfW/nvf5Z
         YQjU/XPQHZgF8jmiESprlewk+Th6ZXkhg0Vmy1WIp67/SNZuVLp6TmrlkJN1ZDZ0kNrc
         zgLipACBdf5xNz0gQUIS0RmIo2Ax38rtFf0ppcsk79w8Xg1JAjouqcFq+MtXyXDYP9SC
         n6Cr8b+RaWhUrTMoB+yQ4W4XUD4kuX14ev5PV+N/qSeM+YNqOuEkobdpqVbLLVDFowU+
         CRhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xyt90e59gy0D9v4MU/RGcEHWAuStwT4uR+WhtHVXIv8=;
        b=dfKaTl9EKd6I8dWIY9aG11zBR/MfHqPHIAdrU0nIgDPEX5tWbPGwjxdtFaaHqMQcU+
         2iHe9QFIIjyBXDJe8SPLCYST6BACl26aKOeA6cgedTshxBuE0cvoSkQbu8JhCT91rogG
         LYq9xQKFxrFiJ/PvW2u0qNZYi+FSxxeav343SQPQUyN6TQp8HtKZITm3rcPqKJrGBcug
         L4qHwtTedeXK7RBJzNVwx79SIiB80rhSuCFtbch7b35ky9+CDuyuS9rcu1x8+QqKTWoP
         ojfyumUHic7va49wKAhfGxq5XbSayz9nMAtzyj5aFFyZuyQtx8prmsQAKLUz6oBC4xZF
         S0Dg==
X-Gm-Message-State: AO0yUKWEbRtBSaB/Re2TLS7g8ckzLf9wM8gmpFB2F1Jhdy8Krc0i1LAA
        aWEo5YdTU+/Zns4qMogrhB53cQ==
X-Google-Smtp-Source: AK7set9+gfUn30gSlptLS4iRT6JV03k0TV0qY49Jqm8tt9Ym3C4ij/OdTO3MKy8fiBGx02btYak4UQ==
X-Received: by 2002:a05:6a21:6d9e:b0:bd:1058:29b2 with SMTP id wl30-20020a056a216d9e00b000bd105829b2mr3904447pzb.58.1676495718545;
        Wed, 15 Feb 2023 13:15:18 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id j14-20020aa7800e000000b00571cdbd0771sm12157675pfi.102.2023.02.15.13.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 13:15:17 -0800 (PST)
Date:   Wed, 15 Feb 2023 13:15:13 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 4/7] KVM: x86/mmu: Optimize SPTE change for aging gfn
 range
Message-ID: <Y+1LYdjXu4H6PX1L@google.com>
References: <20230211014626.3659152-1-vipinsh@google.com>
 <20230211014626.3659152-5-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230211014626.3659152-5-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023 at 05:46:23PM -0800, Vipin Sharma wrote:
> No need to check all of the conditions in __handle_changed_spte(). Aging
> a gfn range implies resetting access bit or marking spte for access
> tracking.

nit: State what the patch does first.

> 
> Use atomic operation to only reset those bits. This avoids checking many
> conditions in __handle_changed_spte() API. Also, clean up code by
> removing dead code and API parameters.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>

nits aside,

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 36 +++++++++++++++++++-----------------
>  1 file changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index c895560244de..5d6e77554797 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -758,13 +758,6 @@ static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>  	_tdp_mmu_set_spte(kvm, iter, new_spte, true);
>  }
>  
> -static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
> -						 struct tdp_iter *iter,
> -						 u64 new_spte)
> -{
> -	_tdp_mmu_set_spte(kvm, iter, new_spte, false);
> -}
> -
>  #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
>  	for_each_tdp_pte(_iter, _root, _start, _end)
>  
> @@ -1251,32 +1244,41 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
>  /*
>   * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
>   * if any of the GFNs in the range have been accessed.
> + *
> + * No need to mark corresponding PFN as accessed as this call is coming from
> + * the clear_young() or clear_flush_young() notifier, which uses the return
> + * value to determine if the page has been accessed.
>   */
>  static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
>  			  struct kvm_gfn_range *range)
>  {
> -	u64 new_spte = 0;
> +	u64 new_spte;
>  
>  	/* If we have a non-accessed entry we don't need to change the pte. */
>  	if (!is_accessed_spte(iter->old_spte))
>  		return false;
>  
> -	new_spte = iter->old_spte;
> -
> -	if (spte_ad_enabled(new_spte)) {
> -		new_spte &= ~shadow_accessed_mask;
> +	if (spte_ad_enabled(iter->old_spte)) {
> +		iter->old_spte  = tdp_mmu_clear_spte_bits(iter->sptep,

nit: Extra space before =
