Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4623749803
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 06:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfFRET5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 00:19:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfFRET5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 00:19:57 -0400
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F20FE20B1F
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 04:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560831596;
        bh=51rZ9e9LkNVBLGHAIif1eIVHEBL3AZLf/1gX1DPTttU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DuLk3e8EkWUmqjbMfqOhBVznVeVo0ij+gX+dBj6X0D/RiqGPAyRXac3zAcRajl+NC
         rG8dKjmVC7cMcg+ACN+3b4bthSfnYsFrxPjfTgqhyZKFcThYwI8P3UENip/XJE3+MM
         sTMSBKCyqPy5UWo0Vh97re/7Sj11UC+1Gd22CCLk=
Received: by mail-wr1-f54.google.com with SMTP id f9so12222540wre.12
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 21:19:55 -0700 (PDT)
X-Gm-Message-State: APjAAAXfg0P6Fg6T6gDCOwPMEia4zd9eL7/4IVqqbnmKMnNqY8uzN8Wk
        rsZy8VT4RinUY9pupsPwa9gBtpjyhu9IvVGpRUtzAA==
X-Google-Smtp-Source: APXvYqwkWC2giN5A08cpptwz3BEntUfKPcruY0ZN2y5TqsdMlC09wK5a0VuZQ+7Nz/i2Q9X96feEw9aA23jTO9Vxlx4=
X-Received: by 2002:adf:a443:: with SMTP id e3mr26082705wra.221.1560831594613;
 Mon, 17 Jun 2019 21:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-46-kirill.shutemov@linux.intel.com> <CALCETrVCdp4LyCasvGkc0+S6fvS+dna=_ytLdDPuD2xeAr5c-w@mail.gmail.com>
 <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com> <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
 <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com> <1560815959.5187.57.camel@linux.intel.com>
 <cbbc6af7-36f8-a81f-48b1-2ad4eefc2417@amd.com> <CALCETrWq98--AgXXj=h1R70CiCWNncCThN2fEdxj2ZkedMw6=A@mail.gmail.com>
In-Reply-To: <CALCETrWq98--AgXXj=h1R70CiCWNncCThN2fEdxj2ZkedMw6=A@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 17 Jun 2019 21:19:42 -0700
X-Gmail-Original-Message-ID: <CALCETrWX877XD=mivftv96y00tWxT5THFD5MgoF+c_BPqc4aDQ@mail.gmail.com>
Message-ID: <CALCETrWX877XD=mivftv96y00tWxT5THFD5MgoF+c_BPqc4aDQ@mail.gmail.com>
Subject: Re: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call for MKTME
To:     Andy Lutomirski <luto@kernel.org>
Cc:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Kai Huang <kai.huang@linux.intel.com>,
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
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 17, 2019 at 6:40 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Mon, Jun 17, 2019 at 6:34 PM Lendacky, Thomas
> <Thomas.Lendacky@amd.com> wrote:
> >
> > On 6/17/19 6:59 PM, Kai Huang wrote:
> > > On Mon, 2019-06-17 at 11:27 -0700, Dave Hansen wrote:
>
> > >
> > > And yes from my reading (better to have AMD guys to confirm) SEV guest uses anonymous memory, but it
> > > also pins all guest memory (by calling GUP from KVM -- SEV specifically introduced 2 KVM ioctls for
> > > this purpose), since SEV architecturally cannot support swapping, migraiton of SEV-encrypted guest
> > > memory, because SME/SEV also uses physical address as "tweak", and there's no way that kernel can
> > > get or use SEV-guest's memory encryption key. In order to swap/migrate SEV-guest memory, we need SGX
> > > EPC eviction/reload similar thing, which SEV doesn't have today.
> >
> > Yes, all the guest memory is currently pinned by calling GUP when creating
> > an SEV guest.
>
> Ick.
>
> What happens if QEMU tries to read the memory?  Does it just see
> ciphertext?  Is cache coherency lost if QEMU writes it?

I should add: is the current interface that SEV uses actually good, or
should the kernel try to do something differently?  I've spent exactly
zero time looking at SEV APIs or at how QEMU manages its memory.
