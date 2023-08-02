Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1CC76D79A
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 21:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbjHBTSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 15:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjHBTSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 15:18:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5A3DA
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 12:18:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d390abf3319so164807276.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 12:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691003902; x=1691608702;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RrtcvQrEnQV4437dpl4qfoY+fdzcmNO0NiU9PwpS4bY=;
        b=YVN8GChz8hYvJeRICxHfxQ6LGkuDTI91bFSFAxUqXKsZyhEnzg3Le2EfT93hDZbRS8
         QKpgABSPLGg2U2vPGx0GkCBG0EsGPStmQ02gRdA6vN9HMDHbxkwkduPRdUvUVXBY4CO4
         0/bw3Qhdvi0F3BLxosHDd1SYSnmleQK2ZMM+sopTYgS5RCUPcWqeXe0awVKlmfy+tlaL
         vbUl3lKdUIuj4BfA8NflOr9q/c0MYRXplBp4UiIrkUyPP+Du8ipwraXvJudYyI6Mcn1Y
         d7BaTRJHTOE6Z85lIfzo5jxW7X1Fcu6faSv/copmRgYPkvaUXBWebDTUsVL8cyYrgRG5
         mzSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691003902; x=1691608702;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RrtcvQrEnQV4437dpl4qfoY+fdzcmNO0NiU9PwpS4bY=;
        b=POY/tcnqJT/VAf+Vjr8CDrObEihyWM5pcIQft09a1ivL4C8IvWhrwHefxzGpF3QMAE
         SM0FtnWk3gtiIWDmOSChJpTxkdNaJ7JxSGPb+XXPXrJlzw9YrDOdVROqV0v220lxGPG8
         5Wm6s5wkl1LF3+N+Icd+NsuGURBzWg9vdMBuMaT8pxhU8G3X44eYkrwCWgHbc/uFM8QI
         J/v6CfhO9/twX3EvlVavBI2L+p2WOAB1hSWEBnD2w1d6BnyXGebMZHZ940kGnGYXbmMQ
         WKKXpBxxRUZaLjUsx0QqzVex/mOMA0mgNGjt9avcM3L4SLWuw0s6PEL249DfT5XJGSSN
         OPRA==
X-Gm-Message-State: ABy/qLazlxJXXHXU93NaftvjubK6Mrb+RMEjphGTf9BIHcK+CpYTetDh
        WEAaMuL1aE1abaNs1vmbxG+S6kSdbvM=
X-Google-Smtp-Source: APBJJlEeHAXkb6vjvkBspeZYh2ptU0GJDD0HHR650TjLTSkEWXlx9EBO/1u0rQXstoQJkIvemMX3ex1cXEM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c508:0:b0:c15:cbd1:60da with SMTP id
 v8-20020a25c508000000b00c15cbd160damr117763ybe.6.1691003902296; Wed, 02 Aug
 2023 12:18:22 -0700 (PDT)
Date:   Wed, 2 Aug 2023 12:18:20 -0700
In-Reply-To: <7e24e0b1-d265-2ac0-d411-4d6f4f0c1383@rbox.co>
Mime-Version: 1.0
References: <20230728001606.2275586-1-mhal@rbox.co> <20230728001606.2275586-2-mhal@rbox.co>
 <ZMhIlj+nUAXeL91B@google.com> <7e24e0b1-d265-2ac0-d411-4d6f4f0c1383@rbox.co>
Message-ID: <ZMqr/A1O4PPbKfFz@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU issues
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023, Michal Luczaj wrote:
> On 8/1/23 01:49, Sean Christopherson wrote:
> >> A note: when servicing kvm_run->kvm_dirty_regs, changes made by
> >> __set_sregs()/kvm_vcpu_ioctl_x86_set_vcpu_events() to on-stack copies =
of
> >> vcpu->run.s.regs will not be reflected back in vcpu->run.s.regs. Is th=
is
> >> ok?
> >=20
> > I would be amazed if anyone cares.  Given the justification and the aut=
hor,
> >=20
> >     This reduces ioctl overhead which is particularly important when us=
erspace
> >     is making synchronous guest state modifications (e.g. when emulatin=
g and/or
> >     intercepting instructions).
> >    =20
> >     Signed-off-by: Ken Hofsass <hofsass@google.com>
> >=20
> > I am pretty sure this was added to optimize a now-abandoned Google effo=
rt to do
> > emulation in uesrspace.  I bring that up because I was going to suggest=
 that we
> > might be able to get away with a straight revert, as QEMU doesn't use t=
he flag
> > and AFAICT neither does our VMM, but there are a non-zero number of hit=
s in e.g.
> > github, so sadly I think we're stuck with the feature :-(
>=20
> All right, so assuming the revert is not happening and the API is not mis=
used
> (i.e. unless vcpu->run->kvm_valid_regs is set, no one is expecting up to =
date
> values in vcpu->run->s.regs), is assignment copying
>=20
> 	struct kvm_vcpu_events events =3D vcpu->run->s.regs.events;
>=20
> the right approach or should it be a memcpy(), like in ioctl handlers?

Both approaches are fine, though I am gaining a preference for the copy-by-=
value
method.  With gcc-12 and probably most compilers, the code generation is id=
entical
for both as the compiler generates a call to memcpy() to handle the the str=
uct
assignment.

The advantage of copy-by-value for structs, and why I think I now prefer it=
, is
that it provides type safety.  E.g. this compiles without complaint

	memcpy(&events, &vcpu->run->s.regs.sregs, sizeof(events));

whereas this

	struct kvm_vcpu_events events =3D vcpu->run->s.regs.sregs;

yields

  arch/x86/kvm/x86.c: In function =E2=80=98sync_regs=E2=80=99:
  arch/x86/kvm/x86.c:11793:49: error: invalid initializer
  11793 |                 struct kvm_vcpu_events events =3D vcpu->run->s.re=
gs.sregs;
        |                                                 ^~~~

The downside is that it's less obvious when reading the code that there is =
a
large-ish memcpy happening, but IMO it's worth gaining the type safety.
