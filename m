Return-Path: <kvm+bounces-25069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F77E95F938
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:52:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFC1E283C11
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 18:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41272198E93;
	Mon, 26 Aug 2024 18:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hrFowURe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689AA768FD
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 18:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724698356; cv=none; b=BtuEsEhJ0IyOEg+9krZxIKfxSQNQjWpakNdTaBpOqxEmfJ/yr79Sd9ddWs5enuzJ2haQaR/TG0FYyWamQO1iMItzRPjIAOiH6WpCJv5q7HRKAOxjN7ZViV7md4l20/ul/CciB8KMVD9U+dB5X9KxBrzqMJpQIDIDaYJTY/RZeI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724698356; c=relaxed/simple;
	bh=WK2BAMqhZ/icmbZ+fmuBUC68TjVKRxsGe1wp0YSg6us=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SgogSfaFgb641epWHMaUjJKNOmRzDmZT9PWzpW67RnOY57EGBtE1EyRsiIpiDHq4d2ROLd8cfx5niX/DZ4wRfGRvDfZVwDOJ+xZi4wH4E1U6ueZII/PoBCrMlldRKYrTBEnruhkjb2gg8Er6hFDitgJIde3SkS982skd4CvCmXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hrFowURe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2EFAC8B7B6
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 18:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724698356;
	bh=WK2BAMqhZ/icmbZ+fmuBUC68TjVKRxsGe1wp0YSg6us=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hrFowUReGLj1HbsTJdq/1EQZWpXXXAYGuCeXYHrFLEsxQapIWPrugGToKAiUCkL9Z
	 r/X+NQf/2xGrEphtxqkvczLV1b+OojRGGb9lU6Cn7ZAZw9PDTssrAND/GqALAmVhQk
	 +xG+Nowxi0WloeAhO+mrD4Ict4YqdjQ3Q9fAMYmpzguuHE2J1sFmY3mQ72lWp1yH2a
	 H8gEJnseLpcOkp4mXmZt/PnRfgmElc5iETvFv8Asftslt8koku5LtTG6+DC09yYjtp
	 bk3DwPEU70HRkfv0GzFrPrc4jpxQSlCnFQbT4WamfI/Ji5ChRyx3FtBymHTgWVbk0E
	 gkxU+/zO+q4EA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id EE573C53BC0; Mon, 26 Aug 2024 18:52:35 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219129] virtio net performance degradation between Windows and
 Linux guest in kernel 6.10.3
Date: Mon, 26 Aug 2024 18:52:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: carnil@debian.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219129-28872-SLZkJxPjLK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219129-28872@https.bugzilla.kernel.org/>
References: <bug-219129-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219129

Salvatore Bonaccorso (carnil@debian.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |carnil@debian.org

--- Comment #10 from Salvatore Bonaccorso (carnil@debian.org) ---
Report on the regressions list:
https://lore.kernel.org/regressions/ZsyMzW-4ee_U8NoX@eldamar.lan/T/#m390d6e=
f7b733149949fb329ae1abffec5cefb99b

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

