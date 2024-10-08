Return-Path: <kvm+bounces-28143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 267209955A9
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 19:32:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C863A1F21878
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 17:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9114320A5D1;
	Tue,  8 Oct 2024 17:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bj5vu36h"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9778209F54
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 17:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728408738; cv=none; b=nn0jCzLkaz2ubnPAo5gu6ER4ze/Yypo0xVJFk9Wj1kuSazD2jv5KTeYXNOZLbNzUp9HsmC0hTUmDH9Y6LuRXlOKzgiWXDxK2hYNK6I/wLwefHREYGUi44JeiBXVkxyTdTSbT5vJveLJAHAWhOGngk2VPKEs18LF5NeNrMDQPTmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728408738; c=relaxed/simple;
	bh=8Qq2nw8SaYJU0R5lXZxDcPHDZa+Tgv7YPY8pbR101Tw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tUUZBKR+dpRM9h6Jps4LpwjpREuqwgFPdnU7/IpL/l5J/KFTSlQgBSyPFe1k8RGeuZe+PTTVxqUnOVc6e43W9XohMed4Zs2kC4hfrpNPwpvKMOKAwpFb9oMLoxnMyzOkDeeCFEVSAFQOgfowsBQr+c5GVoLzdCdI5QVpIp3GcjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bj5vu36h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3ABA8C4CED3
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 17:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728408738;
	bh=8Qq2nw8SaYJU0R5lXZxDcPHDZa+Tgv7YPY8pbR101Tw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Bj5vu36hdJ29ma5jf0fBqpL5fjf2gOGDUsHsyJ2ymdtv3V76ay6AKkJojDQJuAy1q
	 tNmnpJR3TJVp/CMebTs9PbcykvfLfs5ImNWGXw6VKQ+AlyQNjF1ykhCIpyxumGUZTQ
	 HbArGFqIorS0M7TkP2kEHZ0inv/7UKWSwbOYHxoMtoJnkfgjTHXxj67H6RJNW5jk4P
	 M1bmDOljRneh9Tt6XP5U5N5OuvjDiPZaborWaabWZLrsuXo2JbtW+idew3aU7/ZUx1
	 cPr9RD7IySLstdc2dLoP4OR7RWUhwWL6Y/YLb31KHeigFBvwDTi1WYdz/irBP2/srN
	 YWCDXi4652nbQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3424BC53BCA; Tue,  8 Oct 2024 17:32:18 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Tue, 08 Oct 2024 17:32:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: michal.litwinczuk@op.pl
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-ZfiHZpzzsK@https.bugzilla.kernel.org/>
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

--- Comment #25 from h4ck3r (michal.litwinczuk@op.pl) ---
I've recently talked to person which insisted they never had issues on their
guests running on host cpu type without disabling vls.
From what i asked it seems that all guests were linix based and lacked pci
passthrought (proxmox newest kernel as of time of this post)

Further testing is required.

I'm gonna spin up linux guest with approx half of host memory (no balooning)
without any external device attached to see if stability can be archived th=
at
way.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

