Return-Path: <kvm+bounces-24157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31888951E87
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:28:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B933B22DBC
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 15:27:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 708B21B4C23;
	Wed, 14 Aug 2024 15:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fH8LCb9C"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3301B3F20
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 15:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723649268; cv=none; b=LT1H7q6e8YkKBcWC9fOHkN555jRNDba3iPwfdU/Ls/G4KUiMuJNRgqVmoBDN14hLVRrwId+dyzg3Jb3NfPatiixG+khl1VNJVfzQqINnEEgry1s72s8X1UKl2oph46NGALL1FXoVQPisty4p7FPeBSeZvcwEj8JrRk2RonjEu/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723649268; c=relaxed/simple;
	bh=aFAfci1uY6V1rb9ecYOp/FyT2RZt3gLb6uKon7/ep6A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VShAzxPbdNmHgMMQBdcN59y6Al2R+ZnsiPboTq7Kj/C4gc/1+CmtJ1ISK07mYMkJleHyIL6L5blAd07YF0rb4e8S7aX5k2DLugBTmRHr3lGT1n6l5XZaFmemTPK4Lo6Zl9nmPTkCa5X0tI5Q7t/Fx8h51l1CV3w3cTAmcq7QoNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fH8LCb9C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C2D2C4AF14
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723649268;
	bh=aFAfci1uY6V1rb9ecYOp/FyT2RZt3gLb6uKon7/ep6A=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fH8LCb9CirIZiwp1pjwRY0V6HnxEUWq7d29C0ohEtaD7Es0DauU399/+XkDblZjXE
	 EIoD3Xx4ItvI6Udbpm0dz1dt/tb637uLy0NC+IbtjNQbh1wgtgRr0UR//AFpeeS+f1
	 FRvd/mnRL3eIlCo9yF2WYOiK/mfrlxKY7Hgv8zTpj1xYi+pTuufBoS2UBZ9TOvAlMZ
	 77Z7NlXA3KwNXKhS9YXN4dkx/VTLRmHoB8yUVNcGk3GZUJCkRGo3yrADHMVXyjeWR4
	 efG+DXR4emE4CiUbOA5xLsM8CKEtMUw0NNlI49jyqZ6TiGODG7r3UQx+clbePg44sG
	 qJdOX68M4C7jw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 25D08C53BBF; Wed, 14 Aug 2024 15:27:48 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219129] virtio net performance degradation between Windows and
 Linux guest in kernel 6.10.3
Date: Wed, 14 Aug 2024 15:27:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernel@clark.bz
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219129-28872-R4VDBZvlsh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219129-28872@https.bugzilla.kernel.org/>
References: <bug-219129-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219129

--- Comment #8 from Thomas Clark (kernel@clark.bz) ---
Thank you!

On 8/14/24 03:24, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219129
>
> --- Comment #7 from Christian Heusel (christian@heusel.eu) ---
> The patch made it to the 6.10 and 6.6 stable queues :)
>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

