Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BAF3D98ED
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 00:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhG1WcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 18:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbhG1WcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 18:32:00 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D667AC0613D5
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 15:31:56 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso6296720pjo.1
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 15:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4EOLGfIgju2Hvli/6D/hx+/lwjRcH7NCagC19mzzbto=;
        b=Gb2lWfRRrZOCipzLboTCyd8ip2X5sq8STvhzVnNOKAdq7jJ6uEfSFYPOZ72YDwVjrL
         MihCSGQvz9HHyLoJ+CWwfGQbVD3snRPPtI66AJGAylng4Mm8Ety+Kct7YXrDpLD0lU3x
         smoI8LLyZQj4usYW6mQZK55CZUbz4ovZZfFul7UKu8eBWvat00CdoAOA0sqknqJ+vsZ4
         mMId10tDUIfnpHVMG14BYAzC0XLD8xBYruSEWDIiMf2lje4qm/9MDsaw0ZeHunX1Rid/
         Me/2A0gc5AaJ2kDXW3qTyTnbfYH322ZeFX15Pxu02PZFj4CUSqZ9OVqIiJ+RW/WIfrtp
         OpnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4EOLGfIgju2Hvli/6D/hx+/lwjRcH7NCagC19mzzbto=;
        b=jFx9/gQzmZCfGraL+jINv4qrnxhQdKWVA+D7QvcgRdbOVDCtNs6rsN3JM6APs8gc6L
         DaDsiwX61N2igVPX2VyPFszCS242pYOwvA+OWhRU7P6I1E0m7VP4UY2Fvjz04ot9dTpU
         3TvpyPECdVDEGq96e/W6oLCGg/VZp1ptt8doMnvhrX4ZpsovoGa6X+elxe7FyLTIiWoN
         nuK8igRX84ii9UjuNf/+OugXod8mQ98zR97ANQfvgPqvWaFaZ5Bo/XeiB+zAgbYsJXXH
         xFqoBoQ4Qk10uJt/AX0cF9bG4ogmkKBSjVQzH2YSF8R0dEZbOD+SJvkwmM8pr21ijLgu
         oS/Q==
X-Gm-Message-State: AOAM532HzARMmQL8jc9beuwje875H0+7qzPy1EPO/Wx/Kv6ZBr5C6Im+
        aZChrJm859NDbIOTNXJSFWdx5A==
X-Google-Smtp-Source: ABdhPJyST6XeGLZhicf1sD0ee9ilIj+7CH1GqxSzZY42vuYPnjF9ZCYbt4p1c061Ll+/9L5OqLkUUQ==
X-Received: by 2002:aa7:938c:0:b029:32a:1725:a3d7 with SMTP id t12-20020aa7938c0000b029032a1725a3d7mr1900553pfe.64.1627511516184;
        Wed, 28 Jul 2021 15:31:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s36sm984091pgk.64.2021.07.28.15.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 15:31:55 -0700 (PDT)
Date:   Wed, 28 Jul 2021 22:31:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 9/9] KVM: X86: Optimize zapping rmap
Message-ID: <YQHa1xuNKhqRr4Fq@google.com>
References: <20210625153214.43106-1-peterx@redhat.com>
 <20210625153419.43671-1-peterx@redhat.com>
 <YQHOdhMoFW821HAu@google.com>
 <YQHTocEdMzsJQuzL@t490s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQHTocEdMzsJQuzL@t490s>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021, Peter Xu wrote:
> On Wed, Jul 28, 2021 at 09:39:02PM +0000, Sean Christopherson wrote:
> > On Fri, Jun 25, 2021, Peter Xu wrote:
> > Why implement this as a generic method with a callback?  gcc is suprisingly
> > astute in optimizing callback(), but I don't see the point of adding a complex
> > helper that has a single caller, and is extremely unlikely to gain new callers.
> > Or is there another "zap everything" case I'm missing?
> 
> No other case; it's just that pte_list_*() helpers will be more self-contained.

Eh, but this flow is as much about rmaps as it is about pte_list.

> If that'll be a performance concern, no objection to hard code it.

It's more about unnecessary complexity than it is about performance, e.g. gcc-10
generates identical code for both version (which did surprise the heck out of me).

If we really want to isolate pte_list_destroy(), I would vote for something like
this (squashed in).   pte_list_remove() already calls mmu_spte_clear_track_bits(),
so that particular separation of concerns has already gone out the window.

 
-/* Return true if rmap existed and callback called, false otherwise */
-static bool pte_list_destroy(struct kvm_rmap_head *rmap_head,
-                            void (*callback)(u64 *sptep))
+static bool pte_list_destroy(struct kvm_rmap_head *rmap_head)
 {
        struct pte_list_desc *desc, *next;
        int i;
@@ -1013,20 +1011,16 @@ static bool pte_list_destroy(struct kvm_rmap_head *rmap_head,
                return false;
 
        if (!(rmap_head->val & 1)) {
-               if (callback)
-                       callback((u64 *)rmap_head->val);
+               mmu_spte_clear_track_bits((u64 *)rmap_head->val);
                goto out;
        }
 
        desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
-
-       while (desc) {
-               if (callback)
-                       for (i = 0; i < desc->spte_count; i++)
-                               callback(desc->sptes[i]);
+       for ( ; desc; desc = next) {
+               for (i = 0; i < desc->spte_count; i++)
+                       mmu_spte_clear_track_bits(desc->sptes[i]);
                next = desc->more;
                mmu_free_pte_list_desc(desc);
-               desc = next;
        }
 out:
        /* rmap_head is meaningless now, remember to reset it */
@@ -1422,22 +1416,17 @@ static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
        return kvm_mmu_slot_gfn_write_protect(vcpu->kvm, slot, gfn, PG_LEVEL_4K);
 }
 
-static void mmu_spte_clear_track_bits_cb(u64 *sptep)
-{
-       mmu_spte_clear_track_bits(sptep);
-}
-
 static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
                          const struct kvm_memory_slot *slot)
 {
-       return pte_list_destroy(rmap_head, mmu_spte_clear_track_bits_cb);
+       return pte_list_destroy(rmap_head);
 }
 
 static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
                            struct kvm_memory_slot *slot, gfn_t gfn, int level,
                            pte_t unused)
 {
-       return kvm_zap_rmapp(kvm, rmap_head, slot);
+       return pte_list_destroy(rmap_head);
 }
 
 static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
