Return-Path: <kvm+bounces-27832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 689FF98E64F
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 00:53:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E942DB20E3D
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 22:53:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8071619C55E;
	Wed,  2 Oct 2024 22:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uvcO0GlV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A8084A36
	for <kvm@vger.kernel.org>; Wed,  2 Oct 2024 22:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727909581; cv=none; b=VDEJfYgwdl1YPJek3uz803h9R0Q2PGF1mYmXGF9RlnY8KZEawDVyjzcwgPkidzJmAwRIHlu1cU9JR2q5QiLgsaB6cT3dDfNBdZ+nxRLkvNzTphCdhHLSkGzcHjTUKDqXTYvDBwgTCX8R+lpf9N1QcXYistlXvxesCXROdzPN2iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727909581; c=relaxed/simple;
	bh=vfjlWc9/ns/0e5grtwJ30OGeQ9jj9aK1vXaHaGcR+WI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eyalK2UQDAga4elfVhrN5th1p79C0r290ZipwvVmw88Qj99AKm4mUuNvxRLnOp+mbrOG9Q9SLzA1HsmRg94yMTaRqBSOMfchyqp5fUIgSfmTwOP7RPJH7s32Rpt1c4p+X1nT94B1fZfrwFz2zf6BD/u/uqONAAr9HiVRXyDooTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uvcO0GlV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B2A2C4CED3
	for <kvm@vger.kernel.org>; Wed,  2 Oct 2024 22:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727909581;
	bh=vfjlWc9/ns/0e5grtwJ30OGeQ9jj9aK1vXaHaGcR+WI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=uvcO0GlVyu+2GeUwiDvwbliV60RrlmmRCuECwSv1Pjq9GkU270w1Eo5z4Iu6OcjwI
	 TGngHFGn6hq6W0S5GEq7oCew5FFS4cbLThsfm5Tj+bR5zzuoF6EMMkvIXmlxOZwwx8
	 F5mtCQHcrUEwNaB45pEn1Yab8aOB7aOBsQ+WDqc/hnVXubKqgqjVuJsTLt8Zm5d/xX
	 enJgYFTsZyJmC4yZM8MgBBBj2xI9fFpLFGIwR5VCuZhre10rBvGONivo0Nd+X23+iu
	 5VwEsNNcSCw/FU5EuGSsBzfmv0PdQlpw9Rc1wST+2PxRIAFlQV8UV6KOA+qzmsPz6h
	 etzEO78LPERlA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 35D18C53BC2; Wed,  2 Oct 2024 22:53:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Wed, 02 Oct 2024 22:53:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ozonehelix@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-bW4Ti1cByg@https.bugzilla.kernel.org/>
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

--- Comment #19 from Ben Hirlston (ozonehelix@gmail.com) ---
my curiousity relates to this new bug being caused by fixing the CVE's
CVE-2021-3653, CVE-2021-3656

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

