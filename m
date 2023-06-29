Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B17E742F60
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 23:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbjF2VRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 17:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbjF2VRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 17:17:06 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65D9CA
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 14:17:05 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-401d1d967beso88271cf.0
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 14:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688073424; x=1690665424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H9QgpyZtEqZsVI1wel0QxxMtg/ImPrZn0pSFmPj7TqY=;
        b=i+fXCRXqoonLzaJlMJPBNfPKqupDRkY/fTWaf+YUw9O/vT/TtCi+zNt2yQYqw0OQ27
         ZOTRaJx082vwySAsb8DaVM+XgLl07S2LVyJ+lezRdTop5/+hulSpeaxES4fmfhIkobs8
         CJy5ygg43INLmfyPGF3rjeLU9qYgy/3Kbk6npBeBnMNSqRSXx5HbiQI/cS4iCnFsW+n3
         DHHPV8OMEmH394H3DjWJIuqScRMqRdfBaMkVzgcR9skD8IHaUZyOpycI1pnBRXgmscWL
         Doo+LgiuFf3dtMKeD6vg5HYzYXIv4PLD+QBtjrb/1KiKES3CNyBHDbLfF8pSMxcu7Nbr
         B7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688073425; x=1690665425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H9QgpyZtEqZsVI1wel0QxxMtg/ImPrZn0pSFmPj7TqY=;
        b=jHmn3wsJSGVMkeC6CjvN0FIzhVABnMAt3scboSxCOIqImDX/+FdQC046FAuwhaHozr
         tBc+wm1JwM/T6WWbZF/h4HEdRHRHPmians13+Hg0QGF5RVH7xnKvqq6SwqHDQaCjfeqF
         KNQN5skz2yciSEN/ctC2p2YYSqklSMxjFswLxBm46k31E+gZb0MYrqsgIfLOGffWFY/z
         7pJtqn+VMgcWMpCBEhWv0s1KlLCH3uWDFvySo7t+HTHeuoM3oDhH1RrAa+7Xr+eZ4PO3
         hlAXITPSvihxsQkUmYq/se89YuTA6RrFsvi6xGLUbY00xwaSkVW2uyB6lgZJ4aFSFjdG
         qUFw==
X-Gm-Message-State: AC+VfDxMIP4ZjmwYqmXV08GSDtdJwmD7c02kHF36IMV320gsnXy4dvhn
        xA0A6ITHqUbWaE9Z8cba4uaXX1oTjDcHvK7FuI1GZQ==
X-Google-Smtp-Source: ACHHUZ618sn0IJKESOcga0FN8MSV0AQbJD2b3s/6C/JNYw27A8mDjGbGlf3fvrXVjzvb3nz9A15eXzEA0ZJIFUQhN1Y=
X-Received: by 2002:ac8:5843:0:b0:3f9:a986:f3a4 with SMTP id
 h3-20020ac85843000000b003f9a986f3a4mr589397qth.25.1688073424559; Thu, 29 Jun
 2023 14:17:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230504120042.785651-1-rkagan@amazon.de> <ZH6DJ8aFq/LM6Bk9@google.com>
In-Reply-To: <ZH6DJ8aFq/LM6Bk9@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 29 Jun 2023 14:16:53 -0700
Message-ID: <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>
Cc:     Roman Kagan <rkagan@amazon.de>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Like Xu <likexu@tencent.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>
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

On Mon, Jun 5, 2023 at 5:51=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, May 04, 2023, Roman Kagan wrote:
> > diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> > index 5c7bbf03b599..6a91e1afef5a 100644
> > --- a/arch/x86/kvm/pmu.h
> > +++ b/arch/x86/kvm/pmu.h
> > @@ -60,6 +60,12 @@ static inline u64 pmc_read_counter(struct kvm_pmc *p=
mc)
> >       return counter & pmc_bitmask(pmc);
> >  }
> >
> > +static inline void pmc_set_counter(struct kvm_pmc *pmc, u64 val)
> > +{
> > +     pmc->counter +=3D val - pmc_read_counter(pmc);
>
> Ugh, not your code, but I don't see how the current code can possibly be =
correct.
>
> The above unpacks to
>
>         counter =3D pmc->counter;
>         if (pmc->perf_event && !pmc->is_paused)
>                 counter +=3D perf_event_read_value(pmc->perf_event,
>                                                  &enabled, &running);
>         pmc->counter +=3D val - (counter & pmc_bitmask(pmc));
>
> which distills down to
>
>         counter =3D 0;
>         if (pmc->perf_event && !pmc->is_paused)
>                 counter +=3D perf_event_read_value(pmc->perf_event,
>                                                  &enabled, &running);
>         pmc->counter =3D val - (counter & pmc_bitmask(pmc));
>
> or more succinctly
>
>         if (pmc->perf_event && !pmc->is_paused)
>                 val -=3D perf_event_read_value(pmc->perf_event, &enabled,=
 &running);
>
>         pmc->counter =3D val;
>
> which is obviously wrong.  E.g. if the guest writes '0' to an active coun=
ter, the
> adjustment will cause pmc->counter to be loaded with a large (in unsigned=
 terms)
> value, and thus quickly overflow after a write of '0'.

This weird construct goes all the way back to commit f5132b01386b
("KVM: Expose a version 2 architectural PMU to a guests"). Paolo
killed it in commit 2924b52117b2 ("KVM: x86/pmu: do not mask the value
that is written to fixed PMUs"), perhaps by accident. Eric then
resurrected it in commit 4400cf546b4b ("KVM: x86: Fix perfctr WRMSR
for running counters").

It makes no sense to me. WRMSR should just set the new value of the
counter, regardless of the old value or whether or not it is running.

> I assume the intent it to purge any accumulated counts that occurred sinc=
e the
> last read, but *before* the write, but then shouldn't this just be:
>
>         /* Purge any events that were acculumated before the write. */
>         if (pmc->perf_event && !pmc->is_paused)
>                 (void)perf_event_read_value(pmc->perf_event, &enabled, &r=
unning);
>
>         pmc->counter =3D val & pmc_bitmask(pmc);
>
> Am I missing something?
>
> I'd like to get this sorted out before applying this patch, because I rea=
lly want
> to document what on earth this new helper is doing.  Seeing a bizarre par=
tial
> RMW operation in a helper with "set" as the verb is super weird.
