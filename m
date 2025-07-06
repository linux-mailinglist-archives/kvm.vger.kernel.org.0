Return-Path: <kvm+bounces-51617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56323AFA35A
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 09:00:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8811C3AEB3F
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 07:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A73081A316C;
	Sun,  6 Jul 2025 07:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l3SatRWw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5842E370C
	for <kvm@vger.kernel.org>; Sun,  6 Jul 2025 07:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751785224; cv=none; b=VfqMlXNHHFuhl+gehgnk21UhG51CL/7JBOHEleGctJ9oQTjN7lTGQBnpdXMSktkJEr4BTet/TkRldU8a1NQJ261aUxdV6ebIAUulllfQ439X8FjqwuyDS3uA97mhdUpo+9cL/yQZxPLBhHzs01Woz0o547XSzrZvcU+O7e+KO2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751785224; c=relaxed/simple;
	bh=27PYfGl47rsGn3Zobkmo29Q/O40zNNDdUkiDFpDCEzM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S1YjIsY3P+YFjqh2YZQYhHcJUmwwbHFHSm3HPLXAiLIeLN1aypCuI27WD9K79tqQ6X8nRodUaXNt6ABYKkTymxNyrVFgyIoqiXfibAOdVqUP5hqbAiARcb4VVa9/6OT0EQKG/GrBT0VOSYbAwwTh3fEEYWDj+YHf9wEWa98htdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l3SatRWw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6302CC4CEFA
	for <kvm@vger.kernel.org>; Sun,  6 Jul 2025 07:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751785224;
	bh=27PYfGl47rsGn3Zobkmo29Q/O40zNNDdUkiDFpDCEzM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=l3SatRWwzzFYb9n+solqHtWH2ThuEYFft52IR3T3oon008T0rJOJcw0ns4+afiKh+
	 dcip/g7n4VLSla+N0xb1TNIwZjTRi/LOd6ROF9k+PBRzPbt018RonEXcQm7uTA52wt
	 lAJN88jO/uTI/yvHB9TMNAK9rgTiCWR/mmcaaEPWdGuuhjVbW8MZ5wGcqkp9ldJqIn
	 Pt252DNeDEgVGU6Cm7mrfhpp3PXl9/hawbi2MMEX7OWppLtKogptomiRGr3uvuNHtw
	 39sAIUno2NkZaRBbfuchrM06aKiBZ4k8Z82IXm/DlJJLt84cFiR21Oj1LHUNPE9lzD
	 T1XU7dE+3C2lA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5AA9FC53BBF; Sun,  6 Jul 2025 07:00:24 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Sun, 06 Jul 2025 07:00:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-219787-28872-IAgqH9R4VE@https.bugzilla.kernel.org/>
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

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #22 from Artem S. Tashkinov (aros@gmx.com) ---
(In reply to Brian from comment #21)
> How can I still have the problem on Ubuntu 6.14.0-22-generic with VMware
> Workstation and VirtualBox?

VMWare Workstation and VirtualBox use their own supervisors (kernel modules=
).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

