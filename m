Return-Path: <kvm+bounces-7704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1D898458DB
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 14:25:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F679288646
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 13:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BF715337F;
	Thu,  1 Feb 2024 13:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lc+8B8Lh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBFD86621
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 13:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706793948; cv=none; b=m7mEGM8wzYNUP1g6TVsw02wYvrFDbg/+/XdQqmLE/ay7MlwRj9JfQrGIXerwskQ8ED1f4MZvjnttEw6GcmnmZ829MboPa87kF5eZdi9ZLTH7tIUYpYgn3rLMhQ8EeeZSCl/9cC5zWlWigFArfDc7n4h6anv/epoAs/MZXchUaXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706793948; c=relaxed/simple;
	bh=dUOVXt2sYt2gsRqsD+k6Va34igHSS8G/GfVFmbHHfjU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Vn9ReRpn3DhUxDjkOVdnLYxBpUKOA4EWh1HiGnXcy00GX1xPzCYODwZ25rK6w0zjAz16vvAXYMUmlI3bgVbOe8AZAiujiCJT+UNv5dX22tOQJiBiZ95YEQUW38tAgzuIhGhMQQf7jOy5GhVQXzVVHzhX89xcBEHD5Tr7+MvjoKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lc+8B8Lh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B406C43609
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 13:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706793948;
	bh=dUOVXt2sYt2gsRqsD+k6Va34igHSS8G/GfVFmbHHfjU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Lc+8B8LhXpojQF32n3wMFs49tMOg5XKF3vjrllY5p+7c5qgnto3m+P+1SMI8K8GC5
	 bvjPMWaiTXgii2Bn/4qNx4YTgqB3xAQkulAEE0SiqTx7ntMXVId66cs0haJIaU3czC
	 hxw7arYFvIGduKseaJZ5m39BYUDWJbsEa6tN3g5M5xaPsQOULEuf0qFNvP8DwJQvTI
	 4nqopGarPOwRv0e/aszYwPJ4s9xTtUIKWeX3GAqnZW6UTkqqzaOPpMelIi3cjWYEG5
	 PBpf/WT1MOzlydDTw1TXJvmSK06StHHqspUakF5WJors/aLbQpkXi1zrL7Nm4WqNIQ
	 e3uhXtKUO3g/A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1C0B6C53BD2; Thu,  1 Feb 2024 13:25:48 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date: Thu, 01 Feb 2024 13:25:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: devzero@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-C8X78R4GIb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #21 from Roland Kletzing (devzero@web.de) ---
do you have more details (e.g. proxmox forum thread) for this ?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

