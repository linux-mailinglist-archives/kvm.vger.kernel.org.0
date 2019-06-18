Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95AFE49725
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 03:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfFRBvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 21:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbfFRBvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 21:51:00 -0400
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ED552183F
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 01:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560822658;
        bh=9pADkGP6B9XPZnoSXHTdilPdPV8psk9Fh8iUhTu3lCw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aO3C7gusUpRN/F1U4OsRkHAd5bWRjQMfpkle66mvj1CdvoqtH8xKaAKZisXNpFECZ
         QOlRO1ZyOcvCR5lcG2FzLXrziVwwb7nFPBKZOO+serlPcj/7WLJ2HliilezLLDjCa7
         qcRrhJb8zqZ5haKe+GxoCxdEy5Z5yvR95St+9PVQ=
Received: by mail-wm1-f41.google.com with SMTP id 207so1375678wma.1
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 18:50:58 -0700 (PDT)
X-Gm-Message-State: APjAAAX/eBr9Fjy6YP5OOhocxCCnWOm9R2uAt0Blt4I/YENWkaQ7WR1J
        QHa3A7ivb0/fIoKQXF868WPel0ERHP0mv6FNCEMEmw==
X-Google-Smtp-Source: APXvYqwk/SrJSofnVqjpWG+yfZVhTrDqxfKgaT84Q/TstEFvioa01Y7VXX7BoP++q9pm0LhijDOAe1YMxOBvn+LL0vg=
X-Received: by 2002:a7b:cd84:: with SMTP id y4mr951107wmj.79.1560822657085;
 Mon, 17 Jun 2019 18:50:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-46-kirill.shutemov@linux.intel.com> <CALCETrVCdp4LyCasvGkc0+S6fvS+dna=_ytLdDPuD2xeAr5c-w@mail.gmail.com>
 <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com> <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
 <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com> <CALCETrWFXSndmPH0OH4DVVrAyPEeKUUfNwo_9CxO-3xy9awq0g@mail.gmail.com>
 <d599b1d7-9455-3012-0115-96ddbad31833@intel.com> <1560818931.5187.70.camel@linux.intel.com>
In-Reply-To: <1560818931.5187.70.camel@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 17 Jun 2019 18:50:46 -0700
X-Gmail-Original-Message-ID: <CALCETrXNCmSnrTwGiwuF9=wLu797WBPZ0gt92D-CyU+V3sq7hA@mail.gmail.com>
Message-ID: <CALCETrXNCmSnrTwGiwuF9=wLu797WBPZ0gt92D-CyU+V3sq7hA@mail.gmail.com>
Subject: Re: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call for MKTME
To:     Kai Huang <kai.huang@linux.intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
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

On Mon, Jun 17, 2019 at 5:48 PM Kai Huang <kai.huang@linux.intel.com> wrote:
>
>
> >
> > > And another silly argument: if we had /dev/mktme, then we could
> > > possibly get away with avoiding all the keyring stuff entirely.
> > > Instead, you open /dev/mktme and you get your own key under the hook.
> > > If you want two keys, you open /dev/mktme twice.  If you want some
> > > other program to be able to see your memory, you pass it the fd.
> >
> > We still like the keyring because it's one-stop-shopping as the place
> > that *owns* the hardware KeyID slots.  Those are global resources and
> > scream for a single global place to allocate and manage them.  The
> > hardware slots also need to be shared between any anonymous and
> > file-based users, no matter what the APIs for the anonymous side.
>
> MKTME driver (who creates /dev/mktme) can also be the one-stop-shopping. I think whether to choose
> keyring to manage MKTME key should be based on whether we need/should take advantage of existing key
> retention service functionalities. For example, with key retention service we can
> revoke/invalidate/set expiry for a key (not sure whether MKTME needs those although), and we have
> several keyrings -- thread specific keyring, process specific keyring, user specific keyring, etc,
> thus we can control who can/cannot find the key, etc. I think managing MKTME key in MKTME driver
> doesn't have those advantages.
>

Trying to evaluate this with the current proposed code is a bit odd, I
think.  Suppose you create a thread-specific key and then fork().  The
child can presumably still use the key regardless of whether the child
can nominally access the key in the keyring because the PTEs are still
there.

More fundamentally, in some sense, the current code has no semantics.
Associating a key with memory and "encrypting" it doesn't actually do
anything unless you are attacking the memory bus but you haven't
compromised the kernel.  There's no protection against a guest that
can corrupt its EPT tables, there's no protection against kernel bugs
(*especially* if the duplicate direct map design stays), and there
isn't even any fd or other object around by which you can only access
the data if you can see the key.

I'm also wondering whether the kernel will always be able to be a
one-stop shop for key allocation -- if the MKTME hardware gains
interesting new uses down the road, who knows how key allocation will
work?
