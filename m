Return-Path: <kvm+bounces-25000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 735F095E270
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 09:30:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0106FB21547
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 07:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 876C05B69E;
	Sun, 25 Aug 2024 07:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FUgu5NHV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD4C5381B
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 07:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724570992; cv=none; b=SmFO+59HMsqqNKZqr36S08nvwzd7NCfUvJvSVH0Oo5IhBh+I6K+4VFGKXN8gMqBgXdjkWZleA8bmpOA/3DOtx5nd1wHuvHHcWqIInB12O4rDwLu1Vv8RWbOCbCAuuUoPhrbzLTZcGLJYX19CfKWh9+UOonxBMZ6ZiF/Zj4tvTIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724570992; c=relaxed/simple;
	bh=418rbqy01CAy1mf373iPoix4rRdmBYMbvaZ9eXWW9Fo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FemAyrzz6YIcHrsM8iGdUaHekH9CBOkysPTvhq1YyyHfzLWCo84cV2ZBsgeD7jc+cf3MbKnACMNmzCE3IVYlHv5ovYednoECxPRjKCAO81QPf6GK2aJhSbgSMTmimsosySE3I2BPnsgqZEn2FZIXmdravSOnUTXKt98NZ7IB0Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FUgu5NHV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 369C9C32782
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 07:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724570992;
	bh=418rbqy01CAy1mf373iPoix4rRdmBYMbvaZ9eXWW9Fo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FUgu5NHVj7mHN+og+WjB7ZAUM12+hivLqyD+QQ8bZuBCx3qUdsYc3pMqeCt4xsq3D
	 FG0gcvLqRN3lulLlqgH6WVTtufS4dZxDNL/Sm+E+jB60LciAs/uh8jMkrF2nX8CwOx
	 5X+bPrMqSmdyldUCR58Df/9JdFz4My2gA0xUgTyp0KQq4LNFYR3hQZ0QOcgNXH/2ZG
	 qev96dG90FJaUo/2RkBq1tj/frHIEc/5ki5OVZZXtapejzbtROrP7zxkRoPR37hsLu
	 i6YD85NG9Bg7UvzuUhmwIMhMYL57K2GzhWAYWKLanVi0V4DPg1TGZpqbulIewGfUbM
	 aTxMm1vZ6PUwQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 31FD5C53BB7; Sun, 25 Aug 2024 07:29:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date: Sun, 25 Aug 2024 07:29:51 +0000
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
Message-ID: <bug-199727-28872-KtMy3IwLkN@https.bugzilla.kernel.org/>
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

--- Comment #26 from Marco Gabriel (mgabriel@inett.de) ---
Sehr geehrte Damen und Herren,
ich bin bis einschlie=C3=9Flich 25.08.2024 nicht im B=C3=BCro. Ihre E-Mail =
wird nicht
weitergeleitet.
In dringenden Supportanfragen wenden Sie sich bitte an unseren Support per
E-Mail unter support@inett.de<mailto:support@inett.de> oder telefonisch unt=
er
der Rufnummer 0681-410993-0.
Mit freundlichen Gr=C3=BC=C3=9Fen,
Marco Gabriel

Marco Gabriel
Gesch=C3=A4ftsf=C3=BChrer // #GernPerDU

[cid:inett_logo_150x75_678cb305-4b9d-4816-b8b2-b3d27c917355.png]
Linux
Open Source
IT Infrastruktur        .       T: 0681-410993-0<tel:+496814109930>
E: mgabriel@inett.de<mailto:mgabriel@inett.de> -
www.inett.de<https://www.inett.de>
inett GmbH | Mainzer Str. 183 | 66121 Saarbr=C3=BCcken | Germany
.

Vertrieb
E-Mail: vertrieb@inett.de<mailto:vertrieb@inett.de>
Telefon: 0681-410993-33<tel:+4968141099333>

Support
E-Mail: support@inett.de<mailto:support@inett.de> <mailto:support@inett.de>
Telefon: 0681-410993-42<tel:+4968141099342>


Gesch=C3=A4ftsf=C3=BChrung: Marco Gabriel | Amtsgericht Saarbr=C3=BCcken HR=
B 16588

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

