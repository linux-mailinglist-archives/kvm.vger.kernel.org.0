Return-Path: <kvm+bounces-69813-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uL3/FlVdgGlj7AIAu9opvQ
	(envelope-from <kvm+bounces-69813-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 09:16:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CC647C99BB
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 09:16:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E38FA3020D5E
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 08:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99ABC30F927;
	Mon,  2 Feb 2026 08:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MkVyAEO/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1E627B347
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 08:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770019850; cv=none; b=YaJeDTVtzh5CoAQtzXgPJgyQL35jppjFzVksJvWO35eASZKGe0ixCv3W0oCGzJMGpS6DOQM1wehDEUcmjxAMI86A6s1W2BWu4Z2gf5DG6b+SR9Ly3P7NvBVGsPwmWcs4eQTCGkGopl+wAKREnGeKh9sxxsFFIQ1cXwmgaNxV2cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770019850; c=relaxed/simple;
	bh=0zCgjJCVzfIPkkrn9ExHWvZPeM594lE6PyfJF0KlmY4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HzkW6NSC/z7pyiQkLMxXISFlx9Ed3MYrl7FaBc45ALTwpp7PiJNN/e6NbZ+mfVJgy5EtjSqWAHtWh0dtu9rvRdvv5+RZvhZ0p9VmLGe17afrZ0kx23yGj2Gs9zvcQJN1Hd56ygX5kuuw/vSyFOJXA48+mRy9wC/yshhhofUWWPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MkVyAEO/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 757C2C2BC86
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 08:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770019850;
	bh=0zCgjJCVzfIPkkrn9ExHWvZPeM594lE6PyfJF0KlmY4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MkVyAEO/6SG7eDfZNxlMoaQBrdKvexf7L1BUYCz9wN9mTH+TX/9JRCvww7QSH+BN1
	 4iYZ2CtApO00DLcPpFvuTKY7IOwPK5cHzaVEu7FrFge7P3Jj10YuuymsFLlo0Auwv3
	 VlJDQlUGbxs4WnuVmDtyosHSS4fHAICQbfIbrFjuQzsQV6uzQT7kCLksqeMPHoIH8T
	 eFr2n8ncHwr4t0kvXCSEq3jK6ziSV4krGiwk5w9w01TXxbUdfK5dhgeqU/T9sdEc2q
	 N3QSkH06wcdhayGG4biH7yu+jjgmUkDdpft425iqgBCrG+zqrAVawlZJ3GgtvbwWeC
	 KIib/vvBMf/GQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6B1CCC53BC5; Mon,  2 Feb 2026 08:10:50 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 221033] Real time clock does not trigger alarm on QEMU
Date: Mon, 02 Feb 2026 08:10:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: petr.vorel@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-221033-28872-tOu96sugSJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-221033-28872@https.bugzilla.kernel.org/>
References: <bug-221033-28872@https.bugzilla.kernel.org/>
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
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_NEQ_ENVFROM(0.00)[bugzilla-daemon@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	FROM_NO_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TAGGED_FROM(0.00)[bounces-69813-lists,kvm=lfdr.de];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+]
X-Rspamd-Queue-Id: CC647C99BB
X-Rspamd-Action: no action

https://bugzilla.kernel.org/show_bug.cgi?id=3D221033

Petr Vorel (petr.vorel@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |petr.vorel@gmail.com

--- Comment #1 from Petr Vorel (petr.vorel@gmail.com) ---
Also, the problem is only when running VM on UEFI (legacy BIOS works).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

