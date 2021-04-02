Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E37352A86
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 14:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhDBMRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 08:17:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235204AbhDBMRw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Apr 2021 08:17:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617365870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Muwx+qawsLcE0Xkj8kzlIVuDAwSyy9qsNyKVPtLvlps=;
        b=HZSAyiwAUqB52KGI0S8JoX9rhjlNj2PlC8kb2tysRAKr2y5AEQ6DR2nMx+VwAPTfikc6hG
        19ssD2UVmV1m8B0XoKnMpLw2KzRO0SHNZmBWTCtXa6G739mUWjyvV72CZv9V5BeLOiv1Ij
        RCAPXJSxdHEHL70qBIry8+eXleMSFJE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-AaIe7b0bNdClDTyBS-HREQ-1; Fri, 02 Apr 2021 08:17:49 -0400
X-MC-Unique: AaIe7b0bNdClDTyBS-HREQ-1
Received: by mail-wr1-f70.google.com with SMTP id f3so4275644wrt.14
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 05:17:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Muwx+qawsLcE0Xkj8kzlIVuDAwSyy9qsNyKVPtLvlps=;
        b=KWELeST9QA1Tws7NjXWRmdLw79wneH2ZvDmMNdBkjzFNY4OUz5Rdl+dFwtqHLyQ6Zv
         +6oItKPSlfx6W7UMvjX0gPnMw3UA0nU5YM63n7Ms3JaQkX7Ptn19bgjqWhxtD9C68yIU
         1if/XrZT/U833SeYjHv+/gAG971/WxgFTqCi6EY2u6V6Pz386Aw2uYCpaulzV2KVqx7+
         nMKouy9n8Ds5H8pP7H/pIs2sEjdxII2jLmgdj2d5CkWshWHbDVMJaY2a7peQzyD42PD9
         K+f8zdXgDgmAifHDygbbBe8LJ7+MfOHxpvRwSWMscCUrcHPo/16vFbsGGUETLdkEaxcu
         gKNg==
X-Gm-Message-State: AOAM5324XYE+a+1aoMy8Aki5MtOeurrOYh6vfKCgjwYjMAEbf7UyUvnp
        DpSQy9fMVta7V+1FUIMJC5g61kR8V7yqX6hrkh7iSvIC+C3jONE9WK1/28LVI8ir87Y19op6z5u
        0cphDpIjYZi6P
X-Received: by 2002:a05:6000:362:: with SMTP id f2mr15172717wrf.141.1617365868287;
        Fri, 02 Apr 2021 05:17:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLaJxTI8QPBvKFmAdjnuuObyL8/ENWh8opXUP0PYyDWSCUQKuWQD6mlne9MO5n6MrTzGeeiQ==
X-Received: by 2002:a05:6000:362:: with SMTP id f2mr15172680wrf.141.1617365868029;
        Fri, 02 Apr 2021 05:17:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id n9sm14323662wrx.46.2021.04.02.05.17.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 05:17:47 -0700 (PDT)
Subject: Re: [PATCH v2 00/10] KVM: Consolidate and optimize MMU notifiers
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20210402005658.3024832-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9376b453-be3a-f8b7-d53a-7e54c25161ce@redhat.com>
Date:   Fri, 2 Apr 2021 14:17:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210402005658.3024832-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/04/21 02:56, Sean Christopherson wrote:
> The end goal of this series is to optimize the MMU notifiers to take
> mmu_lock if and only if the notification is relevant to KVM, i.e. the hva
> range overlaps a memslot.   Large VMs (hundreds of vCPUs) are very
> sensitive to mmu_lock being taken for write at inopportune times, and
> such VMs also tend to be "static", e.g. backed by HugeTLB with minimal
> page shenanigans.  The vast majority of notifications for these VMs will
> be spurious (for KVM), and eliding mmu_lock for spurious notifications
> avoids an otherwise unacceptable disruption to the guest.
> 
> To get there without potentially degrading performance, e.g. due to
> multiple memslot lookups, especially on non-x86 where the use cases are
> largely unknown (from my perspective), first consolidate the MMU notifier
> logic by moving the hva->gfn lookups into common KVM.
> 
> Based on kvm/queue, commit 5f986f748438 ("KVM: x86: dump_vmcs should
> include the autoload/autostore MSR lists").
> 
> Well tested on Intel and AMD.  Compile tested for arm64, MIPS, PPC,
> PPC e500, and s390.  Absolutely needs to be tested for real on non-x86,
> I give it even odds that I introduced an off-by-one bug somewhere.
> 
> v2:
>   - Drop the patches that have already been pushed to kvm/queue.
>   - Drop two selftest changes that had snuck in via "git commit -a".
>   - Add a patch to assert that mmu_notifier_count is elevated when
>     .change_pte() runs. [Paolo]
>   - Split out moving KVM_MMU_(UN)LOCK() to __kvm_handle_hva_range() to a
>     separate patch.  Opted not to squash it with the introduction of the
>     common hva walkers (patch 02), as that prevented sharing code between
>     the old and new APIs. [Paolo]
>   - Tweak the comment in kvm_vm_destroy() above the smashing of the new
>     slots lock. [Paolo]
>   - Make mmu_notifier_slots_lock unconditional to avoid #ifdefs. [Paolo]
> 
> v1:
>   - https://lkml.kernel.org/r/20210326021957.1424875-1-seanjc@google.com
> 
> Sean Christopherson (10):
>    KVM: Assert that notifier count is elevated in .change_pte()
>    KVM: Move x86's MMU notifier memslot walkers to generic code
>    KVM: arm64: Convert to the gfn-based MMU notifier callbacks
>    KVM: MIPS/MMU: Convert to the gfn-based MMU notifier callbacks
>    KVM: PPC: Convert to the gfn-based MMU notifier callbacks
>    KVM: Kill off the old hva-based MMU notifier callbacks
>    KVM: Move MMU notifier's mmu_lock acquisition into common helper
>    KVM: Take mmu_lock when handling MMU notifier iff the hva hits a
>      memslot
>    KVM: Don't take mmu_lock for range invalidation unless necessary
>    KVM: x86/mmu: Allow yielding during MMU notifier unmap/zap, if
>      possible
> 
>   arch/arm64/kvm/mmu.c                   | 117 +++------
>   arch/mips/kvm/mmu.c                    |  97 ++------
>   arch/powerpc/include/asm/kvm_book3s.h  |  12 +-
>   arch/powerpc/include/asm/kvm_ppc.h     |   9 +-
>   arch/powerpc/kvm/book3s.c              |  18 +-
>   arch/powerpc/kvm/book3s.h              |  10 +-
>   arch/powerpc/kvm/book3s_64_mmu_hv.c    |  98 ++------
>   arch/powerpc/kvm/book3s_64_mmu_radix.c |  25 +-
>   arch/powerpc/kvm/book3s_hv.c           |  12 +-
>   arch/powerpc/kvm/book3s_pr.c           |  56 ++---
>   arch/powerpc/kvm/e500_mmu_host.c       |  27 +-
>   arch/x86/kvm/mmu/mmu.c                 | 127 ++++------
>   arch/x86/kvm/mmu/tdp_mmu.c             | 245 +++++++------------
>   arch/x86/kvm/mmu/tdp_mmu.h             |  14 +-
>   include/linux/kvm_host.h               |  22 +-
>   virt/kvm/kvm_main.c                    | 325 +++++++++++++++++++------
>   16 files changed, 552 insertions(+), 662 deletions(-)
> 

For MIPS, I am going to post a series that simplifies TLB flushing 
further.  I applied it, and rebased this one on top, to 
kvm/mmu-notifier-queue.

Architecture maintainers, please look at the branch and review/test/ack 
your parts.

Thanks!

Paolo

