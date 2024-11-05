Return-Path: <kvm+bounces-30761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3715D9BD3AE
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:45:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1FAC1F219FE
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 17:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEAF91E3DE6;
	Tue,  5 Nov 2024 17:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FuMP6j6a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58A91E3786
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 17:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730828695; cv=none; b=PeYXsTR7mbe7jvs/ereuNG2QYuzS0/0dx8rCva2LuA5dbz6HaHPgcIrgarfnFQsF4uFRCmMl5R2nVAMnQSMguTPaWR+eUVr5IbwWwdRYPFlPQdj54lo9cB3NIKLLZIzwSEOAFbybhiOli4BQC9fgz3WWVLnlXyd6I2dXGcIDWao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730828695; c=relaxed/simple;
	bh=69B0xl2Rtii/iIorWMyThJNFyfonPayap0h/ym3ig1w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fNlNgzBEUUU9bVvXiNgijuoJ/9Sc4pHtGcdzODrRtOaQ9s6SS/yL/1IDoeTs5GoHC04KAyzYuNrzdndyCMPFnz7BjNwexY8OMCGWLpinn3fBgKT4mxcnR/AGqwbiJSgRWLgyfo1/JfOltoO+nRuvBRay+4KpJHy8lWkkAPlf6W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FuMP6j6a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70746C4CED6
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 17:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730828695;
	bh=69B0xl2Rtii/iIorWMyThJNFyfonPayap0h/ym3ig1w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FuMP6j6ah6p4o31sLkTRMK7PdR0UW6fAQ9iBPL0u0bBnqkM9Lgeq2FMwxDaI51cVa
	 y0O9B3Vq/ktMJpjOMEbo+27j/YRg/0mtSuQssZM7zeCL3JA2eG89cLNVv44rJJcZnH
	 vh5qgcX/cw00ie86m6XYJaEhkdALlHkCExLPhY3tNjYp0eut1n6sQCM3IenrdgSeoR
	 hJBe8RFuO07pBcR2GAYO7PvT+Y566PVJ7oQSjy/kY//CVmswVhtoP0N/mdj0ViUGQ6
	 ZKoCmf3JjW0k3xSVtJnJP1XZJJ8g0LDITjrOvTaeUi2Xl7RCbWHJKpJHeeDdlVvbk4
	 ddReZrXHJyV3A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 68128C53BBF; Tue,  5 Nov 2024 17:44:55 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219112] Machine will not wake from suspend if KVM VM is running
Date: Tue, 05 Nov 2024 17:44:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219112-28872-CrbRMPpL9Z@https.bugzilla.kernel.org/>
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

--- Comment #7 from Sean Christopherson (seanjc@google.com) ---
(In reply to Brandon Nielsen from comment #6)
> (In reply to Sean Christopherson from comment #5)
> > Heh, that was quite the rabbit hole.  Poking around reminded me of a bug
> > report from Tejun about KVM worker threads not freezing in certain
> > scenarios[*].
> >=20
> > Long explanation very short, can you try setting KVM's "nx_huge_pages"
> > module param to "never"?  E.g. via
> >=20
> >   echo "never" | sudo tee /sys/module/kvm/parameters/nx_huge_pages
> >=20
> > Note, the module param is writable even while KVM is loaded, but it nee=
ds
> to
> > be set to "never' _before_ launching any VMs, in which case KVM won't s=
pawn
> > the associated worker thread.  I.e. the "never" setting only affects wo=
rker
> > threads for new VMs.
> >=20
> > AFAIK, that's the only problematic flavor of worker thread in KVM.  If =
that
> > makes the suspend/resume problem go away, then odds are very good the
> > underlying issue is the same one Tejun reported.
> >=20
> > [*] https://lore.kernel.org/all/ZyAnSAw34jwWicJl@slm.duckdns.org
>=20
> Interesting, so on my Intel laptop that is set to "Y", on my AMD desktop
> that is set to "N", in both cases, setting it to "never" seems to fix
> suspend. I can't find the documentation for that particular tunable, but
> that seems odd.

The behavior is expected and working as intended.  The parameter controls a
mitigation that is enabled by default if and only if the CPU is affected by
L1TF.  But, KVM creates a kthread related to the mitigation even if the
mitigation is disabled, so that KVM doesn't need to try and spawn/destroy t=
he
kthread on-demand if the user/admin toggles the mitigation while the VM is
running.

The "never" setting is a relatively recent addition that allows the admin to
commit to never enabling the mitigation (without reloading KVM), specifical=
ly
so that KVM can skip creating the kthread, e.g. to reduce VM creation laten=
cy.

As for documentation, I'll add that to the todo list, I simply forgot to ad=
d it
when introducing the "never" option.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

