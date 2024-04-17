Return-Path: <kvm+bounces-14975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E90048A85F2
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 16:29:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3BD42833D0
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 14:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE8D1411F6;
	Wed, 17 Apr 2024 14:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6hfTgpu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7CF13D290
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 14:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713364170; cv=none; b=mcHya4et6/A6T6V4gb9atU+vUkAEQR1q6yUOc1+ZLOcDAx3GbOyd+xM/8ddBKB2XUeCl8a91wC03Tcm7lGFEz2BHxYtTrtRKmv3Khkstnib4+6wl/asUYoqCbxq3ooHfjUumzmzu+GdAMM8fuYhH3aWa5wHyh/Sc88rNcKDZuYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713364170; c=relaxed/simple;
	bh=xp64kmTjANm/WyvRMMAHjJ4OfJtVa3IXX99Xlt6xTc8=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=CH16lv6/46AMa1R4q/Tx3hmQXi01px3IiIbMIhfZUJu/bsGfKtAIp/pyppMIsWepEXDxdJfXIAVmoPD4b9xPTdwhjL6acYr4YSNMwLeSfpeJvddi4ZRSv4HosMxWKYer2Rs1XY/6JnIpnSXpB+GPupvlu1aj280eRhc8nq5aQ80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6hfTgpu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9398CC32781
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 14:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713364169;
	bh=xp64kmTjANm/WyvRMMAHjJ4OfJtVa3IXX99Xlt6xTc8=;
	h=From:To:Subject:Date:From;
	b=C6hfTgpu3WHE63aP9kn0nz7JP4KptoCEDV8RBf5ARnVZR5JTukwS9il6jRQWU9gH1
	 j2/vZRRogSicPevMKk3NyezVWfU3U/OPbLHgaH9ChY3k4X4vPV4ltTOMweRZP3QS2r
	 8lkunCXy1e1f/0ZiMmOEPqgp1eKbXDwfj62+CZik0Dk3PbHSqwhudZgzisVD97/vIa
	 69gYCZh0TVZl3VTw4vhVknZo+1nodE1tuOLoGek8WKYdx5eUfHDjyLotswwWKpw3pR
	 buLEnDbMd7FE2bjC+V8Z60xV8JhgCdk8N8tEmWkjXOSpRdPTAOv9ypQmmmrUBCBT52
	 83OX1mN9KRqng==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 852FEC433DE; Wed, 17 Apr 2024 14:29:29 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218739] New: pmu_counters_test kvm-selftest fails with (count
 != NUM_INSNS_RETIRED)
Date: Wed, 17 Apr 2024 14:29:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jarichte@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218739-28872@https.bugzilla.kernel.org/>
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

            Bug ID: 218739
           Summary: pmu_counters_test kvm-selftest fails with (count !=3D
                    NUM_INSNS_RETIRED)
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: jarichte@redhat.com
        Regression: No

Environment:
CPU Architecture: x86_64, Intel(R) Atom(TM) CPU C2750 @ 2.40GHz
Host OS: Fedorarawhide
Host kernel: Linux Kernel 6.9.0-rc3
gcc: gcc (GCC) 14.0.1
Host kernel source: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
Branch: master
Commit: 1c3bed8006691f485156153778192864c9d8e14f
Bug Detailed Description:
Assertion failure executing kvm selftest pmu_counters_test.

Reproducing Steps:
git clone https://git.kernel.org/pub/scm/virt/kvm/kvm.git
cd kvm && make headers_install
cd kvm/tools/testing/selftests/kvm && make
cd x86_64 && ./pmu_counters_test

Actual Result:
Testing arch events, PMU version 0, perf_caps =3D 0
Testing GP counters, PMU version 0, perf_caps =3D 0
Testing fixed counters, PMU version 0, perf_caps =3D 0
Testing arch events, PMU version 0, perf_caps =3D 2000
Testing GP counters, PMU version 0, perf_caps =3D 2000
Testing fixed counters, PMU version 0, perf_caps =3D 2000
Testing arch events, PMU version 1, perf_caps =3D 0
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
x86_64/pmu_counters_test.c:107: count =3D=3D NUM_INSNS_RETIRED
pid=3D51128 tid=3D51128 errno=3D4 - Interrupted system call
1       0x0000000000402c7d: run_vcpu at pmu_counters_test.c:61
2       0x0000000000402ead: test_arch_events at pmu_counters_test.c:307
3       0x0000000000402674: test_arch_events at pmu_counters_test.c:296
4        (inlined by) test_intel_counters at pmu_counters_test.c:601
5        (inlined by) main at pmu_counters_test.c:635
6       0x00007f78bd1981c7: ?? ??:0
7       0x00007f78bd19828a: ?? ??:0
8       0x0000000000402924: _start at ??:?
0x12 !=3D 0x11 (count !=3D NUM_INSNS_RETIRED)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

