Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D34753548
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 10:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbjGNIpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 04:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235605AbjGNIow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 04:44:52 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E762699
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 01:44:49 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-666e6ecb52dso1123680b3a.2
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 01:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1689324289; x=1691916289;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2XDNJKyAvtlMIxb4++NMoTqb5GVA3Hsp0wi4yzu5NTQ=;
        b=GuxYu3zXFOkZiqFA8G7RJQJ8UFYijTpxAPcBG0OLyrYFaX9T7j51Bt/POIIohde9HC
         oaGcD/KEdjYPvsuZiuruvA+EAQ+ESxDrfAQRTmbvXotZXbbj0rS9vM1FwmzIT12eavvg
         IiBAgwQy3mT0nnr557DzNqyFL2g0Psvos87SYidWoNEswqkGxIDMg6Bd9p6zpC0UnbiB
         1hQ/8EMwuv1OUsiqCKFziMf77E/wMvwxfZhdNx5jr7VouobOWfL4FXEgD68MOn7OwORQ
         0g/gVTYNkCjHEyEZZEFhKgZ+zAxWwht6R14M/yMhZd4jG4Daw53HCOYXTwz/5R9IZvlQ
         Hrlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689324289; x=1691916289;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2XDNJKyAvtlMIxb4++NMoTqb5GVA3Hsp0wi4yzu5NTQ=;
        b=A74q2bTKJZAQ3nymXHqAL5QuGwmiAvJ8Qovl2DWKNFNrQQuUAez1xtP0U4Gd7GGsqq
         n94qcGKNT09ehsi+EyAzKVR63bNOKxYkrUop5EDiKhVPdGU2m96zEfkRTKNTsrbJA5rm
         rGIEt4hIrDn/N4vFlMw/DTwZBCnPApSFB4hxGydU8nRkfauOvgo1GHJWfXTejg+7jlyD
         dj9i2Pvyemr8DIe105GDDE3z4zagFDQlzocb0t6oDIst+iKzDFUQZszhtyHyr4LSWQOu
         3DnmQ18dOd3xQR+xE3XAtOL4qsObVudClnune40iLZ5w69A7Mo4rc/F5IblbXSDhyJRE
         1V/Q==
X-Gm-Message-State: ABy/qLahT7H5Om4SFVnMCmmfOG7ZwN53Ghcpy8MxiECgcLCUiF9IwyNB
        SDOvXx46Qrh7sZTTXZWKCPMjGg==
X-Google-Smtp-Source: APBJJlGmJje7SuvaH3FUCQ9C6hayS/etgeEzN5RNp0WH8Fi2Ie5rRdCGnZ0+dSDZpltqiFjm/zwLDg==
X-Received: by 2002:a05:6a00:999:b0:667:85e6:4e9 with SMTP id u25-20020a056a00099900b0066785e604e9mr3923415pfg.24.1689324288635;
        Fri, 14 Jul 2023 01:44:48 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id c19-20020aa781d3000000b006829b28b393sm6616305pfn.199.2023.07.14.01.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jul 2023 01:44:48 -0700 (PDT)
From:   Yong-Xuan Wang <yongxuan.wang@sifive.com>
To:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org
Cc:     rkanwal@rivosinc.com, anup@brainfault.org,
        dbarboza@ventanamicro.com, ajones@ventanamicro.com,
        atishp@atishpatra.org, vincent.chen@sifive.com,
        greentime.hu@sifive.com, frank.chang@sifive.com,
        jim.shu@sifive.com, Yong-Xuan Wang <yongxuan.wang@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v6 3/5] target/riscv: Create an KVM AIA irqchip
Date:   Fri, 14 Jul 2023 08:44:25 +0000
Message-Id: <20230714084429.22349-4-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230714084429.22349-1-yongxuan.wang@sifive.com>
References: <20230714084429.22349-1-yongxuan.wang@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We create a vAIA chip by using the KVM_DEV_TYPE_RISCV_AIA and then set up
the chip with the KVM_DEV_RISCV_AIA_GRP_* APIs.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Jim Shu <jim.shu@sifive.com>
Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 target/riscv/kvm.c       | 160 +++++++++++++++++++++++++++++++++++++++
 target/riscv/kvm_riscv.h |   6 ++
 2 files changed, 166 insertions(+)

diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 005e054604..9bc92cedff 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -36,6 +36,7 @@
 #include "exec/address-spaces.h"
 #include "hw/boards.h"
 #include "hw/irq.h"
+#include "hw/intc/riscv_imsic.h"
 #include "qemu/log.h"
 #include "hw/loader.h"
 #include "kvm_riscv.h"
@@ -43,6 +44,7 @@
 #include "chardev/char-fe.h"
 #include "migration/migration.h"
 #include "sysemu/runstate.h"
+#include "hw/riscv/numa.h"
 
 static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type,
                                  uint64_t idx)
@@ -1026,3 +1028,161 @@ bool kvm_arch_cpu_check_are_resettable(void)
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
+        return "emul";
+    case KVM_DEV_RISCV_AIA_MODE_HWACCEL:
+        return "hwaccel";
+    case KVM_DEV_RISCV_AIA_MODE_AUTO:
+    default:
+        return "auto";
+    };
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
+        error_report("KVM AIA: failed to get current KVM AIA mode");
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
+            warn_report("KVM AIA: failed to set KVM AIA mode");
+        else
+            qemu_log("KVM AIA: set current mode to %s\n",
+                     kvm_aia_mode_str(aia_mode));
+    }
+
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                            KVM_DEV_RISCV_AIA_CONFIG_SRCS,
+                            &aia_irq_num, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: failed to set number of input irq lines");
+        exit(1);
+    }
+
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                            KVM_DEV_RISCV_AIA_CONFIG_IDS,
+                            &aia_msi_num, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: failed to set number of msi");
+        exit(1);
+    }
+
+    socket_bits = find_last_bit(&socket_count, BITS_PER_LONG) + 1;
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                            KVM_DEV_RISCV_AIA_CONFIG_GROUP_BITS,
+                            &socket_bits, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: failed to set group_bits");
+        exit(1);
+    }
+
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                            KVM_DEV_RISCV_AIA_CONFIG_GROUP_SHIFT,
+                            &group_shift, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: failed to set group_shift");
+        exit(1);
+    }
+
+    guest_bits = guest_num == 0 ? 0 :
+                 find_last_bit(&guest_num, BITS_PER_LONG) + 1;
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
+                            KVM_DEV_RISCV_AIA_CONFIG_GUEST_BITS,
+                            &guest_bits, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: failed to set guest_bits");
+        exit(1);
+    }
+
+    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_ADDR,
+                            KVM_DEV_RISCV_AIA_ADDR_APLIC,
+                            &aplic_base, true, NULL);
+    if (ret < 0) {
+        error_report("KVM AIA: failed to set the base address of APLIC");
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
+                error_report("KVM AIA: failed to set the IMSIC address for hart %d", i);
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
+        error_report("KVM AIA: failed to set hart_bits");
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
+
+    kvm_msi_via_irqfd_allowed = kvm_irqfds_enabled();
+}
diff --git a/target/riscv/kvm_riscv.h b/target/riscv/kvm_riscv.h
index e3ba935808..c6745dd29a 100644
--- a/target/riscv/kvm_riscv.h
+++ b/target/riscv/kvm_riscv.h
@@ -22,5 +22,11 @@
 void kvm_riscv_init_user_properties(Object *cpu_obj);
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

