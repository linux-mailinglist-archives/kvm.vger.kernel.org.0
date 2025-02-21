Return-Path: <kvm+bounces-38893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E75E7A4005C
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 21:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B7E67001D4
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 20:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1355525333B;
	Fri, 21 Feb 2025 20:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mAz5az3Y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3718B1FBE9A
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 20:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740168279; cv=none; b=s9BEBAA9hCU5KtrJekswxdsjTHxYvvnVJs97XgGOoPBymceA/JISC6OfXu9lR/XXTerL8BhWxehX9teV3ZS888zXzItdVwSNGUqsHY0TAMd1frzt8JtY1Le8PmCYSJzSotMaB4rV7N6nbcVifqTtJz0ri0bdxEftXyjjMeMw0V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740168279; c=relaxed/simple;
	bh=dPB4dm2KtBVj9HGEeNt695IZApIa33ITE32pJRB/SwM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CRQG+P3ZiLj7WWDQaVfu/HNlWdlFTex6sPVvg6Q0HESXt5DSXFg/Ce6QiQ9I+JJGcOfTn8+NRNEkO3AaeuQZpRpyNR8X+Jl1PX1CzJ1JJAX8BNCIhlWtpmBs2iGz4xAmeQkDwm9TnpfVH/NBsysT2QQtDvwPhlYDCcJuc4d1wbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mAz5az3Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D5D6C4CEEA
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 20:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740168278;
	bh=dPB4dm2KtBVj9HGEeNt695IZApIa33ITE32pJRB/SwM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mAz5az3YEzlsj5ZqN44uCC5XpSgP5ZkW4eCgLUc5Oab20wHSmNw+iJnsBY+noAxVH
	 xscu3M9az5OagH1gAXxGVKZX4GzBrhjQkysNwTxIB0uiYDKL43BcaIt5cYzyLkDmpD
	 xe0zrtb+oYQsDZIq3HsVsz7kgF3Go1fQXxAFIjR4m19jJu/MuWycK5Nyt5/P6YSu4S
	 s7ZKfqh+0jhXZsqkkTCnpZuxYORM3r35walDeVU0KMtTcVrizdsUt1IgNgS43UiiRX
	 sgLy2IcLR8LvFotNhfDX9PSORaBaAstoCfr/uOJJSR/8426WT0k257XGl2WCh/KMOZ
	 GNluKtczbni0A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 93112C41614; Fri, 21 Feb 2025 20:04:38 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Fri, 21 Feb 2025 20:04:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: rangemachine@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219787-28872-8dLkGEJXry@https.bugzilla.kernel.org/>
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

--- Comment #15 from rangemachine@gmail.com ---
(In reply to Sean Christopherson from comment #13)
> Bug reporters, can you test the attached patches?  I have a reproducer in=
 the
> form of a KVM test, but I haven't actually tested a Windows guest.  Assum=
ing
> squashing DEBUGCTL remedies the issue, I'll post patches after I've done a
> bit
> more testing.

Tested, these 2 patches solves the issue.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

