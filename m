Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970CF3B1D3F
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 17:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhFWPLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 11:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbhFWPLE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 11:11:04 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59400C061756
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 08:08:46 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id pf4-20020a17090b1d84b029016f6699c3f2so4058641pjb.0
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 08:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y/+gUcBGGIUkhyth2VWkINBuYnDFkJtSmXDdrAwsdGw=;
        b=LKlREle06OsdsrH029I5rCI2ZuQ472XzGYzyTwfoLjYbUih+izk1mHF4ZkefzRIb+n
         qqboCkapweELI2vAobhoRCut5MqCD/lOcsNDttQGhyxYbLVoTzpfrufjru2vF/pH+7zB
         anCRK1HyRJtrMhkPlGkE5balrmrh/qJMBEbUY99rV/D0xr/gItSh+tzlja1tmD7kqOQl
         eoGk8Slv5MqsIdZSAVk7BJwkCnB1z688w8fmL5OKe2GqX3hRkARDRF+wAQKjA/3gnrD7
         fudZnSdS/lqdH4mSdaMNbZZhEHHYOU7NWPANKO9c9Om7ZEymsCtLjdC9dthdHtteCPwB
         wYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y/+gUcBGGIUkhyth2VWkINBuYnDFkJtSmXDdrAwsdGw=;
        b=oYsOmhHnPF3Q0QmxXs70BJ7ecv2pV42fy1eN1h38yVtJfXGFl/3uGrKbFV5CVmD8d/
         1HCk5Q2dwV1DYwXtHwAJfCkkXg7QBuIBF9AXsyhAbpTE1uFEE7qZIML/5gK6poec1ss9
         05gNqDNnFBMU0uXXw8IH2dCMzKATggAVTq9M3zdA/Zy8LwUCPr91ful9j6EVes/JwEOD
         UZww8iWha9UxyTzKLIDl5kcusqchLBPYrz9/duw1OPgsBfgprSe+UNK/43G/1+oBuqED
         hzkmBRYQ/fKmkkmhMcIGdiYeWijLfIJ5rtqDSlUcKtcNchQ4Zr/X9GYwyJGs1Id6hzo8
         Ob0A==
X-Gm-Message-State: AOAM530egcEm6QrIy5FTepLyyBiRh9Ch4QfQUNnjQW0nQs/RTWqPb3tO
        KdVx601iXO17jCEfFhgtaoWBLA==
X-Google-Smtp-Source: ABdhPJwB7rtRUmG4UMMsV0iaYZ8fG9PnEVMgPp9orKO5Ybt3W7NGl8vY9Jj73eSJLbtaAoncAKp9Yg==
X-Received: by 2002:a17:90a:4890:: with SMTP id b16mr9147086pjh.211.1624460925633;
        Wed, 23 Jun 2021 08:08:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u4sm254706pfu.27.2021.06.23.08.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 08:08:44 -0700 (PDT)
Date:   Wed, 23 Jun 2021 15:08:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 09/54] KVM: x86/mmu: Unconditionally zap unsync SPs when
 creating >4k SP at GFN
Message-ID: <YNNOeIWqNoZ3j8o+@google.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-10-seanjc@google.com>
 <f2dcfe12-e562-754e-2756-1414e8e2775f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2dcfe12-e562-754e-2756-1414e8e2775f@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021, Paolo Bonzini wrote:
> On 22/06/21 19:56, Sean Christopherson wrote:
> > When creating a new upper-level shadow page, zap unsync shadow pages at
> > the same target gfn instead of attempting to sync the pages.  This fixes
> > a bug where an unsync shadow page could be sync'd with an incompatible
> > context, e.g. wrong smm, is_guest, etc... flags.  In practice, the bug is
> > relatively benign as sync_page() is all but guaranteed to fail its check
> > that the guest's desired gfn (for the to-be-sync'd page) matches the
> > current gfn associated with the shadow page.  I.e. kvm_sync_page() would
> > end up zapping the page anyways.
> > 
> > Alternatively, __kvm_sync_page() could be modified to explicitly verify
> > the mmu_role of the unsync shadow page is compatible with the current MMU
> > context.  But, except for this specific case, __kvm_sync_page() is called
> > iff the page is compatible, e.g. the transient sync in kvm_mmu_get_page()
> > requires an exact role match, and the call from kvm_sync_mmu_roots() is
> > only synchronizing shadow pages from the current MMU (which better be
> > compatible or KVM has problems).  And as described above, attempting to
> > sync shadow pages when creating an upper-level shadow page is unlikely
> > to succeed, e.g. zero successful syncs were observed when running Linux
> > guests despite over a million attempts.
> 
> One issue, this WARN_ON may now trigger:
> 
>                         WARN_ON(!list_empty(&invalid_list));
> 
> due to a kvm_mmu_prepare_zap_page that could have happened on an earlier
> iteration of the for_each_valid_sp.  Before your change, __kvm_sync_page
> would be called always before kvm_sync_pages could add anything to
> invalid_list.

Ah, I should have added a comment.  It took me a few minutes of staring to
remember why it can't fire.

The branch at (2), which adds to invalid_list, is taken if and only if the new
page is not a 4k page.

The branch at (3) is taken if and only if the existing page is a 4k page, because
only 4k pages can become unsync.

Because the shadow page's level is incorporated into its role, if the level of
the new page is >4k, the branch at (1) will be taken for all 4k shadow pages.

Maybe something like this for a comment?

			/*
			 * Assert that the page was not zapped if the "sync" was
			 * successful.  Note, this cannot collide with the above
			 * zapping of unsync pages, as this point is reached iff
			 * the new page is a 4k page (only 4k pages can become
			 * unsync and the role check ensures identical levels),
			 * and zapping occurs iff the new page is NOT a 4k page.
			 */
			WARN_ON(!list_empty(&invalid_list));




1)		if (sp->role.word != role.word) {
			/*
			 * If the guest is creating an upper-level page, zap
			 * unsync pages for the same gfn.  While it's possible
			 * the guest is using recursive page tables, in all
			 * likelihood the guest has stopped using the unsync
			 * page and is installing a completely unrelated page.
			 * Unsync pages must not be left as is, because the new
			 * upper-level page will be write-protected.
			 */
2)			if (level > PG_LEVEL_4K && sp->unsync)
				kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
							 &invalid_list);
			continue;
		}

		if (direct_mmu)
			goto trace_get_page;

3)		if (sp->unsync) {
			/*
			 * The page is good, but is stale.  "Sync" the page to
			 * get the latest guest state, but don't write-protect
			 * the page and don't mark it synchronized!  KVM needs
			 * to ensure the mapping is valid, but doesn't need to
			 * fully sync (write-protect) the page until the guest
			 * invalidates the TLB mapping.  This allows multiple
			 * SPs for a single gfn to be unsync.
			 *
			 * If the sync fails, the page is zapped.  If so, break
			 * If so, break in order to rebuild it.
			 */
			if (!kvm_sync_page(vcpu, sp, &invalid_list))
				break;

			WARN_ON(!list_empty(&invalid_list));
			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
		}
