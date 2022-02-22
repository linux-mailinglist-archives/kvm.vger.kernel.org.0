Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADCD4BF57E
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 11:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiBVKKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 05:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiBVKJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 05:09:40 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A953A10DA66
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 02:08:33 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id j17so5400933wrc.0
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 02:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=4noxcyuFAgImzzAQFbzXSRryQNYK+yQdcRgbEx09zps=;
        b=ItgWNPLKUu3pHO3VpOTEPzFbeGENbBktmqN/9y5X4bUB8fTyrV6xQBAXin+dqF4yYS
         nYBefNG2dTCZku+AkdEc7vK8EwBGsdYc2KdJxXnEDhbKvRvrXdGfipGOy5IMFRDR8j+O
         zdHsRtW3ERx4FTuCzJ/xbA97zAa8xMdI9fINxYAY+5Sr1CfSg4MVUrV6AavCjLNAMUc1
         VIJipnRHx2tCslJ2oizzGi6tkYPRjFm9eHzzCeVd5WSl/koTHyoLqK5nFcX4FDg1ac1F
         PQqru1cJSdrNyO0i2riNQ8bhuA2+AUQdHWGd0S7CPccAO1Vm+Kg7wQEoIfIRcA/dteNL
         P96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=4noxcyuFAgImzzAQFbzXSRryQNYK+yQdcRgbEx09zps=;
        b=J0IfFK0ANpSTuMVAMhkTA9E/U6W5juVLGOLVWN5c7bk9nZvTwjSe+IhMIEp8L9UYJJ
         ROPC5W01wVvp3Ii0lklvrVaREEA/QjNb06mkOKQaqV2kxYlXHm9A9OB87UACuOerH3ic
         ggPtftv7rDcAIi5WX2Dx3WZvPDTHAJQiGW9/horvtIyhknzrG05HJlrt1E36pZNC1xIi
         TYTm1ShGygVO/cX3PrDgzKdmli2RRsfVf6QGKFwt1Z8lFimwGlgrwNthf72EtCdL9PKi
         Jsa2pr1czL62x0u12MZoveG+eGj86YkwvDs5lKO+aj9NmHLps+cftnmXNRz8ZLurkorq
         ZAAQ==
X-Gm-Message-State: AOAM532BLUY086IUhlpFIV/FcMFAzlA85Y1y1CZqlQhUu6krD5LmccjB
        VqMD1Qe+a5dMgg8Oc9R5h0ob8DYbMpR6KsH9
X-Google-Smtp-Source: ABdhPJxgqqnm3BH5ABsKk4NFgcnTNqoY05PNmRVsLoNlu5l1DmDMUkhqIrBh1ChBVvXIXKKSVkdjKA==
X-Received: by 2002:adf:a389:0:b0:1ea:95ea:58dc with SMTP id l9-20020adfa389000000b001ea95ea58dcmr1472168wrb.659.1645524511947;
        Tue, 22 Feb 2022 02:08:31 -0800 (PST)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id ay41sm1921137wmb.44.2022.02.22.02.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 02:08:31 -0800 (PST)
Date:   Tue, 22 Feb 2022 10:08:30 +0000
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com
Subject: [PATCH kvmtool v3] aarch64: Add stolen time support
Message-ID: <YhS2Htrzwks/allO@google.com>
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
 Changelog since v2:
 - Moved the AARCH64_PVTIME_* definitions from arm-common/kvm-arch.h to
   arm64/pvtime.c as pvtime is only available for arm64.

 Changelog since v1:
 - Removed the pvtime.h header file and moved the definitions to kvm-cpu-arch.h
   Verified if the stolen time capability is supported before allocating
   and mapping the memory.

 Makefile                               |  1 +
 arm/aarch64/arm-cpu.c                  |  1 +
 arm/aarch64/include/kvm/kvm-cpu-arch.h |  1 +
 arm/aarch64/pvtime.c                   | 89 ++++++++++++++++++++++++++
 arm/kvm-cpu.c                          | 14 ++--
 5 files changed, 99 insertions(+), 7 deletions(-)
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
index 0000000..247e4f3
--- /dev/null
+++ b/arm/aarch64/pvtime.c
@@ -0,0 +1,89 @@
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+
+#include <linux/byteorder.h>
+#include <linux/types.h>
+
+#define AARCH64_PVTIME_IPA_MAX_SIZE	SZ_64K
+#define AARCH64_PVTIME_IPA_START	(ARM_MEMORY_AREA - \
+					 AARCH64_PVTIME_IPA_MAX_SIZE)
+#define AARCH64_PVTIME_SIZE		(64)
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
2.35.1.473.g83b2b277ed-goog

