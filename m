Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAB349750
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 04:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfFRCLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 22:11:46 -0400
Received: from mga12.intel.com ([192.55.52.136]:31762 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfFRCLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 22:11:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 19:11:45 -0700
X-ExtLoop1: 1
Received: from khuang2-desk.gar.corp.intel.com ([10.255.91.82])
  by orsmga004.jf.intel.com with ESMTP; 17 Jun 2019 19:11:40 -0700
Message-ID: <1560823899.5187.92.camel@linux.intel.com>
Subject: Re: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call
 for MKTME
From:   Kai Huang <kai.huang@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
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
Date:   Tue, 18 Jun 2019 14:11:39 +1200
In-Reply-To: <CALCETrXNCmSnrTwGiwuF9=wLu797WBPZ0gt92D-CyU+V3sq7hA@mail.gmail.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
         <20190508144422.13171-46-kirill.shutemov@linux.intel.com>
         <CALCETrVCdp4LyCasvGkc0+S6fvS+dna=_ytLdDPuD2xeAr5c-w@mail.gmail.com>
         <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com>
         <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
         <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com>
         <CALCETrWFXSndmPH0OH4DVVrAyPEeKUUfNwo_9CxO-3xy9awq0g@mail.gmail.com>
         <d599b1d7-9455-3012-0115-96ddbad31833@intel.com>
         <1560818931.5187.70.camel@linux.intel.com>
         <CALCETrXNCmSnrTwGiwuF9=wLu797WBPZ0gt92D-CyU+V3sq7hA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-06-17 at 18:50 -0700, Andy Lutomirski wrote:
> On Mon, Jun 17, 2019 at 5:48 PM Kai Huang <kai.huang@linux.intel.com> wrote:
> > 
> > 
> > > 
> > > > And another silly argument: if we had /dev/mktme, then we could
> > > > possibly get away with avoiding all the keyring stuff entirely.
> > > > Instead, you open /dev/mktme and you get your own key under the hook.
> > > > If you want two keys, you open /dev/mktme twice.  If you want some
> > > > other program to be able to see your memory, you pass it the fd.
> > > 
> > > We still like the keyring because it's one-stop-shopping as the place
> > > that *owns* the hardware KeyID slots.  Those are global resources and
> > > scream for a single global place to allocate and manage them.  The
> > > hardware slots also need to be shared between any anonymous and
> > > file-based users, no matter what the APIs for the anonymous side.
> > 
> > MKTME driver (who creates /dev/mktme) can also be the one-stop-shopping. I think whether to
> > choose
> > keyring to manage MKTME key should be based on whether we need/should take advantage of existing
> > key
> > retention service functionalities. For example, with key retention service we can
> > revoke/invalidate/set expiry for a key (not sure whether MKTME needs those although), and we
> > have
> > several keyrings -- thread specific keyring, process specific keyring, user specific keyring,
> > etc,
> > thus we can control who can/cannot find the key, etc. I think managing MKTME key in MKTME driver
> > doesn't have those advantages.
> > 
> 
> Trying to evaluate this with the current proposed code is a bit odd, I
> think.  Suppose you create a thread-specific key and then fork().  The
> child can presumably still use the key regardless of whether the child
> can nominally access the key in the keyring because the PTEs are still
> there.

Right. This is a little bit odd, although virtualization (Qemu, which is the main use case of MKTME
at least so far) doesn't use fork().

> 
> More fundamentally, in some sense, the current code has no semantics.
> Associating a key with memory and "encrypting" it doesn't actually do
> anything unless you are attacking the memory bus but you haven't
> compromised the kernel.  There's no protection against a guest that
> can corrupt its EPT tables, there's no protection against kernel bugs
> (*especially* if the duplicate direct map design stays), and there
> isn't even any fd or other object around by which you can only access
> the data if you can see the key.

I am not saying managing MKTME key/keyID in key retention service is definitely better, but it seems
all those you mentioned are not related to whether to choose key retention service to manage MKTME
key/keyID? Or you are saying it doesn't matter we manage key/keyID in key retention service or in
MKTME driver, since MKTME barely have any security benefits (besides physical attack)?

> 
> I'm also wondering whether the kernel will always be able to be a
> one-stop shop for key allocation -- if the MKTME hardware gains
> interesting new uses down the road, who knows how key allocation will
> work?

I by now don't have any use case which requires to manage key/keyID specifically for its own use,
rather than letting kernel to manage keyID allocation. Please inspire us if you have any potential.

Thanks,
-Kai
