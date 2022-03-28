Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CC04EA22F
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 23:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbiC1VC2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 17:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiC1VC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 17:02:26 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897327006A
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 14:00:40 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id b15so13935759pfm.5
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 14:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f/GvndT+5e72qW8tftZIUvnHz4PSf2jIRJgogiD5zrI=;
        b=RCyi+zUD+fHdNxXdEz82Oe0p5sAr1mlG0X7xn+4MNPQ4B5E4u1HSBg6Qc1kwd9rYdR
         ds/IDpBTa5rsEUU22cjOYUNwtOB8kDU39mk557YR3m5nLVtyBh0khXZo01N+q7hLD0ob
         AxR0KEKE8IBX9Zaqkt6H+5Qepul4EO8wiwzJLZq8QHynTwqFhvHrh5su9nLyJvHBgGUi
         xuKbF9Smrg2ECDOwuxSaO4PxxbbuNRX54Jq3b2Lsywv9os4IvDIteTaWT8OEH7FVxdGq
         ViYntLkAJbK5YlO1nKdz6LAdh17GyluLkeAUhi2IIEG7Q9Zt7GYZGhLMcytWwUnmwz9p
         jK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f/GvndT+5e72qW8tftZIUvnHz4PSf2jIRJgogiD5zrI=;
        b=V1CDyA3xIUMJJzKJ/1CxTlV1jXGYMgBttoFR8wlUXYR+0pW6AEPIwhnFbLuqMld/TM
         Eko3F1ypjWCf1OMcdqGAeqaSsXOqy4PXK1DYgX+LhoF7Sw8lsPwBOUzS8Jj23jiqwQR7
         sVFPkunb13T60IolBumN6urhRqA62i5+c/c+sUEdeZBaxwdbetUmjWKB2LKFsI61BXIT
         oPC8nAE3rvAdeLyeojZSMGHlQyPpFfbRFoIMfNuNwUBaSqLgJgrQy1xn7r67ln38R6Wx
         +RrDVa1YArumqgt6kexsq4CHuX+Dfptp02YxnSn8h1fQ2HuZhZyt8v6s84vcQnU7jsIK
         gBVQ==
X-Gm-Message-State: AOAM532PT/mJZkXEJ6OVp4iEvQWRllWVUqkRiiE0lSPy1BriUVM2CxBo
        3mW5JoltgApz5FyjuKgwVNBoxA==
X-Google-Smtp-Source: ABdhPJxjtirRjZvZZguFjo78NbXyGY7NQBBzphFPUklHd9ZkaFYulPitcqn8m4RWZDIjPMlN1BjiyA==
X-Received: by 2002:a63:58d:0:b0:382:16e6:9fb6 with SMTP id 135-20020a63058d000000b0038216e69fb6mr11689292pgf.16.1648501239349;
        Mon, 28 Mar 2022 14:00:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x38-20020a056a0018a600b004fafd05ac3fsm14473848pfh.37.2022.03.28.14.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 14:00:38 -0700 (PDT)
Date:   Mon, 28 Mar 2022 21:00:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 0/9] KVM: SVM: Defer page pinning for SEV guests
Message-ID: <YkIh8zM7XfhsFN8L@google.com>
References: <20220308043857.13652-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308043857.13652-1-nikunj@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 08, 2022, Nikunj A Dadhania wrote:
> This is a follow-up to the RFC implementation [1] that incorporates
> review feedback and bug fixes. See the "RFC v1" section below for a 
> list of changes.

Heh, for future reference, the initial posting of a series/patch/RFC is implicitly
v1, i.e. this should be RFC v2.

> SEV guest requires the guest's pages to be pinned in host physical
> memory as migration of encrypted pages is not supported. The memory
> encryption scheme uses the physical address of the memory being
> encrypted. If guest pages are moved by the host, content decrypted in
> the guest would be incorrect thereby corrupting guest's memory.
> 
> For SEV/SEV-ES guests, the hypervisor doesn't know which pages are
> encrypted and when the guest is done using those pages. Hypervisor
> should treat all the guest pages as encrypted until they are 
> deallocated or the guest is destroyed.
> 
> While provision a pfn, make KVM aware that guest pages need to be 
> pinned for long-term and use appropriate pin_user_pages API for these
> special encrypted memory regions. KVM takes the first reference and
> holds it until a mapping is done. Take an extra reference before KVM
> releases the pfn. 
> 
> Actual pinning management is handled by vendor code via new
> kvm_x86_ops hooks. MMU calls in to vendor code to pin the page on
> demand. Metadata of the pinning is stored in architecture specific
> memslot area. During the memslot freeing path and deallocation path
> guest pages are unpinned.
> 
> Guest boot time comparison:
> +---------------+----------------+-------------------+
> | Guest Memory  |   baseline     |  Demand Pinning + |
> | Size (GB)     | v5.17-rc6(secs)| v5.17-rc6(secs)   |
> +---------------+----------------+-------------------+
> |      4        |     6.16       |      5.71         |
> +---------------+----------------+-------------------+
> |     16        |     7.38       |      5.91         |
> +---------------+----------------+-------------------+
> |     64        |    12.17       |      6.16         |
> +---------------+----------------+-------------------+
> |    128        |    18.20       |      6.50         |
> +---------------+----------------+-------------------+
> |    192        |    24.56       |      6.80         |
> +---------------+----------------+-------------------+

Let me preface this by saying I generally like the idea and especially the
performance, but...

I think we should abandon this approach in favor of committing all our resources
to fd-based private memory[*], which (if done right) will provide on-demand pinning
for "free".  I would much rather get that support merged sooner than later, and use
it as a carrot for legacy SEV to get users to move over to its new APIs, with a long
term goal of deprecating and disallowing SEV/SEV-ES guests without fd-based private
memory.  That would require guest kernel support to communicate private vs. shared,
but SEV guests already "need" to do that to play nice with live migration, so it's
not a big ask, just another carrot to entice guests/customers to update their kernel
(and possibly users to update their guest firmware).

This series isn't awful by any means, but it requires poking into core flows and
further complicates paths that are already anything but simple.  And things like
conditionally grabbing vCPU0 to pin pages in its MMU make me flinch.  And I think
the situation would only get worse by the time all the bugs and corner cases are
ironed out.  E.g. this code is wrong:

  void kvm_release_pfn_clean(kvm_pfn_t pfn)
  {
	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn)) {
		struct page *page = pfn_to_page(pfn);

		if (page_maybe_dma_pinned(page))
			unpin_user_page(page);
		else
			put_page(page);
	}
  }
  EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);

Because (a) page_maybe_dma_pinned() is susceptible to false positives (clearly
documented), and (b) even if it didn't get false positives, there's no guarantee
that _KVM_ owns a pin of the page.

It's not an impossible problem to solve, but I suspect any solution will require
either touching a lot of code or will be fragile and difficult to maintain, e.g.
by auditing all users to understand which need to pin and which don't.  Even if
we _always_ pin memory for SEV guests, we'd still need to plumb the "is SEV guest"
info around.

And FWIW, my years-old idea of using a software-available SPTE bit to track pinned
pages is plagued by the same underlying issue: KVM's current management (or lack
thereof) of SEV guest memory just isn't viable long term.  In all honesty, it
probably should never have been merged.  We can't change the past, but we can, 
and IMO should, avoid piling on more code to an approach that is fundamentally flawed.
	
[*] https://lore.kernel.org/all/20220310140911.50924-1-chao.p.peng@linux.intel.com
