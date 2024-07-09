Return-Path: <kvm+bounces-21160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 020FD92B26D
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 10:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82ED9B231CB
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 08:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA82215383F;
	Tue,  9 Jul 2024 08:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/DLK0ZA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC49153812
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 08:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720514658; cv=none; b=tPP6/NXQINMyE3yAM5JK1Ks/kRT1IFxa2L0uH0BGYTdT3sxoycdVmlyObj2vznGa7PMktX6JADM5i7aOmdNBfB7x7ZsxWRNBmaM/xiuKzGTqEXuqX8tVYpn6e5ky2RtkKbKBiKfzcN1yykhqDnjmSg4GHuy8FXTEAI0hqhBe1yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720514658; c=relaxed/simple;
	bh=9ZCUa81VavM1MlstSf+OFzGIBH8zkNKOuup3w95DW3A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pZ/85HKHKofWDVlLuUl3grpJ23KwQvuQyocuavMEmrkSlmI+1H9DKVVxZQmL1l4GOsAFXh2AAGPfrsxPk7EfX9WPz2ApAW2tCzFASdfn3cB21b5MuBD9rhK1HjoakszUVh8z7WwJt6xTW9sTdsJRuy6mF5A4+KPiBLU1BUuyCWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/DLK0ZA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98F1CC4AF0F
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 08:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720514657;
	bh=9ZCUa81VavM1MlstSf+OFzGIBH8zkNKOuup3w95DW3A=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=M/DLK0ZAtbRhz/2rywTo0deFAP3VeOJbIFMaQgCWi3g+mA7VKekR16i/6QKN2P/42
	 h74e9EtIaBvkKOE/vu8qIS6XUv09lfNz59bRHTkOQLUYy/jmAcobCBwTusFl/Y53rA
	 B3S/E8dbbSEE7IudTDwGlPfLgE84suu2EykxsdUzLQCKZ3WOIBnBAOmowbU/32SXtL
	 yW7dEnvoZe1dMg0Lh5ZTQji0I1dq4YzILLZSOBXLka0nyyS24P9W3lR9I+qHrzXHE0
	 +63c1uSwjhfbMn1ZzthbEelfACfPP7fuQW0eatjw802ivMIOVDJC0eYWA5NckliU5d
	 0pjXxCI2MrG7g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 91D11C433E5; Tue,  9 Jul 2024 08:44:17 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219010] [REGRESSION][VFIO] kernel 6.9.7 causing qemu crash
 because of "Collect hot-reset devices to local buffer"
Date: Tue, 09 Jul 2024 08:44:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219010-28872-EwoVwsZhaJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219010-28872@https.bugzilla.kernel.org/>
References: <bug-219010-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219010

The Linux kernel's regression tracker (Thorsten Leemhuis) (regressions@leem=
huis.info) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |regressions@leemhuis.info

--- Comment #2 from The Linux kernel's regression tracker (Thorsten Leemhui=
s) (regressions@leemhuis.info) ---
Does the problem happen with 6.10-rc6 or newer as well?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

