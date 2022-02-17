Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1BA24BA3FE
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 16:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242310AbiBQPJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 10:09:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbiBQPJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 10:09:12 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D938D271E05
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 07:08:56 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id u2so8431052wrw.1
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 07:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=dw8y6DfT8cItFc3E/kYZhNuuPrxIuu5ppiDVXPQI9PM=;
        b=RPga9ENDDVsX0nUL9MeUD6OCRUXtY6eTIR9Nx7W4jwjItwWGTU6qYN+Qsox/VlEn0v
         gHeXZXAcSX+XNy1IOR/6POncTjxFeeXiea3gLQfe0XbT6IcBvElmZWQ+p4wdbWLeTdvL
         0mf4Z1Km/tI5+BM3BXUD9sgNr+yVOoQgqtqDYhRDHXaH3kE8nHG6yQDGYR410zxgMlXG
         wWVt1/FePzBOPglwMOWyHJU8PBB/37C9sZjsFK1ekGVshBNQ691vO2cyySnIdjaxRN2d
         AuFhq5WUHv7qO70hyTUrEqfJg6x4jW+2KIqU48OLKCskJf5f0WfAdKvsC20lEbppGgik
         Hr7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=dw8y6DfT8cItFc3E/kYZhNuuPrxIuu5ppiDVXPQI9PM=;
        b=epSpMdqBzSCaaZzhSUJDaAyODJP/8ItrpSGwuBiOWTRIqLvYF5t0Xmx4pYNpKhQzHC
         sthTbp18UI83J91wTVa+qePqKmuktoe6BTmnQZjL0RFXd7fzIvyADre66y2PTr+LqGL/
         GqsQKyWiNofh0gOk3mKGfyN/vAoxB+sBi64Ywyc+KXoYIhqnysmKERI9dLUcKlYXYIFi
         K2+5Tl0MnbdK36Gd2LS/4w4cbw3aoNM3W25VCO968jW8FNtqRr57TzvaTtRrE7BnCTlL
         MI07E3a4Hr4Lktr32n+kl1tTdtzsBZlzgTSm+eQ/fk+9QQZvkS53+8bvTlv3zXT1Ve8O
         kYsg==
X-Gm-Message-State: AOAM533ZHwW8TcYhSJO97HxB4giSkr2+p+BXVAfvVnRcggWSGTTQ9K4n
        Lqzi6CfaCGCPHi4gcrDWqP3/ZjmW6jHJm8gU7yk=
X-Google-Smtp-Source: ABdhPJyPfwzZ6cBtMVwCB06BbpZOA8F8BzClb4YWNjfADnbr827x/j4WYyCREkHYuI/nZLJRmR82Pw==
X-Received: by 2002:a5d:584b:0:b0:1e8:b478:ca0 with SMTP id i11-20020a5d584b000000b001e8b4780ca0mr2542777wrf.377.1645110535027;
        Thu, 17 Feb 2022 07:08:55 -0800 (PST)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id n20sm1610984wmq.42.2022.02.17.07.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 07:08:54 -0800 (PST)
Date:   Thu, 17 Feb 2022 15:08:53 +0000
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com
Subject: [PATCH kvmtool v2] aarch64: Add stolen time support
Message-ID: <Yg5lBZKsSoPNmVkT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds support for stolen time by sharing a memory region
with the guest which will be used by the hypervisor to store the stolen
time information. The exact format of the structure stored by the
hypervisor is described in the ARM DEN0057A document.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 Makefile                               |  1 +
 arm/aarch64/arm-cpu.c                  |  1 +
 arm/aarch64/include/kvm/kvm-cpu-arch.h |  1 +
 arm/aarch64/pvtime.c                   | 84 ++++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |  4 ++
 arm/kvm-cpu.c                          | 14 ++---
 6 files changed, 98 insertions(+), 7 deletions(-)
 create mode 100644 arm/aarch64/pvtime.c

diff --git a/Makefile b/Makefile
index f251147..e9121dc 100644
--- a/Makefile
+++ b/Makefile
@@ -182,6 +182,7 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/aarch64/arm-cpu.o
 	OBJS		+= arm/aarch64/kvm-cpu.o
 	OBJS		+= arm/aarch64/kvm.o
+	OBJS		+= arm/aarch64/pvtime.o
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
index d7572b7..326fb20 100644
--- a/arm/aarch64/arm-cpu.c
+++ b/arm/aarch64/arm-cpu.c
@@ -22,6 +22,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
 {
 	vcpu->generate_fdt_nodes = generate_fdt_nodes;
+	kvm_cpu__setup_pvtime(vcpu);
 	return 0;
 }
 
diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index 8dfb82e..b57d6e6 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -19,5 +19,6 @@
 
 void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
 int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
+void kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
 
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
new file mode 100644
index 0000000..c09fd89
--- /dev/null
+++ b/arm/aarch64/pvtime.c
@@ -0,0 +1,84 @@
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+
+#include <linux/byteorder.h>
+#include <linux/types.h>
+
+struct pvtime_data_priv {
+	bool	is_supported;
+	char	*usr_mem;
+};
+
+static struct pvtime_data_priv pvtime_data = {
+	.is_supported	= true,
+	.usr_mem	= NULL
+};
+
+static int pvtime__alloc_region(struct kvm *kvm)
+{
+	char *mem;
+	int ret = 0;
+
+	mem = mmap(NULL, AARCH64_PVTIME_IPA_MAX_SIZE, PROT_RW,
+		   MAP_ANON_NORESERVE, -1, 0);
+	if (mem == MAP_FAILED)
+		return -ENOMEM;
+
+	ret = kvm__register_dev_mem(kvm, AARCH64_PVTIME_IPA_START,
+				    AARCH64_PVTIME_IPA_MAX_SIZE, mem);
+	if (ret) {
+		munmap(mem, AARCH64_PVTIME_IPA_MAX_SIZE);
+		return ret;
+	}
+
+	pvtime_data.usr_mem = mem;
+	return ret;
+}
+
+static int pvtime__teardown_region(struct kvm *kvm)
+{
+	if (pvtime_data.usr_mem == NULL)
+		return 0;
+
+	kvm__destroy_mem(kvm, AARCH64_PVTIME_IPA_START,
+			 AARCH64_PVTIME_IPA_MAX_SIZE, pvtime_data.usr_mem);
+	munmap(pvtime_data.usr_mem, AARCH64_PVTIME_IPA_MAX_SIZE);
+	pvtime_data.usr_mem = NULL;
+	return 0;
+}
+
+void kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
+{
+	int ret;
+	u64 pvtime_guest_addr = AARCH64_PVTIME_IPA_START + vcpu->cpu_id *
+		AARCH64_PVTIME_SIZE;
+	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
+		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
+		.addr	= KVM_ARM_VCPU_PVTIME_IPA
+	};
+
+	if (!pvtime_data.is_supported)
+		return;
+
+	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
+	if (ret)
+		goto out_err;
+
+	if (!pvtime_data.usr_mem) {
+		ret = pvtime__alloc_region(vcpu->kvm);
+		if (ret)
+			goto out_err;
+	}
+
+	pvtime_attr.addr = (u64)&pvtime_guest_addr;
+	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pvtime_attr);
+	if (!ret)
+		return;
+
+	pvtime__teardown_region(vcpu->kvm);
+out_err:
+	pvtime_data.is_supported = false;
+}
+
+dev_exit(pvtime__teardown_region);
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index c645ac0..865bd68 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -54,6 +54,10 @@
 #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
 				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
 
+#define AARCH64_PVTIME_IPA_MAX_SIZE	SZ_64K
+#define AARCH64_PVTIME_IPA_START	(ARM_MEMORY_AREA - \
+					 AARCH64_PVTIME_IPA_MAX_SIZE)
+#define AARCH64_PVTIME_SIZE		(64)
 
 #define ARM_LOMAP_MAX_MEMORY	((1ULL << 32) - ARM_MEMORY_AREA)
 #define ARM_HIMAP_MAX_MEMORY	((1ULL << 40) - ARM_MEMORY_AREA)
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 6a2408c..84ac1e9 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -116,6 +116,13 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 			die("Unable to find matching target");
 	}
 
+	/* Populate the vcpu structure. */
+	vcpu->kvm		= kvm;
+	vcpu->cpu_id		= cpu_id;
+	vcpu->cpu_type		= vcpu_init.target;
+	vcpu->cpu_compatible	= target->compatible;
+	vcpu->is_running	= true;
+
 	if (err || target->init(vcpu))
 		die("Unable to initialise vcpu");
 
@@ -125,13 +132,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 		vcpu->ring = (void *)vcpu->kvm_run +
 			     (coalesced_offset * PAGE_SIZE);
 
-	/* Populate the vcpu structure. */
-	vcpu->kvm		= kvm;
-	vcpu->cpu_id		= cpu_id;
-	vcpu->cpu_type		= vcpu_init.target;
-	vcpu->cpu_compatible	= target->compatible;
-	vcpu->is_running	= true;
-
 	if (kvm_cpu__configure_features(vcpu))
 		die("Unable to configure requested vcpu features");
 
-- 
2.35.1.265.g69c8d7142f-goog

