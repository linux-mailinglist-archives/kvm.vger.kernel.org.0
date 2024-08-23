Return-Path: <kvm+bounces-24871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA6895C69D
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 09:36:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10F3B1C21E99
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 07:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D9FA13C9C0;
	Fri, 23 Aug 2024 07:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rf3kvsCr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9459913C80A
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 07:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724398601; cv=none; b=rtUxUc+KHS+Rp7LRchisMrx0JWqqqwr87gqzhkf5dNkIVpoU7gyGIVoKrZbFTmNA+i+GKsyv23OaE+p701tvbEJHUGxf22ytsBB3+Bdjy6LhwVmt5ucCLteDS9ort8rs7o9xGgoCvwGyLPlgVe7NcIpdipf4+JnxP2Vsgx5hFOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724398601; c=relaxed/simple;
	bh=3ClOOmK7xT/Z8dXev7TKwvLbGU842KBsJYdXmyyFgVo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sRp4tPTu+R22l2RnczNAFpsp2uSQ9vmqy4C6xWO8zD8NKQzyUVoAziT68y1H1HFwXhi3O+P5Swb1+fbD8xQTWbjDTIjs55tyyYoiS7ypfZbAmQuUu2eni4UaS0Em5M6aHD2JbgNPf9eFPztKVXGSxa5vOzaLa7kT5gVhK9MzLvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rf3kvsCr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2536BC4AF15
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 07:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724398601;
	bh=3ClOOmK7xT/Z8dXev7TKwvLbGU842KBsJYdXmyyFgVo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=rf3kvsCrayqAN8bL3bB/O42wBTZ7XI9Jmk7LO7Vt52UDFpcv2e2GxyMkCDllBOhxE
	 9CldF6boJdfccgCRYP5q1lz6pYjzB1u3CkiqWQj1c4HqAcEQdeh/VoUdn2NxVyirMW
	 mAc3YZyP9VoqKKPUeQlMuGjxuj0rYeOk3KarK+z6o/9oMSASKtaKZfiRIdWzXmIM+w
	 Lq4hHY14Ak16whzJttBxCLIdmnbqo2nSznZjO7thSilyIJMdTUhi2wkw4VFCVdUyzY
	 snaxBVPanr50NfjAX/5XJol/VDoLnHMQZU42K7LokiUYRPp+KQlJ53YTaaPR9LMkRd
	 ktie5s7/ImNNg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1D2A6C53BB9; Fri, 23 Aug 2024 07:36:41 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Fri, 23 Aug 2024 07:36:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ozonehelix@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219009-28872-48o1Iec4Pf@https.bugzilla.kernel.org/>
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

Ben Hirlston (ozonehelix@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ozonehelix@gmail.com

--- Comment #2 from Ben Hirlston (ozonehelix@gmail.com) ---
I can confirm on my Ryzen 9 7900X30 system disabling aspm helps. kind of
relieved this is a bug. I was having this issue on my Ryzen 7 5700G system =
but
to a lessor extent and it got worse when I upgraded to Ryzen 7000 series

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

