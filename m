Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBFC7496C5
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 03:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFRBfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 21:35:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:44033 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfFRBfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 21:35:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 18:35:50 -0700
X-ExtLoop1: 1
Received: from khuang2-desk.gar.corp.intel.com ([10.255.91.82])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jun 2019 18:35:47 -0700
Message-ID: <1560821746.5187.82.camel@linux.intel.com>
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
Date:   Tue, 18 Jun 2019 13:35:46 +1200
In-Reply-To: <CALCETrVcrPYUUVdgnPZojhJLgEhKv5gNqnT6u2nFVBAZprcs5g@mail.gmail.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
         <20190508144422.13171-46-kirill.shutemov@linux.intel.com>
         <CALCETrVCdp4LyCasvGkc0+S6fvS+dna=_ytLdDPuD2xeAr5c-w@mail.gmail.com>
         <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com>
         <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
         <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com>
         <CALCETrWFXSndmPH0OH4DVVrAyPEeKUUfNwo_9CxO-3xy9awq0g@mail.gmail.com>
         <1560816342.5187.63.camel@linux.intel.com>
         <CALCETrVcrPYUUVdgnPZojhJLgEhKv5gNqnT6u2nFVBAZprcs5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > > 
> > > I'm having a hard time imagining that ever working -- wouldn't it blow
> > > up if someone did:
> > > 
> > > fd = open("/dev/anything987");
> > > ptr1 = mmap(fd);
> > > ptr2 = mmap(fd);
> > > sys_encrypt(ptr1);
> > > 
> > > So I think it really has to be:
> > > fd = open("/dev/anything987");
> > > ioctl(fd, ENCRYPT_ME);
> > > mmap(fd);
> > 
> > This requires "/dev/anything987" to support ENCRYPT_ME ioctl, right?
> > 
> > So to support NVDIMM (DAX), we need to add ENCRYPT_ME ioctl to DAX?
> 
> Yes and yes, or we do it with layers -- see below.
> 
> I don't see how we can credibly avoid this.  If we try to do MKTME
> behind the DAX driver's back, aren't we going to end up with cache
> coherence problems?

I am not sure whether I understand correctly but how is cache coherence problem related to putting
MKTME concept to different layers? To make MKTME work with DAX/NVDIMM, I think no matter which layer
MKTME concept resides, eventually we need to put keyID into PTE which maps to NVDIMM, and kernel
needs to manage cache coherence for NVDIMM just like for normal memory showed in this series? 

Thanks,
-Kai
