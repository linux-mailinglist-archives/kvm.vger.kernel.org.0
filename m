Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9D24516ED
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 22:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351908AbhKOVxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 16:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351449AbhKOVt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 16:49:28 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D73C110F02
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 13:24:25 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id h23so18144095ila.4
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 13:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OF/AmZ6/8Ffl75FGr0cijP+KLcfs426fMEZZPs4JNVI=;
        b=pIvcYkim79WC9WdkiITYP1+MB8jzylK6P8JSVinke3Wak+GKuLj/9LL41MA/kBxzLO
         mt2Tn3mwUipNThI2KZuagRb6FQOEK8q+VRxAzPNjF/iDO06QkjHTUYego+I+enb4Rkqa
         likO/95o5f9x87CD75MCsPvYrYTf2TVlHyHCRY+67SgeHXRNSehPkm0molAXqvPaEwfL
         KjZHDOomaBw+eJxMLlaDh1rfnhTbkr+FeFacEo6WFZd/oSuJO8AtpiX8kM8SeDAGcjqz
         uoBmuhNfoHf5acGEZvibL+XGF58Y7+ud83kWff6o+rou96WQ+d38jIS4cM6iDxqolHV2
         xiEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OF/AmZ6/8Ffl75FGr0cijP+KLcfs426fMEZZPs4JNVI=;
        b=f4j1/3htRmyCbO0GyAZ+Tqx87cZiE4dzhHGUnJ9BPbZmTaMQGeT66TXRKj0S4AlWyl
         5etJfBdtBHRcYJiNhnXZZqrsQGU/hL5W65cVQ1S/2esp2/l+wA5lk78JTIFwLZlZn8OY
         qYaYRgJD8x+LdwGmdojqxS8IrQeEye7/Z2aHU3ESKNpyaE/XyUElWUZdpAy+HU6XaUqY
         +XD3kTEuocfJBlqjtB/6yPZs7S6QsLVQpEkUdbyYUUzRZIyJ1JjHuL1Sqo7DwW4jQaq+
         dK72PqVlzA8C16yDEnl74DwwzDDDhYCtWJLZxulaqeR1xcKc7UZtR1W7B/kNpn3AOqJu
         kobg==
X-Gm-Message-State: AOAM531Yuj8Ql93S+OFoY5QgvOWp1PSrDaI9TSK3cIcHrfHL/vb8hQ7J
        ETUtPtm672DLLVHI9hGz3yN05H9PPOM1oROrjRiZBA==
X-Google-Smtp-Source: ABdhPJyAtNhoojT+WsEdgf/onZIEeO2B0MvO+SV7ubGxJKEdvqzToTk7Rh0EZ/U9MxFgpc/V6xnDxS6yETo4gd0u+LY=
X-Received: by 2002:a05:6e02:52d:: with SMTP id h13mr1303304ils.274.1637011464326;
 Mon, 15 Nov 2021 13:24:24 -0800 (PST)
MIME-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 15 Nov 2021 13:24:13 -0800
Message-ID: <CANgfPd8_LhPe5fngddL2b=0cSeDwO5pNUGAtboioCMDhKT8Vnw@mail.gmail.com>
Subject: Re: [RFC 00/19] KVM: x86/mmu: Optimize disabling dirty logging
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

On Wed, Nov 10, 2021 at 2:30 PM Ben Gardon <bgardon@google.com> wrote:
>
> Currently disabling dirty logging with the TDP MMU is extremely slow.
> On a 96 vCPU / 96G VM it takes ~45 seconds to disable dirty logging
> with the TDP MMU, as opposed to ~3.5 seconds with the legacy MMU. This
> series optimizes TLB flushes and introduces in-place large page
> promotion, to bring the disable dirty log time down to ~2 seconds.
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
> > ./dirty_log_perf_test -v 96 -s anonymous_hugetlb_1gb
> Test iterations: 2
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory offset: 0x3fe7c0000000
> Populate memory time: 12.016653537s
> Enabling dirty logging time: 0.001992860s
>
> Iteration 1 dirty memory time: 0.046701599s
> Iteration 1 get dirty log time: 0.001214806s
> Iteration 1 clear dirty log time: 0.049519923s
> Iteration 2 dirty memory time: 3.581931268s
> Iteration 2 get dirty log time: 0.000621383s
> Iteration 2 clear dirty log time: 1.894597059s
> Disabling dirty logging time: 1.950542092s
> Get dirty log over 2 iterations took 0.001836189s. (Avg 0.000918094s/iteration)
> Clear dirty log over 2 iterations took 1.944116982s. (Avg 0.972058491s/iteration)
>
> Patch breakdown:
> Patch 1 is a fix for a bug in the way the TBP MMU issues TLB flushes
> Patches 2-5 eliminate many unnecessary TLB flushes through better batching
> Patches 6-12 remove the need for a vCPU pointer to make_spte
> Patches 13-18 are small refactors in perparation for patch 19
> Patch 19 implements in-place largepage promotion when disabling dirty logging
>
> Ben Gardon (19):
>   KVM: x86/mmu: Fix TLB flush range when handling disconnected pt
>   KVM: x86/mmu: Batch TLB flushes for a single zap
>   KVM: x86/mmu: Factor flush and free up when zapping under MMU write
>     lock
>   KVM: x86/mmu: Yield while processing disconnected_sps
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
>  arch/x86/include/asm/kvm-x86-ops.h    |   1 +
>  arch/x86/include/asm/kvm_host.h       |   2 +
>  arch/x86/include/asm/kvm_page_track.h |   6 +-
>  arch/x86/kvm/mmu/mmu.c                |  45 +++---
>  arch/x86/kvm/mmu/mmu_internal.h       |   6 +-
>  arch/x86/kvm/mmu/page_track.c         |   8 +-
>  arch/x86/kvm/mmu/paging_tmpl.h        |   6 +-
>  arch/x86/kvm/mmu/spte.c               |  43 +++--
>  arch/x86/kvm/mmu/spte.h               |  17 +-
>  arch/x86/kvm/mmu/tdp_mmu.c            | 217 +++++++++++++++++++++-----
>  arch/x86/kvm/mmu/tdp_mmu.h            |   5 +-
>  arch/x86/kvm/svm/svm.c                |   8 +
>  arch/x86/kvm/vmx/vmx.c                |  40 +++--
>  include/linux/kvm_host.h              |  10 +-
>  virt/kvm/kvm_main.c                   |  12 +-
>  15 files changed, 302 insertions(+), 124 deletions(-)
>
> --
> 2.34.0.rc0.344.g81b53c2807-goog
>

In a conversation with Sean today, he expressed interest in taking
over patches 2-4 from this series as it conflicted with another fix he
was working on.
I'll leave it to him to incorporate the feedback on these patches.
In the meantime, I've sent another iteration of patch 1 from this
series (a standalone bug fix) and will work on putting together
another version of patches 5-19.
