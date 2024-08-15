Return-Path: <kvm+bounces-24293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A70F1953762
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BB3E1F214F5
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8073A1A01D4;
	Thu, 15 Aug 2024 15:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AuMWz4sS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78E31AED40
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723736107; cv=none; b=TTD02ZXUeWfNNsG2MZr0FhWmuz2FDynO57lWqzmJghuKrgQhzEoJCI+OYGGxb4RuglbGxFw1OI3wYF7Lr4yVdRi/WNWLtkTUlZ1ncF8XpxRKNQ5sYpC5iT950YhIuUOynYGK+/TSqjz6ZZRpvCZmJYwZCpZunv/b3O5PXJGv3jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723736107; c=relaxed/simple;
	bh=x8BoJ7d52qZ7IyL6xJcyH8DZnmk2NLjtc3UaRDkzoyg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BYdmfkGA/ehpCkXDd23pbf1nScVSilzoPKZKtNhiA9tYtOwJ3rjDHla5shEsaYQszF4pmrzt7Hpbn6ytkgFx/i5/T+C5WrBjsb0P0Yy2v57C4tkoDq2r2qCU23zaxby4rAVf6J+5U2/mxQRSd7luZmkueIkKUCKEkxbZj99oQQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AuMWz4sS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3984BC4AF0F
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723736107;
	bh=x8BoJ7d52qZ7IyL6xJcyH8DZnmk2NLjtc3UaRDkzoyg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AuMWz4sSgsYMOICb2dMh9SAWFakZt2aoYiV2MH2wC11aC0JPAjUOZDRrrUK3Lu3ez
	 WmHyP2YI3Im4JBHbCEF0Fg1i9c2fry5IzoVvZ2DOVHtaXktijYsASqjoTkfKm2lAqJ
	 n57twuCgZ4Ha4qupDJsTnxFA0VanIlvWHrMhinlPTtQhLWXtjN8f37sFB/tnCdnesR
	 KGW74T9EuoW/Wh/AKrAEpfCTVKOleB9RmylPxhSLD28dd8reQ3lFrdCidR4KsrxRXb
	 /6Iyc1S3zP7/6d3ksd2ji1PZCIIAs1ZvsudIxjMwQghpOSsvsBMUSCvn/cZDFXc1tP
	 rybu18CPw8eVg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 2A1C7C53BB8; Thu, 15 Aug 2024 15:35:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219161] VM with virtio-net doesn't receive large UDP packets
 (e.g 65507 bytes) from host
Date: Thu, 15 Aug 2024 15:35:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219161-28872-Huf31vW0Mb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219161-28872@https.bugzilla.kernel.org/>
References: <bug-219161-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219161

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
On Thu, Aug 15, 2024, bugzilla-daemon@kernel.org wrote:
> Large UDP packets (e.g 65507 bytes) are not received in VM using virtio-n=
et
> when sent from host to VM, while smaller packets are received successfull=
y.=20
>=20
> The issue occurs with or without vhost enabled, and can be reproduce with
> 6.5.0-rc5+

Is this 100% reproducible?  And did it first show up in 6.5-rc5, i.e. does
everything work as expected in 6.5-rc4?  If so, bisecting will likely get y=
ou a
fast root cause and fix, unless someone happens to know a likely suspect.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

