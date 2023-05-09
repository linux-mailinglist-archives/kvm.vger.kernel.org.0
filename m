Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC67E6FC3E4
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbjEIKbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235187AbjEIKbc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:31:32 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B6CDC7A
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 03:31:30 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1ab1b79d3a7so38938345ad.3
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 03:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683628290; x=1686220290;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HI4TRg2cuwYEsvBzmibkE9/BpJFs4hKp38ctSqfVtcI=;
        b=V+hcuVqSf3DOnNLL9zUwE4nn72OzWJhKaI5ymGHd8DnVmthAG5WaVmjgu/966048s6
         VUvhUfxiyeQdOO7ElI3t1hidGZaI19x7wWqA4wGHL1ZNfnBqv/p3iSErW3fxn0zugI1P
         0FoVXf95WCjaZJZZEv/HkhPxCPj+arzTKg5mKBodJM4IfrIjqnYSwKNosXDIFZGmMAO/
         /5TrHdjpjp+IUXiCGW6Pf43nmfCAhMIa2PHU9qNX4eTQGKILlUQLIpMG5ZhjPXtHO9lX
         hBk7xK9LhpN+oG5TgJzNebaHDCQIQ41mM1b4lZ/o0P7W+1PiNynjtZu06GQ4t28jLRkA
         zgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628290; x=1686220290;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HI4TRg2cuwYEsvBzmibkE9/BpJFs4hKp38ctSqfVtcI=;
        b=Iv9R2Z+KJFlwinCn2bDXms5v1DIw33NoXdr6IWVXXnIhiYjFJHnrk1Zx+43ofRJY53
         YZtlKjvwCyI/NFMBxtV0iK6UgXLRrqBtoxi8GQmxC8xQyg635vf+7FthJVbnkmHujI49
         fJCFTZOGj85BwxXZoAg2PBdSsoCLPMLsE7sU+pr9v4Knl7POc6/HeIYkm1322UU6Hq1a
         c2nOHiBwR5dbGVp4gXOsxos7swHKpormnJ/yu7N7sBe9F0rMVKZc1hL9zRgzgTC0Ja4v
         5TY4vsY8Rk1NITZodXCjVGuDs5RyN1ta6I4upPqzualYVztvwuE1xKB9YPJzKsiRczoD
         GDbw==
X-Gm-Message-State: AC+VfDy9ItGITHPY9373gmzbvJYz7HvB+d5mHu/ImX+XQQLxeWsgvUnD
        vrD7M8NODGYoAa6p7jcp3iAJyQ==
X-Google-Smtp-Source: ACHHUZ4yDs51/jrzt305XFV64RxEA67yxjmxZFxFkfsTsm5LIVITSI6vKK9EGNi++sY/Px+1AIGeog==
X-Received: by 2002:a17:902:b78a:b0:1aa:d9c5:9cd5 with SMTP id e10-20020a170902b78a00b001aad9c59cd5mr13572335pls.11.1683628290049;
        Tue, 09 May 2023 03:31:30 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b001a076025715sm1195191plg.117.2023.05.09.03.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:31:29 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Evan Green <evan@rivosinc.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Celeste Liu <coelacanthus@outlook.com>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: [PATCH -next v19 03/24] riscv: hwprobe: Add support for RISCV_HWPROBE_BASE_BEHAVIOR_V
Date:   Tue,  9 May 2023 10:30:12 +0000
Message-Id: <20230509103033.11285-4-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230509103033.11285-1-andy.chiu@sifive.com>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Probing kernel support for Vector extension is available now.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 Documentation/riscv/hwprobe.rst       | 10 ++++++++++
 arch/riscv/include/asm/hwprobe.h      |  2 +-
 arch/riscv/include/uapi/asm/hwprobe.h |  3 +++
 arch/riscv/kernel/sys_riscv.c         |  9 +++++++++
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/Documentation/riscv/hwprobe.rst b/Documentation/riscv/hwprobe.rst
index 9f0dd62dcb5d..b8755e180fbf 100644
--- a/Documentation/riscv/hwprobe.rst
+++ b/Documentation/riscv/hwprobe.rst
@@ -53,6 +53,9 @@ The following keys are defined:
       programs (it may still be executed in userspace via a
       kernel-controlled mechanism such as the vDSO).
 
+  * :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_V`: Support for Vector extension, as
+    defined by verion 1.0 of the RISC-V Vector extension.
+
 * :c:macro:`RISCV_HWPROBE_KEY_IMA_EXT_0`: A bitmask containing the extensions
   that are compatible with the :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_IMA`:
   base system behavior.
@@ -64,6 +67,13 @@ The following keys are defined:
   * :c:macro:`RISCV_HWPROBE_IMA_C`: The C extension is supported, as defined
     by version 2.2 of the RISC-V ISA manual.
 
+* :c:macro:`RISCV_HWPROBE_KEY_V_EXT_0`: A bitmask containing the extensions
+   that are compatible with the :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_V`: base
+   system behavior.
+
+  * :c:macro:`RISCV_HWPROBE_V`: The V extension is supported, as defined by
+    version 1.0 of the RISC-V Vector extension manual.
+
 * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
   information about the selected set of processors.
 
diff --git a/arch/riscv/include/asm/hwprobe.h b/arch/riscv/include/asm/hwprobe.h
index 78936f4ff513..39df8604fea1 100644
--- a/arch/riscv/include/asm/hwprobe.h
+++ b/arch/riscv/include/asm/hwprobe.h
@@ -8,6 +8,6 @@
 
 #include <uapi/asm/hwprobe.h>
 
-#define RISCV_HWPROBE_MAX_KEY 5
+#define RISCV_HWPROBE_MAX_KEY 6
 
 #endif
diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index 8d745a4ad8a2..93a7fd3fd341 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -22,6 +22,7 @@ struct riscv_hwprobe {
 #define RISCV_HWPROBE_KEY_MIMPID	2
 #define RISCV_HWPROBE_KEY_BASE_BEHAVIOR	3
 #define		RISCV_HWPROBE_BASE_BEHAVIOR_IMA	(1 << 0)
+#define		RISCV_HWPROBE_BASE_BEHAVIOR_V	(1 << 1)
 #define RISCV_HWPROBE_KEY_IMA_EXT_0	4
 #define		RISCV_HWPROBE_IMA_FD		(1 << 0)
 #define		RISCV_HWPROBE_IMA_C		(1 << 1)
@@ -32,6 +33,8 @@ struct riscv_hwprobe {
 #define		RISCV_HWPROBE_MISALIGNED_FAST		(3 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_UNSUPPORTED	(4 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_MASK		(7 << 0)
+#define RISCV_HWPROBE_KEY_V_EXT_0	6
+#define		RISCV_HWPROBE_V			(1 << 0)
 /* Increase RISCV_HWPROBE_MAX_KEY when adding items. */
 
 #endif
diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.c
index 5db29683ebee..6280a7f778b3 100644
--- a/arch/riscv/kernel/sys_riscv.c
+++ b/arch/riscv/kernel/sys_riscv.c
@@ -10,6 +10,7 @@
 #include <asm/cpufeature.h>
 #include <asm/hwprobe.h>
 #include <asm/sbi.h>
+#include <asm/vector.h>
 #include <asm/switch_to.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -161,6 +162,7 @@ static void hwprobe_one_pair(struct riscv_hwprobe *pair,
 	 */
 	case RISCV_HWPROBE_KEY_BASE_BEHAVIOR:
 		pair->value = RISCV_HWPROBE_BASE_BEHAVIOR_IMA;
+		pair->value |= RISCV_HWPROBE_BASE_BEHAVIOR_V;
 		break;
 
 	case RISCV_HWPROBE_KEY_IMA_EXT_0:
@@ -173,6 +175,13 @@ static void hwprobe_one_pair(struct riscv_hwprobe *pair,
 
 		break;
 
+	case RISCV_HWPROBE_KEY_V_EXT_0:
+		pair->value = 0;
+		if (has_vector())
+			pair->value |= RISCV_HWPROBE_V;
+
+		break;
+
 	case RISCV_HWPROBE_KEY_CPUPERF_0:
 		pair->value = hwprobe_misaligned(cpus);
 		break;
-- 
2.17.1

