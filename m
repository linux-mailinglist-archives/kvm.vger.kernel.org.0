Return-Path: <kvm+bounces-53788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DF3BB16E0A
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 11:00:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0CCF1AA128C
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 09:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0075B2BD031;
	Thu, 31 Jul 2025 08:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tsefVXAD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1D52BD012
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 08:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753952393; cv=none; b=rGXLwEg7DmChKIahQRC0Es4y6uwXanEqjtyiHFjXRPzl34oK+KkrCu3QIQpKE+ugv1CKChTd36HLIZGNtdrg3RwCGgLHFqgaur0iAbTXVfIvOjgL0RafwUwl4DYHj+iFTZPLPrNVTQAi7GuLHL/Hf1EQgj1Y1xMUP24cW41NIxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753952393; c=relaxed/simple;
	bh=RDxb8bGe+75On9yfoRm2rWCTy5v+hBx+CkeBMfSzYvg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MgZ1iibfjkSsbQwumj24NWvR5lFCz0AR6nJajQkP27W7ydG7H1i8C4ka00rdVcTrxqrzXasUGUzIJhQZzcAw/lLxnLUaS2KNqYS2cUaAylb0/2ea3cNaOj2tTdmbp80KA2yRwMlzAmeEl10gAjMgJhhEqBHyFXTENC3ld5SkOfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tsefVXAD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDA62C4CEF6
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 08:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753952392;
	bh=RDxb8bGe+75On9yfoRm2rWCTy5v+hBx+CkeBMfSzYvg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=tsefVXAD+gQQUSv7KFzFbyTWfqKeioOcbt09Qaul0vnB2rBJegmz8aBn6OuokeOLN
	 quKFd/a0RChLhsdF9J0D2ypHWbqaseO//PJWC3IQDkSKzPidxLKD3Jd4wdhNFsaGYs
	 xX7CmMGo9yU5xR0aatOYkwmloA99RiphojAoptlQ4AqwufoUF6V62pjZOTOU7e1CGd
	 uIwIh41cQFEXcyKjzezG4841HaLl7U3PdAEHUdUnUBLj1QQrD1TCeJgfZYAnrM0yvz
	 VOL1T3AmvHOCnmt+yXCYNxfDCIHaNKowPACm1Myr8put/BssEjMZqEkgfHS3DL1jJe
	 HJaVRsd6v5bkw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D2FFEC41616; Thu, 31 Jul 2025 08:59:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218792] Guest call trace with mwait enabled
Date: Thu, 31 Jul 2025 08:59:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: chenyi.qiang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218792-28872-QaPSh9KPXG@https.bugzilla.kernel.org/>
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

--- Comment #5 from chenyi.qiang@intel.com ---
On 5/1/2024 12:41 AM, Sean Christopherson wrote:
> On Tue, Apr 30, 2024, bugzilla-daemon@kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D218792
>>
>>             Bug ID: 218792
>>            Summary: Guest call trace with mwait enabled
>>            Product: Virtualization
>>            Version: unspecified
>>           Hardware: Intel
>>                 OS: Linux
>>             Status: NEW
>>           Severity: normal
>>           Priority: P3
>>          Component: kvm
>>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>>           Reporter: farrah.chen@intel.com
>>         Regression: No
>>
>> Environment:
>> host/guest kernel:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>> e67572cd220(v6.9-rc6)
>> QEMU: https://gitlab.com/qemu-project/qemu.git master 5c6528dce86d
>> Host/Guest OS: Centos stream9/Ubuntu24.04
>>
>> Bug detail description:=20
>> Boot Guest with mwait enabled(-overcommit cpu-pm=3Don), guest call trace
>> "unchecked MSR access error"
>>
>> Reproduce steps:
>> img=3Dcentos9.qcow2
>> qemu-system-x86_64 \
>>     -name legacy,debug-threads=3Don \
>>     -overcommit cpu-pm=3Don \
>>     -accel kvm -smp 8 -m 8G -cpu host \
>>     -drive file=3D${img},if=3Dnone,id=3Dvirtio-disk0 \
>>     -device virtio-blk-pci,drive=3Dvirtio-disk0 \
>>     -device virtio-net-pci,netdev=3Dnic0 -netdev
>> user,id=3Dnic0,hostfwd=3Dtcp::10023-:22 \
>>     -vnc :1 -serial stdio
>>
>> Guest boot with call trace:
>> [ 0.475344] unchecked MSR access error: RDMSR from 0xe2 at rIP:
>=20
> MSR 0xE2 is MSR_PKG_CST_CONFIG_CONTROL, which hpet_is_pc10_damaged() assu=
mes
> exists if PC10 substates are supported. KVM doesn't emulate/support
> MSR_PKG_CST_CONFIG_CONTROL, i.e. injects a #GP on the guest RDMSR, hence =
the
> splat.  This isn't a KVM bug as KVM explicitly advertises all zeros for t=
he
> MWAIT CPUID leaf, i.e. QEMU is effectively telling the guest that PC10
> substates
> are support without KVM's explicit blessing.
>=20
> That said, this is arguably a kernel bug (guest side), as I don't see
> anything
> in the SDM that _requires_ MSR_PKG_CST_CONFIG_CONTROL to exist if PC10
> substates
> are supported.
>=20
> The issue is likely benign, other that than obvious WARN.  The kernel
> gracefully
> handles the #GP and zeros the result, i.e. will always think PC10 is
> _disabled_,
> which may or may not be correct, but is functionally ok if the HPET is be=
ing
> emulated by the host, which it probably is.
>=20
>       rdmsrl(MSR_PKG_CST_CONFIG_CONTROL, pcfg);
>       if ((pcfg & 0xF) < 8)
>               return false;
>=20
> The most straightforward fix, and probably the most correct all around, w=
ould
> be
> to use rdmsrl_safe() to suppress the WARN, i.e. have the kernel not yell =
if
> MSR_PKG_CST_CONFIG_CONTROL doesn't exist.  Unless HPET is also being pass=
ed
> through, that'll do the right thing when Linux is a guest.  And if a setup
> also
> passes through HPET, then the VMM can also trap-and-emulate
> MSR_PKG_CST_CONFIG_CONTROL
> as appropriate (doing so in QEMU without KVM support might be impossible,
> though
> again it's unnecessary if QEMU is emulating the HPET).
>=20
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index c96ae8fee95e..2afafff18f92 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -980,7 +980,9 @@ static bool __init hpet_is_pc10_damaged(void)
>                 return false;
>=20=20
>         /* Check whether PC10 is enabled in PKG C-state limit */
> -       rdmsrl(MSR_PKG_CST_CONFIG_CONTROL, pcfg);
> +       if (rdmsrl_safe(MSR_PKG_CST_CONFIG_CONTROL, pcfg))
> +               return false;
> +
>         if ((pcfg & 0xF) < 8)
>                 return false;

There are three places which could access MSR_PKG_CST_CONFIG_CONTROL.
1. hpet_is_pc10_damaged() in hpet.c
2. *_idle_state_table_update() in intel_idle.c (This BUG comes from this pa=
th
in VMs)
3. auto_demotion_disable() in intel_idle.c

This MSR seems not architectural but CPU model specific.

Besides the case 1 as mentioned, the intel_idle driver also uses it to query
the
lowest processor-specific C-state for the package (case 2) and to disable a=
uto
demotion
(case 3) based on the specific model.

I assume both case 2 and 3 are aimed to improve energy-efficiency. For exam=
ple,
spr_idle_state_table_update() adjusts the exit_latency/target_residency to
hardcoded ones based on
the package C-state limit. It seems unreasonable in VMs as the hardcoded va=
lues
are measured in host
and the guest CPU model may not match the host one if we only pass-thru this
MSR. Similarly,
for case 3, there is no guarantee that disabling auto demotion can improve
energy efficiency in a
emulated CPU model.

Since there is no such fine-grained power management virtualization support
yet. Can we change
all the rdmsr/wrmsr(MSR_PKG_CST_CONFIG_CONTROL) to the *_safe() variant to =
skip
the related operation
in VMs?

>=20
>> 0xffffffffb5a966b8 (native_read_msr+0x8/0x40)
>> [ 0.476465] Call Trace:
>> [ 0.476763] <TASK>
>> [ 0.477027] ? ex_handler_msr+0x128/0x140
>> [ 0.477460] ? fixup_exception+0x166/0x3c0
>> [ 0.477934] ? exc_general_protection+0xdc/0x3c0
>> [ 0.478481] ? asm_exc_general_protection+0x26/0x30
>> [ 0.479052] ? __pfx_intel_idle_init+0x10/0x10
>> [ 0.479587] ? native_read_msr+0x8/0x40
>> [ 0.480057] intel_idle_init_cstates_icpu.constprop.0+0x5e/0x560
>> [ 0.480747] ? __pfx_intel_idle_init+0x10/0x10
>> [ 0.481275] intel_idle_init+0x161/0x360
>> [ 0.481742] do_one_initcall+0x45/0x220
>> [ 0.482209] do_initcalls+0xac/0x130
>> [ 0.482643] kernel_init_freeable+0x134/0x1e0
>> [ 0.483159] ? __pfx_kernel_init+0x10/0x10
>> [ 0.483648] kernel_init+0x1a/0x1c0
>> [ 0.484087] ret_from_fork+0x31/0x50
>> [ 0.484541] ? __pfx_kernel_init+0x10/0x10
>> [ 0.485030] ret_from_fork_asm+0x1a/0x30
>> [ 0.485462] </TASK>
>>
>> --=20
>> You may reply to this email to add a comment.
>>
>> You are receiving this mail because:
>> You are watching the assignee of the bug.
>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

