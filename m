Return-Path: <kvm+bounces-4362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1715811A3C
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:00:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80F851F21C28
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA103A8EC;
	Wed, 13 Dec 2023 17:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BersAbf/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC08C35F1A
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 17:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C010C433CA
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 17:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702486826;
	bh=DyVDaQyDZnWu60dzoTXWiXA7SGSuC4rzKLSNn8GYeyE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BersAbf/u1ER806iqR6zYY8mIvaDofODFaSU4mkQSHNjo08/TcHJQ7zSThxoROn3w
	 XYCeFm+BQZAXWoCV0ohU+8GlnzwTyJFIFkDXpKwlxav7vWA6AWWCt5UoVSiAaGpG1i
	 h0bvbXDaOUPUcV8SFBwIslme4kH18x6KtV1QRcvpuvuqMgDa5Fj22KTKAOIxc8xxp6
	 ProuLgDeTPPqzzOg9sdtbBd7Mx7k/h0Ie0ZsQ7pCGzjDzVyUcaEcmEl3Z3YtmPiduV
	 RW6NzdaLuLOsioDL4IMn4l/Q0uNrI8xtyQNT3/OwUoyHM+D1Z+XUfDJ27kPRlQLR9Z
	 SDFP3nSZtf3SQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0F5C1C53BD2; Wed, 13 Dec 2023 17:00:26 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218257] [Nested VM] Failed to boot L2 Windows guest on L1
 Windows guest
Date: Wed, 13 Dec 2023 17:00:25 +0000
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
Message-ID: <bug-218257-28872-pwqJm82fAR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218257-28872@https.bugzilla.kernel.org/>
References: <bug-218257-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218257

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
On Tue, Dec 12, 2023, bugzilla-daemon@kernel.org wrote:
> Environment:
> ------------
> CPU Architecture: x86_64
> Host OS: CentOS Stream 9
> Guest OS L1: Windows 10 Pro (10.0.18362 N/A Build 18362), x64-based PC
> Guest OS L2: Windows 10 Enterprises (10.0.10240 N/A Build 10240), x64-bas=
ed
> PC
> kvm.git next branch commit id: e9e60c82fe391d04db55a91c733df4a017c28b2f
> qemu-kvm commit id:=20
> Host Kernel Version: 6.7.0-rc1
> Hardware: Sapphire Rapids
>=20
> Bug detailed description:
> --------------------------
> To verify two nested Windows guests scenarios, we used Windows image to
> create
> L1 guest, then failed to boot L2 Windows guest on L1 guest. The error scr=
een
> is
> captured in attachment.=20
>=20
> Note: this is suspected to be a KVM Kernel bug by bisect the different
> commits:
> kvm next                                 + qemu-kvm   =3D result
> a1c288f87de7aff94e87724127eabb6cdb38b120 + d451e32c   =3D bad
> e1a6d5cf10dd93fc27d8c85cd7b3e41f08a816e6 + d451e32c   =3D good

Assuming `git bisect` didn't point at exactly the merge commit, can you ple=
ase
bisect to the exact commit, instead of the merge commit?  I.e.

  git bisect start
  git bisect bad a1c288f87de7aff94e87724127eabb6cdb38b120
  git bisect good e1a6d5cf10dd93fc27d8c85cd7b3e41f08a816e6

and go from there.

Hopefully it isn't the merge commit that's being blamed, as that will be far
more
painful to figure out.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

