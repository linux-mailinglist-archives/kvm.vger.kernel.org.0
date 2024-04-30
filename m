Return-Path: <kvm+bounces-16244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADF888B7D50
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:42:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64FA0288E9E
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 16:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E05A179654;
	Tue, 30 Apr 2024 16:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nAkxy/Fc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A11173336
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 16:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495322; cv=none; b=LWwJ+HVBKqLDGBXXpcC8bYcu0biZE0QCogZihsOywdWFtQKf3GhmoG7OMAhWXqkA8hJuDQHuuqJVrz0hdCS82QmbQerH4T5NsiiSeQl2X+fKEmKwY4ATcp6+HNW4r4OAHjHPhDC73BaBy/re50J20fbwROXpRWB+bMfTpk2sQYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495322; c=relaxed/simple;
	bh=SvAxgWZMq5bt6D/2ZDuKNOxpsC2JfO/eQ3BUduAwkDw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bL+v2DNviNolcg5rJn/E+ggXhDaGLn2kat+ORBzh5rSzySvlIQgkqRTMYIAJZ0vn9clTMTM39YIqgodp3/MQ2oQPtHS3ZDBkKv4KXqKEs0J0hki67/mV8HGpWLueShydhazzm7cSwawfiQQ+AZ6aT5kY0q01joX2i2yxS9YEIqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nAkxy/Fc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFD7CC4AF19
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 16:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714495322;
	bh=SvAxgWZMq5bt6D/2ZDuKNOxpsC2JfO/eQ3BUduAwkDw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nAkxy/FcE8x+TBOan7Ri1RB9FhjpUio1yeCupJ1Yla6/vNp70v9/mDp7lvsB7pkkp
	 WlWi843aPJI9F3bYg6TzD0cOyCa9Xcb8kc9mYr0hzX9lCSQaTohvdL+wXvxa53/6Kn
	 PlGJ+HZ57OaXBGgPGoFvm+z2dtOYimzEyM1Hh8FKXj4LUZhEVsuLs8OBOQHqyRa4Ow
	 NXLswnA/FNsB4RadpXin2vaXubO45d9ekr6dH96582QQwFZ/eEb/RWZfjQHo3wopLi
	 Jj8o46oebjcqO0+UgA8h8/rgQtUE1qrdF+BdE5lEvmiSBrcfqDK8saaf49hbH6k94v
	 ds+WUbBHZAswg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DED6CC53B6D; Tue, 30 Apr 2024 16:42:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218792] Guest call trace with mwait enabled
Date: Tue, 30 Apr 2024 16:42:01 +0000
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
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218792-28872-lxsmrNaaL3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218792-28872@https.bugzilla.kernel.org/>
References: <bug-218792-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D218792

--- Comment #2 from Sean Christopherson (seanjc@google.com) ---
On Tue, Apr 30, 2024, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218792
>=20
>             Bug ID: 218792
>            Summary: Guest call trace with mwait enabled
>            Product: Virtualization
>            Version: unspecified
>           Hardware: Intel
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: farrah.chen@intel.com
>         Regression: No
>=20
> Environment:
> host/guest kernel:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> e67572cd220(v6.9-rc6)
> QEMU: https://gitlab.com/qemu-project/qemu.git master 5c6528dce86d
> Host/Guest OS: Centos stream9/Ubuntu24.04
>=20
> Bug detail description:=20
> Boot Guest with mwait enabled(-overcommit cpu-pm=3Don), guest call trace
> "unchecked MSR access error"
>=20
> Reproduce steps:
> img=3Dcentos9.qcow2
> qemu-system-x86_64 \
>     -name legacy,debug-threads=3Don \
>     -overcommit cpu-pm=3Don \
>     -accel kvm -smp 8 -m 8G -cpu host \
>     -drive file=3D${img},if=3Dnone,id=3Dvirtio-disk0 \
>     -device virtio-blk-pci,drive=3Dvirtio-disk0 \
>     -device virtio-net-pci,netdev=3Dnic0 -netdev
> user,id=3Dnic0,hostfwd=3Dtcp::10023-:22 \
>     -vnc :1 -serial stdio
>=20
> Guest boot with call trace:
> [ 0.475344] unchecked MSR access error: RDMSR from 0xe2 at rIP:

MSR 0xE2 is MSR_PKG_CST_CONFIG_CONTROL, which hpet_is_pc10_damaged() assumes
exists if PC10 substates are supported. KVM doesn't emulate/support
MSR_PKG_CST_CONFIG_CONTROL, i.e. injects a #GP on the guest RDMSR, hence the
splat.  This isn't a KVM bug as KVM explicitly advertises all zeros for the
MWAIT CPUID leaf, i.e. QEMU is effectively telling the guest that PC10
substates
are support without KVM's explicit blessing.

That said, this is arguably a kernel bug (guest side), as I don't see anyth=
ing
in the SDM that _requires_ MSR_PKG_CST_CONFIG_CONTROL to exist if PC10
substates
are supported.

The issue is likely benign, other that than obvious WARN.  The kernel
gracefully
handles the #GP and zeros the result, i.e. will always think PC10 is
_disabled_,
which may or may not be correct, but is functionally ok if the HPET is being
emulated by the host, which it probably is.

        rdmsrl(MSR_PKG_CST_CONFIG_CONTROL, pcfg);
        if ((pcfg & 0xF) < 8)
                return false;

The most straightforward fix, and probably the most correct all around, wou=
ld
be
to use rdmsrl_safe() to suppress the WARN, i.e. have the kernel not yell if
MSR_PKG_CST_CONFIG_CONTROL doesn't exist.  Unless HPET is also being passed
through, that'll do the right thing when Linux is a guest.  And if a setup =
also
passes through HPET, then the VMM can also trap-and-emulate
MSR_PKG_CST_CONFIG_CONTROL
as appropriate (doing so in QEMU without KVM support might be impossible,
though
again it's unnecessary if QEMU is emulating the HPET).

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index c96ae8fee95e..2afafff18f92 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -980,7 +980,9 @@ static bool __init hpet_is_pc10_damaged(void)
                return false;

        /* Check whether PC10 is enabled in PKG C-state limit */
-       rdmsrl(MSR_PKG_CST_CONFIG_CONTROL, pcfg);
+       if (rdmsrl_safe(MSR_PKG_CST_CONFIG_CONTROL, pcfg))
+               return false;
+
        if ((pcfg & 0xF) < 8)
                return false;

> 0xffffffffb5a966b8 (native_read_msr+0x8/0x40)
> [ 0.476465] Call Trace:
> [ 0.476763] <TASK>
> [ 0.477027] ? ex_handler_msr+0x128/0x140
> [ 0.477460] ? fixup_exception+0x166/0x3c0
> [ 0.477934] ? exc_general_protection+0xdc/0x3c0
> [ 0.478481] ? asm_exc_general_protection+0x26/0x30
> [ 0.479052] ? __pfx_intel_idle_init+0x10/0x10
> [ 0.479587] ? native_read_msr+0x8/0x40
> [ 0.480057] intel_idle_init_cstates_icpu.constprop.0+0x5e/0x560
> [ 0.480747] ? __pfx_intel_idle_init+0x10/0x10
> [ 0.481275] intel_idle_init+0x161/0x360
> [ 0.481742] do_one_initcall+0x45/0x220
> [ 0.482209] do_initcalls+0xac/0x130
> [ 0.482643] kernel_init_freeable+0x134/0x1e0
> [ 0.483159] ? __pfx_kernel_init+0x10/0x10
> [ 0.483648] kernel_init+0x1a/0x1c0
> [ 0.484087] ret_from_fork+0x31/0x50
> [ 0.484541] ? __pfx_kernel_init+0x10/0x10
> [ 0.485030] ret_from_fork_asm+0x1a/0x30
> [ 0.485462] </TASK>
>=20
> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are watching the assignee of the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

