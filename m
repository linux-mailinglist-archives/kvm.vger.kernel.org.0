Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE1D371770
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 17:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhECPEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 11:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhECPEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 11:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60A0561364
        for <kvm@vger.kernel.org>; Mon,  3 May 2021 15:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620054235;
        bh=ln+8BofV7Gh4bD8EraABi30+kOtgmTS6KtlBAWP07u8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=p/pcCk1Owl9SAKIf4zZn16m79oUf5KJA8G6Tm/q0sT7O0rGMXwetz1Q8eQEI/CBfQ
         DOHo2vsd6EMNYMK/jba+J2xzuHo5DrOIkkoBFp+DY2TUUvFRJcysALBk5b6hw/xvb0
         7GXm/9gB737FdWTk7h6mP6l84J3Za7xx8ukbniXhVWGhdMJsGIlAv8Z+Lf4S0DORdQ
         cGtN9osHnMAK6lHsSzZ+qkRr7YEYtkned3Cj5xIazsMB+dMnvqeaTzrU5Mv7EkJx27
         9XgkVxiaxpvzSmwfIzdsBqdMfZKO0w+KZ4UQOMe0rSaWPJbGIwiK2gT2zrdLyrO4gX
         jGITTz2nTmFZw==
Received: by mail-ed1-f42.google.com with SMTP id e7so6621896edu.10
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 08:03:55 -0700 (PDT)
X-Gm-Message-State: AOAM531YdkYjx9a9bO/wl5TcuajgGkgR5Z5jA5E40SkRfrjkkVmtBlXJ
        5kn8iywRZxrPQrGawLc+gDAoNtfJXlA5/rN+akEFIQ==
X-Google-Smtp-Source: ABdhPJx3QTOhuJGr019PmYgMDrSRVccEeRhDKz9yDKKZ/VSDJuBePqFTTIy/Xno/zToUViVjF4VIL/WxQ0HBM99xFro=
X-Received: by 2002:a05:6402:17b0:: with SMTP id j16mr20168200edy.97.1620054233726;
 Mon, 03 May 2021 08:03:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210430123822.13825-1-brijesh.singh@amd.com> <20210430123822.13825-11-brijesh.singh@amd.com>
 <c3950468-af35-a46d-2d50-238245ed37b3@intel.com>
In-Reply-To: <c3950468-af35-a46d-2d50-238245ed37b3@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 3 May 2021 08:03:42 -0700
X-Gmail-Original-Message-ID: <CALCETrVEyBaG41gS4ntu6ikJqeiWs2gMuqfo_Yk0cdgpHyN9Dg@mail.gmail.com>
Message-ID: <CALCETrVEyBaG41gS4ntu6ikJqeiWs2gMuqfo_Yk0cdgpHyN9Dg@mail.gmail.com>
Subject: Re: [PATCH Part2 RFC v2 10/37] x86/fault: Add support to handle the
 RMP fault for kernel address
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 3, 2021 at 7:44 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 4/30/21 5:37 AM, Brijesh Singh wrote:
> > When SEV-SNP is enabled globally, a write from the host goes through the
> > RMP check. When the host writes to pages, hardware checks the following
> > conditions at the end of page walk:
> >
> > 1. Assigned bit in the RMP table is zero (i.e page is shared).
> > 2. If the page table entry that gives the sPA indicates that the target
> >    page size is a large page, then all RMP entries for the 4KB
> >    constituting pages of the target must have the assigned bit 0.
> > 3. Immutable bit in the RMP table is not zero.
> >
> > The hardware will raise page fault if one of the above conditions is not
> > met. A host should not encounter the RMP fault in normal execution, but
> > a malicious guest could trick the hypervisor into it. e.g., a guest does
> > not make the GHCB page shared, on #VMGEXIT, the hypervisor will attempt
> > to write to GHCB page.
>
> Is that the only case which is left?  If so, why don't you simply split
> the direct map for GHCB pages before giving them to the guest?  Or, map
> them with vmap() so that the mapping is always 4k?

If I read Brijesh's message right, this isn't about 4k.  It's about
the guest violating host expectations about the page type.

I need to go and do a full read of all the relevant specs, but I think
there's an analogous situation in TDX: if the host touches guest
private memory, the TDX hardware will get extremely angry (more so
than AMD hardware).  And, if I have understood this patch correctly,
it's fudging around the underlying bug by intentionally screwing up
the RMP contents to avoid a page fault.  Assuming I've understood
everything correctly (a big if!), then I think this is backwards.  The
host kernel should not ever access guest memory without a plan in
place to handle failure.  We need real accessors, along the lines of
copy_from_guest() and copy_to_guest().
