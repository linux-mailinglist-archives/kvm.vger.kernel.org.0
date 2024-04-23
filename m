Return-Path: <kvm+bounces-15584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ADD08ADB17
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 02:27:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05DC9281DE4
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 00:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA4612AD0B;
	Tue, 23 Apr 2024 00:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b3uuuNct"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46D828DA5
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 00:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713831675; cv=none; b=dSarFdvgCV2bwEWwUpz0adRkT9oxZ5w6HGJrAuK1M6VmRIn87Re67lc9wF7shsHp4VJAv577vmywoZ8YYcfmPk1gdR+g2aUviZbYHwUzAioAGxPjEdU2+GzK6pZc5jxbH1lyeUc9B0VtnUhEFMnsvR+g0/7+POgEvtI3+MNPGg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713831675; c=relaxed/simple;
	bh=Yg75YQ45ngeHeKnxuL9O6/Ep+I6UiuDEDQPIYDFAOzI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G7kd8WheT9GHR5ta8Dk+pIH4ztpgdSpuUz0YsO+BIhnv8lcQxHbC2u6ylwRBEXHB8y3Qfr1BhifKnXBLzQJrsJLbut7Au0erkuLFaRkSdM1PyZe/8K0suHyxUkhMunWT7LRlaRpEJO4EGDaiFlzvR9GUYPeN2L2GbfiHsBeaieQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b3uuuNct; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F9DBC2BD11
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 00:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713831674;
	bh=Yg75YQ45ngeHeKnxuL9O6/Ep+I6UiuDEDQPIYDFAOzI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=b3uuuNctivsDHcCODMrlaAvQs2dA8u5uYD9b2UlJ6pHAcYw8eRwLAFPVfyZT5Wtcl
	 gnofQ+7n8ZT7vdzp2HWRDYMuGzYP+QXeAkOjGNzDt05EgyKts8t5Wug/iUFSVvxqQi
	 Ikh1Sr7Z7SnSODSXezOhqBc7tp9K3bNLB/iAGVKjiZX4w0E/F2Ln/skzSJ7JcVil+5
	 RvGHx9UGp0dKXrpmBh4DIJ4wAns52LvP5+3irg1TfMJD+eNLiWpmhYIBYO37orlhvx
	 Z9lRdhVHdD6qzWHLGguiZeDtAhx4eaib5pCEySN7o9xhRV/uMc54ces+pIgT3Ji/jK
	 ovNvNwWYjqiCQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 56BA3C43230; Tue, 23 Apr 2024 00:21:14 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218739] pmu_counters_test kvm-selftest fails with (count !=
 NUM_INSNS_RETIRED)
Date: Tue, 23 Apr 2024 00:21:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dongli.zhang@oracle.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218739-28872-Az6xyuo5LH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218739-28872@https.bugzilla.kernel.org/>
References: <bug-218739-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218739

Dongli Zhang (dongli.zhang@oracle.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dongli.zhang@oracle.com

--- Comment #1 from Dongli Zhang (dongli.zhang@oracle.com) ---
Perhaps more information can be printed by pmu_counters_test in the future,
e.g., msr, msr_ctrl, their values, cflush and whether forced emulation?

Just from the output, the number of instructions by GUEST_MEASURE_EVENT() d=
oes
not match with NUM_INSNS_RETIRED=3D17,

------------------------

I have tried on an Icelake server and I could not reproduce anything for mo=
st
of times, except the below for only once.

# ./pmu_counters_test=20
Testing arch events, PMU version 0, perf_caps =3D 0
Testing GP counters, PMU version 0, perf_caps =3D 0
Testing fixed counters, PMU version 0, perf_caps =3D 0
Testing arch events, PMU version 0, perf_caps =3D 2000
Testing GP counters, PMU version 0, perf_caps =3D 2000
Testing fixed counters, PMU version 0, perf_caps =3D 2000
Testing arch events, PMU version 1, perf_caps =3D 0
Testing GP counters, PMU version 1, perf_caps =3D 0
Testing fixed counters, PMU version 1, perf_caps =3D 0
Testing arch events, PMU version 1, perf_caps =3D 2000
Testing GP counters, PMU version 1, perf_caps =3D 2000
Testing fixed counters, PMU version 1, perf_caps =3D 2000
Testing arch events, PMU version 2, perf_caps =3D 0
Testing GP counters, PMU version 2, perf_caps =3D 0
Testing fixed counters, PMU version 2, perf_caps =3D 0
Testing arch events, PMU version 2, perf_caps =3D 2000
Testing GP counters, PMU version 2, perf_caps =3D 2000
Testing fixed counters, PMU version 2, perf_caps =3D 2000
Testing arch events, PMU version 3, perf_caps =3D 0
Testing GP counters, PMU version 3, perf_caps =3D 0
Testing fixed counters, PMU version 3, perf_caps =3D 0
Testing arch events, PMU version 3, perf_caps =3D 2000
Testing GP counters, PMU version 3, perf_caps =3D 2000
Testing fixed counters, PMU version 3, perf_caps =3D 2000
Testing arch events, PMU version 4, perf_caps =3D 0
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
  x86_64/pmu_counters_test.c:120: count !=3D 0
  pid=3D39696 tid=3D39696 errno=3D4 - Interrupted system call
     1  0x0000000000402baf: run_vcpu at pmu_counters_test.c:61
     2  0x0000000000402ddd: test_arch_events at pmu_counters_test.c:307
     3  0x0000000000402683: test_arch_events at pmu_counters_test.c:605
     4   (inlined by) test_intel_counters at pmu_counters_test.c:605
     5   (inlined by) main at pmu_counters_test.c:635
     6  0x00007fcfeb43ae44: ?? ??:0
     7  0x000000000040288d: _start at ??:?
  0x0 =3D=3D 0x0 (count =3D=3D 0)


# cat /sys/module/kvm/parameters/enable_pmu=20
Y
# cat /sys/module/kvm/parameters/force_emulation_prefix=20
0

# cpuid -l 0xa -1
CPU:
   Architecture Performance Monitoring Features (0xa):
      version ID                               =3D 0x5 (5)
      number of counters per logical processor =3D 0x8 (8)
      bit width of counter                     =3D 0x30 (48)
      length of EBX bit vector                 =3D 0x8 (8)
      core cycle event                         =3D available
      instruction retired event                =3D available
      reference cycles event                   =3D available
      last-level cache ref event               =3D available
      last-level cache miss event              =3D available
      branch inst retired event                =3D available
      branch mispred retired event             =3D available
      top-down slots event                     =3D available
      fixed counter  0 supported               =3D true
      fixed counter  1 supported               =3D true
      fixed counter  2 supported               =3D true
      fixed counter  3 supported               =3D true
      fixed counter  4 supported               =3D false
      fixed counter  5 supported               =3D false
      fixed counter  6 supported               =3D false
      fixed counter  7 supported               =3D false
      fixed counter  8 supported               =3D false
      fixed counter  9 supported               =3D false
      fixed counter 10 supported               =3D false
      fixed counter 11 supported               =3D false
      fixed counter 12 supported               =3D false
      fixed counter 13 supported               =3D false
      fixed counter 14 supported               =3D false
      fixed counter 15 supported               =3D false
      fixed counter 16 supported               =3D false
      fixed counter 17 supported               =3D false
      fixed counter 18 supported               =3D false
      fixed counter 19 supported               =3D false
      fixed counter 20 supported               =3D false
      fixed counter 21 supported               =3D false
      fixed counter 22 supported               =3D false
      fixed counter 23 supported               =3D false
      fixed counter 24 supported               =3D false
      fixed counter 25 supported               =3D false
      fixed counter 26 supported               =3D false
      fixed counter 27 supported               =3D false
      fixed counter 28 supported               =3D false
      fixed counter 29 supported               =3D false
      fixed counter 30 supported               =3D false
      fixed counter 31 supported               =3D false
      number of contiguous fixed counters      =3D 0x4 (4)
      bit width of fixed counters              =3D 0x30 (48)
      anythread deprecation                    =3D true



-------------------------------------------

I also did tests on nested L1 hypervisor (more legacy hardware). Most of ti=
me
are good, except once.

# ./pmu_counters_test
Testing arch events, PMU version 0, perf_caps =3D 0
Testing GP counters, PMU version 0, perf_caps =3D 0
Testing fixed counters, PMU version 0, perf_caps =3D 0
Testing arch events, PMU version 0, perf_caps =3D 2000
Testing GP counters, PMU version 0, perf_caps =3D 2000
Testing fixed counters, PMU version 0, perf_caps =3D 2000
Testing arch events, PMU version 1, perf_caps =3D 0
Testing GP counters, PMU version 1, perf_caps =3D 0
Testing fixed counters, PMU version 1, perf_caps =3D 0
Testing arch events, PMU version 1, perf_caps =3D 2000
Testing GP counters, PMU version 1, perf_caps =3D 2000
Testing fixed counters, PMU version 1, perf_caps =3D 2000
Testing arch events, PMU version 2, perf_caps =3D 0
Testing GP counters, PMU version 2, perf_caps =3D 0
Testing fixed counters, PMU version 2, perf_caps =3D 0
Testing arch events, PMU version 2, perf_caps =3D 2000
Testing GP counters, PMU version 2, perf_caps =3D 2000
Testing fixed counters, PMU version 2, perf_caps =3D 2000
Testing arch events, PMU version 3, perf_caps =3D 0
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
  x86_64/pmu_counters_test.c:120: count !=3D 0
  pid=3D9301 tid=3D9301 errno=3D4 - Interrupted system call
     1  0x0000000000402bdf: run_vcpu at pmu_counters_test.c:61
     2  0x0000000000402dfd: test_arch_events at pmu_counters_test.c:307
     3  0x00000000004026a3: test_arch_events at pmu_counters_test.c:605
     4   (inlined by) test_intel_counters at pmu_counters_test.c:605
     5   (inlined by) main at pmu_counters_test.c:635
     6  0x00007f05e2f60d8f: ?? ??:0
     7  0x00007f05e2f60e3f: ?? ??:0
     8  0x00000000004028b4: _start at ??:?
  0x0 =3D=3D 0x0 (count =3D=3D 0)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

