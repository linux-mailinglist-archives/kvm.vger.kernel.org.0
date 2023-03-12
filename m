Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462716B646B
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjCLJ4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjCLJ4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:56:05 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0D4515F9
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614952; x=1710150952;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b6xjJNcU42NUbqzjPa6XNuX/HDLFYMGfpmDyZ2M5ayM=;
  b=aslU6Mt9KfCjo17nnDaPx7NcqzbYAbWxmbpbfGolEKUXpRbD3hGuI2qk
   mIk0vX9BbOYUD8A4yGNgigW+T7AyM0tQsWdqUQbvDICY8Mnty/UkQtvBy
   QAwEneIJau8XV32c8277jF6uhiU+J+cMXlyDC36x5JD/A7aVIuvQF7XEj
   XH+j7NeIv+C/QgvVG7pc+5vliGf8wRzZ+RyrTCLYoQpCtVppbGUJrF7AQ
   4m10gTMOtWcUXoXgypJxwC/cCpqMFGDpiQtBlTb1I/+78PSz9Q5rYrJMe
   weomP0AYUZQQKkk54Mhu8NrEvHG27ogmHJm0357Ti+wOUr2XU5tSkmHZ4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623043"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623043"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660815"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660815"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:13 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Shaoqin Huang <shaoqin.huang@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-3 10/22] pkvm: x86: Initialize MMU/EPT configuration
Date:   Mon, 13 Mar 2023 02:01:40 +0800
Message-Id: <20230312180152.1778338-11-jason.cj.chen@intel.com>
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

Initializes MMU/EPT pgtable cap for pKVM, which is used for later
MMU/EPT pgtable creation.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/include/pkvm.h |  3 +++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c    | 21 +++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 3b75760b37a3..648b00326e23 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -45,6 +45,9 @@ struct pkvm_hyp {
 	struct vmx_capability vmx_cap;
 	struct vmcs_config vmcs_config;
 
+	struct pkvm_pgtable_cap mmu_cap;
+	struct pkvm_pgtable_cap ept_cap;
+
 	struct pkvm_pcpu *pcpus[CONFIG_NR_CPUS];
 
 	struct pkvm_host_vm host_vm;
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index ea70f3692044..06f90b41a2de 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -8,6 +8,8 @@
 #include <asm/trapnr.h>
 #include <asm/kvm_pkvm.h>
 
+#include <mmu.h>
+#include <mmu/spte.h>
 #include <pkvm.h>
 #include "pkvm_constants.h"
 
@@ -433,8 +435,23 @@ static __init int pkvm_host_check_and_setup_vmx_cap(struct pkvm_hyp *pkvm)
 	return ret;
 }
 
-static __init int pkvm_init_mmu(void)
+static __init int pkvm_init_mmu(struct pkvm_hyp *pkvm)
 {
+	int pgsz_mask = (1 << PG_LEVEL_2M) | (1 << PG_LEVEL_4K);
+
+	if (boot_cpu_has(X86_FEATURE_GBPAGES))
+		pgsz_mask |= 1 << PG_LEVEL_1G;
+
+	/* record mmu pgtable cap for later mmu pgtable build */
+	pkvm->mmu_cap.level = pgtable_l5_enabled() ? 5 : 4;
+	pkvm->mmu_cap.allowed_pgsz = pgsz_mask;
+	pkvm->mmu_cap.table_prot = (u64)_KERNPG_TABLE_NOENC;
+
+	/* record ept pgtable cap for later ept pgtable build */
+	pkvm->ept_cap.level = pkvm->vmx_cap.ept & VMX_EPT_PAGE_WALK_4_BIT ? 4 : 5;
+	pkvm->ept_cap.allowed_pgsz = pgsz_mask;
+	pkvm->ept_cap.table_prot = VMX_EPT_RWX_MASK;
+
 	/*
 	 * __page_base_offset stores the offset for pkvm
 	 * to translate VA to a PA.
@@ -710,7 +727,7 @@ __init int pkvm_init(void)
 	if (ret)
 		goto out;
 
-	ret = pkvm_init_mmu();
+	ret = pkvm_init_mmu(pkvm);
 	if (ret)
 		goto out;
 
-- 
2.25.1

