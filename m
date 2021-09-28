Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A69D41BAFE
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 01:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243246AbhI1X3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 19:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243145AbhI1X3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 19:29:24 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6130DC06161C
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 16:27:44 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id d4-20020a17090ad98400b0019ece228690so2834818pjv.5
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 16:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EhcU8Kjwg9ut3Xb/ULqWAtFmuiERKbM2e3Paikz24PM=;
        b=nCBwjJ8wk+eIIztcdWohvrAoPS9xE411Mk0+osyihr2YQCUeGX0gh9UMreKbvuCfCQ
         Mf9HWw/kEzftTvW+em1VMKWn01o/uu820IpoBiAlkseaOsar779zc8yyoAgwM4JDKi+f
         KkuJiv9wze5HfP0ZZiPfJZeqBY+5uUsTaBubiEhmeLJ26WbSXy5qxQ4q3AcfTGdQTeI9
         IkdMu/Qyl0m+a3odOSa7UbeJ4fDidepVwH4MeKi8XCnLRA7oOCPDvfaEez3tN886ju3h
         aDp+OFLJ3x0Pe/lFNNAFDRQcF1aLZGnj0NA7NoWIrqhE9+JgVfHu4msus8UIYtt94Y3w
         IX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EhcU8Kjwg9ut3Xb/ULqWAtFmuiERKbM2e3Paikz24PM=;
        b=CUy30ZSFh9q1e8ctGf2J9HE8ZCBssipU1ZPg1+A8zGdErG5KaJXD16B9PtgfHMqoOU
         2U4nm45WOowqy5BuPct+FqjoRDxjNs/KwAeaP58VTMhIteCBSD3Yy4LFzLpRRSBa9fN+
         xAsBSOWSHdAhnmvTjgkExDZBjlC74pjAzVh6Gt1N5QnLCUb7+I1DSGjWwa72oXqa39ha
         0xYVk2WT19DY2LFHW+pNM5CROEQqVy9E1N3yEYWeJPK9InPNhZxxMODJUZaawmLOu5xA
         dMBev5Bb2QejZ8P7GyaUIs4qhaUYLwVDht6G58IGvrbRL5y5s0lJMEz2+4VIRWx2WC+1
         Bx7w==
X-Gm-Message-State: AOAM531iPyCEtpueHIDQIaPALjNAz8QhKh9qNUZ3AYCQbiWBO/ZI3sAN
        UbqFIkLN5DwPCsabVv6PyrGH6g==
X-Google-Smtp-Source: ABdhPJwAWvHmSQDULEyAN8bGPHlrdsyt6zkLtTY6gHMHgQlJIEht1JMpZbQ76VX+lMCX9P5doqCUWA==
X-Received: by 2002:a17:902:a70e:b0:13e:1274:c352 with SMTP id w14-20020a170902a70e00b0013e1274c352mr7331772plq.58.1632871663648;
        Tue, 28 Sep 2021 16:27:43 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id z23sm121863pgv.45.2021.09.28.16.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 16:27:42 -0700 (PDT)
Date:   Tue, 28 Sep 2021 23:27:39 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
Subject: Re: [PATCH v3 00/31] KVM: x86: pass arguments on the page fault path
 via struct kvm_page_fault
Message-ID: <YVOk6zw2b1bI+Qk7@google.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 24, 2021 at 12:31:21PM -0400, Paolo Bonzini wrote:
> The current kvm page fault handlers passes around many arguments to the
> functions.  To simplify those arguments and local variables, introduce
> a data structure, struct kvm_page_fault, to hold those arguments and
> variables.  struct kvm_page_fault is allocated on stack on the caller
> of kvm fault handler, kvm_mmu_do_page_fault(), and passed around.
> 
> Later in the series, my patches are interleaved with David's work to
> add the memory slot to the struct and avoid repeated lookups.  Along the
> way you will find some cleanups of functions with a ludicrous number of
> arguments, so that they use struct kvm_page_fault as much as possible
> or at least receive related information from a single argument.  make_spte
> in particular goes from 11 to 10 arguments (yeah I know) despite gaining
> two for kvm_mmu_page and kvm_memory_slot.
> 
> This can be sometimes a bit debatable (for example struct kvm_mmu_page
> is used a little more on the TDP MMU paths), but overall I think the
> result is an improvement.  For example the SET_SPTE_* constants go
> away, and they absolutely didn't belong in the TDP MMU.  But if you
> disagree with some of the changes, please speak up loudly!

Thanks for getting this cleaned up and sent out. The series looks good
overall. I had 2 small comments but otherwise:

Reviewed-by: David Matlack <dmatlack@google.com>

> 
> Testing: survives kvm-unit-tests on Intel with all of ept=0, ept=1
> tdp_mmu=0, ept=1.  Will do more before committing to it in kvm/next of
> course.
> 
> Paolo
> 
> David Matlack (5):
>   KVM: x86/mmu: Fold rmap_recycle into rmap_add
>   KVM: x86/mmu: Pass the memslot around via struct kvm_page_fault
>   KVM: x86/mmu: Avoid memslot lookup in page_fault_handle_page_track
>   KVM: x86/mmu: Avoid memslot lookup in rmap_add
>   KVM: x86/mmu: Avoid memslot lookup in make_spte and
>     mmu_try_to_unsync_pages
> 
> Paolo Bonzini (25):
>   KVM: MMU: pass unadulterated gpa to direct_page_fault
>   KVM: MMU: Introduce struct kvm_page_fault
>   KVM: MMU: change mmu->page_fault() arguments to kvm_page_fault
>   KVM: MMU: change direct_page_fault() arguments to kvm_page_fault
>   KVM: MMU: change page_fault_handle_page_track() arguments to
>     kvm_page_fault
>   KVM: MMU: change kvm_faultin_pfn() arguments to kvm_page_fault
>   KVM: MMU: change handle_abnormal_pfn() arguments to kvm_page_fault
>   KVM: MMU: change __direct_map() arguments to kvm_page_fault
>   KVM: MMU: change FNAME(fetch)() arguments to kvm_page_fault
>   KVM: MMU: change kvm_tdp_mmu_map() arguments to kvm_page_fault
>   KVM: MMU: change tdp_mmu_map_handle_target_level() arguments to
>     kvm_page_fault
>   KVM: MMU: change fast_page_fault() arguments to kvm_page_fault
>   KVM: MMU: change kvm_mmu_hugepage_adjust() arguments to kvm_page_fault
>   KVM: MMU: change disallowed_hugepage_adjust() arguments to
>     kvm_page_fault
>   KVM: MMU: change tracepoints arguments to kvm_page_fault
>   KVM: MMU: mark page dirty in make_spte
>   KVM: MMU: unify tdp_mmu_map_set_spte_atomic and
>     tdp_mmu_set_spte_atomic_no_dirty_log
>   KVM: MMU: inline set_spte in mmu_set_spte
>   KVM: MMU: inline set_spte in FNAME(sync_page)
>   KVM: MMU: clean up make_spte return value
>   KVM: MMU: remove unnecessary argument to mmu_set_spte
>   KVM: MMU: set ad_disabled in TDP MMU role
>   KVM: MMU: pass kvm_mmu_page struct to make_spte
>   KVM: MMU: pass struct kvm_page_fault to mmu_set_spte
>   KVM: MMU: make spte an in-out argument in make_spte
> 
> Sean Christopherson (1):
>   KVM: x86/mmu: Verify shadow walk doesn't terminate early in page
>     faults
> 
>  arch/x86/include/asm/kvm_host.h       |   4 +-
>  arch/x86/include/asm/kvm_page_track.h |   4 +-
>  arch/x86/kvm/mmu.h                    |  84 +++++-
>  arch/x86/kvm/mmu/mmu.c                | 408 +++++++++++---------------
>  arch/x86/kvm/mmu/mmu_internal.h       |  22 +-
>  arch/x86/kvm/mmu/mmutrace.h           |  18 +-
>  arch/x86/kvm/mmu/page_track.c         |   6 +-
>  arch/x86/kvm/mmu/paging_tmpl.h        | 137 +++++----
>  arch/x86/kvm/mmu/spte.c               |  29 +-
>  arch/x86/kvm/mmu/spte.h               |  14 +-
>  arch/x86/kvm/mmu/tdp_mmu.c            | 123 +++-----
>  arch/x86/kvm/mmu/tdp_mmu.h            |   4 +-
>  12 files changed, 390 insertions(+), 463 deletions(-)
> 
> -- 
> 2.27.0
> 
