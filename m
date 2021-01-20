Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C23B2FDA24
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 20:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392635AbhATTxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 14:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392577AbhATTwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 14:52:00 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127B7C061575
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 11:51:19 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id n25so15943112pgb.0
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 11:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ho40uXNVeEzmbuymns660lMAYcUzjvGL6hQs63ImnEI=;
        b=kCmlY27d4rW33C6mcWFBeausYRkKyZGU3CHchQcm1H6U1ntknRYOuhJsBghcqfKvh3
         L+tsHzNL+iQmLo7+I2aIxIsJRLlzm4IppSNxkr1F3RpGDQKGjpMwBq8TAGRv6DcDrwuU
         HVIg0DuJU4c4TAKX6F52IU6BPUL1g7exxgv4Hwrg8cAjoOir9RozsbYQbfY4dQcw3jD6
         WkXDCeSbGWeiguVGjCYxN5baR7uO1WuZz2gWHNPTXJMEQDawqH2yqWargsjUYL37ymw2
         KJMqnjyIHM90KR9b+agXjs4ZfaEhf5IW8sfGjAi0ks/nlQacFUFRzVkBItfFi4k/Ocot
         9dqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ho40uXNVeEzmbuymns660lMAYcUzjvGL6hQs63ImnEI=;
        b=qjtn+yEDM9/JD4KkWiLXPONVwCMGBbLgtmHN+PuIMgRrgqxKpZ2mQUbhFrX0qfxosm
         JDhGhYFrk40+AB6P4BUvkDW0a9nHJEyElBfPkcupOgf0hzulcYb7oZl5z3jK63h6/+wt
         7TihQaHHz1RRsLXFWA0A+GAw+eDwyO3C1a3jSbh1cq2PLErMLZXRG4YvZ+EAfpL5/Vuv
         iU5Gq891n4nbUf//X4A2hn/LAuZs9z8I1oWSdVkH4B/BQ/JCaDi48lszCz2aqExUfUQB
         LdDDebPXt/SfcNF3R4521pGXkpzK9bng1opseJ3Ca3dU/CxjDY+Y7qShQWSz0kXB+TUY
         bkRQ==
X-Gm-Message-State: AOAM533i5ESyAYc4vg9ONepi2EHnVA807YC7NjHhvy+EltA6BW2Zarmz
        sRDvBvoS80avt08MJUsWKl6V1Q==
X-Google-Smtp-Source: ABdhPJxBf4twl1WvPoyqDlnDRa2E13SugBSYrd52xyTfyuvoGA8UV5cbwPcp9SpMtZWePuSn+bj/MA==
X-Received: by 2002:a63:3088:: with SMTP id w130mr10990537pgw.210.1611172278304;
        Wed, 20 Jan 2021 11:51:18 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id k32sm1472368pjc.36.2021.01.20.11.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 11:51:17 -0800 (PST)
Date:   Wed, 20 Jan 2021 11:51:10 -0800
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
Subject: Re: [PATCH 06/24] kvm: x86/mmu: Skip no-op changes in TDP MMU
 functions
Message-ID: <YAiJrsyC1KSTKycg@google.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-7-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112181041.356734-7-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Ben Gardon wrote:
> Skip setting SPTEs if no change is expected.
> 
> Reviewed-by: Peter Feiner <pfeiner@google.com>
>
Nit on all of these, can you remove the extra newline between the Reviewed-by
and SOB?

> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 1987da0da66e..2650fa9fe066 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -882,6 +882,9 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  		    !is_last_spte(iter.old_spte, iter.level))
>  			continue;
>  
> +		if (!(iter.old_spte & PT_WRITABLE_MASK))

Include the new check with the existing if statement?  I think it makes sense to
group all the checks on old_spte.

> +			continue;
> +
>  		new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
>  
>  		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
> @@ -1079,6 +1082,9 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  		if (!is_shadow_present_pte(iter.old_spte))
>  			continue;
>  
> +		if (iter.old_spte & shadow_dirty_mask)

Same comment here.

> +			continue;
> +

Unrelated to this patch, but it got me looking at the code: shouldn't
clear_dirty_pt_masked() clear the bit in @mask before checking whether or not
the spte needs to be modified?  That way the early break kicks in after sptes
are checked, not necessarily written.  E.g.

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2650fa9fe066..d8eeae910cbf 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1010,21 +1010,21 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
                    !(mask & (1UL << (iter.gfn - gfn))))
                        continue;

-               if (wrprot || spte_ad_need_write_protect(iter.old_spte)) {
-                       if (is_writable_pte(iter.old_spte))
-                               new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
-                       else
-                               continue;
-               } else {
-                       if (iter.old_spte & shadow_dirty_mask)
-                               new_spte = iter.old_spte & ~shadow_dirty_mask;
-                       else
-                               continue;
-               }
-
-               tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
-
                mask &= ~(1UL << (iter.gfn - gfn));
+
+               if (wrprot || spte_ad_need_write_protect(iter.old_spte)) {
+                       if (is_writable_pte(iter.old_spte))
+                               new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
+                       else
+                               continue;
+               } else {
+                       if (iter.old_spte & shadow_dirty_mask)
+                               new_spte = iter.old_spte & ~shadow_dirty_mask;
+                       else
+                               continue;
+               }
+
+               tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
        }
 }


>  		new_spte = iter.old_spte | shadow_dirty_mask;
>  
>  		tdp_mmu_set_spte(kvm, &iter, new_spte);
> -- 
> 2.30.0.284.gd98b1dd5eaa7-goog
> 
