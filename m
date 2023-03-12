Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE946B649D
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjCLKAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjCLJ7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:36 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDEE515D2
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615121; x=1710151121;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gWKOkuF1Ys+mwVmwCpzUR9yutYKFoym7a4BDrlhOb90=;
  b=CD+kohz7X5imAqKbFGdhvzGzaxhM2rb5faxUpPiKdb7a7zuF2kU87cBO
   wGadDAl2nC3czvUlKandBr+YKuh4mqqoXkKhBxa6nQ8arClizXml67MXB
   2PebFkM7Bfq3rZ8NjpzoEQEcc1g/FYfJbU/tI1FovNB7vHz25qNrLtYvX
   rbWLwW6yc9AJ2E936BeVeskoyP3OYq1/SetevdDIbl/Hx4/JOpbu2Y9KL
   yb7Hlp/U/+3ZLoh4TS4yrQaXEDYVscjgnRkKfCZLAMlYFvwPClkL91AfX
   EExzbgfNq3q6KAsEtGeaEgNvwWqaNUh3VX1Llupq5eBMShVQA/i7nnMYU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344700"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344700"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627334"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627334"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:57 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-6 06/13] pkvm: x86: Add API to get the max phys address bits
Date:   Mon, 13 Mar 2023 02:03:38 +0800
Message-Id: <20230312180345.1778588-7-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180345.1778588-1-jason.cj.chen@intel.com>
References: <20230312180345.1778588-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chuanxiao Dong <chuanxiao.dong@intel.com>

Add API get_max_physaddr_bits(), this is necessary used to calculate
the reserved bits for EPT entry.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/memory.c | 21 +++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/memory.h |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/memory.c b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
index 43fc39d44c3d..9a9616ac4cc3 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/memory.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
@@ -10,9 +10,11 @@
 #include "memory.h"
 #include "pgtable.h"
 #include "pkvm_hyp.h"
+#include "cpu.h"
 
 unsigned long __page_base_offset;
 unsigned long __symbol_base_offset;
+static u8 max_physaddr_bits;
 
 unsigned int hyp_memblock_nr;
 struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
@@ -285,3 +287,22 @@ int write_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, void *addr, unsigned int bytes)
 {
 	return copy_gpa(vcpu, gpa, addr, bytes, false);
 }
+
+u64 get_max_physaddr_bits(void)
+{
+	u32 eax, ebx, ecx, edx;
+
+	if (max_physaddr_bits)
+		return max_physaddr_bits;
+
+	eax = 0x80000000;
+	ecx = 0;
+	native_cpuid(&eax, &ebx, &ecx, &edx);
+	if (eax >= 0x80000008) {
+		eax = 0x80000008;
+		native_cpuid(&eax, &ebx, &ecx, &edx);
+		max_physaddr_bits = (u8)eax & 0xff;
+	}
+
+	return max_physaddr_bits;
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/memory.h b/arch/x86/kvm/vmx/pkvm/hyp/memory.h
index a95ae5f71841..b1062f3703e3 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/memory.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/memory.h
@@ -32,4 +32,6 @@ int write_gva(struct kvm_vcpu *vcpu, gva_t gva, void *addr,
 int read_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, void *addr, unsigned int bytes);
 int write_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, void *addr, unsigned int bytes);
 
+u64 get_max_physaddr_bits(void);
+
 #endif
-- 
2.25.1

