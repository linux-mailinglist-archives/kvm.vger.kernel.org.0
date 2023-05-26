Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83598712FE4
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 00:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjEZWUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 18:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243688AbjEZWU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 18:20:29 -0400
Received: from out-44.mta0.migadu.com (out-44.mta0.migadu.com [91.218.175.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95904E76
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 15:20:09 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685139557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2FqhtMmKGmZl4KHXt11WnsOMNvOZmFxz6xEVgV93OUg=;
        b=Run5F849rhkAj5AvoY7XDPO4sOE6qAgcbhMz3fu5Rk9RX3O0nww17Vgwit2Ym2CqJkx7La
        Ze7G6mJ8Oxi0Rb19Yn+sDjn5r7tRk+4xn2KliREvYprYjal8BfjuZJa5d787VLatnhnOPR
        zADnXYditu+aSsyVDIideKcmKFtg1xw=
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
Subject: [PATCH kvmtool 21/21] aarch64: smccc: Start sending PSCI to userspace
Date:   Fri, 26 May 2023 22:19:09 +0000
Message-ID: <20230526221909.317511-1-oliver.upton@linux.dev>
In-Reply-To: <20230526221712.317287-1-oliver.upton@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmtool now has a PSCI implementation that complies with v1.0 of the
specification. Use the SMCCC filter to start sending these calls out to
userspace for further handling. While at it, shut the door on the
legacy, KVM-specific v0.1 functions.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/include/kvm/kvm-config-arch.h |  6 +++-
 arm/aarch64/smccc.c                       | 37 +++++++++++++++++++++++
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index eae8080d3fd9..1c40bbac70f5 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -19,7 +19,11 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset);
 			"Specify random seed for Kernel Address Space "	\
 			"Layout Randomization (KASLR)"),		\
 	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
-			" stolen time"),
+			" stolen time"),				\
+	OPT_BOOLEAN('\0', "in-kernel-smccc", &(cfg)->in_kernel_smccc,	\
+			"Disable userspace handling of SMCCC, instead"	\
+			" relying on the in-kernel implementation"),
+
 #include "arm-common/kvm-config-arch.h"
 
 #endif /* KVM__KVM_CONFIG_ARCH_H */
diff --git a/arm/aarch64/smccc.c b/arm/aarch64/smccc.c
index b95077305ffa..13aa39c927b7 100644
--- a/arm/aarch64/smccc.c
+++ b/arm/aarch64/smccc.c
@@ -39,7 +39,44 @@ out:
 	return true;
 }
 
+static struct kvm_smccc_filter filter_ranges[] = {
+	{
+		.base		= KVM_PSCI_FN_BASE,
+		.nr_functions	= 4,
+		.action		= KVM_SMCCC_FILTER_DENY,
+	},
+	{
+		.base		= PSCI_0_2_FN_BASE,
+		.nr_functions	= 0x20,
+		.action		= KVM_SMCCC_FILTER_FWD_TO_USER,
+	},
+	{
+		.base		= PSCI_0_2_FN64_BASE,
+		.nr_functions	= 0x20,
+		.action		= KVM_SMCCC_FILTER_FWD_TO_USER,
+	},
+};
+
 void kvm__setup_smccc(struct kvm *kvm)
 {
+	struct kvm_device_attr attr = {
+		.group	= KVM_ARM_VM_SMCCC_CTRL,
+		.attr	= KVM_ARM_VM_SMCCC_FILTER,
+	};
+	unsigned int i;
 
+	if (kvm->cfg.arch.in_kernel_smccc)
+		return;
+
+	if (ioctl(kvm->vm_fd, KVM_HAS_DEVICE_ATTR, &attr)) {
+		pr_debug("KVM SMCCC filter not supported");
+		return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(filter_ranges); i++) {
+		attr.addr = (u64)&filter_ranges[i];
+
+		if (ioctl(kvm->vm_fd, KVM_SET_DEVICE_ATTR, &attr))
+			die_perror("KVM_SET_DEVICE_ATTR failed");
+	}
 }
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 87f50352e60f..fa9c34519bd9 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -14,6 +14,7 @@ struct kvm_config_arch {
 	enum irqchip_type irqchip;
 	u64		fw_addr;
 	bool no_pvtime;
+	bool		in_kernel_smccc;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
-- 
2.41.0.rc0.172.g3f132b7071-goog

