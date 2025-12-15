Return-Path: <kvm+bounces-65962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F320CBDD83
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 13:40:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AB60D308BD9F
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 12:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5E962288D5;
	Mon, 15 Dec 2025 12:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="kCcfBPL4"
X-Original-To: kvm@vger.kernel.org
Received: from sg-1-104.ptr.blmpb.com (sg-1-104.ptr.blmpb.com [118.26.132.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D393A244186
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 12:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765801860; cv=none; b=jblKUCjCzo1K4AJD7f8fcAuroD6dtHK5yIHjemtn3Ugfp+UAqmOaAEZ5VJAcgyALGh5EJtxo9R4gk43wYFkwHPXb/rEn9aPzbeAzhyJcCul75fIPRvhw25Q1HGEfMcnr14JvB0GGaYAxtUJmxd8IcyikfWuOf5gZh1hUqP+iOzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765801860; c=relaxed/simple;
	bh=CtmSsUdGiDNVvznJ2WsyK1fFQ9J7gt//EqBRl6RaMDI=;
	h=Date:Message-Id:Mime-Version:To:Cc:From:Subject:Content-Type; b=JTZ/L4XFFDt05sZf2DpBjQEYdbkIud9MxSN158+P5Do9C6HBw0tz7wmGtSI9h/Ufjm/d4QROQGYU4VssMv7+i7VUdFGFqYXutuKVZDGwCXvTzE9iFoEgpL0ju2keW8MsN9SIJC6qMs/cre0FY+3KREq5AT5XXtcAbCjIVbU6dvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=kCcfBPL4; arc=none smtp.client-ip=118.26.132.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1765801845; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=EF/jQxSN1ZfIV9LwwDm6HRiygaKbtqG0Gae5olB1e30=;
 b=kCcfBPL444cY439fV/xCKA2bnsMJ4CA7/JZeoMwomQSqZHF8oll7FVKr82x0wtcWOlrvik
 YNdXMOf9U4qAkT/ccOrx/Q1W5dz3lhNGzCqF2rr0ZicoPryLi3K1hZv4J786ITtvjZWf1T
 ngFno0acUUaMSOF4HevFN2jNqWXIbH3oJEBXZIvuKUwiQALprdg1TJCCLNM/mOsugZNyDh
 fD4mk932S0U4mlBYONmGB75TQDvQ5qzDnUZXBzVml1R/tyaPphynjVuacrC4wUfNhglvkG
 YwwTKTmy/aSfeuYD5VKypatrE8Iol6Okij2mhgywGQ+aDt0C7ewp0Y28Ep5PhA==
Content-Transfer-Encoding: 7bit
Date: Mon, 15 Dec 2025 20:30:29 +0800
Message-Id: <20251215123029.2746-1-guojinhui.liam@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Jinhui Guo <guojinhui.liam@bytedance.com>
To: <alex@shazbot.org>
Cc: <guojinhui.liam@bytedance.com>, <kvm@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
From: "Jinhui Guo" <guojinhui.liam@bytedance.com>
Subject: [RESEND PATCH] vfio/pci: Skip hot reset on Link-Down
X-Mailer: git-send-email 2.17.1
X-Lms-Return-Path: <lba+2693fff73+28616b+vger.kernel.org+guojinhui.liam@bytedance.com>
Content-Type: text/plain; charset=UTF-8

On hot-pluggable ports, simultaneous surprise removal of multiple
PCIe endpoints whether by pulling the card, powering it off, or
dropping the link can trigger a system deadlock.

Example: two PCIe endpoints are bound to vfio-pci and opened by
the same process (fdA for device A, fdB for device B).

1. A PCIe-fault brings B's link down, then A's.
2. The PCI core starts removing B:
   - pciehp_unconfigure_device() takes pci_rescan_remove_lock
   - vfio-pci's remove routine waits for fdB to be closed
3. While B is stuck, the core removes A:
   - pciehp_ist() takes the read side of reset_lock A
   - It blocks on pci_rescan_remove_lock already held by B
4. Killing the process closes fdA first (because it was opened first).
   vfio_pci_core_close_device() tries to hot-reset A, so it needs
   the write side of reset_lock A.
5. The write request sleeps until the read lock from step 3 is
   released, but that reader is itself waiting for B's lock
   -> deadlock.

The stuck thread's backtrace is as follows:
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

The deadlock blocks PCI operations (lspci, sysfs removal, unplug, etc.) and
sends system load soaring as PCI-related work stalls, preventing the system
from isolating the fault.

The ctrl->reset_lock was added by commit 5b3f7b7d062b ("PCI: pciehp:
Avoid slot access during reset") to serialize threads that perform or
observe a bus reset, including pciehp_ist() and pciehp_reset_slot().

When a PCIe device is surprise-removed (card pulled or link fault)
and generates a link-down event, pciehp_ist() handles it first; only
later, after the device has already vanished, does vfio_pci_core_disable()
invoke pciehp_reset_slot() - because it must take ctrl->reset_lock.
Thus the hot reset (FLR, slot, or bus) is performed after the device
is gone, which is pointless.

For surprise removal, the device state is set to
pci_channel_io_perm_failure in pciehp_unconfigure_device(), indicating
the device is already gone (disconnected).

pciehp_ist()
  pciehp_handle_presence_or_link_change()
    pciehp_disable_slot()
      remove_board()
        pciehp_unconfigure_device(presence) {
	  if (!presence)
	      pci_walk_bus(parent, pci_dev_set_disconnected, NULL);
	}

Commit 39714fd73c6b ("PCI: Make pci_dev_is_disconnected() helper public for
other drivers") adds pci_dev_is_disconnected() to let drivers check whether
a device is gone.

Fix the deadlock by using pci_dev_is_disconnected() in
vfio_pci_core_disable() to detect a gone PCIe device and skip the hot
reset.

Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
---

Hi, alex

Sorry for the noise.
I've just resent the patch to expand the commit message; no code changes.
I hope the additional context helps the review.

Best Regards,
Jinhui

 drivers/vfio/pci/vfio_pci_core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 3a11e6f450f7..f42051552dd4 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -678,6 +678,16 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 		if (!vdev->reset_works)
 			goto out;
 
+		/*
+		 * Skip hot reset on Link-Down. This avoids the reset_lock
+		 * deadlock in pciehp_reset_slot() when multiple PCIe devices
+		 * go down at the same time.
+		 */
+		if (pci_dev_is_disconnected(pdev)) {
+			vdev->needs_reset = false;
+			goto out;
+		}
+
 		pci_save_state(pdev);
 	}
 
-- 
2.20.1

