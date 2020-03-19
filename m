Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39A6918BF82
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 19:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgCSSky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 14:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgCSSkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 14:40:53 -0400
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7778121473
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 18:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584643252;
        bh=Nnz8DKyINwp4/CvCy4G7iAxgaPQesPB+hm/vCt15eTU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=R55Y0XT+kDu4C+QH9pSvmerrrpvk8vLjCLyhz6RGjBEy+fuKyV/rBtZviY5CH2bji
         i224dYCMGcoHWaxtOQJty0JTZzlS1PN6iuSbG/Wuu4j5JlPKdprJK/yKOP6Xvpa3E7
         eUIY9FLatITEQ3vemNqnCSh3CuYYaov+WXaxPVpE=
Received: by mail-wm1-f54.google.com with SMTP id d1so3569906wmb.2
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 11:40:52 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1JfmaNqaN2L8l/B93D0NEMvOH8cs4LW2E0Htri7o9Blb1OGpWa
        EALZMugMVrcb7W9C1/QeTYeQe4PXf30rHKez8Q5EtQ==
X-Google-Smtp-Source: ADFU+vvWBH0AH3H+Jf2dJbQy+fo/OsWleVD+wRMeOKLdEDzg7ZJ7+mROEy3ck/x1sUe+/gBAEu7toV/J5yrTI9VoQ/4=
X-Received: by 2002:a1c:b0c3:: with SMTP id z186mr5129118wme.36.1584643250721;
 Thu, 19 Mar 2020 11:40:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200319091407.1481-1-joro@8bytes.org> <20200319091407.1481-71-joro@8bytes.org>
 <CALCETrUOQneBHjoZkP-7T5PDijb=WOyv7xF7TD0GLR2Aw77vyA@mail.gmail.com> <20200319160749.GC5122@8bytes.org>
In-Reply-To: <20200319160749.GC5122@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 19 Mar 2020 11:40:39 -0700
X-Gmail-Original-Message-ID: <CALCETrXY5M87C1Fc3QvTkc6MdbQ_3gAuOPUeWJktAzK4T60QNQ@mail.gmail.com>
Message-ID: <CALCETrXY5M87C1Fc3QvTkc6MdbQ_3gAuOPUeWJktAzK4T60QNQ@mail.gmail.com>
Subject: Re: [PATCH 70/70] x86/sev-es: Add NMI state tracking
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 9:07 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> Hi Andy,
>
> On Thu, Mar 19, 2020 at 08:35:59AM -0700, Andy Lutomirski wrote:
> > On Thu, Mar 19, 2020 at 2:14 AM Joerg Roedel <joro@8bytes.org> wrote:
> > >
> > > From: Joerg Roedel <jroedel@suse.de>
> > >
> > > Keep NMI state in SEV-ES code so the kernel can re-enable NMIs for the
> > > vCPU when it reaches IRET.
> >
> > IIRC I suggested just re-enabling NMI in C from do_nmi().  What was
> > wrong with that approach?
>
> If I understand the code correctly a nested NMI will just reset the
> interrupted NMI handler to start executing again at 'restart_nmi'.
> The interrupted NMI handler could be in the #VC handler, and it is not
> safe to just jump back to the start of the NMI handler from somewhere
> within the #VC handler.

Nope.  A nested NMI will reset the interrupted NMI's return frame to
cause it to run again when it's done.  I don't think this will have
any real interaction with #VC.  There's no longjmp() here.

>
> So I decided to not allow NMI nesting for SEV-ES and only re-enable the
> NMI window when the first NMI returns. This is not implemented in this
> patch, but I will do that once Thomas' entry-code rewrite is upstream.
>

I certainly *like* preventing nesting, but I don't think we really
want a whole alternate NMI path just for a couple of messed-up AMD
generations.  And the TF trick is not so pretty either.

> > This causes us to pop the NMI frame off the stack.  Assuming the NMI
> > restart logic is invoked (which is maybe impossible?), we get #DB,
> > which presumably is actually delivered.  And we end up on the #DB
> > stack, which might already have been in use, so we have a potential
> > increase in nesting.  Also, #DB may be called from an unexpected
> > context.
>
> An SEV-ES hypervisor is required to intercept #DB, which means that the
> #DB exception actually ends up being a #VC exception. So it will not end
> up on the #DB stack.

With your patch set, #DB doesn't seem to end up on the #DB stack either.

>
> > I think there are two credible ways to approach this:
> >
> > 1. Just put the NMI unmask in do_nmi().  The kernel *already* knows
> > how to handle running do_nmi() with NMIs unmasked.  This is much, much
> > simpler than your code.
>
> Right, and I thought about that, but the implication is that the
> complexity is moved somewhere else, namely into the #VC handler, which
> then has to be restartable.

As above, I don't think there's an actual problem here.

>
> > 2. Have an entirely separate NMI path for the
> > SEV-ES-on-misdesigned-CPU case.  And have very clear documentation for
> > what prevents this code from being executed on future CPUs (Zen3?)
> > that have this issue fixed for real?
>
> That sounds like a good alternative, I will investigate this approach.
> The NMI handler should be much simpler as it doesn't need to allow NMI
> nesting. The question is, does the C code down the NMI path depend on
> the NMI handlers stack frame layout (e.g. the in-nmi flag)?

Nope.  In particular, the 32-bit path doesn't have all this.
