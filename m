Return-Path: <kvm+bounces-67196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ACA41CFBD3B
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 04:22:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 00F0C30380C8
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 03:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4246623EAAF;
	Wed,  7 Jan 2026 03:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HywfgVDR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6810E4A33
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 03:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767756146; cv=none; b=LNfufCczkr9pueyr3Ap9u4IL9/QZv3SVCtA709I+sAfMEnc7s/RRCF9tIPWH1oTQjXEB6BtIgMJpLnpCX0M+3A6Hfm1kIf0x928fi9w3npnosW7Z1LxTU0AB4SCt8auz9BMn/VSF6dlugwf0HqjfUmX+YwmeM/Aq9QcVjUDUhfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767756146; c=relaxed/simple;
	bh=L5/aDWLim9nviEvwQuFzh2RTdUpIMa9QIR5bE4H1y44=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ls+xcWFDKEZaQV/aIA63Xhb3vAF0lzYLdKkk7N5EkUgZMs/QOfcXikKACsL4GS0h7I5o+1z5EqLVX2lzbYg1Y3353U+V8aMeRNvZK2WTVrTZWZu1czw1l1BtAUmHtTzvI7OaZPwnku9Td/SNXR7UNHUC3RTC9i1Bco9lHSn3gbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HywfgVDR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D72F0C2BC87
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 03:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767756145;
	bh=L5/aDWLim9nviEvwQuFzh2RTdUpIMa9QIR5bE4H1y44=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HywfgVDRlxvn1zFe/sEy/qEgJR+AvG61Ni8DXa9ue1a3ve3OgaN4B7bkvpsV+R6i/
	 93sPuErST8TX4++hyaQ4x/szcqMoW9m2c2Y2PIKLBhNPHPI37UaXZzK70GpYwtE46r
	 wWwn8HyFZQfftIho3j56TJsdcY6GhFt9rcozx0COrla06cPtUne/7ozi7QgQ8iiroI
	 awHHhJ5XhRH7pLseQ1F/kP/gQGgEGWUWQzAGz6d/nQ8SZTmG1Pv8/eBHGT8RXbMZVR
	 DvOlhxqI4u4FXM4zd/iN+CyvMDoDKjF3yXOcAar/jusqGfZOuJ5YvUqMWpvj6X5RD/
	 RTl3D8aATnypQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D050BC433E1; Wed,  7 Jan 2026 03:22:25 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220740] Host crash when do PF passthrough to KVM guest with
 some devices
Date: Wed, 07 Jan 2026 03:22:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-220740-28872-prO8cxaWJk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220740-28872@https.bugzilla.kernel.org/>
References: <bug-220740-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220740

Chen, Fan (farrah.chen@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #9 from Chen, Fan (farrah.chen@intel.com) ---
Fix patch has been merged into linux.git master
dc85a46928c41423ad89869baf05a589e2975575.
Verified on latest commit f0b9d8eb98dfee8d00419aa07543bdc2c1a44fb1, test pa=
ss,
issue is not reproduced.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

