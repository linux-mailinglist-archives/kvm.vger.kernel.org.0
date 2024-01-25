Return-Path: <kvm+bounces-6973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C749F83B90D
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 06:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 781F828545A
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 05:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19506D287;
	Thu, 25 Jan 2024 05:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5H0MEyI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4885C1381
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 05:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706160188; cv=none; b=oT+5Hla8swpKi2aBqN9nDKm5NrdDV5h+mAoxHrpjgvNLbGy1kfdKkwqChukyvBnvhXqEhakSJXn75gLHWGz/PCalGZUOqmeeB1wvHPJc8pPveKjuvS1lYty58CuGMFY1ihxB7vt4iMcWgOtAY6w0gly3TB3Bpha7l6sgXVMQSaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706160188; c=relaxed/simple;
	bh=1eX8lTztm56ud9FjKkdssZKa3a22dudfPnfMcaB5cM8=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=KH3/x1Byg0rHRXNZJXth6nwr5q9vfrxEA6f8PVmHcpLoVv0naptmtP1n4XGbGc11WpUzMcmbc0XmFakfa29/Ex4htg6O84L7mzZpkD213i5BtyeoHSNta5teQcDiHcq2Ila+RfFllk2hntNtK201Kya32sCkZ1D4T267CskrS3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5H0MEyI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B18B9C433F1
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 05:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706160187;
	bh=1eX8lTztm56ud9FjKkdssZKa3a22dudfPnfMcaB5cM8=;
	h=From:To:Subject:Date:From;
	b=i5H0MEyItxpo37iwVW2/Rz+Cjn815Cv6AOTlzUE63s0v3HVqOyc1FZAYHN29pRxip
	 4dqnF9iqOZmVc8IMEsLZaaM4MYXHscLbenUUelVAyz0eea/7p7I5NgcrcuAZkBRe47
	 lgJIghNL08oUU4oinR879Jx1FtxdHZBhEz4CKX3epR7m1nNnY0V8xrAZ3rs95NzSRV
	 AeC2BeYBpFvkI5T1b+B9t6pQ7dpVZn6ZgEvxHyclh3wOGcGtxIiNGEb1p2xlkEWoG3
	 AOVWW1/CGSvPAYv9Jy/fR7YV1hsjhNUw8WUEmPZOSSZ1F1T1DX3FRA+tV2rp0VLBEv
	 pQq980DaNWhBw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9C9A0C53BD1; Thu, 25 Jan 2024 05:23:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218419] New: kvm-unit-tests asyncpf is skipped with no reason
Date: Thu, 25 Jan 2024 05:23:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: xiaoling.song@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218419-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218419

            Bug ID: 218419
           Summary: kvm-unit-tests asyncpf is skipped with no reason
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: xiaoling.song@intel.com
        Regression: No

kvm-unit-tests asyncpf test case report SKIP with no reason, log as below

./tests/asyncpf
BUILD_HEAD=3D3c1736b1
timeout -k 1s --foreground 90s /usr/local/bin/qemu-system-x86_64 --no-reboot
-nodefaults -device pc-testdev -device isa-debug-exit,iobase=3D0xf4,iosize=
=3D0x4
-vnc none -serial stdio -device pci-testdev -machine accel=3Dkvm -kernel
/tmp/tmp.Ruk4OlGWh7 -smp 1 -m 2048 # -initrd /tmp/tmp.jG2j3sfpQC
enabling apic
smp: waiting for 0 APs
paging enabled
cr0 =3D 80010011
cr3 =3D 107f000
cr4 =3D 20
install handler
enable async pf
alloc memory
start loop
end loop
start loop
end loop
SUMMARY: 0 tests
SKIP asyncpf (0 tests)

Tried to add a cgroup with below commonds still has the same issue

mkdir /sys/fs/cgroup/cg1
echo $$ >  /sys/fs/cgroup/cg1/cgroup.procs
echo 512M > /sys/fs/cgroup/cg1/memory.max

This issue happens for long time, and the latest versio I tried is V6.7-RC7

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

