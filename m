Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16E56E8484
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbjDSWSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjDSWR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:17:56 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960AA5FF7
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:43 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-2496863c2c7so215759a91.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942663; x=1684534663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MC6vnkFRr+LS0VzfoACyhzPionL0+vOgt4l/y7HAvLQ=;
        b=DRAvwidPC7IdYDxLvMZPx6rD17zG/oS72Z/5NPbNssSMeEjGZ/qFXxKzxUoDWrBvaq
         DZ0TInEL8TrdR76cTRhzAJ5vG3gQXDbbiRYVKe5TFYSlezfrU3NDmW+/vfPxscuEdQxg
         jXWWGJNbmSYg4oA+SEn/VeITfEYeL5F6eAjq1+89vsTHHHYZkIRXRhIdgP4FIkoXVHnV
         bl38T3t+0HkBGPH61JvdtrFKDQGGEV6QVexZiROWg23DV082ptqUszDkbJ0kgnR2cFa0
         h+Xapq4PsL1WId18x50ElV1iwBPVNVRSYCKwHvchYfyD9yud1mQMh17Z1wEgoBq7zr/0
         kh+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942663; x=1684534663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MC6vnkFRr+LS0VzfoACyhzPionL0+vOgt4l/y7HAvLQ=;
        b=lRb6owXiLJeVeDOb14f3zVkyucBOkfAyAd340K4SjCSj2V422jDgTA5bHzv/EldZ75
         EtuX8mUg94xruqHyeR7exWh0sljo0DpT3nbpzFHXn1d7P/i05cUMGXKlnOvPjMtDVCrf
         dQFM0I23ubFQ+K4JEwdySG1tIjIAt/2WWlxNauO72DnOWbaU+YLJ07lP9FOUDx50/8L3
         ktyEGHCFH5VxqyNBhUtj7eeoIX59ATGodmYUoE0BMMcfMzbz5xNf5AHKfusao53+g4XX
         q4kOQomfLMLumIv5CtiKitDejliKmMsTJQdBkTIn9LDxBJLExxCUVCGiDg5Z9KxsmQwH
         nHSw==
X-Gm-Message-State: AAQBX9eF3ZGnOky2KXpMyHOE0QQV9PZNPq39W0YUmAjYPHzc8anyUpYp
        XZQAM25H9NU8jCCk/PQql4w3OQ==
X-Google-Smtp-Source: AKy350YM0J4iT9dthj2PQFzxPsPzjGXv4OgXVXSGvlPqAIkruWzwbcoYuc98tklz6iIJwKCz8HSgyw==
X-Received: by 2002:a17:90a:f3c4:b0:247:6364:b8d8 with SMTP id ha4-20020a17090af3c400b002476364b8d8mr4026019pjb.6.1681942662828;
        Wed, 19 Apr 2023 15:17:42 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:17:42 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
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
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 06/48] RISC-V: KVM: Implement COVH SBI extension
Date:   Wed, 19 Apr 2023 15:16:34 -0700
Message-Id: <20230419221716.3603068-7-atishp@rivosinc.com>
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

COVH SBI extension defines the SBI functions that the host will
invoke to configure/create/destroy a TEE VM (TVM).

Implement all the COVH SBI extension functions.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/Kconfig                    |  13 ++
 arch/riscv/include/asm/kvm_cove_sbi.h |  46 +++++
 arch/riscv/kvm/Makefile               |   1 +
 arch/riscv/kvm/cove_sbi.c             | 245 ++++++++++++++++++++++++++
 4 files changed, 305 insertions(+)
 create mode 100644 arch/riscv/include/asm/kvm_cove_sbi.h
 create mode 100644 arch/riscv/kvm/cove_sbi.c

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 4044080..8462941 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -501,6 +501,19 @@ config FPU
 
 	  If you don't know what to do here, say Y.
 
+menu "Confidential VM Extension(CoVE) Support"
+
+config RISCV_COVE_HOST
+	bool "Host(KVM) support for Confidential VM Extension(CoVE)"
+	depends on KVM
+	default n
+	help
+            Enable this if the platform supports confidential vm extension.
+	    That means the platform should be capable of running TEE VM (TVM)
+	    using KVM and TEE Security Manager (TSM).
+
+endmenu # "Confidential VM Extension(CoVE) Support"
+
 endmenu # "Platform type"
 
 menu "Kernel features"
diff --git a/arch/riscv/include/asm/kvm_cove_sbi.h b/arch/riscv/include/asm/kvm_cove_sbi.h
new file mode 100644
index 0000000..24562df
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_cove_sbi.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * COVE SBI extension related header file.
+ *
+ * Copyright (c) 2023 RivosInc
+ *
+ * Authors:
+ *     Atish Patra <atishp@rivosinc.com>
+ */
+
+#ifndef __KVM_COVE_SBI_H
+#define __KVM_COVE_SBI_H
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/sbi.h>
+
+int sbi_covh_tsm_get_info(struct sbi_cove_tsm_info *tinfo_addr);
+int sbi_covh_tvm_initiate_fence(unsigned long tvmid);
+int sbi_covh_tsm_initiate_fence(void);
+int sbi_covh_tsm_local_fence(void);
+int sbi_covh_tsm_create_tvm(struct sbi_cove_tvm_create_params *tparam, unsigned long *tvmid);
+int sbi_covh_tsm_finalize_tvm(unsigned long tvmid, unsigned long sepc, unsigned long entry_arg);
+int sbi_covh_tsm_destroy_tvm(unsigned long tvmid);
+int sbi_covh_add_memory_region(unsigned long tvmid, unsigned long tgpadr, unsigned long rlen);
+
+int sbi_covh_tsm_reclaim_pages(unsigned long phys_addr, unsigned long npages);
+int sbi_covh_tsm_convert_pages(unsigned long phys_addr, unsigned long npages);
+int sbi_covh_tsm_reclaim_page(unsigned long page_addr_phys);
+int sbi_covh_add_pgt_pages(unsigned long tvmid, unsigned long page_addr_phys, unsigned long npages);
+
+int sbi_covh_add_measured_pages(unsigned long tvmid, unsigned long src_addr,
+				unsigned long dest_addr, enum sbi_cove_page_type ptype,
+				unsigned long npages, unsigned long tgpa);
+int sbi_covh_add_zero_pages(unsigned long tvmid, unsigned long page_addr_phys,
+			    enum sbi_cove_page_type ptype, unsigned long npages,
+			    unsigned long tvm_base_page_addr);
+
+int sbi_covh_create_tvm_vcpu(unsigned long tvmid, unsigned long tvm_vcpuid,
+			     unsigned long vpus_page_addr);
+
+int sbi_covh_run_tvm_vcpu(unsigned long tvmid, unsigned long tvm_vcpuid);
+
+#endif
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 6986d3c..40dee04 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -31,3 +31,4 @@ kvm-y += aia.o
 kvm-y += aia_device.o
 kvm-y += aia_aplic.o
 kvm-y += aia_imsic.o
+kvm-$(CONFIG_RISCV_COVE_HOST) += cove_sbi.o
diff --git a/arch/riscv/kvm/cove_sbi.c b/arch/riscv/kvm/cove_sbi.c
new file mode 100644
index 0000000..c8c63fe
--- /dev/null
+++ b/arch/riscv/kvm/cove_sbi.c
@@ -0,0 +1,245 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * COVE SBI extensions related helper functions.
+ *
+ * Copyright (c) 2023 RivosInc
+ *
+ * Authors:
+ *     Atish Patra <atishp@rivosinc.com>
+ */
+
+#include <linux/align.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/kvm_cove_sbi.h>
+#include <asm/sbi.h>
+
+#define RISCV_COVE_ALIGN_4KB (1UL << 12)
+
+int sbi_covh_tsm_get_info(struct sbi_cove_tsm_info *tinfo_addr)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_TSM_GET_INFO, __pa(tinfo_addr),
+			sizeof(*tinfo_addr), 0, 0, 0, 0);
+
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covh_tvm_initiate_fence(unsigned long tvmid)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_TVM_INITIATE_FENCE, tvmid, 0, 0, 0, 0, 0);
+
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covh_tsm_initiate_fence(void)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_TSM_INITIATE_FENCE, 0, 0, 0, 0, 0, 0);
+
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covh_tsm_local_fence(void)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_TSM_LOCAL_FENCE, 0, 0, 0, 0, 0, 0);
+
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covh_tsm_create_tvm(struct sbi_cove_tvm_create_params *tparam, unsigned long *tvmid)
+{
+	struct sbiret ret;
+	int rc = 0;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_CREATE_TVM, __pa(tparam),
+			sizeof(*tparam), 0, 0, 0, 0);
+
+	if (ret.error) {
+		rc = sbi_err_map_linux_errno(ret.error);
+		if (rc == -EFAULT)
+			kvm_err("Invalid phsyical address for tvm params structure\n");
+		goto done;
+	}
+
+	kvm_info("%s: create_tvm tvmid %lx\n", __func__, ret.value);
+	*tvmid = ret.value;
+
+done:
+	return rc;
+}
+
+int sbi_covh_tsm_finalize_tvm(unsigned long tvmid, unsigned long sepc, unsigned long entry_arg)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_FINALIZE_TVM, tvmid,
+			sepc, entry_arg, 0, 0, 0);
+
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covh_tsm_destroy_tvm(unsigned long tvmid)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_DESTROY_TVM, tvmid,
+			0, 0, 0, 0, 0);
+
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covh_add_memory_region(unsigned long tvmid, unsigned long tgpaddr, unsigned long rlen)
+{
+	struct sbiret ret;
+
+	if (!IS_ALIGNED(tgpaddr, RISCV_COVE_ALIGN_4KB) || !IS_ALIGNED(rlen, RISCV_COVE_ALIGN_4KB))
+		return -EINVAL;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_TVM_ADD_MEMORY_REGION, tvmid,
+			tgpaddr, rlen, 0, 0, 0);
+	if (ret.error) {
+		kvm_err("Add memory region failed with sbi error code %ld\n", ret.error);
+		return sbi_err_map_linux_errno(ret.error);
+	}
+
+	return 0;
+}
+
+int sbi_covh_tsm_convert_pages(unsigned long phys_addr, unsigned long npages)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_TSM_CONVERT_PAGES, phys_addr,
+			npages, 0, 0, 0, 0);
+	if (ret.error) {
+		kvm_err("Convert pages failed ret %ld\n", ret.error);
+		return sbi_err_map_linux_errno(ret.error);
+	}
+	return 0;
+}
+
+int sbi_covh_tsm_reclaim_page(unsigned long page_addr_phys)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_TSM_RECLAIM_PAGES, page_addr_phys,
+			1, 0, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covh_tsm_reclaim_pages(unsigned long phys_addr, unsigned long npages)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_TSM_RECLAIM_PAGES, phys_addr,
+			npages, 0, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covh_add_pgt_pages(unsigned long tvmid, unsigned long page_addr_phys, unsigned long npages)
+{
+	struct sbiret ret;
+
+	if (!PAGE_ALIGNED(page_addr_phys))
+		return -EINVAL;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_TVM_ADD_PGT_PAGES, tvmid, page_addr_phys,
+			npages, 0, 0, 0);
+	if (ret.error) {
+		kvm_err("Adding page table pages at %lx failed %ld\n", page_addr_phys, ret.error);
+		return sbi_err_map_linux_errno(ret.error);
+	}
+
+	return 0;
+}
+
+int sbi_covh_add_measured_pages(unsigned long tvmid, unsigned long src_addr,
+				unsigned long dest_addr, enum sbi_cove_page_type ptype,
+				unsigned long npages, unsigned long tgpa)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_TVM_ADD_MEASURED_PAGES, tvmid, src_addr,
+			dest_addr, ptype, npages, tgpa);
+	if (ret.error) {
+		kvm_err("Adding measued pages failed ret %ld\n", ret.error);
+		return sbi_err_map_linux_errno(ret.error);
+	}
+
+	return 0;
+}
+
+int sbi_covh_add_zero_pages(unsigned long tvmid, unsigned long page_addr_phys,
+			    enum sbi_cove_page_type ptype, unsigned long npages,
+			    unsigned long tvm_base_page_addr)
+{
+	struct sbiret ret;
+
+	if (!PAGE_ALIGNED(page_addr_phys))
+		return -EINVAL;
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_TVM_ADD_ZERO_PAGES, tvmid, page_addr_phys,
+			ptype, npages, tvm_base_page_addr, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covh_create_tvm_vcpu(unsigned long tvmid, unsigned long vcpuid,
+			     unsigned long vcpu_state_paddr)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_TVM_CREATE_VCPU, tvmid, vcpuid,
+			vcpu_state_paddr, 0, 0, 0);
+	if (ret.error) {
+		kvm_err("create vcpu failed ret %ld\n", ret.error);
+		return sbi_err_map_linux_errno(ret.error);
+	}
+	return 0;
+}
+
+int sbi_covh_run_tvm_vcpu(unsigned long tvmid, unsigned long vcpuid)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVH, SBI_EXT_COVH_TVM_VCPU_RUN, tvmid, vcpuid, 0, 0, 0, 0);
+	/* Non-zero return value indicate the vcpu is already terminated */
+	if (ret.error || !ret.value)
+		return ret.error ? sbi_err_map_linux_errno(ret.error) : ret.value;
+
+	return 0;
+}
-- 
2.25.1

