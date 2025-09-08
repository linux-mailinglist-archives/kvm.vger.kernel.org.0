Return-Path: <kvm+bounces-56976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DB5EB48F03
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 15:14:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A89116C227
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 13:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F256F2F546E;
	Mon,  8 Sep 2025 13:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u9IVBsBv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2AE306B2B
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 13:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757337130; cv=none; b=KNSpQnaRduwufvGWe5cFefulAJthwkMpmY/41Cx2+JPzWtUvn5KeqgBeblfP0Gx5NsD7f2Evzm7HFS+2wHQ1LRZ/waxQaqKP7j6jfTNMakT6VMShTzh7XGQqJQVVN9bF9vxHBz83JO7JU7NI1CJY0JUJ6hhYORrXEa2Adio1qKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757337130; c=relaxed/simple;
	bh=FCHC9R3vg1FGoxrNV0iSS+Tjy5mo2E9qTUxd1wYJ8Bw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZIxSeTb/0VBH00I3VqTmr7QTnyVm843R5T3RIqypbUIgOEQXkNyJNYH5fQ0YSNOSEXGDKlL/2T4Eo+KLkRayuV/+Wny7byATPilXLoO3jOgw+ZKnZY/p6iB8s6JhU+Bj8+t+QezNTp1e/1i9cPk9s25Ms8/sDQqWVGOvYnTL0og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u9IVBsBv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA034C4CEFA
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 13:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757337129;
	bh=FCHC9R3vg1FGoxrNV0iSS+Tjy5mo2E9qTUxd1wYJ8Bw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=u9IVBsBvnXfOF0wTogFNrO4lgO0GDLGG/A7z9h7y8i7dXX6Uvnrp3MuBvdyI1YS4U
	 MoOA8jQbIF2byg7BLcRekG9AUnb8vFNMn9bNMf3M/S9bDJUNNEdrQm1hqM11NOEGHd
	 aAKXMCMSHZPkhEahnFhaaaBSdxmPgytQ59cQXqorsujuIDoK04LnHiMq2f0WkwpN6u
	 v58Zu5AMGyjDSZyKe9uh8j4oN99KwcfIvpkmNqjUqbNfHWlo3lbUH+KP+X+2gVGnKn
	 BN9mceE4h9WSfRQ8UyMACriQpLpAszOz6gtREVFi3sgUbvgVLzATeCpnQKmQ02Nvbx
	 8bf1XmraFpQRw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9FDE2C433E1; Mon,  8 Sep 2025 13:12:09 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220549] [KVM/VMX] Level triggered interrupts mishandled on
 Windows w/ nested virt(Credential Guard) when using split irqchip
Date: Mon, 08 Sep 2025 13:12:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-220549-28872-K7UAisy9MA@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220549-28872@https.bugzilla.kernel.org/>
References: <bug-220549-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220549

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |DUPLICATE

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---


*** This bug has been marked as a duplicate of bug 220548 ***

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

