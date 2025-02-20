Return-Path: <kvm+bounces-38766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2707AA3E2EA
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:46:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D2AB422021
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E52214201;
	Thu, 20 Feb 2025 17:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdOsRd+f"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF9D213E99
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740073425; cv=none; b=BUEq6fYR+BpyFHPY19ActXyy6SPhkbTf61Ah0++ln+kOgZtl27YW/oGaJCXuLT5cl1E/yv1ARixsyUEq+zJkQIq3fvF/kw85BvhW8LoGg/CDIUpYFShduP58/+3oCxgIJZjJ9thqQPaGzl4Szll5A68GO9tnYPpwLqMWlkXTpuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740073425; c=relaxed/simple;
	bh=QyXlAeWK1x12BtL9q9sJIq3Aok05BP7IY2cmdZanXgk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a9uzS0xCRnsbWJxZa3eAUm0RGHHgr1A4c0/yGmWYdV8FKZKrTn79jVUOFh0K9wxxlYaOkDJvldJkI017kXLdz7h/QC/V3GJmfXU98Tayg/MEta7gDcMZqVNNcnqn4tQz974vNkCxsM5h2XYDK0RXQTBf3J9+Tt6MXRfzjrFSU1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdOsRd+f; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D00ACC4CEE9
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740073424;
	bh=QyXlAeWK1x12BtL9q9sJIq3Aok05BP7IY2cmdZanXgk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gdOsRd+f9bcHqB/MdDg04Mzcy/RYsL0JyLBxzxzHlxA2Fbzf0D1AyUmQXM/XoWu6r
	 0Fx2cFKoMQkB1WvQ3yvq6fZSOknkXRoZEAYunTqxOaR4uSTnRaDdO3fRzUi17VIdpv
	 ieRqHcU9S6cHRLlWSzOzNvfbSz20KoqJ5Wd08TCqp8JXM/0p1ly/VdOOvhvhdNtfeD
	 obv+EJWtE+S2GRO7lvsVUzeq3sDKPU6+LpMEq0kdHNYJUrUTQB7i0J0DbAdXVO1lUh
	 HfX6+q8iaVJHInzwao1AHk4rFRgNFiR44LBpYfChgOXw38RomYDtQFvwkF+6yWWm9H
	 0NrqjsWpIYg2A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C7C1FC41614; Thu, 20 Feb 2025 17:43:44 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Thu, 20 Feb 2025 17:43:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219787-28872-ivjnOwXr3s@https.bugzilla.kernel.org/>
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

--- Comment #6 from Sean Christopherson (seanjc@google.com) ---
On Thu, Feb 20, 2025, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219787
>=20
> --- Comment #4 from rangemachine@gmail.com ---
> (In reply to Sean Christopherson from comment #2)
> > Are you able to bisect to an exact commit?  There are significant KVM
> > changes in 6.13, but they're almost all related to memory management.  I
> > can't think of anything that would manifest as an unexpected single step
> > #DB, especially not with any consistency.
> >=20
> > And just to double check, the only difference in the setup is that the =
host
> > kernel was upgraded from v6.12 =3D> v6.13?  E.g. there was no QEMU upda=
te or
> > guest-side changes?
>=20
> I was not able to bisect yet, sorry.

No need to be sorry, you didn't introduce the bug :-)

> And yes, I double checked, the only change is kernel upgraded from v6.12.=
10
> to v6.13.2 (did not checked v6.13.3 yet, but rc version had some behaviou=
r).

Please let me know if you'll be able to bisect (or not).  Unless I have a
random
epiphany, this will likely require bisection.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

