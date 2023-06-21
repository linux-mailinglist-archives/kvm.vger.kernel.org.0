Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE63873884D
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 17:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjFUPCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 11:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbjFUPCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 11:02:09 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86B26A75
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 07:56:27 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6686ef86110so2349847b3a.2
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 07:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1687359329; x=1689951329;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rfvkhigauytI2tjbNgIGB6WmnYUlmn4JRlTwDfO8B1w=;
        b=CzgB9upPl2ZNXngla3XuooP7eutN/+lSMrU4JRoLZyll/m1Xv48qKLHC36V8/OI0Ea
         aKGO8VZs/+EJQuA95a91LaAynw+UcX1Htu1QX8P9LhDNtUtex27Xgurv0Lgp+W3BqayN
         8MytlGrOQ2A2XRYWWOJyrAG9X1ahYNpbg2Uw1jbcU9K4xdYCBp0IHGOAgI+9hJokMvMl
         /nW1t+dOAxuKe2g1djLep7Xyasf/3OOagKXE7SsoR0Po6K9CcUhzbtki7wS1opGXVVRY
         oAaZA/ATIQNFzAweF/xr9CWfasAKizQxLLKmNWn7QjmP0V5JHvMnptvNkb5KWp+peCeU
         uI7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687359329; x=1689951329;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rfvkhigauytI2tjbNgIGB6WmnYUlmn4JRlTwDfO8B1w=;
        b=U6yGpOVMqcKqeprb6O8UQuXdq8+AhUkFyQTy1bTFYrtfkmV6bXOHlZxsZetwcBIv7T
         9OIOdshE2KJNiux06TDnfJB70tDDZEHhYyWrvnvSIGpBlzwVATuJLiiVbm17uhqWOTPB
         oXW19PijEVxsE8ZavOjC/ZL/vvzeIna3kjiq1e77KZiLuVUnnQ63gsaekAdAcXr930Ve
         bAGS7aEi60/hOf3ziNW9acSUyWKovpxBPlPxNwt1my6z4V0upHdxKk/Kgch+CKr4D0Lb
         4YDF92cT3LT8slgrBcsP0F/kTSbtpqY08twf7RAHCE13qXczc9a9pTHIibOUPKvAYv6z
         tVzQ==
X-Gm-Message-State: AC+VfDySiY7xMM5zSn2nu+WbewT956u9nAHLijec3l8asQ8bpCxyrKbC
        t/hZpvvbXxTgHI85ekEEJCmwUQ==
X-Google-Smtp-Source: ACHHUZ7fL/tfXH/t9EaoJgMaBeh5FyCeWn21G846Bl8Z9u/HND08sKxUwSFc6+GwEEo5wD1pGuVytg==
X-Received: by 2002:a05:6a20:7347:b0:111:ee3b:59b1 with SMTP id v7-20020a056a20734700b00111ee3b59b1mr12803623pzc.2.1687359328870;
        Wed, 21 Jun 2023 07:55:28 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id v8-20020a62a508000000b0066a4e561beesm356762pfm.173.2023.06.21.07.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 07:55:28 -0700 (PDT)
From:   Yong-Xuan Wang <yongxuan.wang@sifive.com>
To:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org
Cc:     rkanwal@rivosinc.com, anup@brainfault.org,
        dbarboza@ventanamicro.com, atishp@atishpatra.org,
        vincent.chen@sifive.com, greentime.hu@sifive.com,
        frank.chang@sifive.com, jim.shu@sifive.com,
        Yong-Xuan Wang <yongxuan.wang@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v4 4/6] target/riscv: Create an KVM AIA irqchip
Date:   Wed, 21 Jun 2023 14:54:54 +0000
Message-Id: <20230621145500.25624-5-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230621145500.25624-1-yongxuan.wang@sifive.com>
References: <20230621145500.25624-1-yongxuan.wang@sifive.com>
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
 target/riscv/kvm.c       | 163 +++++++++++++++++++++++++++++++++++++++
 target/riscv/kvm_riscv.h |   6 ++
 2 files changed, 169 insertions(+)

diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index eb469e8ca5..3dd8467031 100644
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
@@ -41,6 +42,7 @@
 #include "chardev/char-fe.h"
 #include "migration/migration.h"
 #include "sysemu/runstate.h"
+#include "hw/riscv/numa.h"
 
 static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type,
                                  uint64_t idx)
@@ -548,3 +550,164 @@ bool kvm_arch_cpu_check_are_resettable(void)
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
 }
+
+char *kvm_aia_mode_str(uint64_t aia_mode)
+{
+    const char *val;
+
+    switch (aia_mode) {
+    case KVM_DEV_RISCV_AIA_MODE_EMUL:
+        val = "emul";
+        break;
+    case KVM_DEV_RISCV_AIA_MODE_HWACCEL:
+        val = "hwaccel";
+        break;
+    case KVM_DEV_RISCV_AIA_MODE_AUTO:
+    default:
+        val = "auto";
+        break;
+    };
+
+    return g_strdup(val);
+}
+
+void kvm_riscv_aia_create(MachineState *machine,
+                          uint64_t aia_mode, uint64_t group_shift,
+                          uint64_t aia_irq_num, uint64_t aia_msi_num,
+                          uint64_t aplic_base, uint64_t imsic_base,
+                          uint64_t guest_num)
+{
+    int ret, i;
+    int aia_fd = -1;
+    uint64_t default_aia_mode;
+    uint64_t socket_count = riscv_socket_count(machine);
+    uint64_t max_hart_per_socket = 0;
+    uint64_t socket, base_hart, hart_count, socket_imsic_base, imsic_addr;
+    uint64_t socket_bits, hart_bits, guest_bits;
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
+                            &default_aia_mode, false, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: fail to get current KVM AIA mode");
+        exit(1);
+    }
+    qemu_log("KVM AIA: default mode is %s\n",
+             kvm_aia_mode_str(default_aia_mode));
+
+    if (default_aia_mode != aia_mode) {
+        ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                                KVM_DEV_RISCV_AIA_CONFIG_MODE,
+                                &aia_mode, true, NULL);
+        if (ret < 0)
+            warn_report("KVM AIA: fail to set KVM AIA mode");
+        else
+            qemu_log("KVM AIA: set current mode to %s\n",
+                     kvm_aia_mode_str(aia_mode));
+    }
+
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                            KVM_DEV_RISCV_AIA_CONFIG_SRCS,
+                            &aia_irq_num, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: fail to set number of input irq lines");
+        exit(1);
+    }
+
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                            KVM_DEV_RISCV_AIA_CONFIG_IDS,
+                            &aia_msi_num, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: fail to set number of msi");
+        exit(1);
+    }
+
+    socket_bits = find_last_bit(&socket_count, BITS_PER_LONG) + 1;
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                            KVM_DEV_RISCV_AIA_CONFIG_GROUP_BITS,
+                            &socket_bits, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: fail to set group_bits");
+        exit(1);
+    }
+
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                            KVM_DEV_RISCV_AIA_CONFIG_GROUP_SHIFT,
+                            &group_shift, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: fail to set group_shift");
+        exit(1);
+    }
+
+    guest_bits = guest_num == 0 ? 0 :
+                 find_last_bit(&guest_num, BITS_PER_LONG) + 1;
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                            KVM_DEV_RISCV_AIA_CONFIG_GUEST_BITS,
+                            &guest_bits, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: fail to set guest_bits");
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
+    for (socket = 0; socket < socket_count; socket++) {
+        socket_imsic_base = imsic_base + socket * (1U << group_shift);
+        hart_count = riscv_socket_hart_count(machine, socket);
+        base_hart = riscv_socket_first_hartid(machine, socket);
+
+        if (max_hart_per_socket < hart_count) {
+            max_hart_per_socket = hart_count;
+        }
+
+        for (i = 0; i < hart_count; i++) {
+            imsic_addr = socket_imsic_base + i * IMSIC_HART_SIZE(guest_bits);
+            ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_ADDR,
+                                    KVM_DEV_RISCV_AIA_ADDR_IMSIC(i + base_hart),
+                                    &imsic_addr, true, NULL);
+            if (ret < 0) {
+                error_report("KVM AIA: fail to set the address of IMSICs");
+                exit(1);
+            }
+        }
+    }
+
+    hart_bits = find_last_bit(&max_hart_per_socket, BITS_PER_LONG) + 1;
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                            KVM_DEV_RISCV_AIA_CONFIG_HART_BITS,
+                            &hart_bits, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: fail to set hart_bits");
+        exit(1);
+    }
+
+    if (kvm_has_gsi_routing()) {
+        for (uint64_t idx = 0; idx < aia_irq_num + 1; ++idx) {
+            /* KVM AIA only has one APLIC instance */
+            kvm_irqchip_add_irq_route(kvm_state, idx, 0, idx);
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
index ed281bdce0..a61f552d1d 100644
--- a/target/riscv/kvm_riscv.h
+++ b/target/riscv/kvm_riscv.h
@@ -21,5 +21,11 @@
 
 void kvm_riscv_reset_vcpu(RISCVCPU *cpu);
 void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level);
+char *kvm_aia_mode_str(uint64_t aia_mode);
+void kvm_riscv_aia_create(MachineState *machine,
+                          uint64_t aia_mode, uint64_t group_shift,
+                          uint64_t aia_irq_num, uint64_t aia_msi_num,
+                          uint64_t aplic_base, uint64_t imsic_base,
+                          uint64_t guest_num);
 
 #endif
-- 
2.17.1

