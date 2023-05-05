Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D896F822F
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 13:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbjEELl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 07:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbjEELly (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 07:41:54 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B675A4C0B
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 04:41:51 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-643990c5319so975280b3a.2
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 04:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683286911; x=1685878911;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ii4ZYV8PSGVNKvQbfyi9k0H3xqXUg9ceJFhgnCWDfu8=;
        b=kP4U2BDawzzsCWyma8vDOUIzhNWCXy990Pc+gcvUHx1ErGR4FYUu/DXy6XQpT3k+b1
         MMWBPGAHFZaRRrhIrRHb12LA/WMlfQdoiSqUqISlhEyb3cU5ijXD3hv9Ny1Piy71CZ0u
         DN2KBIz8kUkvRSGARkBh8SVVz6ef6QNBRapPWUA1Bd1B5ybudxQm3A4wQQHgofudP6qH
         pfLN/6sZOUyS8S5VeP8Q4L2K3gG+dm9f29tsxECIJhMxeoNb9tfHUDulBp2nasnJYnF2
         SUkBLkQ5R4oK/A8xT5dL7PnRwC+7KSGlCFrhxFYWSLOje9VWEZTibTSbRzDKz7KNS0EA
         kPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683286911; x=1685878911;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ii4ZYV8PSGVNKvQbfyi9k0H3xqXUg9ceJFhgnCWDfu8=;
        b=auX42JtXFhdh6yM1OcEh/vlXTeP63YgI+8Uw1Zz5ThbBCzLKdMe5GvTGEqT3Hiwgpw
         Oq0kjLwghlzCSYFVRSsahY+KK94xfCqfmZZpp+ftk3hiKmAG+navOxFUYplH91M1C1aQ
         Nos9Tl+OUDNG7BuCYBJf5Bso/rejsGsNOlRZLAZicVsAby3HEFlddyO9Q/CrtuzTJfMG
         IXVoa4OkSnoVaOqxeptruZl1L9AN5pEp5uJUiSlQPmHOPkhf3XJmzB+hELh7F037laVI
         HsnNhGsR+om2xv+Mj/v3E9IjPYodlAldQWQD65idBGw6V9TnUqF3qYdXpoDW7RAKai3c
         9pqg==
X-Gm-Message-State: AC+VfDzVsw5ITqxn/3AqmSlpP1ODPOSTQvREISeMTJJ89KwwONahf2Sn
        /5RUi1w3rN0KHlrDLUrw85eGMg==
X-Google-Smtp-Source: ACHHUZ7w5YAODgkHtiWJ6WQ7avqu2+IyoPIbUxhNad9l14c8UtVKUvuStCDAshrfsUYteH1mASV8XA==
X-Received: by 2002:a05:6a00:992:b0:63b:89ba:fc9c with SMTP id u18-20020a056a00099200b0063b89bafc9cmr2095385pfg.27.1683286911179;
        Fri, 05 May 2023 04:41:51 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id y17-20020aa78051000000b0062d859a33d1sm1448171pfm.84.2023.05.05.04.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 04:41:50 -0700 (PDT)
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
Subject: [PTACH v2 4/6] target/riscv: Create an KVM AIA irqchip
Date:   Fri,  5 May 2023 11:39:39 +0000
Message-Id: <20230505113946.23433-5-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230505113946.23433-1-yongxuan.wang@sifive.com>
References: <20230505113946.23433-1-yongxuan.wang@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index ed281bdce0..d8d7256852 100644
--- a/target/riscv/kvm_riscv.h
+++ b/target/riscv/kvm_riscv.h
@@ -21,5 +21,8 @@
 
 void kvm_riscv_reset_vcpu(RISCVCPU *cpu);
 void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level);
+void kvm_riscv_aia_create(DeviceState *aplic_s, bool msimode, int socket,
+                          uint64_t aia_irq_num, uint64_t hart_count,
+                          uint64_t aplic_base, uint64_t imsic_base);
 
 #endif
-- 
2.17.1

