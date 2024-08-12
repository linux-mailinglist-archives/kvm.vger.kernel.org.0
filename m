Return-Path: <kvm+bounces-23826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 040C394E79A
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 09:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2A341F222EF
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 07:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F02F81537D0;
	Mon, 12 Aug 2024 07:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A4W8/eSx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B0945C0B
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 07:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723447120; cv=none; b=mEkEDLT+QSFTin+h95Y6n8w/gupNrlqVvt3r19R1bru7JSq2lxJLe7JO1Cyf64xoZiIAUVryJ2d+kJygZXToEjIpzIrmfRxyMZGpWE/uGDVh4/yBaSB3NjAPH7C21+6rkeRuSvSa6PBaZ2axs4DIjSD4Tmx0lzrYBkXW1boYQuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723447120; c=relaxed/simple;
	bh=x1BBjm+Es0P4T9Ihp3siWuBYBZ0WxWqskEQnj5XaQZA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ucz6N1xQxIKX9Dad5Z9ca1qrs0EIxg1NZQd9lGKIXfFdzGfIJgItAChCZJpinaWtPDOxaMV8j67viiCHsA6qqwOkCE4M9HWqasb5Dg6noHEiB6NzgIk2ZC9y0d7mMO6xrulRbZrwcrlOxinRUsT87mdfLZN8TG0dGptl2k9jzaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A4W8/eSx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 968F6C4AF12
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 07:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723447119;
	bh=x1BBjm+Es0P4T9Ihp3siWuBYBZ0WxWqskEQnj5XaQZA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=A4W8/eSx8HJmXzi/IAEx0KpVgFhSizhx11r+yV/U8gt1w5pAJmrJ4IImh0Wr9dyTI
	 thLq1DDvYzgfvnFiqOUdn/ylEhg0JUZygC8QvJE3s5KJ+f3fyEZ5UEQSBre3reYTcy
	 N/h+F14EifaxCBGbNFrgK4hWTCRRnqItE/LK0k3S7RcWEZWlw53e7DfmQrzdddC+Oo
	 a6U76OGsNoQm0VT02bTIasOEkI9RPaApjMpQ/JGkuIUwscWm1kZQtIAXsiuYyfyboX
	 JrLA/8uQBCTaGdaz9yvA+XuuBxUOReGha0WsGB2XqsEuOWKtrW1NVQia4/5jsEmCNK
	 kEyx+q4foQuwg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8F59EC53BB9; Mon, 12 Aug 2024 07:18:39 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219129] virtio net performance degradation between Windows and
 Linux guest in kernel 6.10.3
Date: Mon, 12 Aug 2024 07:18:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: christian@heusel.eu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219129-28872-QBx7PC0HvZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219129-28872@https.bugzilla.kernel.org/>
References: <bug-219129-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219129

--- Comment #3 from Christian Heusel (christian@heusel.eu) ---
No that is not yet clear, but I have proposed it's inclusion to the stable
kernels a few days ago:
https://lore.kernel.org/all/60bc20c5-7512-44f7-88cb-abc540437ae1@heusel.eu

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

