Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235E265C926
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 23:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbjACWHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 17:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238535AbjACWG1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 17:06:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A50A15817
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 14:06:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B33A4B81120
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 22:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55820C433F1
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 22:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672783558;
        bh=ij2MXo1Qbqr24fGV8RjosuYPZIBbul3FSXR5JCgEvPE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ooOq8bS2c0xBSevCaSthBB8cC5Isy4V53oQ8bVWLwYoOLllAZYBzAYQFUR4iFY6A/
         BIqSk6RzuANEcfOsAyZ/06Q0iKJ5BSpWb+FZJHDyf4dxzn/iw9GDKrsdm4ovqycW2q
         UczBNMmwqi0aj8iYaJCJ+hSX0V38kxlhdJa7csyTXsK95RREjXV1LQ4kDlYpZlfaMo
         Zu/KNNMEzkSkhNVVhnp2oCkta+99e/svjIbFQyOY6/b7dighzaegg6+uCOtTmHaB/+
         Px6Jg/8plR6Bdjae3Wyv6+oi+IlfJIARtA4MWkTfiy+BJMeTSir5XE/YZX2F/PZItf
         CEtSvLvUvwCSA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 3A021C004D5; Tue,  3 Jan 2023 22:05:58 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216867] KVM instruction emulation breaks LOCK instruction
 atomicity when CMPXCHG fails
Date:   Tue, 03 Jan 2023 22:05:57 +0000
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
Message-ID: <bug-216867-28872-hN4yOQqfw4@https.bugzilla.kernel.org/>
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

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
On Fri, Dec 30, 2022, bugzilla-daemon@kernel.org wrote:

> My code performs the following experiment repeatedly on 3 CPUs:
>=20
> * Initially, "ptr" at address 0xb8000 (VGA memory mapped I/O) is set to 0
> * CPU 0 writes 0x12345678 to ptr, then increases counter "count0".
> * In an infinite loop, CPU 1 tries exchanges ptr with register EAX (conta=
ins
> 0)
> using the XCHG instruction. If CPU 1 sees 0x12345678, it increases counter
> "count1".
> * CPU 2's behavior is similar to CPU 1, except it increases counter "coun=
t2"
> when it sees 0x12345678.
>=20
> Ideally, after each experiment there should always be count1 + count2 =3D
> count0.
> However, in KVM, there may be count1 + count2 > count0. This because CPU 0
> writes 0x12345678 to ptr once, but CPU 1 and CPU 2 both get 0x12345678 in
> XCHG.
> Note that XCHG instruction always implements the locking protocol.
>=20
> There is also a deadlock after running the experiment a few times. Howeve=
r I
> am
> not trying to explain it for now.

Is the suspect deadlock in userspace, the guest, or in the host kernel?

> Guessed cause:
>=20
> I guess that KVM emulates the XCHG instruction that accesses 0xb8000. The
> call
> stack should be:
>=20
> ...
>  x86_emulate_instruction (arch/x86/kvm/x86.c)
>   x86_emulate_insn (arch/x86/kvm/emulate.c)
>    writeback (arch/x86/kvm/emulate.c)
>     segmented_cmpxchg (arch/x86/kvm/emulate.c)
>      emulator_cmpxchg_emulated (arch/x86/kvm/x86.c, ->cmpxchg_emulated)
>       emulator_try_cmpxchg_user (arch/x86/kvm/x86.c)
>        ...
>         CMPXCHG instruction
>=20
> Suppose CPU 2 wants to write 0 to ptr using writeback(), and expecting pt=
r to
> already contain 0x13245678. However, CPU 1 changes the content of ptr to =
0.
> So
> * The CMPXCHG instruction fails (clears ZF).
> * emulator_try_cmpxchg_user returns 1.
> * emulator_cmpxchg_emulated() returns X86EMUL_CMPXCHG_FAILED.
> * segmented_cmpxchg() returns X86EMUL_CMPXCHG_FAILED.
> * writeback() returns X86EMUL_CMPXCHG_FAILED.
> * x86_emulate_insn() returns EMULATION_OK.
>=20
> Thus, I think the root cause of this bug is that x86_emulate_insn() ignor=
es
> the
> X86EMUL_CMPXCHG_FAILED error. The correct behavior should be retrying the
> emulation using the updated value (similar to load-linked/store-condition=
al).

KVM does retry the emulation, albeit in a very roundabout and non-robust wa=
y.
On X86EMUL_CMPXCHG_FAILED, x86_emulate_insn() skips the EIP update and does=
n't
writeback GPRs.  x86_emulate_instruction() is flawed and emulates single-st=
ep,
but
the "eip" written should be the original RIP, i.e. shouldn't advance past t=
he
instructions being emulated.  The single-step mess should be fixed, but I d=
oubt
that's the root cause here.

Is there a memslot for 0xb8000?  I assume not since KVM is emulating (have =
you
actually verified that, e.g. with tracepoints?).  KVM's ABI doesn't support
atomic MMIO operations, i.e. if there's no memslot, KVM will effectively dr=
op
the LOCK semantics.  If that's indeed what's happening, you should see

  kvm: emulating exchange as write

in the host dmesg (just once though).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
