Return-Path: <kvm+bounces-63690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 10241C6D64D
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 09:25:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 250FD34D646
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 08:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3052932860C;
	Wed, 19 Nov 2025 08:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iadfIbtD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFD0274B5C
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 08:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763540564; cv=none; b=k+1QzF5ry+gGYnY2QGSUMBt5JA8hXbS6ePab46232l27LWNndv74CYQexPhmGiXfcmTHe+lZkshZSxJSRi3M6G2sfA5RKHOfNtoKGHR2/kByRGnCSvu+hs3N3GNePEfnxXokjj5UpQyK3i4hVsFV7hfgekkzDYzGXdpvD3RrFAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763540564; c=relaxed/simple;
	bh=3GxY8QGFgHmM0f7HNtA7tXdh0qFv/w2uIiY1qIuDNqA=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jCvt6ISg1TrcdnnDGQlzS3zzA3JalQcDez6bwrojYc88P7/MQrdM0cfy+0t+kaqQvHhnT1bIOkEBiXZPD+fPO3NDWVEHBGAnjqiXdFqHbrcqe99xflpsK+c/k7pB8JlmtS+tnod9GcSZoZtRo83EXZVensuSYTnk5c1VMGqEFGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iadfIbtD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0973C2BCF5
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 08:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763540563;
	bh=3GxY8QGFgHmM0f7HNtA7tXdh0qFv/w2uIiY1qIuDNqA=;
	h=From:To:Subject:Date:From;
	b=iadfIbtDgLDzWCjITwNZbUNlGth9XK5iYAxxDagckTxNG65UHhR177GVaBLFNQtVz
	 30sK1sfrtLcmLN0XH2cQZSc+36m3Wkn5hv7lmQ15NlSba5WllUdGdbkDvG0Cag8I1v
	 wmpzib6Df8ZWe8V+PnE93WlRBPg9LqWAFLblD9vk/truHJ0Lk29JjkrMSaAKiq3jcy
	 0ATXwy2xnDOBBvucI8RpHZhv9jrniQ+C94wNBQyKHEB4Ay7ceFWFWYf4KO8iyNFzpj
	 PPu3V+CXGKM67iTQOMigsdyO5r7zvGpcrsIQ5U74GDYlqyaF2hMc6EpPNf8rsVJr1F
	 uAiTIix1/SsoA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 82DDBCAB785; Wed, 19 Nov 2025 08:22:43 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220793] New: If Qemu VM using VHOST/VIRTIO quits kernel crashes
Date: Wed, 19 Nov 2025 08:22:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: aliqrudi@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-220793-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220793

            Bug ID: 220793
           Summary: If Qemu VM using VHOST/VIRTIO quits kernel crashes
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: aliqrudi@gmail.com
        Regression: No

Created attachment 308953
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308953&action=3Dedit
Kernel call trace

The problem happens if a Qemu VM using vhost/virtio receives packets at
a very high rate.  After Qemu's quit command or when the VM is rebooted,
the kernel panics.  The problem is easy to reproduce; we tried different
kernel versions, including 6.1.158 and the mainline, with the same result.
We also reproduced the problem with both Mellanox ConnectX-6 and Intel
XL710 NICs.  The VM is run in Debian 12 using Qemu-7.2.19, on a machine
with AMD Ryzen 9 processor and 192GB of memory.

I have to note that while Qemu's quit command triggers the problem,
if Qemu is killed with SIGTERM, nothing happens.  Kernel's call trace
is included at the end of this email.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

