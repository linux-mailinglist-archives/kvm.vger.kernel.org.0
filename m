Return-Path: <kvm+bounces-22065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A78893940A
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 21:13:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D947E282609
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 19:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EDCF17085D;
	Mon, 22 Jul 2024 19:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sf5oYMLI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5809317C7C
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 19:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721675590; cv=none; b=pQ0psI5E8pSJ+7Gx8hitTIC+b0fQpHJ1ppwwNp1dMwxY9tW21w3jP3ftTvR686F2PNyj6JONryl7Mxn9847Es0t+919P1/ipitZIUXnE1lV2AP70ELF7G01ngMpV9i299j7HcBGjQK1+afOV19eSZQ8y6Kvzp6WVbU9YcYHB4fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721675590; c=relaxed/simple;
	bh=UcbePBeHe1iVlyD9ihcIu3/8PLSUx1YxIiVsXI6lmDM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PX7ahjumITwi6VWGrwKruQYQTgfh5itpyzl+BJJ+4VB1lRy6i2glde5Emt6qzSYlEUVoErBgh0H/47ETR2ynLfjymfJHcBxwOZsKsUoYy2xfCysIpTt/Lc0eZFuE8rfOfot6OZT/l41qPQiEylwp1nWwT/XhAEOeq69Oq8hrVvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sf5oYMLI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4F51C4AF0B
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 19:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721675589;
	bh=UcbePBeHe1iVlyD9ihcIu3/8PLSUx1YxIiVsXI6lmDM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Sf5oYMLIbPG6gk/s1aw+6LJLF/Pifhc2fgGGx4m6kopcMAjnZvtxdkAs/8tt7JQI7
	 DNspltsi8zDsu0GqA9rRLISChmGYcB+sqDNGDzN6lQBOwtdQlsFui3jd5TQUZGJtP7
	 JvEzGRo1K0KDjU9xrWi7D/hBwzzt0yRZhdHYJ+94DJLTjLsQYMOO656ISSRN7HmCV7
	 zuCvjEANtsClnD/IndnI9Shj1avEydF3OeorPyMQ6hWh7SwJ6lUuAZaAx9ExlKhyNh
	 OlcMXMtgP7QEE9Dq+776l+4bHj4KG46ez36MC3l6EJnPmmNbtnsLjP35Uy5EfkbLjz
	 zmCgxBCbPpu5Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C63B3C53BBF; Mon, 22 Jul 2024 19:13:09 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219085] kvm_spurious_fault in L1 when running a nested kvm
 instance on AMD Opteron_G5_qemu L0
Date: Mon, 22 Jul 2024 19:13:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ununpta@mailto.plus
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219085-28872-KtqhT84gS6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219085-28872@https.bugzilla.kernel.org/>
References: <bug-219085-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219085

--- Comment #1 from ununpta@mailto.plus ---
Command I used on L0 AMD Ryzen:
qemu-system-x86_64.exe -m 4096 -machine q35 -accel whpx -smp 1 -cpu
Opteron_G5,check,+svm -hda c:\debian.qcow2

It's reproducible in 100% cases

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

