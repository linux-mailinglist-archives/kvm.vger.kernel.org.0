Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA97F49634
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 02:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfFRAPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 20:15:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbfFRAPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 20:15:18 -0400
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5563E2182B
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 00:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560816917;
        bh=bQszpKKtRqay8BXy5xoZqczKSmcgkXxEdS7CWQ4wvic=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KufUXcCHguV/MZBfdJ1UgPyRTW3eCKtSrfxLxy9i+UBAiIazGMrltN+iFYxFVl62s
         IdEC552KDjlEdIDwV6nsWtxB0Hz2z7RrknFPD/knhdNuEJYm9q3wE83tea6VtQK6hq
         voYk6nrOcb65/pVTvsckV8vOkNjw4TXXRvXpe+tA=
Received: by mail-wr1-f46.google.com with SMTP id p13so11877169wru.10
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 17:15:17 -0700 (PDT)
X-Gm-Message-State: APjAAAW0FqzH2CLFVYQ/DKOLuGuXZu2uKPLE347CXmh7zhWoWuSLClDa
        fFtkY2zpARFswdlHZFuy3Q7YMtfup2SXacCltpRgCA==
X-Google-Smtp-Source: APXvYqyqF7SW2mJlRLiMDDtDqtXekqP0bm1adp9rauvRGsQNnQx5hhHuQU1Yq5NSDMx21e7L39/tBWT38jN3NyvidlI=
X-Received: by 2002:adf:f28a:: with SMTP id k10mr11743806wro.343.1560816915741;
 Mon, 17 Jun 2019 17:15:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-46-kirill.shutemov@linux.intel.com> <CALCETrVCdp4LyCasvGkc0+S6fvS+dna=_ytLdDPuD2xeAr5c-w@mail.gmail.com>
 <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com> <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
 <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com> <CALCETrWFXSndmPH0OH4DVVrAyPEeKUUfNwo_9CxO-3xy9awq0g@mail.gmail.com>
 <1560816342.5187.63.camel@linux.intel.com>
In-Reply-To: <1560816342.5187.63.camel@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 17 Jun 2019 17:15:04 -0700
X-Gmail-Original-Message-ID: <CALCETrVcrPYUUVdgnPZojhJLgEhKv5gNqnT6u2nFVBAZprcs5g@mail.gmail.com>
Message-ID: <CALCETrVcrPYUUVdgnPZojhJLgEhKv5gNqnT6u2nFVBAZprcs5g@mail.gmail.com>
Subject: Re: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call for MKTME
To:     Kai Huang <kai.huang@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Linux-MM <linux-mm@kvack.org>, kvm list <kvm@vger.kernel.org>,
        keyrings@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 17, 2019 at 5:05 PM Kai Huang <kai.huang@linux.intel.com> wrote:
>
> On Mon, 2019-06-17 at 12:12 -0700, Andy Lutomirski wrote:
> > On Mon, Jun 17, 2019 at 11:37 AM Dave Hansen <dave.hansen@intel.com> wrote:
> > >
> > > Tom Lendacky, could you take a look down in the message to the talk of
> > > SEV?  I want to make sure I'm not misrepresenting what it does today.
> > > ...
> > >
> > >
> > > > > I actually don't care all that much which one we end up with.  It's not
> > > > > like the extra syscall in the second options means much.
> > > >
> > > > The benefit of the second one is that, if sys_encrypt is absent, it
> > > > just works.  In the first model, programs need a fallback because
> > > > they'll segfault of mprotect_encrypt() gets ENOSYS.
> > >
> > > Well, by the time they get here, they would have already had to allocate
> > > and set up the encryption key.  I don't think this would really be the
> > > "normal" malloc() path, for instance.
> > >
> > > > >  How do we
> > > > > eventually stack it on top of persistent memory filesystems or Device
> > > > > DAX?
> > > >
> > > > How do we stack anonymous memory on top of persistent memory or Device
> > > > DAX?  I'm confused.
> > >
> > > If our interface to MKTME is:
> > >
> > >         fd = open("/dev/mktme");
> > >         ptr = mmap(fd);
> > >
> > > Then it's hard to combine with an interface which is:
> > >
> > >         fd = open("/dev/dax123");
> > >         ptr = mmap(fd);
> > >
> > > Where if we have something like mprotect() (or madvise() or something
> > > else taking pointer), we can just do:
> > >
> > >         fd = open("/dev/anything987");
> > >         ptr = mmap(fd);
> > >         sys_encrypt(ptr);
> >
> > I'm having a hard time imagining that ever working -- wouldn't it blow
> > up if someone did:
> >
> > fd = open("/dev/anything987");
> > ptr1 = mmap(fd);
> > ptr2 = mmap(fd);
> > sys_encrypt(ptr1);
> >
> > So I think it really has to be:
> > fd = open("/dev/anything987");
> > ioctl(fd, ENCRYPT_ME);
> > mmap(fd);
>
> This requires "/dev/anything987" to support ENCRYPT_ME ioctl, right?
>
> So to support NVDIMM (DAX), we need to add ENCRYPT_ME ioctl to DAX?

Yes and yes, or we do it with layers -- see below.

I don't see how we can credibly avoid this.  If we try to do MKTME
behind the DAX driver's back, aren't we going to end up with cache
coherence problems?

>
> >
> > But I really expect that the encryption of a DAX device will actually
> > be a block device setting and won't look like this at all.  It'll be
> > more like dm-crypt except without device mapper.
>
> Are you suggesting not to support MKTME for DAX, or adding MKTME support to dm-crypt?

I'm proposing exposing it by an interface that looks somewhat like
dm-crypt.  Either we could have a way to create a device layered on
top of the DAX devices that exposes a decrypted view or we add a way
to tell the DAX device to kindly use MKTME with such-and-such key.

If there is demand for a way to have an fscrypt-like thing on top of
DAX where different files use different keys, I suppose that could be
done too, but it will need filesystem or VFS help.
