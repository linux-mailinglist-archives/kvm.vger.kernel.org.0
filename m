Return-Path: <kvm+bounces-59629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CC701BC3765
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 08:23:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 96D394EFF69
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 06:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EABBA2E1758;
	Wed,  8 Oct 2025 06:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eN3/j/Pr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B359247295
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 06:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759904608; cv=none; b=pG6UWlNviwK4NLRPwDAWTS4Vuzamvzt9USU/ZSNhpUUh8ki5cLoAl+m7Nwmet+UbvEf3xmlrWK9OxMyGY+jGbjdHC+cwZIf2JJ5hpeAHaOFNQZyQQAKCOYvzFi+JsOfpxzSIzFlI/s9dkoUL65/2jHUGQd4Rmmf8s+BPjgw0p0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759904608; c=relaxed/simple;
	bh=ZwFiRy0LMcwZTfoXEA8jp0873qOtOE5nAnqhXs0Mlw4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fQ7ruQLus/ksEb/bvSWG99mNlPF9N5X4yVJ21l2N0cHaNv57UZaYSlz0CzFo0bbxJRRWlXIr8hjis/B8xPZsZ7O1Mn3ayiEcpdaSv/7BPkKcuPfmMsrbuLYRcq2WjjAl4pzJ0F4rMRfiuhhJOFWBwAd1c9pDqaWP5YjUcNJxNPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eN3/j/Pr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4B52C116B1
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 06:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759904607;
	bh=ZwFiRy0LMcwZTfoXEA8jp0873qOtOE5nAnqhXs0Mlw4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=eN3/j/Prr/4dNe3I9CBOIRA//T8PKIbCkusrA90D9RU2bc2NjPa5k8Zn4kjvpALkd
	 1ZSRbwOlPIBbL/2YHw9JRQPuUfPlYyNgg/9dI52SW/SOu8P389H3qx/lapBIl1A5lk
	 t5A+iulpk5aOOa/IjJ+F0VPi3SWt/yGqni4zNEphDKJbXQrxyxdKOYlFeROI4in2YI
	 cp7ycvPQMj1B2OBCKFiZ4Twv4wilktfj51QmGKl/HW/oOpqUWAUvts/0wSfkJLhY7f
	 EoS8J2En5ge0Mxgs+rGVQ1KgoOUFWxFh8hAz+0zor5OWHM8c4rf6DQKgX6wSjI6TyK
	 5DCehQbUmuiPQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DBC2AC41614; Wed,  8 Oct 2025 06:23:27 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220631] kernel crash in kvm_intel module on Xeon Silver 4314s
Date: Wed, 08 Oct 2025 06:23:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: f.gruenbichler@proxmox.com
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220631-28872-8FvT9oMHiQ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220631-28872@https.bugzilla.kernel.org/>
References: <bug-220631-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220631

--- Comment #6 from Fabian Gr=C3=BCnbichler (f.gruenbichler@proxmox.com) ---
thanks Sean!

it seems like disabling the Kconfig (at least in non-debug builds) seems li=
ke a
good way forward, I'll forward this to the Ubuntu folks as well (we inherit=
ed
the Y from their kernel config).

@Kevin: I'll ping you once a kernel with that disabled is built, so you can
confirm that this makes your issues no longer reproduce and we can close th=
is!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

