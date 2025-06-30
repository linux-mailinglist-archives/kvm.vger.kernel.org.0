Return-Path: <kvm+bounces-51095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0B35AEDC2B
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 14:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FD413ADEC6
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 11:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B82D28725F;
	Mon, 30 Jun 2025 12:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BiWPatRZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6C6283FEA
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 12:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751284820; cv=none; b=hy84vKEwuD+FOpdxnimFpXN1cVszWfG9XuPsWivz8udpV2gIXjWaPIu6zMxDuwgmvu6k/cR396tCh5P3Z7bXFLKosH0Rcqu6YyIKcLLV4ES82z7LOF/CsWrWLQm0ZsG9aWHlP0xgkbPZ16HmP0R7KRS9VkztcCtC8am1tBxP/+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751284820; c=relaxed/simple;
	bh=Ut4zFXmHTrSoPJkA3sN+2p4J6LZKc3j4XI5JL7Wsfuc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Dc2df5IUeQg6Zlq5Hg/ygk8a9Cy5qVsV+DDQeAvFl4N0AMYaQk9MrIoqsy2513JGSqxvGSSHgYHcLwMQUSv8pqtSqCQOXI6O4/9oWPsy7z3NgoVCIzfvT/CKJjFo7GRo4Vorb4atMgedJfT87mI/NJx9bUOuo4CRYxc6IJzaKTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BiWPatRZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4AD16C4CEF9
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 12:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751284820;
	bh=Ut4zFXmHTrSoPJkA3sN+2p4J6LZKc3j4XI5JL7Wsfuc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BiWPatRZu3um98VsaexP/tb+hladjmgcixHRq49VeQs2Ad0o2gidlLE4AvAGKvyiM
	 iknsClDYULz9Gkvmk/4lZRRYmCeecXD+QuR+60m9reI1dkyGiG4A1GGxQ9p93Bzqvk
	 IFbjeGhXZaAga2AROFYQPzY7naMTqoFQuZYJVm3MrumePeSDgLT9hfLjyuxtBgt/be
	 VIiKvDATbQsUzpJAVQ12ZIN2kGUMubOnzwZmyZBKvoJxBFWnQRnoiV+MYI6IzMeFnM
	 FuvX8Oy+e3rMiknFf3RQQPeQAebGKI+hunLW5efsPPocutJO7uJK50Y0S1oz4q1eL0
	 JFuFXG39M2Fvg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 43D83C41616; Mon, 30 Jun 2025 12:00:20 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Mon, 30 Jun 2025 12:00:19 +0000
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
Message-ID: <bug-219787-28872-g9ZB8loV8D@https.bugzilla.kernel.org/>
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

--- Comment #20 from Ravi Bangoria (ravi.bangoria@amd.com) ---
The KVM fix went in v6.14-rc6. These are the corresponding patches:

https://git.kernel.org/torvalds/c/ee89e8013383    v6.14-rc6
https://git.kernel.org/torvalds/c/d0eac42f5cec    v6.14-rc6
https://git.kernel.org/torvalds/c/fb71c7959356    v6.14-rc6
https://git.kernel.org/torvalds/c/433265870ab3    v6.14-rc6
https://git.kernel.org/torvalds/c/189ecdb3e112    v6.14-rc6
https://git.kernel.org/torvalds/c/5ecdb48dd918    v6.16-rc1

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

