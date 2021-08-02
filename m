Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12E13DDDBD
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 18:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbhHBQbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 12:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbhHBQbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 12:31:48 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1E5C06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 09:31:39 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so32477116pjb.3
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 09:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6/fNrythWmIOKKll38nej43mPI6++VqVAuAeiAew7vs=;
        b=Xaj0/veFdnth5pF2RWy/FUed8t6jLt105uYfChr69Z3tacbSAHatBKY2HK+Q7iUSdJ
         rGCYnbTu46MSGurpvv6W8uluqfoU2VOLJoVFGfV3ryNfyP/Sk8F6SeoPusXRcHjEeweh
         rmXO+05E7RDx+cvtZhj5SyzmRcedi/n7LMCsjzE5J9L6bKlK/PBeUc+3w2sh42F18pqF
         FPCJLPjj7aU8BTEJt6vmFnt5Jnf/XG7pMMFBs2PZsOYcdDJBdRsSWh47uDoZyDFH3Q8Z
         ++is8AaIKHPOlcE3KwZCVj1GMdRWZMeV2C8d1gCZMGlpIUqr3VFLQnq3h6UBCJ05dI/P
         bOXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6/fNrythWmIOKKll38nej43mPI6++VqVAuAeiAew7vs=;
        b=CcMuYTHR2v4ZTn+VWZ1pfg1K7EpCaHlc4mdNqHs8uUew/3F6RIBxnT5R2OmvXzdnnQ
         t48xynGanyIWnfUobSzxRLRyGjkNcD52Z0UMZ1f3I3nMdHzHjvBb9zBRQPb8ugjXE8yl
         X66txs/2iqCKRX1FYB96/+DeY4Cz0t9Zar+fRHPChC535AB5Q9SCCx5thd+tn3kiNLq9
         3wS/jtpi5b2PQnzkNzztHh3yq44k46DocQG7yi+fVJJlE0Foj2xMLL+SgBKKA63mcNSZ
         LaR6Mm5/4KFB2auC4+1laV6v2iA1ACzr4t4FVG8sqMPmGjvSEPel/JYiZBhpH2yGpab2
         Afvg==
X-Gm-Message-State: AOAM531ii7yKcPHozFTiiyQSZelIlWz1itInYoJz7P2GJSW5WxiGVY38
        CNTQ0eTPcAK696DWVFfpV6gpYbEwwGIn9g==
X-Google-Smtp-Source: ABdhPJylFe8yZE+3X6TYqKklHHaqi9cGbAUoZ1WnwMP62FHegItSAvhPaDqxnvl5Mh+d0VKVGZ0vfw==
X-Received: by 2002:a17:90a:1546:: with SMTP id y6mr17854764pja.17.1627921898676;
        Mon, 02 Aug 2021 09:31:38 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id k6sm10458221pgk.1.2021.08.02.09.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 09:31:37 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:31:34 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 3/6] KVM: x86/mmu: Speed up dirty logging in
 tdp_mmu_map_handle_target_level
Message-ID: <YQgd5qBbn/1NKGOn@google.com>
References: <20210730223707.4083785-1-dmatlack@google.com>
 <20210730223707.4083785-4-dmatlack@google.com>
 <279056b0-38c0-6ee4-c581-e2328c120b2e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <279056b0-38c0-6ee4-c581-e2328c120b2e@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 02, 2021 at 04:58:17PM +0200, Paolo Bonzini wrote:
> On 31/07/21 00:37, David Matlack wrote:
> > -	if (new_spte == iter->old_spte)
> > +	if (new_spte == iter->old_spte) {
> >   		ret = RET_PF_SPURIOUS;
> > -	else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
> > -		return RET_PF_RETRY;
> > +	} else {
> > +		if (!tdp_mmu_set_spte_atomic_no_dirty_log(vcpu->kvm, iter, new_spte))
> > +			return RET_PF_RETRY;
> > +
> > +		/*
> > +		 * Mark the gfn dirty here rather that through the vcpu-agnostic
> > +		 * handle_changed_spte_dirty_log to leverage vcpu->lru_slot_index.
> > +		 */
> > +		if (is_writable_pte(new_spte))
> > +			kvm_vcpu_mark_page_dirty(vcpu, iter->gfn);
> > +	}
> 
> Looking at the remaining callers of tdp_mmu_set_spte_atomic we have:
> 
> * tdp_mmu_zap_spte_atomic calls it with REMOVED_SPTE as the new_spte, which
> is never writable
> 
> * kvm_tdp_mmu_map calls it for nonleaf SPTEs, which are always writable but
> should not be dirty.
> 
> 
> So I think you should:
> 
> * change those two to tdp_mmu_set_spte_atomic_no_dirty_log
> 
> * add a WARN_ON_ONCE(iter->level > PG_LEVEL_4K) to tdp_mmu_set_spte_atomic
> 
> * put the kvm_vcpu_mark_page_dirty code directly in tdp_mmu_set_spte_atomic,
> instead of the call to handle_changed_spte_dirty_log
> 
> (I can't exclude I'm missing something though).

Makes sense. I'll take a look to confirm and make those changes in v2.

> 
> Paolo
> 
