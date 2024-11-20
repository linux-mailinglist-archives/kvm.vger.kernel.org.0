Return-Path: <kvm+bounces-32211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF9589D429B
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 20:37:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B0ABB24479
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 19:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5141B5337;
	Wed, 20 Nov 2024 19:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JU307XCW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAB1155352
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 19:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732131470; cv=none; b=P68slU1ti/Q0Y5WVU7QqRpP7pYC/gChnIhXS3zlb5L8qgRthogIKmMn5SX6lXEz12zfWypaNTqbwa9wMGPGoan8Wyo4K8pc9xI6fZP5MPRYJbPM1lUiJi2TKPCDxWNnkZs58zPGCWT8jgVp+1A816uL/rD0aPC2jEm6Wk9Kop7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732131470; c=relaxed/simple;
	bh=I15nbGfbyM6pc/uvzP2VNonM00j8rEX4S7RiAlaY3NU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZTTQ2TMWRnUPw20nG0hy76W3gAFXnBTQeLTRz6o0f3dLqOFepnTtl8GxdVIRq5XpdUxAzm5VB6YHfmjgU+uMssKXpnfUtCP4MFvlkHoRCCszIkenHQAmvuLpynTPSqX0VNmgOIVLYdvA1PrVyZLRoudi0skadmEtaJSJR4DOBUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JU307XCW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 815B8C4CEDD
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 19:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732131469;
	bh=I15nbGfbyM6pc/uvzP2VNonM00j8rEX4S7RiAlaY3NU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JU307XCWdU/6EQ/UrHFX3YKFUGFaQuTYgYe/nNhTGcoslC82lcMxBEGnUp8DhfELV
	 s+Qj6PcJyBnJhFauPGwdjeETWZQgFxXNRGyYdPbN3Q1xS6+Hk8tBUe3Lx5h0eeW3ea
	 x/dZEr48xbqT3Ef73KlehWzTSpbNpvkqQOnvdqCRQpmHOCWDosLSN8HqkeYMlnaSB5
	 pMBg2ho/qrMXSsoUaOQkSI2BAnw72+oSZbirXVeCgs5//91pddqGj2jDBw6OXcyGmi
	 +hsViH3Zk39PGb8rc0b5QM1JCppMpYD13ChKaxTJBE/GR4HqRbljfnE4Qe63TRskxA
	 ZduUo8kGJm6lg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7D5CBC53BC2; Wed, 20 Nov 2024 19:37:49 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Wed, 20 Nov 2024 19:37:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ozonehelix@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-4QNlxmKeei@https.bugzilla.kernel.org/>
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

--- Comment #42 from Ben Hirlston (ozonehelix@gmail.com) ---
to test this I fired up my KVM/QEMU Windows 11 VM and installed virtualbox =
in
it and installed wsl2 to see if running virtual machines in KVM/QEMU would
trigger the crash I've been testing for 20 minutes and have yet to see a cr=
ash

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

