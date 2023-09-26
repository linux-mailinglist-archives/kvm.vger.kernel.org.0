Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E56F7AF041
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 18:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbjIZQIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 12:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjIZQI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 12:08:29 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5D8EB
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 09:08:23 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59e78032ef9so183139297b3.2
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 09:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695744502; x=1696349302; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KyxnAIoW1G5pdEuyAbRRbg9iBlyJHW/0NBQG/4V+f1o=;
        b=W97DJVDukTIwtkkfltlO1XRmm9cbZDWQX+fEHydGMOE6IBBkJAjT5wDFz0YvGE8Cxy
         QrUwvB0Dhu7vfarzZYd7i39wiBL6HxXpiCs261uuLtf6PrzG3D0cnr4q5dbS/1bYMiR5
         LiNAl6ubkSbUN56PYllysYSLqXtfCFYUMPzXddMhs9H7uRWuzJ56S4dQx/UK3aUy99X/
         GTf42VSf3oR/vVmBOrYTWDJql8RpulPSKOeXHG5UgEq/OXN8M9OXO6BHuvNY7HPCk1sD
         kUsdJWI4mcjlqLNVYePSnwfrnoTWJDlKutUeYCxBlfadCli+3ClXzo2P2mjJlmN/RrW7
         whJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695744502; x=1696349302;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KyxnAIoW1G5pdEuyAbRRbg9iBlyJHW/0NBQG/4V+f1o=;
        b=aB5bhcoqUU6zXM9JrHKMQLGP3Rzro3FSc6+x73xg+hTdX+IUpXn2kO3x+A/KBBQGOW
         ZGmrhbWLFPKZwYaetnlXIsw3zhVWAZHlgciQtnXtxGyZEFEhq3qFSlqRHFSa9dYGQfx2
         GlXXPDGTvu3jJBhjzeLTbXGVd0v88uJyfgJ+PufgAzAv976/fP5BcDhc3p3Tmspy5yfb
         NDWi9lyVsXhC67N2bedarUW0gBF+H6eBnrnTOnQmmk1bvKuaTCFM34L/wA3gN1gbmY4x
         ZZKcdVhtlmyd6YgB9ZqD2Nv/ilmfUIuyiIBh8U7mGLOSX6DL+5K++2fwTC3G/rzFWJEI
         9r4w==
X-Gm-Message-State: AOJu0YxU9eCVIWeYvs6oKu1/Y2Wc16NDUFDkUe9QewL98ToqD/VTWtlU
        KS5MWy5AU5OR7g+3oqILiTgn7MHbQ2M=
X-Google-Smtp-Source: AGHT+IFCNT03Fl/DyvP+QHiUraeNGj7vhZYtOevojhwX9aHC3Cs3iOljgeWptW/icXoPfKZLsjiJZnOy3R8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:7643:0:b0:59b:e663:23b9 with SMTP id
 j3-20020a817643000000b0059be66323b9mr131297ywk.1.1695744502364; Tue, 26 Sep
 2023 09:08:22 -0700 (PDT)
Date:   Tue, 26 Sep 2023 16:08:20 +0000
In-Reply-To: <CAGCz3vve7RJ+HE8sHOvq1p5-Wc4RpgZwqp0DiCXiSWq0vUpEVw@mail.gmail.com>
Mime-Version: 1.0
References: <20230923102019.29444-1-phil@philjordan.eu> <ZRGkqY+2QQgt2cVq@google.com>
 <CAGCz3vve7RJ+HE8sHOvq1p5-Wc4RpgZwqp0DiCXiSWq0vUpEVw@mail.gmail.com>
Message-ID: <ZRMB9HUIBcWWHtwK@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/apic: Gates test_pv_ipi on KVM cpuid,
 not test device
From:   Sean Christopherson <seanjc@google.com>
To:     Phil Dennis-Jordan <lists@philjordan.eu>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+KVM and Paolo

Please keep the mailing list Cc'd so that other can participate in the conv=
ersation,
and so that the mails are archived.

Adding Paolo, who I believe is still not subscribed to kvm@ :-)

On Tue, Sep 26, 2023, Phil Dennis-Jordan wrote:
> Hi Sean,
>=20
> Thanks for taking a look at this.
>=20
> On Mon, Sep 25, 2023 at 5:18=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > On Sat, Sep 23, 2023, Phil Dennis-Jordan wrote:
> > > +#define      X86_KVM_FEATURE_PV_SEND_IPI  (CPUID(0x40000001, 0, EAX,=
 11))
> >
> > We could actually define this using the uapi headers, then there's no n=
eed to
> > reference the kernel docs, e.g.
> >
> > #define         X86_FEATURE_KVM_PV_SEND_IPI (CPUID(KVM_CPUID_FEATURES, =
0, EAX, KVM_FEATURE_PV_SEND_IPI)
>=20
> That sounds sensible, but those symbols are #defined in headers that
> are currently only routinely available on Linux systems. I know this
> is the *KVM* unit test suite, but it's definitely also very useful
> elsewhere.
> (My specific motivation for the patch is that on macOS/HVF, Qemu's
> software APIC implementation is used. The current implementation for
> that turns out to be a massive perf bottleneck and very much
> not-spec-compliant, so I've been improving it. This test suite has
> been very useful for testing/verifying my work, but this IPI test had
> to be disabled.)

Ah, right.

> A few options I can think of:
>=20
> 1. I notice x86/hyperv.h has a bunch of similar #defines. We could
> collect only the KVM-related x86 constants and helper functions we
> actually need in a corresponding x86/kvm.h. I see there's a kvmclock.h
> for the KVM clock already - that could either be renamed and expanded
> in scope, or left separate.

kvmclock.h is essentially #2, it's a copy of arch/x86/include/asm/pvclock-a=
bi.h
from the kernel.

> 2. Bring a copy of the necessary KVM uapi header file(s) into the
> repo, slightly hacked up to cut down on transitive dependencies. It
> looks like lib/linux/*.h might already be similar instances for other
> Linux bits. Qemu also does this.

This has my vote, though I'd strongly prefer not to strip out anything unle=
ss it's
absolutely necessary to get KUT to compile.  Grabbing entire files should m=
ake it
easier to maintain the copy+pasted code as future updates to re-sync will h=
opefully
add just the new features.

The attached half-baked patch adds everything except the base "is this KVM?=
"
check and has only been compile tested on x86, feel free to use it as a sta=
rting
point (I wanted to get the basic gist compiling to make sure I wasn't leadi=
ng you
completely astray)

> > > +             && (c.a >=3D 0x40000001 || c.a =3D=3D 0);
> >
> > Why allow 0?  Though I think we probably forego this check entirely.
>=20
> "Note also that old hosts set eax value to 0x0. This should be
> interpreted as if the value was 0x40000001. " according to
> https://www.kernel.org/doc/html/v5.7/virt/kvm/cpuid.html
> Though I suppose "old hosts" are probably VERY old and probably don't
> expose the IPI hypercall=E2=80=A6

Ha, so your the one that reads the documentation ;-)

> > > @@ -658,8 +663,10 @@ static void test_pv_ipi(void)
> > >       int ret;
> > >       unsigned long a0 =3D 0xFFFFFFFF, a1 =3D 0, a2 =3D 0xFFFFFFFF, a=
3 =3D 0x0;
> > >
> > > -     if (!test_device_enabled())
> > > +     if (!is_kvm_ipi_hypercall_supported()) {
> >
> > I would rather open code the two independent checks, e.g.
> >
> >         if (!is_hypervisor_kvm() || !this_cpu_has(X86_FEATURE_KVM_PV_SE=
ND_IPI))
>=20
> Makes sense, especially so we don't have to keep rechecking whether
> we're on KVM in case we end up testing for more KVM feature flags at
> some point.
>=20
> > Or alternatively, provide a generic helper in processor.h to handle the=
 hypervisor
> > check, e.g.
> >
> >   static inline this_cpu_has_kvm_feature(...)
> >
> > Though if we go that route it probably makes sense to play nice with re=
locating
> > the base since it would be quite easy to do so.
>=20
> Probably overkill as long as we only have this one instance?

Yeah, probably.
