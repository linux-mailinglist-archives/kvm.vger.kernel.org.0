Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424174CA705
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 15:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242662AbiCBOFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 09:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242454AbiCBOE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 09:04:56 -0500
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5287782D07
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 06:04:12 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id a16-20020adff7d0000000b001f0473a6b25so383215wrq.1
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 06:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+7ryEuLNazk+gzDD/Av2pf121u7rcYLE694jPZmdl3I=;
        b=aaWD/Xk4R6DW7KkfnF2KmpIHT45cGuZVXd+c6iyHnsb48hSe82kFln0JwFzcpSasmB
         N7dxEkRdXyQay5O6eQOIWjbpk3mwjc2BDorIskb1khBjxxOjRMSWyvO52T66zHD8bgf3
         w3zFMK8G3wQ5QiMdFVtQ111YcA9JoBtCwaEYy2OMpr0vYs1HDbqU4U7O6j6QSkMfCGHt
         +zkYkvBeD3htPQLyL9ZSiqk9YQDkpGtCa/puh3UmjtWkmSXrz1mG+A2lVhT1PtwgUY9I
         m4WwamqKss79v1AHI0NP+ANuUbtmOzvOfTE7uiUtNfSc7Pd7hNZYlI4BMRtmbl2HEuaH
         3Qsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+7ryEuLNazk+gzDD/Av2pf121u7rcYLE694jPZmdl3I=;
        b=TDfRvHZNZYYXR8s5gZFqnVNNVwx7UADmRbwT88hvQVP5aHHKgSc83UoCslJ22ScnjH
         A8F0W2KBElJ65Z5xo8C0OXB74pwhJH8MnJuEvLXHU2y6ICUgGF529zAoufPewXT9rRfI
         2Cbuv3+lqDt4Dfg6ERYjM0hd6mcALaEDcAMGaOy29SaZM0YYvn0XNMP6HC3ly0Knq1gw
         OFt53CXwZvdpVPBXf+Ul47873BtyBzZiC1iZaZ6aYwARdHMgFKN0doUELD9qdG2M4+kG
         BIg2umLAFQ1mAcz3R49wkAx+rq9y/dOXOV6MqN92kwM61fB+yOPViJWUIgXIuvgv6e82
         LcjA==
X-Gm-Message-State: AOAM5300iYYlggCdVvb9u8Pyqkp2XNNL6R+QMljzw7AA4v7+CPD8ASwO
        GkE9UEoE7SySO41ynAraOu5SottUDVEnAuRSr+2XH3K++yrf93YFd79bQOjA+Z2MsCBwChVvQ1m
        14uZwfNa1XUZ7SaxGVCFcpJKf2qvwFqX1bkD++jkO02iTqvgdicmEzi/x5PlDa3U+p+Qu6LrmUw
        ==
X-Google-Smtp-Source: ABdhPJzsdCJY9Og6MZEE85jWVH7V/5hJBmfWRHHYKTZ7lUqr6p/5MajVCSEdArK9tSru7GXdNrehwbt1qri6etn/j9w=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:3c89:b0:37f:aacb:cac7 with
 SMTP id bg9-20020a05600c3c8900b0037faacbcac7mr292082wmb.1.1646229850330; Wed,
 02 Mar 2022 06:04:10 -0800 (PST)
Date:   Wed,  2 Mar 2022 14:03:24 +0000
In-Reply-To: <20220302140324.1010891-1-sebastianene@google.com>
Message-Id: <20220302140324.1010891-3-sebastianene@google.com>
Mime-Version: 1.0
References: <20220302140324.1010891-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v6 2/3] aarch64: Add stolen time support
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds support for stolen time by sharing a memory region
with the guest which will be used by the hypervisor to store the stolen
time information. Reserve a 64kb MMIO memory region after the RTC peripheral
to be used by pvtime. The exact format of the structure stored by the
hypervisor is described in the ARM DEN0057A document.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 Makefile                               |   1 +
 arm/aarch64/arm-cpu.c                  |   2 +-
 arm/aarch64/include/kvm/kvm-cpu-arch.h |   1 +
 arm/aarch64/pvtime.c                   | 103 +++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |   6 +-
 include/kvm/kvm-config.h               |   1 +
 6 files changed, 112 insertions(+), 2 deletions(-)
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
index d7572b7..7e4a3c1 100644
--- a/arm/aarch64/arm-cpu.c
+++ b/arm/aarch64/arm-cpu.c
@@ -22,7 +22,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
 {
 	vcpu->generate_fdt_nodes = generate_fdt_nodes;
-	return 0;
+	return kvm_cpu__setup_pvtime(vcpu);
 }
 
 static struct kvm_arm_target target_generic_v8 = {
diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index 8dfb82e..2b2c1ff 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -19,5 +19,6 @@
 
 void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
 int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
+int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
 
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
new file mode 100644
index 0000000..707412d
--- /dev/null
+++ b/arm/aarch64/pvtime.c
@@ -0,0 +1,103 @@
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+
+#include <linux/byteorder.h>
+#include <linux/types.h>
+
+#define ARM_PVTIME_STRUCT_SIZE		(64)
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
+	mem = mmap(NULL, ARM_PVTIME_MMIO_SIZE, PROT_RW,
+		   MAP_ANON_NORESERVE, -1, 0);
+	if (mem == MAP_FAILED)
+		return -errno;
+
+	ret = kvm__register_dev_mem(kvm, ARM_PVTIME_MMIO_BASE,
+				    ARM_PVTIME_MMIO_SIZE, mem);
+	if (ret) {
+		munmap(mem, ARM_PVTIME_MMIO_SIZE);
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
+	kvm__destroy_mem(kvm, ARM_PVTIME_MMIO_BASE,
+			 ARM_PVTIME_MMIO_SIZE, pvtime_data.usr_mem);
+	munmap(pvtime_data.usr_mem, ARM_PVTIME_MMIO_SIZE);
+	pvtime_data.usr_mem = NULL;
+	return 0;
+}
+
+dev_exit(pvtime__teardown_region);
+
+int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
+{
+	int ret;
+	bool has_stolen_time;
+	u64 pvtime_guest_addr = ARM_PVTIME_MMIO_BASE + vcpu->cpu_id *
+		ARM_PVTIME_STRUCT_SIZE;
+	struct kvm_config *kvm_cfg = NULL;
+	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
+		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
+		.addr	= KVM_ARM_VCPU_PVTIME_IPA
+	};
+
+	kvm_cfg = &vcpu->kvm->cfg;
+	if (kvm_cfg->no_pvtime)
+		return 0;
+
+	if (!pvtime_data.is_supported)
+		return -ENOTSUP;
+
+	has_stolen_time = kvm__supports_extension(vcpu->kvm,
+						  KVM_CAP_STEAL_TIME);
+	if (!has_stolen_time)
+		return 0;
+
+	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
+	if (ret) {
+		perror("KVM_HAS_DEVICE_ATTR failed %d", -errno);
+		goto out_err;
+	}
+
+	if (!pvtime_data.usr_mem) {
+		ret = pvtime__alloc_region(vcpu->kvm);
+		if (ret) {
+			perror("Failed allocating pvtime region %d\n", ret);
+			goto out_err;
+		}
+	}
+
+	pvtime_attr.addr = (u64)&pvtime_guest_addr;
+	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pvtime_attr);
+	if (!ret)
+		return 0;
+
+	perror("KVM_SET_DEVICE_ATTR failed %d", -errno);
+	pvtime__teardown_region(vcpu->kvm);
+out_err:
+	pvtime_data.is_supported = false;
+	return ret;
+}
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index c645ac0..3f82663 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -15,7 +15,8 @@
  * |  PCI  |////| plat  |       |        |     |         |
  * |  I/O  |////| MMIO: | Flash | virtio | GIC |   PCI   |  DRAM
  * | space |////| UART, |       |  MMIO  |     |  (AXI)  |
- * |       |////| RTC   |       |        |     |         |
+ * |       |////| RTC,  |       |        |     |         |
+ * |       |////| PVTIME|       |        |     |         |
  * +-------+----+-------+-------+--------+-----+---------+---......
  */
 
@@ -34,6 +35,9 @@
 #define ARM_RTC_MMIO_BASE	(ARM_UART_MMIO_BASE + ARM_UART_MMIO_SIZE)
 #define ARM_RTC_MMIO_SIZE	0x10000
 
+#define ARM_PVTIME_MMIO_BASE	(ARM_RTC_MMIO_BASE + ARM_RTC_MMIO_SIZE)
+#define ARM_PVTIME_MMIO_SIZE	SZ_64K
+
 #define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
 #define KVM_FLASH_MAX_SIZE	0x1000000
 
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 6a5720c..48adf27 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -62,6 +62,7 @@ struct kvm_config {
 	bool no_dhcp;
 	bool ioport_debug;
 	bool mmio_debug;
+	bool no_pvtime;
 };
 
 #endif
-- 
2.35.1.574.g5d30c73bfb-goog

