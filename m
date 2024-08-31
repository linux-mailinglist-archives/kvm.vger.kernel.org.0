Return-Path: <kvm+bounces-25583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D95966D30
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E05C1F245CB
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D6CC3C3C;
	Sat, 31 Aug 2024 00:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G9dVCWpF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DFE2F2E
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063015; cv=none; b=PjRA4lKmcPFV/MzPsiJkUZfIdShQGMSwFseg3mZpGqE+baKSt78d54czBnkfEZAFiPJKlGxFXov63vvDzozfha3za0zeD2bAKbeIph9v1xdFwjfeRaXIv7bcAf19Jc3YpSlx5ZcpHOEC6w1h8tRfFsiQ9VcdXGzhjOss9NSqnfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063015; c=relaxed/simple;
	bh=XoD1Lh1gvKXuluxNiLQ8xPkL6X5MtC0oNJ3G6vgcM1A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ao8F0HONAMVzlOkRGFvII6JJ4Mn9VgouVKBC62uHAOLrPnNx7sC7vJbCYbcMqM4fGJringEQxWox1g/veyUlWhPZqbsyQkLvOsa3uikKzVLR9/QJNYOyVcs3zNoLrlfz95Ksu/Y8gTClGxj1bYiWLU6EsKRfLnkjWkexcBY37Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G9dVCWpF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F4FDC4CECB
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725063015;
	bh=XoD1Lh1gvKXuluxNiLQ8xPkL6X5MtC0oNJ3G6vgcM1A=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=G9dVCWpFOXHl1fNOCYZo4GNsoAAGcIt9JcRbUFjiCAmyaxEu06HDRuBJ3EVeAMhB2
	 SEuY7+8V0FXVQMzuQj9Fxl4Ojg3yWOKSrvrrev6lzcQX6ffZ8kRkiHlnTttwGlsucc
	 5Rc/DJ0LQ7ST25nG4iYrpGuUu8Bn3/oYw+4sVcBnd9xs+59BrFnJ/su8wmUBuoWqdq
	 PHAxKLwZPAbdwr0zL8Y8M70D+MkEsZhli53HabIJlva7mGn0smxUe/B8MCZSP6wGDI
	 p9QLbSLWSZ7Ioe3QYlEgfhkM3IA0iSCaJ4D0GJxc1A1SoDrpCoTZ5zQpjUtRL1wI1V
	 6KGurFdt4uZbw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 19310C53BB9; Sat, 31 Aug 2024 00:10:15 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Sat, 31 Aug 2024 00:10:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: blake@volian.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219009-28872-iVhadqJj9y@https.bugzilla.kernel.org/>
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

blake (blake@volian.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |blake@volian.org

--- Comment #13 from blake (blake@volian.org) ---
I recently experienced this. I built a proxmox cluster with 7950x. Every no=
de
that I tested on would hard reset with no logs when a VM was doing nested
virtualization.

Our CI testing uses VMs, and putting the CI in a VM itself makes it pretty =
easy
to reproduce, just takes some time.

Setting kvm_amd.vls=3D0 seems to have resolved the issue, we had zero node =
resets
today and I was trying to force them.

Kernel is Proxmox's 6.8.12-1-pve.

Thanks,
Blake

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

