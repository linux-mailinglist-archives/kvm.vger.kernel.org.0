Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22648628EC0
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 01:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237555AbiKOAzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 19:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237135AbiKOAzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 19:55:48 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A48F1BEBE
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 16:55:47 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso12368264pjc.5
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 16:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UDR0+4okRz2ougxrpthuHCLqH7oVh0+moFpWjb6I21A=;
        b=B29X8DwgT55HO7MBAVnJw7YeDANJoVtw30t2AgaH0REUWRhvOkM7omv41vjtw8og5h
         ctJOR38PqhkmnQUWHYSGjBToQzP4DeBFv8jSUqiLx7IqIUxtqldaL2OHI0B9lTAX/C9N
         p2BOYdCPPUsMlxmilyilWHaBRhTqYN+QqYzu1khjNwWM/6a/+o9LpqHwyqkOzO/Jits3
         tX0JIyWfaUA3eEfLABMcadNub2Et6UfkeDZAFVQMbpXBt1HS44Gh/KLEeSrGOFvE7Wke
         GGZ+PPXq6n2o4VF2oN6tXnZg7dCsFsCbMNZUGPq2xmeSy/FvsN5Zp6EmR7wTEfC/EHck
         m2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UDR0+4okRz2ougxrpthuHCLqH7oVh0+moFpWjb6I21A=;
        b=gl6laSDXX3fd7QMqMJoRySLKYvTFIaJ5uGX9CRZs6equSOholw4FpuNm6oZ9Hkvleg
         Ec7RU7vzfdLZp0ypLf48GvxRlVu3EKtOsFcOD0AauXGbq8+hr+SjfZ6hzIpjtEeKd2E8
         +x4ppoy4eWOniLMwkcBkGe4gtmh8/4+nHLWA3Xdw5ybz9uugF99UlhC3wruMiXqtudj1
         MP2r8NORrSW4vdR03Fm+D6Yt/JctxttzXN2XI29fUQj8pvWBUusclhaZ4HtvDaSKPJNb
         f+h1X6qfzjiYzDy19sX+Ej9d3gdl15gyBwxGQybqvc0vYUBXhEiSyaYBKqQUHFht0D1v
         SSFA==
X-Gm-Message-State: ANoB5plJMaQRmCMYHfxy3ojoOe5wjxRTHBQLBrCQ2BPzNYZz87w0Dvl8
        XeM/Q4u/o3POLFoQqTCQuvK4oA==
X-Google-Smtp-Source: AA0mqf5kpFFvdWc7T1RhfAi+hiNzZkX+JbAevTu5pitZlRpQo480iN+e9saChzOGSvM+AL8jaVk9dQ==
X-Received: by 2002:a17:90b:3c8f:b0:212:9b3f:dee5 with SMTP id pv15-20020a17090b3c8f00b002129b3fdee5mr15814316pjb.62.1668473746755;
        Mon, 14 Nov 2022 16:55:46 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z10-20020a170903018a00b00180a7ff78ccsm8262024plg.126.2022.11.14.16.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 16:55:46 -0800 (PST)
Date:   Tue, 15 Nov 2022 00:55:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, zhenyuw@linux.intel.com
Subject: Re: [PATCH v2 1/3] KVM: x86: add a new page track hook
 track_remove_slot
Message-ID: <Y3Ljjji0Bwt5+WxH@google.com>
References: <20221111103247.22275-1-yan.y.zhao@intel.com>
 <20221111103350.22326-1-yan.y.zhao@intel.com>
 <Y26SI3uh8JV0vvO6@google.com>
 <Y27ivXea5SjR5lat@yzhao56-desk.sh.intel.com>
 <Y27sG3AqVX8yLUgR@google.com>
 <Y3GUdqxnPJvc6SPI@yzhao56-desk.sh.intel.com>
 <Y3JtonYdDYOhbmfG@google.com>
 <Y3LEZXWqk6ztuf7x@yzhao56-desk.sh.intel.com>
 <Y3LOIKueyTUoJ00B@google.com>
 <Y3LNplTrOpJdxyEW@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3LNplTrOpJdxyEW@yzhao56-desk.sh.intel.com>
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
> On Mon, Nov 14, 2022 at 11:24:16PM +0000, Sean Christopherson wrote:
> > On Tue, Nov 15, 2022, Yan Zhao wrote:
> > > On Mon, Nov 14, 2022 at 04:32:34PM +0000, Sean Christopherson wrote:
> > > > On Mon, Nov 14, 2022, Yan Zhao wrote:
> > > > > On Sat, Nov 12, 2022 at 12:43:07AM +0000, Sean Christopherson wrote:
> > > > > > On Sat, Nov 12, 2022, Yan Zhao wrote:
> > > > > > > And I'm also not sure if a slots_arch_lock is required for
> > > > > > > kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page().
> > > > > > 
> > > > > > It's not required.  slots_arch_lock protects interaction between memslot updates
> > > > > In kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page(),
> > > > > slot->arch.gfn_track[mode][index] is updated in update_gfn_track(),
> > > > > do you know which lock is used to protect it?
> > > > 
> > > > mmu_lock protects the count, kvm->srcu protects the slot, and shadow_root_allocated
> > > > protects that validity of gfn_track, i.e. shadow_root_allocated ensures that KVM
> > > > allocates gfn_track for all memslots when shadow paging is activated.
> > > Hmm, thanks for the reply.
> > > but in direct_page_fault(),
> > > if (page_fault_handle_page_track(vcpu, fault))
> > > 	return RET_PF_EMULATE;
> > > 
> > > slot->arch.gfn_track is read without any mmu_lock is held.
> > 
> > That's a fast path that deliberately reads out of mmu_lock.  A false positive
> > only results in unnecessary emulation, and any false positive is inherently prone
> > to races anyways, e.g. fault racing with zap.
> what about false negative?
> If the fast path read 0 count, no page track write callback will be called and write
> protection will be removed in the slow path.

No.  For a false negative to occur, a different task would have to create a SPTE
and write-protect the GFN _while holding mmu_lock_.  And then after acquiring
mmu_lock, the vCPU that got the false negative would call make_spte(), which would
detect that making the SPTE writable is disallowed due to the GFN being write-protected.

	if (pte_access & ACC_WRITE_MASK) {
		spte |= PT_WRITABLE_MASK | shadow_mmu_writable_mask;

		/*
		 * Optimization: for pte sync, if spte was writable the hash
		 * lookup is unnecessary (and expensive). Write protection
		 * is responsibility of kvm_mmu_get_page / kvm_mmu_sync_roots.
		 * Same reasoning can be applied to dirty page accounting.
		 */
		if (is_writable_pte(old_spte))
			goto out;

		/*
		 * Unsync shadow pages that are reachable by the new, writable
		 * SPTE.  Write-protect the SPTE if the page can't be unsync'd,
		 * e.g. it's write-tracked (upper-level SPs) or has one or more
		 * shadow pages and unsync'ing pages is not allowed.
		 */
		if (mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, can_unsync, prefetch)) {
			pgprintk("%s: found shadow page for %llx, marking ro\n",
				 __func__, gfn);
			wrprot = true;
			pte_access &= ~ACC_WRITE_MASK;
			spte &= ~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
		}
	}



int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
			    gfn_t gfn, bool can_unsync, bool prefetch)
{
	struct kvm_mmu_page *sp;
	bool locked = false;

	/*
	 * Force write-protection if the page is being tracked.  Note, the page
	 * track machinery is used to write-protect upper-level shadow pages,
	 * i.e. this guards the role.level == 4K assertion below!
	 */
	if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
		return -EPERM;

	...
}
