Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB60E5A1DCF
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 02:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbiHZAvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 20:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiHZAvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 20:51:07 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5330CC8754
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 17:51:05 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id m66so265282vsm.12
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 17:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=0JrpajtekJvh71Rso/3aI0o/Auj8HCuqh9lk53mDmoI=;
        b=entdwi6GP0iJd2AnCMO31AfWW8zOCmhAS9at2OdNy6E92caHUoaGQEKydCUbCoIoxg
         VN8DdyPa3fJ9cQjlyP2409JiQZMLSHkb+vM4xQPNFItu/TO3tt1+apfdL1po2fwkT0W0
         GRg1Xzt4AY8pxjquXh4caIjjTdFpwMWGk688lRpI3bi7tCV7OpeSzysZQJFx7tjHni7C
         HGHW8vXzi6SSvBDNiAUcThQ/PpHRqZWerF/4uxfUJ4gixuTyi3zoJTicZ28c/rp1WYp7
         r5RIRgvrdd0EB/AFhGlvD2G3odBSIebVpAgZX2FluJOoJBdHn1R1UQI8pUk35ycqiy2Q
         JrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0JrpajtekJvh71Rso/3aI0o/Auj8HCuqh9lk53mDmoI=;
        b=sT8eXWYL6IJlB/4aozVswgINBC6q1cVM3Wp0he/7es4Fd/mX0F858ovJ28Lkjbq2WL
         iJhvZFIRrwxffc5o6GPbw7X7dNngdwwrSPg2VxKikh8NirbEPK75fFIoRJb23/Olw1j9
         fr10w083Ua6dA4v+SuK8U/tyiBX9oLmUwHmyVZ/huj5T4IccbFjtSKhZxLkxiSYtkdnV
         0FoXSsiRcH63hZdSCud3KcSViaGXafVbAPvTH22q0j8RnvbYNkc6bIX98yRbwa3rW64E
         yCI579ifCwtMfTc3c6ygrflu2AIt+xVQZwWGU2Ey3yaBtyNmyf7H6UcM+lzbKOjTWA8S
         PL4g==
X-Gm-Message-State: ACgBeo0ihPJoyvSnWDHMVRrcy5rmNLv2i65N71z1Fs8VVrNEI2N7kHqS
        735ppsw5Ot9r0jCVLmNiuaIt1lTq4pN8nIyigR7Gyw==
X-Google-Smtp-Source: AA6agR7p7Dit2ezx7YKW+encSK4TFrVerFoY/6em0zK1bdoztUQVx0haLRefCWKzReFCSOzdWGd2pyDhRpM+ThjkMxU=
X-Received: by 2002:a67:b009:0:b0:38a:e0f2:4108 with SMTP id
 z9-20020a67b009000000b0038ae0f24108mr2723225vse.9.1661475064402; Thu, 25 Aug
 2022 17:51:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com> <20220825050846.3418868-2-reijiw@google.com>
 <Ywen44OKe8gGcOcW@google.com> <Yweo5cmA6D0pxwmJ@google.com> <YweqIefFbP107fe+@google.com>
In-Reply-To: <YweqIefFbP107fe+@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 25 Aug 2022 17:50:48 -0700
Message-ID: <CAAeT=Fxza9hdqDNDDeHqXKwLW_K2aj-3E7Z5FL9eXH0Wpa3YcA@mail.gmail.com>
Subject: Re: [PATCH 1/9] KVM: arm64: selftests: Add helpers to extract a field
 of an ID register
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
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

Hi Oliver, Ricardo,

On Thu, Aug 25, 2022 at 9:58 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Thu, Aug 25, 2022 at 09:52:53AM -0700, Ricardo Koller wrote:
> > On Thu, Aug 25, 2022 at 09:48:35AM -0700, Oliver Upton wrote:
> > > Hi Reiji,
> > >
> > > On Wed, Aug 24, 2022 at 10:08:38PM -0700, Reiji Watanabe wrote:
> > > > Introduce helpers to extract a field of an ID register.
> > > > Subsequent patches will use those helpers.
> > > >
> > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > ---
> > > >  .../selftests/kvm/include/aarch64/processor.h     |  2 ++
> > > >  .../testing/selftests/kvm/lib/aarch64/processor.c | 15 +++++++++++++++
> > > >  2 files changed, 17 insertions(+)
> > > >
> > > > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > > index a8124f9dd68a..a9b4b4e0e592 100644
> > > > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > > @@ -193,4 +193,6 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> > > >
> > > >  uint32_t guest_get_vcpuid(void);
> > > >
> > > > +int cpuid_get_sfield(uint64_t val, int field_shift);
> > > > +unsigned int cpuid_get_ufield(uint64_t val, int field_shift);
> > > >  #endif /* SELFTEST_KVM_PROCESSOR_H */
> > > > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > > > index 6f5551368944..0b2ad46e7ff5 100644
> > > > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > > > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > > > @@ -528,3 +528,18 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> > > >                  [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
> > > >                : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
> > > >  }
> > > > +
> > > > +/* Helpers to get a signed/unsigned feature field from ID register value */
> > > > +int cpuid_get_sfield(uint64_t val, int field_shift)
> > > > +{
> > > > + int width = 4;
> > > > +
> > > > + return (int64_t)(val << (64 - width - field_shift)) >> (64 - width);
> > > > +}
> > >
> > > I don't believe this helper is ever used.

I thought I was going to use this in the selftest for my ID register series.
(So, I originally would like to have similar helpers in cpufeture.h)
But, you are right. That test only extracts unsigned fields...

> > >
> > > > +unsigned int cpuid_get_ufield(uint64_t val, int field_shift)
> > > > +{
> > > > + int width = 4;
> > > > +
> > > > + return (uint64_t)(val << (64 - width - field_shift)) >> (64 - width);
> > > > +}
> > >
> > > I would recommend not open-coding this and instead make use of
> > > ARM64_FEATURE_MASK(). You could pull in linux/bitfield.h to tools, or do
> > > something like this:
> > >
> > >   #define ARM64_FEATURE_GET(ftr, val)                                       \
> > >               ((ARM64_FEATURE_MASK(ftr) & val) >> ftr##_SHIFT)
> > >
> > > Slight preference for FIELD_{GET,SET}() as it matches the field
> > > extraction in the kernel as well.
> >
> > Was doing that with this commit:
> >
> >       [PATCH v5 05/13] tools: Copy bitfield.h from the kernel sources
> >
> > Maybe you could just use it given that it's already reviewed.
>
> Oops, thanks for the reminder Ricardo! Yeah, let's go that route then.

Thank you for the information. I will use that instead.

Thank you,
Reiji
