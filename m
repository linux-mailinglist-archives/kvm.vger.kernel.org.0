Return-Path: <kvm+bounces-44612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFB74A9FCF2
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 00:16:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 056323A57FB
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 22:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6FD420FAA4;
	Mon, 28 Apr 2025 22:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7F3VMfs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22F423AD
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745878556; cv=none; b=HHPAPc3ArJwrP0531n63YN9EQrj5fOIFDrGSoJdGavRlUhcA9+ZuP+38AY1DDJRyTXQKMxRUgdNtcgfNg9KKzkqzcJH/mGyVDNUkDPqnMB4A+tFp3tDReW2Gu/bx9DB5svWybbcWxZ5gvnOtvXIp4ymsaox+1Dp8F0UCUILmLks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745878556; c=relaxed/simple;
	bh=z+7NMEi4IKppYBGijC/+pQteZu7YdzVdx1VaB99xl6s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Jsasm5xtIixCC1QMfSamYvJK2nm+i3YMltFhJUI5Lz4FP4JhjZH4knzcFxWF4wn2vaxbAd1AKMAfEtk8YBHT/jZWtZ4bBfmcWaEI2XauIegYgC8ZmVKwymNZ0oRY4gJkYKgHfXmIfXTKPobxqODpqtwN1JUSAtB0if8eqG4PNKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7F3VMfs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B88FC4CEED
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745878555;
	bh=z+7NMEi4IKppYBGijC/+pQteZu7YdzVdx1VaB99xl6s=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=P7F3VMfs6IN9/J0mw20zYYy5L3jZfkXLT8MHVAw7T6ZBZSMsZyJMmV+lt+Y2o/uMb
	 89sGy3IEfxk1sYQRP5VydLo4oI9qjfKm5QoMZzsX61X1sntQWiCsJ/MpX7Uaryzk0p
	 uqJX10CzuyTHPjxb1pACWzxKMUrbPvGP1bPp5n8hIzxjpAgB2+XBfQBKXY0pww1XHA
	 iQn9GRE7B4NpWE2W0/C61dh0XUt2xXE4gWZNZgH6fG3e26cirTMVtyKA9KMxWt2/DY
	 FxvmO33aQIOkuWRkLYQ8EzvvAjRBAOHEw8oaufq+yezAdOvUUIG3JdhYZBs9VneI/q
	 ECDNvftMRXJhA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 73257C41612; Mon, 28 Apr 2025 22:15:55 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 22:15:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: alex.williamson@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-LfQkp6MWVC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220057-28872@https.bugzilla.kernel.org/>
References: <bug-220057-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220057

--- Comment #15 from Alex Williamson (alex.williamson@redhat.com) ---
(In reply to Adolfo from comment #14)
> Created attachment 308045 [details]
> vfio_map_dma failed
>=20
> I forgot. I have no idea if this is even remotely linked but I'll leave it
> here just in case.
>=20
> host journalctl: vfio_map_dma failed.

Does adding ",phys-bits=3D39" to the cpu: line in the config file resolve t=
hese
errors?  Please include output of lscpu.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

