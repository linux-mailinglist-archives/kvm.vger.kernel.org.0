Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D593A71EC
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 00:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhFNWaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 18:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhFNWaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 18:30:14 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74C4C061574
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 15:27:55 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id k7so10609262pjf.5
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 15:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4OmGnzWSQFupy7cZPXTGR7Cx6p3oef2S1yGq1a+RnO8=;
        b=fPWtmg1LykQeiLmGl8cZBGm2/l6Tm+I13KK5uuXr3MNInm/vntg4pInglDr9nT2Bbc
         Xep3yRRYZJ9zl7Qa2LSJlsJAcOu23sXlbqTRqy5wPaFOE4uowm0t+9aOtRKwsfv+Y1dU
         uxw+Ig5RSg7AkvrWOfiFzYyLD9dR1OGbbU8o9UEV2q5jhbz3tlGt1NxE0dSJd+2DVVhv
         WNZXYwIzRZynI4Mk1LwavlQtT1PbrW9lAwSNqUPPuGKYTKhGlOylC7JVn05rho6LRPsp
         jpCFxLiVOW0a0SXZ3g57WCGmD5fLJsRpF0k9NgREm11pVeGJnQWalzJ78uyD5q6ugeXi
         KYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4OmGnzWSQFupy7cZPXTGR7Cx6p3oef2S1yGq1a+RnO8=;
        b=CE8ndLwCAhq+U7kBXDW/8x1ZJnYvFS/VGK6V1NIjzIwjIxLbFrYL3+23ZGp2lQCZyZ
         uQI9fOPAeceS5voDl/ARUAUDctj3nyt8pcNn8F7ELFV0nr/pqkq05G/LzM3ZbG3bOwSz
         DC+JVMocsAsv9i9dTzeIAg/oIdDTyvT7aebuU3WJLJnYRoNx26ksgYUfXiOux3YennN2
         o7ecjVKMMy/hYHWqNO2Gw2aAgS8u3V9zHkCSG6sV0UhfO6a83107to2mWSq5T9XkGA6Z
         40Ej79YNLMaWTbin77IKskYTZpY4OZ8GtnzOj4AbU0L/MEwkGFNUP4ZQPEcZNlheyi+s
         q1og==
X-Gm-Message-State: AOAM532PAxFqs5Dkd4UIf38G6Bq1C8P1bydF1urYLiCROlJgHU9pKfB+
        ay9sGyhbvwldSRqZD+7VJVJFHbXglLJiqw==
X-Google-Smtp-Source: ABdhPJyULL1SJNZw97g0yPWxdgCszVguhctAQQ9a3b+dfy10H2yHYh0x0mr1KfRW/WTxceEvC0/OWA==
X-Received: by 2002:a17:90a:f303:: with SMTP id ca3mr425648pjb.120.1623709674340;
        Mon, 14 Jun 2021 15:27:54 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id ls13sm12318212pjb.23.2021.06.14.15.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:27:53 -0700 (PDT)
Date:   Mon, 14 Jun 2021 22:27:49 +0000
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 5/8] KVM: x86/mmu: Also record spteps in shadow_page_walk
Message-ID: <YMfX5QyBQ44cAkiJ@google.com>
References: <20210611235701.3941724-1-dmatlack@google.com>
 <20210611235701.3941724-6-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611235701.3941724-6-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021 at 11:56:58PM +0000, David Matlack wrote:
> In order to use walk_shadow_page_lockless() in fast_page_fault() we need
> to also record the spteps.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 1 +
>  arch/x86/kvm/mmu/mmu_internal.h | 3 +++
>  arch/x86/kvm/mmu/tdp_mmu.c      | 1 +
>  3 files changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8140c262f4d3..765f5b01768d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3538,6 +3538,7 @@ static bool walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
>  		spte = mmu_spte_get_lockless(it.sptep);
>  		walk->last_level = it.level;
>  		walk->sptes[it.level] = spte;
> +		walk->spteps[it.level] = it.sptep;
>  
>  		if (!is_shadow_present_pte(spte))
>  			break;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 26da6ca30fbf..0fefbd5d6c95 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -178,6 +178,9 @@ struct shadow_page_walk {
>  
>  	/* The spte value at each level. */
>  	u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
> +
> +	/* The spte pointers at each level. */
> +	u64 *spteps[PT64_ROOT_MAX_LEVEL + 1];
>  };
>  
>  #endif /* __KVM_X86_MMU_INTERNAL_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 36f4844a5f95..7279d17817a1 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1529,6 +1529,7 @@ bool kvm_tdp_mmu_walk_lockless(struct kvm_vcpu *vcpu, u64 addr,
>  
>  		walk->last_level = iter.level;
>  		walk->sptes[iter.level] = iter.old_spte;
> +		walk->spteps[iter.level] = iter.sptep;

I think this should technically be:

		walk->spteps[iter.level] = rcu_dereference(iter.sptep);

>  	}
>  
>  	return walk_ok;
> -- 
> 2.32.0.272.g935e593368-goog
> 
