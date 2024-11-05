Return-Path: <kvm+bounces-30759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 855CB9BD346
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:22:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A09E28145C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 17:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11091E1C11;
	Tue,  5 Nov 2024 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HVvK135P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164B21C3050
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 17:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730827339; cv=none; b=l/ZAH/tNrmJ34Rp0w6imh8S3OFnRZwhJLV0z0Mg1VXt9Gc1DLon9SF04DN5JWjKRStii4x/+XKir/viuQubxuTX5GUnsBnMxV1wUNDMieyswFijIy+AfXBlzw/HqJp5cT/bAD7bbHOXaUT6khZWSddzfLWf+J47MJiVuEDkeQeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730827339; c=relaxed/simple;
	bh=sreBy2QjUTwmWRcQPR+xAnXIhoT0SX0Sz4+refeucG4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cPNh0+MwejPUPzv9J3Hqo3Kmm2QWFU54TuIuTrwM3aLEtv3OqM1h/y9qfHtb2Q0cvv+dLvMID3a7Kjm02PFy/3fuscevoLW7vgf+OBgUxLhnoI0OeU5rPq2HA8iYzDWgcpp74l8HFyZgulel2rQmdmJ/ESturEPYXcz97PW3XNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HVvK135P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B41CC4CEDA
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730827338;
	bh=sreBy2QjUTwmWRcQPR+xAnXIhoT0SX0Sz4+refeucG4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HVvK135P7UEkOdDWWOKZ4o0/hTODG84ZqLJHrOX33+d+TItcCyYQbmpIYl7W0r8lX
	 n8QofjxNYaHaiXbR7SCMBcWTy5mHKreefvfG4DNFe16ayI+/CLIsoNwWQ2vt2H76e0
	 hMcxAiYkqWALApTLEClcqkNljK9yQwMfhaa2H8nfrffqru3jrDZeXTXCxN71eFn8BN
	 zHe3BNB1gSIC9EaEXmojXoLclNIaybre5Zr/3UpcJyhj4GwI24xaw6Qoi4PE+QvKce
	 utLYKiRhsKgKcPpvR/6/uAfKDQCT5HI9SynDJuhMkp3mXlBHBLHj7aTqJVp/nYwotS
	 7PvHOeuxHk01Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 95AD5C53BC7; Tue,  5 Nov 2024 17:22:18 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Tue, 05 Nov 2024 17:22:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mario.limonciello@amd.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-219009-28872-sIMOJyIcOD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219009-28872@https.bugzilla.kernel.org/>
References: <bug-219009-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219009

Mario Limonciello (AMD) (mario.limonciello@amd.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #38 from Mario Limonciello (AMD) (mario.limonciello@amd.com) ---
Thanks everyone for your feedback and testing.

The following change will go into 6.12 and back to the stable kernels to fix
this issue.  It is essentially doing the same effect that kvm_amd.vls=3D0 d=
id.

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=3Dx86=
/urgent&id=3Da5ca1dc46a6b610dd4627d8b633d6c84f9724ef0

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

