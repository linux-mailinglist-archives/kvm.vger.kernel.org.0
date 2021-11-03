Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930D9444A74
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 22:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhKCVs0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 17:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhKCVsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 17:48:25 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE598C061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 14:45:48 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id j9so3575651pgh.1
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 14:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9HQuN6/j/2lyJCBx063XgkgNwuUGBxex5WAcqFNAykM=;
        b=kXdM9BEDI6eIklkLMaYrFsd+GGOqDQkeR/1/VbbdulMWvRZtMD9c/U4Ti7qfwOqb7E
         BW6sb0LmQ2X7yf4qLdRoKe8EYVd829FMASDMI1tmMpSUK58SBJOlGv/arCC6gz3izM6w
         wNWZfQdNTkNUBKOOXl2+pQARBQ4lbu57Ce3xly+d0WuEz5eRYBeXqnSVl/0WekHetrDx
         4qzrwMdVDbV4bd76Ch4pAJNoFrJ8udLy1vnVXeKvGEcoQV598vW5ST33sAG99oQrTdC6
         pvYwALc//xYgwi4Q/aSle3xdzrokgZlT5r5JW1Jn8+Btv4fxBro+byS7HH1NyH5ZIhRp
         K5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9HQuN6/j/2lyJCBx063XgkgNwuUGBxex5WAcqFNAykM=;
        b=GxuSMkeZhiHudN9VgYYXaTJb8WWlC+U0BupQvGORXx4nHc+jV0ebTph17Dzxv1FFfO
         oO6JfVbbeqOEzjEoMtwrpFe2KDAsIvWM8EG4y3YyVxetdfsb7DVCvId3nUJF+S75lXTC
         S4RtiMThZ8Ih5Pcgu7H7DMccBC18GD07SVVocIzIIV2AfyY33AtM+aj5JgcXS6OXT3WS
         5hMOrRcNF2/IIZOk9/1Jq0fi6QzUUoS4nrh89RJrRRRuvqjWb4o2Tobjhd/vmvWs6n+5
         VFbPCHH4j8ibNQQbN13kzTiG4Lmy9sGKXtdrwT/nXOLebxMaj88rMX6a/BW6jKT4XCmq
         5RPw==
X-Gm-Message-State: AOAM531w2eyhXasS8hGYSmwYRUDxJ1lkipylzH9QQXHHKeVzmWLxVxIE
        Nkc50oaHdIa2GQf3IwIAgAkAMQ==
X-Google-Smtp-Source: ABdhPJzUV+SIeZImeUavwxhJH2HEkwKsTzzo4CmxmerFaL6zS+MJZSBmc30FLWU+NNaPbqnl53Vc8Q==
X-Received: by 2002:a05:6a00:23ce:b0:480:fee1:5495 with SMTP id g14-20020a056a0023ce00b00480fee15495mr27790636pfc.71.1635975948285;
        Wed, 03 Nov 2021 14:45:48 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m22sm3287631pfo.176.2021.11.03.14.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 14:45:47 -0700 (PDT)
Date:   Wed, 3 Nov 2021 21:45:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Junaid Shahid <junaids@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        bgardon@google.com
Subject: Re: [PATCH] kvm: mmu: Use fast PF path for access tracking of huge
 pages when possible
Message-ID: <YYMDCPNuUdt2EukD@google.com>
References: <20211102032900.1888262-1-junaids@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102032900.1888262-1-junaids@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 01, 2021, Junaid Shahid wrote:
> The fast page fault path bails out on write faults to huge pages in
> order to accommodate dirty logging. This change adds a check to do that
> only when dirty logging is actually enabled, so that access tracking for
> huge pages can still use the fast path for write faults in the common
> case.
>
> Signed-off-by: Junaid Shahid <junaids@google.com>

One nit, otherwise

Reviewed-by: Sean Christopherson <seanjc@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 354d2ca92df4..5df9181c5082 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3191,8 +3191,9 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  			new_spte |= PT_WRITABLE_MASK;
>  
>  			/*
> -			 * Do not fix write-permission on the large spte.  Since
> -			 * we only dirty the first page into the dirty-bitmap in
> +			 * Do not fix write-permission on the large spte when
> +			 * dirty logging is enabled. Since we only dirty the
> +			 * first page into the dirty-bitmap in
>  			 * fast_pf_fix_direct_spte(), other pages are missed
>  			 * if its slot has dirty logging enabled.
>  			 *
> @@ -3201,7 +3202,8 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  			 *
>  			 * See the comments in kvm_arch_commit_memory_region().

This part is slightly stale as kvm_mmu_slot_apply_flags() now has the comments.
Maybe just drop it entirely?  The comments there don't do a whole lot to make this
code more understandable.

>  			 */
> -			if (sp->role.level > PG_LEVEL_4K)
> +			if (sp->role.level > PG_LEVEL_4K &&
> +			    kvm_slot_dirty_track_enabled(fault->slot))
>  				break;
>  		}
>  
> -- 
> 2.33.1.1089.g2158813163f-goog
> 
