Return-Path: <kvm+bounces-17981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE5988CC73A
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 21:34:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAD74283C65
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 19:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7620C146588;
	Wed, 22 May 2024 19:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vCvsx5kx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E193145B1F
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 19:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716406490; cv=none; b=s/+3xOMCnh6NZ76CLOgDrOhZUWEpOrt3Vmmzt/sDofXwPQU4VSAP3QpR5ziRRP2EqdOp7DNQRLn7ZC+VpLhDtK8raWUR2M5vYq6k9/EI4bqqr/jXAOAr1E6NdN8ysCnFNL5q/HrFLK1jeLET8vDysPx40G1uFGFwSAEWxuHCGaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716406490; c=relaxed/simple;
	bh=pI3+r84V+lDE9cv3P+8ES4etq4VSLeRJ213qFeuGJD4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VSWwagV/zM87RuY3Al6IC+gn0T6E97VKcP9AiQJM2ahntu6vAsLbDn8AAFEiCF07ghqpKwU+bo4CxHACWanEHd52ixVhUdmdbV0y096l1CEhNyBwKa2ROfBaUu2yLqMPiH43yp4eJDe8M+UCsr192FwhQHfUoDrkCbAh3kZm7pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vCvsx5kx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5901AC4AF07
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 19:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716406490;
	bh=pI3+r84V+lDE9cv3P+8ES4etq4VSLeRJ213qFeuGJD4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=vCvsx5kxlKG8syNLrS9u0f44s00dVcZUbDXlw/h30cR6YYGTjfHgzn4eKQxEZ7gEK
	 QwU5BIZRUl5eukIGbtI34Zp0lcND67vfdL0HPi1IBrjcTiKD6NeUpQ3XqeC1ynRtUn
	 YpGoOvBKhqwCrW7H5qbYHztSasRCpn5ZjvlUHEasOE0Dgm30q/wlVBBriPXc3Ylf7q
	 8alipunlkaHbw7wKQdKfoU+zLkPyBE9cAoiRckf4pgGX+1wudlFOenBBRcAFEOzRih
	 SVOFolXvofb+hupUmxIra06e+5x1mMGHGy5bYhfeuhmXKRz/QpEw3ri1JIEbBtZP8a
	 HDFeh8MykEhYA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4EAFEC53BB8; Wed, 22 May 2024 19:34:50 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218876] PCIE device crash when trying to pass through USB PCIe
 Card to virtual machine
Date: Wed, 22 May 2024 19:34:50 +0000
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
X-Bugzilla-Changed-Fields: short_desc
Message-ID: <bug-218876-28872-N5hHn1fOrv@https.bugzilla.kernel.org/>
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
            Summary|PCIE device crash when      |PCIE device crash when
                   |trying to pass through USB  |trying to pass through USB
                   |Device to virtual machine   |PCIe Card to virtual
                   |                            |machine

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

