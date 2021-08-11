Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E7E3E950E
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 17:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbhHKPxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 11:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbhHKPwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 11:52:54 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C388C061765
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 08:52:20 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a8so4130373pjk.4
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 08:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5LIL7TooUdF4jsk1ShMs5Hj6yTpAYJOQMbpQgvOSIVs=;
        b=TZ0ZBPoAkcrtXMYs67yvlc/TxTa93EDbVEhrkTkgjtjd9HqIb9zMkXF8uBGNGxlREo
         sACE0/6tzrQCPH1P8KznR9K049lCmT4LVltVmhex2nSH6LL8Cu0xS6K9suZYeHt+dWzy
         bMv3K/g1wEyJ8++ThT/UujdWetAiU+ZQEoQOWzBeR0+0wRk51yirvqjRQln4EVocUdHM
         SPqAtOL5jLhymUv9WpKnhifW2Il6qdmRF3GBsJen9yzthPCnlg3HdGZHamCIpM15ApSN
         FFa1sJclUnoHbS5C/GNXdKixfBCvcchBZvCtpbJFPzL5UiOo4qH8EAb3/AMg77tgFvVY
         6dQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5LIL7TooUdF4jsk1ShMs5Hj6yTpAYJOQMbpQgvOSIVs=;
        b=hTFrS4OWzEU5ftJ6OXdvVsiELmj5YPdMMHNztRPhjSJqHO/bj+t06KXBVwpuE1SqCe
         NXhsXdQ9mgiYAbT470HnDSS8rVZh5VYmY/pIteLGeJba9VrIxpyXli7c52xGK29OtR20
         D7ANZeFP3e1hSQa9YdEw3VBFOfK9E0oUUKcyq00BFukO+K07kMPau0FLtKbNSpkyCGYX
         3HCJqtJakGp8E6dsnoOngLFaPm4MUspemJcsfsGmN1A1AXFJ52OmDlWiQ5S52EnBTZp3
         DWuo+NMkEAT0yfMw557/BNQ6p3N2fHFNSOfoUTYOVOPalCPWOzY8dLDWyb4B9Y+jhSwB
         tRrg==
X-Gm-Message-State: AOAM533Px/WWannKdUZKDrUZRN5OQDC/0eQnfFAcEiEViEHO1b3WLYe4
        ysYWJkrH7uFZFrPE3gw3kCaDNg==
X-Google-Smtp-Source: ABdhPJzy7ItsvyY0Z/dD5yQa+gbL0TSGT69lYVYnkCI4eCcvMSWrsciOyAsWNdeHSB464MyvFOY3wQ==
X-Received: by 2002:a63:4e51:: with SMTP id o17mr399343pgl.126.1628697139744;
        Wed, 11 Aug 2021 08:52:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z131sm10806573pfc.159.2021.08.11.08.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 08:52:19 -0700 (PDT)
Date:   Wed, 11 Aug 2021 15:52:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Protect marking SPs unsync when using
 TDP MMU with spinlock
Message-ID: <YRPyLagRbw5QKoNc@google.com>
References: <20210810224554.2978735-1-seanjc@google.com>
 <20210810224554.2978735-2-seanjc@google.com>
 <74bb6910-4a0c-4d2f-e6b5-714a3181638e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74bb6910-4a0c-4d2f-e6b5-714a3181638e@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021, Paolo Bonzini wrote:
> On 11/08/21 00:45, Sean Christopherson wrote:
> > Use an entirely new spinlock even though piggybacking tdp_mmu_pages_lock
> > would functionally be ok.  Usurping the lock could degrade performance when
> > building upper level page tables on different vCPUs, especially since the
> > unsync flow could hold the lock for a comparatively long time depending on
> > the number of indirect shadow pages and the depth of the paging tree.
> 
> If we are to introduce a new spinlock, do we need to make it conditional and
> pass it around like this?  It would be simpler to just take it everywhere
> (just like, in patch 2, passing "shared == true" to tdp_mmu_link_page is
> always safe anyway).

It's definitely not necessary to pass it around.  I liked this approach because
the lock is directly referenced only by the TDP MMU.

My runner up was to key off of is_tdp_mmu_enabled(), which is not strictly
necessary, but I didn't like checking is_tdp_mmu() this far down the call chain.
E.g. minus comments and lockdeps

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d574c68cbc5c..651256a10cb9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2594,6 +2594,8 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
  */
 int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
 {
+       bool tdp_mmu = is_tdp_mmu_enabled(vcpu->kvm);
+       bool write_locked = !tdp_mmu;
        struct kvm_mmu_page *sp;

        /*
@@ -2617,9 +2619,19 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
                if (sp->unsync)
                        continue;

+               if (!write_locked) {
+                       write_locked = true;
+                       spin_lock(&vcpu->kvm->arch.tdp_mmu_unsync_pages_lock);
+
+                       if (READ_ONCE(sp->unsync))
+                               continue;
+               }
+
                WARN_ON(sp->role.level != PG_LEVEL_4K);
                kvm_unsync_page(vcpu, sp);
        }
+       if (tdp_mmu && write_locked)
+               spin_unlock(&vcpu->kvm->arch.tdp_mmu_unsync_pages_lock);

        /*
         * We need to ensure that the marking of unsync pages is visible



All that said, I do not have a strong preference.  Were you thinking something
like this?

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d574c68cbc5c..b622e8a13b8b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2595,6 +2595,7 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
 {
        struct kvm_mmu_page *sp;
+       bool locked = false;

        /*
         * Force write-protection if the page is being tracked.  Note, the page
@@ -2617,9 +2618,34 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
                if (sp->unsync)
                        continue;

+               /*
+                * TDP MMU page faults require an additional spinlock as they
+                * run with mmu_lock held for read, not write, and the unsync
+                * logic is not thread safe.  Take the spinklock regardless of
+                * the MMU type to avoid extra conditionals/parameters, there's
+                * no meaningful penalty if mmu_lock is held for write.
+                */
+               if (!locked) {
+                       locked = true;
+                       spin_lock(&kvm->arch.mmu_unsync_pages_lock);
+
+                       /*
+                        * Recheck after taking the spinlock, a different vCPU
+                        * may have since marked the page unsync.  A false
+                        * positive on the unprotected check above is not
+                        * possible as clearing sp->unsync _must_ hold mmu_lock
+                        * for write, i.e. unsync cannot transition from 0->1
+                        * while this CPU holds mmu_lock for read.
+                        */
+                       if (READ_ONCE(sp->unsync))
+                               continue;
+               }
+
                WARN_ON(sp->role.level != PG_LEVEL_4K);
                kvm_unsync_page(vcpu, sp);
        }
+       if (locked)
+               spin_unlock(&kvm->arch.mmu_unsync_pages_lock);

        /*
         * We need to ensure that the marking of unsync pages is visible
