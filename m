Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780C16D6D3C
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 21:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbjDDTfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 15:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbjDDTfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 15:35:00 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA50AC
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 12:34:59 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 140-20020a630792000000b0050be9465db8so9734397pgh.2
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 12:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680636899;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LuV+/sJOq2uDAF4iudL5mtYpR36Yypb8trQPNgvINbg=;
        b=KQ7Dk7TU7k221z8YiX2kN/3uZEQcyLXIZCxd4U6GQEAim0R92B50cjmrBHPVO8TEGw
         DZqacgV+ZS3QoLfWUbPPHDXqO23foWHIPdzrO+mD7geIFab38WD2+TzgvEWILX9ik8dX
         FW7NDUzHqUz3mqzF6i6OU6WaHOBSu1/T/Gd5CgoWstWYqyyluIr617MPHa1nOM3CJNuT
         LJaowseQzcCmf2rFJeDXwkk2U1TmYINodpv6Yi/6Df5PIB44+6s1SWW4gAF7Y02ABddC
         jQ78xmZrpu0/iKrfiQk3FnGkhLi4QUEXVGv4GMdE98xrUMJ4uhvo8TmVYyGol0YZvRBS
         uZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680636899;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LuV+/sJOq2uDAF4iudL5mtYpR36Yypb8trQPNgvINbg=;
        b=VEvEcsgcF3tEfwYimOWu22k5Hhc0G/Ou0hXcN0bb9Q63qATWBvGa8ERhIJ5HWMWKvP
         oLBYBLhmLduPOufWCNLRJ1tmiQPRx/Yw4QK7QHtLMnlfUrAQPneqE8YXoki1ZFeMKpjE
         iy1JgakgkKrnp0r580MnTnXboaL55HKO9WrKAl66euzxT5EVV5OKrDQC2sShFhCBbRZL
         GcWOa6vp8Or873KQErNlW+OPtA5zeQrvhZ8AWZjkWayp7iEFpvSoPpIZ2T9Kxrhkpj0g
         xIm96amZmq5jB9LrPuKmz5KRCpIrIatiT+a3HuVk6bv+akAn+WwxV9O9bRQz1h+egdi0
         j1TA==
X-Gm-Message-State: AAQBX9fAFQvAKH6j/i0ctnQ9EWrJVdyUBmotjkVBl/SMDSFOecHmu2fb
        RijAsP3hgf0xhGhyAMB3vKyyjzovewI=
X-Google-Smtp-Source: AKy350bhdJ/ttpMbZ6gVAtAiTSzKPofPi3LmGG5tA+Ip3z9TKfjG/MNXk6an2WuCm3VuIO2e6EeXVPR7RAo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:150c:0:b0:514:26cf:9c05 with SMTP id
 v12-20020a63150c000000b0051426cf9c05mr488041pgl.7.1680636899011; Tue, 04 Apr
 2023 12:34:59 -0700 (PDT)
Date:   Tue, 4 Apr 2023 12:34:57 -0700
In-Reply-To: <CAF7b7moV9=w4zJhSD2XZrnZTQAP3QeO1rvyT0dMWDhYj0PDcEA@mail.gmail.com>
Mime-Version: 1.0
References: <20230317000226.GA408922@ls.amr.corp.intel.com>
 <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
 <ZBTgnjXJvR8jtc4i@google.com> <CAF7b7mqnvLe8tw_6-cW1b2Bk8YB9qP=7BsOOJK3q-tAyDkarww@mail.gmail.com>
 <ZBiBkwIF4YHnphPp@google.com> <CAF7b7mrVQ6zP6SLHm4QBfQLgaxQuMtxjhqU5YKjjKGkoND4MLw@mail.gmail.com>
 <ZBnLaidtZEM20jMp@google.com> <CAF7b7mof8HkcaSthEO8Wu9kf8ZHjE9c1TDzQGAYDYv7FN9+k9w@mail.gmail.com>
 <ZBoIzo8FGxSyUJ2I@google.com> <CAF7b7moV9=w4zJhSD2XZrnZTQAP3QeO1rvyT0dMWDhYj0PDcEA@mail.gmail.com>
Message-ID: <ZCx74RGh1/nnix6U@google.com>
Subject: Re: [WIP Patch v2 04/14] KVM: x86: Add KVM_CAP_X86_MEMORY_FAULT_EXIT
 and associated kvm_run field
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023, Anish Moorthy wrote:
> On Tue, Mar 21, 2023 at 12:43=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Tue, Mar 21, 2023, Anish Moorthy wrote:
> > > On Tue, Mar 21, 2023 at 8:21=E2=80=AFAM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > > FWIW, I completely agree that filling KVM_EXIT_MEMORY_FAULT without=
 guaranteeing
> > > > that KVM "immediately" exits to userspace isn't ideal, but given th=
e amount of
> > > > historical code that we need to deal with, it seems like the lesser=
 of all evils.
> > > > Unless I'm misunderstanding the use cases, unnecessarily filling kv=
m_run is a far
> > > > better failure mode than KVM not filling kvm_run when it should, i.=
e. false
> > > > positives are ok, false negatives are fatal.
> > >
> > > Don't you have this in reverse?
> >
> > No, I don't think so.
> >
> > > False negatives will just result in userspace not having useful extra
> > > information for the -EFAULT it receives from KVM_RUN, in which case u=
serspace
> > > can do what you mentioned all VMMs do today and just terminate the VM=
.
> >
> > And that is _really_ bad behavior if we have any hope of userspace actu=
ally being
> > able to rely on this functionality.  E.g. any false negative when users=
pace is
> > trying to do postcopy demand paging will be fatal to the VM.
> >
> > > Whereas a false positive might cause a double-write to the KVM_RUN st=
ruct,
> > > either putting incorrect information in kvm_run.memory_fault or
> >
> > Recording unused information on -EFAULT in kvm_run doesn't make the inf=
ormation
> > incorrect.
>=20
> Let's say that some function (converted to annotate its EFAULTs) fills
> in kvm_run.memory_fault, but the EFAULT is suppressed from being
> returned from kvm_run. What if, later within the same kvm_run call,
> some other function (which we've completely overlooked) EFAULTs and
> that return value actually does make it out to kvm_run? Userspace
> would get stale information, which could be catastrophic.

"catastrophic" is a bit hyperbolic.  Yes, it would be bad, but at _worst_ u=
serspace
will kill the VM, which is the status quo today.

> Actually even performing the annotations only in functions that
> currently always bubble EFAULTs to userspace still seems brittle: if
> new callers are ever added which don't bubble the EFAULTs, then we end
> up in the same situation.

Because of KVM's semi-magical '1 =3D=3D resume, -errno/0 =3D=3D exit' "desi=
gn", that's
true for literally every exit to userspace in KVM and every VM-Exit handler=
.
E.g. see commit 2368048bf5c2 ("KVM: x86: Signal #GP, not -EPERM, on bad
WRMSR(MCi_CTL/STATUS)"), where KVM returned '-1' instead of '1' when reject=
ing
MSR accesses and inadvertantly killed the VM.  A similar bug would be if KV=
M
returned EFAULT instead of -EFAULT, in which case vcpu_run() would resume t=
he
guest instead of exiting to userspace and likely put the vCPU into an infin=
ite
loop.

Do I want to harden KVM to make things like this less brittle?  Absolutely.=
  Do I
think we should hold up this functionality just because it doesn't solve al=
l of
pre-existing flaws in the related KVM code?  No.
