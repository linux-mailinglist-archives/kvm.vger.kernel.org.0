Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E886DFC1C
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 19:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjDLRAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 13:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjDLRAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 13:00:47 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F9A975C
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 10:00:21 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54f3e30726cso84767247b3.22
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 10:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681318821; x=1683910821;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zutyk3vgFzjdOrimqnKd9a4qfcwXSXa68lbEeBZ1eQg=;
        b=IZZXSyhRqBygl98pAwJ195/lO23y9wzxnJzTeLavCNbM/kU/mBJ1GC8ZmW6tTpoYXP
         PY0nWeLEbIg+5o7amqu28CcAOMyL9JVbyqxAZoxGYdojAqH0hOMd7sB/VgrHr/9VoFEH
         N++AOxYICYk4NMgXjjBgqIC+kTajndMl0nNiHno/++JajT9YjaZFQiwa6IHMhd4/rd6Y
         PHzXoTy3Ed8QUulmSLyl6/nwo0/zyKtSFoDv70p5o0HB8MPOMVvXUmgOqYCrIbfOdezY
         B223HMhTAyg86ZdUsycpPpX6a4d8q/hfoNtqScMwgpi52bm+b0fpCUSGzDJoQiyjBkTW
         p+XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681318821; x=1683910821;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zutyk3vgFzjdOrimqnKd9a4qfcwXSXa68lbEeBZ1eQg=;
        b=Xrk3txsE7hX0AyuABukTbDq/+6OLNbsU6kDktUzLy+kuixjVvWXGQ2sQ2Uh36usqgZ
         YlR5GL07GAzTflFB7yxg+v50YblyT8ujbZF2yb8O3vps5IA8DCx6OpvSmwfeV6S007FW
         5I4lLcbbs91aM3U/hvKggpprqtQCGUCTh7++LdqbXqFzZfIiuqm00DMTOwVg4qqqTN8q
         Y5bhfJlrlHs5kBlJ/TjIEakgfXR6N6A1RRUMvzlHPHWt2vt59YE1mWesRouQPT9aqdZS
         upORD3yPA6XtSbzl/z5UN4FMgjIyRAHprum2x5E9vDo/MSoyY0wjB6i22YqHQ1gI2PNt
         OyjQ==
X-Gm-Message-State: AAQBX9d5iVQ5VewPPJB+LWroXdKi7/fEvdNo1gi0o5VnnXogRnwo3PnC
        lqaMTO+mIqXf7eSg1Ta0Ux0GOpDnYig=
X-Google-Smtp-Source: AKy350Z19ZluZHtXdISI0/T8zheFEA0b/urLmhI2LJeGa+TBistTaS4n+A7VWhUvzekIT5RfgMEb9ytqWdY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:76d0:0:b0:b6c:2d28:b3e7 with SMTP id
 r199-20020a2576d0000000b00b6c2d28b3e7mr2130038ybc.9.1681318821023; Wed, 12
 Apr 2023 10:00:21 -0700 (PDT)
Date:   Wed, 12 Apr 2023 10:00:19 -0700
In-Reply-To: <bug-217304-28872-obRYeQMhMS@https.bugzilla.kernel.org/>
Mime-Version: 1.0
References: <bug-217304-28872@https.bugzilla.kernel.org/> <bug-217304-28872-obRYeQMhMS@https.bugzilla.kernel.org/>
Message-ID: <ZDbjozj39rVqI6HG@google.com>
Subject: Re: [Bug 217304] KVM does not handle NMI blocking correctly in nested virtualization
From:   Sean Christopherson <seanjc@google.com>
To:     bugzilla-daemon@kernel.org
Cc:     kvm@vger.kernel.org
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

On Thu, Apr 06, 2023, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217304
>=20
> --- Comment #1 from Sean Christopherson (seanjc@google.com) ---
> On Thu, Apr 06, 2023, bugzilla-daemon@kernel.org wrote:
> > Assume KVM runs in L0, LHV runs in L1, the nested guest runs in L2.
> >=20
> > The code in LHV performs an experiment (called "Experiment 13" in seria=
l
> > output) on CPU 0 to test the behavior of NMI blocking. The experiment s=
teps
> > are:
> > 1. Prepare state such that the CPU is currently in L1 (LHV), and NMI is
> > blocked
> > 2. Modify VMCS12 to make sure that L2 has virtual NMIs enabled (NMI exi=
ting =3D
> > 1, Virtual NMIs =3D 1), and L2 does not block NMI (Blocking by NMI =3D =
0)
> > 3. VM entry to L2
> > 4. L2 performs VMCALL, get VM exit to L1
> > 5. L1 checks whether NMI is blocked.
> >=20
> > The expected behavior is that NMI should be blocked, which is reproduce=
d on
> > real hardware. According to Intel SDM, NMIs should be unblocked after V=
M
> > entry
> > to L2 (step 3). After VM exit to L1 (step 4), NMI blocking does not cha=
nge,
> > so
> > NMIs are still unblocked. This behavior is reproducible on real hardwar=
e.
> >=20
> > However, when running on KVM, the experiment shows that at step 5, NMIs=
 are
> > blocked in L1. Thus, I think NMI blocking is not implemented correctly =
in
> > KVM's
> > nested virtualization.
>=20
> Ya, KVM blocks NMIs on nested NMI VM-Exits, but doesn't unblock NMIs for =
all
> other
> exit types.  I believe this is the fix (untested):
>=20
> ---
>  arch/x86/kvm/vmx/nested.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 96ede74a6067..4240a052628a 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4164,12 +4164,7 @@ static int vmx_check_nested_events(struct kvm_vcpu
> *vcpu)
>                 nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
>                                   NMI_VECTOR | INTR_TYPE_NMI_INTR |
>                                   INTR_INFO_VALID_MASK, 0);
> -               /*
> -                * The NMI-triggered VM exit counts as injection:
> -                * clear this one and block further NMIs.
> -                */
>                 vcpu->arch.nmi_pending =3D 0;
> -               vmx_set_nmi_mask(vcpu, true);
>                 return 0;
>         }
>=20
> @@ -4865,6 +4860,13 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32
> vm_exit_reason,
>                                 INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR=
;
>                 }
>=20
> +               /*
> +                * NMIs are blocked on VM-Exit due to NMI, and unblocked =
by all
> +                * other VM-Exit types.
> +                */
> +               vmx_set_nmi_mask(vcpu, (u16)vm_exit_reason =3D=3D
> EXIT_REASON_EXCEPTION_NMI &&
> +                                      !is_nmi(vmcs12->vm_exit_intr_info)=
);

Ugh, this is wrong.  As Eric stated in the bug report, and per section "27.=
5.5
Updating Non-Register State", VM-Exit does *not* affect NMI blocking except=
 if
the VM-Exit is directly due to an NMI

  Event blocking is affected as follows:
    * There is no blocking by STI or by MOV SS after a VM exit.
    * VM exits caused directly by non-maskable interrupts (NMIs) cause bloc=
king by
      NMI (see Table 24-3). Other VM exits do not affect blocking by NMI. (=
See
      Section 27.1 for the case in which an NMI causes a VM exit indirectly=
.)

The scenario here is that virtual NMIs are enabled, in which case case VM-E=
nter,
not VM-Exit, effectively clears NMI blocking.  From "26.7.1 Interruptibilit=
y State":

  The blocking of non-maskable interrupts (NMIs) is determined as follows:
    * If the "virtual NMIs" VM-execution control is 0, NMIs are blocked if =
and
      only if bit 3 (blocking by NMI) in the interruptibility-state field i=
s 1.
      If the "NMI exiting" VM-execution control is 0, execution of the IRET
      instruction removes this blocking (even if the instruction generates =
a fault).
      If the "NMI exiting" control is 1, IRET does not affect this blocking=
.
    * The following items describe the use of bit 3 (blocking by NMI) in th=
e
      interruptibility-state field if the "virtual NMIs" VM-execution contr=
ol is 1:
        * The bit=E2=80=99s value does not affect the blocking of NMIs afte=
r VM entry. NMIs
          are not blocked in VMX non-root operation (except for ordinary bl=
ocking
          for other reasons, such as by the MOV SS instruction, the wait-fo=
r-SIPI
          state, etc.)
        * The bit=E2=80=99s value determines whether there is virtual-NMI b=
locking after VM
          entry. If the bit is 1, virtual-NMI blocking is in effect after V=
M entry.
          If the bit is 0, there is no virtual-NMI blocking after VM entry =
unless
          the VM entry is injecting an NMI (see Section 26.6.1.1). Executio=
n of IRET
          removes virtual-NMI blocking (even if the instruction generates a=
 fault).

I.e. forcing NMIs to be unblocked is wrong when virtual NMIs are disabled.

Unfortunately, that means fixing this will require a much more involved pat=
ch
(series?), e.g. KVM can't modify NMI blocking until the VM-Enter is success=
ful,
at which point vmcs02, not vmcs01, is loaded, and so KVM will likely need t=
o
to track NMI blocking in a software variable.  That in turn gets complicate=
d by
the !vNMI case, because then KVM needs to propagate NMI blocking between vm=
cs01,
vmcs12, and vmcs02.  Blech.

I'm going to punt fixing this due to lack of bandwidth, and AFAIK lack of a=
 use
case beyond testing.  Hopefully I'll be able to revisit this in a few weeks=
, but
that might be wishful thinking.
