Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6356B646F
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjCLJ4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjCLJ4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:56:23 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BFF521F2
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614963; x=1710150963;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oMmVu6x7rqZoZjKSRHmHXHPN6ec2ghnlaN3L7R3QFBA=;
  b=EuSpG/cI+gzQcW4BpWIsMwWjjZmrKyC09Np0ag8zoXYXO0IVgp+TA+ud
   /0uxzaLWddBqEOadytsg4tKHtOHAMjjAs8IGlfTTODa+vSW63zFBIBNPw
   FyaL3qLfjgqOcqmxB2jcz/R9c8EjulTdVGjssFXxayQGVsrZxCJzVctUj
   Dx1+wN6aN2QgchLk/3f2ZjaJrHgyFuydTgwp6QG2t0Zzlc5tnHIXBkKST
   TvXEvPFYVrRY8qUWiMPy1YKI/PuPC01Ja1WTAovlkbsGrbedl2iAUnRk/
   klBNubH9IzIyIsBIoUVRziMRxF5SFJUn/oFrAc1nxmUmWoYvK3EeqeFbH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623052"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623052"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660827"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660827"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:19 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-3 14/22] pkvm: x86: Add global pkvm_hyp pointer
Date:   Mon, 13 Mar 2023 02:01:44 +0800
Message-Id: <20230312180152.1778338-15-jason.cj.chen@intel.com>
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

The unique global data structure pkvm_hyp is used to describe pKVM
hypervisor, includes the whole info about its host vm & pcpu settings.
It's useful for pKVM runtime to fetch required information, add a
global pointer pkvm_hyp for pKVM, set it in pkvm_init when pKVM got
successfully initialized.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/Makefile   |  2 +-
 arch/x86/kvm/vmx/pkvm/hyp/pkvm.c     |  8 ++++++++
 arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h | 10 ++++++++++
 arch/x86/kvm/vmx/pkvm/include/pkvm.h |  1 +
 arch/x86/kvm/vmx/pkvm/pkvm_host.c    |  9 ++++++++-
 5 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index cc869624b201..bea43d22a2a3 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -12,7 +12,7 @@ ccflags-y += -D__PKVM_HYP__
 lib-dir		:= lib
 virt-dir	:= ../../../../../../$(KVM_PKVM)
 
-pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o mmu.o
+pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o mmu.o pkvm.o
 
 pkvm-hyp-y	+= $(lib-dir)/memset_64.o
 pkvm-hyp-$(CONFIG_RETPOLINE)	+= $(lib-dir)/retpoline.o
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
new file mode 100644
index 000000000000..a5f776195af6
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#include <pkvm.h>
+
+struct pkvm_hyp *pkvm_hyp;
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
new file mode 100644
index 000000000000..e84296a714a2
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#ifndef __PKVM_HYP_H
+#define __PKVM_HYP_H
+
+extern struct pkvm_hyp *pkvm_hyp;
+
+#endif
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 648b00326e23..18ec51965936 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -63,6 +63,7 @@ extern char __pkvm_text_start[], __pkvm_text_end[];
 
 extern unsigned long pkvm_sym(__page_base_offset);
 extern unsigned long pkvm_sym(__symbol_base_offset);
+extern struct pkvm_hyp *pkvm_sym(pkvm_hyp);
 
 PKVM_DECLARE(void, __pkvm_vmx_vmexit(void));
 PKVM_DECLARE(int, pkvm_main(struct kvm_vcpu *vcpu));
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 06f90b41a2de..36ed9df1c7ab 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -708,6 +708,11 @@ __init int pkvm_init(void)
 {
 	int ret = 0, cpu;
 
+	if (pkvm_sym(pkvm_hyp)) {
+		pr_err("pkvm hypervisor is running!");
+		return -EBUSY;
+	}
+
 	if (!hyp_mem_base) {
 		pr_err("pkvm required memory not get reserved!");
 		ret = -ENOMEM;
@@ -717,7 +722,8 @@ __init int pkvm_init(void)
 			pkvm_data_struct_pages(PKVM_PAGES, PKVM_PERCPU_PAGES,
 				num_possible_cpus()) << PAGE_SHIFT);
 
-	pkvm = pkvm_sym(pkvm_early_alloc_contig)(PKVM_PAGES);
+	/* pkvm hypervisor keeps same VA mapping as deprivileged host */
+	pkvm = pkvm_sym(pkvm_hyp) = pkvm_sym(pkvm_early_alloc_contig)(PKVM_PAGES);
 	if (!pkvm) {
 		ret = -ENOMEM;
 		goto out;
@@ -749,5 +755,6 @@ __init int pkvm_init(void)
 	return 0;
 
 out:
+	pkvm_sym(pkvm_hyp) = NULL;
 	return ret;
 }
-- 
2.25.1

