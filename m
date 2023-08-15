Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B17E77C496
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 02:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjHOAoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 20:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbjHOAni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 20:43:38 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1421BAF
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 17:43:37 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-589e5e46735so31097107b3.2
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 17:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692060216; x=1692665016;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KsY/ZaK2RNf5OtLDY1Fjip2JnZVZAV7QJfs4V9oHYNQ=;
        b=0x9Y0/N0szkc98rXT0O9vx+lBDT9Urk4YC3IjrsruZyPWTevA0qxTKEE24zkaMVvZX
         vJ8ijsK1XhTezSGspOieS+NKY0ZP0PdOGDhH4IcTWXpG7BBVnfe/VN97EsW4HGVgtkSZ
         wrjkjn8kAW6SMBz45nbCNcTfKwzGPxvi92rt93D3wefqvl5aTaio79Zs2ugDmZhtXXnL
         z1CUzukfcvkuBrgeY4eNluYVVApVWX8vcjZ4OqsCS/x7XFfTkcT71sYtRvJmNbijyFq5
         HtUkS7zz4r1jhGzlwhp9BrtPieKFymz9Gdpfr6fizWbyNJW/3IbQPODSwmIUEMG7jFby
         QJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692060216; x=1692665016;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KsY/ZaK2RNf5OtLDY1Fjip2JnZVZAV7QJfs4V9oHYNQ=;
        b=jZaC8fehj7xUWmlBMs1NzOfzwCapCc1Mv0pFPXTsXmfTCw+aA4FQqpYi5yaCQNFAO2
         uLxaD6hOViMJ5060OcWAg4CdMsH+vg2gVejG5AqsbBNVeOrUBL+AXDh+hBV015WsmuaD
         qCugBYENAe6VccpvAmFtP0cRW/z3h/UxeBOuk84itxFpvtJMwI9oF+Go5JPII4ktBxTQ
         jTYxp+BqProOtGzvM2omwO6YqEpH71KiDxD5xjVi0Zo0Q24YmHj1B33EXvVdl0LuDma3
         LoaJeJVANjRPW7HCB1wv+28e7fG5gBgsmzpNowLry0Hr9ttwUWwzyrXV2joX4nmvv4MW
         crqw==
X-Gm-Message-State: AOJu0YxTSzsk5WBG5wr7ZL0Nk5NLfZa9nLMQXKePulNeMAOFImot2jIx
        XWF+er2JjYSh824jg6IETEkUg5XR3c8=
X-Google-Smtp-Source: AGHT+IHcLwDac4BWNRjgQpIWOkWuss1NmMWEbE9cL8TvxNyzuC00IaInTzAhw3Df+aMOuMZkJ6GxzXkqHz0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:441f:0:b0:589:a974:d7ef with SMTP id
 r31-20020a81441f000000b00589a974d7efmr158615ywa.6.1692060216360; Mon, 14 Aug
 2023 17:43:36 -0700 (PDT)
Date:   Mon, 14 Aug 2023 17:43:34 -0700
In-Reply-To: <CAF7b7mo0gGGhv9dSFV70md1fNqMvPCfZ05VawPOB=xFkaax8AA@mail.gmail.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com> <CAF7b7mqfkLYtWBJ=u0MK7hhARHrahQXHza9VnaughyNz5_tNug@mail.gmail.com>
 <ZNpsCngiSjISMG5j@google.com> <CAF7b7mo0gGGhv9dSFV70md1fNqMvPCfZ05VawPOB=xFkaax8AA@mail.gmail.com>
Message-ID: <ZNrKNs8IjkUWOatn@google.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
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

On Mon, Aug 14, 2023, Anish Moorthy wrote:
> On Mon, Aug 14, 2023 at 11:01=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > What is/was the error?  It's probably worth digging into; "static inlin=
e" should
> > work just fine, so there might be something funky elsewhere that you're=
 papering
> > over.
>=20
> What I get is
>=20
> > ./include/linux/kvm_host.h:2298:20: error: function 'kvm_handle_guest_u=
access_fault' has internal linkage but is not defined [-Werror,-Wundefined-=
internal]
> > static inline void kvm_handle_guest_uaccess_fault(struct kvm_vcpu *vcpu=
,
> >                    ^
> > arch/x86/kvm/mmu/mmu.c:3323:2: note: used here
> >         kvm_handle_guest_uaccess_fault(vcpu, gfn_to_gpa(fault->gfn), PA=
GE_SIZE,
> >         ^
> > 1 error generated.
>=20
> (mmu.c:3323 is in kvm_handle_error_pfn()). I tried shoving the
> definition of the function from kvm_main.c to kvm_host.h so that I
> could make it "static inline": but then the same "internal linkage"
> error pops up in the kvm_vcpu_read/write_guest_page() functions.

Can you point me at your branch?  That should be easy to resolve, but it's =
all
but impossible to figure out what's going wrong without being able to see t=
he
full code.

> Btw, do you actually know the size of the union in the run struct? I
> started checking it but stopped when I realized that it includes
> arch-dependent structs.

256 bytes, though how much of that is actually free for the "speculative" i=
dea...

		/* Fix the size of the union. */
		char padding[256];

Well fudge.  PPC's KVM_EXIT_OSI actually uses all 256 bytes.  And KVM_EXIT_=
SYSTEM_EVENT
is closer to the limit than I'd like.

On the other hand, despite burning 2048 bytes for kvm_sync_regs, all of kvm=
_run
is only 2352 bytes, i.e. we have plenty of room in the 4KiB page.  So we co=
uld
throw the "speculative" exits in a completely different union.  But that wo=
uld
be cumbersome for userspace.

Hrm.  The best option would probably be to have a "nested" or "previous" ex=
it union,
and copy the existing exit information to that field prior to filling a new=
 exit
reason.  But that would require an absolute insane amount of refactoring be=
cause
everything just writes the fields directly. *sigh*

I suppose we could copy the information into two places for "speculative" e=
xits,
the actual exit union and a separate "speculative" field.  I might be grasp=
ing at
straws though, not sure that ugliness would be worth making it slightly eas=
ier to
deal with the (A) scenario from earlier.

FWIW, my trick for quick finding the real size is to feed the size+1 into a=
n alignment.
Unless you get really unlucky, that alignment will be illegal and the compi=
ler
will tell you the size, e.g.=20

arch/x86/kvm/x86.c:13405:9: error: requested alignment =E2=80=982353=E2=80=
=99 is not a positive power of 2
13405 |         unsigned int len __aligned(sizeof(*run) + 1);
      |         ^~~~~~~~

