Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D9B48DA6
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 21:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfFQTMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 15:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbfFQTMf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 15:12:35 -0400
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9812E208CB
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 19:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560798753;
        bh=iB5y5Zu4qbKrjb1l9NPFwndfY9Hlf8H4ea1wBhUkzvQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=u2YwFMQnEuL95VJAF+xSJUrvjviELW8LACJiuxyOGnB4nqjGjmbFz5bNyr7x5P7xV
         6rFQ9e6hEpHCA2tL7HXXlNnqJ0jvdS8Izy9PArs+dAvG2vjQjE4kbWFoAFP85zGiek
         ps/XWaUVgsS58Hy8dBSgrjfFCLx8bGQTqnxb2I7o=
Received: by mail-wr1-f52.google.com with SMTP id k11so11238907wrl.1
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 12:12:33 -0700 (PDT)
X-Gm-Message-State: APjAAAUDAPoE9ujmoBQE71tJJ1NTu9GbiIN1Iqo26k3Z6160lJWmXZ3s
        VTaEDVRTe0R83u5MCDHDqQi10VGumJXNs2dABzEiLw==
X-Google-Smtp-Source: APXvYqyVfJ2JNvfBU2L4DTO4h4dbmpc/CBe+DfWNCfmOVKfQ0k0I5D871RcoCkUh0GY4/Ab3rJAppaMpeN+9mjrcBLU=
X-Received: by 2002:adf:cc85:: with SMTP id p5mr16716016wrj.47.1560798752177;
 Mon, 17 Jun 2019 12:12:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-46-kirill.shutemov@linux.intel.com> <CALCETrVCdp4LyCasvGkc0+S6fvS+dna=_ytLdDPuD2xeAr5c-w@mail.gmail.com>
 <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com> <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
 <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com>
In-Reply-To: <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 17 Jun 2019 12:12:20 -0700
X-Gmail-Original-Message-ID: <CALCETrWFXSndmPH0OH4DVVrAyPEeKUUfNwo_9CxO-3xy9awq0g@mail.gmail.com>
Message-ID: <CALCETrWFXSndmPH0OH4DVVrAyPEeKUUfNwo_9CxO-3xy9awq0g@mail.gmail.com>
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
        keyrings@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 17, 2019 at 11:37 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> Tom Lendacky, could you take a look down in the message to the talk of
> SEV?  I want to make sure I'm not misrepresenting what it does today.
> ...
>
>
> >> I actually don't care all that much which one we end up with.  It's not
> >> like the extra syscall in the second options means much.
> >
> > The benefit of the second one is that, if sys_encrypt is absent, it
> > just works.  In the first model, programs need a fallback because
> > they'll segfault of mprotect_encrypt() gets ENOSYS.
>
> Well, by the time they get here, they would have already had to allocate
> and set up the encryption key.  I don't think this would really be the
> "normal" malloc() path, for instance.
>
> >>  How do we
> >> eventually stack it on top of persistent memory filesystems or Device
> >> DAX?
> >
> > How do we stack anonymous memory on top of persistent memory or Device
> > DAX?  I'm confused.
>
> If our interface to MKTME is:
>
>         fd = open("/dev/mktme");
>         ptr = mmap(fd);
>
> Then it's hard to combine with an interface which is:
>
>         fd = open("/dev/dax123");
>         ptr = mmap(fd);
>
> Where if we have something like mprotect() (or madvise() or something
> else taking pointer), we can just do:
>
>         fd = open("/dev/anything987");
>         ptr = mmap(fd);
>         sys_encrypt(ptr);

I'm having a hard time imagining that ever working -- wouldn't it blow
up if someone did:

fd = open("/dev/anything987");
ptr1 = mmap(fd);
ptr2 = mmap(fd);
sys_encrypt(ptr1);

So I think it really has to be:
fd = open("/dev/anything987");
ioctl(fd, ENCRYPT_ME);
mmap(fd);

But I really expect that the encryption of a DAX device will actually
be a block device setting and won't look like this at all.  It'll be
more like dm-crypt except without device mapper.

>
> Now, we might not *do* it that way for dax, for instance, but I'm just
> saying that if we go the /dev/mktme route, we never get a choice.
>
> > I think that, in the long run, we're going to have to either expand
> > the core mm's concept of what "memory" is or just have a whole
> > parallel set of mechanisms for memory that doesn't work like memory.
> ...
> > I expect that some day normal memory will  be able to be repurposed as
> > SGX pages on the fly, and that will also look a lot more like SEV or
> > XPFO than like the this model of MKTME.
>
> I think you're drawing the line at pages where the kernel can manage
> contents vs. not manage contents.  I'm not sure that's the right
> distinction to make, though.  The thing that is important is whether the
> kernel can manage the lifetime and location of the data in the page.

The kernel can manage the location of EPC pages, for example, but only
under extreme constraints right now.  The draft SGX driver can and
does swap them out and swap them back in, potentially at a different
address.

>
> Basically: Can the kernel choose where the page comes from and get the
> page back when it wants?
>
> I really don't like the current state of things like with SEV or with
> KVM direct device assignment where the physical location is quite locked
> down and the kernel really can't manage the memory.  I'm trying really
> hard to make sure future hardware is more permissive about such things.
>  My hope is that these are a temporary blip and not the new normal.
>
> > So, if we upstream MKTME as anonymous memory with a magic config
> > syscall, I predict that, in a few years, it will be end up inheriting
> > all downsides of both approaches with few of the upsides.  Programs
> > like QEMU will need to learn to manipulate pages that can't be
> > accessed outside the VM without special VM buy-in, so the fact that
> > MKTME pages are fully functional and can be GUP-ed won't be very
> > useful.  And the VM will learn about all these things, but MKTME won't
> > really fit in.
>
> Kai Huang (who is on cc) has been doing the QEMU enabling and might want
> to weigh in.  I'd also love to hear from the AMD folks in case I'm not
> grokking some aspect of SEV.
>
> But, my understanding is that, even today, neither QEMU nor the kernel
> can see SEV-encrypted guest memory.  So QEMU should already understand
> how to not interact with guest memory.  I _assume_ it's also already
> doing this with anonymous memory, without needing /dev/sme or something.

Let's find out!

If it's using anonymous memory, it must be very strange, since it
would more or less have to be mmapped PROT_NONE.  The thing that makes
anonymous memory in particular seem so awkward to me is that it's
fundamentally identified by it's *address*, which means it makes no
sense if it's not mapped.

>
> > And, one of these days, someone will come up with a version of XPFO
> > that could actually be upstreamed, and it seems entirely plausible
> > that it will be totally incompatible with MKTME-as-anonymous-memory
> > and that users of MKTME will actually get *worse* security.
>
> I'm not following here.  XPFO just means that we don't keep the direct
> map around all the time for all memory.  If XPFO and
> MKTME-as-anonymous-memory were both in play, I think we'd just be
> creating/destroying the MKTME-enlightened direct map instead of a
> vanilla one.

What I'm saying is that I can imagine XPFO also wanting to be
something other than anonymous memory.  I don't think we'll ever want
regular MAP_ANONYMOUS to enable XPFO by default because the
performance will suck.  Doing this seems odd:

ptr = mmap(MAP_ANONYMOUS);
sys_xpfo_a_pointer(ptr);

So I could imagine:

ptr = mmap(MAP_ANONYMOUS | MAP_XPFO);

or

fd = open("/dev/xpfo"); (or fd = memfd_create(..., XPFO);
ptr = mmap(fd);

I'm thinking that XPFO is a *lot* simpler under the hood if we just
straight-up don't support GUP on it.  Maybe we should call this
"strong XPFO".  Similarly, the kinds of things that want MKTME may
also want the memory to be entirely absent from the direct map.  And
the things that use SEV (as I understand it) *can't* usefully use the
memory for normal IO via GUP or copy_to/from_user(), so these things
all have a decent amount in common.

Another down side of anonymous memory (in my head, anyway -- QEMU
people should chime in) is that it seems awkward to use it for IO
techniques in which the back-end isn't in the QEMU process.  If
there's an fd involved, you can pass it around, feed it to things like
vfio, etc.  If there's no fd, it's stuck in the creating process.

And another silly argument: if we had /dev/mktme, then we could
possibly get away with avoiding all the keyring stuff entirely.
Instead, you open /dev/mktme and you get your own key under the hook.
If you want two keys, you open /dev/mktme twice.  If you want some
other program to be able to see your memory, you pass it the fd.

I hope this email isn't too rambling :)

--Andy
