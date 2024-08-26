Return-Path: <kvm+bounces-25070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42A8995F93A
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:53:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFB721F21720
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 18:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C27B1991A5;
	Mon, 26 Aug 2024 18:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NQXqC37L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55121991D8
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 18:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724698376; cv=none; b=dArk/c/e1mMTEUSifbdaZdaEV7+rm2zE4gqOH5SamtilW5TjW6nPSyTRonxW21ZlyuXUxyKxCOJ5kpl9S1NlRJGAjnHHdLpGv70U560ZIm4hZqghnmko/PSI0QTFvc4Oh/5DbOZhNxkSJb7oE7EFrFEkad6qYEQS8V0ZPGfka7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724698376; c=relaxed/simple;
	bh=dHj+G9y/F/l7SUx/AQFpO94GJqKhWL7q2yLxsglVq0Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Igq8kHXMOtcV9PLcxzdmwkB2vsc3RShwSznQI1y4cMPRKbL4n4g0WZat1F9+x2ZU+qF4CPn1GkuMIR5lVjnDXjIr1HZe79CcUUzbO2kBvNH0/ZYRVZQ6p4k0/SVNn6xC6DsOAr0T+pAIeoOeFWGmOZZW+MMHM5eKGon7ekJGUyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NQXqC37L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AC3CC8B7B4
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 18:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724698376;
	bh=dHj+G9y/F/l7SUx/AQFpO94GJqKhWL7q2yLxsglVq0Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NQXqC37LuCLgpBdcuzZW8bzWl2lgpyhfLK6JtVAjLRamhrJZ37+hWGe/uUygGydKC
	 XpJJGGJyEt/4Z8J49FWIB3ouQvvM1jbmiNwctPnAtjVtLdyettu8x1hZ8RP6f/2pba
	 FhWko4hhhzFHxVV9RlcozLn06WHjwXO2YJUxUlT6kZ/yTFhLVM5oVGLAao9KIltxLR
	 xvNTE25Jte0+GvjTD8ypwr6RE2KRaqdeGrMJJWDvKWHltqAULR2Lrp93DqT09mkQPF
	 XgZveP44Cp2fKrVwoccKR1ivEx/IpEqabYRakPlGfCJ6nh9IpvKo1r1fl+v9TAsqZU
	 O9gvpf/1mNnag==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 74534C53BA7; Mon, 26 Aug 2024 18:52:56 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219129] virtio net performance degradation between Windows and
 Linux guest in kernel 6.10.3
Date: Mon, 26 Aug 2024 18:52:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: carnil@debian.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219129-28872-M60rAAP4M3@https.bugzilla.kernel.org/>
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

--- Comment #11 from Salvatore Bonaccorso (carnil@debian.org) ---
And a downstream report in Debian: https://bugs.debian.org/1079684

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

