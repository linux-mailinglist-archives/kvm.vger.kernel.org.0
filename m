Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DAD5A850E
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 20:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbiHaSJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 14:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbiHaSIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 14:08:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE01EE68A4;
        Wed, 31 Aug 2022 11:08:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38E7DB82221;
        Wed, 31 Aug 2022 18:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6F7C433D6;
        Wed, 31 Aug 2022 18:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661969321;
        bh=gEVSZo6IZOnVd4BVQuHJHN2F00a6Y7EMFpgV8m6o8aI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEyi+M9675/fqQ6aKfd9KGILK7DLDHCOgs9bTXSikr3xdjgLsrV5fGBAvEZgvVW3S
         VlOQL2ce8OkX6h04S0yF7a8Ca/yw4bnv6RRQbc1qr0lB4SmNGmKBB8Lpf663SMZSMT
         dSaj/d/XuWy9RfQAC5vhG3rQ1B9AeYKvQTHDBKVomodgjc+KGG6eaaXkkrsVYjuFxF
         tUl8ECG68p+LifunrHPRwB7djV9kHCgtm1fId/qgAe89+d1Bn/8crYTOu3c//e0Q36
         8ocBeeB453p3xTGU9VkyE5TLW8YOIFERaAJ2rSrbUjTWkJr1JbjM0ET8x8aPIe0x7m
         An5qEgUXOjrvg==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v2 2/5] RISC-V: KVM: Use generic guest entry infrastructure
Date:   Thu,  1 Sep 2022 01:59:17 +0800
Message-Id: <20220831175920.2806-3-jszhang@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220831175920.2806-1-jszhang@kernel.org>
References: <20220831175920.2806-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

