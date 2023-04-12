Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1002D6E002E
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 22:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjDLUu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 16:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjDLUu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 16:50:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529F76584
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 13:50:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE76C63541
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 20:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D489C4339C
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 20:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681332625;
        bh=lWAHl44ZV0WqqcxQ65ArdEDu/dYYinrQJwPgp2tk1rc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tV4UEInG/5ie3qhVhMw4BPcU1eO0ZtfDccc1d1/B7LTiz/OnpqxaKIlsmIL21R/1x
         Dm7P2ifD1syJA32uBP6YuIFzDAYw8RoNrhbUGc1wJI1MaJX559wkRoPxD6/jkMKxp8
         Jd/qLg2HlDqUbS+Qrvx5V2bwKIcmMaK5qBzP9CNonVxpBd0gvtS10HstmlCVOJb9FH
         V6X7aNZfCOyeOhvzbLHppZVhFz9GJWOojmlB/yIyCJOCc2rPZoUNzNIKoByZ8cf9Mk
         lWHe1mcso+kneiXimkETn8InbqZWxaJOnP/1k4aCQPQ49dXjCFJS3qast0+I2Ct9OH
         lB+BX5pPZXeug==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 30D06C43145; Wed, 12 Apr 2023 20:50:25 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217304] KVM does not handle NMI blocking correctly in nested
 virtualization
Date:   Wed, 12 Apr 2023 20:50:24 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixiaoyi13691419520@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217304-28872-Omt4TdrpiW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217304-28872@https.bugzilla.kernel.org/>
References: <bug-217304-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217304

--- Comment #4 from Eric Li (lixiaoyi13691419520@gmail.com) ---
=E5=9C=A8 2023-04-12=E6=98=9F=E6=9C=9F=E4=B8=89=E7=9A=84 17:00 +0000=EF=BC=
=8Cbugzilla-daemon@kernel.org=E5=86=99=E9=81=93=EF=BC=9A
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217304
>=20
> --- Comment #3 from Sean Christopherson (seanjc@google.com) ---
> On Thu, Apr 06, 2023, bugzilla-daemon@kernel.org=C2=A0wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D217304
> >=20
> > --- Comment #1 from Sean Christopherson (seanjc@google.com) ---
> > On Thu, Apr 06, 2023, bugzilla-daemon@kernel.org=C2=A0wrote:
> > > Assume KVM runs in L0, LHV runs in L1, the nested guest runs in
> > > L2.
> > >=20
> > > The code in LHV performs an experiment (called "Experiment 13" in
> > > serial
> > > output) on CPU 0 to test the behavior of NMI blocking. The
> > > experiment steps
> > > are:
> > > 1. Prepare state such that the CPU is currently in L1 (LHV), and
> > > NMI is
> > > blocked
> > > 2. Modify VMCS12 to make sure that L2 has virtual NMIs enabled
> > > (NMI exiting
> > =3D
> > > 1, Virtual NMIs =3D 1), and L2 does not block NMI (Blocking by NMI
> > > =3D 0)
> > > 3. VM entry to L2
> > > 4. L2 performs VMCALL, get VM exit to L1
> > > 5. L1 checks whether NMI is blocked.
> > >=20
> > > The expected behavior is that NMI should be blocked, which is
> > > reproduced on
> > > real hardware. According to Intel SDM, NMIs should be unblocked
> > > after VM
> > > entry
> > > to L2 (step 3). After VM exit to L1 (step 4), NMI blocking does
> > > not change,
> > > so
> > > NMIs are still unblocked. This behavior is reproducible on real
> > > hardware.
> > >=20
> > > However, when running on KVM, the experiment shows that at step
> > > 5, NMIs are
> > > blocked in L1. Thus, I think NMI blocking is not implemented
> > > correctly in
> > > KVM's
> > > nested virtualization.
> >=20
> > Ya, KVM blocks NMIs on nested NMI VM-Exits, but doesn't unblock
> > NMIs for all
> > other
> > exit types.=C2=A0 I believe this is the fix (untested):
> >=20
> > ---
> > =C2=A0arch/x86/kvm/vmx/nested.c | 12 +++++++-----
> > =C2=A01 file changed, 7 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 96ede74a6067..4240a052628a 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -4164,12 +4164,7 @@ static int vmx_check_nested_events(struct
> > kvm_vcpu
> > *vcpu)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 NMI_VECTOR | INTR_TY=
PE_NMI_INTR |
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 INTR_INFO_VALID_MASK=
, 0);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 /*
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * The NMI-triggered VM exit counts as injection:
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * clear this one and block further NMIs.
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 vcpu->arch.nmi_pending =3D 0;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 vmx_set_nmi_mask(vcpu, true);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return 0;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >=20
> > @@ -4865,6 +4860,13 @@ void nested_vmx_vmexit(struct kvm_vcpu
> > *vcpu, u32
> > vm_exit_reason,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 INTR_INFO_VALID_MASK |
> > INTR_TYPE_EXT_INTR;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 }
> >=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 /*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * NMIs are blocked on VM-Exit due to NMI, and
> > unblocked by
> > all
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * other VM-Exit types.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 vmx_set_nmi_mask(vcpu, (u16)vm_exit_reason =3D=3D
> > EXIT_REASON_EXCEPTION_NMI &&
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 !is_nmi(vmcs12-
> > >vm_exit_intr_info));
>=20
> Ugh, this is wrong.=C2=A0 As Eric stated in the bug report, and per
> section "27.5.5
> Updating Non-Register State", VM-Exit does *not* affect NMI blocking
> except if
> the VM-Exit is directly due to an NMI
>=20
> =C2=A0 Event blocking is affected as follows:
> =C2=A0=C2=A0=C2=A0 * There is no blocking by STI or by MOV SS after a VM =
exit.
> =C2=A0=C2=A0=C2=A0 * VM exits caused directly by non-maskable interrupts =
(NMIs)
> cause blocking
> by
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 NMI (see Table 24-3). Other VM exits do no=
t affect blocking by
> NMI. (See
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Section 27.1 for the case in which an NMI =
causes a VM exit
> indirectly.)
>=20
Correct. In my experiment, NMI is unblocked at VMENTRY. VMEXIT does not
change NMI blocking (i.e. remain unblocked).

> The scenario here is that virtual NMIs are enabled, in which case
> case
> VM-Enter,
> not VM-Exit, effectively clears NMI blocking.=C2=A0 From "26.7.1
> Interruptibility
> State":
>=20
> =C2=A0 The blocking of non-maskable interrupts (NMIs) is determined as
> follows:
> =C2=A0=C2=A0=C2=A0 * If the "virtual NMIs" VM-execution control is 0, NMI=
s are
> blocked if and
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 only if bit 3 (blocking by NMI) in the int=
erruptibility-state
> field is 1.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 If the "NMI exiting" VM-execution control =
is 0, execution of
> the IRET
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 instruction removes this blocking (even if=
 the instruction
> generates a
> fault).
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 If the "NMI exiting" control is 1, IRET do=
es not affect this
> blocking.
> =C2=A0=C2=A0=C2=A0 * The following items describe the use of bit 3 (block=
ing by NMI)
> in the
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 interruptibility-state field if the "virtu=
al NMIs" VM-execution
> control
> is 1:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * The bit=E2=80=99s value does=
 not affect the blocking of NMIs after
> VM entry.
> NMIs
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 are not blocked in=
 VMX non-root operation (except for
> ordinary
> blocking
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for other reasons,=
 such as by the MOV SS instruction, the
> wait-for-SIPI
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 state, etc.)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * The bit=E2=80=99s value dete=
rmines whether there is virtual-NMI
> blocking
> after VM
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 entry. If the bit =
is 1, virtual-NMI blocking is in effect
> after VM
> entry.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 If the bit is 0, t=
here is no virtual-NMI blocking after VM
> entry
> unless
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 the VM entry is in=
jecting an NMI (see Section 26.6.1.1).
> Execution of
> IRET
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 removes virtual-NM=
I blocking (even if the instruction
> generates a
> fault).
>=20
> I.e. forcing NMIs to be unblocked is wrong when virtual NMIs are
> disabled.
>=20
> Unfortunately, that means fixing this will require a much more
> involved patch
> (series?), e.g. KVM can't modify NMI blocking until the VM-Enter is
> successful,
> at which point vmcs02, not vmcs01, is loaded, and so KVM will likely
> need to
> to track NMI blocking in a software variable.=C2=A0 That in turn gets
> complicated by
> the !vNMI case, because then KVM needs to propagate NMI blocking
> between
> vmcs01,
> vmcs12, and vmcs02.=C2=A0 Blech.
>=20
Yes, the implementation to handle NMI perfectly in nested
virtualization may be complicated. There are many strange cases to
think about (e.g. priority between NMI window VM-exit and NMI
interrupts).

> I'm going to punt fixing this due to lack of bandwidth, and AFAIK
> lack of a use
> case beyond testing.=C2=A0 Hopefully I'll be able to revisit this in a few
> weeks,
> but
> that might be wishful thinking.
>=20
I agree. This case probably only appears in testing. I can't think of a
reasonable reason for a hypervisor to perform VM-enter with NMIs
blocked.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
