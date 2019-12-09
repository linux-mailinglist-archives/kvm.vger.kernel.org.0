Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800BB11707C
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 16:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfLIPbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 10:31:22 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40053 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726491AbfLIPbU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Dec 2019 10:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575905478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hcabZguFWz6HawJeliIVVxXf5dnNiReFkMH/8uh3XWg=;
        b=dc5wag12W8djR99Rn0+L4pMEJ9rze+e/5q3JKlPZLySbv1ZPZfHXRc8LSK/kwRWAg2Mtl0
        bLhussneuuAJoJ/If0/hYurG//ubFgFl0PgHfjCn4hzgW/DFuYuRyvjBw7qKGZiBJedu9g
        C26Q67YlgUNokawVkXuJJ82JaHk8JXc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-Wrmw2mwcPPiO1huGIo6q_Q-1; Mon, 09 Dec 2019 10:31:16 -0500
Received: by mail-wm1-f72.google.com with SMTP id f11so564271wmh.1
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 07:31:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hcabZguFWz6HawJeliIVVxXf5dnNiReFkMH/8uh3XWg=;
        b=rPnxUgXfs3G0neFXeqDeChWm1xJEiqUQMg8mMdBt44A213YnqBS1Ze2tnzh8+ce2Lg
         a/4KHOab0hZ+aIEVpg8mWp17uFiNdyXbFR0/9MWEpHKKZ+2jp5RpLa8jEafVIL5fMBqS
         61+323VK2rp2vsfilCpJ+qEpZaffZ35jggi6dNaH/R4zgSXUP2zHKX3nqCkqpcCprEOn
         nYSeh8KAJe6zjoaZ+ghII2cKRt9fLEaCvY2xroQw+td1RVumu+wM+KB81LPdH0WTdU1a
         UlAw01ms6PrJsOt15kEyTLZN3DgET4faSfaXfBTr+shK5PD/z+iDKekngsbNLVKhmoPI
         pHgQ==
X-Gm-Message-State: APjAAAVl3HvHvFzR0vBUdv50q5mL8niogNnOye5T8+T4SSIY7d3UF/Tb
        EG4sacigZFXiG+sym4gWXuqaEh0+Dp5J1e2F7NLjXQtnAq/FB9in8y2G5662gFCeOtVY1kmKF+L
        22emcKMqxpSvg
X-Received: by 2002:a05:600c:2101:: with SMTP id u1mr25385269wml.43.1575905475309;
        Mon, 09 Dec 2019 07:31:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqwUgHCTV4jCZ380MrUbnKulMEgtMrmyFd2pt+SGYutioQNOgnVxofbmjebn8P2X7z15AWUA2g==
X-Received: by 2002:a05:600c:2101:: with SMTP id u1mr25385231wml.43.1575905474987;
        Mon, 09 Dec 2019 07:31:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id s10sm27833316wrw.12.2019.12.09.07.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 07:31:14 -0800 (PST)
Subject: Re: [PATCH 00/16] KVM: x86: MMU page fault clean-up
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191206235729.29263-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3b1d2093-eb1f-2c80-4104-3b33a5d764cc@redhat.com>
Date:   Mon, 9 Dec 2019 16:31:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191206235729.29263-1-sean.j.christopherson@intel.com>
Content-Language: en-US
X-MC-Unique: Wrmw2mwcPPiO1huGIo6q_Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/19 00:57, Sean Christopherson wrote:
> The original purpose of this series was to call thp_adjust() from
> __direct_map() and FNAME(fetch) to eliminate a page refcounting quirk[*].
> Before doing that, I wanted to clean up the large page handling so that
> the map/fetch funtions weren't being passed multiple booleans that tracked
> the same basic info.  While trying to decipher all the the interactions,
> I stumbled across a handful of fun things:
> 
>   - 32-bit KVM w/ TDP is completely broken with respect to 64-bit GPAs due
>     to the page fault handlers and all related flows dropping bits 63:32
>     of the GPA.  As a result, KVM inserts the wrong GPA and the guest hangs
>     because it generates EPT/NPT faults until it's killed.
> 
>   - The TDP and non-paging page fault flows are identical except for
>     one-off constraints on guest page size.
> 
>   - The !VALID_PAGE(root_hpa) checks in the page fault flows are bogus.
>     They were added a few years ago to "fix" a nVMX bug and are no longer
>     needed now that nVMX is in much better shape.
> 
> Patch 1 fixes the 32-bit KVM w/ TDP issue.  More details below.
> 
> Patches 2-12 are 99% refactoring to merge TDP and non-paging page fault
> handling, and to do the thp_adjust() move.  These are basically nops from
> a functional perspective.  There are technically functional changes in a
> few patches, but they are very superficial and in theory won't be
> observable in normal usage.
> 
> Patches 13-16 add WARNs on the !VALID_PAGE(root_hpa) checks to make it
> clear that root_hpa is expected to be valid when handling page faults,
> e.g. for the longest time I thought KVM relied on the checks in map/fetch
> to correctly handle kvm_mmu_zap_all().
> 
> 
> 32-bit KVM w/ TDP:
> 
> I marked this patch for stable because it's obviously a bug fix, but I'm
> entirely not sure we want to backport the fix.  Obviously no userspace VMM
> is actually exposing 64-bit GPAs to its guests, i.e. odds are this won't
> actually fix any real world use cases.  And, the scope of the changes are
> likely going to make backporting a pain.  But, on the other hand, if it's
> not backported then future bug fixes in related code are likely to
> conflict, and it does fix the case where a buggy guest kernel accesses a
> non-existent 64-bit GPA (crashes instead of hanging indefinitely).
> 
> I'm also not confident I found all the cases where KVM is truncating the
> GPA.  AFAIK, 32-bit Qemu simply doesn't support 64-bit GPAs.  To confirm
> the bug and verify the fix, I hacked KVM and the guest kernel to generate
> 64-bit GPAs when remapping MMIO, which covers a tiny fragment of KVM.

Queued, thanks!

Paolo

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fa46fbed60013..49a59bcb32117 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5737,7 +5737,7 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
>         vcpu->run->mmio.len = min(8u, vcpu->mmio_fragments[0].len);
>         vcpu->run->mmio.is_write = vcpu->mmio_is_write = ops->write;
>         vcpu->run->exit_reason = KVM_EXIT_MMIO;
> -       vcpu->run->mmio.phys_addr = gpa;
> +       vcpu->run->mmio.phys_addr = gpa & 0xffffffffull;
>  
>         return ops->read_write_exit_mmio(vcpu, gpa, val, bytes);
>  }
> 
> 
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index b9c78f3bcd673..e22f254987bea 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -184,7 +184,10 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>         if (kernel_map_sync_memtype(phys_addr, size, pcm))
>                 goto err_free_area;
>  
> -       if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot))
> +       BUG_ON(!boot_cpu_data.x86_phys_bits);
> +
> +       if (ioremap_page_range(vaddr, vaddr + size,
> +                              phys_addr | BIT_ULL(boot_cpu_data.x86_phys_bits - 1), prot))
>                 goto err_free_area;
>  
>         ret_addr = (void __iomem *) (vaddr + offset);
> 
> [*] https://lkml.kernel.org/r/20191126174603.GB22233@linux.intel.com
> 
> Sean Christopherson (16):
>   KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit KVM
>   KVM: x86/mmu: Move definition of make_mmu_pages_available() up
>   KVM: x86/mmu: Fold nonpaging_map() into nonpaging_page_fault()
>   KVM: x86/mmu: Move nonpaging_page_fault() below try_async_pf()
>   KVM: x86/mmu: Refactor handling of cache consistency with TDP
>   KVM: x86/mmu: Refactor the per-slot level calculation in
>     mapping_level()
>   KVM: x86/mmu: Refactor handling of forced 4k pages in page faults
>   KVM: x86/mmu: Incorporate guest's page level into max level for shadow
>     MMU
>   KVM: x86/mmu: Persist gfn_lpage_is_disallowed() to max_level
>   KVM: x86/mmu: Rename lpage_disallowed to account_disallowed_nx_lpage
>   KVM: x86/mmu: Consolidate tdp_page_fault() and nonpaging_page_fault()
>   KVM: x86/mmu: Move transparent_hugepage_adjust() above __direct_map()
>   KVM: x86/mmu: Move calls to thp_adjust() down a level
>   KVM: x86/mmu: Move root_hpa validity checks to top of page fault
>     handler
>   KVM: x86/mmu: WARN on an invalid root_hpa
>   KVM: x86/mmu: WARN if root_hpa is invalid when handling a page fault
> 
>  arch/x86/include/asm/kvm_host.h |   8 +-
>  arch/x86/kvm/mmu/mmu.c          | 438 ++++++++++++++------------------
>  arch/x86/kvm/mmu/paging_tmpl.h  |  58 +++--
>  arch/x86/kvm/mmutrace.h         |  12 +-
>  arch/x86/kvm/x86.c              |  40 ++-
>  arch/x86/kvm/x86.h              |   2 +-
>  include/linux/kvm_host.h        |   6 +-
>  virt/kvm/async_pf.c             |  10 +-
>  8 files changed, 259 insertions(+), 315 deletions(-)
> 

