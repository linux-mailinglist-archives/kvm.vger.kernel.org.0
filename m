Return-Path: <kvm+bounces-43407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 25EBAA8B451
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 10:49:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32C9B7A38CD
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 08:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 933CE230BD2;
	Wed, 16 Apr 2025 08:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DPZHo5DT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF2A21D594
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 08:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744793367; cv=none; b=XKNJL+9hb0yY6tNUW3T+S1IqG41oWyFhD3kD8LS2lM7SDo/FwjVwHqi5NIlJ8dUX7RJOEJyp4KtCkV4hxJ/twmC9f+6tlIpfiKLDJpjjBs37TwOeBE3Xp06VLLCMT6NBA+AlDLwUMClSCPa8OLP2VaVtHnLi4YmvzKUb4qqZXHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744793367; c=relaxed/simple;
	bh=YbiC2uPMwr5zERCkWpKvycdCJ5uXHTpyR2ESiZlBK4A=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=fE//vna5qutZLOZCchh1zHzCvmWsVCxbU163NkCdt+Cd5KYCqsKRq6BHLl/chuTJn0k5tiwK/TsrzTl0hMZqVdpaJ5qhQzxdEG234XP3XHCkcoMJrnbNLDKMK+SLfO7nDA/uLOr8xAmpd0wesQvU4FDcLcGTFZxAXxiaujFlX8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DPZHo5DT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3162EC4CEED
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 08:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744793367;
	bh=YbiC2uPMwr5zERCkWpKvycdCJ5uXHTpyR2ESiZlBK4A=;
	h=From:To:Subject:Date:From;
	b=DPZHo5DT/IjjotF1Cc96TbaqLlNF34xBuJuFIfdvjN+tGKTGyzQ0ePJ5/Ac6wI2bo
	 feRz7bVgpbWkS4rB1/sPPqwTP1EQ6BoCF8AH4FnfVVXK1UP++NTVVKD9NORxsx/dvm
	 o5G0wN+yRpZSrql2b1tU9eg0l0JHNWZZtWERp4hfaPoAO+MUA95HXQXWDA9zsNoCmu
	 Zqv6jEM7P0PnYOepbD9D4aemMMiaQf7sORjFdzS6v5uko5aY+9EIP1G9P30dfuPjh+
	 vcR0od+Ha6EQ2pIDgS8MnJCDFvhRxb4Iu9eJ9xm4DCWjkyAfRdGXCsZA9Ef4VEUktj
	 6/vzvhvYVvbkQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 19C87C53BBF; Wed, 16 Apr 2025 08:49:27 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220019] New: Host call trace and crash after boot guest with
 perf kvm stat record
Date: Wed, 16 Apr 2025 08:49:26 +0000
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
Message-ID: <bug-220019-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220019

            Bug ID: 220019
           Summary: Host call trace and crash after boot guest with perf
                    kvm stat record
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

CPU: EMR/GNR

Host kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

Guest kernel: 6.15-rc2 release

QEMU: https://gitlab.com/qemu-project/qemu.git

Bug detail description:=20

Host call trace and crash when boot guest with perf kvm stat record, host c=
rash
in 1~2s after guest boot up

Reproduce steps:=20

Boot guest with perf kvm stat record:

perf kvm stat record qemu-system-x86_64 \
    -name legacy,debug-threads=3Don \
    -accel kvm -smp 4 -m 4G -cpu host \
    -drive file=3D${img},if=3Dnone,id=3Dvirtio-disk0 \
    -serial stdio

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

