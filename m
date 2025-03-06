Return-Path: <kvm+bounces-40280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 744DDA55991
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:19:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4C6C3AF3B7
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 22:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F0B27C853;
	Thu,  6 Mar 2025 22:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kzd64qaO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DFB27815A
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 22:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741299578; cv=none; b=JFOc+20me/r4z/1yhZ/MuxAt2KjmbBsffRP2AYc7HG5HxUIEKdBfhvXvmzcUSlzKbqma5VI3ve2VPiACD7JyncUwjItQhOK8JY/gv4S3xQqW5NeRvWORLvqyYTFxegwfy/xruv9bizEwysoYFf0lcyPpX8N585JnxrohEXe5a9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741299578; c=relaxed/simple;
	bh=HBygJ59Et48wezazjfhdLycQXFJOMy28pKMoQCDcOig=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rP+zL9ZcpjElAYVTUdr2IbEqZsvO11NCVBczfw5ivt/YaJ2jebqrmjRNGGBBpeW12Axivp3k9zleVQdW4/Ub2e7Tmgx5dVNwZh1cT7xwglzTLeW4eu9vvr42lksKkwWk96Yl4G+fE1Crmqo5GR9LRmANHoq2EUnsSQ/InuRJYA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kzd64qaO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 730E5C4CEF1
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 22:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741299577;
	bh=HBygJ59Et48wezazjfhdLycQXFJOMy28pKMoQCDcOig=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kzd64qaOHdb4yPnZ1KYNk+x36HkNzTE9bCh97zy71/RuIhQu2ZGcZySIy9ilHgbro
	 2FJPGUZE7PxD9qMN+ao1Wis6tGMSGzPdh3K5XmphsFhpcswVLMyh4VCryI8uqErjeD
	 PKvlfY11yEzqMC7K+FsRK2B285tGEwu89L5BtNW7etHRjQ4i1o927Wxo9KymJ7fU6L
	 OEzc1YVcvVXjUDqXtj9ArahkRIUGVKpHw6GkEYaJ9QXVJzeNRMZFlmH16JEla9X3bf
	 fhb4iMFok3rjUhepj+NyZJtdJIHjW0D4bNmunPg+LJtbuwo1W8L+6cBpn7vI/j1QwI
	 OzVlsIjpqEnog==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 69693C433E1; Thu,  6 Mar 2025 22:19:37 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Thu, 06 Mar 2025 22:19:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: h4ck3re404@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-rbhCxN7gDl@https.bugzilla.kernel.org/>
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

--- Comment #51 from h4ck3r (h4ck3re404@gmail.com) ---
I finally had time to test differences more clearly.

Cpus i used were 7700x and 9700x

Guest os is windows (linux didn't had most issues in the first place)

No nested virt warning with wsl still persists (probably windows being wind=
ows
cause zen5 only guests don't have it)

Pcie "slowdown" is gone using zen5 (no performance penalty on gpu)

No issues with nvme drive passthrough (it would behave as broken hdd on zen4
having huge latency and increased temps for some reason - probably irq
handling)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

