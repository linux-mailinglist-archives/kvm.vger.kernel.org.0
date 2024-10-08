Return-Path: <kvm+bounces-28150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D4F799576C
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 21:12:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 99084B26AB6
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 19:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA25212F16;
	Tue,  8 Oct 2024 19:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FMCWaFuM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EAF1E0DFB
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 19:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728414717; cv=none; b=sUdvX/F3OQKccOHQZA5/cIvooMWMY7KhnzC1T5myH4G5UuIe1x8oluGP1IPAp3Zg+Q6JVPRiu9Mr7enwWRA9JRypAAVCUEmaDqGbUQ9OryETnTQx6hflry4GwsHJ8qUy0P7JX4PYmhm+NZvIaH5jwe/FhOEzQnbanPgGA1IedJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728414717; c=relaxed/simple;
	bh=jaahP4ehPa2lGaDUiH7kTKI8W7eBdtdPzaueIrkoiVY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hFxSvWstL+XTc/6mnpcPOsBokohshZqRyzyELxQOdFNz1SFkofclx+zDvpZ+lbio1t39949D0ObcHsgpVctb33cldBvHP2LiUVarK6/gi5eZnjci59w9rxS0dLon6vhVqK7RitRf9+HoR3jrBNfESaZTO0TEgfaIM8YSTkpTZ4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FMCWaFuM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC1BAC4CED3
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 19:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728414716;
	bh=jaahP4ehPa2lGaDUiH7kTKI8W7eBdtdPzaueIrkoiVY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FMCWaFuMzj8Y3csqd+dUe8+fvdYZmRdaMCnubCZtyXSu0M48UwXD0qxHuZjdOqDJN
	 G6pNOgWoVcMzGCQNP2wNNAEPRKQhgsdt74IfGsM3c9PrWGaHyVmZINx5xLfReGo7eH
	 EwtAE96XWfsLHFHIU1p6F94n6uQKoxmDA8AdBMqCXMf1YkaR+hWzOaOVXJN+6Fr6Nm
	 XTIt0QMNXjc3MhB24zZq0ZKwrCXTM1WTuDtjvZme0/rOaFsca/cZSSnQ55cnuMaNlx
	 lU9N50i28g5XfqIM4StrQboOovsxH5onBzmmSitUlfYTjrbBqE/LOrDFiX/bidAJ4+
	 rtPLVU3BdTKrg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A6D88C53BCA; Tue,  8 Oct 2024 19:11:56 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Tue, 08 Oct 2024 19:11:56 +0000
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
Message-ID: <bug-219009-28872-A9G5yBaBeX@https.bugzilla.kernel.org/>
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

--- Comment #30 from h4ck3r (michal.litwinczuk@op.pl) ---
I've also saw some memory related issues after overloading guest ram.
For example after having to write to swap on windows guest i've seen pcie
stutters which persisted even after freeing memory (v4 cpu type)
Same thing happened when guest run for too long.
Thou that might be more of an vfio issue than anything else.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

