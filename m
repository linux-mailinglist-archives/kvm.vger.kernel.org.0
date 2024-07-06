Return-Path: <kvm+bounces-21057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA1CC9292C2
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 13:20:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 789C11F2201B
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 11:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B3016BFB5;
	Sat,  6 Jul 2024 11:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="shHBSNQZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E7EA955
	for <kvm@vger.kernel.org>; Sat,  6 Jul 2024 11:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720264839; cv=none; b=KmNX+33reHYNx2vwhMrEcDiXoKmtOY2hXHeYrzcLzqYd3i7SLNwF0VCq+6Zo43YzS3mnApfLqG0f8U8RXAHZsCc93yO0lcwirjPEGm48zEXvN/d/ZcI32Q24hebZ2MYxTESRCQl7KpiVUB0DkbTKp+UdBXILLedxqJ1t4RDCaQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720264839; c=relaxed/simple;
	bh=mzWNalstZ/cgOuJCRAwZoEOMvU/ajcaDLhCY2s2j5ts=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=b+X3yKIRoFClzEEr4MJlOebBoX9ovN42+Jzqb9krvExu6XclJVdcPdphvghe0B5mm4/UT2utqdH3ghOd7ySaDfH0bJuT0moDZjO8hc2q/WEuC5vmvoQuNMJ5fJPY92qVYSuZ16cREbZbe77JKc4E1l8f0f4qFz2P8Bp2SXl12YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=shHBSNQZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63E59C4AF0A
	for <kvm@vger.kernel.org>; Sat,  6 Jul 2024 11:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720264839;
	bh=mzWNalstZ/cgOuJCRAwZoEOMvU/ajcaDLhCY2s2j5ts=;
	h=From:To:Subject:Date:From;
	b=shHBSNQZjIy1Lev1JnUKoai3dekxtvT0KO4BywUWQe30WmTWEmEXdYxHpHDnwfmil
	 gF6jJIlzsYHCVDFXYxHADd9MmBqDk3BaJ2yKyZKxy8ydiJpU89rGewsxKbGPheDLi1
	 c71PmF7hXv4QSdKfvhmIs521RAENyMDw4z371UiowCVPgNb9GcWircPn3zmEEDCrGf
	 QU0pg0fUmgdgR9nW1QKCISatiJrnV2ARFE0rJ1SbNhLiwBTQXYkWqbS/lx5tSLjWme
	 zWy1mhH3kCCqWkuOx1RyDdwibEOJW4Ppt8UOQ7equzkwSuBkvkSgwSzSlYXI3IK138
	 OXIUBPTzIv7iQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 55CD6C53BB7; Sat,  6 Jul 2024 11:20:39 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] New: Random host reboots on Ryzen 7000/8000 using
 nested VMs (vls suspected)
Date: Sat, 06 Jul 2024 11:20:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zaltys@natrix.lt
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219009-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219009

            Bug ID: 219009
           Summary: Random host reboots on Ryzen 7000/8000 using nested
                    VMs (vls suspected)
           Product: Virtualization
           Version: unspecified
          Hardware: AMD
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: zaltys@natrix.lt
        Regression: No

Running nested VMs on AMD Ryzen 7000/8000 (ZEN4) CPUs results in random hos=
t's
reboots.

There is no kernel panic, no log entries, no relevant output to serial cons=
ole.
It is as if platform is simply hard reset. It seems time to reproduce it va=
ries
from system to system and can be dependent on workload and even specific CPU
model.

I can reproduce it with kernel 6.9.7 and qemu 9.0 on Ryzen 7950X3D under one
hour by using KVM -> Windows 10/11 with Hyper-V services on or KVM -> Windo=
ws
10/11 with 3 VBox VMs (also Win11) running. Others people had it repeatedly
reproduced on Ryzen 7700,7600 and 8700GE, including KVM -> KVM -> Linux.[1]=
 I
also have seen Hetzner (company offering Ryzen based dedicated servers)
customers complaining about similiar random reboots.

I tried looking up errata for Ryzen 7000/8000, but could not find one
published, so I decided to check errata for EPYC 9004 [2], which is also Ze=
n4
arch as Ryzen 7000/8000. It has nesting related bug #1495 (on page 49), whi=
ch
mentions using Virtualized VMLOAD/VMSAVE can result in MCE and/or system re=
set.=20

Based on that errata mentioned above, I reconfigured my system with
kvm_amd.vls=3D0 and for me random reboots with nested virtualization stoppe=
d.
Same was reported by several people from [1].

Somebody from AMD must be asked to confirm if it is really Ryzen 7000/8000
hardware bug, and if there is a better fix than disabling VLS as it has
performance hit. If disabling it is the only fix, then kvm_amd.vls=3D0 must=
 be
default for Ryzen 7000/8000.

[1]
https://www.reddit.com/r/Proxmox/comments/1cym3pl/nested_virtualization_cra=
shing_ryzen_7000_series/
[2]
https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/revisi=
on-guides/57095-PUB_1_01.pdf

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

