Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123836D4DEA
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbjDCQdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbjDCQdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:33:12 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51B61997;
        Mon,  3 Apr 2023 09:33:08 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id ix20so28602481plb.3;
        Mon, 03 Apr 2023 09:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680539588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/JyY9VZwYc39EnA1aZWuXOPQGLxKvuatHXzEFodZCZQ=;
        b=FACJfAv6gr+vK3e3XeLN4xvpkGnKPBmnv+fv9jvnfnCHgf1bczHB6AYubASZaeKnWO
         rNNLZE8IYRJ8BRbD/fGBhWTtRFr3kbxLQ2xZm5LIjwTrnobuLcRsF8oLHPd9FFDE798F
         xwQG589j0RfUlH8NV2IT1h5SUeHtadiEVA1anBsEmyeoUrEP9NQoL2K1rl0CH2YyBYQX
         iosbiKl+uG6JEkZ0gGwW2PZhs5seT17+QAjCwCRmZqpEsomA3wV9DiXEKnPA0Q8gFISG
         BbZtS2wxXdRwc5mpG6kJxKWbjjDpI9JOyMmNvUEM2h8g5h+Sv/L25nAcudz8NqBFkMpL
         R7jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680539588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/JyY9VZwYc39EnA1aZWuXOPQGLxKvuatHXzEFodZCZQ=;
        b=zFendd71o5w/I1uyQsCZh+626pPfKau5PGtWEg/KYMx49mfBZV55m0vAiYNTgMgdpW
         QSCYyEBKF2ZxIeSwMwndjTLq+uzM8lQftObxFIGoXkqdbV3RaaQZ35K4BepCEXQv3y91
         8RqKkZwAmPLyvpJj1Na2eyWkoJ8hjgRT/wt0nZ431O7gpTY6v1zxYexAcE/Ezv49/7QC
         N4LJvI4SU3MNZYU7OvmYuaF2E7zSf1SfSxx73ArhTSV/w8jwWxIPMTENIPt9Pdyw75Ma
         plK4zCWwbYXrBcbL724fO+nrq7UAx6La5kvlIsVVLbLGewq06HFpwc06cVUIt53I1FNe
         F4OQ==
X-Gm-Message-State: AAQBX9e43qGHgsRORiGDcsCl9bu7MfqF6glBVx9s0EykL62c69kZECCJ
        cI+0TZ7eCv+pGZ6b5Jisqu+Yq7lQgfZkXMNMPXM=
X-Google-Smtp-Source: AKy350bsjMqV4NZgmlAE2raeLsIsDcysn41kaYxCjcPrDjA9fvGH+CkiSf3cG9CL3vzkpEB75b+yuh9BvTkAmAFp99U=
X-Received: by 2002:a17:902:ef94:b0:1a1:c109:3700 with SMTP id
 iz20-20020a170902ef9400b001a1c1093700mr12819974plb.7.1680539587819; Mon, 03
 Apr 2023 09:33:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230403140605.540512-1-jiangshanlai@gmail.com> <700a9c1b-5967-4e0c-0a15-8e2ab968dac6@intel.com>
In-Reply-To: <700a9c1b-5967-4e0c-0a15-8e2ab968dac6@intel.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 4 Apr 2023 00:32:55 +0800
Message-ID: <CAJhGHyBSxZbsjkaZ-zkVUJ6fkcpAKEszxLh49VZQ3hxO95Cn6g@mail.gmail.com>
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

On Mon, Apr 3, 2023 at 10:23=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 4/3/23 07:05, Lai Jiangshan wrote:
> > 2.3 #VE
> > -------
> >
> > The approach for fixing the kernel mode #VE recursion issue is to just
> > NOT use IST for #VE although #VE is also considered to be one of the
> > super exceptions and had raised some worries:
> > https://lore.kernel.org/lkml/YCEQiDNSHTGBXBcj@hirez.programming.kicks-a=
ss.net/
> > https://lore.kernel.org/lkml/CALCETrU9XypKbj-TrXLB3CPW6=3DMZ__5ifLz0ckb=
B=3Dc=3DMyegn9Q@mail.gmail.com/
> > https://lore.kernel.org/lkml/1843debc-05e8-4d10-73e4-7ddce3b3eae2@intel=
.com/
> >
> > To remit the worries,  SEPT_VE_DISABLE is forced used currently and
> > also disables its abilities (accept-on-demand or memory balloon which
> > is critical to lightweight VMs like Kata Containers):
> > https://lore.kernel.org/lkml/YCb0%2FDg28uI7TRD%2F@google.com/
>
> You don't need #VE for accept-on-demand.  Pages go through _very_
> well-defined software choke points before they get used *and* before
> they get ballooned.  Thus:
>
> > https://lore.kernel.org/lkml/20230330114956.20342-3-kirill.shutemov@lin=
ux.intel.com/
>

Thanks for the information.

I will have a look to see how it supports memory balloons.

And if accept-on-demand were supported, do we still need this
CONFIG_UNACCEPTED_MEMORY?

> BTW, _who_ considers #VE to be a "super exception"?  Can you explain how
> it is any more "super" than #PF?  #PF can recurse.  You can take #PF in
> the entry paths.
>
> I kinda don't think you should be using TDX and #VE as part of the
> justification for this series.

You are right, #VE is not a super exception anymore since SEPT_VE_DISABLE
is forced set in the Linux kernel and it is nothing to do with this series.

But #VE was once thought to be a super exception (I will correct the
sentence in the cover letter), so it is worth mentioning it.

And since SEPT_VE_DISABLE is configurable, it would allow some paranoids
to have a try with SEPT_VE_DISABLE=3Dfalse even without FRED.
The paranoids can try it with IST #VE.

Thanks
Lai
