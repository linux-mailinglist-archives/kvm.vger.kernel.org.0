Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908E232744D
	for <lists+kvm@lfdr.de>; Sun, 28 Feb 2021 21:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhB1UEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Feb 2021 15:04:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230178AbhB1UEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Feb 2021 15:04:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 02F7964EB3
        for <kvm@vger.kernel.org>; Sun, 28 Feb 2021 20:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614542654;
        bh=LS9oDM+62wu8YifgpqEj+5LP/FNY97zdhZWenj0UYD0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=YwnkQ7+vlzGJEjoi5zyqwIPG453+lvIwNz0BVPsMucpWlJJZ3TxveQ+4Bf69/viUn
         HmlG9T2YJ2rwajMK1e39XqecKGeQUpSUaa1Ww5kIXtG1B+e/wNZcOQ7B8yT3HHs83H
         c6FeNRJzJLHksNJ1ahi3me663L0+5Mhw+DIUooPvXMDv6Q6+v+ecxC6LiJ5ErRFUMV
         gbbXVHK18wZ1Xh7EVzG5O9vO0gEwpFrletGNujW5dCzngwU1GG0OGwPWDwezHzBBTn
         62M18uPXacIDpY9zTWTYnXcxGWgmJhNwjSMSIw2xym/JG/HNoDZQMzoozIAYXHd3Vu
         +TecEZl//wnXw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id F3F1665359; Sun, 28 Feb 2021 20:04:13 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Sun, 28 Feb 2021 20:04:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: pmenzel+bugzilla.kernel.org@molgen.mpg.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201753-28872-cKEjkvjTn4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201753-28872@https.bugzilla.kernel.org/>
References: <bug-201753-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D201753

--- Comment #18 from Paul Menzel (pmenzel+bugzilla.kernel.org@molgen.mpg.de=
) ---
Even with ten tries in the loop, it still fails with the AMD Ryzen 3 2200G =
with
Radeon Vega Graphics (family: 0x17, model: 0x11, stepping: 0x0):

    [    0.401152] pci 0000:00:00.2: AMD-Vi: Unable to read/write to IOMMU =
perf
counter. (retry =3D 0)

```
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 9126efcbaf2c7..70c00ee5ff354 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1746,7 +1746,7 @@ static void __init init_iommu_perf_ctr(struct amd_iom=
mu
*iommu)

        /* Check if the performance counters can be written to */
        val =3D 0xabcd;
-       for (retry =3D 5; retry; retry--) {
+       for (retry =3D 10; retry; retry--) {
                if (iommu_pc_get_set_reg(iommu, 0, 0, 0, &val, true) ||
                    iommu_pc_get_set_reg(iommu, 0, 0, 0, &val2, false) ||
                    val2)
@@ -1764,7 +1764,7 @@ static void __init init_iommu_perf_ctr(struct amd_iom=
mu
*iommu)
        if (val !=3D val2)
                goto pc_false;

-       pci_info(pdev, "IOMMU performance counters supported\n");
+       pci_info(pdev, "IOMMU performance counters supported (retry =3D %i)=
\n",
retry);

        val =3D readl(iommu->mmio_base + MMIO_CNTR_CONF_OFFSET);
        iommu->max_banks =3D (u8) ((val >> 12) & 0x3f);
@@ -1773,7 +1773,7 @@ static void __init init_iommu_perf_ctr(struct amd_iom=
mu
*iommu)
        return;

 pc_false:
-       pci_err(pdev, "Unable to read/write to IOMMU perf counter.\n");
+       pci_err(pdev, "Unable to read/write to IOMMU perf counter. (retry =
=3D
%i)\n", retry);
        amd_iommu_pc_present =3D false;
        return;
 }
```

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
