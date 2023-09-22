Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B8C7ABA7A
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 22:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjIVU0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 16:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjIVU0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 16:26:51 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D3DCE
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 13:26:28 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-6562330d68dso13693526d6.2
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 13:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695414387; x=1696019187; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U8JHxG43+vfdtMYvui6/9C10gw13nh7o2zFztJiuSJw=;
        b=NEQ30FtqRkEvgOLp88ezPIN3hXaLfsZqRfQr70zD/Dc0ysjKiTQJ5vBphWNxoZyVsU
         +F8Gl7eGb+wiRlhK9taDLQG6bgm+3g+77lHivucAixxRxLhovqyFLrDXAKsoIvdDf+qo
         Yp8kxtzQ1UnVC30eA7jEkzd8cM17bcdU5A7eaTHZ8S+1aGhQq2yk/xgKRbwFyzQ4UYCU
         Hgv77+CU1sWQi0o749a9zi5set4UOvTbGbHJD6ipknWptx9qlNClvxscjC1aUu1kOKOG
         T+hRE/muI9HC+SfxpqvkSYfK12CaKjUQ5/RrGGy5PkwJboyxexJ4Gk2zDdR4aHxAiLwk
         7i/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695414387; x=1696019187;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U8JHxG43+vfdtMYvui6/9C10gw13nh7o2zFztJiuSJw=;
        b=QIYq+dqWK4y1dP9o1PyGfo3RREoQhvSnFFKPy5EmmGO9jXSJ0Dax3hLrCkKAIVUqVy
         u9ndxpqcPiKDB5O13VYt32OzPe7Sm0zuh8+iIBiCOozZt5q6NHRjZDeNI2gEJnqODxaE
         005sxJ0iwO0AEm4ycL2Llq8doTfB3LdSDfyYR7wxid8CkzwijehjIiE4wgaP4k949BJa
         DFQ3UrmFafOG5gnN3/MuwLNKz9iq6E0T7eLH2j+Rm8CyO4yoK6vwEl2MRxqYxx2htePZ
         XplsM1F4/c5dEqvYPKuwreZqrz/yvkzR7O0gR0l+Ca6A/Wp5yQYtMGe5/pfsiFpeVsWT
         rwjg==
X-Gm-Message-State: AOJu0YwZEt/dmqd9w80u/rtLZQe6VrYL89UP8It3IICv+vTV723uiIrR
        A0pIHNf3LkHTD9hdQXhOAzBQGwB1vmnbK/SpRdqUSQ==
X-Google-Smtp-Source: AGHT+IECfhkpK1kAesa3H4D9kAWjPsjYYcBlTSLlZz9VVvGtlMUrMemW8zpqvOHN5Mi+t7AvVy7NcgSrJ0iw8KNNeuY=
X-Received: by 2002:a0c:cdcc:0:b0:658:25cb:f342 with SMTP id
 a12-20020a0ccdcc000000b0065825cbf342mr386998qvn.9.1695414387399; Fri, 22 Sep
 2023 13:26:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <ZQ3hD+zBCkZxZclS@google.com>
 <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com> <ZQ3pQfu6Zw3MMvKx@google.com>
In-Reply-To: <ZQ3pQfu6Zw3MMvKx@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Fri, 22 Sep 2023 13:25:50 -0700
Message-ID: <CAL715WKguAT_K_eUTxk8XEQ5rQ=e5WhEFdwOx8VpkpTHJWgRFw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 12:21=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Fri, Sep 22, 2023, Jim Mattson wrote:
> > On Fri, Sep 22, 2023 at 11:46=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > On Fri, Sep 01, 2023, Jim Mattson wrote:
> > > > When the irq_work callback, kvm_pmi_trigger_fn(), is invoked during=
 a
> > > > VM-exit that also invokes __kvm_perf_overflow() as a result of
> > > > instruction emulation, kvm_pmu_deliver_pmi() will be called twice
> > > > before the next VM-entry.
> > > >
> > > > That shouldn't be a problem. The local APIC is supposed to
> > > > automatically set the mask flag in LVTPC when it handles a PMI, so =
the
> > > > second PMI should be inhibited. However, KVM's local APIC emulation
> > > > fails to set the mask flag in LVTPC when it handles a PMI, so two P=
MIs
> > > > are delivered via the local APIC. In the common case, where LVTPC i=
s
> > > > configured to deliver an NMI, the first NMI is vectored through the
> > > > guest IDT, and the second one is held pending. When the NMI handler
> > > > returns, the second NMI is vectored through the IDT. For Linux gues=
ts,
> > > > this results in the "dazed and confused" spurious NMI message.
> > > >
> > > > Though the obvious fix is to set the mask flag in LVTPC when handli=
ng
> > > > a PMI, KVM's logic around synthesizing a PMI is unnecessarily
> > > > convoluted.
> > >
> > > To address Like's question about whether not this is necessary, I thi=
nk we should
> > > rephrase this to explicitly state this is a bug irrespective of the w=
hole LVTPC
> > > masking thing.
> > >
> > > And I think it makes sense to swap the order of the two patches.  The=
 LVTPC masking
> > > fix is a clearcut architectural violation.  This is a bit more of a g=
rey area,
> > > though still blatantly buggy.
> >
> > The reason I ordered the patches as I did is that when this patch
> > comes first, it actually fixes the problem that was introduced in
> > commit 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring
> > instructions"). If this patch comes second, it's less clear that it
> > fixes a bug, since the other patch renders this one essentially moot.
>
> Yeah, but as Like pointed out, the way the changelog is worded just raise=
s the
> question of why this change is necessary.
>
> I think we should tag them both for stable.  They're both bug fixes, rega=
rdless
> of the ordering.

Agree. Both patches are fixing the general potential buggy situation
of multiple PMI injection on one vm entry: one software level defense
(forcing the usage of KVM_REQ_PMI) and one hardware level defense
(preventing PMI injection using mask).

Although neither patch in this series is fixing the root cause of this
specific double PMI injection bug, I don't see a reason why we cannot
add a "fixes" tag to them, since we may fix it and create it again.

I am currently working on it and testing my patch. Please give me some
time, I think I could try sending out one version today. Once that is
done, I will combine mine with the existing patch and send it out as a
series.

Thanks.
-Mingwei
