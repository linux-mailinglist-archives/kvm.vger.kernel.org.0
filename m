Return-Path: <kvm+bounces-44467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 569C2A9DE14
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 02:47:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96F1C5A7A06
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 00:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B735F20FA9E;
	Sun, 27 Apr 2025 00:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cThYwat6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF1BA47
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 00:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745714819; cv=none; b=Fb5c0zXvjcx9hP5logsL+m0v3kLBalkrZDZ6tonO13rVu0fgYbgLils4SB4sTxTkuWrQ2yrRueNzImSEFGHL1KrnbrlcYf94R6mE7h+PuthMhFXI6sDDJ/WbKxg0gOj923GsiU1Mxy8ElPswJKZlI2gZOPop68fzx4Smpcc+8X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745714819; c=relaxed/simple;
	bh=6w8InrR0UjCsPBijuy+qM6D+gHqN0DCqrg5KTBN81wA=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Ra+C7KxaoJcKmoUodgN3Bwyfh5LDPV/dYlCv2ybRpwRZF4disRruzWtLQ52dVGN8WEOFEZSooDd6KDcqzmuvd5X3+YaQMRwCZh4k+wRoRufRRtfDkigSUmwOV/4sWEHI7qfor4KbdtGaqZPKqwiFTtXAXOPQ1YpqJByV1CGepbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cThYwat6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57DADC4CEED
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 00:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745714818;
	bh=6w8InrR0UjCsPBijuy+qM6D+gHqN0DCqrg5KTBN81wA=;
	h=From:To:Subject:Date:From;
	b=cThYwat6v9UtLf6Y8GEKa2OVPpoJseram9zBLLcB7rt8FTe9ZoF2e27ff/vGtWw0M
	 ofNahM3Q6FG5WJRgS44LYyaHn/lEvrRIeZmZ/0lm6tdHfniPLjAlhgReVyGwKzMmoH
	 x4Vv110jkgHXIktACtC5PmOeI/gUprjHxheMu2x0AZ4LEvHYY83yofYlexFJABL4Lj
	 iYuvnqU5RCq0IvyNKTeyB+5zSzzEU2uNSoWGDGVv2SmWOGaZpbI+V2vPdi5hXFvsqo
	 /4POgf8aSjYKRceLGU6gg62JpD+fpHNDSFNzjXs3yemrKcG80WUc0Dxqi6zz5uAC5K
	 T4YyPhXFwVyPg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 501CDC53BC7; Sun, 27 Apr 2025 00:46:58 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] New: Kernel regression. Linux VMs crashing (I did not
 test Windows guest VMs)
Date: Sun, 27 Apr 2025 00:46:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: adolfotregosa@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-220057-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220057

            Bug ID: 220057
           Summary: Kernel regression. Linux VMs crashing (I did not test
                    Windows guest VMs)
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: blocking
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: adolfotregosa@gmail.com
        Regression: No

Created attachment 308028
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308028&action=3Dedit
journalctl

I found a kernel regression. I'm using Proxmox, and any kernel with the
following commit:

https://github.com/torvalds/linux/commit/f9e54c3a2f5b79ecc57c7bc7d0d3521e46=
1a2101

causes an instant VM crash in some situations that involve GPU acceleration.
I=E2=80=99m using an NVIDIA GPU passthrough, but another person experienced=
 the same
crashes with an AMD 9070 XT. In my case, this occurs when playing a simple
YouTube video in Chromium-based browsers or when running some games.

I have confirmed that reverting this commit prevents my Linux VMs from
crashing.

I=E2=80=99ve attached a log showing what the host=E2=80=99s journalctl log =
displays. The error
is always exactly the same.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

