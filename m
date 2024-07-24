Return-Path: <kvm+bounces-22201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C15DB93B77E
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 21:18:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D8A01F218D0
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 19:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6BF16D9B7;
	Wed, 24 Jul 2024 19:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUUkc9nb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D1B169AC5
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 19:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721848517; cv=none; b=jMi1bDHxRlcH8rTMXRC1mF5bBUN/qfEqaj5jynuekO1E0WrSOLL6XhkOzkKUBwFqpSipo/xF42hocbwzRCVK05Szpz2TiTtmFlwjTKqXI606oReD6eM6LrdQXYCj4FTQDjP2DqXyrhYNIW6o5tw4cjK+5YunrVu3kOLPfEAcRT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721848517; c=relaxed/simple;
	bh=pLPmpAxNRdnIKk24vUea/cA1/ysiK2OSBR9hz+tpZbI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V9CjKjIhBTxpMasgWKgCaO2qE4girREE2JVMzdzpzNGSmja0INbPxklMsfvVecMpRUWzGI03zg+jHzcq4mqROHYQJ1zj1qIWfVpTmsX0bzt+A1QwU9p/ny2G6rUXfk7/3EsWGL+Cm/2DFYEYQJihQF9Xs1r76FeFaUT68X5eUiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUUkc9nb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDFDDC4AF0F
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 19:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721848516;
	bh=pLPmpAxNRdnIKk24vUea/cA1/ysiK2OSBR9hz+tpZbI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OUUkc9nb2J6PbjyIhnpCNtw2Lo0usRXFMliFs2RxtCblYnSietyMljECBTpy9K1Ej
	 bRPh4olW5gozB+oFsfahFA4BvFfJMvK3PEralZeTLcGFacy229wXxJVZ9M42YoJ7dO
	 2h6uUXgErlBLe4nuhNYyy+Byv/rov9tS6VJu6U8Bq/7n9Le0zS8ezuDDzZwF3fmRLf
	 cN8HlbrGrL0o9O/wGDoAld1/vkY0tpJFvOtijheGfZw5ETqQ5jXlm1yjvjxtA6RglR
	 JFZJ9ybxLNjjqJC34u3ApCEZmdLobD/RTaIikRcNsOT9iaqjPxgAzYDvVyj6rogrqN
	 yCMX2FO5fEGtQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CB885C53B50; Wed, 24 Jul 2024 19:15:16 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219085] kvm_spurious_fault in L1 when running a nested kvm
 instance on AMD Opteron_G5_qemu L0
Date: Wed, 24 Jul 2024 19:15:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ununpta@mailto.plus
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219085-28872-e2vXUUujDm@https.bugzilla.kernel.org/>
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

--- Comment #5 from ununpta@mailto.plus ---
Sean, after looking into AMD documentation on
https://unix.stackexchange.com/questions/74376 I think it's clear why KVM i=
n L1
crashes.

AMD says:
> Secure Virtual Machine Enable (SVME) Bit. Bit 12, read/write. Enables the=
 SVM
> extensions. When this bit is zero, the SVM instructions cause #UD excepti=
ons.
> EFER.SVME defaults to a reset value of zero.
> The effect of turning off EFER.SVME while a guest is running is undefined;
> therefore, the VMM should always prevent guests from writing EFER.
> SVM extensions can be disabled by setting VM_CR.SVME_DISABLE.

Command to read from EFER.SVME is `sudo rdmsr 0xC0000080 #EFER`. Both in
non-working and working machines this command returns d01. d01 is 1101 0000
0001 in bin.

Crashing command from Comment #1 did `WRMSR to 0xc0000080 (tried to write
0x0000000000001d01)`. 1d01 is 0001 1101 0000 0001 in bin. The leftmost 0001=
 is
Bit 12.

So crashing command in L1 tries to write Bit 12 to exclude #UD. Nested VM is
impossible without Bit 12. Writing this bit needs 0ring priveleges, guests
cannot do this but the VM manager can. VM manager hooks into the write
operation, checks whether VM_CR.SVME_DISABLE =3D=3D 0 and if true, sets the=
 Bit 12
by itself with L0 priveleges, then returns success to the guest.

This is what happens on Windows if KVM L1 runs on the top of native Windows
Hyper-V manager L0.
Qemu on windows does not hook into write command and guest tries to write t=
he
Bit with user privileges, which of course fails.

Questions are:
* How Does Processor determine who tries to write - L0 or L1?
* Does KVM determine in its code source whether KVM itself runs on the top =
of
Hyper-V or on the top of another KVM?
* Should Qemu hook into WRMSR to 0xc0000080 (tried to write 0x0000000000001=
d01)
coming from KVM if Qemu is accelerated by Hyper-V on L0 and KVM is L1?

> Sorry, I don't follow this question.
I figured out that the commands I had tried to describe turned out `sudo rd=
msr
0xC0000080 #EFER` and `sudo rdmsr 0xC0010114 #VM_CR`. The package is called
msr-tools :)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

