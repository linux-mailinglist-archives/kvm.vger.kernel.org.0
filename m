Return-Path: <kvm+bounces-28997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D16D9A0B7E
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 15:33:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5D01283324
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 13:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1191208965;
	Wed, 16 Oct 2024 13:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OU7Jb1Ic"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB863A8F0
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 13:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729085631; cv=none; b=MT31bbEIbThjui5vk9xfN3cHGXinm6wPmj2/sf5NThBKSsF6FUm8LQAxw0lQKMV8QhDFKvLVCXGR1ozFNPpEGBAw2X+jVaOVo598f4iyU8/BCCbJOsSWogNv5iLr7k+0BM3mzq35iH5Urtx9N6d2PQkplxjxV1lLOHfhjf48JC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729085631; c=relaxed/simple;
	bh=DfpdQ/heH8R6uuuvFo9fI0fwj7b1UvCL9xDILvSHjIU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XPOeKZX2Ux/NSyFFs9GCxmzeQbiplHidGCadO09xiOprCVArRNfBmHRgpppst0xNaVN2y+T8zpW7hOVBuuZLczh5Nom8QSZPe7Eaa/jAVf7WY68ZB4li/wZVBnGsg3gJTXJnCXi7ztWk4f6hpiZtlcwASiYoetRv2HiHZJIv3PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OU7Jb1Ic; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E43BC4CED6
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 13:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729085630;
	bh=DfpdQ/heH8R6uuuvFo9fI0fwj7b1UvCL9xDILvSHjIU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OU7Jb1IcOq3b3lby/AwWAN5vmKyGqxzJG5S6IMu2pcDGilSrY3GLSxADbGpvZE3ak
	 vdlK7l11DSxinzCAwEDoC0zwbOqfnlxknKJ6YsMGKFPIfZByjFnoI/39YnLL3qTcSV
	 c4CkyUpAr7fGUi1iRot/47rI34L5Y1BX/RrfiShRxyk5qIxNMALZ7sEhw748tQvzK1
	 ZyCW42jplUTE6mrPI9co1D1nkHdNBW1ED9pS6nxBA9FT8qYkIFuKPGNhwIGslbeD3h
	 8RiwZN82C7PcjYZPnBe1j6f7o1kHLuzRc+LEF2FOCuoz6tA1oiAcO0LvCW5xNaEStG
	 g8ZuN0EejjR3Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 599E6C53BC2; Wed, 16 Oct 2024 13:33:50 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Wed, 16 Oct 2024 13:33:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-HGvsZcVu6b@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219009-28872@https.bugzilla.kernel.org/>
References: <bug-219009-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219009

--- Comment #32 from mlevitsk@redhat.com ---
This is very intersting - disabling VLS should not have any effect other th=
an
performance loss - KVM emulates VMLOAD/VMSAVE in this case, instead of hard=
ware
doing so.

@Ben Hirlston  can you double check that with VLS WSL2 works, and witouth V=
LS
it doesn't?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

