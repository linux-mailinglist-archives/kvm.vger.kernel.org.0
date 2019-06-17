Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A2449625
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 01:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfFQX70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 19:59:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:46877 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbfFQX70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 19:59:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 16:59:25 -0700
X-ExtLoop1: 1
Received: from khuang2-desk.gar.corp.intel.com ([10.255.91.82])
  by orsmga005.jf.intel.com with ESMTP; 17 Jun 2019 16:59:20 -0700
Message-ID: <1560815959.5187.57.camel@linux.intel.com>
Subject: Re: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call
 for MKTME
From:   Kai Huang <kai.huang@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
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
Date:   Tue, 18 Jun 2019 11:59:19 +1200
In-Reply-To: <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
         <20190508144422.13171-46-kirill.shutemov@linux.intel.com>
         <CALCETrVCdp4LyCasvGkc0+S6fvS+dna=_ytLdDPuD2xeAr5c-w@mail.gmail.com>
         <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com>
         <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
         <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-06-17 at 11:27 -0700, Dave Hansen wrote:
> Tom Lendacky, could you take a look down in the message to the talk of
> SEV?  I want to make sure I'm not misrepresenting what it does today.
> ...
> 
> 
> > > I actually don't care all that much which one we end up with.  It's not
> > > like the extra syscall in the second options means much.
> > 
> > The benefit of the second one is that, if sys_encrypt is absent, it
> > just works.  In the first model, programs need a fallback because
> > they'll segfault of mprotect_encrypt() gets ENOSYS.
> 
> Well, by the time they get here, they would have already had to allocate
> and set up the encryption key.  I don't think this would really be the
> "normal" malloc() path, for instance.
> 
> > >  How do we
> > > eventually stack it on top of persistent memory filesystems or Device
> > > DAX?
> > 
> > How do we stack anonymous memory on top of persistent memory or Device
> > DAX?  I'm confused.
> 
> If our interface to MKTME is:
> 
> 	fd = open("/dev/mktme");
> 	ptr = mmap(fd);
> 
> Then it's hard to combine with an interface which is:
> 
> 	fd = open("/dev/dax123");
> 	ptr = mmap(fd);
> 
> Where if we have something like mprotect() (or madvise() or something
> else taking pointer), we can just do:
> 
> 	fd = open("/dev/anything987");
> 	ptr = mmap(fd);
> 	sys_encrypt(ptr);
> 
> Now, we might not *do* it that way for dax, for instance, but I'm just
> saying that if we go the /dev/mktme route, we never get a choice.
> 
> > I think that, in the long run, we're going to have to either expand
> > the core mm's concept of what "memory" is or just have a whole
> > parallel set of mechanisms for memory that doesn't work like memory.
> 
> ...
> > I expect that some day normal memory will  be able to be repurposed as
> > SGX pages on the fly, and that will also look a lot more like SEV or
> > XPFO than like the this model of MKTME.
> 
> I think you're drawing the line at pages where the kernel can manage
> contents vs. not manage contents.  I'm not sure that's the right
> distinction to make, though.  The thing that is important is whether the
> kernel can manage the lifetime and location of the data in the page.
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

Correct neither Qemu nor kernel can see SEV-encrypted guest memory. Qemu requires guest's
cooperation when it needs to interacts with guest, i.e. to support virtual DMA (of virtual devices
in SEV-guest), qemu requires SEV-guest to setup bounce buffer (which will not be SEV-encrypted
memory, but shared memory can be accessed from host side too), so that guest kernel can copy DMA
data from bounce buffer to its own SEV-encrypted memory after qemu/host kernel puts DMA data to
bounce buffer.

And yes from my reading (better to have AMD guys to confirm) SEV guest uses anonymous memory, but it
also pins all guest memory (by calling GUP from KVM -- SEV specifically introduced 2 KVM ioctls for
this purpose), since SEV architecturally cannot support swapping, migraiton of SEV-encrypted guest
memory, because SME/SEV also uses physical address as "tweak", and there's no way that kernel can
get or use SEV-guest's memory encryption key. In order to swap/migrate SEV-guest memory, we need SGX
EPC eviction/reload similar thing, which SEV doesn't have today.

From this perspective, I think driver proposal kinda makes sense since we already have security
feature which uses normal memory some kind like "device memory" (no swap, no migration, etc), so it
makes sense that MKTME just follows that (although from HW MKTME can support swap, page migration,
etc). The downside of driver proposal for MKTME I think is, like Dave mentioned, it's hard (or not
sure whether it is possible) to extend to support NVDIMM (and file backed guest memory), since for
virtual NVDIMM, Qemu needs to call mmap against fd of NVDIMM.

Thanks,
-Kai
