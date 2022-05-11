Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2185F522E4A
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 10:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243610AbiEKIYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 04:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243621AbiEKIYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 04:24:15 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6DC6BFC4;
        Wed, 11 May 2022 01:24:14 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id p4so1429651qtq.12;
        Wed, 11 May 2022 01:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2UJ8TdG/ZXkqli01Tzw/46lE+X6BSAjmpr/x155Uyss=;
        b=i37TjzU3Q0df21D/YSmpH4Cczrmk/TIUCBWZVXfvj5f/11h9d7E4AKQvb019JQAoRA
         OLg0ePSg0Bwrwnse+0UP/BV7VPDlkmOf+gRE1+fOJoc80xn2EI2lAK9pTDPTTsMIFQeS
         evcTy6e6VDdeTmKAQWp/7vg6kXy9TjgWZi3slqEyS3L2Ng29DnIKLADDKCr4aQUbGfNV
         rKSzrCusuhjpmNDXlP86oDKTFkpb6FT78AHnorHZDPSWSWwdeG/7Qi8GmRogVyg7SbUD
         AOWlUDXeyrOaKLZeo+QJaiTGq45/oRcJowsJJpEzAFHsA3QNd0ggX2YqFYIsgi1nqGlG
         54yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2UJ8TdG/ZXkqli01Tzw/46lE+X6BSAjmpr/x155Uyss=;
        b=Eik1Rv04SlWxi8eRWgh1amzE7q4P4P5X9BKf3GH8SmXsiDQr91xcGuECzZytZbEoI7
         H1c+Vp/TND2SvIbFLDQ/zrz5xi/QTODeHLLchIe6fM9RYm0i3u50AGVTwR0Jt4jECSUV
         jLfiupwhrbD084HzwjDde/D8WLYF21M59QDv1Tq0r1Es5uZMrmuQqGhPDYHpPqLz0Phv
         y/B/d3nfGaDIgLX2dzHseDwSfN6F0bl+ZovMWnKq1uFyj6JBBltMDVmrFSRkWpbSCgcw
         tK9AvY1bXWa0tlrTCe7askZPZ/XX1bE/fycBOkK3AMVj2ErWuuJ7sq6UcWPhwaLqUP43
         +Eqw==
X-Gm-Message-State: AOAM530Ldh6sjz813C14cMpxwrmLcVCKl2lrmwHZiJk7xQWzVZah3Mgy
        ieRdV7ew85BeY1NSUZfhuKAxF9wcnV3BgDxpGXY=
X-Google-Smtp-Source: ABdhPJw4ywOeI32gajTbIkB0BZZFunlxMOAeg9x8fyw2kMFA6AF0u5HdvgUXY7k1gDEZblvj8mGuCkqdXldSq4SpvkQ=
X-Received: by 2002:ac8:7e81:0:b0:2f3:d195:ace0 with SMTP id
 w1-20020ac87e81000000b002f3d195ace0mr17510587qtj.5.1652257453406; Wed, 11 May
 2022 01:24:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220510154217.5216-1-ubizjak@gmail.com> <20220510165506.GP76023@worktop.programming.kicks-ass.net>
 <CAFULd4aNME5s2zGOO0A11kdjfHekH=ceSH7jUfAhmZaJWHv9cQ@mail.gmail.com> <20220511075409.GX76023@worktop.programming.kicks-ass.net>
In-Reply-To: <20220511075409.GX76023@worktop.programming.kicks-ass.net>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Wed, 11 May 2022 10:24:02 +0200
Message-ID: <CAFULd4aXpt_pnCR5OK5B1m5sErfB3uj_ez=-KW7=0qQheEdVzA@mail.gmail.com>
Subject: Re: [PATCH] locking/atomic/x86: Introduce try_cmpxchg64
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 11, 2022 at 9:54 AM Peter Zijlstra <peterz@infradead.org> wrote=
:
>
> On Tue, May 10, 2022 at 07:07:25PM +0200, Uros Bizjak wrote:
> > On Tue, May 10, 2022 at 6:55 PM Peter Zijlstra <peterz@infradead.org> w=
rote:
> > >
> > > On Tue, May 10, 2022 at 05:42:17PM +0200, Uros Bizjak wrote:
> > > > This patch adds try_cmpxchg64 to improve code around cmpxchg8b.  Wh=
ile
> > > > the resulting code improvements on x86_64 are minor (a compare and =
a move saved),
> > > > the improvements on x86_32 are quite noticeable. The code improves =
from:
> > >
> > > What user of cmpxchg64 is this?
> >
> > This is cmpxchg64 in pi_try_set_control from
> > arch/x86/kvm/vmx/posted_intr.c, as shown in a RFC patch [1].
>
> I can't read that code, my brain is hard wired to read pi as priority
> inheritance/inversion.
>
> Still, does 32bit actually support that stuff?

Unfortunately, it does:

kvm-intel-y        +=3D vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.=
o \
               vmx/evmcs.o vmx/nested.o vmx/posted_intr.o

And when existing cmpxchg64 is substituted with cmpxchg, the
compilation dies for 32bits with:

error: call to =E2=80=98__cmpxchg_wrong_size=E2=80=99 declared with attribu=
te error:
Bad argument size for cmpxchg

So, the majority of the patch deals with 32bits and tries to implement
the inlined insn correctly for all cases. The 64bit part is simply a
call to arch_try_cmpxchg, and the rest is auto-generated from scripts.

>
> > There are some more opportunities for try_cmpxchg64 in KVM, namely
> > fast_pf_fix_direct_spte in arch/x86/kvm/mmu/mmu.c and
> > tdp_mmu_set_spte_atomic in arch/x86/kvm/mmu/tdp_mmu.c
>
> tdp_mmu is definitely 64bit only and as such shouldn't need to use
> cmpxchg64.

Indeed.

>
> Anyway, your patch looks about right, but I find it *really* hard to
> care about 32bit code these days.

Thanks, this is also my sentiment, but I hope the patch will enable
better code and perhaps ease similar situation I have had elsewhere.

Uros.

On Wed, May 11, 2022 at 9:54 AM Peter Zijlstra <peterz@infradead.org> wrote=
:
>
> On Tue, May 10, 2022 at 07:07:25PM +0200, Uros Bizjak wrote:
> > On Tue, May 10, 2022 at 6:55 PM Peter Zijlstra <peterz@infradead.org> w=
rote:
> > >
> > > On Tue, May 10, 2022 at 05:42:17PM +0200, Uros Bizjak wrote:
> > > > This patch adds try_cmpxchg64 to improve code around cmpxchg8b.  Wh=
ile
> > > > the resulting code improvements on x86_64 are minor (a compare and =
a move saved),
> > > > the improvements on x86_32 are quite noticeable. The code improves =
from:
> > >
> > > What user of cmpxchg64 is this?
> >
> > This is cmpxchg64 in pi_try_set_control from
> > arch/x86/kvm/vmx/posted_intr.c, as shown in a RFC patch [1].
>
> I can't read that code, my brain is hard wired to read pi as priority
> inheritance/inversion.
>
> Still, does 32bit actually support that stuff?

Unfortunately, it does:

kvm-intel-y        +=3D vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.=
o \
               vmx/evmcs.o vmx/nested.o vmx/posted_intr.o

And when cmpxchg64 is substituted with cmpxchg, the compilation dies
for 32bits with:

error: call to =E2=80=98__cmpxchg_wrong_size=E2=80=99 declared with attribu=
te error:
Bad argument size for cmpxchg

So, the majority of the patch deals with 32bits and tries to implement
the inlined insn correctly for all cases. The 64bit part is simply a
call to arch_try_cmpxchg, and the rest is auto-generated from scripts.

>
> > There are some more opportunities for try_cmpxchg64 in KVM, namely
> > fast_pf_fix_direct_spte in arch/x86/kvm/mmu/mmu.c and
> > tdp_mmu_set_spte_atomic in arch/x86/kvm/mmu/tdp_mmu.c
>
> tdp_mmu is definitely 64bit only and as such shouldn't need to use
> cmpxchg64.

Indeed.

>
> Anyway, your patch looks about right, but I find it *really* hard to
> care about 32bit code these days.

Thanks, this is also my sentiment, but I hope the patch will enable
better code and perhaps ease a similar situation elsewhere in the
sources.

Uros.
