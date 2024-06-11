Return-Path: <kvm+bounces-19299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51F17903360
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 09:22:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF042283555
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 07:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8574D171094;
	Tue, 11 Jun 2024 07:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NzQQMIqQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B177026AF6
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 07:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718090564; cv=none; b=RcGkbxU++EXKQ01eYFkvleS2HLT1/wDJx17OnOEMeFOHJ871I8uZKThDFz9jJnrHkDQozRzdYxrgR8MkdlZD8D63SV/q1rR3uswmHJfqwjvxM84610QuCarKnvMPxYcMT8GQfrrsApnA96yn8WKZPQwxhSUZfRpCmKREDWOaiHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718090564; c=relaxed/simple;
	bh=yRmLZ+6rpBbFCtCjXWC9vMU7rBYCeDJf+yK4AummjEA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Txjtb9FPHOi0CsD6EIyw+Udm8EPBGKz2Ks3TqGWWyVLfUagDZJBdNITAnsNVVd0B6JaU9yf+AQfsvC1SPDKHz7gCrbEhoMeGQfLIDA9WSa1oMgbr3UOiPjNAG+e7wuQbotOENWqpRU8q9C6/JknQKVDnyk+KhSyDwj/jUaJZ90o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NzQQMIqQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 337A2C4AF48
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 07:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718090564;
	bh=yRmLZ+6rpBbFCtCjXWC9vMU7rBYCeDJf+yK4AummjEA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NzQQMIqQpIhxk6OCE7A0kSKWvwx2HUNToDv/ow7jbaI420C0vgjGc1leA+pNMYlvz
	 C+lQ3zgoQOmxZUCH4UDbg8uwCw6Iu0hLcUW7UxuvwoaGo2pKrTWGLXeQxQ0BZ4ZDz/
	 /YFC2hzZi1QZCB19anE2mc4TnBSkCjUtDmhT7BNrJTNMFq500xBa2Q5h8ylDDvj0PU
	 kvyOY45E+yRHZikkn3AEKEuGr+HlgYbHsz+N6p21RqFPpNAVok81/t/IN3FYp7LlMF
	 NvCv6BqMoangPkCPAs7szL3cC6c3JflFSph6P0oeNalfuaeF66pF2R9KsfkBR6g/jh
	 smpNb6bnrsFCw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 29034C53BB8; Tue, 11 Jun 2024 07:22:44 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218949] Kernel panic after upgrading to 6.10-rc2
Date: Tue, 11 Jun 2024 07:22:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: PATCH_ALREADY_AVAILABLE
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-218949-28872-y0zqKBhO08@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218949-28872@https.bugzilla.kernel.org/>
References: <bug-218949-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218949

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |PATCH_ALREADY_AVAILABLE

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

