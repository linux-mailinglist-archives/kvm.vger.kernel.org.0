Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10DB2FF78B
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 22:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbhAUVoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 16:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbhAUVdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 16:33:43 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F56C061756
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 13:33:03 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id r4so2016121pls.11
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 13:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=heOAa0BFO9cJ9EoYaea7q8l/tcUhXpogBrPq9/6scMA=;
        b=BcDoRCPuaUWM4pW+HetAi848XmG4yvza7LPddenAWJ0iUvYKLfO29QnyobpHUsy0Sx
         b7Ii4T4te7+OAGKXtopOExxiBK5AVfSae6AQxLjJzITc6LJErKBHbY2qwTXGUXYh4NNr
         S5k784LolcZVj5n5iGkTwhJxyIPzdaoDdOn55YP4z9Yd/7sT5tGM352qet6+PWYHVEGf
         d6CJAXNAFdvtoiiWhTtIdNvGhwFYjgE2JvVuqpnlRogNCL6xw0oV3rDaFzuVoE8lBPyX
         fuEGh+XyR9kqiPumhYGLbr/7TbOY4Gis6tVz4NaUsftvz17NrHLKyJm9lyxBziVGjjZL
         T+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=heOAa0BFO9cJ9EoYaea7q8l/tcUhXpogBrPq9/6scMA=;
        b=MXGxKl6kicpOULy3UikL4ri01Szcpqh343gcU8WJvXIGO+Lutq6AgBWqSsBdMEsgUL
         CTjuMX7MbhY6Xz2q5hYK8WOOWnETpegX+eefS5KzVVOIKDXEtgUsw+PhNSeQk3g1yRDX
         761t0Lg7scp372x2BCNddBulLXchfD1AShwMTR22uS+AinhUFbAzBDh8ole/oCKT62CD
         jAERcczJ9ztDbqUXGkVV/bohDBQcLvynj8DPl6hMbASv4XDrNV/DhNeWTLRTHiqDK5xR
         IN/TrqgU4heQ7Af44rXTjuSnsM1K1J6a9OBBAt3eDW2e9reUdLAOS1dO11WY8aAaYDEG
         ULDQ==
X-Gm-Message-State: AOAM530teWwj7BJ2uXCoFj3Gi5aEAcS0n09ikrRvLFbSLDxpL77os0Kq
        0PBLmDmgweTy06YBzrg5oPz22w==
X-Google-Smtp-Source: ABdhPJy9DeI3hwQH4fKBdS6DUSA8NXpJW63wheYRd+I4c9hipw7e+1V0kThuiugDCxf/ohlQmdnabg==
X-Received: by 2002:a17:90a:7e90:: with SMTP id j16mr1478133pjl.163.1611264782355;
        Thu, 21 Jan 2021 13:33:02 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 123sm6648455pfd.91.2021.01.21.13.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 13:33:01 -0800 (PST)
Date:   Thu, 21 Jan 2021 13:32:55 -0800
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
Subject: Re: [PATCH 19/24] kvm: x86/mmu: Protect tdp_mmu_pages with a lock
Message-ID: <YAnzB3Uwn3AVTXGN@google.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-20-bgardon@google.com>
 <YAnUhCocizx97FWL@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAnUhCocizx97FWL@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021, Sean Christopherson wrote:
> On Tue, Jan 12, 2021, Ben Gardon wrote:
> > +static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> > +				bool atomic)
> > +{
> > +	if (atomic)
> 
> Summarizing an off-list discussion with Ben:
> 
> This path isn't reachable in this series, which means all the RCU stuff is more
> or less untestable.  Only the page fault path modifies the MMU while hold a read
> lock, and it can't zap non-leaf shadow pages (only zaps large SPTEs and installs
> new SPs).

Aha!  I was wrong.  This will be hit when KVM zaps a 4k SPTE and installs a
large SPTE overtop a SP, e.g. if the host migrates a page for compaction and
creates a new THP.

  tdp_mmu_map_handle_target_level()
     tdp_mmu_set_spte_atomic()
       handle_changed_spte()
         __handle_changed_spte()
	   handle_disconnected_tdp_mmu_page()
	     tdp_mmu_unlink_page()

> The intent is to convert other zap-happy paths to a read lock, notably
> kvm_mmu_zap_collapsible_sptes() and kvm_recover_nx_lpages().  Ben will include
> patches to convert at least one of those in the next version of this series so
> that there is justification and coverage for the RCU-deferred freeing.

Somewhat offtopic, zap_collapsible_spte_range() looks wrong.  It zaps non-leaf
SPs, and has several comments that make it quite clear that that's its intent,
but the logic is messed up.  For non-leaf SPs, PFN points at the next table, not
the final PFN that is mapped into the guest.  That absolutely should never be a
reserved PFN, and whether or not its a huge page is irrelevant.  My analysis is
more or less confirmed by looking at Ben's internal code, which explicitly does
the exact opposite in that it explicitly zaps leaf SPTEs.

	tdp_root_for_each_pte(iter, root, start, end) {
		/* Ensure forward progress has been made before yielding. */
		if (iter.goal_gfn != last_goal_gfn &&
		    tdp_mmu_iter_flush_cond_resched(kvm, &iter)) {
			last_goal_gfn = iter.goal_gfn;
			spte_set = false;
			/*
			 * Yielding caused the paging structure walk to be
			 * reset so skip to the next iteration to continue the
			 * walk from the root.
			 */
			continue;
		}

		if (!is_shadow_present_pte(iter.old_spte) ||
		    is_last_spte(iter.old_spte, iter.level)) <--- inverted?
			continue;

		pfn = spte_to_pfn(iter.old_spte); <-- this would be the page table?
		if (kvm_is_reserved_pfn(pfn) ||
		    !PageTransCompoundMap(pfn_to_page(pfn)))
			continue;

		tdp_mmu_set_spte(kvm, &iter, 0);
		spte_set = true;
	}


Coming back to this series, I wonder if the RCU approach is truly necessary to
get the desired scalability.  If both zap_collapsible_sptes() and NX huge page
recovery zap _only_ leaf SPTEs, then the only path that can actually unlink a
shadow page while holding the lock for read is the page fault path that installs
a huge page over an existing shadow page.

Assuming the above analysis is correct, I think it's worth exploring alternatives
to using RCU to defer freeing the SP memory, e.g. promoting to a write lock in
the specific case of overwriting a SP (though that may not exist for rwlocks),
or maybe something entirely different?

I actually do like deferred free concept, but I find it difficult to reason
about exactly what protections are provided by RCU, and what even _needs_ to be
protected.  Maybe we just need to add some __rcu annotations?
