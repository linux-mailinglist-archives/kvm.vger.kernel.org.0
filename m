Return-Path: <kvm+bounces-29160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D2389A3A88
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 11:53:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E375A1F29713
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 09:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B5672010E3;
	Fri, 18 Oct 2024 09:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pePoh1IR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8E7201003
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 09:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729245186; cv=none; b=CVvbdSBEtOQVBiY9UjzyLy7Qy4Lw6li/xqLa7m1z/M2gI7FXnp/4NUjKRyJorognoofVPNinHXCbMutU+OCVa4Q+s/C7SofQMFgEWAQZK8IojjkfKubT9pN4AxowoGbsqgxA+q03F0l8e43dF8ZB8GHaYbb2zeFh17OS4mPIO1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729245186; c=relaxed/simple;
	bh=QIUIOigWmV+2NI0w2dBVsWrGcWZhT7qdgMjOM+YKXJU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mfUak88UK/DN/5FBD9cHs6+8mljZyywM0Tn82T0jGhNRsV7irIjwETG/6I7DSa7z6X4EW6maCC5MSFktZHXsiq5szRT2rx1QwWIOQJP+7Xcqo+/s0i+gx3oHmikNuwO96SaTrHAGPMfSoMCGBSE8mbafneZiDMS92Hs9Jkg2euI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pePoh1IR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4098C4CED4
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 09:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729245185;
	bh=QIUIOigWmV+2NI0w2dBVsWrGcWZhT7qdgMjOM+YKXJU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=pePoh1IRFOlZU0C9SyvLVxpMPnhY/hYp+TT9a3ML3/pzFQKbilZPGYamInYjf4/pZ
	 gmRjrOPpMaRo895pdXYw52ZO28mncbH4qLMhoyLeb8LsAu8hIcG26LE3OgVZMtG6/V
	 HnlNmeXywS+zvhLSfMZEaD9W3l8cG2cFbonZJEuiDwIJIvjUsDMaBm/6H+dxYSn0kH
	 sIKv1D8vrwtCXXUzeqQiFGyUw4KwK3JPSIrhNmCFfnt5r3lFiPdurkPyIdijQM/ZP8
	 QbD1N5ornNCzPyVh4Dnu6rDVOuqaMVIjXxH34FicUBTeAW8+MDkDfD1zrqY3ZHFgP1
	 7qeuUy/i61jCQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DDF55C53BBF; Fri, 18 Oct 2024 09:53:05 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Fri, 18 Oct 2024 09:53:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: kernel@isdennu.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219009-28872-zC8K4Dvuzs@https.bugzilla.kernel.org/>
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

isdennu (kernel@isdennu.ru) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kernel@isdennu.ru

--- Comment #34 from isdennu (kernel@isdennu.ru) ---
(In reply to h4ck3r from comment #29)
> (In reply to mlevitsk from comment #26)
> > But the question is - did they use nested virtualization on Linux activ=
ely
> > and with vls enabled?
> >=20
> >=20
> > The use case which causes the reboots as I understand is Hyperv enabled
> > Windows, in which case pretty much the whole Windows is running as a ne=
sted
> > VM, nested to the Hyperv hypervisor.
> >=20
> > Once I get my hands on a client Zen4 machine (I only have Zen2 at home)=
, I
> > will also try to reproduce this but not promises when this will happen.=
=20
> >=20
> > Meanwhile I really hope that someone from AMD can take a look a this, a=
nd
> > either confirm that this is or will be fixed with a microcode patch or
> > confirm that we have to disable vls on the affected CPUs.
> >=20
> > Best regards,
> >        Maxim Levitsky
>=20
> Not really - most of them are microservice type ones.
> That would also mean there is less chance of corruption since they occupi=
ed
> less host memory.
> And windows uses nested virt even if hyperv is not installed somehow.
> (installation does not, but freshly booted guest crashed my node)
>=20
> Im afraid it might be unresolvable issue, even with microcode.
> At least most things point to similar issue as memory leaks on their igpu=
s.

I have a 7900x on which I use igpu and RX7800XT as dgpu (use for AI work) a=
nd
motherboard ASUS ProArt X670E-CREATOR. That being said, I actively use
virtualization.
When disabling VLS and even disabling nested virtualization completely, my =
host
kept rebooting unpredictably. That is, no advice from this thread helped me.
As a result, I disabled igpu in BIOS and enabled nested virtualization and =
VLS.
With this configuration the reboots continued. But after disabling VLS the
reboots disappeared and now the PC works without fail.
I can assume that the problem with VLS and the use of igpu may be somehow
related.

It would be very interesting to know if this problem is present on Ryzen 90=
00.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

