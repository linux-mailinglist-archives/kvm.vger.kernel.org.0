Return-Path: <kvm+bounces-38764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71543A3E2BC
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:41:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D8F217C089
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A86F1214203;
	Thu, 20 Feb 2025 17:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXH6uY8e"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD842213E8B
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740073261; cv=none; b=MwjHaBgxGNnPJcAG4KSGSXMzP8CpJ39ImiQ3suoVgGqkomZCTNiTts0g5ga5Ovx1HQ8iUbsWNYEhGEbqKsva65Mr6WKB5bxc9t/TT2ouWCLHJiDU4eBKGjS+3N5HOa9x3tgFvajoabSYzPkxOBYrpy7wHMZEXSJrjz9wQg95PZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740073261; c=relaxed/simple;
	bh=UAeU7xGbATgaoIG99mMtJbcfbHEAqG3lHJBpW3OKdxw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lxBOGzLL5WwHxUopgEZzahv2Iuf1rvKgwx31DhXFaxzXz7S2JyUIeuz5Tb65uRSReSav+6iAtB6fyq8GJgjliqW1YA534XP1QKrmW0j38ApW6rjaHu57+5xZyUgqKHxuTAeCokt2a68tvIGCXs0/vrNyLkg1bt6hZRVC0bEtWlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXH6uY8e; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 502ABC4CEEB
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740073261;
	bh=UAeU7xGbATgaoIG99mMtJbcfbHEAqG3lHJBpW3OKdxw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nXH6uY8eUTsS4zRkTWK7lx1rLQvvAag+O4cFzqcaqokHtftJjAAQHDI+KiRAokm4R
	 y3KeBPdGwB+1QDAFQ7WFnwRgQO3IpElnfHIyHHCBwNBIApItGVvEaQzse4OEgIg2uU
	 /OTxK7TzGFJ/BbRODJYKFKgn/KPXyjzsinWEwfqu7PkS1hbWtFXw268e92q1CEHM+v
	 ch8leIFrZgNNQNrdurlxjEVFKSNztgk6zIQV6vtjvU3ae7HlbQqYWgDxuTZ1pYKdFk
	 CohKC3LNk61ajeOjBEMYbEcANAb/fOBhCz4GAzdJ4FDExcuwPNDS3Q4YpWa6blo1yV
	 mzGqSn5CKHUtQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4C04DC41616; Thu, 20 Feb 2025 17:41:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Thu, 20 Feb 2025 17:41:00 +0000
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
Message-ID: <bug-219787-28872-XgOSURp3Ue@https.bugzilla.kernel.org/>
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

--- Comment #5 from Sean Christopherson (seanjc@google.com) ---
On Thu, Feb 20, 2025, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219787
>=20
> whanos@sergal.fun changed:
>=20
>            What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>                  CC|                            |whanos@sergal.fun
>=20
> --- Comment #3 from whanos@sergal.fun ---
> I have been able to reproduce this bug too on Linux 6.13.3 - Specifically
> whilst attempting to download/install any game via Steam in a GPU passthr=
ough
> enabled Windows KVM guest.

Are you also running an AMD system?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

