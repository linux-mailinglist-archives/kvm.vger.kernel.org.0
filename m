Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7BA711FD7
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 08:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242150AbjEZGZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 02:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242137AbjEZGZi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 02:25:38 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C93198
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 23:25:35 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1ae452c2777so3926845ad.0
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 23:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685082335; x=1687674335;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1C0UYjIrCFodvNRiqEHXxZVoFTPAVZq1EdtJGjVqtXw=;
        b=P2aBusqCin3KnObGgGF5eGu8p2r5/nP2VJObx5uYw0Lox8eJTn+A1KKP5HhXIBOPyA
         958PSIPsGjMIfY48KDM9eWTUGjqvOsUM65/L+tBIyv3sOe3kTyoL0qr3GF8EBf8I0dVr
         P0f7KRLQyxWGOScUTlG6aqhZPeB5VILv7nS8omySEJMKvE54NiTXNLbKHQxrsKFHXY1g
         FOqY0/QZDsra3L92+1iPnGt6FwFaCWymuugVitJ99WGPj3AYtxB8EgUjfGR7Lg3wna/+
         C6SS3i+wiO0DHFCIY9IhEeHYgodzq+muz67Jyc0n8bGM611wbzuJ+qXyv+1kMyXyr76U
         L2gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685082335; x=1687674335;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1C0UYjIrCFodvNRiqEHXxZVoFTPAVZq1EdtJGjVqtXw=;
        b=aTJN8rmxKygdfB3BupdM+kt3wYMuXHaJ97GHEmOTLmlrG2gXQVDNmTDGOQFVVfP+LA
         StBEueC1GaZhRG9QO1jATqv6fNMjSM/gieIyjkgk4K+Rnp8Mi+gAKxIjvMbkGYqeHoLy
         E/ZVITfa1HyfPn6mOAMNsv9ztN6eX0gK5ADTaA1oMElARsTipe++pOPHgWhCOfhuxSXD
         CafrLkOKgYmZ7x5koc7B2TwChQ5UZOwl9CvUg7kxl0X3t6iT2NJLM4lw9Ein5LtSwWjo
         TWUs8vtXyzOiPSDdFRtbgMoChJCI9uD0cf28jKye0n0PxIuknOfVavuVz2caArCrONc9
         wT/Q==
X-Gm-Message-State: AC+VfDwhClYKT9ACXH6MbfhWQP35P91Hf+WdeuhfpvTbnwO6t8fD+0pi
        FzVSip4dZRaNMc6h7DjvcNBzCCCULpbMs7ENf+E=
X-Google-Smtp-Source: ACHHUZ6wa1D5MjwdLipRo87u4avsi3ZvaKHVUVuYnS+XPlQ4eL5pJcH7Ig8zM3dMs+bFu8rKL6qmog==
X-Received: by 2002:a17:902:c40e:b0:1b0:7cc:982a with SMTP id k14-20020a170902c40e00b001b007cc982amr1208190plk.5.1685082334910;
        Thu, 25 May 2023 23:25:34 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id m24-20020a170902bb9800b001a94a497b50sm2429150pls.20.2023.05.25.23.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 23:25:34 -0700 (PDT)
From:   Yong-Xuan Wang <yongxuan.wang@sifive.com>
To:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org, rkanwal@rivosinc.com,
        anup@brainfault.org, dbarboza@ventanamicro.com,
        atishp@atishpatra.org, vincent.chen@sifive.com,
        greentime.hu@sifive.com, frank.chang@sifive.com, jim.shu@sifive.com
Cc:     Yong-Xuan Wang <yongxuan.wang@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3 4/6] target/riscv: Create an KVM AIA irqchip
Date:   Fri, 26 May 2023 06:25:04 +0000
Message-Id: <20230526062509.31682-5-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230526062509.31682-1-yongxuan.wang@sifive.com>
References: <20230526062509.31682-1-yongxuan.wang@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

implement a function to create an KVM AIA chip

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Jim Shu <jim.shu@sifive.com>
---
 target/riscv/kvm.c       | 83 ++++++++++++++++++++++++++++++++++++++++
 target/riscv/kvm_riscv.h |  3 ++
 2 files changed, 86 insertions(+)

diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index eb469e8ca5..ead121154f 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -34,6 +34,7 @@
 #include "exec/address-spaces.h"
 #include "hw/boards.h"
 #include "hw/irq.h"
+#include "hw/intc/riscv_imsic.h"
 #include "qemu/log.h"
 #include "hw/loader.h"
 #include "kvm_riscv.h"
@@ -548,3 +549,85 @@ bool kvm_arch_cpu_check_are_resettable(void)
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
 }
+
+void kvm_riscv_aia_create(DeviceState *aplic_s, bool msimode, int socket,
+                          uint64_t aia_irq_num, uint64_t hart_count,
+                          uint64_t aplic_base, uint64_t imsic_base)
+{
+    int ret;
+    int aia_fd = -1;
+    uint64_t aia_mode;
+    uint64_t aia_nr_ids;
+    uint64_t aia_hart_bits = find_last_bit(&hart_count, BITS_PER_LONG) + 1;
+
+    if (!msimode) {
+        error_report("Currently KVM AIA only supports aplic_imsic mode");
+        exit(1);
+    }
+
+    aia_fd = kvm_create_device(kvm_state, KVM_DEV_TYPE_RISCV_AIA, false);
+
+    if (aia_fd < 0) {
+        error_report("Unable to create in-kernel irqchip");
+        exit(1);
+    }
+
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                            KVM_DEV_RISCV_AIA_CONFIG_MODE,
+                            &aia_mode, false, NULL);
+
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                            KVM_DEV_RISCV_AIA_CONFIG_IDS,
+                            &aia_nr_ids, false, NULL);
+
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                            KVM_DEV_RISCV_AIA_CONFIG_SRCS,
+                            &aia_irq_num, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: fail to set number input irq lines");
+        exit(1);
+    }
+
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                            KVM_DEV_RISCV_AIA_CONFIG_HART_BITS,
+                            &aia_hart_bits, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: fail to set number of harts");
+        exit(1);
+    }
+
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_ADDR,
+                            KVM_DEV_RISCV_AIA_ADDR_APLIC,
+                            &aplic_base, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: fail to set the base address of APLIC");
+        exit(1);
+    }
+
+    for (int i = 0; i < hart_count; i++) {
+        uint64_t imsic_addr = imsic_base + i * IMSIC_HART_SIZE(0);
+        ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_ADDR,
+                                KVM_DEV_RISCV_AIA_ADDR_IMSIC(i),
+                                &imsic_addr, true, NULL);
+        if (ret < 0) {
+            error_report("KVM AIA: fail to set the base address of IMSICs");
+            exit(1);
+        }
+    }
+
+    if (kvm_has_gsi_routing()) {
+        for (uint64_t idx = 0; idx < aia_irq_num + 1; ++idx) {
+            kvm_irqchip_add_irq_route(kvm_state, idx, socket, idx);
+        }
+        kvm_gsi_routing_allowed = true;
+        kvm_irqchip_commit_routes(kvm_state);
+    }
+
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CTRL,
+                            KVM_DEV_RISCV_AIA_CTRL_INIT,
+                            NULL, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: initialized fail");
+        exit(1);
+    }
+}
diff --git a/target/riscv/kvm_riscv.h b/target/riscv/kvm_riscv.h
index 606968a4b7..6067adff51 100644
--- a/target/riscv/kvm_riscv.h
+++ b/target/riscv/kvm_riscv.h
@@ -21,6 +21,9 @@
 
 void kvm_riscv_reset_vcpu(RISCVCPU *cpu);
 void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level);
+void kvm_riscv_aia_create(DeviceState *aplic_s, bool msimode, int socket,
+                          uint64_t aia_irq_num, uint64_t hart_count,
+                          uint64_t aplic_base, uint64_t imsic_base);
 
 #define KVM_DEV_RISCV_AIA_GRP_CONFIG            0
 #define KVM_DEV_RISCV_AIA_CONFIG_MODE           0
-- 
2.17.1

