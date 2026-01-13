Return-Path: <kvm+bounces-67967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DEFB8D1AA72
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 18:34:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 91061307BD29
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD4B221FCC;
	Tue, 13 Jan 2026 17:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XnCX7owV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6039C1CD1E4
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 17:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768325537; cv=none; b=X0BwvoyVgqraRadc39tYUXE/6VPH5g5nTNIHmmHyaZSFe1nOKlcy5RZu2jTBVWhqWc3ZdlFGC8AoAmRNr1gLrUiptsdvcZKErXUV6pLqImOqsItbcHsHhfBSB2S6Y3imAqCBRZS6ULtPy286fBbSwXCC0jPGptHa/+/r1ZkmbH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768325537; c=relaxed/simple;
	bh=kbKTVYbXskIVX/4wn6ubrG3YIurqVK4p/e/C6UpS0iY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Jg91gUBSCt2RL9DJI2bqJ9SNCDbJ7S0EdguEp6cLpvneJ1KG5Z0/wRRcRNKTe4dxxLsexY8hG+61rIc+2QSvbWaxr/rETpLOc/a+qsKNLmD61/fEReoqfiObZ9hZ4M3zoNMMLn6sBx40IkTNcMDlD7R9VO3Ia0QKPRXX25F3RfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XnCX7owV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11A8EC19424
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 17:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768325537;
	bh=kbKTVYbXskIVX/4wn6ubrG3YIurqVK4p/e/C6UpS0iY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XnCX7owVktWgIPQwTdM7//OYLed0uDfoJAvp+A3DWXqZEEV0NeYMaGAuTG3vAeS/P
	 8zgYkWgZQnm46pT7auM2aDiZD05c5o+hb19aApekw0Ic6hqPOxlJzsTGSIXfZ7cHc+
	 ckpzR8EM8veQf58kxkqOg8rtPNf2YOMkaQX9ELNnYfT8aUlt7ecKnk4as3zWeX+HGY
	 TA7qNcVFu8KEvprPW0lM9BOxKq5pNtQTUShwp5JjWGZm1TSxf6MydQzvZWtnSmTivQ
	 w9eEt3wvkTR+g4m6Ci/+VRToUs58ASpvLDFxP/OBL/xTzrebuPgPtSeYYktdeR3B75
	 1n8gw/UXMIQOA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0A487C41614; Tue, 13 Jan 2026 17:32:17 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220963] nSVM: missing unmap in nested_svm_vmrun()
Date: Tue, 13 Jan 2026 17:32:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yosry.ahmed@linux.dev
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220963-28872-nAbsWhwVOZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220963-28872@https.bugzilla.kernel.org/>
References: <bug-220963-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220963

--- Comment #1 from yosry.ahmed@linux.dev ---
On Sat, Jan 10, 2026 at 07:33:25PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D220963
>=20
>             Bug ID: 220963
>            Summary: nSVM: missing unmap in nested_svm_vmrun()
>            Product: Virtualization
>            Version: unspecified
>           Hardware: AMD
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: max@m00nbsd.net
>         Regression: No
>=20
> In nested_svm_vmrun():
>=20
>     ret =3D kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
> ...
>     if (WARN_ON_ONCE(!svm->nested.initialized))
>         return -EINVAL;
>=20
> A call to kvm_vcpu_unmap() is missing before the return.

I think I accidentally fixed this in
https://lore.kernel.org/kvm/20251215192722.3654335-26-yosry.ahmed@linux.dev=
/.

It's probably not a big deal, as reaching nested_svm_vmrun() without
svm->nested.initialized means we already have another bug :)

>=20
> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are watching the assignee of the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

