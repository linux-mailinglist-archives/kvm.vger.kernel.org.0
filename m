Return-Path: <kvm+bounces-25193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 516BF9616A8
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 20:17:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06DD91F24DCB
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 18:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25891D2F6C;
	Tue, 27 Aug 2024 18:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fwkNtpb4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C231D2788
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 18:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724782619; cv=none; b=HNTzBIt5M7MuXV2cq5IC95gqPB3gKQLYXH4EBjgvJ4uz/e00Ix0JcrTb63Vi5Hzb+PZnxMpAGWU4pFTriF0WMBeNPdnWoBZJYgeTcDoXmzsM4ply+9SeU03AQXZbufpKqJogd2AGM5XterOSeCrOUvvkyfwcddOr6QbMHvdJXIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724782619; c=relaxed/simple;
	bh=KBxdpkBq/Gt+Zn5bz5HezqsTfz90uEp4yWpE3GB75qs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XIQ7vi1SkCLtWKdWesPzMuXaq2MtZgG5UTnp8gEEV7UUlTGYuhk+gdKRKmov7fm24FUuvcrIE1XfGY0UmtlQLF2O/NRFrwsMhqoT0UNTnpbepb1CtCrILyb3STCl9tFf3Cyl3BAMBP+vSuI7ZpkrcdXFmVq/gZXJ96kBrA+OKhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fwkNtpb4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 724D7C567E8
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 18:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724782617;
	bh=KBxdpkBq/Gt+Zn5bz5HezqsTfz90uEp4yWpE3GB75qs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fwkNtpb4/GMkaOQYLIFILeSKVWAyWoPyvJyrYAbHQpq206Cd1MXlbsJNicpMCKItG
	 oSEJ920unxrkSxnRZJHe8dRkvhlRQ2nC7vP7q5zM1QbXyWjW9j0f+4fKWDEzfY4A6j
	 lI75nA25LJJM7T4NPoWHaqKYCz9lMoTFeynaB5StUM5T9tBZPXp/GmKD9/uF/cLKTs
	 RSzLHoONi6+TW/HnQNHCDqWNDixEDFAQkMUU5+gYFhX4R33KYLBqETAjPOsmHvBEf0
	 Qhlty6K8YHZrH234I2v/gkFtOCfuk/qGkmSrotus1MJ1D/HMs7q+FX0XSt4kd9BaVi
	 kmBehln/YLuOQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6C690C53BBF; Tue, 27 Aug 2024 18:16:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Tue, 27 Aug 2024 18:16:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: michal.litwinczuk@op.pl
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-hPWl6dnQ8B@https.bugzilla.kernel.org/>
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

--- Comment #11 from h4ck3r (michal.litwinczuk@op.pl) ---
Im afraid it might be overlooked issue that propagated to zen5.
If there is someone with zen5 let know if nestes virt also breaks on it.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

