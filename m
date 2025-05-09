Return-Path: <kvm+bounces-46048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EF94AB0EDF
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5C4C1B60712
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12AC274669;
	Fri,  9 May 2025 09:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oZDykybu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8CC1C5D44
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746782627; cv=none; b=EuYQxRAcVB3nROUiws09G/pu+CUccOSPmK4Ip5A/nUaO4OM+AQb7m4+kzNsJKdjEaQSptU2wZdaL5K+pm2sqzEuCsQV0AfyK2P/R+TK75ijS318P7X3fDKgOkwNqcLg6dqBWRDoWdG/+iW5+eoa0TxjYG0M/GZjBs8XaAtYOlgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746782627; c=relaxed/simple;
	bh=OkCTQbBR+CuwIgnj7ljJdlGGd/Tv47pZGoVwg64wR30=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PTmAivAx8Js+Wao1XEv0CQir/9Nm+Xrpm+1PmuSyqFNb1mZT+9syULBtT7U5pq23jj/NDoc9t5YI/QI9KR4KHx+qlYiFMFjYBxVHplkrVrq74kOcAgmOgd5+TL9s6SZ28zE/v1Tod1pRidhoEK/Ry1qdUP7RVMEjpUQj3WaPcwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oZDykybu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B0BBC4CEF6
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746782626;
	bh=OkCTQbBR+CuwIgnj7ljJdlGGd/Tv47pZGoVwg64wR30=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=oZDykybuAWrB78qsmHKl2RoXeM5i00uw2aN673BmGYUO3qAzVyaLIG3f+v/I2d4x1
	 O8z72s3TPJ1YeIMBVDZFRGRfqSwncRsQqLZR82mhRiD/0Px1anx80GTv3cTHmoYE/8
	 vslSky9MmsHQoGjkqvMsCjVmYVXLmux/3RiRMb16XkfBfSQCmR3/jy3KSyADdMBUIG
	 disWdsgApRAB99aZcIFD1CQUn9Jxbp74o2aUkokdb7FmLpfqR+rDydAgOMhumv2GBF
	 Fo881unJheno9uYTDQIaFoGKBQaVn9LS3swQA0jPAJfjeUrgMkENOt+zYANEaiHoPM
	 tQOxi4TTDXBzA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 53B59C3279F; Fri,  9 May 2025 09:23:46 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date: Fri, 09 May 2025 09:23:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: gkovacs@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-199727-28872-elGScyhIJs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

Gergely Kovacs (gkovacs@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|3.x, 4.x, 5.x               |3.x, 4.x, 5.x, 6.x

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

