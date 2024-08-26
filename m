Return-Path: <kvm+bounces-25018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A61F95E5F1
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 02:08:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D9241C20938
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 00:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C487163C;
	Mon, 26 Aug 2024 00:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ooQTM/eV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C5A173
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 00:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724630913; cv=none; b=VicVeMRtih0nDB6F928NU5POQZ+bc5IdyIf7HbcedOoGD0AALyudh3Gmv5Uq/zYPRw//ZHF8H1Rdpd9AmY11NWqhuldlYd24EREbR0ykdwOfMAyOEmxdNZES8ZNogJzZFGHF6FUY8m3g1vI+NdnvlapFMlsJYWsj6H47w2JqsDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724630913; c=relaxed/simple;
	bh=/ZrB80bRurHxvKfWL4l0Vq0ytP5z5g8cWciN1ECznYM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VeWX+zbdBrfJp2ooojjp/izypJs1RDNZfv1H92EYnrUyeb4lECkwjQviu6nDlgaOAYE/Gt+I6YloUElX2mWCY5MBYcrKmNe7KXmhzBVR0jM8BQV/B+SdMpT18se4LAtkTh+EjOVqPcgOTgqKKv8vHb9XxUA5aLevJIuAv5r2u/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ooQTM/eV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67913C4AF62
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 00:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724630910;
	bh=/ZrB80bRurHxvKfWL4l0Vq0ytP5z5g8cWciN1ECznYM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ooQTM/eVLNUjx/hniA1hH0ERl+FIoy2aGBNyffA3IC1iNADD/LJtVsfDJrnUImWxL
	 TE+POnQBYGf2JyrXpud8D35SLx4nYk3gIuCoTWivFQ7MRVayd6rsD7wR1w7YQ9WQLQ
	 /SEuM5s4iJwpKiDr/NnXpjpNsgRHVrnZ5w4cheXS3gkw6z/Nv4YeZHO+vYV7t1PBHn
	 yfz6yOnaVRO1ys4I75Cn8JXMAbMuWOGbqOVUMqmppe6GE6oolErQ+zJ7Ouv4YNe8sA
	 OQSl5LG2eOBSo3yzAzPCdnnA4JrXw80DhNrUxl+7xvCq5ADiAz74k+PZKUZc/MrakP
	 T1e+L/cQROBUg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 639ACC53B7F; Mon, 26 Aug 2024 00:08:30 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Mon, 26 Aug 2024 00:08:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ozonehelix@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-WmwDANtU5D@https.bugzilla.kernel.org/>
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

--- Comment #10 from Ben Hirlston (ozonehelix@gmail.com) ---
(In reply to Ben Hirlston from comment #9)
> (In reply to h4ck3r from comment #8)
> > (In reply to Ben Hirlston from comment #6)
> > > do we know if Ryzen 9000 has this issue? I know I had this issue on R=
yzen
> > > 5000 but to a lessor extent
> >=20
> > Could you elaborate on what was happening with 5000?
> > (reboots, mce, something other)
>=20
> I would be using my Virtual Machine to Windows Windows 11 and would be do=
ing
> something intensive that was using vls and the machine would reset just l=
ike
> 7000 but it happened way less often

I no longer have that machine anymore so I can't test it anymore but I have
memory of it happening on a bi weekly to monthly occurrence

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

