Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312CD1AD8A1
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 10:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgDQIdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 04:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729784AbgDQIdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 04:33:41 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A565F221F7;
        Fri, 17 Apr 2020 08:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587112420;
        bh=Q/n3YSGkA8IpHQfyYvvTnIFRQtBPZZHJe2vh3gpvOm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwhVYj6S6b6yLsXF42/r7i2CM5O1TzasHexm2EWn8yp2eytX+zta2g+pQJx3b/aXv
         XXhPe1isrnHQ70tYTKnvDUSQc7SCqA/AO63fUmHfhMYJzL4MZnrZZ3dmR8V+0lVMbJ
         8lEL26fonlaxhTUGfn6ZJNosTWtrHpapG8KNgeZI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jPMRP-00473f-2P; Fri, 17 Apr 2020 09:33:39 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Julien Grall <julien@xen.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 5/6] KVM: arm64: vgic-v3: Retire all pending LPIs on vcpu destroy
Date:   Fri, 17 Apr 2020 09:33:18 +0100
Message-Id: <20200417083319.3066217-6-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200417083319.3066217-1-maz@kernel.org>
References: <20200417083319.3066217-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, yuzenghui@huawei.com, eric.auger@redhat.com, Andre.Przywara@arm.com, julien@xen.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

It's likely that the vcpu fails to handle all virtual interrupts if
userspace decides to destroy it, leaving the pending ones stay in the
ap_list. If the un-handled one is a LPI, its vgic_irq structure will
be eventually leaked because of an extra refcount increment in
vgic_queue_irq_unlock().

This was detected by kmemleak on almost every guest destroy, the
backtrace is as follows:

unreferenced object 0xffff80725aed5500 (size 128):
comm "CPU 5/KVM", pid 40711, jiffies 4298024754 (age 166366.512s)
hex dump (first 32 bytes):
00 00 00 00 00 00 00 00 08 01 a9 73 6d 80 ff ff ...........sm...
c8 61 ee a9 00 20 ff ff 28 1e 55 81 6c 80 ff ff .a... ..(.U.l...
backtrace:
[<000000004bcaa122>] kmem_cache_alloc_trace+0x2dc/0x418
[<0000000069c7dabb>] vgic_add_lpi+0x88/0x418
[<00000000bfefd5c5>] vgic_its_cmd_handle_mapi+0x4dc/0x588
[<00000000cf993975>] vgic_its_process_commands.part.5+0x484/0x1198
[<000000004bd3f8e3>] vgic_its_process_commands+0x50/0x80
[<00000000b9a65b2b>] vgic_mmio_write_its_cwriter+0xac/0x108
[<0000000009641ebb>] dispatch_mmio_write+0xd0/0x188
[<000000008f79d288>] __kvm_io_bus_write+0x134/0x240
[<00000000882f39ac>] kvm_io_bus_write+0xe0/0x150
[<0000000078197602>] io_mem_abort+0x484/0x7b8
[<0000000060954e3c>] kvm_handle_guest_abort+0x4cc/0xa58
[<00000000e0d0cd65>] handle_exit+0x24c/0x770
[<00000000b44a7fad>] kvm_arch_vcpu_ioctl_run+0x460/0x1988
[<0000000025fb897c>] kvm_vcpu_ioctl+0x4f8/0xee0
[<000000003271e317>] do_vfs_ioctl+0x160/0xcd8
[<00000000e7f39607>] ksys_ioctl+0x98/0xd8

Fix it by retiring all pending LPIs in the ap_list on the destroy path.

p.s. I can also reproduce it on a normal guest shutdown. It is because
userspace still send LPIs to vcpu (through KVM_SIGNAL_MSI ioctl) while
the guest is being shutdown and unable to handle it. A little strange
though and haven't dig further...

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200414030349.625-2-yuzenghui@huawei.com
---
 virt/kvm/arm/vgic/vgic-init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index a963b9d766b7..53ec9b9d9bc4 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -348,6 +348,12 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
+	/*
+	 * Retire all pending LPIs on this vcpu anyway as we're
+	 * going to destroy it.
+	 */
+	vgic_flush_pending_lpis(vcpu);
+
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
 }
 
-- 
2.26.1

