Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AB8219FCD
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 14:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgGIMOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 08:14:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24897 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727814AbgGIMOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 08:14:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594296875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kwRIPXQdD58+F7cV0LER43YEzOAqv3hHNiA5thj41Io=;
        b=cVCQOvTzQLiJEVpyUbxvPhbSQpUxzVZtXyKqyeYGFbAN1T+iquSqMwtHHLMK9ZXJn66KL0
        R2r1FthKbm4bqAcEtLpDYzcUmf5heC0teSOwpu0c+1IVQz1DXoQV8/JHKo23+d6/1xQWRv
        vBIcsF3xLG+hbv/lB65P2Esaue7994U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-BkgrZ-hoNkKuF-NrXxBhIw-1; Thu, 09 Jul 2020 08:14:32 -0400
X-MC-Unique: BkgrZ-hoNkKuF-NrXxBhIw-1
Received: by mail-wr1-f72.google.com with SMTP id a18so1746031wrm.14
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 05:14:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kwRIPXQdD58+F7cV0LER43YEzOAqv3hHNiA5thj41Io=;
        b=dikCV9Cau0hAoFlA77i2cXh7KAR5jhlTux5oaGichS0we4oh3sRwFQ5G6VupB11v6n
         4gi7YWi33VO/Te147MVJzSbuFpkHr39fxMV22fJa0cookblj3qtr1s3+oJrD91SuHmuo
         Upesw4GL3+V3hzumu8L+5aSBg8t9aXpK9ACoFkayXLPRLYwuwZzNSJO5mRg2Rr105AmR
         kY6vunOO2SJyBvi15mSmYwGJLgqfrAGX9HVRQmomf6My1/zDdKzgUmfmhkxw6HgVpEyg
         vp2KOc0N7ewaNOkWpamxYIBCNJxPk3hqocudM23uRto1t/tB/TZnN9OfTTA2NPcLuYDg
         iVhA==
X-Gm-Message-State: AOAM533edRQqhlLhLinmnYHYkdeqG58AZMd6+YKzSL8IjKtSPloieETO
        uAVTkadUKJ4Rp3bI7rTy2DaeIgrnWsaKh810UkXy1jE7KHdsbXgqzxAd7hVFZCXpGajwR+CXdBt
        ZjEHrKd6N6HmO
X-Received: by 2002:a7b:c92e:: with SMTP id h14mr13361795wml.36.1594296871531;
        Thu, 09 Jul 2020 05:14:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRhPo7g5kUipBnsOFe+3r9VY5ESGX0vtcsJ/9+mosHc1rT3gI7GlSh2CG+AM/UAt8pI6ZlHQ==
X-Received: by 2002:a7b:c92e:: with SMTP id h14mr13361761wml.36.1594296871306;
        Thu, 09 Jul 2020 05:14:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id c206sm4897543wmf.36.2020.07.09.05.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 05:14:30 -0700 (PDT)
Subject: Re: [PATCH v3 00/21] KVM: Cleanup and unify kvm_mmu_memory_cache
 usage
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Marc Zyngier <maz@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
References: <20200703023545.8771-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9cce79d8-bc8a-8a3a-060a-c9a882dd7e07@redhat.com>
Date:   Thu, 9 Jul 2020 14:14:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200703023545.8771-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/20 04:35, Sean Christopherson wrote:
> The only interesting delta from v2 is that patch 18 is updated to handle
> a conflict with arm64's p4d rework.  Resolution was straightforward
> (famous last words).
> 
> 
> This series resurrects Christoffer Dall's series[1] to provide a common
> MMU memory cache implementation that can be shared by x86, arm64 and MIPS.
> 
> It also picks up a suggested change from Ben Gardon[2] to clear shadow
> page tables during initial allocation so as to avoid clearing entire
> pages while holding mmu_lock.
> 
> The front half of the patches do house cleaning on x86's memory cache
> implementation in preparation for moving it to common code, along with a
> fair bit of cleanup on the usage.  The middle chunk moves the patches to
> common KVM, and the last two chunks convert arm64 and MIPS to the common
> implementation.
> 
> Fully tested on x86 only.  Compile tested patches 14-21 on arm64, MIPS,
> s390 and PowerPC.

Queued, thanks.

Paolo

> v3:
>   - Rebased to kvm/queue, commit a037ff353ba6 ("Merge ... into HEAD")
>   - Collect more review tags. [Ben]
> 
> v2:
>   - Rebase to kvm-5.8-2, commit 49b3deaad345 ("Merge tag ...").
>   - Use an asm-generic kvm_types.h for s390 and PowerPC instead of an
>     empty arch-specific file. [Marc]
>   - Explicit document "GFP_PGTABLE_USER == GFP_KERNEL_ACCOUNT | GFP_ZERO"
>     in the arm64 conversion patch. [Marc]
>   - Collect review tags. [Ben]
> 
> Sean Christopherson (21):
>   KVM: x86/mmu: Track the associated kmem_cache in the MMU caches
>   KVM: x86/mmu: Consolidate "page" variant of memory cache helpers
>   KVM: x86/mmu: Use consistent "mc" name for kvm_mmu_memory_cache locals
>   KVM: x86/mmu: Remove superfluous gotos from mmu_topup_memory_caches()
>   KVM: x86/mmu: Try to avoid crashing KVM if a MMU memory cache is empty
>   KVM: x86/mmu: Move fast_page_fault() call above
>     mmu_topup_memory_caches()
>   KVM: x86/mmu: Topup memory caches after walking GVA->GPA
>   KVM: x86/mmu: Clean up the gorilla math in mmu_topup_memory_caches()
>   KVM: x86/mmu: Separate the memory caches for shadow pages and gfn
>     arrays
>   KVM: x86/mmu: Make __GFP_ZERO a property of the memory cache
>   KVM: x86/mmu: Zero allocate shadow pages (outside of mmu_lock)
>   KVM: x86/mmu: Skip filling the gfn cache for guaranteed direct MMU
>     topups
>   KVM: x86/mmu: Prepend "kvm_" to memory cache helpers that will be
>     global
>   KVM: Move x86's version of struct kvm_mmu_memory_cache to common code
>   KVM: Move x86's MMU memory cache helpers to common KVM code
>   KVM: arm64: Drop @max param from mmu_topup_memory_cache()
>   KVM: arm64: Use common code's approach for __GFP_ZERO with memory
>     caches
>   KVM: arm64: Use common KVM implementation of MMU memory caches
>   KVM: MIPS: Drop @max param from mmu_topup_memory_cache()
>   KVM: MIPS: Account pages used for GPA page tables
>   KVM: MIPS: Use common KVM implementation of MMU memory caches
> 
>  arch/arm64/include/asm/kvm_host.h  |  11 ---
>  arch/arm64/include/asm/kvm_types.h |   8 ++
>  arch/arm64/kvm/arm.c               |   2 +
>  arch/arm64/kvm/mmu.c               |  56 +++----------
>  arch/mips/include/asm/kvm_host.h   |  11 ---
>  arch/mips/include/asm/kvm_types.h  |   7 ++
>  arch/mips/kvm/mmu.c                |  44 ++--------
>  arch/powerpc/include/asm/Kbuild    |   1 +
>  arch/s390/include/asm/Kbuild       |   1 +
>  arch/x86/include/asm/kvm_host.h    |  14 +---
>  arch/x86/include/asm/kvm_types.h   |   7 ++
>  arch/x86/kvm/mmu/mmu.c             | 129 +++++++++--------------------
>  arch/x86/kvm/mmu/paging_tmpl.h     |  10 +--
>  include/asm-generic/kvm_types.h    |   5 ++
>  include/linux/kvm_host.h           |   7 ++
>  include/linux/kvm_types.h          |  19 +++++
>  virt/kvm/kvm_main.c                |  55 ++++++++++++
>  17 files changed, 176 insertions(+), 211 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_types.h
>  create mode 100644 arch/mips/include/asm/kvm_types.h
>  create mode 100644 arch/x86/include/asm/kvm_types.h
>  create mode 100644 include/asm-generic/kvm_types.h
> 

