Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9347A6B77F7
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 13:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCMMtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 08:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjCMMs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 08:48:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C0B2CFF4
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 05:48:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9587E611C2
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 12:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3AAC433A1;
        Mon, 13 Mar 2023 12:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678711735;
        bh=BUC9hAfA1qOocmMfiDvROwAZWZgEvI6pNFbD7VUpZy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEB/g/JVom1Tut5XXH7LLVFhEkidDpVgQ1yX9ot99FU8qj7kwTjogVQC7AsemFTkd
         +r6qIqLmbq3ScDeC28Fj5ZqBM1HwIKtWDbwxu4nqPI8FiF39guGzD0GGYHtP62GcvD
         OreKM/iLAaMZmxTbsannI2x5Bwkcf2WsbY+l6u/e+j9SaWF8Q7zMjLLH+sMFJFbZnn
         QUYtgxgHmDhuv6oZdaIvDCBJs87jdKdKyK8+WDXdBDnDr0KdOdkHolibJz/wF6tPZv
         +Ja4Tj9JHxCEZ8jxkZ/tHtTemd3w/OBT1HIEukRUkozlzFxZU0jfCIupVDTbGPmCjE
         wTsrx+3eq92Hw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pbhbh-00HEdE-7W;
        Mon, 13 Mar 2023 12:48:53 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: [PATCH v2 07/19] KVM: arm64: Expose {un,}lock_all_vcpus() to the reset of KVM
Date:   Mon, 13 Mar 2023 12:48:25 +0000
Message-Id: <20230313124837.2264882-8-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313124837.2264882-1-maz@kernel.org>
References: <20230313124837.2264882-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Being able to lock/unlock all vcpus in one go is a feature that
only the vgic has enjoyed so far. Let's be brave and expose it
to the world.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h     |  3 +++
 arch/arm64/kvm/arm.c                  | 39 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 38 --------------------------
 arch/arm64/kvm/vgic/vgic.h            |  3 ---
 4 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcd774d74f34..002a10cbade2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -922,6 +922,9 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
 
 int __init kvm_sys_reg_table_init(void);
 
+bool lock_all_vcpus(struct kvm *kvm);
+void unlock_all_vcpus(struct kvm *kvm);
+
 /* MMIO helpers */
 void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
 unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..097750a01497 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1484,6 +1484,45 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	}
 }
 
+/* unlocks vcpus from @vcpu_lock_idx and smaller */
+static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
+{
+	struct kvm_vcpu *tmp_vcpu;
+
+	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
+		tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
+		mutex_unlock(&tmp_vcpu->mutex);
+	}
+}
+
+void unlock_all_vcpus(struct kvm *kvm)
+{
+	unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
+}
+
+/* Returns true if all vcpus were locked, false otherwise */
+bool lock_all_vcpus(struct kvm *kvm)
+{
+	struct kvm_vcpu *tmp_vcpu;
+	unsigned long c;
+
+	/*
+	 * Any time a vcpu is in an ioctl (including running), the
+	 * core KVM code tries to grab the vcpu->mutex.
+	 *
+	 * By grabbing the vcpu->mutex of all VCPUs we ensure that no
+	 * other VCPUs can fiddle with the state while we access it.
+	 */
+	kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
+		if (!mutex_trylock(&tmp_vcpu->mutex)) {
+			unlock_vcpus(kvm, c - 1);
+			return false;
+		}
+	}
+
+	return true;
+}
+
 static unsigned long nvhe_percpu_size(void)
 {
 	return (unsigned long)CHOOSE_NVHE_SYM(__per_cpu_end) -
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index edeac2380591..04dd68835b3f 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -342,44 +342,6 @@ int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
 	return 0;
 }
 
-/* unlocks vcpus from @vcpu_lock_idx and smaller */
-static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
-{
-	struct kvm_vcpu *tmp_vcpu;
-
-	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
-		tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
-		mutex_unlock(&tmp_vcpu->mutex);
-	}
-}
-
-void unlock_all_vcpus(struct kvm *kvm)
-{
-	unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
-}
-
-/* Returns true if all vcpus were locked, false otherwise */
-bool lock_all_vcpus(struct kvm *kvm)
-{
-	struct kvm_vcpu *tmp_vcpu;
-	unsigned long c;
-
-	/*
-	 * Any time a vcpu is run, vcpu_load is called which tries to grab the
-	 * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure
-	 * that no other VCPUs are run and fiddle with the vgic state while we
-	 * access it.
-	 */
-	kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
-		if (!mutex_trylock(&tmp_vcpu->mutex)) {
-			unlock_vcpus(kvm, c - 1);
-			return false;
-		}
-	}
-
-	return true;
-}
-
 /**
  * vgic_v2_attr_regs_access - allows user space to access VGIC v2 state
  *
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 7f7f3c5ed85a..f9923beedd27 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -273,9 +273,6 @@ int vgic_init(struct kvm *kvm);
 void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
 
-bool lock_all_vcpus(struct kvm *kvm);
-void unlock_all_vcpus(struct kvm *kvm);
-
 static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *cpu_if = &vcpu->arch.vgic_cpu;
-- 
2.34.1

