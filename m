Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBCE6E84CD
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbjDSWW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbjDSWVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:21:47 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5988A9778
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:20:24 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63b60366047so357731b3a.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942749; x=1684534749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8vKC+DATLxW+QWgEBtVVKhLwPezg/zgsscm2TPJ1sU=;
        b=BwX+DM7PF0bcRvAKKIu4MHKKajOEzXLxGIauLswkbEgjP6DJZ6w6f7IIzl8Qpi8c98
         ed4C65vIGkkrNIrLR5kdnMXy2vcDHhmfQHa8C6amTJnDRxQZMkqxUQV7hs024Ati36Dt
         zpHCU/W8PLW1oErRDOCQdSTnQVm/WTAOCvbqhuYsNSC3p+RiRejOdpcZADkJX6CbNoIH
         9EVmLfGzACsyDnRZvTGg/b8+8stR7Al9zVOUv8bZ/yCdHCLAg6/FhYsFSYe4Yx79Lh8K
         qgEDVcvH60RycDNT8QKaO1+287IZvvLfcWjMdpa7LI9GrhUlCgUkAt3/dSeYRn7Itqpu
         sgIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942749; x=1684534749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8vKC+DATLxW+QWgEBtVVKhLwPezg/zgsscm2TPJ1sU=;
        b=Wqz8hM77rff7WypF71RQdGgmnlmCbLbUglDN7nOHTu0eqONVcAPf7PKbLx9Wkcwoa0
         jVVL9/Smc6dumMX6n1F3+LIwn1c4uwaDBYoZHMbH8YrD9CGkVAx2LlqwK8YByuClfeSE
         H1/ucM77g9hEPzE9xjzgc0SI488bVLfYVJFq6Rx5cGiDCnGFZqkFh2llj8VCrZgPHNlI
         UqYUqdqAPBqDqQFNE91cT38RUfkh3Tir3/6+m4pQH4VDxDnu1QCIb4B+G47rLFF/cFxd
         qMMXLyG565tsKJVVIHZQXDByCjPBY60gCKG+n6sKwb9pO+ElPX88BEekXQO5I5H4Jdip
         UPIQ==
X-Gm-Message-State: AAQBX9cjYT616UboWalCt+aJbF4wA6G/Si1W8AgpCqe48qjehBJd1Rcs
        EitVEW+k74zXdBO7pyMnurk4Qg==
X-Google-Smtp-Source: AKy350YMt1GXaXJLEtI/tcFCT7P2BRkKgLnzDade8rOaHZzTbglX9T86uEwEdM3HEdy8DD35oL3itg==
X-Received: by 2002:a17:903:3013:b0:1a2:8940:6da4 with SMTP id o19-20020a170903301300b001a289406da4mr5416617pla.29.1681942749582;
        Wed, 19 Apr 2023 15:19:09 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:19:09 -0700 (PDT)
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
Subject: [RFC 45/48] RISC-V: ioremap: Implement for arch specific ioremap hooks
Date:   Wed, 19 Apr 2023 15:17:13 -0700
Message-Id: <20230419221716.3603068-46-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rajnesh Kanwal <rkanwal@rivosinc.com>

The guests running in CoVE must notify the host about its mmio regions
so that host can enable mmio emulation.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/mm/Makefile  |  1 +
 arch/riscv/mm/ioremap.c | 45 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)
 create mode 100644 arch/riscv/mm/ioremap.c

diff --git a/arch/riscv/mm/Makefile b/arch/riscv/mm/Makefile
index 1fd9b60..721b557 100644
--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -15,6 +15,7 @@ obj-y += cacheflush.o
 obj-y += context.o
 obj-y += pgtable.o
 obj-y += pmem.o
+obj-y += ioremap.o
 
 ifeq ($(CONFIG_MMU),y)
 obj-$(CONFIG_SMP) += tlbflush.o
diff --git a/arch/riscv/mm/ioremap.c b/arch/riscv/mm/ioremap.c
new file mode 100644
index 0000000..0d4e026
--- /dev/null
+++ b/arch/riscv/mm/ioremap.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2023 Rivos Inc.
+ *
+ * Authors:
+ *     Rajnesh Kanwal <rkanwal@rivosinc.com>
+ */
+
+#include <linux/export.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/io.h>
+#include <asm/covg_sbi.h>
+#include <asm/cove.h>
+#include <asm-generic/io.h>
+
+void ioremap_phys_range_hook(phys_addr_t addr, size_t size, pgprot_t prot)
+{
+	unsigned long offset;
+
+	if (!is_cove_guest())
+		return;
+
+	/* Page-align address and size. */
+	offset = addr & (~PAGE_MASK);
+	addr -= offset;
+	size = PAGE_ALIGN(size + offset);
+
+	sbi_covg_add_mmio_region(addr, size);
+}
+
+void iounmap_phys_range_hook(phys_addr_t addr, size_t size)
+{
+	unsigned long offset;
+
+	if (!is_cove_guest())
+		return;
+
+	/* Page-align address and size. */
+	offset = addr & (~PAGE_MASK);
+	addr -= offset;
+	size = PAGE_ALIGN(size + offset);
+
+	sbi_covg_remove_mmio_region(addr, size);
+}
-- 
2.25.1

