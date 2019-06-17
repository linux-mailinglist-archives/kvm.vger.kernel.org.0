Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1385E487BF
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 17:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfFQPq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 11:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbfFQPq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 11:46:27 -0400
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 220212084A
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 15:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560786385;
        bh=F3uEyDN+Xs7L0Di68zDs4MEi1Cbu2UWQXut0pG0xWMs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wa35xolYW4YasUKQT8EwzT6szfhNdHDv0tXqCBbVczs42MXSBCsyqEPKC57euY3wj
         xTlfaENabxyxNZ4xaXCX4kGyw7z94wbPMr9w+hYWZLZqYfzBKsWgmhZHcCSZ61Sbjv
         HM3+iiGzq5mOAoMIYcKW89sL9P2A2CmPt30I6s04=
Received: by mail-wm1-f53.google.com with SMTP id u8so9657212wmm.1
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 08:46:25 -0700 (PDT)
X-Gm-Message-State: APjAAAUaTYWn+0O61RC23Eg7ZmkJUeOcluI3VbW6hF3FaovwVGxn3Ilj
        c/cITZTJmBTYXETcouzYQOBeHJCfh+aAtzPrQ/MpUA==
X-Google-Smtp-Source: APXvYqyrDpnzTXcyPRzw7xdKgDkoK9TPRpUT8p/03uOhfg+q5WxYbogJ4WqJXyfqu9bcckbw7dHL/p31ug/zjQinPwo=
X-Received: by 2002:a1c:a942:: with SMTP id s63mr19448598wme.76.1560786383736;
 Mon, 17 Jun 2019 08:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-46-kirill.shutemov@linux.intel.com> <CALCETrVCdp4LyCasvGkc0+S6fvS+dna=_ytLdDPuD2xeAr5c-w@mail.gmail.com>
 <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com>
In-Reply-To: <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 17 Jun 2019 08:46:12 -0700
X-Gmail-Original-Message-ID: <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
Message-ID: <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
Subject: Re: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call for MKTME
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Linux-MM <linux-mm@kvack.org>, kvm list <kvm@vger.kernel.org>,
        keyrings@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 17, 2019 at 8:28 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 6/17/19 8:07 AM, Andy Lutomirski wrote:
> > I still find it bizarre that this is conflated with mprotect().
>
> This needs to be in the changelog.  But, for better or worse, it's
> following the mprotect_pkey() pattern.
>
> Other than the obvious "set the key on this memory", we're looking for
> two other properties: atomicity (ensuring there is no transient state
> where the memory is usable without the desired properties) and that it
> is usable on existing allocations.
>
> For atomicity, we have a model where we can allocate things with
> PROT_NONE, then do mprotect_pkey() and mprotect_encrypt() (plus any
> future features), then the last mprotect_*() call takes us from
> PROT_NONE to the desired end permisions.  We could just require a plain
> old mprotect() to do that instead of embedding mprotect()-like behavior
> in these, of course, but that isn't the path we're on at the moment with
> mprotect_pkey().
>
> So, for this series it's just a matter of whether we do this:
>
>         ptr = mmap(..., PROT_NONE);
>         mprotect_pkey(protect_key, ptr, PROT_NONE);
>         mprotect_encrypt(encr_key, ptr, PROT_READ|PROT_WRITE);
>         // good to go
>
> or this:
>
>         ptr = mmap(..., PROT_NONE);
>         mprotect_pkey(protect_key, ptr, PROT_NONE);
>         sys_encrypt(key, ptr);
>         mprotect(ptr, PROT_READ|PROT_WRITE);
>         // good to go
>
> I actually don't care all that much which one we end up with.  It's not
> like the extra syscall in the second options means much.

The benefit of the second one is that, if sys_encrypt is absent, it
just works.  In the first model, programs need a fallback because
they'll segfault of mprotect_encrypt() gets ENOSYS.

>
> > This is part of why I much prefer the idea of making this style of
> > MKTME a driver or some other non-intrusive interface.  Then, once
> > everyone gets tired of it, the driver can just get turned off with no
> > side effects.
>
> I like the concept, but not where it leads.  I'd call it the 'hugetlbfs
> approach". :)  Hugetblfs certainly go us huge pages, but it's continued
> to be a parallel set of code with parallel bugs and parallel
> implementations of many VM features.  It's not that you can't implement
> new things on hugetlbfs, it's that you *need* to.  You never get them
> for free.

Fair enough, but...

>
> For instance, if we do a driver, how do we get large pages?  How do we
> swap/reclaim the pages?  How do we do NUMA affinity?

Those all make sense.

>  How do we
> eventually stack it on top of persistent memory filesystems or Device
> DAX?

How do we stack anonymous memory on top of persistent memory or Device
DAX?  I'm confused.

Just to throw this out there, what if we had a new device /dev/xpfo
and MKTME were one of its features.  You open /dev/xpfo, optionally do
an ioctl to set a key, and them map it.  The pages you get are
unmapped entirely from the direct map, and you get a PFNMAP VMA with
all its limitations.  This seems much more useful -- it's limited, but
it's limited *because the kernel can't accidentally read it*.

I think that, in the long run, we're going to have to either expand
the core mm's concept of what "memory" is or just have a whole
parallel set of mechanisms for memory that doesn't work like memory.
We're already accumulating a set of things that are backed by memory
but aren't usable as memory. SGX EPC pages and SEV pages come to mind.
They are faster when they're in big contiguous chunks (well, not SGX
AFAIK, but maybe some day), they have NUMA node affinity, and they
show up in page tables, but the hardware restricts who can read and
write them.  If Intel isn't planning to do something like this with
the MKTME hardware, I'll eat my hat.

I expect that some day normal memory will  be able to be repurposed as
SGX pages on the fly, and that will also look a lot more like SEV or
XPFO than like the this model of MKTME.

So, if we upstream MKTME as anonymous memory with a magic config
syscall, I predict that, in a few years, it will be end up inheriting
all downsides of both approaches with few of the upsides.  Programs
like QEMU will need to learn to manipulate pages that can't be
accessed outside the VM without special VM buy-in, so the fact that
MKTME pages are fully functional and can be GUP-ed won't be very
useful.  And the VM will learn about all these things, but MKTME won't
really fit in.

And, one of these days, someone will come up with a version of XPFO
that could actually be upstreamed, and it seems entirely plausible
that it will be totally incompatible with MKTME-as-anonymous-memory
and that users of MKTME will actually get *worse* security.
