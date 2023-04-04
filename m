Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53CED6D571A
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 05:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbjDDDRr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 23:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjDDDRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 23:17:45 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237A6FB;
        Mon,  3 Apr 2023 20:17:44 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso32594487pjb.2;
        Mon, 03 Apr 2023 20:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680578263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qs3Bti2bEU1Z0C12LLTnFbjadt184MNl6VTmS9vvdvA=;
        b=ULfEnAJ53opqKjbgs64Ovk34Ol+tT+bg9RrqVWjw5LWPaU60crwA/Zobsk3+pYV5aA
         M46unl3ZvJn82ASeNzWgz5+bbeBQZ4t1hXoOFc1BaXgjmuZPD7Vc4TsJ38962NntvHw3
         rLJc3LUDj9224mn8ipU1wZf2tN3en0ufLPwrNFWDusZ7bV9dcSe3Ixx3pIXByPGtECJM
         qA2CH/4ZC3vGVsnNHvY67wLIUB++z4OGo8madgRMnz5C8ogko/rNsvmjkT/Dx/60Q+rp
         Vvj36xMh/64sMAtVLRRiszVIV5lkkMjaWfkQ+QpJmQa1/COYKRW5dCWdk1AEklBJccPB
         qhjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680578263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qs3Bti2bEU1Z0C12LLTnFbjadt184MNl6VTmS9vvdvA=;
        b=vKCEwHulihQBSTQ33ksgv7N7aIdNOW2E0r/AGnIuqtKs84XedgxcvAr0FnifsfrKds
         HFQkZjEcyqNeZfdQbS/hibg6EWgL6VgJIyDksHX1KDh/rDjl71g+7BAcpwur72Dkpwyf
         eX3TxhjCyb081D//0yiqIixtpPnOGBT4PQ8rhuaZMl91hCvSuDSm1bJCUFiT/b0G6jPQ
         7dmKgmVPTxf4gBj8OKZW5MMwhh5B8ZUwAGYPpjPj2g/J+rdiqb1yu5qRTkM/GzjyHWmb
         SeFQuN5Tqj0Ho41fDcRWOdyn/WRiHMu/RQtBF7vOiUr5bOkxgT9es4Fc42MFOBaEuBHl
         Zirg==
X-Gm-Message-State: AAQBX9cgbL0zfLTl03qRDW9YNGjaPDCFoofOl6reudxJCrpzVcvj1sL8
        tP6/Sz2MGfuEd9daOSygabwD1Kl+iDMwPRqbiSE=
X-Google-Smtp-Source: AKy350Y0s2OKMr8Zi4R8GDBxrLZ/SmmL9/HHXxE1OnPLUl0zIpMPn3gR4F/jXhV/vL6Y/ufbCfRBFSrSNyjXvbvAeXw=
X-Received: by 2002:a17:902:f683:b0:19f:1d62:4393 with SMTP id
 l3-20020a170902f68300b0019f1d624393mr446573plg.7.1680578263546; Mon, 03 Apr
 2023 20:17:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230403140605.540512-1-jiangshanlai@gmail.com> <19035c40-e756-6efd-1c02-b09109fb44c1@intel.com>
In-Reply-To: <19035c40-e756-6efd-1c02-b09109fb44c1@intel.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 4 Apr 2023 11:17:30 +0800
Message-ID: <CAJhGHyBHmC=UXr88GsykO9eUeqJZp59jrCH3ngkFiCxVBW2F3g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] x86/entry: Atomic statck switching for IST
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jiri Slaby <jslaby@suse.cz>, Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 4, 2023 at 12:53=E2=80=AFAM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 4/3/23 07:05, Lai Jiangshan wrote:
> >  Documentation/x86/kernel-stacks.rst   |   2 +
> >  arch/x86/entry/Makefile               |   3 +
> >  arch/x86/entry/entry_64.S             | 615 +++++++-------------------
> >  arch/x86/entry/ist_entry.c            | 299 +++++++++++++
> >  arch/x86/include/asm/cpu_entry_area.h |   8 +-
> >  arch/x86/include/asm/idtentry.h       |  15 +-
> >  arch/x86/include/asm/sev.h            |  14 -
> >  arch/x86/include/asm/traps.h          |   1 -
> >  arch/x86/kernel/asm-offsets_64.c      |   7 +
> >  arch/x86/kernel/callthunks.c          |   2 +
> >  arch/x86/kernel/dumpstack_64.c        |   6 +-
> >  arch/x86/kernel/nmi.c                 |   8 -
> >  arch/x86/kernel/sev.c                 | 108 -----
> >  arch/x86/kernel/traps.c               |  43 --
> >  arch/x86/kvm/vmx/vmx.c                | 441 +++++++++++++++++-
> >  arch/x86/kvm/x86.c                    |  10 +-
> >  arch/x86/mm/cpu_entry_area.c          |   2 +-
> >  tools/objtool/check.c                 |   7 +-
> >  18 files changed, 937 insertions(+), 654 deletions(-)
> >  create mode 100644 arch/x86/entry/ist_entry.c
>
> Some high-level comments...
>
> The diffstat looks a lot nastier because of the testing patch.  If you
> that patch and trim the diffstat a bit, it starts to look a _lot_ more
> appealing:
>
> >  arch/x86/entry/entry_64.S             |  615 ++++++++-----------------=
-----------
> >  arch/x86/entry/ist_entry.c            |  299 +++++++++++++++++
> >  arch/x86/kernel/sev.c                 |  108 ------
> >  arch/x86/kernel/traps.c               |   43 --
> ...
> >  16 files changed, 490 insertions(+), 650 deletions(-)
>
> It removes more code than it adds and also removes a bunch of assembly.
> If it were me posting this, I'd have shouted that from the rooftops
> instead of obscuring it with a testing patch and leaving it as an
> exercise to the reader to figure out.

The cover letter has 800+ lines of comments.  About 100-300 lines
of comments will be moved into the code which would make the diffstat
not so appealing.


P.S.

One of the reasons I didn't move them is that the comments are much more
complicated than the code which is a sign of improvement-required.

I'm going to change the narration from save-touch-replicate-copy-commit
to save-copy-build-commit and avoid using "replicate".

copy=3Dcopy_outmost(), build=3Dbuild_interrupted(), the new narration
will change the comments mainly, and it will not change the actual
work. If the new narration is not simpler, I will not send it out to
add any confusion.

>  * Flesh out the testing story.  What kind of hardware was this tested
>    on?  How much was bare metal vs. VMs, etc...?

It is tested on bare metal and VM.  It is hard to stress the bare
metal on atomic-IST-entry.  The testing code tests it in VM and the
super exceptions can be injected at will.

>  * Reinforce what the benefits to end users are here.  Are folks
>    _actually_ running into the #VC fragility, for instance?
>
> Also, let's say we queue this, it starts getting linux-next testing, and
> we start getting bug reports of hangs.  It'll have to get reverted if we
> can't find the bug fast.
>
> How much of a pain would it be to make atomic-IST-entry _temporarily_
> selectable at boot time?  It would obviously need to keep the old code
> around and would not have the nice diffstat.  But that way, folks would
> at least have a workaround while we're bug hunting.

It is easy to make atomic-IST-entry selectable at boot time since IDT
is an indirect table.  I will do it and temporarily keep the old code.
