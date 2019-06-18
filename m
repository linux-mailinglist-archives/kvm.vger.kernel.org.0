Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A3C49707
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 03:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfFRBkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 21:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbfFRBko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 21:40:44 -0400
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D18C0208E4
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 01:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560822044;
        bh=KsbO8zqRDwjqNqLUKDtxw38bKGpR6/rXffGf+dHWdqY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tAYxS8CzDFuv2tQZHZR4A3RbB0atwX6vH4WU+fA+oZHmeDZ2QCd8tIftSy05dWYvx
         Zr2+5L9RCAkPUy8diltaJF7/yaAZ9lLrLPKmiWFNUhWORvS5gl44MTXH5S00eMh8Dm
         CARK3lbj5/kG+g8UA3DoM4IVv0LeK7RA1QPw8H0E=
Received: by mail-wm1-f41.google.com with SMTP id u8so1351146wmm.1
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 18:40:43 -0700 (PDT)
X-Gm-Message-State: APjAAAWUL0YEgHylDhDwgDoaL+cydCsjkdoOiSy3BIy0Qyv1SFxa6wNy
        9IECsgAjlNchDWy3FnjvR5gmgL/hKZrzKFKStxVseg==
X-Google-Smtp-Source: APXvYqzS0tk+KNMV6hutqJZNe+OpQ2triMNDvKY2XNxjx+/s7nYJx2KaD0PtMpxVPGCU2zuqJwIgx5ai1DRb5gWNARw=
X-Received: by 2002:a7b:cd84:: with SMTP id y4mr928755wmj.79.1560822042435;
 Mon, 17 Jun 2019 18:40:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-46-kirill.shutemov@linux.intel.com> <CALCETrVCdp4LyCasvGkc0+S6fvS+dna=_ytLdDPuD2xeAr5c-w@mail.gmail.com>
 <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com> <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
 <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com> <1560815959.5187.57.camel@linux.intel.com>
 <cbbc6af7-36f8-a81f-48b1-2ad4eefc2417@amd.com>
In-Reply-To: <cbbc6af7-36f8-a81f-48b1-2ad4eefc2417@amd.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 17 Jun 2019 18:40:31 -0700
X-Gmail-Original-Message-ID: <CALCETrWq98--AgXXj=h1R70CiCWNncCThN2fEdxj2ZkedMw6=A@mail.gmail.com>
Message-ID: <CALCETrWq98--AgXXj=h1R70CiCWNncCThN2fEdxj2ZkedMw6=A@mail.gmail.com>
Subject: Re: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call for MKTME
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Cc:     Kai Huang <kai.huang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
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
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 17, 2019 at 6:34 PM Lendacky, Thomas
<Thomas.Lendacky@amd.com> wrote:
>
> On 6/17/19 6:59 PM, Kai Huang wrote:
> > On Mon, 2019-06-17 at 11:27 -0700, Dave Hansen wrote:

> >
> > And yes from my reading (better to have AMD guys to confirm) SEV guest uses anonymous memory, but it
> > also pins all guest memory (by calling GUP from KVM -- SEV specifically introduced 2 KVM ioctls for
> > this purpose), since SEV architecturally cannot support swapping, migraiton of SEV-encrypted guest
> > memory, because SME/SEV also uses physical address as "tweak", and there's no way that kernel can
> > get or use SEV-guest's memory encryption key. In order to swap/migrate SEV-guest memory, we need SGX
> > EPC eviction/reload similar thing, which SEV doesn't have today.
>
> Yes, all the guest memory is currently pinned by calling GUP when creating
> an SEV guest.

Ick.

What happens if QEMU tries to read the memory?  Does it just see
ciphertext?  Is cache coherency lost if QEMU writes it?
