Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004DD6190EF
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 07:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiKDGVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 02:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiKDGVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 02:21:18 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6ACD2A43C
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 23:21:15 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n39-20020a05600c3ba700b003cf71011cddso4705560wms.1
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 23:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3gm+CCMBzGV2wY5tpR1ywTaFubhsMnT6RUSMviBRIrA=;
        b=2tmx0ZEzKlapeA40O0da60uijCZiQnnvovriTJgT3C3YW39LcGgvxSgN7m0Ms0JXRr
         D92XuuUCup3qht8mttWG9ecOOEurQnH46+r4Oaj2PNwPaCuW57yvPYegBdCMNT8MnSoU
         NOlY3X6PELYB51vtQkE4j/wGUNXLmEKjmPzkuW9/jS+OiQ316dllc8FPxAsGI0rzGUTU
         5q2tEAFlf54tRihF1fQBaPZ+jK4//Gke9zNI4MbzwaxlCrgaYBonTRPX25KVZrENs1J3
         Xow0dCWTcpfW0PdaLQ/uzBW2WBuW1Aegf7XTWh65W1L5iuGy79EZUOzhsxIypYrmCsE+
         u/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3gm+CCMBzGV2wY5tpR1ywTaFubhsMnT6RUSMviBRIrA=;
        b=gZ9gOiFQiN1rwPo9jNI/pioD742ywuN4O0V2eweKAkvh7lg1EcLinG0ezYkl7JzyNo
         pEXvYqqrd+fTPGQCCWsxEL/acCxjWntt1u82PqOFZbRMNgPTcDwD7AeWcZlS6uHBUkFO
         y7zkc36JSGYRThrscnDaAvJ1PMeHiZ4zXGr4whnMxMZO3YiNCF5tGA4oRI659GsPsaLY
         P6bWJo+i3Fi6YmqMKTNLkNOXMjLXhWHixx+xq7NyUy+yj/17HhMu10o80ZQlFgEkZGab
         YLmUgq6CKKxQ+Tirq6uf90McGIXG/CRO5VdDgh1ktLui/BpujavKfpT0qaGXGKgeljah
         XNEA==
X-Gm-Message-State: ACrzQf03V50QO15CaE9MKT1N9OhB6y24dnj+TfToIMdN57bzCH++0ZeF
        Nx/0+UR1hy2fgo2gnfiil4bJhQ==
X-Google-Smtp-Source: AMsMyM7cP7o2Mb3eYYy1AVu03sQGOtx3okUtdbwIqzpIe6O5ZDxr+oIbMBpI7JrFVBYNndSa4ueUzw==
X-Received: by 2002:a05:600c:3b87:b0:3cf:59ea:ea26 with SMTP id n7-20020a05600c3b8700b003cf59eaea26mr26647184wms.159.1667542875338;
        Thu, 03 Nov 2022 23:21:15 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b4d7:0:c7c:f931:dd4c:1ea6])
        by smtp.gmail.com with ESMTPSA id w11-20020a5d608b000000b002366f9bd717sm3099924wrt.45.2022.11.03.23.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 23:21:14 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        bagasdotme@gmail.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [v2 2/6] KVM: arm64: Add SMCCC paravirtualised lock calls
Date:   Fri,  4 Nov 2022 06:21:01 +0000
Message-Id: <20221104062105.4119003-3-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104062105.4119003-1-usama.arif@bytedance.com>
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new SMCCC compatible hypercalls for PV lock features:
  ARM_SMCCC_KVM_FUNC_PV_LOCK:   0xC6000002

Also add the header file which defines the ABI for the paravirtualized
lock features we're about to add.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/arm64/include/asm/pvlock-abi.h | 17 +++++++++++++++++
 include/linux/arm-smccc.h           |  8 ++++++++
 tools/include/linux/arm-smccc.h     |  8 ++++++++
 3 files changed, 33 insertions(+)
 create mode 100644 arch/arm64/include/asm/pvlock-abi.h

diff --git a/arch/arm64/include/asm/pvlock-abi.h b/arch/arm64/include/asm/pvlock-abi.h
new file mode 100644
index 000000000000..3f4574071679
--- /dev/null
+++ b/arch/arm64/include/asm/pvlock-abi.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright(c) 2019 Huawei Technologies Co., Ltd
+ * Author: Zengruan Ye <yezengruan@huawei.com>
+ *         Usama Arif <usama.arif@bytedance.com>
+ */
+
+#ifndef __ASM_PVLOCK_ABI_H
+#define __ASM_PVLOCK_ABI_H
+
+struct pvlock_vcpu_state {
+	__le64 preempted;
+	/* Structure must be 64 byte aligned, pad to that size */
+	u8 padding[56];
+} __packed;
+
+#endif
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 220c8c60e021..104c10035b10 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -112,6 +112,7 @@
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
 #define ARM_SMCCC_KVM_FUNC_PTP			1
+#define ARM_SMCCC_KVM_FUNC_PV_LOCK		2
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -151,6 +152,13 @@
 			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
 			   0x21)
 
+/* Paravirtualised lock calls */
+#define ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,		\
+			   ARM_SMCCC_KVM_FUNC_PV_LOCK)
+
 /* TRNG entropy source calls (defined by ARM DEN0098) */
 #define ARM_SMCCC_TRNG_VERSION					\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
diff --git a/tools/include/linux/arm-smccc.h b/tools/include/linux/arm-smccc.h
index 63ce9bebccd3..c21e539c0228 100644
--- a/tools/include/linux/arm-smccc.h
+++ b/tools/include/linux/arm-smccc.h
@@ -111,6 +111,7 @@
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
 #define ARM_SMCCC_KVM_FUNC_PTP			1
+#define ARM_SMCCC_KVM_FUNC_PV_LOCK		2
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -150,6 +151,13 @@
 			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
 			   0x21)
 
+/* Paravirtualised lock calls */
+#define ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,		\
+			   ARM_SMCCC_KVM_FUNC_PV_LOCK)
+
 /* TRNG entropy source calls (defined by ARM DEN0098) */
 #define ARM_SMCCC_TRNG_VERSION					\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
-- 
2.25.1

