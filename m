Return-Path: <kvm+bounces-28149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C9A3995762
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 21:05:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2371128747A
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 19:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 661C62139B1;
	Tue,  8 Oct 2024 19:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vHB4YlKP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917FC1F4FA9
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 19:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728414349; cv=none; b=aIyMiWKaeP1+5ybm54wqSh3btRUoZJxm6PfeYm0MJI3mitsnAl2r79fIFDmWe5LL70lfJ3BbLXB5JhuCvm3af60jO4OWOBzQZVsWU3nMUOv0lrjoUTsmTw0HDloqZQTlYgVKNyE7XQx8ItrzOD2L7ryeny9ERlBSb5kJkmVQa5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728414349; c=relaxed/simple;
	bh=gloWWZjFWR0ms5VsZAoCfqgUDfnc+RKJiqI9uyKjec4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B2qXFFPk52fSHDT/ZQKPEdgnrJ53Oy8nNBJ+xH347BzKD/kGp7gPuoPrjleyxHby2YghgHZy+zu3JtQoHnb9dstpUnACzVo4DMAmBroQy8Qhd6zf1Zd1t3km4wCYfu/niJ4pt9eRD2BNAC6K7fe9C7zOzXFOJM4Xjpm1v+6pG04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vHB4YlKP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11276C4CED3
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 19:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728414349;
	bh=gloWWZjFWR0ms5VsZAoCfqgUDfnc+RKJiqI9uyKjec4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=vHB4YlKPKQ0O04J3FWDNzI+7a4Z0kZAUvFrsUbS0mSPN2c0IFmtS+LGzCWkJpMsJ+
	 lfoBr+Yp808FtsyKJx1wm+htsjpLuIQ3IxmOhsvBmmMby14vyvCReXMFQsBDywmRdd
	 nfEcchvbXw1iXCL71FOPgeXgy9Xzd2H+4OfTRJXv/rf3sXCfzaNNVNsplywqq7KRox
	 GRmgAqkfoAX/UlwoghhDYsYhWJqHDW/jrwSoD7J1BoYDgXKJGv0sHViVx/9bTDwYEv
	 OCxzsyhw2xiegiyCvzGy3DmIc5b/TmjutDyXBmu6xav7jYwP2CXjgNWWQJsIRVFHbK
	 EhAr07+3r9w6g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0A921C53BCA; Tue,  8 Oct 2024 19:05:49 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Tue, 08 Oct 2024 19:05:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: michal.litwinczuk@op.pl
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-fHUfdNKHMU@https.bugzilla.kernel.org/>
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

--- Comment #29 from h4ck3r (michal.litwinczuk@op.pl) ---
(In reply to mlevitsk from comment #26)
> But the question is - did they use nested virtualization on Linux actively
> and with vls enabled?
>=20
>=20
> The use case which causes the reboots as I understand is Hyperv enabled
> Windows, in which case pretty much the whole Windows is running as a nest=
ed
> VM, nested to the Hyperv hypervisor.
>=20
> Once I get my hands on a client Zen4 machine (I only have Zen2 at home), I
> will also try to reproduce this but not promises when this will happen.=20
>=20
> Meanwhile I really hope that someone from AMD can take a look a this, and
> either confirm that this is or will be fixed with a microcode patch or
> confirm that we have to disable vls on the affected CPUs.
>=20
> Best regards,
>        Maxim Levitsky

Not really - most of them are microservice type ones.
That would also mean there is less chance of corruption since they occupied
less host memory.
And windows uses nested virt even if hyperv is not installed somehow.
(installation does not, but freshly booted guest crashed my node)

Im afraid it might be unresolvable issue, even with microcode.
At least most things point to similar issue as memory leaks on their igpus.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

