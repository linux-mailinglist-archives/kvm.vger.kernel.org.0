Return-Path: <kvm+bounces-30426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C71329BA7B4
	for <lists+kvm@lfdr.de>; Sun,  3 Nov 2024 20:45:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A929281305
	for <lists+kvm@lfdr.de>; Sun,  3 Nov 2024 19:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C503D187877;
	Sun,  3 Nov 2024 19:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3KxCXQv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCC07C0BE
	for <kvm@vger.kernel.org>; Sun,  3 Nov 2024 19:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730663152; cv=none; b=PLHfOeZfMQE61Xqy3T+OV38UP9M3FFGK/JhBS+mmWLAQhNvL6hgGXAtGrNoGgOPDRl+m9F6kFuByMfRhXL6gdpgun666OtUEjhcvbMm4hOMXdC4oM032bYC5W9r0d/3Ss6LobOphsGAYBNJHcW1jCu4uMT4CWDOjaY55kim6GOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730663152; c=relaxed/simple;
	bh=eXfzTKI77oy0gZiBG5oHjsf/Ip2L0N33R3pV6jkcGDs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nNED7OFE6JbDuqMkXW7uW9zpi+xclEYOWUBpfoKGaj0SbN6OeJkownaItIxGsbSrihlufM1Jm+eCCan+T5eGFxAAoUov8HfcjZbd+gHxpDALByxFdhQQ6JiUtvkusDs41VUIr/tWjaKSO9pfS69uy8zKvq+0fytScgFc75IG7B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3KxCXQv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8453DC4CED4
	for <kvm@vger.kernel.org>; Sun,  3 Nov 2024 19:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730663151;
	bh=eXfzTKI77oy0gZiBG5oHjsf/Ip2L0N33R3pV6jkcGDs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=S3KxCXQvVhBnCutoiSwN+3GEYS+tUxa/nSELpN6yOYAr+ODLKbD2OdhyqR+xX3D0q
	 YFL2iHjMm5JkBKsPLfgLZGoqLF62psp0BLGQXez7RYk8SPkoZgOfSeqwFgf/rRQpHB
	 rIMhabjSWH+BYT0Z0/LL/r2WuO6N5LASiRNQv2PX3AYGiKyq8Ds0DdDDw8gQ74DaMR
	 swyPOKpY6nq4svsUrcgu6MiFRul/dNMRRRSjXOlfrb3sa/Cr0U601frhZ+ZMbQR8tR
	 TAOfDtYQ9YRpe8sPv+pTw23DLDrfjbpcneev23rOb0ZdFJ2JyKEqZIFG5TK7jrgqAT
	 74gEBBIVR5Rww==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 764BCC53BC8; Sun,  3 Nov 2024 19:45:51 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219112] Machine will not wake from suspend if KVM VM is running
Date: Sun, 03 Nov 2024 19:45:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: nielsenb@jetfuse.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219112-28872-jZU8p6aFva@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219112-28872@https.bugzilla.kernel.org/>
References: <bug-219112-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219112

--- Comment #4 from Brandon Nielsen (nielsenb@jetfuse.net) ---
I am unable to recreate with non-user mode VMs.

So, at least in my case, the real issue is probably in systemd:
https://bugzilla.redhat.com/show_bug.cgi?id=3D2321268

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

