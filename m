Return-Path: <kvm+bounces-38967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA5CAA40CBE
	for <lists+kvm@lfdr.de>; Sun, 23 Feb 2025 05:57:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0731C1898E67
	for <lists+kvm@lfdr.de>; Sun, 23 Feb 2025 04:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DFEC1C84CC;
	Sun, 23 Feb 2025 04:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZyrE9Flp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD887E0E8
	for <kvm@vger.kernel.org>; Sun, 23 Feb 2025 04:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740286652; cv=none; b=tHIctGoaTM51KRbq/XT6Owf/YkyHba1Xi1FE6JZ8Iq20026WrPtiFSbC80j1Tv1wFRs6RSEP4gjBixrUVBA+4JNin3uzaC1F9WEfQiTtzMuRm0xvvQuWMTC1Fk9XIx8qQYjL5UEKxuM01bEA+AwqecrU4q+vE1CV1stbOaYn3Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740286652; c=relaxed/simple;
	bh=wGfQHdYGTNKFILC4asS/SCxHJUWU5t+CQGfAkXCoeAQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gVXl02OszSfVDsBSUtNLWv5WbwTW8lUVhTa69PfukSt7fxBAe/W7A+Id+WsYjl5etvcUb0YGuYrYqqNDG8WOM5mwxQy1VtKfKeTiJPNd76bmHEhhWzysBblx4GjQ8SlgfFkgVPjG0fUBv6OCWjt5pvz2de7YsXA5Bm6SN/NMTP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZyrE9Flp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1458C4CEEB
	for <kvm@vger.kernel.org>; Sun, 23 Feb 2025 04:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740286651;
	bh=wGfQHdYGTNKFILC4asS/SCxHJUWU5t+CQGfAkXCoeAQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZyrE9FlpgxLt7p7jOvFkkxWyimUC4d7HdaMVuNK26oTETl5Mpr9p8plHpYt/fZSSq
	 eYR8/g5ByBRhiWwelRvK6Sn373wPfGxKkr/xTgrw/riY71PZwWnPOOcMwhzlAh2eME
	 G6/WzaaWEjOVVPAvLK+UxAATlK5TIMqzdtiJ+izbRH6SxhnyHSzrgBjgc7MaumcbSi
	 zH9Ch+Ru7xF8Kz151NLzOAJbmAgckzeJwwccyR25ahWEHce6HoLPFrrBWW7XAopC47
	 75Cpqq4WDdwmoUEyeC3avi7nKqfiavCajA6w9E0ITw6X/5saAMbQlosHSc5UoW4vw6
	 Y84UvodKW0ZgA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C9345C41606; Sun, 23 Feb 2025 04:57:31 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Sun, 23 Feb 2025 04:57:31 +0000
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
Message-ID: <bug-219787-28872-X4Rs1A6BGU@https.bugzilla.kernel.org/>
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

--- Comment #16 from Ravi Bangoria (ravi.bangoria@amd.com) ---
(In reply to Sean Christopherson from comment #13)

> And does AMD do _any_ testing?  This doesn't even require a full reproduc=
er,
> e.g. the existing debug KVM-Unit-Test fails on my system (Turin) without =
ever
> generating a split/bus lock.  AFAICT, the CPU is reporting bus locks in D=
R6
> on
> #DBs that are most definitely not due to bus locks.

It seems, the CPU is preserving SW written DR6[BusLockDetected] while
generating the #DB when the CPL is 0 and DEBUGCTL[BusLockTrapEn] is set.

Since most of the x86/debug.c KUT tests clears DR6[BusLockDetected] before
executing the test, the bit remains cleared at the exception time which cau=
ses
tests to fail.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

