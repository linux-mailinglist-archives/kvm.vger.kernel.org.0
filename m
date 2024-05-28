Return-Path: <kvm+bounces-18229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8EF38D2255
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 19:21:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 058B11C22CD1
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 17:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5C65174EFB;
	Tue, 28 May 2024 17:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jy58qV7r"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C68C174EDE
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716916846; cv=none; b=Y3aPPYZxRIuJVfoTHRFNGYKCsXhxFNpu2ymgPq/IETb30ErFVFIe7fegMxjP1aKBvWQnoGiTwI+0Zw8pnYhzXiaXhFuf6CEnlCPENo/Lm0TQ33MZ0ldLnpZEJ1U8TvWmDWueuDFyqjyDFiukk/zKD1lOfFZtQGkgrpPxmK+jU+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716916846; c=relaxed/simple;
	bh=rtHvj4GR3zd2q/v2HVFQZIrslnyfyI+bG9oo3oAQ894=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pRDYCyMRt1ZsUwetPdFkZBhoe6K4zuLm1X0IzPj9CNcq1U6DKevHKQ97sCHRaKcsMdIHQ0T9mivKNL3hUR3KbJ6PV56wE3ptEE72JZz4BL00txU8t+Q/NdZbMfLPpmd87m98kwkZQR6HfnV8faYYMUAtwA6U3C7PL1mdXOHzBeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jy58qV7r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90F38C4AF07
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 17:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716916845;
	bh=rtHvj4GR3zd2q/v2HVFQZIrslnyfyI+bG9oo3oAQ894=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jy58qV7rIzCZf+UU7kkzEqVRdWGVMQizmCnFvmVfMXOkyVel2i2ANYJunfwlVqTdW
	 bCY/YxCHxApwmJCZwf+1WHCKDqnKslnUXvJpS9fs3gdLOMrs2Ao3YOpzXFQXqLKvIW
	 kQyvdTTYDd/KqGSSWZ6lOZS7+ZcWjhqBiZt0hgSnVUHMzdIWoyhpx2fTAlOqy9At2o
	 JZztL0sdvv9qHP/gz3dp/35tiiLZ0baiLe9YMO3r2OWjzG4ZkwHDxWtbev7IBS441/
	 zE56vKoW3D0NkEXgILnyTMeVTcBptcHTH4F6Q8QC6ue+w0hoV1sSEQDnDi3jMGAm1o
	 s9iFGK1H4O+mA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 87DD0C53BA7; Tue, 28 May 2024 17:20:45 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218739] pmu_counters_test kvm-selftest fails with (count !=
 NUM_INSNS_RETIRED)
Date: Tue, 28 May 2024 17:20:45 +0000
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
Message-ID: <bug-218739-28872-7VcFqZN7xa@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218739-28872@https.bugzilla.kernel.org/>
References: <bug-218739-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218739

--- Comment #3 from Sean Christopherson (seanjc@google.com) ---
On Mon, May 27, 2024, bugzilla-daemon@kernel.org wrote:
> I also see this test fail sometimes (once per hour or so of continuous
> running)
>  and in my case it fails because 'count !=3D 0' assert on
> INTEL_ARCH_LLC_MISSES_INDEX event and only for this event.
>=20
> The reason is IMHO, is that it is possible  to have 0 LLC misses if the c=
ache
> is large enough and code was run for enough iterations.

The test does CLFUSH{,OPT} on its future code sequence after enabling the
counter.
In theory, that's should guarantee an LLC Miss.

Hmm, but this SDM blurb about speculative loads makes me think past me was
wrong.

  (that is, data can be speculatively loaded into a cache line just before,
during,
   or after the execution of a CLFLUSH instruction that references the cache
line).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

