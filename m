Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA3DCC738
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2019 03:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfJEBdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 21:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbfJEBdV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 21:33:21 -0400
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6606222CC
        for <kvm@vger.kernel.org>; Sat,  5 Oct 2019 01:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570239201;
        bh=n4aRImq4Lrub/+kEZQaJLf+YSE+YDB6MnfXrB9ePfvk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iYBdrZ8t8ue68AoQly/xyqB28LRJAXGjFkcdPTNRRNiAcnIRC3V/tmkDJKzJxuCZy
         V9a4KhIY7/9CzFBCq4b1AH78jgig2473H1G194ofqYcCKkqIYb9wwPok1Yby1quKl8
         Q3WBdKX9YRyaVXFM/wKMwQ6t0MJ6DXsN9NEEv0Iw=
Received: by mail-wr1-f52.google.com with SMTP id r5so9072396wrm.12
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 18:33:20 -0700 (PDT)
X-Gm-Message-State: APjAAAWqZbRkV8QLJhYbYqL/qHj3wJYdpcAibCls3E4EkIhI5mOLCthH
        aHdgWS2h2pyY+26yzOflkwmNe3oZXDE0dEewddQQvA==
X-Google-Smtp-Source: APXvYqyjhheOmqMgJaDuXYPsAFybWX1peME6BJhrzOo/E8Me2RUlybh6fcihReGSWFe7PARuThdGh065aUJ9r5hsRnc=
X-Received: by 2002:a5d:4647:: with SMTP id j7mr14200264wrs.106.1570239199136;
 Fri, 04 Oct 2019 18:33:19 -0700 (PDT)
MIME-Version: 1.0
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
 <CALCETrW9MEvNt+kB_65cbX9VJiLxktAFagkzSGR0VQfd4VHOiQ@mail.gmail.com> <d5be8611158108a05fbb67c23b10357f2fb19816.camel@intel.com>
In-Reply-To: <d5be8611158108a05fbb67c23b10357f2fb19816.camel@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 4 Oct 2019 18:33:07 -0700
X-Gmail-Original-Message-ID: <CALCETrWDFYO4LZu_OM24FAcnphm4jwvbz4j31q8w7eeHUR_4EA@mail.gmail.com>
Message-ID: <CALCETrWDFYO4LZu_OM24FAcnphm4jwvbz4j31q8w7eeHUR_4EA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] XOM for KVM guest userspace
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "luto@kernel.org" <luto@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "Dock, Deneen T" <deneen.t.dock@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kristen@linux.intel.com" <kristen@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 4, 2019 at 1:10 PM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Fri, 2019-10-04 at 07:56 -0700, Andy Lutomirski wrote:
> > On Thu, Oct 3, 2019 at 2:38 PM Rick Edgecombe
> > <rick.p.edgecombe@intel.com> wrote:
> > >
> > > This patchset enables the ability for KVM guests to create execute-only (XO)
> > > memory by utilizing EPT based XO permissions. XO memory is currently
> > > supported
> > > on Intel hardware natively for CPU's with PKU, but this enables it on older
> > > platforms, and can support XO for kernel memory as well.
> >
> > The patchset seems to sometimes call this feature "XO" and sometimes
> > call it "NR".  To me, XO implies no-read and no-write, whereas NR
> > implies just no-read.  Can you please clarify *exactly* what the new
> > bit does and be consistent?
> >
> > I suggest that you make it NR, which allows for PROT_EXEC and
> > PROT_EXEC|PROT_WRITE and plain PROT_WRITE.  WX is of dubious value,
> > but I can imagine plain W being genuinely useful for logging and for
> > JITs that could maintain a W and a separate X mapping of some code.
> > In other words, with an NR bit, all 8 logical access modes are
> > possible.  Also, keeping the paging bits more orthogonal seems nice --
> > we already have a bit that controls write access.
>
> Sorry, yes the behavior of this bit needs to be documented a lot better. I will
> definitely do this for the next version.
>
> To clarify, since the EPT permissions in the XO/NR range are executable, and not
> readable or writeable the new bit really means XO, but only when NX is 0 since
> the guest page tables are being checked as well. When NR=1, W=1, and NX=0, the
> memory is still XO.
>
> NR was picked over XO because as you say. The idea is that it can be defined
> that in the case of KVM XO, NR and writable is not a valid combination, like
> writeable but not readable is defined as not valid for the EPT.
>

Ugh, I see, this is an "EPT Misconfiguration".  Oh, well.  I guess
just keep things as they are and document things better, please.
Don't try to emulate.

I don't suppose Intel could be convinced to get rid of that in a
future CPU and allow write-only memory?

BTW, is your patch checking for support in IA32_VMX_EPT_VPID_CAP?  I
didn't notice it, but I didn't look that hard.
