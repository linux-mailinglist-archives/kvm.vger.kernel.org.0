Return-Path: <kvm+bounces-13872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0832B89BCD4
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 12:17:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6880AB2251D
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 10:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 276AE52F87;
	Mon,  8 Apr 2024 10:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I6UFY/A3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52871524AD
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 10:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712571434; cv=none; b=NuNDdrxnV1Y4+Z+1GlKV7TP//9H/7ONR8u+RGTw6IUlIuR4Gy6Qxv0njZQBNG2FhvJpGa02Xxvb2EY0KLgPN3Bbxl0UgY7HExWjSrGR7lf4tFq4Ds6EtAUeWRcPRTYM670A+CRGLflyUQ8UIOGgaaF83AKjxsVevGPZ6wDZpS00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712571434; c=relaxed/simple;
	bh=fz4YeGvkKoR5kmc/E8PSurIa8ZZv5ax2hnnebm6qlHw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ReXbZGkDwXwI5SMQa3caIQ5FmRVXdi6CNe+/qvLkRA4FpW+ibKXAl+3Smz9Ms/75njK74ugBPMaXD5PjOin3xFL5pA69qdPzN8HWv3hBfNvA1LqBGeAJfhAzxzlhkNqOzrGjNaVU7HcqFIf8CZgU3Fq9dGWMvu++z8JB2+yhZXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I6UFY/A3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA6EAC43394
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 10:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712571434;
	bh=fz4YeGvkKoR5kmc/E8PSurIa8ZZv5ax2hnnebm6qlHw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=I6UFY/A3b3/cZroozX1XHJ+VFI5LhMh7e4DJO4WRFqf9qj8WVcJBKPQzGAC6qcV2F
	 C4fJxYvWTXYRPW5t2UvzFfSyDbCE+WRLEGwLCXHIcLhe8kPTYx2a70pjvKAhacHlvg
	 qEr7IRpgTYx/FsKIAVVj3a1oBXhpfjHeoWeqIUfQZ90NPOyN/kVjVtJR5qdlPtMSxF
	 aJx/17s6ZgpPGkJpbNLRHfuELq7E03aOd8INON+Uj2Kuukl+40fg7lxEP/xuzwK5LP
	 r7exqhkiiSMa32GdUcwch7AUNfSnloWtt1zz4538NaSnaR85vXtQvcxi146xjaZkEX
	 NBEYycLoxSBSg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E0F13C53BD9; Mon,  8 Apr 2024 10:17:13 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218684] CPU soft lockups in KVM VMs on kernel 6.x after
 switching hypervisor from C8S to C9S
Date: Mon, 08 Apr 2024 10:17:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: frantisek@sumsal.cz
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: PATCH_ALREADY_AVAILABLE
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-218684-28872-ztFRu80GP8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218684-28872@https.bugzilla.kernel.org/>
References: <bug-218684-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218684

Frantisek Sumsal (frantisek@sumsal.cz) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |PATCH_ALREADY_AVAILABLE

--- Comment #2 from Frantisek Sumsal (frantisek@sumsal.cz) ---
(In reply to Sean Christopherson from comment #1)
> On Fri, Apr 05, 2024, bugzilla-daemon@kernel.org wrote:
<...snip...>
>=20
> Hmm, the vCPU is stuck in the idle HLT loop, which suggests that the vCPU
> isn't
> waking up when it should.  But it does obviously get the hrtimer interrup=
t,
> so
> it's not completely hosed.
>=20
> Are you able to test custom kernels?  If so, bisecting the host kernel is
> likely
> the easiest way to figure out what's going on.  It might not be the
> _fastest_,
> but it should be straightforward, and shouldn't require much KVM expertis=
e,
> i.e.
> won't require lengthy back-and-forth discussions if no one immediately sp=
ots
> a
> bug.
>=20
> And before bisecting, it'd be worth seeing if an upstream host kernel has=
 the
> same problem, e.g. if upstream works, it might be easier/faster to bisect=
 to
> a
> fix, than to bisect to a bug.

I did some tests over the weekend, and after installing the latest-ish main=
line
kernel on the host (6.9.0-0.rc1.316.vanilla.fc40.x86_64, ignore the fc40 pa=
rt,
I was just lazy and used [0] for a quick test) the soft lockups disappear
completely. I really should've tried this before filing an issue - I tried =
just
6.7.1-0.hs1.hsx.el9.x86_64 (from [1]) and that didn't help, so I mistakenly
assumed that it's not the host kernel who's at fault.

Also, with the mainline kernel on the host, I can now use the "stock" Arch
Linux kernel on the guest as well without any soft lockups.

Given the mainline kernel works as expected I'll go ahead and move this iss=
ue
to the RHEL downstream (and bisect the kernel to find out what's the fix).
Thanks a lot for nudging me into the right direction!

[0] https://fedoraproject.org/wiki/Kernel_Vanilla_Repositories
[1] https://sig.centos.org/hyperscale/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

