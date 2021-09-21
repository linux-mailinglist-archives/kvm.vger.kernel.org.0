Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4627A412E99
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 08:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhIUG25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 02:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhIUG24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 02:28:56 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813B8C061574
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 23:27:28 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id ay33so50932958qkb.10
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 23:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bx2qLnibyjBQP3Cwq2rxTrw1KpHuF4QRllMp6t6UiFc=;
        b=a+vdvt88RTaFWVh/6GdGX0TUYAxYiZBTFwUXiduLzzBGBA58aeJyJ/WH5xNmFBtn/r
         xRrBAFTpOUiBaElOXIFY/I4e5GBgQG1E7dSqBD6oh6smn7vW7enSkUx1VLFh//geJ+8v
         J1VEIrYJ11fBZTo5/LP/PXnOJJLTqTREpTQLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bx2qLnibyjBQP3Cwq2rxTrw1KpHuF4QRllMp6t6UiFc=;
        b=xZR7OZFVsLMaEuUtqdJ9JZCCrKepsua85mK0pc0iT/VYtCzKcAhyjuqkaBYGQMijTO
         S4JIR3N7bD4UqfirUq6yP6EccN4ttZhusagQsk4NLqMEXJlUSRovnVtefw4Wari42QWy
         okYS5ZeJx9eS9Zy/buu0MTB9JVM7PHk+6876hANoZSyEvDHmihk43qD65HOz9qQEs11d
         GJL/YDgNCdJXkWMsJApRaDSCanPzq8OdjTeZG0onCHx387/pzcFW6/BYGvVnw0pyvxU8
         iY2CNAMR8YRJAkqQBuNyxflz579gXeuKQXv5oWwB/H6pyIxDbnO9Diwn4rSo2ccZA0BF
         fcCg==
X-Gm-Message-State: AOAM532SuCjB/SOZXIneT90upvZ0k5qQZTDrerEpTrIGGL5xdVMWjBft
        zkGngmPEBRYJh396iFXnjl39Zo+g+VJDJFBYNk0U+M72dBofjg==
X-Google-Smtp-Source: ABdhPJwqv0yS1pJjqGFDkqVh9BDwoNusU5NQWtDRZgLijPyw8WvND8LS4z/Pgwym+MF/bGjXyf5kg/pSdTblO8nOE/I=
X-Received: by 2002:a05:6902:1547:: with SMTP id r7mr34266227ybu.72.1632205647689;
 Mon, 20 Sep 2021 23:27:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210825025009.2081060-1-stevensd@google.com>
In-Reply-To: <20210825025009.2081060-1-stevensd@google.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Tue, 21 Sep 2021 15:27:16 +0900
Message-ID: <CAD=HUj6_CFE0ZjexVMQMansmVcFRm3-udG=_12ROKfWDroNt-g@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] KVM: allow mapping non-refcounted pages
To:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        open list <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Is there any feedback on these patches? CVE-2021-22543 was fixed by
disallowing mapping of non-refcounted memory. These patches add proper
support for mapping that type of memory.

-David

On Wed, Aug 25, 2021 at 11:50 AM David Stevens <stevensd@chromium.org> wrote:
>
> From: David Stevens <stevensd@chromium.org>
>
> This patch series adds support for mapping non-refcount VM_IO and
> VM_PFNMAP memory into the guest.
>
> Currently, the gfn_to_pfn functions require being able to pin the target
> pfn, so they will fail if the pfn returned by follow_pte isn't a
> ref-counted page.  However, the KVM secondary MMUs do not require that
> the pfn be pinned, since they are integrated with the mmu notifier API.
> This series adds a new set of gfn_to_pfn_page functions which parallel
> the gfn_to_pfn functions but do not pin the pfn. The new functions
> return the page from gup if it was present, so callers can use it and
> call put_page when done.
>
> The gfn_to_pfn functions should be depreciated, since as they are unsafe
> due to relying on trying to obtain a struct page from a pfn returned by
> follow_pte. I added new functions instead of simply adding another
> optional parameter to the existing functions to make it easier to track
> down users of the deprecated functions.
>
> This series updates x86 and arm64 secondary MMUs to the new API.
>
> v2 -> v3:
>  - rebase on kvm next branch
> v1 -> v2:
>  - Introduce new gfn_to_pfn_page functions instead of modifying the
>    behavior of existing gfn_to_pfn functions, to make the change less
>    invasive.
>  - Drop changes to mmu_audit.c
>  - Include Nicholas Piggin's patch to avoid corrupting refcount in the
>    follow_pte case, and use it in depreciated gfn_to_pfn functions.
>  - Rebase on kvm/next
>
> David Stevens (4):
>   KVM: mmu: introduce new gfn_to_pfn_page functions
>   KVM: x86/mmu: use gfn_to_pfn_page
>   KVM: arm64/mmu: use gfn_to_pfn_page
>   KVM: mmu: remove over-aggressive warnings
>
>  arch/arm64/kvm/mmu.c            |  26 +++--
>  arch/x86/kvm/mmu/mmu.c          |  50 +++++----
>  arch/x86/kvm/mmu/mmu_internal.h |   3 +-
>  arch/x86/kvm/mmu/paging_tmpl.h  |  23 ++--
>  arch/x86/kvm/mmu/tdp_mmu.c      |   6 +-
>  arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
>  arch/x86/kvm/x86.c              |   6 +-
>  include/linux/kvm_host.h        |  17 +++
>  virt/kvm/kvm_main.c             | 188 +++++++++++++++++++++++---------
>  9 files changed, 220 insertions(+), 103 deletions(-)
>
> --
> 2.33.0.rc2.250.ged5fa647cd-goog
>
