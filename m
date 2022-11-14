Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC9062858E
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 17:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237766AbiKNQh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 11:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237986AbiKNQhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 11:37:03 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89B353EDF
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 08:32:38 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id b29so11460702pfp.13
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 08:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fl4vYZukq8gCsaclrBinKemUC9Y9RD4y/Lg/kykiAyY=;
        b=XFGuwBJF6z0EaYkVgH7A1bZ2UQoEDGL3sPwz22b5mFQxOIeujyJE2gfJDMdKfrtpHM
         DuQJSDBoA0+EDkiTUeFS2HSSmU/FgIS/ATGyTSjlTyGL3zxDEldXu0WcH72VAbC8KZAg
         iJ7+P54da1SxIBlHzXmYIKrsBw2BneA+Ie3X4hjtrIhSRVznVHDTmny6TGuow/kk7MhM
         T0dlTil8s7AVow4Sp1tYtU0768iGCC7N4qoQUpWEcqbMRxjUjukCdoenIL4GYo5z/gzF
         jNJP7twdpR9AJiLK01IFbxmWkyHx9fnD3J3K9yhWFxPkxSiIIX7cXG0ohcizBUng9YUQ
         tOdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fl4vYZukq8gCsaclrBinKemUC9Y9RD4y/Lg/kykiAyY=;
        b=5aXS9itKrxvlYcEGUO/ZIotz1CAxTZEwyuVnyj/uS/zdi7rmFSnHdvFBPp3hp3IQyR
         PCwDL961aGyr29uwhGk0Wzu6bltQj4UQMj501ffHfrG4E8NUifY7cBTPy1rXCZrRPcqk
         0ewogpXVK6hYJMUjp8OQM0URf73VojTeHDsASNYenvKNary4vFoEuqUMvFXIHlF1gOGd
         kYwX6er7CjJ3ciZP916e1DG9HEpEY2INUSBqmdK7YiAvaSfaBEOcypKEaztLR0fi+8GJ
         i0/ArQXUR9Jrk5gvRPF9MRGmpc2LYy5CAyI+F0uCNU7KpAahOH4+zwyYNTfgcJnEOh/B
         ZnpQ==
X-Gm-Message-State: ANoB5pkMwGqLVoPFXwFKPEJRivZYW0NQZginrJj0VHX50/Bj2jPjRd+d
        lcMb9Nzz5jLUFmtK9pBLxVW7WQ==
X-Google-Smtp-Source: AA0mqf5F2NsLGqG6wSNJ5DDtUghQHmhby8l34F1Ns+grkLUucvyPskfdoa29mstcGu3oXagS03J/Gw==
X-Received: by 2002:a62:403:0:b0:572:5be2:505b with SMTP id 3-20020a620403000000b005725be2505bmr1140379pfe.52.1668443557888;
        Mon, 14 Nov 2022 08:32:37 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l29-20020a63ba5d000000b00438834b14a1sm6064695pgu.80.2022.11.14.08.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 08:32:37 -0800 (PST)
Date:   Mon, 14 Nov 2022 16:32:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, zhenyuw@linux.intel.com
Subject: Re: [PATCH v2 1/3] KVM: x86: add a new page track hook
 track_remove_slot
Message-ID: <Y3JtonYdDYOhbmfG@google.com>
References: <20221111103247.22275-1-yan.y.zhao@intel.com>
 <20221111103350.22326-1-yan.y.zhao@intel.com>
 <Y26SI3uh8JV0vvO6@google.com>
 <Y27ivXea5SjR5lat@yzhao56-desk.sh.intel.com>
 <Y27sG3AqVX8yLUgR@google.com>
 <Y3GUdqxnPJvc6SPI@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3GUdqxnPJvc6SPI@yzhao56-desk.sh.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022, Yan Zhao wrote:
> On Sat, Nov 12, 2022 at 12:43:07AM +0000, Sean Christopherson wrote:
> > On Sat, Nov 12, 2022, Yan Zhao wrote:
> > > And I'm also not sure if a slots_arch_lock is required for
> > > kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page().
> > 
> > It's not required.  slots_arch_lock protects interaction between memslot updates
> In kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page(),
> slot->arch.gfn_track[mode][index] is updated in update_gfn_track(),
> do you know which lock is used to protect it?

mmu_lock protects the count, kvm->srcu protects the slot, and shadow_root_allocated
protects that validity of gfn_track, i.e. shadow_root_allocated ensures that KVM
allocates gfn_track for all memslots when shadow paging is activated.

The cleanup series I'm prepping adds lockdep assertions for the relevant paths, e.g. 

$ git grep -B 8 -E "update_gfn_write_track.*;"
arch/x86/kvm/mmu/page_track.c-void __kvm_write_track_add_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
arch/x86/kvm/mmu/page_track.c-                         gfn_t gfn)
arch/x86/kvm/mmu/page_track.c-{
arch/x86/kvm/mmu/page_track.c-  lockdep_assert_held_write(&kvm->mmu_lock);
arch/x86/kvm/mmu/page_track.c-
arch/x86/kvm/mmu/page_track.c-  if (KVM_BUG_ON(!kvm_page_track_write_tracking_enabled(kvm), kvm))
arch/x86/kvm/mmu/page_track.c-          return;
arch/x86/kvm/mmu/page_track.c-
arch/x86/kvm/mmu/page_track.c:  update_gfn_write_track(slot, gfn, 1);
--
arch/x86/kvm/mmu/page_track.c-void __kvm_write_track_remove_gfn(struct kvm *kvm,
arch/x86/kvm/mmu/page_track.c-                            struct kvm_memory_slot *slot, gfn_t gfn)
arch/x86/kvm/mmu/page_track.c-{
arch/x86/kvm/mmu/page_track.c-  lockdep_assert_held_write(&kvm->mmu_lock);
arch/x86/kvm/mmu/page_track.c-
arch/x86/kvm/mmu/page_track.c-  if (KVM_BUG_ON(!kvm_page_track_write_tracking_enabled(kvm), kvm))
arch/x86/kvm/mmu/page_track.c-          return;
arch/x86/kvm/mmu/page_track.c-
arch/x86/kvm/mmu/page_track.c:  update_gfn_write_track(slot, gfn, -1);

