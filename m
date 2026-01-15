Return-Path: <kvm+bounces-68140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C79D22026
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:24:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC17C308362B
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF0225776;
	Thu, 15 Jan 2026 01:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9e0JUlT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CA7200113
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768440151; cv=none; b=E2F5aoIqUfNVL9ZVnpqztawLsld7/k/xaFIH38qDhOOsIQ/t7WiAyVW08jpMweFniodMyq6RIH4BK8iznI1ZFCm+WVBbQuNyKFvBr9DEHqIuN5DAqsl5e3dgtVA+oEJLmUwRfvfA84Pc+hV9+Mpus7SC1R/ZxWjnMKTCrVTPIjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768440151; c=relaxed/simple;
	bh=VHTcj0I3PHj/dZqzeZS41A1hv/56cWgwoQjo8V90vh8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s1RzYrQU/FXkFp+KZNLUT/S31rH68wQr/YiVb7C2SONmeq7Do3ZYMJ3Wsj1mk5Ac/DlUiowV3q3iAsigLeKCP5c8y3Fmkk7CG1tBXLOoimrmSsD1RyX4YtMsroQ7UN/TERIwBN8AjeyXWn2jAkOsinjPa85HOy4PWzArEWQLv1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9e0JUlT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C58DC16AAE
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768440151;
	bh=VHTcj0I3PHj/dZqzeZS41A1hv/56cWgwoQjo8V90vh8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=h9e0JUlTAaiPbxjnI6/DaYfMDYrJ9OSc+mrKYLlWzf3O1MblvKYLG4lua5c/tyPyQ
	 PJZD+mkinkCdkOJT4YKrZr8GMpaJjdkGW2fbtN6Yz6DR6c0vxKId0vG3ZXzJZetFet
	 uLZWn6P6vuBBss2NnY9xN2Eg5GH3ncrqzoMhOuQsHoYvg2dpDDE1WrMCvLJ9v1FwsZ
	 QXpoPXt24MaRK0AXjWaRlSWPQk32TDEtKOYg7ibqrDz0JnRRxd+VGNPAjWqb1pDBpr
	 ufpPd4PMnOcMtREOorgV+G777+dSjItEYd2cJsglRIRjsO4G4qmqtUwgHh2oKdNV4k
	 54QGNtzoZyfcQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0233CC41614; Thu, 15 Jan 2026 01:22:31 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220964] nSVM: missing sanity checks in svm_leave_smm()
Date: Thu, 15 Jan 2026 01:22:30 +0000
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
Message-ID: <bug-220964-28872-CHHSZu8vB3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220964-28872@https.bugzilla.kernel.org/>
References: <bug-220964-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220964

--- Comment #1 from yosry.ahmed@linux.dev ---
On Sat, Jan 10, 2026 at 08:03:07PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D220964
>=20
>             Bug ID: 220964
>            Summary: nSVM: missing sanity checks in svm_leave_smm()
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
> In svm_leave_smm():
>=20
>     svm_copy_vmrun_state(&svm->vmcb01.ptr->save, map_save.hva + 0x400);
> ...
>     nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
>     nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
>     ret =3D enter_svm_guest_mode(vcpu, smram64->svm_guest_vmcb_gpa, vmcb1=
2,
> false);
>=20
> map_save.hva and vmcb12 are guest mappings, but there is no sanity check
> performed on the copied control/save areas. It seems that this allows the
> guest
> to modify restricted values (intercepts, EFER, CR4) and gain access to CPU
> features the host may not support or expose.

This was reported by Sean in
https://lore.kernel.org/kvm/aThIQzni6fC1qdgj@google.com/.

I think the following patch should fix it:
https://lore.kernel.org/kvm/20260115011312.3675857-14-yosry.ahmed@linux.dev=
/.

>=20
> nested_copy_vmcb_control_to_cache() and nested_vmcb_check_controls() ough=
t to
> be combined into one function, same with nested_copy_vmcb_save_to_cache()=
 and
> nested_vmcb_check_save(), to eliminate the risk that a copy is made witho=
ut
> sanity check.
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

