Return-Path: <kvm+bounces-22014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4840D938280
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 20:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79A041C20E27
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 18:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EDA514882D;
	Sat, 20 Jul 2024 18:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cDiREyyq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0D6147C8B
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 18:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721500211; cv=none; b=YRRZLfqkwtB0sQ0RzAopes+SaNJDEd6nRVNGW5TBnlKy8SskXHBsHK1bzU0Nf6IksN2BP469kH0weKpmdBQtW8teY6f5B2bC4/BNkz9FfhYvrBVyk9Wcdp3X76r5snFFomqrWeYUg5v9+yS6L5+dM4Frupwqj1ifEXd2G+g2adU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721500211; c=relaxed/simple;
	bh=ubTlAVokGmlBI38td5PiGQMBAMs5zPIjXkHDCBee//E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kHDlBkTg1m92jpIQbFuhpCCRBw0LvD0DN0nXVyY02ywjuQgjjcNaI57nUSHPTKOf1qWu2urmSmLSpTqQzmOKbrO4he1RRdPckeZaPjz7P9MtIHlvDNQqZllOibyR2XFJYqozkyVxJke/YkZQKtVvBGQZfW1PtJl6EfFHTpjYt5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cDiREyyq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id C25CBC4AF0F
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 18:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721500210;
	bh=ubTlAVokGmlBI38td5PiGQMBAMs5zPIjXkHDCBee//E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=cDiREyyqOhbqRqid2euI+kIrLP1fVUJH1/DHZeCjvNuB3cG1ceGEd0cazV7U75xAt
	 tkmsP7a7Tym84pLr8cXHHsl4wGMdlBRI1PElMn+ovqJLb1s6Nc9e6B4eWqcFqcxFE3
	 nzGvKNqk9x4xgLBQsuy/SO9UWHTjH6+o31I0iulAvCuG2488tEst6wKipkR+3V5B8d
	 OnHNwP96C59gedS/Blx2GmgnLxglrTWfiUYXUgzp7iI+qF5UxKbmzqDbTiwLVDUnVC
	 peXt6zUMAlKR6qPYlseH5Gp8LTRVXVGjZv50p+AsQ+f/L8xicCtWtgP8hPdeIg06ZJ
	 OGySbmZnVx8vg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B809CC53B50; Sat, 20 Jul 2024 18:30:10 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219010] [REGRESSION][VFIO] kernel 6.9.7 causing qemu crash
 because of "Collect hot-reset devices to local buffer"
Date: Sat, 20 Jul 2024 18:30:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zaltys@natrix.lt
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-219010-28872-F0qTV733NB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219010-28872@https.bugzilla.kernel.org/>
References: <bug-219010-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219010

=C5=BDilvinas =C5=BDaltiena (zaltys@natrix.lt) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #9 from =C5=BDilvinas =C5=BDaltiena (zaltys@natrix.lt) ---
Fixed in 6.9.10. Closing this.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

