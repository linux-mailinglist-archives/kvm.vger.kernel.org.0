Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9ED86EC85F
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 11:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbjDXJHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 05:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbjDXJHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 05:07:34 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B33E79
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 02:07:32 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-51f597c975fso4457383a12.0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 02:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1682327252; x=1684919252;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5z/8lGR1AkQIcHq/8iqR9nQgXil5d7VQ8a2hbIgNp0E=;
        b=fDfm2ZTFk1o8gSk8alCzqUgJwDAVAv2wdNYqSiaJ+7votKR76jVnlbsXLQtgLx9EHn
         kzR7hYACAbNCXwemqwPWuUr6uCpHmTur+PiamI+wxb0ymmRzsESVmD7kRSpEK82zpiWD
         nIUcThnq+xeMOFt0QKX/KVdNbhVPMxXDl8FEJFmWMNuXR2ldmEBW+sWUkYGXBHoKBllj
         XfB1JH/aFTa0bAOQDC+z+IIvK7gjCUWCr+YZUO7ywf5sXoQC3zcFxBW5KpbavpvubAEc
         bBxqloGOoHupMMYC7ARkIgQIS4j7/aS20RLxh9eYXkEZXkPuZcJZF1zlOZFyWgAiI7qn
         yttg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682327252; x=1684919252;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5z/8lGR1AkQIcHq/8iqR9nQgXil5d7VQ8a2hbIgNp0E=;
        b=c+9z3xD5XRtqGYV+63OOZ0Nz9ZLLKnkeRVlMcglXDBkwnas/o0xTFTIQAw5dZhJyjO
         fGJqz/AB/j1GSIeRKlIAw5cmVOcawak9oC0FugZKKd14uTUtMLnAsxvfXfYjFRCc+dEs
         K5VyY7Zp4s7RKeqSLoEnuOVI7QoqDt6p4SBF9Rkoz2Jgt6EM/MQ4rlDvaugYlol+OULc
         /IHK4zyrEIi89KogVuOa+XiW8NKV8yhi8ZB9GApK2Uhl1lNkcmq9UZi2Ph7zkvJyt2My
         pwLaasmzRu3IM8WQTKgdRA6u4z4nAXm6ywEo0I6vv2hhikPgzsdp0dC9ESmLC5udOXrL
         iJCA==
X-Gm-Message-State: AAQBX9eJRbJdjZN6Xo/ZdXjgqqD6NcqnrroZvCFloHQYKP/s3CsXi4LW
        Bg2K+3iyz/6SCb/eVkjvvVuhZw==
X-Google-Smtp-Source: AKy350az9guWfDiaJa9jsO+Oh2dtSwmH48lLWeKBR5zQJpQdM0tMgNFkLexzfrSCyCLpKEk42BfStw==
X-Received: by 2002:a17:903:245:b0:1a5:f9b:27bd with SMTP id j5-20020a170903024500b001a50f9b27bdmr15188504plh.34.1682327252143;
        Mon, 24 Apr 2023 02:07:32 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jf2-20020a170903268200b001a207906418sm6234820plb.23.2023.04.24.02.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 02:07:31 -0700 (PDT)
From:   Yong-Xuan Wang <yongxuan.wang@sifive.com>
To:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org
Cc:     rkanwal@rivosinc.com, anup@brainfault.org,
        dbarboza@ventanamicro.com, atishp@atishpatra.org,
        vincent.chen@sifive.com, greentime.hu@sifive.com,
        frank.chang@sifive.com, Yong-Xuan Wang <yongxuan.wang@sifive.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Thomas Huth <thuth@redhat.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH 1/6] update-linux-headers: sync-up header with Linux for KVM AIA support
Date:   Mon, 24 Apr 2023 09:07:03 +0000
Message-Id: <20230424090716.15674-2-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230424090716.15674-1-yongxuan.wang@sifive.com>
References: <20230424090716.15674-1-yongxuan.wang@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sync-up Linux header to get latest KVM RISC-V headers having AIA support.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Jim Shu <jim.shu@sifive.com>
---
 linux-headers/linux/kvm.h |  2 ++
 target/riscv/kvm_riscv.h  | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index ebdafa576d..316732a617 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1426,6 +1426,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
 	KVM_DEV_TYPE_ARM_PV_TIME,
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
+	KVM_DEV_TYPE_RISCV_AIA,
+#define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
 	KVM_DEV_TYPE_MAX,
 };
 
diff --git a/target/riscv/kvm_riscv.h b/target/riscv/kvm_riscv.h
index ed281bdce0..606968a4b7 100644
--- a/target/riscv/kvm_riscv.h
+++ b/target/riscv/kvm_riscv.h
@@ -22,4 +22,37 @@
 void kvm_riscv_reset_vcpu(RISCVCPU *cpu);
 void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level);
 
+#define KVM_DEV_RISCV_AIA_GRP_CONFIG            0
+#define KVM_DEV_RISCV_AIA_CONFIG_MODE           0
+#define KVM_DEV_RISCV_AIA_CONFIG_IDS            1
+#define KVM_DEV_RISCV_AIA_CONFIG_SRCS           2
+#define KVM_DEV_RISCV_AIA_CONFIG_GROUP_BITS     3
+#define KVM_DEV_RISCV_AIA_CONFIG_GROUP_SHIFT    4
+#define KVM_DEV_RISCV_AIA_CONFIG_HART_BITS      5
+#define KVM_DEV_RISCV_AIA_CONFIG_GUEST_BITS     6
+#define KVM_DEV_RISCV_AIA_MODE_EMUL             0
+#define KVM_DEV_RISCV_AIA_MODE_HWACCEL          1
+#define KVM_DEV_RISCV_AIA_MODE_AUTO             2
+#define KVM_DEV_RISCV_AIA_IDS_MIN               63
+#define KVM_DEV_RISCV_AIA_IDS_MAX               2048
+#define KVM_DEV_RISCV_AIA_SRCS_MAX              1024
+#define KVM_DEV_RISCV_AIA_GROUP_BITS_MAX        8
+#define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MIN       24
+#define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MAX       56
+#define KVM_DEV_RISCV_AIA_HART_BITS_MAX         16
+#define KVM_DEV_RISCV_AIA_GUEST_BITS_MAX        8
+
+#define KVM_DEV_RISCV_AIA_GRP_ADDR              1
+#define KVM_DEV_RISCV_AIA_ADDR_APLIC            0
+#define KVM_DEV_RISCV_AIA_ADDR_IMSIC(__vcpu)    (1 + (__vcpu))
+#define KVM_DEV_RISCV_AIA_ADDR_MAX              \
+        (1 + KVM_DEV_RISCV_APLIC_MAX_HARTS)
+
+#define KVM_DEV_RISCV_AIA_GRP_CTRL              2
+#define KVM_DEV_RISCV_AIA_CTRL_INIT             0
+
+#define KVM_DEV_RISCV_AIA_GRP_APLIC             3
+
+#define KVM_DEV_RISCV_AIA_GRP_IMSIC             4
+
 #endif
-- 
2.17.1

