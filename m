Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7335A65C9B7
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 23:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbjACWih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 17:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjACWie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 17:38:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839F25583
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 14:38:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18CEF61520
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 22:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70FFCC433F1
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 22:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672785512;
        bh=O5lVAkX4R3QTqiTF6+vuBCR13r/XdQMKEqaBjJZC+eE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PSs5bkQ5NZ9cOKmJs6UqBEN+HowQdPmw4FwAi5uNyER2JDYtw04c158Jadgsthg0j
         taOAonYqj9G0cv+08KqULosfL0s5bmWUy54c9hINN0ITNvf3XH9UjCUA+xR2MEmWFV
         ImmeJL3OC8/1/n2fpNkxDbOy4fF1XXP8dcNeCHHF3AD2gQtykrA7TTQgpKVLUDrB2W
         Y3w45MADVO8bdJQWJVEJ8kum9wTYdi8blIKRHdtzXVZGRDamjqDNw2qOulFkXnAWlQ
         Ok0sHes8scAhT5rPzbuKGlV/kp0rQAd4OslPqvg6wVvldGULEn6f+PPmr/Tqf2XY7Y
         u0sAmfX+Fr64A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5AA54C43145; Tue,  3 Jan 2023 22:38:32 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216867] KVM instruction emulation breaks LOCK instruction
 atomicity when CMPXCHG fails
Date:   Tue, 03 Jan 2023 22:38:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ercli@ucdavis.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216867-28872-dcUCSYBNjg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216867-28872@https.bugzilla.kernel.org/>
References: <bug-216867-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216867

--- Comment #2 from Eric Li (ercli@ucdavis.edu) ---
=E5=9C=A8 2023-01-03=E6=98=9F=E6=9C=9F=E4=BA=8C=E7=9A=84 22:05 +0000=EF=BC=
=8Cbugzilla-daemon@kernel.org=E5=86=99=E9=81=93=EF=BC=9A
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216867
>=20
> --- Comment #1 from Sean Christopherson (seanjc@google.com) ---
> On Fri, Dec 30, 2022, bugzilla-daemon@kernel.org=C2=A0wrote:
>=20
> > My code performs the following experiment repeatedly on 3 CPUs:
> >=20
> > * Initially, "ptr" at address 0xb8000 (VGA memory mapped I/O) is
> > set to 0
> > * CPU 0 writes 0x12345678 to ptr, then increases counter "count0".
> > * In an infinite loop, CPU 1 tries exchanges ptr with register EAX
> > (contains
> > 0)
> > using the XCHG instruction. If CPU 1 sees 0x12345678, it increases
> > counter
> > "count1".
> > * CPU 2's behavior is similar to CPU 1, except it increases counter
> > "count2"
> > when it sees 0x12345678.
> >=20
> > Ideally, after each experiment there should always be count1 +
> > count2 =3D
> > count0.
> > However, in KVM, there may be count1 + count2 > count0. This
> > because CPU 0
> > writes 0x12345678 to ptr once, but CPU 1 and CPU 2 both get
> > 0x12345678 in
> > XCHG.
> > Note that XCHG instruction always implements the locking protocol.
> >=20
> > There is also a deadlock after running the experiment a few times.
> > However I
> > am
> > not trying to explain it for now.
>=20
> Is the suspect deadlock in userspace, the guest, or in the host
> kernel?
>=20

The deadlock happens in the guest. It is due to how my experiment is
implemented. It is not directly related to KVM.

> > Guessed cause:
> >=20
> > I guess that KVM emulates the XCHG instruction that accesses
> > 0xb8000. The
> > call
> > stack should be:
> >=20
> > ...
> > =C2=A0x86_emulate_instruction (arch/x86/kvm/x86.c)
> > =C2=A0 x86_emulate_insn (arch/x86/kvm/emulate.c)
> > =C2=A0=C2=A0 writeback (arch/x86/kvm/emulate.c)
> > =C2=A0=C2=A0=C2=A0 segmented_cmpxchg (arch/x86/kvm/emulate.c)
> > =C2=A0=C2=A0=C2=A0=C2=A0 emulator_cmpxchg_emulated (arch/x86/kvm/x86.c,=
 -
> > >cmpxchg_emulated)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 emulator_try_cmpxchg_user (arch/x86/kvm/=
x86.c)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CMPXCHG instruction
> >=20
> > Suppose CPU 2 wants to write 0 to ptr using writeback(), and
> > expecting ptr to
> > already contain 0x13245678. However, CPU 1 changes the content of
> > ptr to 0.
> > So
> > * The CMPXCHG instruction fails (clears ZF).
> > * emulator_try_cmpxchg_user returns 1.
> > * emulator_cmpxchg_emulated() returns X86EMUL_CMPXCHG_FAILED.
> > * segmented_cmpxchg() returns X86EMUL_CMPXCHG_FAILED.
> > * writeback() returns X86EMUL_CMPXCHG_FAILED.
> > * x86_emulate_insn() returns EMULATION_OK.
> >=20
> > Thus, I think the root cause of this bug is that x86_emulate_insn()
> > ignores
> > the
> > X86EMUL_CMPXCHG_FAILED error. The correct behavior should be
> > retrying the
> > emulation using the updated value (similar to load-linked/store-
> > conditional).
>=20
> KVM does retry the emulation, albeit in a very roundabout and non-
> robust way.
> On X86EMUL_CMPXCHG_FAILED, x86_emulate_insn() skips the EIP update
> and doesn't
> writeback GPRs.=C2=A0 x86_emulate_instruction() is flawed and emulates
> single-step,
> but
> the "eip" written should be the original RIP, i.e. shouldn't advance
> past the
> instructions being emulated.=C2=A0 The single-step mess should be fixed,
> but I doubt
> that's the root cause here.
>=20

I see, thanks for the explanation. Now the retrying code looks correct
to me (though I agree that the code could have been written in a better
way).

> Is there a memslot for 0xb8000?=C2=A0 I assume not since KVM is emulating
> (have you
> actually verified that, e.g. with tracepoints?).=C2=A0 KVM's ABI doesn't
> support
> atomic MMIO operations, i.e. if there's no memslot, KVM will
> effectively drop
> the LOCK semantics.=C2=A0 If that's indeed what's happening, you should
> see
>=20
> =C2=A0 kvm: emulating exchange as write
>=20
> in the host dmesg (just once though).
>=20

You are right. I see "kvm: emulating exchange as write" when I run the
guest I wrote. Looks like this is the check that causes KVM to drop
LOCK on VGA MMIO:

>       gpa =3D kvm_mmu_gva_to_gpa_write(vcpu, addr, NULL);
>
>       if (gpa =3D=3D INVALID_GPA ||
>           (gpa & PAGE_MASK) =3D=3D APIC_DEFAULT_PHYS_BASE)
>               goto emul_write;

Closing this bug since LOCK on MMIO is not supported by KVM's ABI.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
