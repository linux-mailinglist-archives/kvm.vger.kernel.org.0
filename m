Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7ED119431C
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 16:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgCZPZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 11:25:30 -0400
Received: from foss.arm.com ([217.140.110.172]:33946 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728496AbgCZPZa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 11:25:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB0CD1045;
        Thu, 26 Mar 2020 08:25:29 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D295C3F71E;
        Thu, 26 Mar 2020 08:25:28 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH v3 kvmtool 31/32] vfio: Trap MMIO access to BAR addresses which aren't page aligned
Date:   Thu, 26 Mar 2020 15:24:37 +0000
Message-Id: <20200326152438.6218-32-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326152438.6218-1-alexandru.elisei@arm.com>
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_SET_USER_MEMORY_REGION will fail if the guest physical address is
not aligned to the page size. However, it is legal for a guest to
program an address which isn't aligned to the page size. Trap and
emulate MMIO accesses to the region when that happens.

Without this patch, when assigning a Seagate Barracude hard drive to a
VM I was seeing these errors:

[    0.286029] pci 0000:00:00.0: BAR 0: assigned [mem 0x41004600-0x4100467f]
  Error: 0000:01:00.0: failed to register region with KVM
  Error: [1095:3132] Error activating emulation for BAR 0
[..]
[   10.561794] irq 13: nobody cared (try booting with the "irqpoll" option)
[   10.563122] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.0-seattle-00009-g909b20467ed1 #133
[   10.563124] Hardware name: linux,dummy-virt (DT)
[   10.563126] Call trace:
[   10.563134]  dump_backtrace+0x0/0x140
[   10.563137]  show_stack+0x14/0x20
[   10.563141]  dump_stack+0xbc/0x100
[   10.563146]  __report_bad_irq+0x48/0xd4
[   10.563148]  note_interrupt+0x288/0x378
[   10.563151]  handle_irq_event_percpu+0x80/0x88
[   10.563153]  handle_irq_event+0x44/0xc8
[   10.563155]  handle_fasteoi_irq+0xb4/0x160
[   10.563157]  generic_handle_irq+0x24/0x38
[   10.563159]  __handle_domain_irq+0x60/0xb8
[   10.563162]  gic_handle_irq+0x50/0xa0
[   10.563164]  el1_irq+0xb8/0x180
[   10.563166]  arch_cpu_idle+0x10/0x18
[   10.563170]  do_idle+0x204/0x290
[   10.563172]  cpu_startup_entry+0x20/0x40
[   10.563175]  rest_init+0xd4/0xe0
[   10.563180]  arch_call_rest_init+0xc/0x14
[   10.563182]  start_kernel+0x420/0x44c
[   10.563183] handlers:
[   10.563650] [<000000001e474803>] sil24_interrupt
[   10.564559] Disabling IRQ #13
[..]
[   11.832916] ata1: spurious interrupt (slot_stat 0x0 active_tag -84148995 sactive 0x0)
[   12.045444] ata_ratelimit: 1 callbacks suppressed

With this patch, I don't see the errors and the device works as
expected.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 vfio/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/vfio/core.c b/vfio/core.c
index bad3c7c8cd26..0b45e78b40b4 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -226,6 +226,15 @@ int vfio_map_region(struct kvm *kvm, struct vfio_device *vdev,
 	if (!(region->info.flags & VFIO_REGION_INFO_FLAG_MMAP))
 		return vfio_setup_trap_region(kvm, vdev, region);
 
+	/*
+	 * KVM_SET_USER_MEMORY_REGION will fail because the guest physical
+	 * address isn't page aligned, let's emulate the region ourselves.
+	 */
+	if (region->guest_phys_addr & (PAGE_SIZE - 1))
+		return kvm__register_mmio(kvm, region->guest_phys_addr,
+					  region->info.size, false,
+					  vfio_mmio_access, region);
+
 	if (region->info.flags & VFIO_REGION_INFO_FLAG_READ)
 		prot |= PROT_READ;
 	if (region->info.flags & VFIO_REGION_INFO_FLAG_WRITE)
-- 
2.20.1

