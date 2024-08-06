Return-Path: <kvm+bounces-23334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1451948C05
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 11:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 498131F22957
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 09:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2D81BDA88;
	Tue,  6 Aug 2024 09:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H3yGlO2B"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7542C1607BD
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 09:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722935813; cv=none; b=djBRsAd459Pvxmj9amEDCJX3O4XcR1nrgbx0R+kMkzYZhVIezpRV08og6eFcGwiWbHX9syBdwAN4JkmZGnQb7+hYLOPhbPzYKv5ZLxeh2jOoGf5PCtibEWcigIOHGkWBSbZdSPbWEdFdqE/DtMuZ9ou3hetOQvXWdYuvf+GThCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722935813; c=relaxed/simple;
	bh=B36e82GqyWf2vZzNudReK+uz6/B3zOnvIEcQ/iYoF0k=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=CpDSBO45Ic08Sioxk1pIYjD85fyir6vMfLc1LDgseGttQHIzuN79Is9jqd/tWbqPiLfM4G9W255CjZngkRu8uG6AAxrQsmEqNY8DS39GSK/K8REO2nOUupgDh0Jg0WbJ9/XowuCpe8JKgIcCXdQIAz3IV5O68R2SzXPYFLlhZLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H3yGlO2B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21B25C4AF14
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 09:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722935813;
	bh=B36e82GqyWf2vZzNudReK+uz6/B3zOnvIEcQ/iYoF0k=;
	h=From:To:Subject:Date:From;
	b=H3yGlO2BllzyOwmJqkAZqze1PTGH3uRgRSBrAXuYJZIoEDBIGScUWK4Rp5MsaaObg
	 kSSxLtV+Hr7AsaFS8FeCb0ImyDTs4g2RYIhpr+TiGY1NRbAn54gnv30VhTbDssDec0
	 uPEW6i1TZbXyyvN94eozLQHkIj+uQ38SSRGjfE6aj6WaFq0dxRzHS9JIcUhxcw1nOY
	 Wwuzwkl7G6dBEt1/d8YkexVMUx+hjNgPXC/c6ZITfFrFYmkROrQ7DkjsLmZ31HdADn
	 ZAdUwe5H/CmxNdAFYfUxdAK3nWlLToW06ChvP0Ox6mnzw572KyV+IH3793qtROdSKT
	 PgLqzrMq6LZ0A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 11880C53BB9; Tue,  6 Aug 2024 09:16:53 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219129] New: virtio net performance degradation between Windows
 and Linux guest in kernel 6.10.3
Date: Tue, 06 Aug 2024 09:16:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: anton.wd@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219129-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219129

            Bug ID: 219129
           Summary: virtio net performance degradation between Windows and
                    Linux guest in kernel 6.10.3
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: anton.wd@gmail.com
        Regression: No

After kernel upgrade from 6.10.2 to 6.10.3 network performance has become v=
ery
low between Windows and Linux guest.

Steps to reproduce:
MTU 9000 for all adapters and bridge (Jumbo frame 9014 in Windows)
KVM host, qemu 9.0.2, bridge (e.g. br0)
Linux guest, virtio net adapter bridged to host br0, address e.g. 192.168.0=
.1
Windows 11 guest, virtio net adapter, bridged to host br0, address e.g.
192.168.0.2

When accessing Linux guest from Windows 11 and if kvm host OR Linux guest h=
as
kernel version 6.10.3 then network performance is poor.

iperf3 for example:

$ iperf3.exe --client 192.168.0.1
Connecting to host 192.168.0.1, port 5201
[  5] local 192.168.0.2 port 49849 connected to 192.168.0.1 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.01   sec   256 KBytes  2.08 Mbits/sec
[  5]   1.01-2.01   sec   128 KBytes  1.04 Mbits/sec
[  5]   2.01-3.01   sec  0.00 Bytes  0.00 bits/sec
[  5]   3.01-4.01   sec   128 KBytes  1.05 Mbits/sec
[  5]   4.01-5.00   sec  0.00 Bytes  0.00 bits/sec
[  5]   5.00-6.01   sec  0.00 Bytes  0.00 bits/sec
[  5]   6.01-7.01   sec  0.00 Bytes  0.00 bits/sec
[  5]   7.01-8.01   sec   128 KBytes  1.05 Mbits/sec
[  5]   8.01-9.01   sec  0.00 Bytes  0.00 bits/sec
[  5]   9.01-10.01  sec  0.00 Bytes  0.00 bits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-10.01  sec   640 KBytes   524 Kbits/sec                  sender
[  5]   0.00-10.02  sec   384 KBytes   314 Kbits/sec                  recei=
ver

iperf Done.


If kvm host AND Linux guest has kernel version 6.10.2 then performance seem=
s ok

$ iperf3.exe --client 192.168.0.1
Connecting to host 192.168.0.1, port 5201
[  5] local 192.168.0.2 port 50092 connected to 192.168.0.1 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.01   sec  3.86 GBytes  33.0 Gbits/sec
[  5]   1.01-2.01   sec  3.78 GBytes  32.4 Gbits/sec
[  5]   2.01-3.02   sec  3.72 GBytes  31.6 Gbits/sec
[  5]   3.02-4.01   sec  3.75 GBytes  32.2 Gbits/sec
[  5]   4.01-5.01   sec  3.80 GBytes  32.8 Gbits/sec
[  5]   5.01-6.01   sec  3.64 GBytes  31.3 Gbits/sec
[  5]   6.01-7.01   sec  3.90 GBytes  33.6 Gbits/sec
[  5]   7.01-8.00   sec  3.94 GBytes  33.9 Gbits/sec
[  5]   8.00-9.00   sec  3.83 GBytes  32.9 Gbits/sec
[  5]   9.00-10.00  sec  3.87 GBytes  33.3 Gbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-10.00  sec  38.1 GBytes  32.7 Gbits/sec                  sender
[  5]   0.00-10.01  sec  38.1 GBytes  32.7 Gbits/sec                  recei=
ver

iperf Done.

The following entries appear in the kernel logs on Linux guest:
[  157.294081] enp3s0: bad gso: type: 1, size: 8960
[  157.294298] enp3s0: bad gso: type: 1, size: 8960
[  157.623938] enp3s0: bad gso: type: 1, size: 8960
[  157.938094] enp3s0: bad gso: type: 1, size: 8960
[  158.249957] enp3s0: bad gso: type: 1, size: 8960
[  158.593349] enp3s0: bad gso: type: 1, size: 8960
[  158.909346] enp3s0: bad gso: type: 1, size: 8960
[  159.236646] enp3s0: bad gso: type: 1, size: 8960
[  159.236721] enp3s0: bad gso: type: 1, size: 8960
[  159.236745] enp3s0: bad gso: type: 1, size: 8960

This is also reproduced for bare metal Windows 11 PC with bridged physical
network adapter to br0 on kvm host.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

