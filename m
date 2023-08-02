Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F26376DBBE
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 01:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbjHBXni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 19:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbjHBXna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 19:43:30 -0400
Received: from out-79.mta1.migadu.com (out-79.mta1.migadu.com [IPv6:2001:41d0:203:375::4f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF48030E0
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 16:43:27 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691019805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yZ5cS4uVApzTMhkcsYl32QYpyJaJQq/5lAGOLA7r+KY=;
        b=nlxIOkEBS3OOpRKV4lMgr6F9aMOL8kUXAC6d7yq7amMDOJVDocOSi719XbnTru9CKVYjCc
        5n40uHAyYfmAF1WVQnE3kGXL8rulwvezkT7vkZHAd1bnnDseVC+jaabmBIV50qXW1wCZJ7
        W++wnu9295eaMsCQem0HQf3htasdCx4=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v3 07/17] arm: Generalize execution state specific VM initialization
Date:   Wed,  2 Aug 2023 23:42:45 +0000
Message-ID: <20230802234255.466782-8-oliver.upton@linux.dev>
In-Reply-To: <20230802234255.466782-1-oliver.upton@linux.dev>
References: <20230802234255.466782-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current state of MTE initialization sticks out a bit: an
MTE-specific init routine is implemented for both aarch32 and aarch64.
Generalize on the notion of execution state specific VM initialization
in preparation for SMCCC filter creation, as the feature is only present
on aarch64.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch32/include/kvm/kvm-arch.h | 2 +-
 arm/aarch64/include/kvm/kvm-arch.h | 1 -
 arm/aarch64/kvm.c                  | 7 ++++++-
 arm/include/arm-common/kvm-arch.h  | 2 ++
 arm/kvm.c                          | 2 +-
 5 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
index 467fb09175b8..c02fbea9f2fc 100644
--- a/arm/aarch32/include/kvm/kvm-arch.h
+++ b/arm/aarch32/include/kvm/kvm-arch.h
@@ -6,7 +6,7 @@
 #define kvm__arch_get_kern_offset(...)	0x8000
 
 struct kvm;
-static inline void kvm__arch_enable_mte(struct kvm *kvm) {}
+static inline void __kvm__arm_init(struct kvm *kvm) {}
 
 #define MAX_PAGE_SIZE	SZ_4K
 
diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index 02d09a413831..0d3b169b3c93 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -6,7 +6,6 @@
 struct kvm;
 unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd);
 int kvm__arch_get_ipa_limit(struct kvm *kvm);
-void kvm__arch_enable_mte(struct kvm *kvm);
 
 #define MAX_PAGE_SIZE	SZ_64K
 
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 54200c9eec9d..848e6909994a 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -134,7 +134,7 @@ int kvm__get_vm_type(struct kvm *kvm)
 	return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
 }
 
-void kvm__arch_enable_mte(struct kvm *kvm)
+static void kvm__arch_enable_mte(struct kvm *kvm)
 {
 	struct kvm_enable_cap cap = {
 		.cap = KVM_CAP_ARM_MTE,
@@ -160,3 +160,8 @@ void kvm__arch_enable_mte(struct kvm *kvm)
 
 	pr_debug("MTE capability enabled");
 }
+
+void __kvm__arm_init(struct kvm *kvm)
+{
+	kvm__arch_enable_mte(kvm);
+}
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index 60eec02c1d10..00c4b74c9d41 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -110,4 +110,6 @@ struct kvm_arch {
 	cpu_set_t *vcpu_affinity_cpuset;
 };
 
+void __kvm__arm_init(struct kvm *kvm);
+
 #endif /* ARM_COMMON__KVM_ARCH_H */
diff --git a/arm/kvm.c b/arm/kvm.c
index 9f9582326401..7042d0900664 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -93,7 +93,7 @@ void kvm__arch_init(struct kvm *kvm)
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
 
-	kvm__arch_enable_mte(kvm);
+	__kvm__arm_init(kvm);
 }
 
 #define FDT_ALIGN	SZ_2M
-- 
2.41.0.585.gd2178a4bd4-goog

