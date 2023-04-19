Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0096E84D4
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbjDSWWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232907AbjDSWWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:22:04 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548B49743
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:20:33 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1a92369761cso4221465ad.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942745; x=1684534745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFcComAa5TlSFZBz7x8OlktBSnuCSnQ4ODeflbYaEGg=;
        b=0nUEiKekWfmNI3AIrUphLeoG9IshBvYin/IZirKoihkL7Vz1hKxvtZ9S/+qBRCxzGl
         Z5d0ha3qHQFVtOuYq101NOgtW6elAbMIjX+yLfEnzAp2xs2I4iBDYY5ZkQhxDmkY/7bK
         cWsa9maVnCVxVpLIasWERRfsvZygnli2tjaAPy0CiHcpn0ucula1hxhQbTtXkquOE/G9
         qpketxd8B8maczWCb6ig5SjaDPKhR+D5kNN9pT45ngLGWR38A7D8mV+x7ZjU7uDYBccF
         cGzTF21j2WAnsV3IO9kxRpdiOoTA+Oi128benfRj77bo/TAAOLLGK42wViYQ/tssBFno
         STjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942745; x=1684534745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZFcComAa5TlSFZBz7x8OlktBSnuCSnQ4ODeflbYaEGg=;
        b=gEdvHs953iC/4NAvu2I/Yxmo2Z8f3TG0RzDgYH29KYVp0eQR/eqivx9Uu/dozVAdI0
         JG2XusBI7ufLM5OizdJqzRjlg9C7xF0YFClBFKzojLkyubnkMFVADx/yy9h+g/FQMrrs
         uSw/WQqrdMTPGWNNyyrVqiQBW/mhD6wNFw7IRKjEqrY1KiEPyTM77R/E1wenE75RMU4F
         Uwf4xEh50lNLtZjcK3GINSZ0qzP2tPXqOudg7sLHfGFnyWm7zg8OaWdSFGcbd5wuvkRc
         HORdYYMDvFvEvXe0DNsmvJ1B5YGGf+dV5gIGcl4q3rgLXXPJqMYsl/dUI/tbH7BotKr9
         useQ==
X-Gm-Message-State: AAQBX9c0+/tF0YxEkZB3xwjsRcVxo2D1SZY6sjU9u2YgVakDROiOerk9
        eGTjgeB650pRWtbMd1a81XA39g==
X-Google-Smtp-Source: AKy350ZdssyQae53kgooCFIYW6ziRRtfOc1jDxPEdCsn1TsvpfXtraJ7uSS11rn4Y1HrD+jtGXUOIw==
X-Received: by 2002:a17:902:c792:b0:19e:7a2c:78a7 with SMTP id w18-20020a170902c79200b0019e7a2c78a7mr5521629pla.57.1681942745174;
        Wed, 19 Apr 2023 15:19:05 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:19:04 -0700 (PDT)
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
Subject: [RFC 43/48] RISC-V: Add base memory encryption functions.
Date:   Wed, 19 Apr 2023 15:17:11 -0700
Message-Id: <20230419221716.3603068-44-atishp@rivosinc.com>
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

Devices like virtio use shared memory buffers to transfer
data. These buffers are part of the guest memory region.
For CoVE guest this is not possible as host can not access
guest memory.

This is solved by VIRTIO_F_ACCESS_PLATFORM feature and SWIOTLB
bounce buffers. Guest only allow devices with VIRTIO_F_ACCESS_PLATFORM
feature which leads to guest using DMA API and from there moving
to SWIOTLB bounce buffer due to SWIOTLB_FORCE flag set for TEE VM.

set_memory_encrypted and set_memory_decrypted sit in this allocation
path. Based on if a buffer is being decrypted we mark it shared and
if it's being encrypted we mark it unshared using hypercalls.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/Kconfig                   |  7 ++++
 arch/riscv/include/asm/mem_encrypt.h | 26 +++++++++++++
 arch/riscv/mm/Makefile               |  2 +
 arch/riscv/mm/init.c                 | 17 ++++++++-
 arch/riscv/mm/mem_encrypt.c          | 57 ++++++++++++++++++++++++++++
 5 files changed, 108 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/include/asm/mem_encrypt.h
 create mode 100644 arch/riscv/mm/mem_encrypt.c

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 49c3006..414cee1 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -163,6 +163,11 @@ config ARCH_MMAP_RND_BITS_MAX
 config ARCH_MMAP_RND_COMPAT_BITS_MAX
 	default 17
 
+config RISCV_MEM_ENCRYPT
+	select ARCH_HAS_MEM_ENCRYPT
+	select ARCH_HAS_FORCE_DMA_UNENCRYPTED
+	def_bool n
+
 # set if we run in machine mode, cleared if we run in supervisor mode
 config RISCV_M_MODE
 	bool
@@ -515,6 +520,8 @@ config RISCV_COVE_HOST
 config RISCV_COVE_GUEST
 	bool "Guest Support for Confidential VM Extension(CoVE)"
 	default n
+	select SWIOTLB
+	select RISCV_MEM_ENCRYPT
 	help
 	  Enables support for running TVMs on platforms supporting CoVE.
 
diff --git a/arch/riscv/include/asm/mem_encrypt.h b/arch/riscv/include/asm/mem_encrypt.h
new file mode 100644
index 0000000..0dc3fe8
--- /dev/null
+++ b/arch/riscv/include/asm/mem_encrypt.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * RISCV Memory Encryption Support.
+ *
+ * Copyright (c) 2023 Rivos Inc.
+ *
+ * Authors:
+ *     Rajnesh Kanwal <rkanwal@rivosinc.com>
+ */
+
+#ifndef __RISCV_MEM_ENCRYPT_H__
+#define __RISCV_MEM_ENCRYPT_H__
+
+#include <linux/init.h>
+
+struct device;
+
+bool force_dma_unencrypted(struct device *dev);
+
+/* Architecture __weak replacement functions */
+void __init mem_encrypt_init(void);
+
+int set_memory_encrypted(unsigned long addr, int numpages);
+int set_memory_decrypted(unsigned long addr, int numpages);
+
+#endif /* __RISCV_MEM_ENCRYPT_H__ */
diff --git a/arch/riscv/mm/Makefile b/arch/riscv/mm/Makefile
index 2ac177c..1fd9b60 100644
--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -33,3 +33,5 @@ endif
 
 obj-$(CONFIG_DEBUG_VIRTUAL) += physaddr.o
 obj-$(CONFIG_RISCV_DMA_NONCOHERENT) += dma-noncoherent.o
+
+obj-$(CONFIG_RISCV_MEM_ENCRYPT)	+= mem_encrypt.o
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 478d676..b5edd8e 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -21,6 +21,7 @@
 #include <linux/crash_dump.h>
 #include <linux/hugetlb.h>
 
+#include <asm/cove.h>
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
@@ -156,11 +157,25 @@ static void print_vm_layout(void) { }
 
 void __init mem_init(void)
 {
+	unsigned int flags = SWIOTLB_VERBOSE;
+	bool swiotlb_en;
+
+	if (is_cove_guest()) {
+		/* Since the guest memory is inaccessible to the host, devices
+		 * always need to use the SWIOTLB buffer for DMA even if
+		 * dma_capable() says otherwise.
+		 */
+		flags |= SWIOTLB_FORCE;
+		swiotlb_en = true;
+	} else {
+		swiotlb_en = !!(max_pfn > PFN_DOWN(dma32_phys_limit));
+	}
+
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
 #endif /* CONFIG_FLATMEM */
 
-	swiotlb_init(max_pfn > PFN_DOWN(dma32_phys_limit), SWIOTLB_VERBOSE);
+	swiotlb_init(swiotlb_en, flags);
 	memblock_free_all();
 
 	print_vm_layout();
diff --git a/arch/riscv/mm/mem_encrypt.c b/arch/riscv/mm/mem_encrypt.c
new file mode 100644
index 0000000..8207a5c
--- /dev/null
+++ b/arch/riscv/mm/mem_encrypt.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2023 Rivos Inc.
+ *
+ * Authors:
+ *     Rajnesh Kanwal <rkanwal@rivosinc.com>
+ */
+
+#include <linux/dma-direct.h>
+#include <linux/swiotlb.h>
+#include <linux/cc_platform.h>
+#include <linux/mem_encrypt.h>
+#include <asm/covg_sbi.h>
+
+/* Override for DMA direct allocation check - ARCH_HAS_FORCE_DMA_UNENCRYPTED */
+bool force_dma_unencrypted(struct device *dev)
+{
+	/*
+	 * For authorized devices in trusted guest, all DMA must be to/from
+	 * unencrypted addresses.
+	 */
+	return cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT);
+}
+
+int set_memory_encrypted(unsigned long addr, int numpages)
+{
+	if (!cc_platform_has(CC_ATTR_MEM_ENCRYPT))
+		return 0;
+
+	if (!PAGE_ALIGNED(addr))
+		return -EINVAL;
+
+	return sbi_covg_unshare_memory(__pa(addr), numpages * PAGE_SIZE);
+}
+EXPORT_SYMBOL_GPL(set_memory_encrypted);
+
+int set_memory_decrypted(unsigned long addr, int numpages)
+{
+	if (!cc_platform_has(CC_ATTR_MEM_ENCRYPT))
+		return 0;
+
+	if (!PAGE_ALIGNED(addr))
+		return -EINVAL;
+
+	return sbi_covg_share_memory(__pa(addr), numpages * PAGE_SIZE);
+}
+EXPORT_SYMBOL_GPL(set_memory_decrypted);
+
+/* Architecture __weak replacement functions */
+void __init mem_encrypt_init(void)
+{
+	if (!cc_platform_has(CC_ATTR_MEM_ENCRYPT))
+		return;
+
+	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
+	swiotlb_update_mem_attributes();
+}
-- 
2.25.1

