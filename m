Return-Path: <kvm+bounces-29650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA8009AE906
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 16:37:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 765FD1F23639
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 14:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C0371DD0DF;
	Thu, 24 Oct 2024 14:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H2dPbgE5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A187CF16
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 14:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729780637; cv=none; b=U5yJDEgYoxIJNp3SdWJcAjsPbogtbC//dHDGuSNO2tHHv8wwV9p+JoKywm/jq5lBLZmSpCsjjbvIZizGJReuOsJEDRntlJFGym8Bj50/xDDJnS//xjk3YJsoY3e8yj+M5uwn3Nb1bLXJvKkEdhwe7Wgtt0XwZZsGy7VLgmmaINo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729780637; c=relaxed/simple;
	bh=duM5Xxjm34RD179FN71Hc+NHsR80maFEE2SZPxJ5/DY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lGFRMeH8i3L69NTlmY1t2XODf09vxEi+XEI+NECPTGb3Rss+5XHORXTDEbMy2c45SpeCjgVtK1XtGAoCc4AcCiga0/V/bAZ2QZ+M4fI4X3BuqWz0dbRXqZvrGI1hB24SdNTuQkM7QoCiS7zBE3KkD5WZomEJZ6fmY5nxNWekGME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H2dPbgE5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4AD5FC4CEE9
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 14:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729780637;
	bh=duM5Xxjm34RD179FN71Hc+NHsR80maFEE2SZPxJ5/DY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=H2dPbgE5avOEiy+GbVRC4A17972s/OUBElpPmO6/Liie9UIa5fReJKErIGUsXVYCA
	 +UCC+Bp2VoKI7CwDUtQp3dujmz1fMUtlvgGQ/tqybLdtt3u7S8vLtirLr63KX9aDP3
	 WsJljXGB9gthc1zM5Ac/5VJTG2Hgi1KjPHGw61yj35UAmOjkQWVWzOVCZrmUlSeyLa
	 3az9fo/rSL9Si2+673J38T1aUjO+jQ/yWLW1WR3es4IxxQXcWIko/sf+kuvYmU7hPk
	 /thHSS8XE4uj4nFlFLWVr0WF8hBD4E3Zg8srjsRYXkwwVgtr0FY+cHpeLO6AYZe4d/
	 w8Whgg0r4yawQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 455A7C53BC5; Thu, 24 Oct 2024 14:37:17 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Thu, 24 Oct 2024 14:37:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: simon@wegel.ca
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219009-28872-8vzvR12KR3@https.bugzilla.kernel.org/>
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

Simon Labrecque (simon@wegel.ca) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |simon@wegel.ca

--- Comment #37 from Simon Labrecque (simon@wegel.ca) ---
Wow, this bug sent me to a weird path :P I've been using a Windows VM for t=
he
past 6 months, daily, without problem. Then suddently 2 days ago (didn't up=
date
the kernel or anything else), my PC started randomly rebooting when under l=
oad.
Reading on problems with AMD cpus (and specifically 7950x), I bought a PSU =
and
swapped it. Same problem. Then the cpu (for a 7600), then the motherboard, =
then
the memory... same. I could 100% reproduce the problem by putting the VM un=
der
load within 3 minutes. AFAIK, there was no MCE logged.

I finally stumbled on this thread, set kvm_amd.vls=3D0, and that indeed ful=
ly
fixed the problem.

I don't know how or why hyper-v was suddently enabled in my Windows VM, but
that's obviously what happened. When it did, it triggered this bug quite
violently.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

