Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433274B8DA8
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 17:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbiBPQRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 11:17:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbiBPQRE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 11:17:04 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C8E15DB09
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 08:16:51 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id d14-20020a05600c34ce00b0037bf4d14dc7so1994145wmq.3
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 08:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=H3gHrgMTfocFjTPlthx24Op4v2ZtezvXjgsNGzJCP90=;
        b=dCXnSdTuIIf2eyYh3riusSZHwXL+NnU7icSOSc+Qv+f54GniZFezvYNYIq6w3E3FCV
         LmzYyj4LclmxjWkDH78zSBT6rqccbqo28/2qkkE+lk1/vp8So+clEQienf6uFmpf9+Ux
         e3t3Yh568sYQGoP/97cn+oU735i/PwEfmU5SQeNp9f7cIoPxKbwYyePaYNwkFAcn8JVz
         tGeomKVq4UrGcw4mz82IqED1+WqPDbOQ6gqqhCI2A+l8flYjJiJovbdiEotKBtTcDLzK
         FKedMQovTJmpCtJV55i8c/Vc82w7mrbKMK3SDGkfTIx5163obS8M4bI1QM9rZKDyghxv
         GU6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=H3gHrgMTfocFjTPlthx24Op4v2ZtezvXjgsNGzJCP90=;
        b=jwEAckKQWT92kK05VyPQSXBEDYS9cslLQxlXZUFU7X3bBs600bxKhS9KfGdfFs8/E4
         Zd1N78bR46x0/FqZcM0eX8ZhE3M2PYMQO9z6YprVITver//3EoeS0+M4H+60b7YgG6Ay
         +tVxQ4o5urq1LhsIQUgFPUjfVpujKeT/7iTRp3mLq2UdEh3aOr/iWZpvJdDu6JdsEaHj
         76cHF2rDbqUSqo/Vw6/PUF7eP19JCmIyG4M4PqbVhbBSg+FD07u1fZf9yDaMeTpCvQ7M
         oTXO/as65z9jBrjloK0WUDPfPXqcP3AEF6wyEURrh/cIfwsyeTka7Qz6YRHQXgXsx4IG
         Tz7A==
X-Gm-Message-State: AOAM533pPzqgAsZ2W5lwfC5cB12f1K2F3raGA14BZFDVMIZe+v4qXzck
        vru6lBmiCoF7XB2+VX0fxRbl7T6DLn4L5TLx
X-Google-Smtp-Source: ABdhPJx7FeJIsiXbjONZX2UTKtSQyEFokJwTL2ioUcuI3Oi1mbN1MMMPGCc3Hs38Ubc0NLqVS/PqcA==
X-Received: by 2002:a05:600c:3491:b0:37b:d710:f565 with SMTP id a17-20020a05600c349100b0037bd710f565mr2401004wmq.10.1645028209834;
        Wed, 16 Feb 2022 08:16:49 -0800 (PST)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id ba27sm8809744wrb.61.2022.02.16.08.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 08:16:49 -0800 (PST)
Date:   Wed, 16 Feb 2022 16:16:48 +0000
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com
Subject: [PATCH kvmtool] aarch64: Add stolen time support
Message-ID: <Yg0jcO32I+zFz/0s@google.com>
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

This patch add support for stolen time by sharing a memory region
with the guest which will be used by the hypervisor to store the stolen
time information. The exact format of the structure stored by the
hypervisor is described in the ARM DEN0057A document.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 Makefile                          |  3 +-
 arm/aarch64/arm-cpu.c             |  2 +
 arm/aarch64/include/kvm/pvtime.h  |  6 +++
 arm/aarch64/pvtime.c              | 83 +++++++++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h |  6 +++
 arm/kvm-cpu.c                     | 14 +++---
 6 files changed, 106 insertions(+), 8 deletions(-)
 create mode 100644 arm/aarch64/include/kvm/pvtime.h
 create mode 100644 arm/aarch64/pvtime.c

diff --git a/Makefile b/Makefile
index f251147..282ae99 100644
--- a/Makefile
+++ b/Makefile
@@ -182,6 +182,7 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/aarch64/arm-cpu.o
 	OBJS		+= arm/aarch64/kvm-cpu.o
 	OBJS		+= arm/aarch64/kvm.o
+	OBJS		+= arm/aarch64/pvtime.o
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
@@ -582,4 +583,4 @@ ifneq ($(MAKECMDGOALS),clean)
 
 KVMTOOLS-VERSION-FILE:
 	@$(SHELL_PATH) util/KVMTOOLS-VERSION-GEN $(OUTPUT)
-endif
\ No newline at end of file
+endif
diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
index d7572b7..80bf83a 100644
--- a/arm/aarch64/arm-cpu.c
+++ b/arm/aarch64/arm-cpu.c
@@ -2,6 +2,7 @@
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
 #include "kvm/util.h"
+#include "kvm/pvtime.h"
 
 #include "arm-common/gic.h"
 #include "arm-common/timer.h"
@@ -22,6 +23,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
 {
 	vcpu->generate_fdt_nodes = generate_fdt_nodes;
+	pvtime__setup_vcpu(vcpu);
 	return 0;
 }
 
diff --git a/arm/aarch64/include/kvm/pvtime.h b/arm/aarch64/include/kvm/pvtime.h
new file mode 100644
index 0000000..c31f019
--- /dev/null
+++ b/arm/aarch64/include/kvm/pvtime.h
@@ -0,0 +1,6 @@
+#ifndef KVM__PVTIME_H
+#define KVM__PVTIME_H
+
+void pvtime__setup_vcpu(struct kvm_cpu *vcpu);
+
+#endif /* KVM__PVTIME_H */
diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
new file mode 100644
index 0000000..eb92388
--- /dev/null
+++ b/arm/aarch64/pvtime.c
@@ -0,0 +1,83 @@
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+#include "kvm/pvtime.h"
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
+static int pvtime__aloc_region(struct kvm *kvm)
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
+	kvm__destroy_mem(kvm, AARCH64_PVTIME_IPA_START,
+			 AARCH64_PVTIME_IPA_MAX_SIZE, pvtime_data.usr_mem);
+	munmap(pvtime_data.usr_mem, AARCH64_PVTIME_IPA_MAX_SIZE);
+	pvtime_data.usr_mem = NULL;
+	return 0;
+}
+
+void pvtime__setup_vcpu(struct kvm_cpu *vcpu)
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
+	if (!pvtime_data.usr_mem) {
+		ret = pvtime__aloc_region(vcpu->kvm);
+		if (ret)
+			goto out_err_alloc;
+	}
+
+	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
+	if (ret)
+		goto out_err_attr;
+
+	pvtime_attr.addr = (u64)&pvtime_guest_addr;
+	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pvtime_attr);
+	if (!ret)
+		return;
+
+out_err_attr:
+	pvtime__teardown_region(vcpu->kvm);
+out_err_alloc:
+	pvtime_data.is_supported = false;
+}
+
+dev_exit(pvtime__teardown_region);
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index c645ac0..7b683d6 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -54,6 +54,12 @@
 #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
 				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
 
+#define AARCH64_PVTIME_IPA_MAX_SIZE		(0x10000)
+#define AARCH64_PROTECTED_VM_FW_MAX_SIZE	(0x200000)
+#define AARCH64_PVTIME_IPA_START	(ARM_MEMORY_AREA - \
+					 AARCH64_PROTECTED_VM_FW_MAX_SIZE - \
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

