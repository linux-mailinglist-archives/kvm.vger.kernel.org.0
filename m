Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893A867E3D5
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbjA0Lmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbjA0LmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:42:00 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8AEF372659;
        Fri, 27 Jan 2023 03:41:28 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6C8F1684;
        Fri, 27 Jan 2023 03:41:47 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 561883F64C;
        Fri, 27 Jan 2023 03:41:03 -0800 (PST)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     suzuki.poulose@arm.com,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, linux-coco@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC kvmtool 27/31] virtio: Add arch specific hook for virtio host flags
Date:   Fri, 27 Jan 2023 11:39:28 +0000
Message-Id: <20230127113932.166089-28-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127113932.166089-1-suzuki.poulose@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127113932.166089-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add callbacks for archs to provide virtio host flags.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch32/kvm.c | 5 +++++
 arm/aarch64/kvm.c | 5 +++++
 include/kvm/kvm.h | 2 ++
 mips/kvm.c        | 5 +++++
 powerpc/kvm.c     | 5 +++++
 riscv/kvm.c       | 5 +++++
 virtio/core.c     | 5 ++++-
 x86/kvm.c         | 5 +++++
 8 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arm/aarch32/kvm.c b/arm/aarch32/kvm.c
index 768a56bb..849c55d3 100644
--- a/arm/aarch32/kvm.c
+++ b/arm/aarch32/kvm.c
@@ -12,3 +12,8 @@ u64 kvm__arch_default_ram_address(void)
 {
 	return ARM_MEMORY_AREA;
 }
+
+u64 kvm__arch_get_virtio_host_features(struct kvm *kvm)
+{
+	return 0;
+}
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 344c568b..a4664237 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -234,3 +234,8 @@ void kvm__arch_enable_mte(struct kvm *kvm)
 
 	pr_debug("MTE capability enabled");
 }
+
+u64 kvm__arch_get_virtio_host_features(struct kvm *kvm)
+{
+	return 0;
+}
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 3872dc65..a3624de4 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -203,6 +203,8 @@ int kvm__arch_free_firmware(struct kvm *kvm);
 bool kvm__arch_cpu_supports_vm(void);
 void kvm__arch_read_term(struct kvm *kvm);
 
+u64 kvm__arch_get_virtio_host_features(struct kvm *kvm);
+
 #ifdef ARCH_HAS_CFG_RAM_ADDRESS
 static inline bool kvm__arch_has_cfg_ram_address(void)
 {
diff --git a/mips/kvm.c b/mips/kvm.c
index 0faa03a9..e23d5cf9 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -374,3 +374,8 @@ void ioport__map_irq(u8 *irq)
 void serial8250__inject_sysrq(struct kvm *kvm, char sysrq)
 {
 }
+
+u64 kvm__arch_get_virtio_host_features(struct kvm *kvm)
+{
+	return 0;
+}
diff --git a/powerpc/kvm.c b/powerpc/kvm.c
index 7b0d0669..6b3ab93f 100644
--- a/powerpc/kvm.c
+++ b/powerpc/kvm.c
@@ -529,3 +529,8 @@ int kvm__arch_free_firmware(struct kvm *kvm)
 {
 	return 0;
 }
+
+u64 kvm__arch_get_virtio_host_features(struct kvm *kvm)
+{
+	return 0;
+}
diff --git a/riscv/kvm.c b/riscv/kvm.c
index 4d6f5cb5..884321ca 100644
--- a/riscv/kvm.c
+++ b/riscv/kvm.c
@@ -182,3 +182,8 @@ int kvm__arch_setup_firmware(struct kvm *kvm)
 {
 	return 0;
 }
+
+u64 kvm__arch_get_virtio_host_features(struct kvm *kvm)
+{
+	return 0;
+}
diff --git a/virtio/core.c b/virtio/core.c
index 50e7f86d..674f6fae 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -285,7 +285,10 @@ void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 
 u64 virtio_dev_get_host_features(struct virtio_device *vdev, struct kvm *kvm, void *dev)
 {
-	return vdev->ops->get_host_features(kvm, dev);
+	u64 features = kvm__arch_get_virtio_host_features(kvm);
+
+	features |= vdev->ops->get_host_features(kvm, dev);
+	return features;
 }
 
 bool virtio_access_config(struct kvm *kvm, struct virtio_device *vdev,
diff --git a/x86/kvm.c b/x86/kvm.c
index 328fa750..961b5d3f 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -387,3 +387,8 @@ void kvm__arch_read_term(struct kvm *kvm)
 	serial8250__update_consoles(kvm);
 	virtio_console__inject_interrupt(kvm);
 }
+
+u64 kvm__arch_get_virtio_host_features(struct kvm *kvm)
+{
+	return 0;
+}
-- 
2.34.1

