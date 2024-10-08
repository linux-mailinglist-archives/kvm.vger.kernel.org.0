Return-Path: <kvm+bounces-28148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84845995681
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 20:26:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B0761F23D04
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 18:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFAE2212D0E;
	Tue,  8 Oct 2024 18:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GWJNBO7b"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276FA21265D
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 18:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728411977; cv=none; b=GgRjzfxhT9iG8ATwVILOgbbfy/8r7Lk+e7BIEk2hapKrQ1SayvJ4CprZZhJWEw81TgCRPIDvTeeYSZStZNoEU2TNXGFl07NEqbGvuuNhorYF52zHKI74d6aug0VkhF+auAVcekjHcd2TAQIfo9TGegWUtXWOwEDGsK11Om1+iRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728411977; c=relaxed/simple;
	bh=eB0DyQgeQu6eDVGvg3o4WWKRmZXFTLiUXQDLjTXP/hQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BGxu3OCFQfhQ/K/StayghG+TRXN91pUbVdRDfOSXp+5Y6I4g+6QPQvTX+iXGpT1O2L6JF2eocC2HLW7KrFCSWTsgJAR2Skau1XqU7geYRUD666MaRbqkxC/hpDk5RvBot32w8fUrPjTyMfF4o4W9q4ActI5/ErZ0VIgf+9qc1po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GWJNBO7b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0AA8C4CED4
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 18:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728411976;
	bh=eB0DyQgeQu6eDVGvg3o4WWKRmZXFTLiUXQDLjTXP/hQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GWJNBO7bFsz3Bcnls9YBZr29pv5vA+zD83wfAMcT7ROvjD/Z4jR1Wli+8SqDQn2Oc
	 u/KaNgV5Z5UpRZoqXP8biwHTWeAj2vMs1m4EvfDyEBzRjy9ZPPdsqaD0AOIiqivOa5
	 drClg1WaBHKGh0PCj8Se+XGDC7bfzMybSVUFqZEFutQK1g1yDETPuVc1qAqFLZa37t
	 RkVQwG7I6ZSpYDKqUP8nonGK1PSUIxQcEvPCBn3o6T/CTxDKIWOAtqZGQHFhekdoQ7
	 fcDngYcG7jihZSjAfw2WZ0yJR09zDIxRu/nHzTOsqC0Z4863HMAMFKo30EI6GyXUam
	 44VjNeGrNupLQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9BCD2C53BC1; Tue,  8 Oct 2024 18:26:16 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Tue, 08 Oct 2024 18:26:16 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-e7xKgXfcuO@https.bugzilla.kernel.org/>
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

--- Comment #28 from blake (blake@volian.org) ---
All of ours are running Debian Bookworm, stock kernel
linux-image-6.1.0-26-amd64. And then hosts are 6.8.12-2-pve

On Tue, Oct 8, 2024, at 12:53 PM, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219009
>=20
> --- Comment #27 from =C5=BDilvinas =C5=BDaltiena (zaltys@natrix.lt) ---
> (In reply to blake from comment #13)
> > I recently experienced this. I built a proxmox cluster with 7950x. Every
> > node that I tested on would hard reset with no logs when a VM was doing
> > nested virtualization.
> >=20
> > Our CI testing uses VMs, and putting the CI in a VM itself makes it pre=
tty
> > easy to reproduce, just takes some time.
>=20
> Blake, what OS is used in your VMs ?
>=20
> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are on the CC list for the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

