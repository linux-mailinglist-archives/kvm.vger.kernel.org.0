Return-Path: <kvm+bounces-19180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7238D902006
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 12:57:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E42228651F
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 10:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66CC278C65;
	Mon, 10 Jun 2024 10:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E3W6pk89"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F34678C6D
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 10:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718017046; cv=none; b=TJDDoDEWYRyURo1yv9cvg5E77/T6KHyx8ZMrBc7GQP/V3rzczRDUJDMEHcbViiF4iPRv0wDO4XKl6U3eDTWFD+pGmRvS+eRBUOT8I2wU3VQ7zqzJxVrzTy26zZ6ep0qvbrXMpljsSveZmXFj7a/ca68Eos40WxM+xy4iafR9L5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718017046; c=relaxed/simple;
	bh=BS6kjU5Wd5VGIGjq5yoenBtp75fVl5T9wx9P2sBcnrg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p36+wdaKbclFMTY5SCt3ePomBHg1xINwuKjZgCtFJufOI2dsYiMckfslUz3uHwVUYMHJT7SI4x2kShlPpW4mDYd6XiL5zyKj5LmqQealJEbVv+A8L323k1R75c9f4SDN6Ndyju2chaoxqbsoIZqWgt1jBtprOxlQcENdzFzwuHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E3W6pk89; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2922AC4AF1C
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 10:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718017046;
	bh=BS6kjU5Wd5VGIGjq5yoenBtp75fVl5T9wx9P2sBcnrg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=E3W6pk89sT+AaqP0fARZAwpqDFTzMnhR7dl2De99P2WgHp+DskyuByphTMBks39ZZ
	 chER7eXXgVD5h/DY7tCtMje5mlA0007GUg+o3Pm2zQtr/aaWXPBcto/qbZ/U33g9No
	 I782pQRy2Hbms1iO5erwGtsm1XwLOvYZICmhdsIFVbn4IeIsKB/gWFu0CY3xPnUz9q
	 tD+M/2yyspR4WrG6nDob9KnwsGJZLBlk5j4CaLkjGR9yKANGDIqqxvD+4RhA+jm8Dj
	 7nStIVIYtMp44cAA9zoARx35MHZMPEJBMLT/It2lEu6XPqImzDZe+QIZjmIIsQEL++
	 YjjqBGntAG0pg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1D28EC53B73; Mon, 10 Jun 2024 10:57:26 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218949] Kernel panic after upgrading to 6.10-rc2
Date: Mon, 10 Jun 2024 10:57:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: badouri.g@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-218949-28872-VMAtPFnfws@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218949-28872@https.bugzilla.kernel.org/>
References: <bug-218949-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218949

--- Comment #1 from Gino Badouri (badouri.g@gmail.com) ---
Created attachment 306447
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306447&action=3Dedit
Settings of the VM

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

