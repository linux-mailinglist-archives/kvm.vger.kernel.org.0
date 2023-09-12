Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D063279D87F
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 20:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237173AbjILSQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 14:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237373AbjILSQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 14:16:20 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F140F10D8
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 11:16:15 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-52a49a42353so7681579a12.2
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 11:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694542574; x=1695147374; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7G6zArsYHzwZkBqmBK6VoaHYjsTRL2QKwDCRc1siAf0=;
        b=qGfFzfZiaxKERCfxJp4hDVoU/PYn+A5fwIgpXbymHbzEP8gHG3VJs7Rc7ayn/3CGIh
         Djog/vSFDb8Qmnkl1bZzo92XrJV7cgX+Qjz1Dp/5X720B9swbtP4vsBWU9U/PUCbRT9S
         HPjoeyIxmnl5NIg8dUMl78IIdHbYmUmA5Gg+Y9J1S0ucB0eisxRDK6hqnlHTnII+ND1Y
         BjIq4aRy97FgJYdG9Qhp8Vl/hFsG/YmLT0FJhwCDfFN/jg3sOpGe8z7BWxvGGQOU95lY
         nc2FrL3Jy5crNaTRVilDdUnZyG6Gmcs30SEgkpD+6gsDcLki+tXk4A1wCe9nDvg3xUn7
         rGcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694542574; x=1695147374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7G6zArsYHzwZkBqmBK6VoaHYjsTRL2QKwDCRc1siAf0=;
        b=sBzvomm3PgOJgYKxyabS1TiHsDU9tfGFySDPp0YawzcV9kHUKGVFGq5LyRj1p/MtbE
         dT7/+em/0aSdsbE7H20UlCm22qwwGjqEYutANs6XOiVhDE8ldh7G1y8CxBF/1w5OlIHh
         U/KcxrPTCahPIox6cFc2ajPqByp9xneRfSoSTxlN6ppOB/CGvuB7vq8IDQEm3s7fnhOw
         GXHUPdQJhB6+oqmTLIBR5AxzYgVDuyuDvXTTigT4XWXBC3YVKJzjxoiBnZaN4JjSruGW
         XuOBbyCCop2wjXymBdnrtt+iXLOzxrgy2kE1NQN9wvVSGtAhjb4eqk8uhc+obyx23Nnw
         iLPg==
X-Gm-Message-State: AOJu0Ywnnx9ktgSbjesCDKkqnhbucr9Scx8gOlhcw7e+P/OPfeUX2jIO
        dT0EtEcZ+PE4UE/h9flLZKfbPhPLMwT/90/SquDEtw==
X-Google-Smtp-Source: AGHT+IFqq23f40V3D1ln2gU0d96bO0U35CPT0AKCN0YsmzMEFl7m8OF2w1scczWLTCpJ0oJ5Sfrod2OzJoeEKqcJLcY=
X-Received: by 2002:a17:906:844a:b0:9a1:e8c0:7e2e with SMTP id
 e10-20020a170906844a00b009a1e8c07e2emr72791ejy.14.1694542574160; Tue, 12 Sep
 2023 11:16:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230912161518.199484-1-hshan@google.com> <ZQCayNY+8PYvfc40@google.com>
In-Reply-To: <ZQCayNY+8PYvfc40@google.com>
From:   Haitao Shan <hshan@google.com>
Date:   Tue, 12 Sep 2023 11:16:02 -0700
Message-ID: <CAGD3tSwnXFhnyw4JX_7-UgZpHpPg1Yj_JqsO_Tano1XgmcCvbQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Fix lapic timer interrupt lost after loading a snapshot.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry for sending the reply twice. The former reply got rejected since
I forgot to turn on the plain text email setting.

On Tue, Sep 12, 2023 at 10:07=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Tue, Sep 12, 2023, Haitao Shan wrote:
> > This issue exists in kernel version 6.3-rc1 or above. The issue is
> > introduced by the commit 8e6ed96cdd50 ("KVM: x86: fire timer when it is
> > migrated and expired, and in oneshot mode"). The issue occurs on Intel
> > platform which APIC virtualization and posted interrupt processing.
>
> I think the bug was actually introduced by:
>
>   967235d32032 ("KVM: vmx: clear pending interrupts on KVM_SET_LAPIC")
Thanks for pointing this out. I know commit 8e6ed96cdd50 is only a
trigger. But I
did not go one step further and find out where the bug is coming from.
>
> Fixing the "deadline <=3D 0" handling just made it much easier to be hit.=
  E.g. if
> the deadline was '1' during restore, set_target_expiration() would set ts=
cdeadline
> to T1+(1*N), where T1 is the current TSC and N is the multipler to get fr=
om nanoseconds
> to cycles.  start_sw_tscdeadline() (or vmx_set_hv_timer()) would then rer=
ead the
> TSC (call it T2), see T2 > T1+(1*N), and mark the timer as expired.
>
> > The issue is first discovered when running the Android Emulator which
> > is based on QEMU 2.12. I can reproduce the issue with QEMU 8.0.4 in
> > Debian 12.
>
> The above is helpful as extra context, but repeating "This issue" and "Th=
e issue"
> over and over without ever actually describing what the issue actualy is =
makes it
> quite difficult to understand what is actually being fixed.
Got it. I will rewrite the whole commit message for v2.
>
> > With the above commit, the timer gets fired immediately inside the
> > KVM_SET_LAPIC call when loading the snapshot. On such Intel platforms,
> > this eventually leads to setting the corresponding PIR bit. However,
> > the whole PIR bits get cleared later in the same KVM_SET_LAPIC call.
> > Missing lapic timer interrupt freeze the guest kernel.
>
> Please phrase changelogs as commands and state what is actually being cha=
nged.
> Again, the context on what is broken is helpful, but the changelog really=
, really
> needs to state what is being changed.
Will do.
>
> > Signed-off-by: Haitao Shan <hshan@google.com>
> > ---
> >  arch/x86/kvm/lapic.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index a983a16163b1..6f73406b875a 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2977,14 +2977,14 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, s=
truct kvm_lapic_state *s)
> >       apic_update_lvtt(apic);
> >       apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0)=
);
> >       update_divide_count(apic);
> > -     __start_apic_timer(apic, APIC_TMCCT);
> > -     kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
> >       kvm_apic_update_apicv(vcpu);
> >       if (apic->apicv_active) {
> >               static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
> >               static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_fi=
nd_highest_irr(apic));
> >               static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_hig=
hest_isr(apic));
> >       }
> > +     __start_apic_timer(apic, APIC_TMCCT);
> > +     kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
>
> I don't think this is the ordering we want.  It currently works, but it s=
ubtly
> "relies" on a few things:
>
>   1. That vmx_deliver_posted_interrupt() never "fails" when APICv is enab=
led,
>      i.e. never puts the interrupt in the IRR instead of the PIR.
>
>   2. The SVM, a.k.a. AVIC, doesn't ever sync from the IRR to a separate "=
hardware"
>      virtual APIC, because unlike VMX, SVM does set the bit in the IRR.
>
> I doubt #2 will ever change simply because that's tied to how AVIC works,=
 and #1
> shouldn't actually break anything since the fallback path in vmx_deliver_=
interrupt()
> needs to be self-sufficient, but I don't like that the code syncs from th=
e IRR and
> _then_ potentially modifies the IRR.
>
> I also don't like doing additional APIC state restoration _after_ invokin=
g the
> post_state_restore() hook.  Updating APICv in the middle of the restore f=
low is
> going to be brittle and difficult to maintain, e.g. it won't be obvious w=
hat
> needs to go before and what needs to go after.
>
> IMO, vmx_apicv_post_state_restore() is blatantly broken.  It is most defi=
nitely
> not doing "post state restore" stuff, it's simply purging state, i.e. bel=
ongs in
> a "pre state restore" hook.
>
> So rather than shuffle around the timer code, I think we should instead a=
dd yet
> another kvm_x86_ops hook, e.g. apicv_pre_state_restore(), and have initia=
lize
> the PI descriptor there.
>
> Aha!  And I think the new apicv_pre_state_restore() needs to be invoked e=
ven if
> APICv is not active, because I don't see anything that purges the PIR whe=
n APICv
> is enabled.  VMX's APICv doesn't have many inhibits that can go away, and=
 I
> highly doubt userspace will restore into a vCPU with pending posted inter=
rupts,
> so in practice this is _extremely_ unlikely to be problematic.  But it's =
still
> wrong.
Thanks for sharing what you would like to fix the bug. I will write a
v2 for that.
Actually, I am sorry that I forgot to add RFC to the title, as I
personally did not think
the proposed fix looks clean. I am surprised that
apic_post_state_restore actually
clears the whole PIR which looks like "resetting" instead of
"restoring". However,
I am not sure whether this is the exact intended behavior and code sequence=
. If
it is intended, __restart_apic_timer should defer its interrupt
delivery action after
apic_post_state_restore (something like raising a request for updating PIR =
when
vcpu_enter_guest).

I will work on v2 following your suggestion. Thanks!

--=20
Haitao @Google
