Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4FC6A0F60
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 19:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjBWSYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 13:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjBWSYC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 13:24:02 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666984346F
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 10:23:58 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id d7-20020a056a0010c700b005a8ee90fbc6so5749161pfu.4
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 10:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cPNG5uIkry6SPqM4BN2SEB/cHBlElEpC9OaRo7SwP1M=;
        b=bYsrefngLcy0tfHlns6aMlsdH2oIXTPT7lCylB/IL5DVPx4RFU9eL+p5YVECAPtS2s
         usebFCow9QCqMP5Aq02575uRXKS0mk//xQRfDBsRpRdC2zmDEyg2ryuBNb/sp+DPWgwF
         VuLa1AcmuUwAE3iCUPltPHtYeTAZILzvYPi2vnJHhG0/8yhA2WDigL3Zx02Bro1ht/wk
         s8xh5/L//ScWeIcEScF2iwWK8oEw3PkhR9lUeMjlbwQX3a8MxONyGn4ttyjC8lyqJYZ/
         JY6qaBvtT0VySspOSF5NLPqjE3eDxO/SX5MhEIUMI9EksUAeRqergYUfiuOc1l/z/1f1
         4c7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cPNG5uIkry6SPqM4BN2SEB/cHBlElEpC9OaRo7SwP1M=;
        b=Kf7kj+KlvV+5ky00WJ1wuzJ71wi0niDRhkfb24lQAeYJ8JMd/Y/2IUFt3MZ4pycZa6
         RIrXkrwaZQReqf5wPpZ2aS0NOs5vL857OJ1lgAOmo5RHxvNrrkflXOwEMofoPsVTRFgd
         jNlmD/93Epr5ptu0PKBBiaw1BLnezvFXLUkbW7J2cNP74ZxKJf0cH7e1+PaIqLioBC76
         OqHoKzMe25ignXqzz7SW4Nm82nbj1SXz4ilTKWL3Pn/L5xofhxzeDo5uWvbgkOpuJTKH
         aT0+xUQeK8N6PmeN79y5JRZwBTKJO/oIursAkaTkvDe5UgbxsXsLCut3rj1yBE99Olc5
         uWmg==
X-Gm-Message-State: AO0yUKUEn+rBFE6qO98xXux4NiERp+ituJ3pDoeLs2c/fdXFED0wbtY1
        tBMSGsaByWU+IEf5KxG6M412ABY2vSI=
X-Google-Smtp-Source: AK7set/qgsnXlcUCBL6IPFbm1InDpYCFgJKykWmAkZmrH7WbhMO1WH0I80dbu7seLELSE2a0nC1NZ0yIDIg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8a53:0:b0:593:dc61:2161 with SMTP id
 n19-20020aa78a53000000b00593dc612161mr1985673pfa.2.1677176637799; Thu, 23 Feb
 2023 10:23:57 -0800 (PST)
Date:   Thu, 23 Feb 2023 10:23:56 -0800
In-Reply-To: <CAOUHufYw9Mc-w1E-Jkqnt869bVJ0AxOB5_grSEMcdMdDODDdCw@mail.gmail.com>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-3-yuzhao@google.com>
 <Y++q/lglE6FJBdjt@google.com> <CAOUHufaK-BHdajDZJKjn_LU-gMkUTKa_9foMB8g-u9DyrVhPwg@mail.gmail.com>
 <Y/ed0XYAPx+7pukA@google.com> <CAOUHufYw9Mc-w1E-Jkqnt869bVJ0AxOB5_grSEMcdMdDODDdCw@mail.gmail.com>
Message-ID: <Y/evPJg9gvXxO1hs@google.com>
Subject: Re: [PATCH mm-unstable v1 2/5] kvm/x86: add kvm_arch_test_clear_young()
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 23, 2023, Yu Zhao wrote:
> On Thu, Feb 23, 2023 at 10:09=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > I'll take a look at that series. clear_bit() probably won't cause any
> > > practical damage but is technically wrong because, for example, it ca=
n
> > > end up clearing the A-bit in a non-leaf PMD. (cmpxchg will just fail
> > > in this case, obviously.)
> >
> > Eh, not really.  By that argument, clearing an A-bit in a huge PTE is a=
lso technically
> > wrong because the target gfn may or may not have been accessed.
>=20
> Sorry, I don't understand. You mean clear_bit() on a huge PTE is
> technically wrong? Yes, that's what I mean. (cmpxchg() on a huge PTE
> is not.)
>=20
> > The only way for
> > KVM to clear a A-bit in a non-leaf entry is if the entry _was_ a huge P=
TE, but was
> > replaced between the "is leaf" and the clear_bit().
>=20
> I think there is a misunderstanding here. Let me be more specific:
> 1. Clearing the A-bit in a non-leaf entry is technically wrong because
> that's not our intention.
> 2. When we try to clear_bit() on a leaf PMD, it can at the same time
> become a non-leaf PMD, which causes 1) above, and therefore is
> technically wrong.
> 3. I don't think 2) could do any real harm, so no practically no problem.
> 4. cmpxchg() can avoid 2).
>=20
> Does this make sense?

I understand what you're saying, but clearing an A-bit on a non-leaf PMD th=
at
_just_ got converted from a leaf PMD is "wrong" if and only if the intented
behavior is nonsensical.

Without an explicit granluarity from the caller, the intent is to either (a=
) reap
A-bit on leaf PTEs, or (b) reap A-bit at the highest possible granularity. =
 (a) is
nonsensical because because it provides zero guarantees to the caller as to=
 the
granularity of the information.  Leaf vs. non-leaf matters for the life cyc=
le of
page tables and guest accesses, e.g. KVM needs to zap _only_ leaf SPTEs whe=
n
handling an mmu_notifier invalidation, but when it comes to the granularity=
 of the
A-bit, leaf vs. non-leaf has no meaning.  On KVM x86, a PMD covers 2MiB of =
GPAs
regardless of whether it's a leaf or non-leaf PMD.

If the intent is (b), then clearing the A-bit on a PMD a few cycles after t=
he PMD
was converted from leaf to non-leaf is a pointless distinction, because it =
yields
the same end result as clearing the A-bit just a few cycles earlier, when t=
he PMD
was a leaf.

Actually, if I'm reading patch 5 correctly, this is all much ado about noth=
ing,
because the MGLRU code only kicks in only for non-huge PTEs, and KVM cannot=
 have
larger mappings than the primary MMU, i.e. should not encounter huge PTEs.

On that topic, if the assumption is that the bitmap is used only for non-hu=
ge PTEs,
then x86's kvm_arch_test_clear_young() needs to be hardened to process only=
 4KiB
PTEs, and probably to WARN if a huge PTE is encountered.  That assumption s=
hould
also be documented.

If that assumption is incorrect, then kvm_arch_test_clear_young() is broken=
 and/or
the expected behavior of the bitmap isn't fully defined.
