Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2403318BF8B
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 19:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgCSSnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 14:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbgCSSnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 14:43:35 -0400
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BE8621556
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 18:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584643414;
        bh=16Mv0Bki/NfvJX5iwDxd/8tDdJeb33292LnGanZEgHk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gZnE0N1zX3N4hrpdEBg3hayONMFggbn4LZXMYyZpsRN0k2dZjof1Jfd1Qmvhdh93+
         sGF9hoGmQ3D9O6lCKLVt/Fn4A0XRLnor5uOC07hgnzJMuGptsX7jsAEzADkZqINynv
         dtZbN5mYI74zyy3gDrcqFJNyDt6bH15ZmZzbPenY=
Received: by mail-wm1-f47.google.com with SMTP id m3so3578904wmi.0
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 11:43:34 -0700 (PDT)
X-Gm-Message-State: ANhLgQ2TZuN7P5x/ZpIF1Z+extPO6HW+UP9Hrg8SjQ8FkyIQo3tQuDT8
        IfuwqK1i4IbogXTQdNnNaRS7I0YI0zeaiVuE++0WMA==
X-Google-Smtp-Source: ADFU+vv10cBd6Yipt9Fp30VfQsiUak847hkVmmyNfiLI7ndWg3gIIQhdPQtda5z9gYC13rmpADmNaW86Fu4VfLkwdyA=
X-Received: by 2002:a1c:1904:: with SMTP id 4mr765861wmz.21.1584643412632;
 Thu, 19 Mar 2020 11:43:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200319091407.1481-1-joro@8bytes.org> <20200319091407.1481-42-joro@8bytes.org>
 <CALCETrW9EYi5dzCKNtKkxM18CC4n5BZxTp1=qQ5qZccwstXjzg@mail.gmail.com> <20200319162439.GE5122@8bytes.org>
In-Reply-To: <20200319162439.GE5122@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 19 Mar 2020 11:43:20 -0700
X-Gmail-Original-Message-ID: <CALCETrW6LOwEfjJz-S7fFJvPqgr9BoCkRG2MA-Pk6K_y_rmGHg@mail.gmail.com>
Message-ID: <CALCETrW6LOwEfjJz-S7fFJvPqgr9BoCkRG2MA-Pk6K_y_rmGHg@mail.gmail.com>
Subject: Re: [PATCH 41/70] x86/sev-es: Add Runtime #VC Exception Handler
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

On Thu, Mar 19, 2020 at 9:24 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> On Thu, Mar 19, 2020 at 08:44:03AM -0700, Andy Lutomirski wrote:
> > On Thu, Mar 19, 2020 at 2:14 AM Joerg Roedel <joro@8bytes.org> wrote:
> > >
> > > From: Tom Lendacky <thomas.lendacky@amd.com>
> > >
> > > Add the handler for #VC exceptions invoked at runtime.
> >
> > If I read this correctly, this does not use IST.  If that's true, I
> > don't see how this can possibly work.  There at least two nasty cases
> > that come to mind:
> >
> > 1. SYSCALL followed by NMI.  The NMI IRET hack gets to #VC and we
> > explode.  This is fixable by getting rid of the NMI EFLAGS.TF hack.
>
> Not an issue in this patch-set, the confusion comes from the fact that I
> left some parts of the single-step-over-iret code in the patch. But it
> is not used. The NMI handling in this patch-set sends the NMI-complete
> message before the IRET, when the kernel is still in a safe environment
> (kernel stack, kernel cr3).

Got it!

>
> > 2. tools/testing/selftests/x86/mov_ss_trap_64.  User code does MOV
> > (addr), SS; SYSCALL, where addr has a data breakpoint.  We get #DB
> > promoted to #VC with no stack.
>
> Also not an issue, as debugging is not supported at the moment in SEV-ES
> guests (hardware has no way yet to save/restore the debug registers
> across #VMEXITs). But this will change with future hardware. If you look
> at the implementation for dr7 read/write events, you see that the dr7
> value is cached and returned, but does not make it to the hardware dr7.

Eek.  This would probably benefit from some ptrace / perf logic to
prevent the kernel or userspace from thinking that debugging works.

I guess this means that #DB only happens due to TF or INT01.  I
suppose this is probably okay.

>
> I though about using IST for the #VC handler, but the implications for
> nesting #VC handlers made me decide against it. But for future hardware
> that supports debugging inside SEV-ES guests it will be an issue. I'll
> think about how to fix the problem, it probably has to be IST :(

Or future generations could have enough hardware support for debugging
that #DB doesn't need to be intercepted or can be re-injected
correctly with the #DB vector.

>
> Regards,
>
>         Joerg
