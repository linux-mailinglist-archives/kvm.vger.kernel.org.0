Return-Path: <kvm+bounces-17984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA3618CC7C3
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 22:38:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3F991C20F41
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 20:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64883145FE9;
	Wed, 22 May 2024 20:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BetgRvaC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5E341A80
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 20:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716410327; cv=none; b=fN1K3dWqyzJHVqmpjoMS0GjrygehFxoKNczyEH9CZGA7VyHxPSSRPIKi+KCarVJHW2A9PuYSphqU0aksvLwHFXi8Kl7Nj6miQ5JvrO2OpmR1867E4P2wAsPcncx2dm40ZNYZQ4DLBYRPAGkeJYmzkndPHSv1cr9eVElvBH5IzD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716410327; c=relaxed/simple;
	bh=r4SVa6e8R/9m3VxqIlr9fr0vh4e3w+kQOr5HQVAHu68=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uetazl2PzuhPKpQQYd4GCjNeM4v7WXLmdglHqsEkwE7jLkNvVgKNoWRggwoHwQw1y6cL+Q5cVeTDg2yFqbmHC/xNNRSUhlz4/GcioDY5JUOalYXYq3CloHqRQznqi46pFQWPd1aBlDe3RUEEjnd04s7yt2ft09fe/NAYWDzv/z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BetgRvaC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0AAECC32782
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 20:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716410327;
	bh=r4SVa6e8R/9m3VxqIlr9fr0vh4e3w+kQOr5HQVAHu68=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BetgRvaC3bEHjyUIwU2hi5dja32mQhONoeeGGT0C/iBqGvCIs8sExb9sQNqVzJMRC
	 MjjIfiLbe4O0aFPj6tPhD49YdC35K/hddxUz1MFCzJihe4MUVMyrc6GAZW1WiO3RWq
	 g2SaIkBJPdolcXPuqCWARuOh7nEOxvDEhXaHa546+MCV397pQxb2ZKWxrfnikQnr+G
	 45m85eMPVAG3ifrPnMFa0RUxgImxK9MI5ao2PX8JC/xGG8CN9E2tb8pd5SBvWXfmMO
	 QFKHvl2s42CTQIUHcUYvBpCuBVXauucPOfU687dz9hQzvikXj8bDqCfiUGFqAewD88
	 vlMhiIT7XLkCQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id F2701C53B7F; Wed, 22 May 2024 20:38:46 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218876] PCIE device crash when trying to pass through USB PCIe
 Card to virtual machine
Date: Wed, 22 May 2024 20:38:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dan@danalderman.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-218876-28872-UiXTt3h59Z@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218876-28872@https.bugzilla.kernel.org/>
References: <bug-218876-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218876

Dan Alderman (dan@danalderman.co.uk) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|                            |6.9.1-x64v2-xanmod1
                   |                            |#0~20240517.gc240cba SMP
                   |                            |PREEMPT_DYNAMIC

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

