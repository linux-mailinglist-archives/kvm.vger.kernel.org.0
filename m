Return-Path: <kvm+bounces-61798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 36492C2AB0F
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 10:13:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 93E8D4E69EA
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 09:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE5B2E5B1B;
	Mon,  3 Nov 2025 09:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sd3HN1tK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322421B87C9
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 09:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762161172; cv=none; b=dAztxBLIzHzj3lQzctgD3rRbX3rYODQXQ8oT+soHNLQuufypgRkxV7vGvdJdpaevDtSSJAW5Y6hNelg8x1Rjnysv6H+Di68mhHs//SQQJpkqvtS7kc4nsigk+XJyowgTyK3n1B/sqpRjYxjtNGngDl5aDoVJ9HmtFeskQXhaJUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762161172; c=relaxed/simple;
	bh=PBYpNLYnnMbku+7d1x4dCv4wHnzS9z2Su+rR8nJHbOM=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=J9M4fT4mFASNyOd3sH3RbivG8nCvS0Nrj8eqhnjVcJJPi0QY7fiLjGzWXuwITee92Rlz0zDNrIkD0dIakx6PVEOTiQSuZLnys7xQzNflhrvK1p3P0DKvjqSpoWJkGInyX5fUjaYuvVHO6Winour7qRzp5E4vldWz/J2irM/fIFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sd3HN1tK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF2D5C116D0
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 09:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762161171;
	bh=PBYpNLYnnMbku+7d1x4dCv4wHnzS9z2Su+rR8nJHbOM=;
	h=From:To:Subject:Date:From;
	b=sd3HN1tKLLoeuu0jOEaE4cr/00A69FEZolKlqqL2jvHiBLmH57upbYDZWo9vNXNWI
	 UhzDcUi2QLUfDgKNwIoluaYytWBW/WDZ/ITCBvQvfdIPbsNstQ4NuWDEqoqUAPRwqc
	 0DBqVIAh7YJzc9IdVcFNscdyNrj4TW8Uqemo8PKYhV7mhLHrbcpPWeiO12bp7jNpmi
	 Jq4z1FDtc81YYYeRL9DmkQnfftsXJLYvH0Gh7tx/uM1UZgtQ4SfADdWyLQ7/OcQB2E
	 Kj1dx7QGGXrQj21XrW0noSaNUMR13MWnJvSrFn2x2VQLLjlmccXkocBc093LTHzqaF
	 id5LxYkWhYzjA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A3BE0C41613; Mon,  3 Nov 2025 09:12:51 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220740] New: Host crash when do PF passthrough to KVM guest
 with some devices
Date: Mon, 03 Nov 2025 09:12:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-220740-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220740

            Bug ID: 220740
           Summary: Host crash when do PF passthrough to KVM guest with
                    some devices
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: farrah.chen@intel.com
        Regression: No

Environment:

Host Kernel: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux=
.git
v6.18.0-rc4

Guest kernel: 6.17-rc7

QEMU: https://gitlab.com/qemu-project/qemu.git master 37ad0e48e9fd58b17

Bug detail description:=20

when do PF passthrough to KVM guest with some devices, guest failed to boot=
 and
host crash.

Not all devices can trigger this issue, currently, I found Intel NIC
X710(almost every time) and Nvidia GPU A10(randomly) can reproduce this iss=
ue.
VF passthrough can't reproduce this issue.

Reproduce steps:=20

Add "intel_iommu=3Don" host kernel cmdline to enable VTD
Check VTD in dmesg
[root@gnr ~]# dmesg|grep "Virtualization Technology"
[   27.313975] DMAR: Intel(R) Virtualization Technology for Directed I/O
Check BDF of X710
[root@gnr ~]# lspci|grep "X710"
b8:00.0 Ethernet controller: Intel Corporation Ethernet Controller X710 for
10GbE SFP+ (rev 01)
...
Bind X710 to vfio-pci driver
[root@gnr ~]# modprobe vfio-pci
[root@gnr ~]# echo 0000:b8:00.0 >
/sys/bus/pci/devices/0000\:b8\:00.0/driver/unbind

[root@gnr ~]# lspci -n -s b8:00.0
b8:00.0 0200: 8086:1572 (rev 01)
[root@gnr ~]# echo 8086 1572 > /sys/bus/pci/drivers/vfio-pci/new_id
[root@gnr ~]# lspci -k -s b8:00.0
b8:00.0 Ethernet controller: Intel Corporation Ethernet Controller X710 for
10GbE SFP+ (rev 01)
        Subsystem: Intel Corporation Ethernet Converged Network Adapter X71=
0-2
        Kernel driver in use: vfio-pci
        Kernel modules: i40e

Boot guest with b8:00.0 assigned
/home/qemu/build/qemu-system-x86_64 \
    -name legacy,debug-threads=3Don \
    -accel kvm \
    -cpu host \
    -smp 16 \
    -m 16G \
    -drive file=3D/home/centos9.qcow2,if=3Dnone,id=3Dvirtio-disk0 \
    -device virtio-blk-pci,drive=3Dvirtio-disk0 \
    -vnc :1 \
    -monitor telnet:127.0.0.1:45455,nowait,server \
    -device vfio-pci,host=3Db8:00.0 \
    -serial stdio
Error log:=20

VM failed to boot, no output.
Host crash with below error in serial output.

gnr login: [  120.259677] i40e 0000:b8:00.0: i40e_ptp_stop: removed PHC on
ens26f0np0

[  136.778544] vfio-pci 0000:b8:00.0: resetting

[  136.891303] vfio-pci 0000:b8:00.0: reset done

[  136.896389] vfio-pci 0000:b8:00.0: Masking broken INTx support

[  136.940637] vfio-pci 0000:b8:00.0: resetting

[  137.051298] vfio-pci 0000:b8:00.0: reset done

[IEH] error found at IEH(S:0x1 B:0xFE D:0x2 F:0x0) Sev: IEH CORRECT ERROR

[IEH] ErrorStatus 0x10, MaxBitIdx 0x1D

IEH CORRECT ERROR

[IEH] BitIdx 0x4, ShareIdx 0x0

[IEH] error device is (S:0x1 B:0xB7 D:0x0 F:0x4) BitIdx 0x4, ShareIdx 0x0 [=
IEH]
error found at IEH(S:0x1 B:0xB7 D:0x0 F:0x4) Sev: IEH CORRECT ERROR

[IEH] ErrorStatus 0x4, MaxBitIdx 0x11

IEH CORRECT ERROR

[IEH] BitIdx 0x2, ShareIdx 0x0

[IEH] error device is (S:0x1 B:0xB7 D:0x2 F:0x0) BitIdx 0x2, ShareIdx 0x0=
=20=20
[Device Error] error on skt:0x1 Bus:0xB7 Device:0x2 func:0x0

PcieRootPortErrorHandler MailBox->PcieInitPar.SerrEmuTestEn =3D 0x0

PcieRootPortMultiErrorsHandler RP Error handler.

ERROR: C00000002:V03071008 I0 515DFD4E-2D7E-40D1-8C22-8AD3CD224325 7C7C9818

WHEA: Detected PCIe Error

 --Logging Corrected Error to WHEA

WHEA: Sending OS notification via SCI. Success

ERROR: C00000002:V03071008 I0 515DFD4E-2D7E-40D1-8C22-8AD3CD224325 7C7C9818

WHEA: Detected PCIe Error

 --Logging Corrected Error to WHEA

WHEA: Sending OS notification via SCI. Success
...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

