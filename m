Return-Path: <kvm+bounces-22070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73E729396E1
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 01:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5B7C1C21913
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 23:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA05161FFE;
	Mon, 22 Jul 2024 23:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e8TBJ4WT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F17B50A6D
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 23:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721690471; cv=none; b=dXoWeIWaTLmcYG34/7abu/3XT5U7oD5py/b2vL43/Cq5lvDOipGMznStX+B5t0SujIExGKrIsEagBIH4DhEqPSO3gB4h/El0BqkFI84viHt8KRH+q+HNpduPdN8jMANFLNdS4KFZj77mApRE0lq6BBwZNnxKenTQHSzlO2RwSnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721690471; c=relaxed/simple;
	bh=XVbN9hhrf+joj/qN69v3C72EniYPQf3CfamoZ0Lz6i4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T6b8vtI46Vbv1xvA9lMrZDd32ON7YKROxaN4lZIZGcf9+DgJWMEYTpCmCx795YlV4oK1vbt1P4+BFJBFCoqolkRharStFdppDS4mO2gNfIwM9bNpuiaxvZVxGDlw80UVQhoqUkfrSxbN9hyWZoRr+bBEA7ucEBeQXUEt1Ag1brA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e8TBJ4WT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E63B6C4AF0A
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 23:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721690470;
	bh=XVbN9hhrf+joj/qN69v3C72EniYPQf3CfamoZ0Lz6i4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=e8TBJ4WT+G82wTETIQW08dYpnNdkfG+pFFphHPy6cGbZH4ZKHeTHQu+nl/j+AyNEe
	 wVuPVQfuZmKZd6RlDI3/j5jKT7Ulk27pifM30c30dbZI2fptNhvF7ulNf/V+7Hb3i+
	 TGbHODh8OAJatdLlGTHHjddh0i2j+/KnUTiAd2exATBYJPmla107QZ+xvLKXVmEbf4
	 tA/khZv3hNAdNBKswnlvBzrDsRtTV1ROP4VzRbvDF36Y4ggmi0UoQxPTeqak3U1QB5
	 yKHMW9STRKHiUkJzyG0NGKbiKxKYnIwHIrm1bHfJPyqtc+1AG6M1YXSdH65Z9DOoVB
	 XVLLzOetL+JXA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D9CC9C53BC0; Mon, 22 Jul 2024 23:21:10 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219085] kvm_spurious_fault in L1 when running a nested kvm
 instance on AMD Opteron_G5_qemu L0
Date: Mon, 22 Jul 2024 23:21:10 +0000
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
Message-ID: <bug-219085-28872-eyh39ovmi6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219085-28872@https.bugzilla.kernel.org/>
References: <bug-219085-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219085

--- Comment #2 from Sean Christopherson (seanjc@google.com) ---
On Mon, Jul 22, 2024, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219085
>=20
> --- Comment #1 from ununpta@mailto.plus ---
> Command I used on L0 AMD Ryzen:
> qemu-system-x86_64.exe -m 4096 -machine q35 -accel whpx -smp 1 -cpu

This is likely an issue in the L0 hypervisor, which in this case is Hyper-V=
.=20
KVM
(L1) hits a #GP when trying to enable EFER.SVME, which leads to the #UD on
VMSAVE
(SVM isn't enabled).

  [  355.714362] unchecked MSR access error: WRMSR to 0xc0000080 (tried to
write 0x0000000000001d01) at rIP: 0xffffffff9228a274
(native_write_msr+0x4/0x20)

Do you you see the same behavior on other kernel (L1) version?  Have you
changed
any other components (especially in L0)?

> Opteron_G5,check,+svm -hda c:\debian.qcow2
>=20
> It's reproducible in 100% cases
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

