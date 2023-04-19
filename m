Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37776E856F
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbjDSW6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233765AbjDSW6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:58:15 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881BC9EFE
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:57:46 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id o2so943350uao.11
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681945063; x=1684537063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wI5JEqEayPS5t0DearmNB32dGieY2Rp85qRqyRU4954=;
        b=oBaO1gGAq5VShR7JdGsFxiI0UU2MLeNbLcoorvcGS/xmLKw9GaRbBSWp1eIpGI5Ruf
         DPb4IrkLsDVLMJLRIMkoq3OWraz1NnoPqDPzuE5Qd8Ll1kBDIOm8t3DPSgCHe6kcfdk8
         QxKSH6E1JMlCHFknxamvJnKzhcrobhsEVvFAfR/0vVmO6Go676yxlsPXNuW8TLyD35bO
         B3VbU9VYsQUqCHOkqNuPFU+6BFN5wl62deglp2BnwuGBiTCp0eqppiZ41oqi0F+9RtP8
         /s/tIHATI3sgNQg+GizJvSuZQ6VbaCc05k4DIyBJ+0kM+zs4cpshBWXfIcWm61U6DH5H
         Sn7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681945063; x=1684537063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wI5JEqEayPS5t0DearmNB32dGieY2Rp85qRqyRU4954=;
        b=IcmVobBBX/1cIGNflAz8zAxnLpdFVU/OBy9R+f4sXyUF0Z9wUaNCKHeeVV39QQn2go
         ZXAMwX8l47V9Ilfkdv28BhFjiCtHlCGz+CYN53BWtgXOWL+bcOXpzsyLX4QsEwLsNBho
         iwEgBTfuoTQqO3NtaN/1A1YsHWe4yvf2zvKq6XqF9yGTFniAx4zWnBTR31CA6ehZ+2EO
         Ux9Mnq1r+tCm75GW37fyY/pUXyU2EFbcR5t58/zG+Ce9qLY0oJjWKZzjcz4tlIjIhuv9
         ugquJ3AIVKXOuCmvrFMoCgP/SyxUja0LS8ExoRHpZBWAS9aVO99aQKYgZtkyOYTlk638
         q7ng==
X-Gm-Message-State: AAQBX9e2BfTRec1JTa2PVKeP5wnirtjC9ugIqLbpnHdneMva88OdFFIs
        fWnKq/PPvHMf/6ZAIhVYOlmSCtOhbuD/5FpgWeI=
X-Google-Smtp-Source: AKy350bHPqgey3c6g8HqkR9B9xlgHTWq+fR92XQNeVK1lT0G63M1RyCGum2kegw8LaA3eJtSnsnKXQ==
X-Received: by 2002:a17:90a:6002:b0:246:865d:419a with SMTP id y2-20020a17090a600200b00246865d419amr3928528pji.6.1681942733866;
        Wed, 19 Apr 2023 15:18:53 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:18:53 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Atish Patra <atishp@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 38/48] RISC-V: Add CoVE guest config and helper functions
Date:   Wed, 19 Apr 2023 15:17:06 -0700
Message-Id: <20230419221716.3603068-39-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rajnesh Kanwal <rkanwal@rivosinc.com>

Introduce a separate config for the guest running in CoVE so that
it can be enabled separately if required. However, the default config
will enable both CoVE host & guest configs in order to make single
image work as both host & guest. Introduce a helper function to
detect if a guest is TVM or not at run time. The TSM only enables
the CoVE guest SBI extension for TVMs.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Co-developed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/Kbuild             |  2 ++
 arch/riscv/Kconfig            |  6 ++++++
 arch/riscv/cove/Makefile      |  2 ++
 arch/riscv/cove/core.c        | 28 ++++++++++++++++++++++++++++
 arch/riscv/include/asm/cove.h | 27 +++++++++++++++++++++++++++
 arch/riscv/kernel/setup.c     |  2 ++
 6 files changed, 67 insertions(+)
 create mode 100644 arch/riscv/cove/Makefile
 create mode 100644 arch/riscv/cove/core.c
 create mode 100644 arch/riscv/include/asm/cove.h

diff --git a/arch/riscv/Kbuild b/arch/riscv/Kbuild
index afa83e3..ecd661e 100644
--- a/arch/riscv/Kbuild
+++ b/arch/riscv/Kbuild
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
+obj-$(CONFIG_RISCV_COVE_GUEST) += cove/
+
 obj-y += kernel/ mm/ net/
 obj-$(CONFIG_BUILTIN_DTB) += boot/dts/
 obj-y += errata/
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 8462941..49c3006 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -512,6 +512,12 @@ config RISCV_COVE_HOST
 	    That means the platform should be capable of running TEE VM (TVM)
 	    using KVM and TEE Security Manager (TSM).
 
+config RISCV_COVE_GUEST
+	bool "Guest Support for Confidential VM Extension(CoVE)"
+	default n
+	help
+	  Enables support for running TVMs on platforms supporting CoVE.
+
 endmenu # "Confidential VM Extension(CoVE) Support"
 
 endmenu # "Platform type"
diff --git a/arch/riscv/cove/Makefile b/arch/riscv/cove/Makefile
new file mode 100644
index 0000000..03a0cac
--- /dev/null
+++ b/arch/riscv/cove/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_RISCV_COVE_GUEST)	+= core.o
diff --git a/arch/riscv/cove/core.c b/arch/riscv/cove/core.c
new file mode 100644
index 0000000..7218fe7
--- /dev/null
+++ b/arch/riscv/cove/core.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Confidential Computing Platform Capability checks
+ *
+ * Copyright (c) 2023 Rivos Inc.
+ *
+ * Authors:
+ *     Rajnesh Kanwal <rkanwal@rivosinc.com>
+ */
+
+#include <linux/export.h>
+#include <linux/cc_platform.h>
+#include <asm/sbi.h>
+#include <asm/cove.h>
+
+static bool is_tvm;
+
+bool is_cove_guest(void)
+{
+	return is_tvm;
+}
+EXPORT_SYMBOL_GPL(is_cove_guest);
+
+void riscv_cove_sbi_init(void)
+{
+	if (sbi_probe_extension(SBI_EXT_COVG) > 0)
+		is_tvm = true;
+}
diff --git a/arch/riscv/include/asm/cove.h b/arch/riscv/include/asm/cove.h
new file mode 100644
index 0000000..c4d609d
--- /dev/null
+++ b/arch/riscv/include/asm/cove.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * TVM helper functions
+ *
+ * Copyright (c) 2023 Rivos Inc.
+ *
+ * Authors:
+ *     Rajnesh Kanwal <rkanwal@rivosinc.com>
+ */
+
+#ifndef __RISCV_COVE_H__
+#define __RISCV_COVE_H__
+
+#ifdef CONFIG_RISCV_COVE_GUEST
+void riscv_cove_sbi_init(void);
+bool is_cove_guest(void);
+#else /* CONFIG_RISCV_COVE_GUEST */
+static inline bool is_cove_guest(void)
+{
+	return false;
+}
+static inline void riscv_cove_sbi_init(void)
+{
+}
+#endif /* CONFIG_RISCV_COVE_GUEST */
+
+#endif /* __RISCV_COVE_H__ */
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 7b2b065..20b0280 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -35,6 +35,7 @@
 #include <asm/thread_info.h>
 #include <asm/kasan.h>
 #include <asm/efi.h>
+#include <asm/cove.h>
 
 #include "head.h"
 
@@ -272,6 +273,7 @@ void __init setup_arch(char **cmdline_p)
 
 	early_ioremap_setup();
 	sbi_init();
+	riscv_cove_sbi_init();
 	jump_label_init();
 	parse_early_param();
 
-- 
2.25.1

