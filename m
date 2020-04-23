Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D811B5FA0
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgDWPki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:40:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729312AbgDWPkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 11:40:37 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B283D2166E;
        Thu, 23 Apr 2020 15:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587656436;
        bh=n+o2mqQRZN2hZz3P/W26d4psiY47gyRfHELtjEZmnW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qx9rsDifcJ3+Njhk6JU+Pb2nzh/0EoTXPz58KxuZqaD2uSItsJerIqWPKfGNybjlf
         w+UHQ+7zEmbbOuCNmcsIlY0o/dCZJwuUUU2JUGq/cQYPIe82J0Kr1AKIw1koYsd4Tf
         5Fx/xMDflxU6h3CzdGZLbMHWJUIf5iMRBG58Cpn8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRdxr-005oPM-3d; Thu, 23 Apr 2020 16:40:35 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Julien Grall <julien@xen.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 7/8] KVM: arm64: vgic-v3: Retire all pending LPIs on vcpu destroy
Date:   Thu, 23 Apr 2020 16:40:08 +0100
Message-Id: <20200423154009.4113562-8-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200423154009.4113562-1-maz@kernel.org>
References: <20200423154009.4113562-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, andre.przywara@arm.com, christoffer.dall@arm.com, julien@xen.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
[maz: moved the distributor deallocation down to avoid an UAF splat]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200414030349.625-2-yuzenghui@huawei.com
---
 virt/kvm/arm/vgic/vgic-init.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index a963b9d766b73..30dbec9fe0b4a 100644
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
 
@@ -359,10 +365,10 @@ static void __kvm_vgic_destroy(struct kvm *kvm)
 
 	vgic_debug_destroy(kvm);
 
-	kvm_vgic_dist_destroy(kvm);
-
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_destroy(vcpu);
+
+	kvm_vgic_dist_destroy(kvm);
 }
 
 void kvm_vgic_destroy(struct kvm *kvm)
-- 
2.26.2

