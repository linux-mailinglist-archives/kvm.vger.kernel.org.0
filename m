Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A34628D5C
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 00:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbiKNXYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 18:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiKNXYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 18:24:22 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFCBFD6
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 15:24:21 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id h193so11606485pgc.10
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 15:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=isFHkEsP4U7bls6+qnM9Ylr3wjVvZ13ykkMwbt8BoQw=;
        b=LWOYZLNMNZwSReaa3uSIz6jrXnI/Rr2JJojN/mxQAoov+trhlXXYow2KlUgLSLOQNt
         ZW2OzsnCNJyIe0jqPWkR9ZzyTPJEWIuEna29fGERlsILjuqFaWuvNMHAjBfyj/8J2iTM
         av9glh1vpo4WQkSfE8gZuaPFZM3yC2lp28zgCrtZ9GLYBz/baZLGQ+SDS0GELJmvch6x
         WUA4myeaVI/WzyMRmE3H5TzBhk+lbhbRX2wdPrutAyFLrnIQfpM4spqXksL3d5D3RkA8
         ycNQkoQXFwg5TBGtWGPeaFxxPJnx1ytnsmzeovhKe8r1LjJuWhWeI0/MgHAJeRpY+EsW
         4pYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=isFHkEsP4U7bls6+qnM9Ylr3wjVvZ13ykkMwbt8BoQw=;
        b=5G5zwyNpXxRZd7MIkogxDW7cNkEIllE5FoDuQSiEozUs0ExE7uSxaPr5J84dE6cOgD
         tOLVHRca/Kc+qzOxhTk9eQwzADY5EyPoJ8pXUQGL4zxG/msWtSqdLJqxoKDKpxyc0VPZ
         L1zlh8C1t0tQg9FpHcQx5B6QxDvj4a2WLkbncpPhsqbFHuRbnKw4xi8wRWgnuzKvzB4N
         4OjIRerNAGm3YNbtiwZF1wA9iuulUe9F3dRAWT9NqMmlit2Z1mVLrli83sIcYAeNOYz8
         gWqt+wdVVrM55CLiwU/Tkkd7pKyANNQfjIWVQ5t9A2W8k61AXobpTZTG5PCUaMLLDbLd
         Iwqg==
X-Gm-Message-State: ANoB5pk5fxFHuPa1Gyybm6vJk6TXQqjKVU0avN4l0HuSLki7hkndNJRx
        IDi76jxZnYANWYZ0r2DIbmx22g==
X-Google-Smtp-Source: AA0mqf4XwefhBFMM95veTWx+1D5wJMGN873P83ISTzdr6a1eJB1Sel9VSsLR59mWLNxeNAm/G0SBYg==
X-Received: by 2002:a63:1801:0:b0:470:7886:e200 with SMTP id y1-20020a631801000000b004707886e200mr13714841pgl.111.1668468260709;
        Mon, 14 Nov 2022 15:24:20 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v5-20020a622f05000000b00571f66721aesm4132497pfv.42.2022.11.14.15.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 15:24:20 -0800 (PST)
Date:   Mon, 14 Nov 2022 23:24:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, zhenyuw@linux.intel.com
Subject: Re: [PATCH v2 1/3] KVM: x86: add a new page track hook
 track_remove_slot
Message-ID: <Y3LOIKueyTUoJ00B@google.com>
References: <20221111103247.22275-1-yan.y.zhao@intel.com>
 <20221111103350.22326-1-yan.y.zhao@intel.com>
 <Y26SI3uh8JV0vvO6@google.com>
 <Y27ivXea5SjR5lat@yzhao56-desk.sh.intel.com>
 <Y27sG3AqVX8yLUgR@google.com>
 <Y3GUdqxnPJvc6SPI@yzhao56-desk.sh.intel.com>
 <Y3JtonYdDYOhbmfG@google.com>
 <Y3LEZXWqk6ztuf7x@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3LEZXWqk6ztuf7x@yzhao56-desk.sh.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 15, 2022, Yan Zhao wrote:
> On Mon, Nov 14, 2022 at 04:32:34PM +0000, Sean Christopherson wrote:
> > On Mon, Nov 14, 2022, Yan Zhao wrote:
> > > On Sat, Nov 12, 2022 at 12:43:07AM +0000, Sean Christopherson wrote:
> > > > On Sat, Nov 12, 2022, Yan Zhao wrote:
> > > > > And I'm also not sure if a slots_arch_lock is required for
> > > > > kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page().
> > > > 
> > > > It's not required.  slots_arch_lock protects interaction between memslot updates
> > > In kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page(),
> > > slot->arch.gfn_track[mode][index] is updated in update_gfn_track(),
> > > do you know which lock is used to protect it?
> > 
> > mmu_lock protects the count, kvm->srcu protects the slot, and shadow_root_allocated
> > protects that validity of gfn_track, i.e. shadow_root_allocated ensures that KVM
> > allocates gfn_track for all memslots when shadow paging is activated.
> Hmm, thanks for the reply.
> but in direct_page_fault(),
> if (page_fault_handle_page_track(vcpu, fault))
> 	return RET_PF_EMULATE;
> 
> slot->arch.gfn_track is read without any mmu_lock is held.

That's a fast path that deliberately reads out of mmu_lock.  A false positive
only results in unnecessary emulation, and any false positive is inherently prone
to races anyways, e.g. fault racing with zap.

> > arch/x86/kvm/mmu/page_track.c-void __kvm_write_track_remove_gfn(struct kvm *kvm,
> > arch/x86/kvm/mmu/page_track.c-                            struct kvm_memory_slot *slot, gfn_t gfn)
> > arch/x86/kvm/mmu/page_track.c-{
> > arch/x86/kvm/mmu/page_track.c-  lockdep_assert_held_write(&kvm->mmu_lock);
> > arch/x86/kvm/mmu/page_track.c-
> > arch/x86/kvm/mmu/page_track.c-  if (KVM_BUG_ON(!kvm_page_track_write_tracking_enabled(kvm), kvm))
> > arch/x86/kvm/mmu/page_track.c-          return;
> > arch/x86/kvm/mmu/page_track.c-
> > arch/x86/kvm/mmu/page_track.c:  update_gfn_write_track(slot, gfn, -1);
> yes, it will be helpful.
> 
> Besides, will WRITE_ONCE or atomic_add in update_gfn_write_track() to
> update slot->arch.gfn_track be better?

WRITE_ONCE() won't suffice, it needs to be atomic.  Switching to atomic_inc/dec
isn't worth it so long as KVM's shadow MMU takes mmu_lock for write, i.e. while
the accounting is mutually exclusive for other reasons in both KVM and KVMGT.
