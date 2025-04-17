Return-Path: <kvm+bounces-43535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F2C7A911F7
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 05:15:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B52D819078AF
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 03:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 500AB1D514C;
	Thu, 17 Apr 2025 03:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MHFJVi4S"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743061D63E2
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 03:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744859706; cv=none; b=UvdcN8iLv3H3pao+MoXwdIdeZQYe81uK0tMf2fUaewkb+nnWo5RLFSgZ4p0pmEvMfL5QdwKms4eUfZYasqgjc01oOr4xZ80NzLZ4T3pYZ7pq6+x6ZSJ8VwH2dr6B41mSGeKr3VrwFKvyMoTfHr/s48WhsPKeGX0UIE34doEuMb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744859706; c=relaxed/simple;
	bh=7aCPsQ9Ef1EuU7GVm1lWpdAhWo6Z3aOouuMAkvDlqos=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Jdh00w9wkJX4s2Xpu8VCP5J9HHHEV7qM3AtzrAGDzhGCRw3tOnqkg7825Wb+8mLupBhPN9/aDOxzPegxU5BebFzo03rQlJYJDxY7wObWj685dDczIIL0SdrXhGyjb5TWWh5xvfifk3zFbnqF6KY9ib+I9ikxdtBPOm0rBCfPw2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MHFJVi4S; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27F4AC4CEF3
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 03:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744859706;
	bh=7aCPsQ9Ef1EuU7GVm1lWpdAhWo6Z3aOouuMAkvDlqos=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MHFJVi4SuTC3MKlHHdN2dc2fkuGQHQsOeop4lqefGgqDEsHLZxnMn6CyA+iIEJJ2V
	 SidIcCInzBrxtZHZ/ucKH9qcTEz9LKnnknKRUbJAAJvxJW2gPAXpUfmcscgq5UcdfE
	 3o2uzrXGfVUPStDQFJ0l9b7/+kGu+qIink+0FTEwmGPLhX3uGnOsFK8POqD9l2kRh9
	 OX0zZArATf5omNZ+zVi/yC6A4HX/aFbdC3+f1w4S8octyZNWk8Hbn+0Sapp1IbdCYI
	 yK8eleS8FXZjNgDiR6otQWchoVS0NiCcwyNtxQ3Ai0XpqAVqY4P4+ZVc3wzIRmVIC0
	 rEKWHMM9a618g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0B42ACAB780; Thu, 17 Apr 2025 03:15:06 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220019] Host call trace and crash after boot guest with perf
 kvm stat record
Date: Thu, 17 Apr 2025 03:15:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220019-28872-ULANU6Xwlx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220019-28872@https.bugzilla.kernel.org/>
References: <bug-220019-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220019

--- Comment #3 from Chen, Fan (farrah.chen@intel.com) ---
And we found the fix patch has been posted already
https://lore.kernel.org/lkml/20250415131446.GN5600@noisy.programming.kicks-=
ass.net/,
verified this patch, it fixed the issue indeed.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

