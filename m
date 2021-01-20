Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE23B2FD8A1
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 19:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387549AbhATSoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 13:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732217AbhATSjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 13:39:55 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D50C0613ED
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 10:38:43 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id o20so6633076pfu.0
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 10:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mElTic+jf8bgADKOBTWN16jkO/72eN/4k9grsPAxeFQ=;
        b=A2biDiJB3/jJkXDSRHqBba911K3ZGgYbXwVCQNl+xY3zxYE2mhzdnHw+EmzGl8YIaW
         PqGiVAcz+5CuAl8jh1IuoeqLdkvb2PTwfIVEM8s7rvRgM4oiYHK9xSII/KEzBPRpTXwq
         8DJHbAPeUkOkQYxsGxVctBhx/HT6t8t/l6EZuC8EzmEEKxEyjSUrbvd5qPEfDe3DI96i
         9XAXhzJDRTn5I5lVEgPZ6FGNcpfVizJph6HK0hiFybz9Xh0O1iGVVBlwoidqMOa56ev2
         +980GF2UW/K8+SVBbnellb+N17BLQA49IQhnX/McLWq8xCjVDbuCs0rISnHImNMSH7DW
         SMYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mElTic+jf8bgADKOBTWN16jkO/72eN/4k9grsPAxeFQ=;
        b=cBEd5N0Ikaztt4ajBZMaabIpIX1XdGcvEOOwJmzJB/asI5tm6SJdVfsg3AFTYYCyzh
         BEH6Tou3JAPmJEDhj4/jkIQOvcc7ZrOQlRr1YtMyUHS+NJUXophsc1IAitHFyadTeXuK
         SqrBYFFg4xxl42t5PJondE8DF/S0OcEd0QBzjvwQ7u5pjIrUIOHGLzve6IAIZqU+82CX
         MoIbdh/26deYFZQidHLsjYIoQuQXl+D9lCOVrVlvDp8aH9rJOHDz8194ASMYaPHMs7fA
         0UPx+EmEShjEUSqs87222LOPSYlNst8HdOm2lJsNI4iMWoxVQuC5dGSF1ikBR3kQMaCH
         F9Xw==
X-Gm-Message-State: AOAM531YxkcolZbFO6VcTxx2lnDnlyGareKtG4rwqJ/ibUawnZv7qCxf
        F2hICiuFXkVGW4wC7nt0AdTjIw==
X-Google-Smtp-Source: ABdhPJwNAX0ZQZCQRbuxONKq8kwAHK0E7euP+HiWMmED0RE75l4vS6eVLidiMD5nKK85hg30yjtouQ==
X-Received: by 2002:a63:c54c:: with SMTP id g12mr10491152pgd.449.1611167923133;
        Wed, 20 Jan 2021 10:38:43 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id g17sm3132050pfk.184.2021.01.20.10.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 10:38:42 -0800 (PST)
Date:   Wed, 20 Jan 2021 10:38:35 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 04/24] kvm: x86/mmu: change TDP MMU yield function
 returns to match cond_resched
Message-ID: <YAh4q6ZCOw3qDzHP@google.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-5-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112181041.356734-5-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Ben Gardon wrote:
> Currently the TDP MMU yield / cond_resched functions either return
> nothing or return true if the TLBs were not flushed. These are confusing
> semantics, especially when making control flow decisions in calling
> functions.
> 
> To clean things up, change both functions to have the same
> return value semantics as cond_resched: true if the thread yielded,
> false if it did not. If the function yielded in the _flush_ version,
> then the TLBs will have been flushed.
> 
> Reviewed-by: Peter Feiner <pfeiner@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 38 +++++++++++++++++++++++++++++---------
>  1 file changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 2ef8615f9dba..b2784514ca2d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -413,8 +413,15 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
>  			 _mmu->shadow_root_level, _start, _end)
>  
>  /*
> - * Flush the TLB if the process should drop kvm->mmu_lock.
> - * Return whether the caller still needs to flush the tlb.
> + * Flush the TLB and yield if the MMU lock is contended or this thread needs to
> + * return control to the scheduler.
> + *
> + * If this function yields, it will also reset the tdp_iter's walk over the
> + * paging structure and the calling function should allow the iterator to
> + * continue its traversal from the paging structure root.
> + *
> + * Return true if this function yielded, the TLBs were flushed, and the
> + * iterator's traversal was reset. Return false if a yield was not needed.
>   */
>  static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
>  {
> @@ -422,18 +429,30 @@ static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *it
>  		kvm_flush_remote_tlbs(kvm);
>  		cond_resched_lock(&kvm->mmu_lock);
>  		tdp_iter_refresh_walk(iter);
> -		return false;
> -	} else {
>  		return true;
> -	}
> +	} else
> +		return false;

Kernel style is to have curly braces on all branches if any branch has 'em.  Or,
omit the else since the taken branch always returns.  I think I prefer the latter?

>  }
>  
> -static void tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
> +/*
> + * Yield if the MMU lock is contended or this thread needs to return control
> + * to the scheduler.
> + *
> + * If this function yields, it will also reset the tdp_iter's walk over the
> + * paging structure and the calling function should allow the iterator to
> + * continue its traversal from the paging structure root.
> + *
> + * Return true if this function yielded and the iterator's traversal was reset.
> + * Return false if a yield was not needed.
> + */
> +static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
>  {
>  	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
>  		cond_resched_lock(&kvm->mmu_lock);
>  		tdp_iter_refresh_walk(iter);
> -	}
> +		return true;
> +	} else
> +		return false;

Same here.

>  }
>  
>  /*
> @@ -470,7 +489,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  		tdp_mmu_set_spte(kvm, &iter, 0);
>  
>  		if (can_yield)
> -			flush_needed = tdp_mmu_iter_flush_cond_resched(kvm, &iter);
> +			flush_needed = !tdp_mmu_iter_flush_cond_resched(kvm,
> +									&iter);

As with the existing code, I'd let this poke out.  Alternatively, this could be
written as:

		flush_needed = !can_yield ||
			       !tdp_mmu_iter_flush_cond_resched(kvm, &iter);

>  		else
>  			flush_needed = true;
>  	}
> @@ -1072,7 +1092,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>  
>  		tdp_mmu_set_spte(kvm, &iter, 0);
>  
> -		spte_set = tdp_mmu_iter_flush_cond_resched(kvm, &iter);
> +		spte_set = !tdp_mmu_iter_flush_cond_resched(kvm, &iter);
>  	}
>  
>  	if (spte_set)
> -- 
> 2.30.0.284.gd98b1dd5eaa7-goog
> 
