Return-Path: <kvm+bounces-38768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B8AA3E2F1
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:46:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40433189FA4E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B48C213E6E;
	Thu, 20 Feb 2025 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XrVel7+R"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25BA17BCE
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740073562; cv=none; b=KAOenrBR/p3libbqltLP+QFz4foLSHb3CQZFLiCQabiIlHyY9VKkeorgwmkoFLgkQIoAorbljjd60DDI6a30O0V++Z2oJ7wXrFp6vWtyOIPSPf9JUCPbVrG+hYZKZ1w5b9of4JHoZjgme1Vfg4sI5dUh1l5pULud8uYz6vgVBKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740073562; c=relaxed/simple;
	bh=rHp8N8Gnyyy4+Kqcj2tYc3E4gN+u4EqOQL8n6jsxPfs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n6Hy2T6AXL0/xmy/JTI5v9oGOMPPJaHy/voMiDF22ph4z1QTLS5xpDgNKuZ9N+5aiis0J1Y+jhGih2pvo5tJZocMlYu0RAa9SyLhsiJLGvxXbfdmIq+6/kt8/GBY7O8/R2uWEAziRKBJq+X+rfzoWy0WlmcKAHl0ecU61NnGHVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XrVel7+R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F1CEC4CEE8
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740073562;
	bh=rHp8N8Gnyyy4+Kqcj2tYc3E4gN+u4EqOQL8n6jsxPfs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XrVel7+RRBj5Zszne2lYSOw03PW3TAptGE5V76ohMqxYb9wYeWQRejsyReIwGXttg
	 Mrx2NsjOY/tgiNohubdw2rUguNijsyh/gxPIAIOHFsSOPt3BbdyaIxdnZ6gUNCmfW4
	 N7QJlHqNkqtYI4BduYrDfOdMZBa210Bgqv1wTRAP6fDV3on95xLEr/SzEuHW2+/WjT
	 8i6lzIeI67BB5hoRoIjQ9/zdwiKjxNEYTirGBsy3QOiRt8qWF721NWbEwjvccUd/nr
	 W0W290aQ3mk0DFTFQ3Dirv4AsQf17fTMsPZ57SzKGFuM01aazsCqxwVcGRfbgu8II7
	 FXYWCwmCanVHg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 27CD4C3279F; Thu, 20 Feb 2025 17:46:02 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Thu, 20 Feb 2025 17:46:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: whanos@sergal.fun
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219787-28872-nA978xoyPB@https.bugzilla.kernel.org/>
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

--- Comment #7 from whanos@sergal.fun ---
(In reply to Sean Christopherson from comment #5)
> On Thu, Feb 20, 2025, bugzilla-daemon@kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D219787
> >=20
> > whanos@sergal.fun changed:
> >=20
> >            What    |Removed                     |Added
> >
> -------------------------------------------------------------------------=
---
> >                  CC|                            |whanos@sergal.fun
> >=20
> > --- Comment #3 from whanos@sergal.fun ---
> > I have been able to reproduce this bug too on Linux 6.13.3 - Specifical=
ly
> > whilst attempting to download/install any game via Steam in a GPU
> passthrough
> > enabled Windows KVM guest.
>=20
> Are you also running an AMD system?

Yep. I am running a 9800X3D in an X670E chipset motherboard.=20
I honestly wonder if this bug only affects people using a 9800X3D.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

