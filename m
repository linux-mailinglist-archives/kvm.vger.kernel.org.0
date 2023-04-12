Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466846DFC1E
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 19:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjDLRBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 13:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbjDLRA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 13:00:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2C7A274
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 10:00:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A776463790
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 17:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1917AC4339C
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 17:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681318825;
        bh=ytgpZ7cSgULIpTNARpHyxzA3Evw9N661jPz4oaecjxU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fFDZsJrl8/zwpj33DlExPtZd0LDWQuIbX005CBDWV7cz/Qy/V5DZGLGxqBSR6gp2w
         SH0Yjhkc/jzY5AUIlwBu0QuyVQjRja7lyauWxtV9ZMABKR36q4f4DiwayDo77Ez1r8
         lOZFaNMpd/u9RllMF2hXb+Qmy/CExAd9vrtYlOAKq74DTrHFqg8rKl//xZabDvPLdd
         ybDrvhNm9j6xJF3l0pmAkazFKm/ArVC+pgwW8i7UagzgiMHXMpZhC1TNwnVvslAYjN
         LQyL19Nv7JtK+8V6lRj74wS84mxckjJo5E4s8ZZ3PYEgHgCF2bSO9ReW7L6PiJhCdZ
         juBEjz4u+fvUg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id EC18BC43143; Wed, 12 Apr 2023 17:00:24 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217304] KVM does not handle NMI blocking correctly in nested
 virtualization
Date:   Wed, 12 Apr 2023 17:00:24 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217304-28872-tXQxKbN9G4@https.bugzilla.kernel.org/>
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

--- Comment #3 from Sean Christopherson (seanjc@google.com) ---
On Thu, Apr 06, 2023, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217304
>=20
> --- Comment #1 from Sean Christopherson (seanjc@google.com) ---
> On Thu, Apr 06, 2023, bugzilla-daemon@kernel.org wrote:
> > Assume KVM runs in L0, LHV runs in L1, the nested guest runs in L2.
> >=20
> > The code in LHV performs an experiment (called "Experiment 13" in serial
> > output) on CPU 0 to test the behavior of NMI blocking. The experiment s=
teps
> > are:
> > 1. Prepare state such that the CPU is currently in L1 (LHV), and NMI is
> > blocked
> > 2. Modify VMCS12 to make sure that L2 has virtual NMIs enabled (NMI exi=
ting
> =3D
> > 1, Virtual NMIs =3D 1), and L2 does not block NMI (Blocking by NMI =3D =
0)
> > 3. VM entry to L2
> > 4. L2 performs VMCALL, get VM exit to L1
> > 5. L1 checks whether NMI is blocked.
> >=20
> > The expected behavior is that NMI should be blocked, which is reproduce=
d on
> > real hardware. According to Intel SDM, NMIs should be unblocked after VM
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
>                                 INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
>                 }
>=20
> +               /*
> +                * NMIs are blocked on VM-Exit due to NMI, and unblocked =
by
> all
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
king
by
      NMI (see Table 24-3). Other VM exits do not affect blocking by NMI. (=
See
      Section 27.1 for the case in which an NMI causes a VM exit indirectly=
.)

The scenario here is that virtual NMIs are enabled, in which case case
VM-Enter,
not VM-Exit, effectively clears NMI blocking.  From "26.7.1 Interruptibility
State":

  The blocking of non-maskable interrupts (NMIs) is determined as follows:
    * If the "virtual NMIs" VM-execution control is 0, NMIs are blocked if =
and
      only if bit 3 (blocking by NMI) in the interruptibility-state field i=
s 1.
      If the "NMI exiting" VM-execution control is 0, execution of the IRET
      instruction removes this blocking (even if the instruction generates a
fault).
      If the "NMI exiting" control is 1, IRET does not affect this blocking.
    * The following items describe the use of bit 3 (blocking by NMI) in the
      interruptibility-state field if the "virtual NMIs" VM-execution contr=
ol
is 1:
        * The bit=E2=80=99s value does not affect the blocking of NMIs afte=
r VM entry.
NMIs
          are not blocked in VMX non-root operation (except for ordinary
blocking
          for other reasons, such as by the MOV SS instruction, the
wait-for-SIPI
          state, etc.)
        * The bit=E2=80=99s value determines whether there is virtual-NMI b=
locking
after VM
          entry. If the bit is 1, virtual-NMI blocking is in effect after VM
entry.
          If the bit is 0, there is no virtual-NMI blocking after VM entry
unless
          the VM entry is injecting an NMI (see Section 26.6.1.1). Executio=
n of
IRET
          removes virtual-NMI blocking (even if the instruction generates a
fault).

I.e. forcing NMIs to be unblocked is wrong when virtual NMIs are disabled.

Unfortunately, that means fixing this will require a much more involved pat=
ch
(series?), e.g. KVM can't modify NMI blocking until the VM-Enter is success=
ful,
at which point vmcs02, not vmcs01, is loaded, and so KVM will likely need to
to track NMI blocking in a software variable.  That in turn gets complicate=
d by
the !vNMI case, because then KVM needs to propagate NMI blocking between
vmcs01,
vmcs12, and vmcs02.  Blech.

I'm going to punt fixing this due to lack of bandwidth, and AFAIK lack of a=
 use
case beyond testing.  Hopefully I'll be able to revisit this in a few weeks,
but
that might be wishful thinking.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
