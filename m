Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09B37ABA92
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 22:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjIVUfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 16:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjIVUfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 16:35:04 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113B71A2
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 13:34:58 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59e758d6236so41000097b3.1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 13:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695414897; x=1696019697; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yB+prA8r0oKCP57D5Xk55fy/VxijtGFIenaw/nUUgP4=;
        b=PPjKemNFzBlV5ZPUG75Wfc6aGFZlKrlltyKEB3ePYh+S9X6mXr+YQxSV8M52baItat
         DRw47TD2I8J1uR5eek/FGU9fA5brTlIr46d9cXbXgvKJMBGdr2e6F8E+7yDijU43Thfp
         rkDDjNjMCDvBJixwFi21NCcfiXiJo94s6zrS9OCszcywTtlkyAFBBus4zU3QOVNbpz9R
         IRdPFWVJtIspqqbKYIbYpSrUwKZ7McgfiKvdg0Mm2z8h8ea505VnGS22G5mhW3wzDHPP
         FqZkSCDUmxFobJiwooIyF9aYXmAaxZPKeZUBUBYEjOw2F1Q3gSiQoF3sBOZrPA/Ot4/d
         LVmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695414897; x=1696019697;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yB+prA8r0oKCP57D5Xk55fy/VxijtGFIenaw/nUUgP4=;
        b=uwEZA7qhQWGg8SMsd8FBCIym5Zm5eg0shxxugNfGUpRf1h3fGZ6DcTGm6I1v9wfGfA
         ChR3TSqyrurxXwGJf+EjoO5rljleasBbLxId7gP5wKM1QQUpGGFCH21XlpUL9ffhiGh+
         jvVdUMjZ6YOWA4arq/fcbNAZN3ffa8DTA85QktlV+43VYPcsZRN+WxHqI8A1jQSohvr1
         qwVWlDCQj+cKg6f3VHvescFpvq3wQRtIMX4iZCqwmuxyDzKM/kIEKOszQ92L2MU7GDdq
         A3weyHfnMZ2TNsDw8IaELnNGwSxvIWZ0VJ4I7xdTZTzEm/zqYiuJPl0z6X09ynpJ6S+t
         Tz/g==
X-Gm-Message-State: AOJu0YyK+Ohmugx3BVwt2M+NDLEFdvG/XJhsJBOuulQf3b6EIvU02qJi
        Oih2KfrX46Q0xhiryNBnmxDaxiUv+3Q=
X-Google-Smtp-Source: AGHT+IEZ2LQ+4Nw4BfZOu+cGWz3yzJyRqDWmXL70bWgNvbKkn4s9EygwTUVdXQoSZrt4/62zyciDzJgKnpY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:e701:0:b0:59b:e97e:f7df with SMTP id
 x1-20020a81e701000000b0059be97ef7dfmr10032ywl.2.1695414897162; Fri, 22 Sep
 2023 13:34:57 -0700 (PDT)
Date:   Fri, 22 Sep 2023 13:34:55 -0700
In-Reply-To: <CAL715WKguAT_K_eUTxk8XEQ5rQ=e5WhEFdwOx8VpkpTHJWgRFw@mail.gmail.com>
Mime-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <ZQ3hD+zBCkZxZclS@google.com>
 <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
 <ZQ3pQfu6Zw3MMvKx@google.com> <CAL715WKguAT_K_eUTxk8XEQ5rQ=e5WhEFdwOx8VpkpTHJWgRFw@mail.gmail.com>
Message-ID: <ZQ36bxFOZM0s5+uk@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> On Fri, Sep 22, 2023 at 12:21=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Fri, Sep 22, 2023, Jim Mattson wrote:
> > > On Fri, Sep 22, 2023 at 11:46=E2=80=AFAM Sean Christopherson <seanjc@=
google.com> wrote:
> > > >
> > > > On Fri, Sep 01, 2023, Jim Mattson wrote:
> > > > > When the irq_work callback, kvm_pmi_trigger_fn(), is invoked duri=
ng a
> > > > > VM-exit that also invokes __kvm_perf_overflow() as a result of
> > > > > instruction emulation, kvm_pmu_deliver_pmi() will be called twice
> > > > > before the next VM-entry.
> > > > >
> > > > > That shouldn't be a problem. The local APIC is supposed to
> > > > > automatically set the mask flag in LVTPC when it handles a PMI, s=
o the
> > > > > second PMI should be inhibited. However, KVM's local APIC emulati=
on
> > > > > fails to set the mask flag in LVTPC when it handles a PMI, so two=
 PMIs
> > > > > are delivered via the local APIC. In the common case, where LVTPC=
 is
> > > > > configured to deliver an NMI, the first NMI is vectored through t=
he
> > > > > guest IDT, and the second one is held pending. When the NMI handl=
er
> > > > > returns, the second NMI is vectored through the IDT. For Linux gu=
ests,
> > > > > this results in the "dazed and confused" spurious NMI message.
> > > > >
> > > > > Though the obvious fix is to set the mask flag in LVTPC when hand=
ling
> > > > > a PMI, KVM's logic around synthesizing a PMI is unnecessarily
> > > > > convoluted.
> > > >
> > > > To address Like's question about whether not this is necessary, I t=
hink we should
> > > > rephrase this to explicitly state this is a bug irrespective of the=
 whole LVTPC
> > > > masking thing.
> > > >
> > > > And I think it makes sense to swap the order of the two patches.  T=
he LVTPC masking
> > > > fix is a clearcut architectural violation.  This is a bit more of a=
 grey area,
> > > > though still blatantly buggy.
> > >
> > > The reason I ordered the patches as I did is that when this patch
> > > comes first, it actually fixes the problem that was introduced in
> > > commit 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring
> > > instructions"). If this patch comes second, it's less clear that it
> > > fixes a bug, since the other patch renders this one essentially moot.
> >
> > Yeah, but as Like pointed out, the way the changelog is worded just rai=
ses the
> > question of why this change is necessary.
> >
> > I think we should tag them both for stable.  They're both bug fixes, re=
gardless
> > of the ordering.
>=20
> Agree. Both patches are fixing the general potential buggy situation
> of multiple PMI injection on one vm entry: one software level defense
> (forcing the usage of KVM_REQ_PMI) and one hardware level defense
> (preventing PMI injection using mask).
>=20
> Although neither patch in this series is fixing the root cause of this
> specific double PMI injection bug, I don't see a reason why we cannot
> add a "fixes" tag to them, since we may fix it and create it again.
>=20
> I am currently working on it and testing my patch. Please give me some
> time, I think I could try sending out one version today. Once that is
> done, I will combine mine with the existing patch and send it out as a
> series.

Me confused, what patch?  And what does this patch have to do with Jim's se=
ries?
Unless I've missed something, Jim's patches are good to go with my nits add=
ressed.
