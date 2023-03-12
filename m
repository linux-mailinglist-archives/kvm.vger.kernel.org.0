Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD8B6B648C
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjCLJ7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjCLJ66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:58:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370626EB5
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615078; x=1710151078;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AG/WGab/Fwpu7sbhVbWQaNoyiToIH4cqlqnnRIr6VTU=;
  b=LXKah/ZNYJ8DfTNGTnNgbLkF18rgeekOteK4ExjLjh373yxx1SNy3B+y
   cBQfkrxWwW8wNgPfloCBjL52zc0CBge4kmq65JJtZ9USA5NDxZHdSSAfC
   WAjYkePpWnr/b6BaAXJ8G8QZvkp2SiYEr4X+lYQdT+RCD3P5FY+gWecaz
   0WfhTuy6BFLu2ZYLljghB+qFT23b15RhRl0YZvZD8U8kSBXtNbu1N4fiY
   K/GPfP5WPLlSa+n5ktS9MAs/rsM23duhWiDBhQVFCCVZD84p9GCj0qWnx
   857yZLFEesLxlj7z1ySzPgJht5a8PI5BIiZpoLjZ1eqBVvY8gg19JdhZ0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998120"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998120"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677737"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677737"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:24 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-5 14/22] pkvm: x86: Add msr ops for pKVM hypervisor
Date:   Mon, 13 Mar 2023 02:02:55 +0800
Message-Id: <20230312180303.1778492-15-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180303.1778492-1-jason.cj.chen@intel.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
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

Add pkvm msr ops, avoid using Linux msr ops directly to remove the
dependency of link to EXTABLE.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/cpu.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/cpu.h b/arch/x86/kvm/vmx/pkvm/hyp/cpu.h
index c49074292f7c..896c2984ffa6 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/cpu.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/cpu.h
@@ -13,6 +13,29 @@ static inline u64 pkvm_msr_read(u32 reg)
 	return (((u64)msrh << 32U) | msrl);
 }
 
+#define pkvm_rdmsr(msr, low, high)              \
+do {                                            \
+	u64 __val = pkvm_msr_read(msr);         \
+	(void)((low) = (u32)__val);             \
+	(void)((high) = (u32)(__val >> 32));    \
+} while (0)
+
+#define pkvm_rdmsrl(msr, val)                   \
+	((val) = pkvm_msr_read((msr)))
+
+static inline void pkvm_msr_write(u32 reg, u64 msr_val)
+{
+	asm volatile (" wrmsr " : : "c" (reg), "a" ((u32)msr_val), "d" ((u32)(msr_val >> 32U)));
+}
+
+#define pkvm_wrmsr(msr, low, high)              	\
+do {                                            	\
+	u64 __val = (u64)(high) << 32 | (u64)(low); 	\
+	pkvm_msr_write(msr, __val);             	\
+} while (0)
+
+#define pkvm_wrmsrl(msr, val)   pkvm_msr_write(msr, val)
+
 #ifdef CONFIG_PKVM_INTEL_DEBUG
 #include <linux/smp.h>
 static inline u64 get_pcpu_id(void)
-- 
2.25.1

