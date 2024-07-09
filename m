Return-Path: <kvm+bounces-21202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC13792BBA3
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 15:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC1161C22715
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 13:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 903AA15F3F3;
	Tue,  9 Jul 2024 13:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eIK91qaa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF5015CD58
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 13:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720532683; cv=none; b=WW32sFsjbnyLyZqt/7TQ+QQmbLrNIVr3G1P2rhne/iavQ9KdjpwnliPn0Cf9GWnHKMVLXjiO+MdiGPdMkFY7wWv9TwiWbBdxgSin+W7jC3+uB4WWTRVwMzjL1+Biwsyajca0byaKS5AtdYw94ubPEK9h6RaqYCE2b0USHOyM5Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720532683; c=relaxed/simple;
	bh=zJyC8jjyKh52L2UitwncaBm3/kHKZYf+3tVJpfUc8QU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mpwK61d9QtekOnAvq8VSjrpE1UYO3MWPDx9FXBYANQKm41ojIzOJActhUfhLsQt/iI1I6q3agM0KpFMYvboH+VYzusHaHZVu0JXVtKZNvhcLPEhZXi/4iS0dW2TUT0XwpXoWdkEfXkNZrrH5UMuAKDe4T/rLX8+khZzoIEZDXmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eIK91qaa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 494D2C4AF0D
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 13:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720532683;
	bh=zJyC8jjyKh52L2UitwncaBm3/kHKZYf+3tVJpfUc8QU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=eIK91qaa2Ius1hgytiwj+STceTTHxYyab/JLiIBDuIS7ax6+YFxTUEgYH4ucUiiCx
	 TtljnSAUBR3DpJ+GxLqIbLQ0XUQksne7aLQdTDyOVd30piZb1Kmgz5wXH1ZTzzUezx
	 gE+DHR3hgbUOIAi90xV/IxWNqvaCBQlJELWxVWTeioolul9HIRO6tKp1iJj8eetwHn
	 rrocWFKQc1TRxkr4pPjajFiY5qYxYJSoNAvm5ActHLR4OoW7YZtkFA0eifhktqKCdm
	 rNjzkJGvApEvNjxnuVxADy9mIdfpb8mIwzUb4DIsyYHK0yDZDGgw9drnYdWUateGjV
	 YI8wsBD8rna5w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 43BD9C53B73; Tue,  9 Jul 2024 13:44:43 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219010] [REGRESSION][VFIO] kernel 6.9.7 causing qemu crash
 because of "Collect hot-reset devices to local buffer"
Date: Tue, 09 Jul 2024 13:44:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yi.l.liu@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219010-28872-m9NOJSSMHm@https.bugzilla.kernel.org/>
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

--- Comment #3 from Liu, Yi L (yi.l.liu@intel.com) ---
On 2024/7/7 01:19, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219010
>=20
> --- Comment #1 from =C5=BDilvinas =C5=BDaltiena (zaltys@natrix.lt) ---
> Additional information: passing NVIDIA GPU, Samsung NVMEs works, passing
> Fresco
>   FL1100 based USB card does not work. Fresco card is single VF device, b=
ut
>   like
> that sound card it does not report FLR. Reverting "vfio/pci: Collect
> hot-reset
> devices to local buffer" allows to pass every mentioned device.
>=20

It appears that the count is used without init.. And it does not happen
with other devices as they have FLR, hence does not trigger the hotreset
info path. Please try below patch to see if it works.


 From 93618efe933c4fa5ec453bddacdf1ca2ccbf3751 Mon Sep 17 00:00:00 2001
From: Yi Liu <yi.l.liu@intel.com>
Date: Tue, 9 Jul 2024 06:41:02 -0700
Subject: [PATCH] vfio/pci: Fix a regresssion

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
  drivers/vfio/pci/vfio_pci_core.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c=20
b/drivers/vfio/pci/vfio_pci_core.c
index 59af22f6f826..0a7bfdd08bc7 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1260,7 +1260,7 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
        struct vfio_pci_hot_reset_info hdr;
        struct vfio_pci_fill_info fill =3D {};
        bool slot =3D false;
-       int ret, count;
+       int ret, count =3D 0;

        if (copy_from_user(&hdr, arg, minsz))
                return -EFAULT;

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

