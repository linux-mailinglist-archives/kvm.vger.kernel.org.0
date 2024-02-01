Return-Path: <kvm+bounces-7705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81EC084593A
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 14:48:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29490294723
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 13:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A245D470;
	Thu,  1 Feb 2024 13:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZkvh47/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E1C5336C
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 13:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706795220; cv=none; b=RpClKdNJtNWV5LwCJxo5Shu0BhBBfXjmzAVy68aAWopg+GWpItFXgktaaaGYZa+YCO7ziiZQh7YCv1s+R7Zo1KP8asspD4zYdgKs66pqVnRgtXyDF3pGIUgzzla5tExu2L9Yocioc932vFSbZumOpoWedmyDV3spDqQWxP2KBVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706795220; c=relaxed/simple;
	bh=lYnLmN5el78VT20pI1M8eRN5xueQxWLxXTnu2Q89b+4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jPCqkXS8GNJrQ4iUFD5UnZyUPf2K04/t6UVA91TdF9COmZAqZr5OkQFTXr2CAl0zmGhLwnIpZg39/Kj9N30MX99S5YI3IQUUveguQ7b6N8nXrrQFkGF2BuCbSEsSBRcxnSfRX/KrqinWe8g0QNK8MYcO+nDKdiG/OwnV0VbIsmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZkvh47/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF312C433F1
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 13:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706795219;
	bh=lYnLmN5el78VT20pI1M8eRN5xueQxWLxXTnu2Q89b+4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jZkvh47/5/P2ug9xAlg64yjJHorR6T+sdiHhD3Z+Dps9jRk5JuS06h4sd2zwfQHEC
	 mYEDe4Wc8oEPlEUjcYNPJ7ArUxQWTMvUg7lp7UIn2fjF8XgUxXEu0ECwmFsoOns49G
	 6F78ZlgudmumcOgg3BOcPmLFgue8BAnhdMr02f2E1pUMGJ1S5gQvigk/e7c/2Rl5DY
	 cAWZQOC6VHAiVXtcnpv6sYTzcmcnIPMZ8ut7JbjEP7U+rfcnIIkq0+aH07o52YEG9C
	 zZ3Z/puFqp/xoKXqU3CcAb9ssBBHOyxLr/7/56RnECYNF3is8dyAB2os0BzxgtnSB7
	 9+l5MSjcASHuQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CB40EC4332E; Thu,  1 Feb 2024 13:46:59 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date: Thu, 01 Feb 2024 13:46:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mgabriel@inett.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-8EHPWLCT6q@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #22 from Marco Gabriel (mgabriel@inett.de) ---
I have several sources, at least multiple clients suffering from possible t=
he
same problem.

As we're in touch with the Proxmox Support, I can't directly point to a for=
um
message, but probably to related/same issues in other trackers:

- https://github.com/virtio-win/kvm-guest-drivers-windows/issues/756
-
https://forum.proxmox.com/threads/redhat-virtio-developers-would-like-to-co=
ordinate-with-proxmox-devs-re-vioscsi-reset-to-device-system-unresponsive.1=
39160/
(I guess you know this thread already)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

