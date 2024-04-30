Return-Path: <kvm+bounces-16216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 652AE8B6BD5
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 09:34:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9635A1C21E77
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 07:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F2833EA72;
	Tue, 30 Apr 2024 07:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DmTYeuBr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A632335BC
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 07:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714462347; cv=none; b=kmQrBHKh6nLCpHpU4fP7lwf3HZAJsUHcwkClbz/c+JP3SJ9TZgLWQ+JgtpvS3GZw7wvViPHAqpKaaE/suuPMA7w+01XEuqoy4MFilfAgtgTSv4YQjMM2K/SqUpXubJzSU6BJ0mzVHigrMvbqvyZSD4MV7QfgW56wS+V60ezdI4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714462347; c=relaxed/simple;
	bh=/iEEC+3sP2+9ZekLB59E6CkoSG61AexJ5p1MpoKI8Hw=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=D83FrZ7DrJpRIDRsg2Bra5O+5PVnwQj8o9pyyT/qnQpXnPdVJ3H80bqqPUH/B1Oky84SHw/0GNadW1lrBl1u6ArDLxNpuyxnavHfYfi8D7aLXmuzG341jc+kSy6ON0rkn+6CFMKDHvsADnH97Urdov7OJj1jqg/JBYcHXtju8PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DmTYeuBr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E64B5C4AF17
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 07:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714462346;
	bh=/iEEC+3sP2+9ZekLB59E6CkoSG61AexJ5p1MpoKI8Hw=;
	h=From:To:Subject:Date:From;
	b=DmTYeuBrji9TuzUVudST6Zet08jHOTwQXiZbL/6Wa2NxG/0x7a4oBRCIZGhoViNha
	 9d9P6oggpFu1TNShXMOcWzQsee2Q+kBTShWNBnLeLCNG8MczPgz23McVansnz3mbEy
	 u/GIcB0H3gFP1JSSlSVrn+5iB82NLmz92HLG41ixMRatRG+wbbl3sb0QLKXpK9gaGn
	 vT0PAEfk4KT5E1rA8PKBEA9hJazZuKgJW6SprmZUR1P07AuloB9LaxNY3ywHBA2+3c
	 tG/jI42KOev6bAfFvTZj248zlfznzPo9BHWy8KsjX7mlDlBGTi8tJxNdWQoEzGPW80
	 iqVTPKt8m3qIQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D6F2AC53B6A; Tue, 30 Apr 2024 07:32:26 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218792] New: Guest call trace with mwait enabled
Date: Tue, 30 Apr 2024 07:32:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218792-28872@https.bugzilla.kernel.org/>
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

            Bug ID: 218792
           Summary: Guest call trace with mwait enabled
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: farrah.chen@intel.com
        Regression: No

Environment:
host/guest kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
e67572cd220(v6.9-rc6)
QEMU: https://gitlab.com/qemu-project/qemu.git master 5c6528dce86d
Host/Guest OS: Centos stream9/Ubuntu24.04

Bug detail description:=20
Boot Guest with mwait enabled(-overcommit cpu-pm=3Don), guest call trace
"unchecked MSR access error"

Reproduce steps:
img=3Dcentos9.qcow2
qemu-system-x86_64 \
    -name legacy,debug-threads=3Don \
    -overcommit cpu-pm=3Don \
    -accel kvm -smp 8 -m 8G -cpu host \
    -drive file=3D${img},if=3Dnone,id=3Dvirtio-disk0 \
    -device virtio-blk-pci,drive=3Dvirtio-disk0 \
    -device virtio-net-pci,netdev=3Dnic0 -netdev
user,id=3Dnic0,hostfwd=3Dtcp::10023-:22 \
    -vnc :1 -serial stdio

Guest boot with call trace:
[ 0.475344] unchecked MSR access error: RDMSR from 0xe2 at rIP:
0xffffffffb5a966b8 (native_read_msr+0x8/0x40)
[ 0.476465] Call Trace:
[ 0.476763] <TASK>
[ 0.477027] ? ex_handler_msr+0x128/0x140
[ 0.477460] ? fixup_exception+0x166/0x3c0
[ 0.477934] ? exc_general_protection+0xdc/0x3c0
[ 0.478481] ? asm_exc_general_protection+0x26/0x30
[ 0.479052] ? __pfx_intel_idle_init+0x10/0x10
[ 0.479587] ? native_read_msr+0x8/0x40
[ 0.480057] intel_idle_init_cstates_icpu.constprop.0+0x5e/0x560
[ 0.480747] ? __pfx_intel_idle_init+0x10/0x10
[ 0.481275] intel_idle_init+0x161/0x360
[ 0.481742] do_one_initcall+0x45/0x220
[ 0.482209] do_initcalls+0xac/0x130
[ 0.482643] kernel_init_freeable+0x134/0x1e0
[ 0.483159] ? __pfx_kernel_init+0x10/0x10
[ 0.483648] kernel_init+0x1a/0x1c0
[ 0.484087] ret_from_fork+0x31/0x50
[ 0.484541] ? __pfx_kernel_init+0x10/0x10
[ 0.485030] ret_from_fork_asm+0x1a/0x30
[ 0.485462] </TASK>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

