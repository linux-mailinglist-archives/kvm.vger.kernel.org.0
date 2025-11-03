Return-Path: <kvm+bounces-61925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BEB4AC2E782
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 00:47:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EF0C189A8ED
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 23:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9008D26158B;
	Mon,  3 Nov 2025 23:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LuvljNUP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38DE2F9D98
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 23:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213667; cv=none; b=k9qbtbVVOPEXhHiZIQ9YgT81BgskGD9GbiKWYNZNjqSnbVNz/AVgH2e7a8sKImh7Tu2Tte2OcfMJ3tltjLuu4O8WhCIJSD/N2V65JXTn3WGYrkowOKcK+73PFfkV55RlRoMHAvM5hvV5Lb6cugFjRa/2sbfQvLBze2zpYPUaE1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213667; c=relaxed/simple;
	bh=xc56y0Shr9uqQbg5GMkYZC2GjyUB11o/ISRm1t7N0rU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=USe8f31/xceJKShNcidE05ZKexFzbDF+7gSQ9EyfVF0WspEH4iLtwMy2+7B6aNnRgEVNtEJyHDHFudFgm6/iWEcNVdvWwskNtKHfuF9D2V5vqSmr2taEPvhfIlI9Sjw7KZpzzr6GuASOY78DGGVecrFUjWaTAW39nQ9+Blm7X/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LuvljNUP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2BA82C113D0
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 23:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762213667;
	bh=xc56y0Shr9uqQbg5GMkYZC2GjyUB11o/ISRm1t7N0rU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LuvljNUPP/SjauO47bSXOdfjnq9tDOidFmUrVuSAHeBWAVe7efxkUyEyfwwrDTgLG
	 nCYCChZ16VDTE42zdYIzHCf5YySsZ8VBuzwi4GPvbqIEgaUTGdx8rW05E0cufEaFvi
	 rrW3Rr/Ks+4fzu3AYtgkMcDmfZAs7gn07wvBQaGIr4iILJ5uhOh6StxpFA9CGeETC4
	 5NWyhMeuUr6VifI2rsTysA3Yc4OQBR5DLTYNi+H6giAx9o0/iE24TmHyvASVTmrsNZ
	 Q3vxJk1zAMrBP/El+h86uXgqk1/5izVSAHNWs/ALWWXs8rHic2vya2TZWH0fVHS0b7
	 szQhTQqnf7DLg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 2570FC53BC5; Mon,  3 Nov 2025 23:47:47 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220740] Host crash when do PF passthrough to KVM guest with
 some devices
Date: Mon, 03 Nov 2025 23:47:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: alex.l.williamson@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-220740-28872-aeAd0AKUgz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220740-28872@https.bugzilla.kernel.org/>
References: <bug-220740-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220740

Alex Williamson (alex.l.williamson@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alex.l.williamson@gmail.com
                   |                            |, ramesh.thomas@intel.com

--- Comment #2 from Alex Williamson (alex.l.williamson@gmail.com) ---
(In reply to Chen, Fan from comment #1)
> I reproduced this issue on SPR, GNR, SRF, CWF.

Were there platforms that did not reproduce?

> If we disable "PCIE Error Enabling" in BIOS, host will not crash.
>=20
> After bisecting, the first bad commit is:
> commit 2b938e3db335e3670475e31a722c2bee34748c5a (HEAD)
...
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -16,6 +16,7 @@
>  #include <linux/io.h>
>  #include <linux/vfio.h>
>  #include <linux/vgaarb.h>
> +#include <linux/io-64-nonatomic-lo-hi.h>
>=20
>  #include "vfio_pci_priv.h"

Theoretically this would only define non-atomic ioread64 and iowrite64 supp=
ort
on a host that doesn't already have native support for these.  Any 64-bit
x86_64 host should already define ioread/write64, so no change in behavior =
is
expected or intended.  Can you provide the kernel .config and compiler
information?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

