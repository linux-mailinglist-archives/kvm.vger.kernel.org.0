Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B08C3D5A04
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 15:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhGZMZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 08:25:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52551 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232334AbhGZMZ3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 08:25:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627304757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QeDe60GoL1uNmmVH11pVUYwZoT+qXOzBK4hGeoIKDq4=;
        b=fMLKv2XY60dDb3bffQLf28+ILT7OIrzeZIChoYcusoqTZjvHQgKjC4H+4fS9M7fvZR4Fi2
        lRk/90wLjFC1GxB9Yg1sBlocOK5wsmf9x7NVGSxAr+AkseC+i859pVfTcXPccNH8QlWUhO
        GsfaILgpMwhhezNTdn/4ByyayhGujHw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-22btwFQsPD-TBcPMtuLftQ-1; Mon, 26 Jul 2021 09:05:55 -0400
X-MC-Unique: 22btwFQsPD-TBcPMtuLftQ-1
Received: by mail-ed1-f72.google.com with SMTP id c1-20020aa7df010000b02903bb5c6f746eso2351741edy.10
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 06:05:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QeDe60GoL1uNmmVH11pVUYwZoT+qXOzBK4hGeoIKDq4=;
        b=JHiXgK0azxqLeZ+TEWaPO+7fFeupmgRSfNCMRTuOoDyyGeuP8ZPNaqdIiInM7Bmqbs
         Jq7Ed+orfub/O2j75mki1lz01ZbB5uoVW8ezwrRNNm6V6eK1e48IJnTPlW5vm8K4v/WA
         4cHU1Ljj66IPR4q/IRD9hjJ6HTrWx1lYbkRh49lda0eP7gK1mkMlWG1utdhT7MPZxIf9
         n9W4+el8D86F6ENlaHRGtRjQwQJXQrgi/5Gb0zTqwu0Fnfcp7XUlntA0qnYeS2JCJVcD
         blgRmbU3hglc027Cagb5TUmcZq4/f/zyZsn+7AWgCje2RstNS/dpTrbA6sJuiR/PEQor
         k7Cg==
X-Gm-Message-State: AOAM530D04ngRcy5U1QJvQnuUlabef76NpeZQXoOcX/uNUvvC5Y41pse
        Ff9RFMcperOzILhufpCPo6XsQ/8yIo6fz/sVKRZLnDZyLi8FkTvlrxAXCsMbFpYyAUcee+P/a+b
        Ij1Mp3kmBU/ru
X-Received: by 2002:a17:906:580c:: with SMTP id m12mr14800452ejq.32.1627304754578;
        Mon, 26 Jul 2021 06:05:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwz9OQwUrcpCTK2UcD2jrxFbQjK6NzwLSZzcRL0LNAk0NsGdCDRW4Vict6FUB1TdEicPQPqUA==
X-Received: by 2002:a17:906:580c:: with SMTP id m12mr14800430ejq.32.1627304754349;
        Mon, 26 Jul 2021 06:05:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id jy17sm733064ejc.112.2021.07.26.06.05.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 06:05:53 -0700 (PDT)
Subject: Re: [PATCH v2 0/9] KVM: X86: Some light optimizations on rmap logic
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210625153214.43106-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6400f7db-3194-ac9b-3116-44d1201564eb@redhat.com>
Date:   Mon, 26 Jul 2021 15:05:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625153214.43106-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/21 17:32, Peter Xu wrote:
> v2:
> - Rebased to kvm-queue since I found quite a few conflicts already
> - Add an example into patch commit message of "KVM: X86: Introduce
>    mmu_rmaps_stat per-vm debugfs file"
> - Cleanup more places in patch "KVM: X86: Optimize pte_list_desc with per-array
>    counter" and squashed
> 
> All things started from patch 1, which introduced a new statistic to keep "max
> rmap entry count per vm".  At that time I was just curious about how many rmap
> is there normally for a guest, and it surprised me a bit.
> 
> For TDP mappings it's all fine as mostly rmap of a page is either 0 or 1
> depending on faulted or not.  It turns out with EPT=N there seems to be a huge
> number of pages that can have tens or hundreds of rmap entries even for an idle
> guest.  Then I continued with the rest.
> 
> To understand better on "how much of those pages", I did patch 2-6 which
> introduced the idea of per-arch per-vm debugfs nodes, and added a debug file to
> do statistics for rmap, which is similar to kvm_arch_create_vcpu_debugfs() but
> for vm not vcpu.
> 
> I did notice this should be the clean approach as I also see other archs
> randomly create some per-vm debugfs nodes there:
> 
> ---8<---
> *** arch/arm64/kvm/vgic/vgic-debug.c:
> vgic_debug_init[274]           debugfs_create_file("vgic-state", 0444, kvm->debugfs_dentry, kvm,
> 
> *** arch/powerpc/kvm/book3s_64_mmu_hv.c:
> kvmppc_mmu_debugfs_init[2115]  debugfs_create_file("htab", 0400, kvm->arch.debugfs_dir, kvm,
> 
> *** arch/powerpc/kvm/book3s_64_mmu_radix.c:
> kvmhv_radix_debugfs_init[1434] debugfs_create_file("radix", 0400, kvm->arch.debugfs_dir, kvm,
> 
> *** arch/powerpc/kvm/book3s_hv.c:
> debugfs_vcpu_init[2395]        debugfs_create_file("timings", 0444, vcpu->arch.debugfs_dir, vcpu,
> 
> *** arch/powerpc/kvm/book3s_xics.c:
> xics_debugfs_init[1027]        xics->dentry = debugfs_create_file(name, 0444, powerpc_debugfs_root,
> 
> *** arch/powerpc/kvm/book3s_xive.c:
> xive_debugfs_init[2236]        xive->dentry = debugfs_create_file(name, S_IRUGO, powerpc_debugfs_root,
> 
> *** arch/powerpc/kvm/timing.c:
> kvmppc_create_vcpu_debugfs[214] debugfs_file = debugfs_create_file(dbg_fname, 0666, kvm_debugfs_dir,
> ---8<---
> 
> PPC even has its own per-vm dir for that.  I think if patch 2-6 can be
> considered to be accepted then the next thing to consider is to merge all these
> usages to be under the same existing per-vm dentry with their per-arch hooks
> introduced.
> 
> The last 3 patches (patch 7-9) are a few optimizations of existing rmap logic.
> The major test case I used is rmap_fork [1], however it's not really the ideal
> one to show their effect for sure as that test I wrote covers both
> rmap_add/remove, while I don't have good idea on optimizing rmap_remove without
> changing the array structure or adding much overhead (e.g. sort the array, or
> making a tree-like structure somehow to replace the array list).  However it
> already shows some benefit with those changes, so I post them out.
> 
> Applying patch 7-8 will bring a summary of 38% perf boost when I fork 500
> childs with the test I used.  Didn't run perf test on patch 9.  More in the
> commit log.
> 
> Please review, thanks.
> 
> [1] https://github.com/xzpeter/clibs/commit/825436f825453de2ea5aaee4bdb1c92281efe5b3
> 
> Peter Xu (9):
>    KVM: X86: Add per-vm stat for max rmap list size
>    KVM: Introduce kvm_get_kvm_safe()
>    KVM: Allow to have arch-specific per-vm debugfs files
>    KVM: X86: Introduce pte_list_count() helper
>    KVM: X86: Introduce kvm_mmu_slot_lpages() helpers
>    KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs file
>    KVM: X86: MMU: Tune PTE_LIST_EXT to be bigger
>    KVM: X86: Optimize pte_list_desc with per-array counter
>    KVM: X86: Optimize zapping rmap
> 
>   arch/x86/include/asm/kvm_host.h |   1 +
>   arch/x86/kvm/mmu/mmu.c          |  97 +++++++++++++++++------
>   arch/x86/kvm/mmu/mmu_internal.h |   1 +
>   arch/x86/kvm/x86.c              | 131 +++++++++++++++++++++++++++++++-
>   include/linux/kvm_host.h        |   2 +
>   virt/kvm/kvm_main.c             |  37 +++++++--
>   6 files changed, 235 insertions(+), 34 deletions(-)
> 

Looks good, thanks.  I queued it, but for now I have left out the 
statistics part; I would like to check the histogram patches too first.

Paolo

