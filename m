Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A977744535
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 01:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbjF3XZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 19:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjF3XZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 19:25:19 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EA83ABF
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 16:25:18 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-4007b5bafceso46381cf.1
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 16:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688167517; x=1690759517;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRZBR1MXCGtC/KqowoCPSF3f5NCSbXaaOajzWQJNWJE=;
        b=3w+IlVFuqN4dTutQAdWH6XZRaPMWjmINBQKH71yY/CEg6R4ymY/CsIsebMyTJHHEa0
         4FGT4mVBt7qBrU9BF1Q0lexumPsrJoTwzhinXqJWDF7+QHWQo1y5PC2L4R9kzhlsONah
         g9xLC9f3pi/ozoGhJOtMq9UNQ+L2t4F9dU+6gOYWA+F9GM97AS7vDwDtayN99pJVz87k
         DhVn4PmC59ya5P/kM9K9LPy2bcn/ymAxPOC///bcEN7AVfq7j7fFZ69om7k1k0BrqxRO
         37Wp3oBnhK2tNDoC9U6fuyNgE1KVRel8DfaPfboczkOmAfZHy0WTH0LbiMv+hk0Znrkw
         aHdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688167517; x=1690759517;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MRZBR1MXCGtC/KqowoCPSF3f5NCSbXaaOajzWQJNWJE=;
        b=O3XvuI50MgmPMt3fwEv5tNaKFQWrQIYobgwihvwrg2lFY4RCLpt5lJNs9R6KBKQUD7
         nElnQm6oDHlXARC2dm8sU6jPpvTKEMqHX0+VxrIifbU4RaXb0+X2NQ6GkwVKabd+iaL6
         oASGAK+5cveYjd+kHXnnqbRlF5lsA5dQ4z8g8LwtPfW9byZ/SEkDrGT0UQm27smf/4mA
         jWdeG9umO15jEDD4jfWTYd4YPcDXQDLqHwjufXK5DrPNuLQ6jWmx6VS3cLRCutWrfiDz
         kMtqv2speMlLVRUoSpVq2if00jHq5ExMp1VCHsL/QargmojVjzjpVzM40TA9VczlbOSW
         c5Jg==
X-Gm-Message-State: ABy/qLawc6tUUFwlKJaFhhuDt5Q0FEB31cp3nVXAUKGX1hFW/9WD856X
        lFbQ3RkMjf+7yZPq0pFsgPT+gI/kYWYTRgcQl2cUeA==
X-Google-Smtp-Source: APBJJlG3H0yLq9Mo8JakTju+Ox/t3X10r0wrjSSjQozofKT+Tnv2U/AwUqxQEIK8IEpdc3j94yNRwVGFN0OOEqgOlsw=
X-Received: by 2002:a05:622a:120a:b0:3f8:6685:c944 with SMTP id
 y10-20020a05622a120a00b003f86685c944mr87105qtx.14.1688167517187; Fri, 30 Jun
 2023 16:25:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230504120042.785651-1-rkagan@amazon.de> <ZH6DJ8aFq/LM6Bk9@google.com>
 <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com>
 <ZJ4dmrQSduY8aWap@google.com> <ZJ65CiW0eEL2mGg8@u40bc5e070a0153.ant.amazon.com>
 <ZJ7mjdZ8h/RSilFX@google.com> <ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com>
 <CALMp9eSNoHoAB4ZnMTZqvc8h2O8VL7RkLkSDeS-PSGi7usZ+TA@mail.gmail.com>
In-Reply-To: <CALMp9eSNoHoAB4ZnMTZqvc8h2O8VL7RkLkSDeS-PSGi7usZ+TA@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 30 Jun 2023 16:25:06 -0700
Message-ID: <CALMp9eTY0PrH5QrrGdsxGh8X7S0pqHV7h1-Dk3xeDy9b4jd0+A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
To:     Roman Kagan <rkagan@amazon.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Like Xu <likexu@tencent.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 9:40=E2=80=AFAM Jim Mattson <jmattson@google.com> w=
rote:
>
> On Fri, Jun 30, 2023 at 8:21=E2=80=AFAM Roman Kagan <rkagan@amazon.de> wr=
ote:
> >
> > On Fri, Jun 30, 2023 at 07:28:29AM -0700, Sean Christopherson wrote:
> > > On Fri, Jun 30, 2023, Roman Kagan wrote:
> > > > On Thu, Jun 29, 2023 at 05:11:06PM -0700, Sean Christopherson wrote=
:
> > > > > @@ -74,6 +74,14 @@ static inline u64 pmc_read_counter(struct kvm_=
pmc *pmc)
> > > > >         return counter & pmc_bitmask(pmc);
> > > > >  }
> > > > >
> > > > > +static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 va=
l)
> > > > > +{
> > > > > +       if (pmc->perf_event && !pmc->is_paused)
> > > > > +               perf_event_set_count(pmc->perf_event, val);
> > > > > +
> > > > > +       pmc->counter =3D val;
> > > >
> > > > Doesn't this still have the original problem of storing wider value=
 than
> > > > allowed?
> > >
> > > Yes, this was just to fix the counter offset weirdness.  My plan is t=
o apply your
> > > patch on top.  Sorry for not making that clear.
> >
> > Ah, got it, thanks!
> >
> > Also I'm now chasing a problem that we occasionally see
> >
> > [3939579.462832] Uhhuh. NMI received for unknown reason 30 on CPU 43.
> > [3939579.462836] Do you have a strange power saving mode enabled?
> > [3939579.462836] Dazed and confused, but trying to continue
> >
> > in the guests when perf is used.  These messages disappear when
> > 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions") is
> > reverted.  I haven't yet figured out where exactly the culprit is.
>
> Maybe this is because KVM doesn't virtualize
> IA32_DEBUGCTL.Freeze_PerfMon_On_PMI?

Never mind. Linux doesn't set IA32_DEBUGCTL.Freeze_PerfMon_On_PMI.

> Consider:
>
> 1. PMC0 overflows, GLOBAL_STATUS[0] is set, and an NMI is delivered.
> 2. Before the guest's PMI handler clears GLOBAL_CTRL, PMC1 overflows,
> GLOBAL_STATUS[1] is set, and an NMI is queued for delivery after the
> next IRET.
> 3. The guest's PMI handler clears GLOBAL_CTRL, reads 3 from
> GLOBAL_STATUS, writes 3 to GLOBAL_OVF_CTRL, re-enables GLOBAL_CTRL,
> and IRETs.
> 4. The queued NMI is delivered, but GLOBAL_STATUS is now 0. No one
> claims the NMI, so we get the spurious NMI message.
>
> I don't know why this would require counting the retirement of
> emulated instructions. It seems that hardware PMC overflow in the
> early part of the guest's PMI handler would also be a problem.
>
> > Thanks,
> > Roman.
> >
> >
> >
> > Amazon Development Center Germany GmbH
> > Krausenstr. 38
> > 10117 Berlin
> > Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> > Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> > Sitz: Berlin
> > Ust-ID: DE 289 237 879
> >
> >
> >
