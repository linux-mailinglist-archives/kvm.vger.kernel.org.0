Return-Path: <kvm+bounces-14142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6010989FCB0
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 18:15:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01B3F1F21DC8
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC2F17A91B;
	Wed, 10 Apr 2024 16:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JOy6hayz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D92617A910
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 16:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712765677; cv=none; b=Xg2dOtKeFZN/F/PeaNlwBmceu6jFSuQqfHaFa5oA+t1leWfNh3uZpDUBMNumyyiQkNfdw8otbgE3VvBuY7kiEMUaSoaLsZ0L/RK67aouBBfVydizsQrN21r2TLL/3DfRM1NM1CCwCkwYy9dvxxQQYMbAzx5mAjSBFxgE8IrNTuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712765677; c=relaxed/simple;
	bh=xJAvsL1RZzP7h7T+8Vuc4bz6HRyaL1Uxf9VhxjNg0Z8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=vAovGJPnFyUBKpzYfUiSi4MHfouS+7InIOCCVPw8Fhz6uf536ELE6siEmrP9OwuY+pXzNTYnyEFIRe5i5HGeOj/m5LNzIN9Ng/0QKm3uMXrpeQl44fryGMXPE1phY1N4XNeaO06zwpeIvyA2JXiiATqTdryed+WI7GKlcb7R+ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JOy6hayz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60B4BC433A6
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 16:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712765677;
	bh=xJAvsL1RZzP7h7T+8Vuc4bz6HRyaL1Uxf9VhxjNg0Z8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JOy6hayzuYKSGBMx3fj1hZyuqvf1mYUDrD3WnSkCkOdOm0j+cALj2T1VlOHaScJ+F
	 6Dbd+Nm4QMBWp7r77E92cp0ygTpvSFQzWEzP6EwA9FY3ZfATYn1rgybyNc82Kdnlzk
	 Fzn+R+QRtz0RIVc8WojOAa3vMd5mfFXoCaDu+GTBpnSH596XQ/TYHQbkoJpH72imut
	 rl5YSS2I/Rknm9fkKlss1PACs2zZus4cEXJos7OG4A81rsbuYZbc4x4h2GpytE9pJF
	 3UGPw2qOm2yvI5H3VnSl/p3LwZl9fszIgaal73pxmubkKJNMiXqhRpFOWV+FbcEspj
	 CM0vZN5kAKngw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5729DC4332E; Wed, 10 Apr 2024 16:14:37 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218698] Kernel panic on adding vCPU to guest in Linux 6.9-rc2
Date: Wed, 10 Apr 2024 16:14:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Linux
X-Bugzilla-Component: Kernel
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-kernel@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: component assigned_to product
Message-ID: <bug-218698-28872-vufXIY2Dqr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218698-28872@https.bugzilla.kernel.org/>
References: <bug-218698-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218698

The Linux kernel's regression tracker (Thorsten Leemhuis) (regressions@leem=
huis.info) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|kvm                         |Kernel
           Assignee|virtualization_kvm@kernel-b |linux-kernel@kernel-bugs.ke
                   |ugs.osdl.org                |rnel.org
            Product|Virtualization              |Linux

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

