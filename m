Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455D76B6468
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjCLJ4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjCLJzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:55:52 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F4D5072A
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614938; x=1710150938;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+Jsk/lAh0jBl8TxohAxNwl+3Nd+N0Pm3M381k5/RUuQ=;
  b=BKiJHe1vvWW41Kuijf07WxWm9Z7lth7Jpxg8pC3BJ7mLsHxKnb/iP++e
   o3c8umbrc33+ZqWZy+nNyfU9KMpFOUGUIvObQY7jrO4/yp4Efjvpz8xXB
   KuUe5JhBZA1R7P8jl8pV/Mfgsy52eK+stt8jEaL+PmbxBp2KV3RxLG1fe
   4zQUxe9P81QyINdnqb7pb29MdH+hxVRIXHHzz3R/fOuTBZGs2+jVRUHwG
   gvD5NWyPVi0Y8GAMrSXvwF2z8GgC8katUqQBBUGvMa6EDqOVONyRxiVGz
   +SxlshgJqFM5GnMsyR9hvLm6pfvBjJMdmjv0MTkBCwI9lQJKNnwXrsqhb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623032"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623032"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660803"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660803"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:08 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-3 07/22] pkvm: x86: Reserve memory for pKVM
Date:   Mon, 13 Mar 2023 02:01:37 +0800
Message-Id: <20230312180152.1778338-8-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180152.1778338-1-jason.cj.chen@intel.com>
References: <20230312180152.1778338-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reserve required memory for pKVM on Intel platform before de-privilege.

It takes use of general API kvm_hyp_reserve() to do the reservation,
which get pkvm reserve memory size (hyp_mem_size) from API
hyp_total_reserve_pages() then record reserved physical memory base to
hyp_mem_base. At the same time, register system memory block layout
info to hyp_memory[] array.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/include/asm/kvm_pkvm.h | 14 ++++++++++++++
 arch/x86/kernel/setup.c         |  3 +++
 arch/x86/kvm/vmx/pkvm/Makefile  |  3 +++
 virt/kvm/pkvm/pkvm.c            |  1 +
 4 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/kvm_pkvm.h b/arch/x86/include/asm/kvm_pkvm.h
index 30f7f805bcb8..3c750f1a3a2d 100644
--- a/arch/x86/include/asm/kvm_pkvm.h
+++ b/arch/x86/include/asm/kvm_pkvm.h
@@ -27,6 +27,11 @@ unsigned long pkvm_virt_to_phys(void *virt);
 #define __hyp_pa __pkvm_pa
 #define __hyp_va __pkvm_va
 
+extern phys_addr_t hyp_mem_base;
+extern phys_addr_t hyp_mem_size;
+
+void __init kvm_hyp_reserve(void);
+
 static inline unsigned long __pkvm_pgtable_max_pages(unsigned long nr_pages)
 {
 	unsigned long total = 0, i;
@@ -111,7 +116,16 @@ static inline unsigned long pkvm_data_struct_pages(unsigned long global_pgs,
 	return (percpu_pgs * num_cpus + global_pgs);
 }
 
+static inline int hyp_pre_reserve_check(void)
+{
+	/* no necessary check yet*/
+	return 0;
+}
+
 u64 hyp_total_reserve_pages(void);
+
+#else
+static inline void kvm_hyp_reserve(void) {}
 #endif
 
 #endif
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 88188549647c..1598d7235af9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -39,6 +39,7 @@
 #include <asm/cpu.h>
 #include <asm/efi.h>
 #include <asm/gart.h>
+#include <asm/kvm_pkvm.h>
 #include <asm/hypervisor.h>
 #include <asm/io_apic.h>
 #include <asm/kasan.h>
@@ -1322,6 +1323,8 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	unwind_init();
+
+	kvm_hyp_reserve();
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kvm/vmx/pkvm/Makefile b/arch/x86/kvm/vmx/pkvm/Makefile
index fa90a7375f6f..12d82e889033 100644
--- a/arch/x86/kvm/vmx/pkvm/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/Makefile
@@ -1,10 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0
 
+KVM_PKVM ?= ../../../../../virt/kvm/pkvm
 ccflags-y += -I $(srctree)/arch/x86/kvm
 ccflags-y += -I $(srctree)/arch/x86/kvm/vmx/pkvm/include
 
 pkvm-obj		:= pkvm_host.o
 
+pkvm-obj		+= $(KVM_PKVM)/pkvm.o
+
 obj-$(CONFIG_PKVM_INTEL)	+= $(pkvm-obj)
 obj-$(CONFIG_PKVM_INTEL)	+= hyp/
 
diff --git a/virt/kvm/pkvm/pkvm.c b/virt/kvm/pkvm/pkvm.c
index 6f06a41f0e77..8a20a662b917 100644
--- a/virt/kvm/pkvm/pkvm.c
+++ b/virt/kvm/pkvm/pkvm.c
@@ -4,6 +4,7 @@
  * Author: Quentin Perret <qperret@google.com>
  */
 
+#include <linux/kvm_host.h>
 #include <linux/memblock.h>
 #include <linux/sort.h>
 
-- 
2.25.1

