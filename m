Return-Path: <kvm+bounces-23805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECF4094D98B
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2024 02:27:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2ABD21C21067
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2024 00:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A208D1BDC3;
	Sat, 10 Aug 2024 00:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zeap77X3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C732A1802B
	for <kvm@vger.kernel.org>; Sat, 10 Aug 2024 00:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723249672; cv=none; b=LPKuneYJOW49QqMzJVMMc4oPH01LpEuaCXMel+SIWIV+vuwt00o04iAAlcd0vgRlleb96pcgnlDFUxrcIw8ZAbAaht+r58xMEDa3co0EETGPx8nXyIB/Fa97XCkZ8+DePZ2cdy+7DNcTKGSpbXPT8eEcO75O4f/acmUMGWPGuAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723249672; c=relaxed/simple;
	bh=ebnumNLyVeeGwdANWmHqZMbTnCuNTE+tKUnR1wR6zu4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=klp2Qi3JI71NPvCkHAM/nXnfnZeE6xHl+dLF4zxfboaRMhOBcm8zuTWeorlOoyGd/bAw5v0hASzRiZ4ws2Yxx+7d3JKsEk+V0wkZ3gr3NQxq5HLC6waHyDmy0o8lHTIfJmyZKs+P6PBKrYy40NNQk7dMfQRgPc9JVpj4OsP6yqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zeap77X3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 639C8C4AF0E
	for <kvm@vger.kernel.org>; Sat, 10 Aug 2024 00:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723249672;
	bh=ebnumNLyVeeGwdANWmHqZMbTnCuNTE+tKUnR1wR6zu4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Zeap77X3fkOpEYkY7DgG9Ol/aZhGOmpyw80urvkojfAnWjpti2Supy+pWDyIHF+f3
	 1oTlZA1WiNwqmOl1k5r+8SqC8HfrkJiK/mjwHTqKZdRx0mXUqQoayRz06cCGM5gjuS
	 OiYFvKrQbkigzihNqHcKacdFqw9CBAgONwGtf/xqpwqeFIGfmkokieT1ooCzFYlp7M
	 /ma0OBJ16rT/GOOsjgMulnZQSAuofjJ6fxiQK5iyF1A1NQEWZ0wpen/JhRpyQv8Lx0
	 ymsApmirtC3S6j19vRpvK77B2S03CnRcKFaFq6kJqjOTsv8LjC/wxpGulY0tt4VR6q
	 r07WVoopr9pfg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5A826C53BB9; Sat, 10 Aug 2024 00:27:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219112] Machine will not wake from suspend if KVM VM is running
Date: Sat, 10 Aug 2024 00:27:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: alex.delorenzo@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219112-28872-g0YQjwg5pw@https.bugzilla.kernel.org/>
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

--- Comment #2 from AlexDeLorenzo.dev (alex.delorenzo@gmail.com) ---
(In reply to Sean Christopherson from comment #1)
> > Expected outcome: Machine should resume from suspend when a KVM VM is
> running
> >=20
> > Observed outcome: Machine will not resume from suspend
>=20
> As in, suspend/resume the host, and the host never resumes?

Yup, the host never resumes. It's also might be possible that the host never
suspends correctly in the first place. I've noticed that sometimes the final
lock screen image freezes on external monitors, suggesting that a full susp=
end
wasn't successful.=20

> > I tried this on 6.6.42 LTS, 6.9.x, and 6.10-rc1 through 6.10.2, and ran
> into
>=20
> Have you tried older kernels?  If so, is bisecting possible?  E.g. there =
was
> a
> somewhat related rework in 6.1 (IIRC).


Several months ago, this wasn't a problem when I was using older kernels.
Unfortunately, I don't remember what versions I was using at that point, ju=
st
that they were 6.x.

I'll try with some 6.1 era kernels to see if the problem is still there.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

