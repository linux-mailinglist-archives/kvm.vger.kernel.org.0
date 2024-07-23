Return-Path: <kvm+bounces-22125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39BEF93A778
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 20:53:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6E4FB218C9
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 18:53:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA5313D898;
	Tue, 23 Jul 2024 18:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J2pHNVdK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39E513C8EE
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 18:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760799; cv=none; b=Dg5D5raYHP3UKy+KpQS91rQTi2AVJSXjr4dFKmatcEW/22xWj9yvu2tpk0zuUpdbnjjWOiIMkFCF/+TNOZME5LGsCEh3wP0/Cgyvls1xMYdRz357uX0xBEctX2eLERKmGGlY3A0MtwTM5AayoHi+Q61KPD2GcqO5f4mBONQY71Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760799; c=relaxed/simple;
	bh=B8ErdYKQMQzZuQD+SdqPlygxSQ0qaad1LYSXB77MtkY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ri+wxb6/oelYSXcvEFe9QKSLIo1BfQMdzdfFRf6R97jSaAABYYO53N60WLVV8SuNgCUFRu8ey7NHJahdB8/u5WXxw8x5FLNVHCe1sHT4hX/zt/O5CNY+8f+1TEllrR5o0M/hpe2vVE2i4EXgXhAiWSJ2W8+90thgkexv7YyQWak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J2pHNVdK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62E0DC4AF09
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 18:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721760799;
	bh=B8ErdYKQMQzZuQD+SdqPlygxSQ0qaad1LYSXB77MtkY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=J2pHNVdKd112Jd8oFeIL0owp3tvxqhUARnZCd1O9oZEg/M7QZ/NCXLOBT9lABo6Wg
	 PrildhhlLICi42jWQrkDFynWGwG8NhbAgtUirN+E56atM9uDVSSEpkyNV6wHvK29Rn
	 eHFy4ArWgiPf0KTJEDxRDiMYo5fgCKHNefgGWrLTERbv1tZHaec1OWNhC6fgegAR4H
	 6Q49k495nCm2jqzRNYodD7LyXm6L6uHjd+hOmD9FcegoDrKUdrh38lQgWGhZ4pfkRX
	 8FHdoW3hr07/bz7CGE1U3afBSTH+UwQ6ErfqnY9oL6uXITZX4/ETYkhnvJTZd4T7st
	 xKtylGgl2HsEA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 551CDC433E5; Tue, 23 Jul 2024 18:53:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219085] kvm_spurious_fault in L1 when running a nested kvm
 instance on AMD Opteron_G5_qemu L0
Date: Tue, 23 Jul 2024 18:53:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ununpta@mailto.plus
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219085-28872-QBm5HWk6wX@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219085-28872@https.bugzilla.kernel.org/>
References: <bug-219085-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219085

--- Comment #3 from ununpta@mailto.plus ---
> Do you you see the same behavior on other kernel (L1) version?  Have you
> changed any other components (especially in L0)?

Thank you for your help.

What I tried:
* Opened Hyper-V manager built in Windows and created Ubuntu 22.04 LTS
available by default.
* Opened PowerShell console and ran `Set-VMProcessor -VMName "Ubuntu 22.04 =
LTS"
-ExposeVirtualizationExtensions $true` to allow Nested Virtualization in
Hyper-V.

I have to notice, though, that even without `ExposeVirtualizationExtensions
$true`, KVM inside Hyper-V manager didn't crash as it did in qemu. Bash just
printed a warning that nested virtualization is restricted.

* Booted into "Ubuntu 22.04 LTS", installed qemu and `qemu-system-x86_64 -a=
ccel
kvm` was successfull - BIOS was shown up.
Default kernel was vmlinuz-5.15.0-27-generic - After qemu launch, only
kvm-related messages were:
[2.485820] kvm: Nested Virtualization enabled
[2.485822] SVM: kvm: Nested Paging enabled
[2.485823] SVM: kvm: Hyper-V enlightened NPT TLB flush enabled
[2.485824] SVM: kvm: Hyper-V Direct TLB flush enabled
[2.485828] SVM: Virtual VMLOAD VMSAVE supported

Then I recompiled latest kernel and installed it with the same successful
KVM-accelerated qemu BIOS boot.
vmlinuz-6.10.0 - After qemu launch, only kvm-related messages are:

[1.701988] kvm_amd: TSC scaling supported
[1.701992] kvm_amd: Nested Virtualization enabled
[1.701993] kvm_amd: Nested Paging enabled
[1.701996] kvm_amd: kvm_amd: Hyper-V enlightened NPT TLB flush enabled
[1.701997] kvm_amd: kvm_amd: Hyper-V Direct TLB flush enabled
[1.701999] kvm_amd: Virtual VMLOAD VMSAVE supported
[1.702000] kvm_amd: PMU virtualization is disabled

I have to guess how to allow `Set-VMProcessor -VMName "Ubuntu 22.04 LTS"
-ExposeVirtualizationExtensions $true` for third-party software, not only f=
or
machines created by Hyper-V manager. Maybe Qemu has to be run under admin
priveleges as well.

I also saw a claim from Peter Maydell, qemu developer, who had said this ab=
out
qemu command line parameter `-cpu _processor_type_`:
> using a specific cpu type will only work with KVM if the host CPU really =
is
> that exact CPU type, otherwise, use "-cpu host" or "-cpu max".
> This is a restriction in the kernel's KVM handling, and not something that
> can be worked around in the QEMU side.
Per https://gitlab.com/qemu-project/qemu/-/issues/239

I was somewhat confused by this claim because=20
> --- Comment #1 from ununpta@mailto.plus ---
> Command I used on L0 AMD Ryzen:
> qemu-system-x86_64.exe -m 4096 -machine q35 -accel whpx -smp 1 -cpu
> Opteron_G5

Let me ask you a few questions.
Q1: Can one use an older cpu (but still supporting SVM), not the actual bare
one in qemu command line for nested virtualization or KVM will crash due to
restriction in the kernel's KVM handling?
Q2: Is there a command in bare Kernel/KVM console to figure out if EFER.SVME
register/bit is writeable? If not,
Q3: Can you recommend any package to figure out it?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

