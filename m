Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210054528A3
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 04:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhKPDkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 22:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbhKPDjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 22:39:04 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F205C1276F9
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:58:37 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id 14so23499719ioe.2
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rIVNjgG4r8C2Qpo2XG80XfnjCwJinqyXbT9NtOTqwxE=;
        b=G7xyIdVNQ9yuqZmHX0vz73gOy8llAgwgo65t8I/6OLPNX93vJl59DQItYlMyPMWkRB
         peCYvvOLfXH7jfHSwWzsGVaqYd6KmXzBdgKpz8TG3JZgKuKGIfc+f2TPeviqiMbE+mLk
         MpGEnZY6H2K1pIaW3ZJXM9u+wSiX/hS/0dGZLQUGOl4A4dopr0YGpwCyMspE++irJ1O6
         pLWPs8GjyjKtCCZdlP1Au7togdY+hLUQHPRErlESSbezigbuZ5qZKHWSGgFDXHvVCrqC
         5GSpd75Bx/RJS/7AVXZBVBh3DMlZjKTJDRVPyj5MJ9Rr/kxUt3uFv4RzE14RP5TydUjL
         5NGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rIVNjgG4r8C2Qpo2XG80XfnjCwJinqyXbT9NtOTqwxE=;
        b=ttINalm/hpyCKkGpLjpscbxv7f9S3cN3DSal+gGHpl0rlCWr+zY0Icuv46kEi63EJ2
         CsaHGxQKWpua/D7VQ/UAdVoPBdEL0mQC1XcwvRbGFZOYwEiGpgmR/yileCoUPFUuSuJq
         2AANn2VZ1kxOvOA6UAQXYWFS0iQP6p0pRk2n+YO2eb8kLdPHC4WUc77O+a4MSIOF6LPc
         bBCnLYQaKQaBn4HwvvEwya0h5UDtnScLM+mPzOhmvrbHVQkbBAaLHfwiv/z+sML7s1tn
         sYpgatODqubRNcAtWTuafTr+VmRNBk4dU1C3GVD4PMyCw82FeUAtPN31nMa/iwpVduT6
         7nDA==
X-Gm-Message-State: AOAM532+xOos66xk/vVEUblSkAQOdgNmCmDVeolKYzrLxcbyh7Tq9up2
        hDE0nZk7kUAehVpVShGvOzCPjowxCWGWcQAehjj+OQmh3CAokw==
X-Google-Smtp-Source: ABdhPJzgmK0oy6IkA7wQoR/MbGs4Y+H4D4v7Jfhpc4Gp55rHx4Pft9toFQTNwj6nc96jYVfNAAbJQqbbClqOGH9FbCI=
X-Received: by 2002:a5d:9493:: with SMTP id v19mr1914750ioj.34.1637020716570;
 Mon, 15 Nov 2021 15:58:36 -0800 (PST)
MIME-Version: 1.0
References: <20211115234603.2908381-1-bgardon@google.com>
In-Reply-To: <20211115234603.2908381-1-bgardon@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 15 Nov 2021 15:58:25 -0800
Message-ID: <CANgfPd8AHMdXAKrOVOwfAps+0qXVfkHD6EY-kW6oU+DisqGiLg@mail.gmail.com>
Subject: Re: [PATCH 00/15] Currently disabling dirty logging with the TDP MMU
 is extremely slow. On a 96 vCPU / 96G VM it takes ~45 seconds to disable
 dirty logging with the TDP MMU, as opposed to ~3.5 seconds with the legacy
 MMU. This series optimizes TLB flushes and introduces in-place large page
 promotion, to bring the disable dirty log time down to ~2 seconds.
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 3:46 PM Ben Gardon <bgardon@google.com> wrote:

Haha oops, I lost the covers letter title there. It should have been
"KVM: x86/mmu: Optimize disabling dirty logging" and the subject line
should have been the first paragraph.
I'll correct that on any future versions of this series I send out.

>
> Testing:
> Ran KVM selftests and kvm-unit-tests on an Intel Skylake. This
> series introduced no new failures.
>
> Performance:
> To collect these results I needed to apply Mingwei's patch
> "selftests: KVM: align guest physical memory base address to 1GB"
> https://lkml.org/lkml/2021/8/29/310
> David Matlack is going to send out an updated version of that patch soon.
>
> Without this series, TDP MMU:
> > ./dirty_log_perf_test -v 96 -s anonymous_hugetlb_1gb
> Test iterations: 2
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory offset: 0x3fe7c0000000
> Populate memory time: 10.966500447s
> Enabling dirty logging time: 0.002068737s
>
> Iteration 1 dirty memory time: 0.047556280s
> Iteration 1 get dirty log time: 0.001253914s
> Iteration 1 clear dirty log time: 0.049716661s
> Iteration 2 dirty memory time: 3.679662016s
> Iteration 2 get dirty log time: 0.000659546s
> Iteration 2 clear dirty log time: 1.834329322s
> Disabling dirty logging time: 45.738439510s
> Get dirty log over 2 iterations took 0.001913460s. (Avg 0.000956730s/iteration)
> Clear dirty log over 2 iterations took 1.884045983s. (Avg 0.942022991s/iteration)
>
> Without this series, Legacy MMU:
> > ./dirty_log_perf_test -v 96 -s anonymous_hugetlb_1gb
> Test iterations: 2
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory offset: 0x3fe7c0000000
> Populate memory time: 12.664750666s
> Enabling dirty logging time: 0.002025510s
>
> Iteration 1 dirty memory time: 0.046240875s
> Iteration 1 get dirty log time: 0.001864342s
> Iteration 1 clear dirty log time: 0.170243637s
> Iteration 2 dirty memory time: 31.571088701s
> Iteration 2 get dirty log time: 0.000626245s
> Iteration 2 clear dirty log time: 1.294817729s
> Disabling dirty logging time: 3.566831573s
> Get dirty log over 2 iterations took 0.002490587s. (Avg 0.001245293s/iteration)
> Clear dirty log over 2 iterations took 1.465061366s. (Avg 0.732530683s/iteration)
>
> With this series, TDP MMU:
> (Updated since RFC. Pulling out patches 1-4 could have a performance impact.)
> > ./dirty_log_perf_test -v 96 -s anonymous_hugetlb_1gb
> Test iterations: 2
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory offset: 0x3fe7c0000000
> Populate memory time: 12.225242366s
> Enabling dirty logging time: 0.002063442s
>
> Iteration 1 dirty memory time: 0.047598123s
> Iteration 1 get dirty log time: 0.001247702s
> Iteration 1 clear dirty log time: 0.051062420s
> Iteration 2 dirty memory time: 3.660439803s
> Iteration 2 get dirty log time: 0.000736229s
> Iteration 2 clear dirty log time: 1.043469951s
> Disabling dirty logging time: 1.400549627s
> Get dirty log over 2 iterations took 0.001983931s. (Avg 0.000991965s/iteration)
> Clear dirty log over 2 iterations took 1.094532371s. (Avg 0.547266185s/iteration)
>
> Patch breakdown:
> Patches 1 eliminates extra TLB flushes while disabling dirty logging.
> Patches 2-8 remove the need for a vCPU pointer to make_spte
> Patches 9-14 are small refactors in perparation for patch 19
> Patch 15 implements in-place largepage promotion when disabling dirty logging
>
> Changelog:
> RFC -> v1:
>         Dropped the first 4 patches from the series. Patch 1 was sent
>         separately, patches 2-4 will be taken over by Sean Christopherson.
>         Incorporated David Matlack's Reviewed-by.
>
> Ben Gardon (15):
>   KVM: x86/mmu: Remove redundant flushes when disabling dirty logging
>   KVM: x86/mmu: Introduce vcpu_make_spte
>   KVM: x86/mmu: Factor wrprot for nested PML out of make_spte
>   KVM: x86/mmu: Factor mt_mask out of make_spte
>   KVM: x86/mmu: Remove need for a vcpu from
>     kvm_slot_page_track_is_active
>   KVM: x86/mmu: Remove need for a vcpu from mmu_try_to_unsync_pages
>   KVM: x86/mmu: Factor shadow_zero_check out of make_spte
>   KVM: x86/mmu: Replace vcpu argument with kvm pointer in make_spte
>   KVM: x86/mmu: Factor out the meat of reset_tdp_shadow_zero_bits_mask
>   KVM: x86/mmu: Propagate memslot const qualifier
>   KVM: x86/MMU: Refactor vmx_get_mt_mask
>   KVM: x86/mmu: Factor out part of vmx_get_mt_mask which does not depend
>     on vcpu
>   KVM: x86/mmu: Add try_get_mt_mask to x86_ops
>   KVM: x86/mmu: Make kvm_is_mmio_pfn usable outside of spte.c
>   KVM: x86/mmu: Promote pages in-place when disabling dirty logging
>
>  arch/x86/include/asm/kvm-x86-ops.h    |  1 +
>  arch/x86/include/asm/kvm_host.h       |  2 +
>  arch/x86/include/asm/kvm_page_track.h |  6 +-
>  arch/x86/kvm/mmu/mmu.c                | 45 +++++++------
>  arch/x86/kvm/mmu/mmu_internal.h       |  6 +-
>  arch/x86/kvm/mmu/page_track.c         |  8 +--
>  arch/x86/kvm/mmu/paging_tmpl.h        |  6 +-
>  arch/x86/kvm/mmu/spte.c               | 43 ++++++++----
>  arch/x86/kvm/mmu/spte.h               | 17 +++--
>  arch/x86/kvm/mmu/tdp_mmu.c            | 97 +++++++++++++++++++++------
>  arch/x86/kvm/mmu/tdp_mmu.h            |  5 +-
>  arch/x86/kvm/svm/svm.c                |  8 +++
>  arch/x86/kvm/vmx/vmx.c                | 40 ++++++-----
>  include/linux/kvm_host.h              | 10 +--
>  virt/kvm/kvm_main.c                   | 12 ++--
>  15 files changed, 205 insertions(+), 101 deletions(-)
>
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>
