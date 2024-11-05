Return-Path: <kvm+bounces-30751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FC159BD2B6
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 17:45:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5156D1C20DCA
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 16:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ECF41D7E46;
	Tue,  5 Nov 2024 16:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ju3aZnzN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955B2172BD0
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 16:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730825137; cv=none; b=D6BYY1FM5EOicJLcI/7XxYRUrDNLQdvyN2TyMH1vaH9wvClzh02oEAZRs/tQrVaS54g0sEZv8BaKEs/dKuJN1BsFk4UCn3eAu7NBiWkzxX7DhE14msVoUszvr5wkdIYuk8KoMiu8oq64ncG/YXLM4WlbrxvuSbx1TME5eegFKuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730825137; c=relaxed/simple;
	bh=CoOPmsCyxYK2x4KVezymNkhU8biEHva3tdX5/qK+v60=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BSelv2nym0NhIZ4uANE3GriLDZORuv2KiJVIkikWL7GiQYmjoj2jx9DbiTHpb/eKt+uiAGvOYCPuBdodwH+RU76xMOKbedEEeerSAkbnIuO8AyqRciAG2qRU7c5y0SlGEuoE/Le9b+KDMnOflsdgwKX4xvlV08c1PBBprPil9kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ju3aZnzN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D238C4CED7
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 16:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730825137;
	bh=CoOPmsCyxYK2x4KVezymNkhU8biEHva3tdX5/qK+v60=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ju3aZnzN0MUVAYQrI8tPeQiz4BZ+FtpcEI5eDbE4uGEXNpWNvOs0it5lpzqeSgsds
	 rMoke20vmNI/Dsds8i4NIHw2hWFnJG8sbgsvUL2wvFYwleYVuVlhJEsdGN9UCZxZc0
	 8yu/5ZtL5M5agAXnmfK4XbTBZueIDWgn88RqFmhSonSHWMcJ2DACMnRe9Y2ScGouos
	 zso8dJak0xhZoux4/ZB0XnKIoCa4RwPJ1c2lLG8hDBfT4r8TZRAAyrKnJj+DCRq59F
	 JQ8cXe99ev9uwhDTzyquGxwZRAP16MeeO4a2duiwqC0W+CEIs3YlbAge3OyoE/pjXt
	 GyFxEJ08OHlYQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 30A30C53BCB; Tue,  5 Nov 2024 16:45:37 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219112] Machine will not wake from suspend if KVM VM is running
Date: Tue, 05 Nov 2024 16:45:36 +0000
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
Message-ID: <bug-219112-28872-7hK5iF66ev@https.bugzilla.kernel.org/>
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

--- Comment #6 from Brandon Nielsen (nielsenb@jetfuse.net) ---
(In reply to Sean Christopherson from comment #5)
> Heh, that was quite the rabbit hole.  Poking around reminded me of a bug
> report from Tejun about KVM worker threads not freezing in certain
> scenarios[*].
>=20
> Long explanation very short, can you try setting KVM's "nx_huge_pages"
> module param to "never"?  E.g. via
>=20
>   echo "never" | sudo tee /sys/module/kvm/parameters/nx_huge_pages
>=20
> Note, the module param is writable even while KVM is loaded, but it needs=
 to
> be set to "never' _before_ launching any VMs, in which case KVM won't spa=
wn
> the associated worker thread.  I.e. the "never" setting only affects work=
er
> threads for new VMs.
>=20
> AFAIK, that's the only problematic flavor of worker thread in KVM.  If th=
at
> makes the suspend/resume problem go away, then odds are very good the
> underlying issue is the same one Tejun reported.
>=20
> [*] https://lore.kernel.org/all/ZyAnSAw34jwWicJl@slm.duckdns.org

Interesting, so on my Intel laptop that is set to "Y", on my AMD desktop th=
at
is set to "N", in both cases, setting it to "never" seems to fix suspend. I
can't find the documentation for that particular tunable, but that seems od=
d.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

