Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA755FDED6
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 19:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiJMRVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 13:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiJMRVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 13:21:31 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16887D9945
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 10:21:30 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-360871745b0so24040067b3.3
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 10:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QuAPrq7fg7n5xtr2Tt6KkaaUEeLuu+jNnvfbI0TJOvQ=;
        b=TcbfAV+G20cD+j8MXhlBXVZ6475WoerOXjRAY/TZ78ZBxROpWGFW7BdXnDll3LaO9N
         XQdOKl8y1MWP2bMGTEFHXLc0bdGKtpAPEhP8qmAlEleBjK+L+e7hLO7YabSdLMmdB23i
         duN3DXmq35Pze0amNomz6pGO6SuLtDj9K86YpB7i+ZB8bw7AxIFTpxMOAsgltOB5pjIJ
         x9m4eDjS+y5RiuL/nBIJ6lvytzuccgJROuVcaOK34QSeSVUi/Jf9PnTBY/ZO58tBHih0
         u0H2gF9auA/tZvvqm/CACMFf3GiKsOr67MJb5a3DEUS9gEHJNd/E+9ktazTwsGG2Hswc
         4ESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QuAPrq7fg7n5xtr2Tt6KkaaUEeLuu+jNnvfbI0TJOvQ=;
        b=thVyGZWXSQ4lxmGcsLaGGI6AWhBFbkd0iPwYpXqV4ooh5If0TuHYqZJFNcTrATvzfc
         JfL4ePX/J6IVCWaGzf9FLd/7uTuMtLtdizN/dFdw2b0jR5nd83H0Y73cZNfncdIUhwvZ
         jiRx/5mpgiN+/V5WAIZyao2TPM0i2LJiSombL6Cv+yFZsMrMfLSHXP0me2Xljr3k7ug6
         pvBQMvFMYJUdxjCkCxFuzLcyKfi8Wgb/6vpTBPtlQTJQl41yyfODdaqTXIH8AMYFmCOl
         DB0S4KGHs9p84f10pkm0pZU8s0AnFKxPaW9SQX4W4r2wXRvV5Q9gaU4r3TtypmfnVMBF
         aVSg==
X-Gm-Message-State: ACrzQf2KpMxT4KzB+dchBR6ZihVQ6Jd/RHitt32QJGme74vJVdyDuqpV
        9dTqodcVsa2wuizEoVTPzN4Df8EtqgK1ccT+qPTlBw==
X-Google-Smtp-Source: AMsMyM7EYOPAqQtv3tYWi/iflfKvVcuZlSSnM/7DH525UefT2YqiASBW2R2cOnQ8OvVCMuzlp1djkiUueSzgoa6C2PE=
X-Received: by 2002:a81:9204:0:b0:358:89e9:cff9 with SMTP id
 j4-20020a819204000000b0035889e9cff9mr973200ywg.168.1665681689194; Thu, 13 Oct
 2022 10:21:29 -0700 (PDT)
MIME-Version: 1.0
References: <20221012181702.3663607-1-seanjc@google.com>
In-Reply-To: <20221012181702.3663607-1-seanjc@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 13 Oct 2022 10:21:02 -0700
Message-ID: <CALzav=fZvNttbXSZfCCaFym8cNHYmFZX7286CW_zTZA1CTr3kA@mail.gmail.com>
Subject: Re: [PATCH v4 00/11] KVM: x86/mmu: Make tdp_mmu a read-only parameter
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Oct 12, 2022 at 11:17 AM Sean Christopherson <seanjc@google.com> wrote:
>
> This is a variation of David's series to change tdp_mmu to a RO param[*].
> The key difference is that instead of moving the TDP MMU page fault handler
> to its own function, use static branches to make TDP MMU page faults (and
> a few other paths) effectively branch free.
>
> I'm not dead set against having a dedicated TDP MMU page fault handler, but
> IMO it's not really better once the TDP MMU vs. shadow MMU is reduced to a
> static branch, just different.  The read vs. write mmu_lock is the most
> visible ugliness, and that can be buried in helpers if we really want to
> make the page fault handler easier on the eyes, e.g.
>
>         direct_page_fault_mmu_lock(vcpu);
>
>         if (is_page_fault_stale(vcpu, fault))
>                 goto out_unlock;
>
>         if (is_tdp_mmu_enabled()) {
>                 r = kvm_tdp_mmu_map(vcpu, fault);
>         } else {
>                 r = make_mmu_pages_available(vcpu);
>                 if (r)
>                         goto out_unlock;
>
>                 r = __direct_map(vcpu, fault);
>         }
>
> out_unlock:
>         direct_page_fault_mmu_unlock(vcpu);

Thanks for the respin.

My preference is still separate handlers. When I am reading this code,
I only care about one path (TDP MMU or Shadow MMU, usually TDP MMU).
Having separate handlers makes it easy to read since I don't have to
care about the implementation details of the other MMU.

And more importantly (but less certain), the TDP MMU fault handler is
going to diverge further from the Shadow MMU fault handler in the near
future. i.e. There will be more and more branches in a common fault
handler, and the value of having a common fault handler diminishes.
Specifically, to support moving the TDP MMU to common code, the TDP
MMU is no longer going to topup the same mem caches as the Shadow MMU
(TDP MMU is not going to use struct kvm_mmu_page), and the TDP MMU
will probably have its own fast_page_fault() handler eventually.

If we do go the common handler route, I don't prefer the
direct_page_fault_mmu_lock/unlock() wrapper since it further obscures
the differences between the 2 MMUs.

>
> v4:
>   - Keep is_tdp_mmu_page() in patch 1.
>   - Collect reviews. [Isaku]
>   - Skip "make MMU pages available" for root allocations.
>   - Rework "is TDP MMU" checks to take advantage of read-only param.
>   - Use a static key to track TDP MMU enabling.
>
> [*] https://lkml.kernel.org/r/20220921173546.2674386-1-dmatlack@google.com
>
> David Matlack (7):
>   KVM: x86/mmu: Change tdp_mmu to a read-only parameter
>   KVM: x86/mmu: Move TDP MMU VM init/uninit behind tdp_mmu_enabled
>   KVM: x86/mmu: Grab mmu_invalidate_seq in kvm_faultin_pfn()
>   KVM: x86/mmu: Handle error PFNs in kvm_faultin_pfn()
>   KVM: x86/mmu: Avoid memslot lookup during KVM_PFN_ERR_HWPOISON
>     handling
>   KVM: x86/mmu: Handle no-slot faults in kvm_faultin_pfn()
>   KVM: x86/mmu: Stop needlessly making MMU pages available for TDP MMU
>
> Sean Christopherson (4):
>   KVM: x86/mmu: Pivot on "TDP MMU enabled" when handling direct page
>     faults
>   KVM: x86/mmu: Pivot on "TDP MMU enabled" to check if active MMU is TDP
>     MMU
>   KVM: x86/mmu: Replace open coded usage of tdp_mmu_page with
>     is_tdp_mmu_page()
>   KVM: x86/mmu: Use static key/branches for checking if TDP MMU is
>     enabled
>
>  arch/x86/include/asm/kvm_host.h |   9 --
>  arch/x86/kvm/mmu.h              |  14 ++-
>  arch/x86/kvm/mmu/mmu.c          | 212 ++++++++++++++++++++------------
>  arch/x86/kvm/mmu/mmu_internal.h |   1 +
>  arch/x86/kvm/mmu/paging_tmpl.h  |  12 +-
>  arch/x86/kvm/mmu/tdp_mmu.c      |  13 +-
>  arch/x86/kvm/mmu/tdp_mmu.h      |  25 +---
>  7 files changed, 149 insertions(+), 137 deletions(-)
>
>
> base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
> --
> 2.38.0.rc1.362.ged0d419d3c-goog
>
