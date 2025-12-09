Return-Path: <kvm+bounces-65537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B81D1CAEC2B
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 03:55:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DAD333032A83
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 02:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 616F13009F1;
	Tue,  9 Dec 2025 02:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BH3burtk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7FE2DECA8
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 02:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765248876; cv=none; b=MMAqKGGbF57Jfm/cRnQlzmXVTRtdALgOc1n0eXldWoESsw3/6bW0ZujlIHPdpqsIyrqjvOywNTdxjVHGQ03d2nOp0jvyIFKAqXVHcqvBQZw9Lj/57AOOA4z3i8t6UsdY31YNsdHdtOd/jYsOAqHrh0VKTQr1+OehcljAzzE0IxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765248876; c=relaxed/simple;
	bh=1AbDa6ZV+PEGW0h8zcZZZAy6Swhu54DQi0hOSbIiT48=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B6BpMRWB/Ep+rOaDXp7b0hIGRCLRn2Ldjb2gWsTvCY/2qNky4qkJwfJEc7gUnZ/+xYAOeQDvEThSgselKtJz5z/us+ht1O1i2vRf365MQ7kwGSYBp5ylG5zUbYuh5Ptve5fGi2Woibt51f9SMjuzTm+rnfeJEZ++ufStyEAP5fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BH3burtk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id C96FBC116B1
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 02:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765248875;
	bh=1AbDa6ZV+PEGW0h8zcZZZAy6Swhu54DQi0hOSbIiT48=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BH3burtk1qkwO/Tci1q1FiWu/yVmRQG/2HIztKuBBrq+eI/v+aPDTsYXNFNDx3d+n
	 mmHVXyzflFxeBXGID1PYkjk9cLu2yyG5AVv6eR0Y5l1/DkR1TbjaEAfUd6Y9cxGIJL
	 CrdbXpAi+MqS52tzNany2eF34nj6q3m8i8jFZzt/gM+2JxKa5FjCWncQ60inLjD9Ou
	 wbH60pI44+SCk0sjUdxjg3rpGvRq7N3LU6D+LO05X9+813VW0HJO82dDs0twEpbY1C
	 mMmqx2jObdr5TP9Hs0YYgoe4EsZWpb5CWkrUMo6g8ABjn7l8EOsWxQCRHdKYbFauzA
	 EM7Ntfch7+oCw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C163AC433E1; Tue,  9 Dec 2025 02:54:35 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220740] Host crash when do PF passthrough to KVM guest with
 some devices
Date: Tue, 09 Dec 2025 02:54:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: kevin.tian@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220740-28872-jH0XOJ9a6f@https.bugzilla.kernel.org/>
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

--- Comment #8 from kevin.tian@intel.com ---
> From: bugzilla-daemon@kernel.org <bugzilla-daemon@kernel.org>
> Sent: Wednesday, November 5, 2025 8:03 AM
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D220740
>=20
> --- Comment #5 from Alex Williamson (alex.l.williamson@gmail.com) ---
> I have an X710, but not a system that can reproduce the issue.
>=20
> Also I need to correct my previous statement after untangling the headers.
> This commit did introduce 8-byte access support for archs including x86_64
> where they don't otherwise defined a ioread/write64 support.  This access
> uses
> readq/writeq, where previously we'd use pairs or readl/writel.  The
> expectation
> is that we're more closely matching the access by the guest.
>=20
> I'm curious how we're getting into this code for an X710 though, mine sho=
ws
> BARs as:
>=20
> 03:00.0 Ethernet controller: Intel Corporation Ethernet Controller X710 f=
or
> 10GbE SFP+ (rev 01)
>         Region 0: Memory at 380000000000 (64-bit, prefetchable) [size=3D8=
M]
>         Region 3: Memory at 380001800000 (64-bit, prefetchable) [size=3D3=
2K]
>=20
> Those would typically be mapped directly into the KVM address space and
> not
> fault through QEMU to trigger access through this code.

We have verified this problem caused by 8-byte access to the rom bar:

    Expansion ROM at 93480000 [disabled] [size=3D512K]

Every qword access to that range triggers a dozens of PCI AER related
prints then in total 64K reads from Qemu lead to many many prints then
the host is not responsive.

There is indeed no access to bar0/bar3 in this path.

Disabling "PCIE Error Enabling" in BIOS just removes the prints to hide
the issue.

Updating to latest X710 firmware didn't help and we didn't find an explicit
errata talking about this dword limitation.=20

It is difficult to identify all possible devices suffering from this issue,=
 so
a
safer/simpler way is to universally disable 8-byte access to the rom bar,
e.g. as below:

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c
b/drivers/vfio/pci/nvgrace-gpu/main.c
index e346392b72f6..9b39184f76b7 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -491,7 +491,7 @@ nvgrace_gpu_map_and_read(struct nvgrace_gpu_pci_core_de=
vice
*nvdev,
                ret =3D vfio_pci_core_do_io_rw(&nvdev->core_device, false,
                                             nvdev->resmem.ioaddr,
                                             buf, offset, mem_count,
-                                            0, 0, false);
+                                            0, 0, false, true);
        }

        return ret;
@@ -609,7 +609,7 @@ nvgrace_gpu_map_and_write(struct
nvgrace_gpu_pci_core_device *nvdev,
                ret =3D vfio_pci_core_do_io_rw(&nvdev->core_device, false,
                                             nvdev->resmem.ioaddr,
                                             (char __user *)buf, pos,
mem_count,
-                                            0, 0, true);
+                                            0, 0, true, true);
        }

        return ret;
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c
b/drivers/vfio/pci/vfio_pci_rdwr.c
index 6192788c8ba3..3467151a632d 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -135,7 +135,7 @@ VFIO_IORDWR(64)
 ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool
test_mem,
                               void __iomem *io, char __user *buf,
                               loff_t off, size_t count, size_t x_start,
-                              size_t x_end, bool iswrite)
+                              size_t x_end, bool iswrite, bool allow_qword)
 {
        ssize_t done =3D 0;
        int ret;
@@ -150,7 +150,7 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_dev=
ice
*vdev, bool test_mem,
                else
                        fillable =3D 0;

-               if (fillable >=3D 8 && !(off % 8)) {
+               if (allow_qword && fillable >=3D 8 && !(off % 8)) {
                        ret =3D vfio_pci_iordwr64(vdev, iswrite, test_mem,
                                                io, buf, off, &filled);
                        if (ret)
@@ -234,6 +234,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vd=
ev,
char __user *buf,
        void __iomem *io;
        struct resource *res =3D &vdev->pdev->resource[bar];
        ssize_t done;
+       bool allow_qword =3D true;

        if (pci_resource_start(pdev, bar))
                end =3D pci_resource_len(pdev, bar);
@@ -262,6 +263,15 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *v=
dev,
char __user *buf,
                if (!io)
                        return -ENOMEM;
                x_end =3D end;
+
+               /*
+                * Certain devices (e.g. Intel X710) don't support 8-byte
access
+                * to the ROM bar. Otherwise PCI AER errors might be trigge=
red.
+                *
+                * Disable qword access to the ROM bar universally, which h=
as
been
+                * working reliably for years before 8-byte access is enabl=
ed.
+                */
+               allow_qword =3D false;
        } else {
                int ret =3D vfio_pci_core_setup_barmap(vdev, bar);
                if (ret) {
@@ -278,7 +288,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vd=
ev,
char __user *buf,
        }

        done =3D vfio_pci_core_do_io_rw(vdev, res->flags & IORESOURCE_MEM, =
io,
buf, pos,
-                                     count, x_start, x_end, iswrite);
+                                     count, x_start, x_end, iswrite,
allow_qword);

        if (done >=3D 0)
                *ppos +=3D done;
@@ -352,7 +362,7 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vd=
ev,
char __user *buf,
         * to the memory enable bit in the command register.
         */
        done =3D vfio_pci_core_do_io_rw(vdev, false, iomem, buf, off, count,
-                                     0, 0, iswrite);
+                                     0, 0, iswrite, true);

        vga_put(vdev->pdev, rsrc);

diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2..3a75b76eaed3 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -133,7 +133,7 @@ pci_ers_result_t vfio_pci_core_aer_err_detected(struct
pci_dev *pdev,
 ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool
test_mem,
                               void __iomem *io, char __user *buf,
                               loff_t off, size_t count, size_t x_start,
-                              size_t x_end, bool iswrite);
+                              size_t x_end, bool iswrite, bool allow_qword=
);
 bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
                                         loff_t reg_start, size_t reg_cnt,
                                         loff_t *buf_offset,

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

