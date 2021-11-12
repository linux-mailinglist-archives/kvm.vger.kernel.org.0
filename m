Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A6B44F01A
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 00:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbhKLX4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 18:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhKLX4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 18:56:05 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CC4C061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 15:53:13 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id q17so9616372plr.11
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 15:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gojtBW/r/xf8g2//78l2TEMOnJOiXV3waj3qkECVeqU=;
        b=cPdRbXCvdzWASSXvVHD7Rc/r30jMYD5c7cQeFJIk1Ww78VP3OjZXIBBwjWfp1gh9K5
         o6BM6uiLSvYqTimqPrqerL7mdyCNlV6Qm97YgzD1OAomTJVQJLawjbSSYT8rGXcfDRNT
         fgpvRVRdDEyOvbgCB+Q8fwo/QLCo01tdhJuDx5duYaWnS2QkEG5vNUOSnRnv8d8lPnSo
         TdAPS2b3JnIr4EJd7A4X94oJ7ZWoo2i1j6EHEITZY3gM6PcwPwqi174GN7N7ioW3UeRm
         ymBult5TNbzcAvXW4DWxunqHKI3o9ylCHRyD4px0YOY+n9dRSf/pa/vBJdwXXaZAVHZv
         +C7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gojtBW/r/xf8g2//78l2TEMOnJOiXV3waj3qkECVeqU=;
        b=O5juzri0VtvE2CGXtU+GZPhGr4AsOWPnvOG4ywDF1PY38ZDT/EbZZxylUXrf2Aywg2
         OQ7cuFwaFPFRlqsDfu8572ZOKrdnuGOyhEP/phQc7ceE7rcSrPXPWZ7HGDiV7DpVUyv5
         fvqOYGjD7075IG8JbYREKO7ZqodO5YjYiGMO3BFohQuKgUz0QtFgKvIKtUNgBLLxBWvm
         5WslUbRrxz0VsqO4ArayC1nWyQ88H5r7aHeZjLb4aZESLyTI3hcJaHeQpw9U7dxgK5oI
         aGrd71DJWX53OeYBhQf5+e7uYk38bsGL/HIWONR+AmxgNim6E7sxXbcLkiWtUX4pk1f7
         7RiQ==
X-Gm-Message-State: AOAM5319dITH9q95OrUrK4ejgITNd2Q+9punbDrsJcTSWSQNOxAODww0
        YoNWBixt8NM6phBolo83qpgdIg==
X-Google-Smtp-Source: ABdhPJwU07AJSZ2zDITrDqE5QeTuOZmtItO8muoN5QPSoPbBBJPmnQtrCEPjVLpFM1x45iewkiYAbA==
X-Received: by 2002:a17:90a:aa0e:: with SMTP id k14mr23007162pjq.88.1636761193271;
        Fri, 12 Nov 2021 15:53:13 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t21sm5525037pgo.12.2021.11.12.15.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 15:53:12 -0800 (PST)
Date:   Fri, 12 Nov 2021 23:53:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [RFC 02/19] KVM: x86/mmu: Batch TLB flushes for a single zap
Message-ID: <YY7+ZARmQV+eWbDL@google.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110223010.1392399-3-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021, Ben Gardon wrote:
> When recursively handling a removed TDP page table, the TDP MMU will
> flush the TLBs and queue an RCU callback to free the PT. If the original
> change zapped a non-leaf SPTE at PG_LEVEL_1G or above, that change will
> result in many unnecessary TLB flushes when one would suffice. Queue all
> the PTs which need to be freed on a list and wait to queue RCU callbacks
> to free them until after all the recursive callbacks are done.

I'm pretty sure we can do this without tracking disconnected SPs.  The whole point
of protecting TDP MMU with RCU is to wait until _all_ CPUs are guaranateed to have
dropped references.  Emphasis on "all" because that also includes the CPU that's
doing the zapping/replacement!

And since the current CPU is required to hold RCU, we can use its RCU lock as a
proxy for all vCPUs executing in the guest.  That will require either flushing in
zap_gfn_range() or requiring callers to hold, or more likely a mix of both so that
flows that zap multiple roots or both TDP and legacy MMU pages can batch flushes

If this doesn't sound completely bonkers, I'd like to pick this up next week, I
wandered into KVM's handling of invalidated roots and have patches that would
conflict in weird ways with this idea.

So I think this can simply be (sans zap_gfn_range() changes):

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4e226cdb40d9..d2303bca4449 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -431,9 +431,6 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
                                    shared);
        }
 
-       kvm_flush_remote_tlbs_with_address(kvm, gfn,
-                                          KVM_PAGES_PER_HPAGE(level + 1));
-
        call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
@@ -716,11 +713,11 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
                return false;
 
        if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
-               rcu_read_unlock();
-
                if (flush)
                        kvm_flush_remote_tlbs(kvm);
 
+               rcu_read_unlock();
+
                if (shared)
                        cond_resched_rwlock_read(&kvm->mmu_lock);
                else
@@ -817,7 +814,6 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
        }
 
        rcu_read_unlock();
-       return flush;
 }
 
 /*
@@ -954,6 +950,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
                ret = RET_PF_SPURIOUS;
        else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
                return RET_PF_RETRY;
+       else if (<old spte was present shadow page>)
+               kvm_flush_remote_tlbs(kvm);
 
        /*
         * If the page fault was caused by a write but the page is write


> +static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
> +					   struct tdp_iter *iter,
> +					   u64 new_spte)
> +{
> +	return __tdp_mmu_set_spte_atomic(kvm, iter, new_spte, NULL);

This helper and refactoring belongs in patch 19.  It is impossible to review without
the context of its user(s).
