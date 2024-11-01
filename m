Return-Path: <kvm+bounces-30308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8370E9B92FF
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 15:21:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A2801F230F4
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 14:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 549721A4E77;
	Fri,  1 Nov 2024 14:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o+jBa0oO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA5D1714D3
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 14:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730470877; cv=none; b=pI64jfjxGaTqL681MJGGX0ZMCldurFyyfP1CItYIRhGcmuwTXkoSCUuD3PhrIA8Og5bjoRfmxq2lxwXRHW1y4bguZBcA96qUoo0+VDuL5Bx3Oryjy8XUDrrLV6Fx84BjFiSglCBAUepss+yLD5tqOohJq5+1zE3AM55SUawAfLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730470877; c=relaxed/simple;
	bh=Ismwy4eMXgnstyX+CAkiMkeWu/6Qc/74qo1v3Ej5S8U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nNUW5ick4A5Bjy3JUYOnlWaL87mf5eVI1W39slYoks41KOGQ3iLAF+VAPFPleH+opf75aIUhn9s92qa1a6aPnixJY96+v3e8Ypp/AKoK6cvkGJgr9Q5Sgla6N9MoyKZWBPfS5+EbADUpEVEw4iAUFjTY0n87pI4HW754IplrF1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o+jBa0oO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06F2CC4CED6
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 14:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730470877;
	bh=Ismwy4eMXgnstyX+CAkiMkeWu/6Qc/74qo1v3Ej5S8U=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=o+jBa0oOpg2ydX8U/OcX/3wiUCbybL1fAvOkDvXUlGktqhQ0fNlFfVPJia7+GhU6M
	 Zm6QfJ3/K8F1lNofYaR4e/bm2Prlh9c60RIqF1IABs76kH9quVYRvew35k2eT5vjbe
	 1ONd7oIHy7ljdkGja7HkbpTK96n/4P0gR9m36w2wqm+FMPdsGTno0Uvqjm+6ZM1A30
	 mbuVl2w+sR3nkwsmvWqTGC3glrpb0Y1VN5XItxtvh8+40KwjN6l3uagfftw8TZFyS2
	 CQbKmkMKDr3xYL9QhN+5T63DxcrxdVbr8d8cQii/bwSYDgMDbtgYclEplbIW1FvJ0L
	 ljg0PE5KWi4lA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id EAD51C53BC9; Fri,  1 Nov 2024 14:21:16 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219112] Machine will not wake from suspend if KVM VM is running
Date: Fri, 01 Nov 2024 14:21:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: nielsenb@jetfuse.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219112-28872-LvqDNMfDjn@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219112-28872@https.bugzilla.kernel.org/>
References: <bug-219112-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219112

Brandon Nielsen (nielsenb@jetfuse.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nielsenb@jetfuse.net

--- Comment #3 from Brandon Nielsen (nielsenb@jetfuse.net) ---
I have verified this on my systems as well. One with an AMD 5800x3D, another
with an Intel i7-8550U. Both have virtualization support enabled in their
respective BIOSes. Usermode VMs used on both machines. Kernel 6.11.5 curren=
tly,
but I haven't been using VMs frequently lately so I don't know when this
behavior started.

I think suspend is being entered properly "kernel: PM: suspend entry (deep)=
" is
seen in the journal, and I think exiting suspend at least starts "kernel: P=
M:
suspend exit" is seen in the journal along with a bunch of other resuming s=
tuff
(network interfaces being brought up, clocks being synchronized, etc.).

Unfortunately the displays never wake up and the machine never becomes usab=
le.

I even see my power button press being logged when I eventually need to hard
kill the machine so I can reboot.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

