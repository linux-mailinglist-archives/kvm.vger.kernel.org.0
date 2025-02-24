Return-Path: <kvm+bounces-38988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CEA3A41DE0
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 12:57:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7DC41886191
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 11:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3137B25EFA4;
	Mon, 24 Feb 2025 11:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sn6ejOFq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4120C802
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 11:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740396824; cv=none; b=BZCRlUp3waw8J+nKJt+wgk5mm76rR5BNeOZPqnPhqnAOCI5Ci5EW0XVuT0KweJ6YxOhixYkq457hkQ/a1GHrzOy+ciV+lUbM+1rjaED5vVi7bPmF4BAKipPozflBUmpKjz9Aek+okPVDZRC4kxiavCt5UHcGni6QOOuiI7bB6J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740396824; c=relaxed/simple;
	bh=lGwWXfwKz4pV5Ukv+kyUjyCqMU1NFTAZURglECm1cjc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EHXMqHeidXeG3Ko58jXzD9pMUWG18DIQ1SGEidgPoUb6cOrf5qn/WVVGUj+crQsibgplTHe/GFXO10X1/BjqItYPl4oux4MTh4+OLGItvCt9dDTp+c/f1W4wrok/oc1qyfWavA9EsePcIWPGU8m8ouHN3hTMMFOCDoQoPp/X0zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sn6ejOFq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8E4BC4CEED
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 11:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740396823;
	bh=lGwWXfwKz4pV5Ukv+kyUjyCqMU1NFTAZURglECm1cjc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=sn6ejOFqGCvdtOrsgrbb3Mkvx5J79xhef5FPLFTceaEzE90FcBmQy/N3BegRVclWo
	 PWP9wIdTTg16men+1qRsONVpgH6gkqZEtTZfc8H2Hpz0yAaGEAkJD0gv/m42OzYC6v
	 PESDPoxhoJW9q1VNQIVAtwYE7oylw9poCCuJ/plwArdXxyKQC0tZVDMB90I3Z0y+T7
	 jvBMRgT3eloFoTRU/ty2uoYbjhP9ypwaHZ7IquPoMr+19BMFjpAQwr89bA0buyUm4U
	 3UR25akbAnhHQ5edtvcXEu2B8TwycO6UMAGbLA9UuS5Tqz4cpH17o+1R/+FkX8lVlY
	 rD1K3SUovnusw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A06F3C41616; Mon, 24 Feb 2025 11:33:43 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Mon, 24 Feb 2025 11:33:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: jonbetti@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219787-28872-2DarJnAZeG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219787-28872@https.bugzilla.kernel.org/>
References: <bug-219787-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219787

Jon Betti (jonbetti@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jonbetti@gmail.com

--- Comment #17 from Jon Betti (jonbetti@gmail.com) ---
(In reply to whanos from comment #7)
> I honestly wonder if this bug only affects people using a 9800X3D.

I'm running a 9950X and had repro as another data point. (I had this issue =
for
a few weeks but thought it was Steam until I started looking at crash dumps=
 in
Windows... and I thankfully stumbled onto this bug which restored my sanity
:).)

(In reply to rangemachine from comment #15)
> (In reply to Sean Christopherson from comment #13)
> > Bug reporters, can you test the attached patches?
> Tested, these 2 patches solves the issue.

+1. Patched my kernel and the issue went away (again: 'twas Steam for me th=
at
threw the exception).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

