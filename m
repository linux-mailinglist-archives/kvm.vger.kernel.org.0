Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A175C3717AF
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 17:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhECPQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 11:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhECPQz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 11:16:55 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14D1C06174A
        for <kvm@vger.kernel.org>; Mon,  3 May 2021 08:16:01 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id u13so4003750edd.3
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 08:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7l/LQ7XahwkZsKB4ahSZ6Zz5k0dtmltYbxNaS4zuBFo=;
        b=OjP4Ha4tmYLsEphRrrum5sDZ8uIC0TGPJQ1wKN1StWM/VnURp7+zG7+W8OVC0jQgtg
         YvSzGzGtwSAlALl/o7jHb4w4qHjkD4XkgLAsRW1cMVqW+9e3vKlAD7fNvKoKgmlzX3ei
         LU803YZOhiAMm7K1v4HWN9zbhfVMbuNPyCiwl89DPFh7vQPGtiU+dQFA5mRn1yhuMBlp
         mxsDBo7qb6mTmXRwwKrFr32B5xESzjApOxsoPNpwUHu6U8qjJ/Fh3fthTTHXs+coEbuc
         7NhsQU/MmXLxyL2+FzgRPGuwF1R9nU2hV+R5fG4BU8gRx4QOkrY0w7qCZ6AKAxXx09wR
         ceRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7l/LQ7XahwkZsKB4ahSZ6Zz5k0dtmltYbxNaS4zuBFo=;
        b=J/x7sTVlnIFONF+CUL7/NZgBeJJ8dG/PeSR0+8ElqgjBsnnmZd4pcSWB844aW80C4G
         L/dFa/6hS3ktU38nD/ScSEAgCGUyyHDVXlXpFb0rwfgiVveohKdoqq1PaoyiQbjdPFE0
         xQUyf09vlKtlCwfAdMu/MGBindX8FnKgSAWuYpfUkPiNXdbifJ4NmKqIcSuDFg90iNCx
         1JdZAEh4W/ZRwIn0Ki0DZDcHTPopFNT5EkyeCBrUmqRWrGtBr/bFE+6hX3sj72Vnl7VR
         zPZ0gntkzYXl0bKJks1y72QDtFz8No9OwsDkLSA1H0PK4w4knUuGhKDLVr25H55869I0
         7JcQ==
X-Gm-Message-State: AOAM5332bl9X8dJGfsXmbuT61kZez62eiiBybmle2H9PFbiUFlG8BXIV
        +ANgYjVYx5myi0AAzzZKetK8JBTTrrx6nGhJ3FYpAw==
X-Google-Smtp-Source: ABdhPJyy5EHT8aqHafp4q0/YB60ZPgtuU1OTdyGOTpMdM0pmxtWmLQ5k6UCNNfsqf/gQG4LMfnvRrXBOW52J+QbW764=
X-Received: by 2002:a05:6402:3063:: with SMTP id bs3mr20835674edb.84.1620054960447;
 Mon, 03 May 2021 08:16:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210430123822.13825-1-brijesh.singh@amd.com> <20210430123822.13825-9-brijesh.singh@amd.com>
In-Reply-To: <20210430123822.13825-9-brijesh.singh@amd.com>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Mon, 3 May 2021 08:15:49 -0700
Message-ID: <CALCETrXsUW3S_9ZUPXT5HEv_ki2VxEUQMe-uzerG1xnbcgYNtw@mail.gmail.com>
Subject: Re: [PATCH Part2 RFC v2 08/37] x86/sev: Split the physmap when adding
 the page in RMP table
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 5:39 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
> The integrity guarantee of SEV-SNP is enforced through the RMP table.
> The RMP is used in conjuntion with standard x86 and IOMMU page
> tables to enforce memory restrictions and page access rights. The
> RMP is indexed by system physical address, and is checked at the end
> of CPU and IOMMU table walks. The RMP check is enforced as soon as
> SEV-SNP is enabled globally in the system. Not every memory access
> requires an RMP check. In particular, the read accesses from the
> hypervisor do not require RMP checks because the data confidentiality
> is already protected via memory encryption. When hardware encounters
> an RMP checks failure, it raise a page-fault exception. The RMP bit in
> fault error code can be used to determine if the fault was due to an
> RMP checks failure.
>
> A write from the hypervisor goes through the RMP checks. When the
> hypervisor writes to pages, hardware checks to ensures that the assigned
> bit in the RMP is zero (i.e page is shared). If the page table entry that
> gives the sPA indicates that the target page size is a large page, then
> all RMP entries for the 4KB constituting pages of the target must have the
> assigned bit 0. If one of entry does not have assigned bit 0 then hardware
> will raise an RMP violation. To resolve it, split the page table entry
> leading to target page into 4K.
>
> This poses a challenge in the Linux memory model. The Linux kernel
> creates a direct mapping of all the physical memory -- referred to as
> the physmap. The physmap may contain a valid mapping of guest owned pages.
> During the page table walk, the host access may get into the situation where
> one of the pages within the large page is owned by the guest (i.e assigned
> bit is set in RMP). A write to a non-guest within the large page will
> raise an RMP violation. To workaround it, call set_memory_4k() to split
> the physmap before adding the page in the RMP table. This ensures that the
> pages added in the RMP table are used as 4K in the physmap.
>
> The spliting of the physmap is a temporary solution until the kernel page
> fault handler is improved to split the kernel address on demand.

Not happening.  The pages to be split might be critical to fault
handling, e.g. stack, GDT, IDT, etc.

How much performance do we get back if we add a requirement that only
2M pages (hugetlbfs, etc) may be used for private guest memory?
