Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04AB67AB9C7
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 21:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbjIVTE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 15:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjIVTE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 15:04:56 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485BA92
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 12:04:50 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-53368df6093so2925a12.1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 12:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695409489; x=1696014289; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ySvKJS1rfryxlQiyxydTwo7CkrpoEDZuBumeYPgiMkk=;
        b=B8n5iT6x68dfoOYU2g8+SIvr0Sok0w9Egie+4eEoE649IujZ4aMxA22Ju0uY0i2Vn1
         cZKFQom99TcBUyncIAgcBCEjP8dV7Kph/s63JLx8YWoyy4Yf0rWnEbe87FsO++t/qiuW
         zutNQkTTfFosUlNkAmF6hcHR9vG0MbHvjdVPd/BEAtK2MwrQeKZVIlj4VWjnUVGmZPDc
         H9kbF52ACqjFEas+xYRGvNkO+ssfk4N6CxzApl0kVHKqzVXK51V8JTXPAzb3/livupQV
         XbcEApexslc4DIUjoTu0eLVisYyh3KcByPjgLqTvA1sAl46aGj5Big5kirXvC/BrNpdo
         EOuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695409489; x=1696014289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ySvKJS1rfryxlQiyxydTwo7CkrpoEDZuBumeYPgiMkk=;
        b=ru3jBrsan0yxhnj/IXS6nmg42ovWmZok/ITfhYZG7jHC+7QBR2sazbKlT8WR490XzF
         XDQLRGt9PBQvGK5BBQWXpM+IHnOiPCJA4p3F/aUQxwmlVk0fGVdemlo34wfZ/eaMXx/J
         4pwA3SRM2NumvcZZ10o/e7ZbLhGT6PwbHpckaIYZE47AGk1tfUt7FrvLOaRB5tX0Hh6t
         GKBmVE1GxeXzTuk5gT8ZfUzs7tzxJsaJrz+XFJk6z6dfI/OCYrjInRnV2YhDhOsPkjFd
         DfXEJ4WByRaw4rCRsqkRKIGZKxyhyk1ePGVrwk+8Cl7JjRPjk3SaEmfqTc8YYxuBI+0e
         xQ4g==
X-Gm-Message-State: AOJu0YwglaEeiORitEatMfxOrT5T7VsDv4oJ5DqGqTjeuAB5VI8skBIw
        ZW/jg364DBa6SBbmMDMxM79abX+pTOLXk0Jvwt1J0w==
X-Google-Smtp-Source: AGHT+IH5uU8g0c355ufZZY1SdEDJrFZQEN7rgSnMmF4aQJWkXM0xIu8Pofpl6evJYicAJChXpC5/IWTs+Ovam9OCwH0=
X-Received: by 2002:a50:f61d:0:b0:52e:f99a:b5f8 with SMTP id
 c29-20020a50f61d000000b0052ef99ab5f8mr16869edn.7.1695409488611; Fri, 22 Sep
 2023 12:04:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <ZQ3hD+zBCkZxZclS@google.com>
In-Reply-To: <ZQ3hD+zBCkZxZclS@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 22 Sep 2023 12:04:33 -0700
Message-ID: <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>,
        Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 11:46=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Fri, Sep 01, 2023, Jim Mattson wrote:
> > When the irq_work callback, kvm_pmi_trigger_fn(), is invoked during a
> > VM-exit that also invokes __kvm_perf_overflow() as a result of
> > instruction emulation, kvm_pmu_deliver_pmi() will be called twice
> > before the next VM-entry.
> >
> > That shouldn't be a problem. The local APIC is supposed to
> > automatically set the mask flag in LVTPC when it handles a PMI, so the
> > second PMI should be inhibited. However, KVM's local APIC emulation
> > fails to set the mask flag in LVTPC when it handles a PMI, so two PMIs
> > are delivered via the local APIC. In the common case, where LVTPC is
> > configured to deliver an NMI, the first NMI is vectored through the
> > guest IDT, and the second one is held pending. When the NMI handler
> > returns, the second NMI is vectored through the IDT. For Linux guests,
> > this results in the "dazed and confused" spurious NMI message.
> >
> > Though the obvious fix is to set the mask flag in LVTPC when handling
> > a PMI, KVM's logic around synthesizing a PMI is unnecessarily
> > convoluted.
>
> To address Like's question about whether not this is necessary, I think w=
e should
> rephrase this to explicitly state this is a bug irrespective of the whole=
 LVTPC
> masking thing.
>
> And I think it makes sense to swap the order of the two patches.  The LVT=
PC masking
> fix is a clearcut architectural violation.  This is a bit more of a grey =
area,
> though still blatantly buggy.

The reason I ordered the patches as I did is that when this patch
comes first, it actually fixes the problem that was introduced in
commit 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring
instructions"). If this patch comes second, it's less clear that it
fixes a bug, since the other patch renders this one essentially moot.

> So, put this patch second, and replace the above paragraphs with somethin=
g like?
>
>   Calling kvm_pmu_deliver_pmi() twice is unlikely to be problematic now t=
hat
>   KVM sets the LVTPC mask bit when delivering a PMI.  But using IRQ work =
to
>   trigger the PMI is still broken, albeit very theoretically.
>
>   E.g. if the self-IPI to trigger IRQ work is be delayed long enough for =
the
>   vCPU to be migrated to a different pCPU, then it's possible for
>   kvm_pmi_trigger_fn() to race with the kvm_pmu_deliver_pmi() from
>   KVM_REQ_PMI and still generate two PMIs.
>
>   KVM could set the mask bit using an atomic operation, but that'd just b=
e
>   piling on unnecessary code to workaround what is effectively a hack.  T=
he
>   *only* reason KVM uses IRQ work is to ensure the PMI is treated as a wa=
ke
>   event, e.g. if the vCPU just executed HLT.
>
> > Remove the irq_work callback for synthesizing a PMI, and all of the
> > logic for invoking it. Instead, to prevent a vcpu from leaving C0 with
> > a PMI pending, add a check for KVM_REQ_PMI to kvm_vcpu_has_events().
