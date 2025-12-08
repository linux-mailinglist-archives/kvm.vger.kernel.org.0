Return-Path: <kvm+bounces-65482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A68CAC65C
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 08:46:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1DF273014136
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 07:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C6B2D29C7;
	Mon,  8 Dec 2025 07:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="atyU62TD"
X-Original-To: kvm@vger.kernel.org
Received: from sg-1-103.ptr.blmpb.com (sg-1-103.ptr.blmpb.com [118.26.132.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A092BD58A
	for <kvm@vger.kernel.org>; Mon,  8 Dec 2025 07:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765179987; cv=none; b=CNdgjZ9OVYguc48Yu/p4GBqMJaNNQsL2mrH/LNJRE2uGRfMN69yKknter24oJMfY40bO3mEaVJBCFNvaXhuOIRczG/BTZL2RrQkc3CekH11DZEufrd7luJDaJz2F5erPyT6CAx7iDofOjOFKpgBEfAE8qjlqMAp3T84+/US0Yd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765179987; c=relaxed/simple;
	bh=k8wAGr/eNJUG2YjhwuYYxGEuRRPyTRkHf6v3Mo7iGwg=;
	h=Mime-Version:To:Date:Cc:Subject:Message-Id:Content-Type:From; b=W8Z0onmHpzhulvHSV3xAavOSy/Dgg+ZNXSx2kkR2PMuADnU1ZJBJYFs5GyNfSa+HSuVIL3mXDMet0czbegJzmS5Dtt5NFelpqdruq3htAqWR2nNwjW17QRhfjdeQohlNNjrCKF7dVcGZTb4i17aGKsnbvy5guaxwtBEyw8cZYRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=atyU62TD; arc=none smtp.client-ip=118.26.132.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1765179966; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=3KMt0BlvaTEJCBNQKfyKxcLJr7uP95ixoR2necFSrj4=;
 b=atyU62TDkb4DuDQcuFDve+3/CA4QpaNZQHrqWNEnI9OZ0GwlEfhyAIcGoiQfGQLnJ+B8M0
 2n5APJO0QFRGDOoPmHl+iWxulAl3o51tbgqVINnicx+EhBM/IxYS5pbTfHYNwtySdwSEdt
 H0g3x0ElF7n3ax806QldaE+mnPEf1c5+4QXvlB38sCPKXR5jtF8GGW9TUxPi3nV/wlaUIK
 mWPXYOi42uUGrJj9Z7VbvqV220Gc++L6b6RoDPthjSe4WfcWqEo1HHW9P/D9oOLAE8MDap
 jRa5QRV5i+CqUwBW5X/Y+7b9RDzhjlTACpqiznvJDLUadA+g8DZRJQaGHSFVKg==
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Jinhui Guo <guojinhui.liam@bytedance.com>
To: <alex@shazbot.org>
Date: Mon,  8 Dec 2025 15:44:59 +0800
Cc: <guojinhui.liam@bytedance.com>, <kvm@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
X-Mailer: git-send-email 2.17.1
X-Lms-Return-Path: <lba+26936823c+9805ab+vger.kernel.org+guojinhui.liam@bytedance.com>
Subject: [PATCH] vfio/pci: Skip hot reset on Link-Down
Message-Id: <20251208074459.1297-1-guojinhui.liam@bytedance.com>
Content-Type: text/plain; charset=UTF-8
From: "Jinhui Guo" <guojinhui.liam@bytedance.com>
Content-Transfer-Encoding: quoted-printable

On hot-pluggable ports, simultaneous surprise removal of multiple
PCIe endpoints whether by pulling the card, powering it off, or
dropping the link can trigger a system deadlock.

Example: two PCIe endpoints are bound to vfio-pci and opened by
the same process (fdA for device A, fdB for device B).

1. A PCIe-fault brings B=E2=80=99s link down, then A=E2=80=99s.
2. The PCI core starts removing B:
   - pciehp_unconfigure_device() takes pci_rescan_remove_lock
   - vfio-pci=E2=80=99s remove routine waits for fdB to be closed
3. While B is stuck, the core removes A:
   - pciehp_ist() takes the read side of reset_lock A
   - It blocks on pci_rescan_remove_lock already held by B
4. Killing the process closes fdA first.
   vfio_pci_core_close_device() tries to hot-reset A, so it needs
   the write side of reset_lock A.
5. The write request sleeps until the read lock from step 3 is
   released, but that reader is itself waiting for B=E2=80=99s lock
   -> deadlock.

The stuck thread=E2=80=99s backtrace is as follows:
  /proc/1909/stack
    [<0>] vfio_unregister_group_dev+0x99/0xf0 [vfio]
    [<0>] vfio_pci_core_unregister_device+0x19/0xb0 [vfio_pci_core]
    [<0>] vfio_pci_remove+0x15/0x20 [vfio_pci]
    [<0>] pci_device_remove+0x3e/0xb0
    [<0>] device_release_driver_internal+0x19b/0x200
    [<0>] pci_stop_bus_device+0x6d/0x90
    [<0>] pci_stop_and_remove_bus_device+0xe/0x20
    [<0>] pciehp_unconfigure_device+0x8c/0x150
    [<0>] pciehp_disable_slot+0x68/0x140
    [<0>] pciehp_handle_presence_or_link_change+0x246/0x4c0
    [<0>] pciehp_ist+0x244/0x280
    [<0>] irq_thread_fn+0x1f/0x60
    [<0>] irq_thread+0x1ac/0x290
    [<0>] kthread+0xfa/0x240
    [<0>] ret_from_fork+0x209/0x260
    [<0>] ret_from_fork_asm+0x1a/0x30
  /proc/1910/stack
    [<0>] pciehp_unconfigure_device+0x43/0x150
    [<0>] pciehp_disable_slot+0x68/0x140
    [<0>] pciehp_handle_presence_or_link_change+0x246/0x4c0
    [<0>] pciehp_ist+0x244/0x280
    [<0>] irq_thread_fn+0x1f/0x60
    [<0>] irq_thread+0x1ac/0x290
    [<0>] kthread+0xfa/0x240
    [<0>] ret_from_fork+0x209/0x260
    [<0>] ret_from_fork_asm+0x1a/0x30
  /proc/6765/stack
    [<0>] pciehp_reset_slot+0x2c/0x70
    [<0>] pci_reset_hotplug_slot+0x3e/0x60
    [<0>] pci_reset_bus_function+0xcd/0x180
    [<0>] cxl_reset_bus_function+0xc8/0x110
    [<0>] __pci_reset_function_locked+0x4f/0xd0
    [<0>] vfio_pci_core_disable+0x381/0x400 [vfio_pci_core]
    [<0>] vfio_pci_core_close_device+0x63/0xd0 [vfio_pci_core]
    [<0>] vfio_df_close+0x48/0x80 [vfio]
    [<0>] vfio_df_group_close+0x32/0x70 [vfio]
    [<0>] vfio_device_fops_release+0x1d/0x40 [vfio]
    [<0>] __fput+0xe6/0x2b0
    [<0>] task_work_run+0x58/0x90
    [<0>] do_exit+0x29b/0xa80
    [<0>] do_group_exit+0x2c/0x80
    [<0>] get_signal+0x8f9/0x900
    [<0>] arch_do_signal_or_restart+0x29/0x210
    [<0>] exit_to_user_mode_loop+0x8e/0x4f0
    [<0>] do_syscall_64+0x262/0x630
    [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

Since the device is already disconnected, a hot-reset serves no
purpose and risks generating additional PCIe link errors during
the unplug sequence. Fix the issue by skipping hot-reset on Link-Down.

Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_c=
ore.c
index 3a11e6f450f7..f42051552dd4 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -678,6 +678,16 @@ void vfio_pci_core_disable(struct vfio_pci_core_device=
 *vdev)
 		if (!vdev->reset_works)
 			goto out;
=20
+		/*
+		 * Skip hot reset on Link-Down. This avoids the reset_lock
+		 * deadlock in pciehp_reset_slot() when multiple PCIe devices
+		 * go down at the same time.
+		 */
+		if (pci_dev_is_disconnected(pdev)) {
+			vdev->needs_reset =3D false;
+			goto out;
+		}
+
 		pci_save_state(pdev);
 	}
=20
--=20
2.20.1

