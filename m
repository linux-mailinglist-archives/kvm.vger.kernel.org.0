Return-Path: <kvm+bounces-32019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EBCC39D153D
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 17:22:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B13C62837F8
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 16:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D531BC065;
	Mon, 18 Nov 2024 16:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TMejOZWY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72AB22F19
	for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 16:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731946922; cv=none; b=k+iWt2nomvaWKYwKYkuieI5sbsjCBLO0kcYmqzvCQ+QiMTiVMmBhDj1tKRN6pomuOBUTYpkq4pBEMV1PBJQM4LEtEwa51QBSuCUm6JzIqhBhRCg85rlOFxw331jNbzbTewTX5jml8jRvP/7F+FwWAwrq2dUKAi1TtaNyisFh4xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731946922; c=relaxed/simple;
	bh=yqlWkKP8DAmDKuGLzX3E4KehzY5HJR6JYeF7JlU/BZo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UgVdggXG2nKvVb0+o3KyIjynDLt//ttzTCIGH07T4OFcJPZ7GCHGzd9OOA1eZNNbR436GKQfK0YXG8mwF20YbdCZyGeCEMH3mFIJh5rEUrktb8CoENaAE29m1gCPiBuW0hqFxJuo9OV9CA5guEZR87OtZFA6UlquyVF/cgqw4Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TMejOZWY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 110BBC4CEE1
	for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 16:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731946922;
	bh=yqlWkKP8DAmDKuGLzX3E4KehzY5HJR6JYeF7JlU/BZo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TMejOZWYRSEAt86jIIpWb+ZUxItSpAaT4d74QMik5z11lXZsPttuvBkSoHUox3sUq
	 Z0OOPq2Hp1MCZTUe9LWKQYpTpLjbaK+fGmQUCNpVYDYttZUBs5cJwbLTKREs+/dVAu
	 SlVBFbJOCMlelVQWl7PWt48kEfAQQ0qjnAdsWrhOz5EzBzUsEzIbdnbI66bZB0LvQ1
	 bZYOP7dK2zYvCbKSWZVGYKH//bv6I2Z06hjKKp3E6jAOKL52dM5RsZsjh2C9AMg5Xu
	 ulx2duAHqSrpMqVSLUbVFnQd60uxVYr4iEo09+nMVrGZDLLCnDZEMR2wEYY6xYYN9N
	 SPS+5bT1IP2zA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id EBABACAB788; Mon, 18 Nov 2024 16:22:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Mon, 18 Nov 2024 16:22:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: animusnull@fastmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219009-28872-4pZBeQd4cj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219009-28872@https.bugzilla.kernel.org/>
References: <bug-219009-28872@https.bugzilla.kernel.org/>
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

Sean (animusnull@fastmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |animusnull@fastmail.com

--- Comment #39 from Sean (animusnull@fastmail.com) ---
I've been encountering random reboots with a 7950X as well, oddly no nested
virtualization. I just came across this via a phoronix article, and tried t=
he
kvm_amd.vls=3D0 argument I've hit my third reboot today after trying to ame=
nd the
flag. I'm going to try bringing in the patch  today.



I have two virtual machines I use. Neither is using nested virtualization=20
- Windows 11 with VFIO and pcie passthrough
- Linux guest with spice and opengl via virgl



Even with just the Linux guest it crashes=20



My main distribution is NixOs with 6.6. But I've tried Fedora, Arch and Ubu=
ntu
with 6.6,6.8.6.10 and 6.11. I've disable power saving, and a number of
different tweaks.=20



I've also swapped memory, motherboard, disks and power supply. Updated bios,
etc. The system started showing instability after I bumped to 6.X, and upda=
ting
to the bios post voltage issues with the zen 4 cpus. I was on 5.1X for a wh=
ile
due to bugs on gpu initialization while using vfio.

There is a note on iGPU which I'm using, and experiencing a number of issues
with. I won't go into that, and expect it's due to 6.6, which I'm locked to
right now due to zfs.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

