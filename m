Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC4A6ED800
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 00:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbjDXWeL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 18:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbjDXWeJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 18:34:09 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F944109
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:34:08 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id 71dfb90a1353d-440375334c1so2083318e0c.2
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682375647; x=1684967647;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hya5HtM8DaHSiWr577YxBeXg4MXiDazfyvrjidrt9Ms=;
        b=3s9FlF3yuSKzN6fg5VIOdb+lPqzllcSHqaej0oXhXwInCI7yLfVo8dQnxbGevAw0Le
         mTjgKRlnrP+o4CGW4IFKICZcTEcFQ3NMDlG34jRQaW+NYTX80gcuJheTsTlyWk0aysQc
         S7eoy3tXujOzC0ZpV2tt7TWZwxbB39zp86638MV1TUX15OAOXuXkezigyhGaD6m+0rNp
         IMBKXcCCV1siL4C9cBTQt1C6OYT1T6XkUFv6eZ6KYVY5osyFiSnF5tWyQgLQGhM1flA7
         6fC2Cpy8VmOgvVufpHmqKoVfGXNmhxpFS07g2z+USuXm18wLcoPiZiE1KeykhQyU+wKK
         RWGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682375647; x=1684967647;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hya5HtM8DaHSiWr577YxBeXg4MXiDazfyvrjidrt9Ms=;
        b=ecQUVvMLA9gIS8uNjYCpy/ZX1H7q/KBAWMIKtNb3HlF9Ic6l2A2BzT/YwQOoyb4aj4
         yE0adOvXLRE4RoXcF8nTKTSlLMvnsoxSEmp66nc6v/77ALW+vW4uJooCYvJPFr9gHPFs
         GMZvo17OpDyeelvud2GWiyo9YUPBf1ge8Mq7bM8KiSRGbZLR1v6YPkiPvEtiAkTp/whp
         vnsQJGEslKwVSGw5YcQvTyeJO0ro+qIZXNouO3pY6bMi7zeuR2RQZe7ylJjv2wwMYzc+
         ug7MWkE+FMC9vDKDt9YZwBZ+FyBIIhA33q4QKv6bSIq03SSrpVdf7HH+Ffu5xf4D1lPP
         Kd8g==
X-Gm-Message-State: AC+VfDzvqp6oHm4DEIBy0knm0OOmvSxk27ktMJN6cjUJfFZitFfJBl+P
        qFnIcaTDw271gR+Pjv6643tlH+tz+Y+r7VmxaC/4DA==
X-Google-Smtp-Source: ACHHUZ5CEnfntrlNJqMiiM9SMbCQlJwh8WvqR20BBdrize7I7vqwdZ7MsdtMyrbInwPeX+tOVw8BkvkOhw2BlXggXSY=
X-Received: by 2002:a1f:5f87:0:b0:44a:e66e:e709 with SMTP id
 t129-20020a1f5f87000000b0044ae66ee709mr172554vkb.0.1682375647327; Mon, 24 Apr
 2023 15:34:07 -0700 (PDT)
MIME-Version: 1.0
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 24 Apr 2023 15:33:40 -0700
Message-ID: <CALzav=eBXp7CBN1hLVmyH0A4Ukt3MXR7=0__xPSOx1X1tw4iSw@mail.gmail.com>
Subject: RFC: Common MMU Recommendation
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvmarm@lists.linux.dev,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
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

Apologies for the long delay since the last Common MMU update. I've
been swamped with Google-internal stuff the past few months. But I
have some updates to share on the strategy I think we should take
going forward.

The "Common TDP MMU" Approach
=============================

In December 2022 I sent an RFC[1] to demonstrate that it is possible
to refactor the KVM/x86 TDP MMU into common code, i.e. introduce a
Common TDP MMU. The intent behind this was to eventually use this to
replace the KVM/ARM and KVM/RISC-V MMU code. This may be a viable
approach for sharing code with RISC-V, but after further
consideration, this is a dead-end for ARM.

The KVM/x86 TDP MMU does not support all of the ARM use-cases
(notably, managing Stage-1 page tables or compiling into the hyp). So
a Common TDP MMU would have to exist alongside the current ARM page
table code (not replace it) for years. This would increase our
maintenance costs by having to support both the Common MMU and ARM MMU
when adding support for new ARM architectural features.

The Common TDP MMU approach is too all-or-nothing, rather than
providing incremental benefit. ARM and x86 are constantly evolving
(e.g. ARM support for Nested Virtualization and Confidential Computing
are under development, both of which require changes to the page table
code). And we know 128-bit ARM page tables are coming. The Common TDP
MMU would be constantly trying to "catch-up" to the ARM MMU, and might
never get there.

Lastly, ARM and x86 have significantly different TLB and cache
maintenance requirements. Future versions of the ARM architecture make
it behave more like x86, but KVM still has to support older versions.
It's highly likely that certain optimizations and patterns we use in
the TDP MMU won't work for ARM.

For all these reasons, continuing to invest in refactoring the KVM/x86
TDP MMU common right now is not worth it for ARM. It still could be
viable for RISC-V, but we (Google) don't have enough resources to
continue this work. I'd be happy to help provide reviews and guidance
to anyone that wants to pick it up.

Looking Forward
===============
I still believe that sharing KVM MMU code across architectures is a
worthwhile pursuit. But I think we should look for more incremental
ways to do it.

For new features, we (Google) plan to upstream both x86 and ARM
support whenever possible, to limit further divergence and to increase
the probability of sharing code whenever possible. Note: x86 and ARM
support won't be upstreamed in a single series due to
architecture-specific maintainers and trees. But we aim to design them
considering both architectures from the beginning.

As for de-duplicating existing code, there will be opportunities to
organically share more code that we should take. The new common
range-based TLB flushing APIs is one example[2].

I also think there are two areas that would be worth investing in:

Determining Host Huge Page Size
-------------------------------
When handling a fault, KVM needs to figure out what size mapping it
can use to map the memory. KVM/x86 figures this out (in part) by
walking the Linux stage-1 page tables. KVM/ARM and KVM/RISC-V perform
a vma_lookup() under the mmap_lock and inspect the VMA.

The latter approach has scalability downsides (mmap_lock) and also
does not work with HugeTLB High Granularity Mapping[3], where Linux
can map HugeTLB memory with smaller mappings to enable demand fetching
4KiB at a time (and KVM must do the same).

I'd like to unify the architectures to use a common Linux stage-1 page
table walk to fix the HGM use-case, and share more code. It may even
be possible to avoid the vma_lookup() eventually [4].

KVM Page Table Iterators
------------------------
To have any hope of sharing MMU code, we have to invest in sharing
page table code.

A good place to start here would be a common page table walker (x86
folks: think tdp_iter.c). Page tables are relatively simple data
structures, and walking through them is just a tree traversal.
Differences in page table layout can be parameterized in the walker
and architecture-specific code can handle parsing the PTEs. But the
actual walking and, more perhaps importantly, the _interface_ for
walking the page tables can be common.

Consider the x86 and ARM MMU code today. They use very different code
for walking page tables: x86 uses pre-order traversals with for-loop
macros. ARM uses pre-order and post-order traversals using callbacks
and function recursion. The stark difference in how the tables are
walked makes it very difficult to work across the architectures.

Next Steps
==========
I will be on paternity leave from May to September. So there likely
won't be much progress from me for a while. But I'm going to see if we
can find someone to work on the common Linux stage-1 walker while I'm
out.

---

Thanks to Oliver Upton, Sean Christopherson, and Marc Zyngier for
their input on this recommendation.

[1] https://lore.kernel.org/kvm/20221208193857.4090582-1-dmatlack@google.com/
[2] https://lore.kernel.org/kvm/20230126184025.2294823-1-dmatlack@google.com/
[3] https://lore.kernel.org/linux-mm/20230218002819.1486479-1-jthoughton@google.com/
[4] ARM also uses the VMA lookup to map PFNMAP VMAs with huge pages.
We might need to keep that around until Linux Stage-1 also uses huge
pages for PFNMAP VMAs (if it doesn't already).
