Return-Path: <kvm+bounces-38989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3903A41DE4
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 12:57:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B3F51891876
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 11:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78BF25EFB1;
	Mon, 24 Feb 2025 11:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iTGM26gU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0130023F419
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 11:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740396964; cv=none; b=KzaY041UsH5aN9o5ZTv5S3t51QL+MoJfbj8NmIadLIiB0lPsVw7T8cKih6v0AN2afXqS0iZyqWNBzAy7NAU7WbkZUl/iA1PTd3LvcLt2DzJOBYmTRTwXsHH1RFimJlzNeouUQ2xHwufae+cTXOpU7s8O1Eq45Ml87j3PO5jtBZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740396964; c=relaxed/simple;
	bh=U2X+wUVZ6C0GkTV9rTTeNKNicFl50o1rVTxmmDyVUGY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fzEo/gp4Xsfv0Cf8tcFCaAYkVc8K98UxL/Xc5TM1E5hkdMZ9h/O49VvOErOYyplbPCypM1Jq60MIoa4U6K9K5sHlIFD1z3jn9XHlvW8JTKD55yrm/i8QgnhzF36y24Na8sCF/UvxN3Cx1NSZD/daJpSK8oPSGPKI40q7L+esbQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iTGM26gU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76D6EC4CEEC
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 11:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740396963;
	bh=U2X+wUVZ6C0GkTV9rTTeNKNicFl50o1rVTxmmDyVUGY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=iTGM26gUBg3bG+ZRaaRBqChit8CVQOGcVk4k0fbMVLY+ziZkc8Pxa2eZfSRAD/B3K
	 Wb5IQUrKe6sWpO8mo9Nni5DlO9d9uFs74bivTX2LV0koNCGPbJGVUn7CPI8f3QAQnS
	 irx83eKpC+O6YEhvEcoqZXWHqsGfX1RYIZScjzJ1L9+xk/d+ukF+4hNtMQAU3r+jP4
	 EFQZ6KFiFIcT22xT9OeZUp3oJ7bgSOYhl0b18KmBfL3uabwVXOmOEY6dXoFMVziTKZ
	 kVC8rLY2GhRhM/UCo0/INIjA7PMhDHFuyrM+tsBBK9a7YYjH8GLwS4TmpCa0XIDV9q
	 twsVX3EvZuBrg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6D4D6C41606; Mon, 24 Feb 2025 11:36:03 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Mon, 24 Feb 2025 11:36:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ravi.bangoria@amd.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219787-28872-kTq8MgTJ0N@https.bugzilla.kernel.org/>
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

--- Comment #18 from Ravi Bangoria (ravi.bangoria@amd.com) ---
(In reply to Ravi Bangoria from comment #16)
> It seems, the CPU is preserving SW written DR6[BusLockDetected] while
> generating the #DB when the CPL is 0 and DEBUGCTL[BusLockTrapEn] is set.

My bad, the behavior is same for CPL 3 as well. Apparently, it's a correct
behavior as documented in the AMD Architecture Programmer's Manual. I've po=
sted
a KUT patch to KVM mailing list. (More details in the patch). Please review.

https://lore.kernel.org/r/20250224112601.6504-1-ravi.bangoria@amd.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

