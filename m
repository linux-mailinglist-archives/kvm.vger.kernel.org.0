Return-Path: <kvm+bounces-29180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 599439A4675
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 21:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEEC72830F8
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 19:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43B62038BD;
	Fri, 18 Oct 2024 19:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pn/3rySc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5592040A2
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 19:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729278218; cv=none; b=Dj3q9BSmUzC4En74gjoZXiu/bdGAJNstnJwGL1BtKLPGekB9eutwrLe9MxLZYHdqilFaGwCa9WqgqcGWZodZ9mYfZsKBXyTpk7TSDD1/35awxD5Aa2R6OuYGaTA0KsT4Cchy99jYjSUpVNl1uXKlG11fYm10AldfQzucVf/G+5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729278218; c=relaxed/simple;
	bh=3n9l9GsWpypFJCBH1OxNm96HBH+LQ5R2A7pCMxX6DIg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uGsoFfMoWHQRO2SzvMQVeUswO9iTEC1y4XberKOZLikW616TbpjbWejchfecW7oyyniDyAE80d6E6TTdGlffSsXVRRgHXTwdKJiQ5jiPVcTkjWn1B1QV9SbXl5Ozysdm1432g6MvTwkJWaDhCE/di9P4TDV+23ec9WlCUj8I2SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pn/3rySc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66352C4CED5
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 19:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729278217;
	bh=3n9l9GsWpypFJCBH1OxNm96HBH+LQ5R2A7pCMxX6DIg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=pn/3rySclGJ9E2z/V1Wk3rY8lVkA7Mp/wvBoUYYNz9mpfF49E6Y2IUc7s6SQ2TbR2
	 Icv8tl/8tajThzFJvLM3t1CT/MILYmP2D0HBw4BXXn43CVaocKnKG9Y/Wm3vyS7VtG
	 VTvRWwdhgnB+LPI2rJRzG4qYF+i0TcOBUcZoy2pKe7MLYNMzbeJ7I6p966y+EgB89H
	 BeRj6kpx5/DwqIUEKhaXDuUNhqrOKUxhcpIjSccMNy6QaEskELhENSbfcr6qg/4v1z
	 +k2jYNpm64YQVBpiuFqaIaZ38sF0QAjlXySfUJRJajYTbxcQRriuBBpf2gJwymvBq6
	 0IzGm/dwHXlKg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5CB1BC53BBF; Fri, 18 Oct 2024 19:03:37 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Fri, 18 Oct 2024 19:03:36 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-iTNtxz41uT@https.bugzilla.kernel.org/>
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

--- Comment #35 from Ben Hirlston (ozonehelix@gmail.com) ---
yeah I'm not using my iGPU in my 7900X3D at all I have a 7800 XT and a RTX =
3060
that is setup to run with the vfio-pci driver on my MSI MPG X670E CARBON WI=
FI
motherboard. and disabling VLS made my random reboots stop. so to hear that
having an igpu enabled caused it to continue is interesting

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

