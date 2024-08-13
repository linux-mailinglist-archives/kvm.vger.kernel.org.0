Return-Path: <kvm+bounces-24038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62026950A87
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:42:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 133BA1F25E18
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6B171A257B;
	Tue, 13 Aug 2024 16:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ovdPvJBk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E241A257E
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 16:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723567186; cv=none; b=Oc5lVa4CQWsdQBpcIKKwQWyUCU4h1Tv2huc1oBLt/4VkTyLvayJqLNa5UXDfj52lsq4flX/jW8jvr0Z1i2HtSwpu86zlGDzYTtLD2T+hz7xEt2k6Pz8TVVvMbK/I2twH1zkwI+3KifXMmj1GZVTEgr1CbXTkXLLl6uU5itX3OeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723567186; c=relaxed/simple;
	bh=aOPEKmg7GiaRYhCby/S4varJgX6i9Shaudh0InX2b04=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EqcWoIQsVdEXNgOS1CEs7BUFoVYqGYDbsaT0E04jCXBYf3Z04NVBIGWWOVeiiLPdXWG7a6slHBJ4tkewLuVKuiqpoAIFaLI4XODGxDFVBp30U0YR6+T/nnrXEUl/MNTjwIz+5A+f0jWQWdo7T1WwG8kM9eoSNX2A8A40Ioi5To0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ovdPvJBk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88EDAC4AF15
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 16:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723567185;
	bh=aOPEKmg7GiaRYhCby/S4varJgX6i9Shaudh0InX2b04=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ovdPvJBkbzpfuvVE0eMcQmx37s6At8PpkPr/VpoyKAtN/X+RW1zcLtG5tXxM3vuWj
	 O0ku3XwJ7xOCjZV0hy5yBBJLGzpTQl7YDlxQEElRSWo+17sEF69Y7aP9QDdkhPrRat
	 kuF/dW16MvtliNEKXowVhYTLVszzo2j/PaVskjWfUVSsHWd1rXG2W41kSnpqgAHkLZ
	 3EIawIImUfiiNujOntI+Qtrb2/CM1mQReduenK+cQ7L2X1adIpMtA5v4Wgactj6F3M
	 OHDEXqHBLgX4bFH/By65vmK4Quctq+LQMoBZA/3G/eqimH9tr2wQg/IEYC9UGrcJr/
	 GTWXyIsKTl79Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8384FC53BBF; Tue, 13 Aug 2024 16:39:45 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219129] virtio net performance degradation between Windows and
 Linux guest in kernel 6.10.3
Date: Tue, 13 Aug 2024 16:39:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jordan@jordanwhited.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219129-28872-akUNQWEv5i@https.bugzilla.kernel.org/>
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

--- Comment #6 from Jordan Whited (jordan@jordanwhited.com) ---
https://github.com/jwhited/tun-einval-repro/blob/main/main.go contains a
simplified reproduction of the issue. This writes a GSO_TCPv4 packet to a T=
UN
device w/GSO=3D1240 and 2 equal length segments. The write returns EINVAL w=
ith
e269d79c7d35aa3808b1f3c1737d63dab504ddc8 absent the fix in
89add40066f9ed9abe5f7f886fe5789ff7e0c50e.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

