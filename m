Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A14E5E9466
	for <lists+kvm@lfdr.de>; Sun, 25 Sep 2022 18:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbiIYQdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Sep 2022 12:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbiIYQdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Sep 2022 12:33:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C500B2A408;
        Sun, 25 Sep 2022 09:33:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58110B80E6D;
        Sun, 25 Sep 2022 16:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196BCC433C1;
        Sun, 25 Sep 2022 16:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664123613;
        bh=gEVSZo6IZOnVd4BVQuHJHN2F00a6Y7EMFpgV8m6o8aI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIdEn7WYr3y/rpGD9loAckzLSySmgfgp9dyLicUsMfjjwdn40cLuN6zLLj/LOV9Nt
         w7+0SOOs6WSK8DMfhBCdUEZxebtKCMKrVB5goKF1Kb8XEiPr+NwjkgijP9GjQF3l7C
         WyHw1FOIynVG+LrVeAgZu8sC73ZZ+13s/gGI0an6PJKx2ACr7p9QeLDjlO2adlyJQE
         OZ9DMtTFSyq7GsfuNfX1jtojKvTksuDbkOx0AKUxBaE4u9RhaEjyaNrF0KVYtL/Hnb
         4tk8/VMxL0skJxsU6cEywngiUcasms2wim1spP3albK3bob826eHX0WIcy1uGM9LNO
         L4aeTag7IZXcw==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v3 2/3] RISC-V: KVM: Use generic guest entry infrastructure
Date:   Mon, 26 Sep 2022 00:23:59 +0800
Message-Id: <20220925162400.1606-3-jszhang@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220925162400.1606-1-jszhang@kernel.org>
References: <20220925162400.1606-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use generic guest entry infrastructure to properly handle
TIF_NOTIFY_RESUME.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/kvm/Kconfig |  1 +
 arch/riscv/kvm/vcpu.c  | 18 ++++++------------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index f5a342fa1b1d..f36a737d5f96 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -24,6 +24,7 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select KVM_MMIO
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
+	select KVM_XFER_TO_GUEST_WORK
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select HAVE_KVM_EVENTFD
 	select SRCU
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 3da459fedc28..e3e6b8608288 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/entry-kvm.h>
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kdebug.h>
@@ -959,7 +960,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	while (ret > 0) {
 		/* Check conditions before entering the guest */
-		cond_resched();
+		ret = xfer_to_guest_mode_handle_work(vcpu);
+		if (!ret)
+			ret = 1;
 
 		kvm_riscv_gstage_vmid_update(vcpu);
 
@@ -967,16 +970,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		local_irq_disable();
 
-		/*
-		 * Exit if we have a signal pending so that we can deliver
-		 * the signal to user space.
-		 */
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			run->exit_reason = KVM_EXIT_INTR;
-			++vcpu->stat.signal_exits;
-		}
-
 		/*
 		 * Ensure we set mode to IN_GUEST_MODE after we disable
 		 * interrupts and before the final VCPU requests check.
@@ -999,7 +992,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		if (ret <= 0 ||
 		    kvm_riscv_gstage_vmid_ver_changed(&vcpu->kvm->arch.vmid) ||
-		    kvm_request_pending(vcpu)) {
+		    kvm_request_pending(vcpu) ||
+		    xfer_to_guest_mode_work_pending()) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			local_irq_enable();
 			kvm_vcpu_srcu_read_lock(vcpu);
-- 
2.34.1

