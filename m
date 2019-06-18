Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B363749716
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 03:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbfFRBny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 21:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbfFRBny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 21:43:54 -0400
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8513D21670
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 01:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560822232;
        bh=UeYxzLzSuHkMsOuXwbF2xE8bLo2DE9Ww1ky5l8uVDBU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Bzbrz8OzybZx3nRD8sszmrux5YYYBpI0S2wK2zb8PyRZ4zcxsLG3dVRc64HvmE3Ui
         M7Sl4fczjevhlcuk02zlNt8Ymdmk+E4IgnWBm+yXVqstWxyO3bf3QA3M9Q1RivuPh1
         NnIRmdDmIbcCeiljctgQl+Clg5Pl3NWlQ2WIF1XA=
Received: by mail-wr1-f42.google.com with SMTP id x4so12045779wrt.6
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 18:43:52 -0700 (PDT)
X-Gm-Message-State: APjAAAVma3luK9FZKF/2RvxSpjOMe5THn2jlREqw+Q4F3UdE/rxLWgnd
        i1A1DNSKlmTeJE2al6+KFCXbVmSH2aKxgeHQnvhw9A==
X-Google-Smtp-Source: APXvYqy/3GwC+ybJPbiqUN4zJXNUsdh3MExSjxnPoCGxfyRLpGXNcW3WtovAJfnouA+Zf8by7BtMXSty6Yu+3bvUT+o=
X-Received: by 2002:adf:a443:: with SMTP id e3mr25678448wra.221.1560822231037;
 Mon, 17 Jun 2019 18:43:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-46-kirill.shutemov@linux.intel.com> <CALCETrVCdp4LyCasvGkc0+S6fvS+dna=_ytLdDPuD2xeAr5c-w@mail.gmail.com>
 <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com> <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
 <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com> <CALCETrWFXSndmPH0OH4DVVrAyPEeKUUfNwo_9CxO-3xy9awq0g@mail.gmail.com>
 <1560816342.5187.63.camel@linux.intel.com> <CALCETrVcrPYUUVdgnPZojhJLgEhKv5gNqnT6u2nFVBAZprcs5g@mail.gmail.com>
 <1560821746.5187.82.camel@linux.intel.com>
In-Reply-To: <1560821746.5187.82.camel@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 17 Jun 2019 18:43:40 -0700
X-Gmail-Original-Message-ID: <CALCETrUrFTFGhRMuNLxD9G9=GsR6U-THWn4AtminR_HU-nBj+Q@mail.gmail.com>
Message-ID: <CALCETrUrFTFGhRMuNLxD9G9=GsR6U-THWn4AtminR_HU-nBj+Q@mail.gmail.com>
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

On Mon, Jun 17, 2019 at 6:35 PM Kai Huang <kai.huang@linux.intel.com> wrote:
>
>
> > > >
> > > > I'm having a hard time imagining that ever working -- wouldn't it blow
> > > > up if someone did:
> > > >
> > > > fd = open("/dev/anything987");
> > > > ptr1 = mmap(fd);
> > > > ptr2 = mmap(fd);
> > > > sys_encrypt(ptr1);
> > > >
> > > > So I think it really has to be:
> > > > fd = open("/dev/anything987");
> > > > ioctl(fd, ENCRYPT_ME);
> > > > mmap(fd);
> > >
> > > This requires "/dev/anything987" to support ENCRYPT_ME ioctl, right?
> > >
> > > So to support NVDIMM (DAX), we need to add ENCRYPT_ME ioctl to DAX?
> >
> > Yes and yes, or we do it with layers -- see below.
> >
> > I don't see how we can credibly avoid this.  If we try to do MKTME
> > behind the DAX driver's back, aren't we going to end up with cache
> > coherence problems?
>
> I am not sure whether I understand correctly but how is cache coherence problem related to putting
> MKTME concept to different layers? To make MKTME work with DAX/NVDIMM, I think no matter which layer
> MKTME concept resides, eventually we need to put keyID into PTE which maps to NVDIMM, and kernel
> needs to manage cache coherence for NVDIMM just like for normal memory showed in this series?
>

I mean is that, to avoid cache coherence problems, something has to
prevent user code from mapping the same page with two different key
ids.  If the entire MKTME mechanism purely layers on top of DAX,
something needs to prevent the underlying DAX device from being mapped
at the same time as the MKTME-decrypted view.  This is obviously
doable, but it's not automatic.
