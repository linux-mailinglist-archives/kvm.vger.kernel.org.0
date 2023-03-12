Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218F16B647F
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjCLJ6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjCLJ6A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:58:00 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B17656785
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615047; x=1710151047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8GeyfmjA2v6m5gyxDArFiKnkdq1a+4Fmk3OZAtrfGkw=;
  b=ZLauv/1/IBAJxR542U74zMgqIspDSOT3VDntxmfmmCkbQspmlYXhUjgL
   FCRuqa7bM89yLZnsCLMGQFgbuSzbXs2+QPeA0FiAgQ6FXynik/8Z6umgw
   v9lMxaKAbnL13m2DRQh/7ZSyC5Bb0od3jmAm4owtEhVPv/d/9RW+W8YjG
   voISDdGKbVXGHW2J6XDV0mUO/8Pj42ZPwpKZ+qdtdHqeH7TW42IJQF91T
   2r2qyxl5+b4+plVsEOvlVc3hR6KNEKOvO9U2j3eZ/059p2CyNEXK1p3ZL
   kU5Qm6Lc1u6SL+Kt/istRJXwemf7kAAvLza0EYVfgZ5r/yUkUXLbkhkHF
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998091"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998091"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677643"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677643"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:09 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-5 01/22] pkvm: x86: Add memcpy lib
Date:   Mon, 13 Mar 2023 02:02:42 +0800
Message-Id: <20230312180303.1778492-2-jason.cj.chen@intel.com>
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

pKVM need its own memcpy library, it cannot directly use
arch/x86/lib/memcpy_64.S as it's based on ALTERNATIVE section
which pKVM does not support yet.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/Makefile        |  1 +
 arch/x86/kvm/vmx/pkvm/hyp/lib/memcpy_64.S | 26 +++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index fe852bd43a7e..9c410ec96f45 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -17,6 +17,7 @@ pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o mmu.o pkvm.o \
 ifndef CONFIG_PKVM_INTEL_DEBUG
 lib-dir		:= lib
 pkvm-hyp-y	+= $(lib-dir)/memset_64.o
+pkvm-hyp-y	+= $(lib-dir)/memcpy_64.o
 pkvm-hyp-$(CONFIG_RETPOLINE)	+= $(lib-dir)/retpoline.o
 pkvm-hyp-$(CONFIG_DEBUG_LIST)	+= $(lib-dir)/list_debug.o
 endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/lib/memcpy_64.S b/arch/x86/kvm/vmx/pkvm/hyp/lib/memcpy_64.S
new file mode 100644
index 000000000000..b976f646d352
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/lib/memcpy_64.S
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright 2002 Andi Kleen */
+
+#include <linux/linkage.h>
+
+/*
+ * memcpy - Copy a memory block.
+ *
+ * Input:
+ *  rdi destination
+ *  rsi source
+ *  rdx count
+ *
+ * Output:
+ * rax original destination
+ *
+ * This is enhanced fast string memcpy. It is faster and
+ * simpler than old memcpy.
+ */
+
+SYM_FUNC_START(memcpy)
+	movq %rdi, %rax
+	movq %rdx, %rcx
+	rep movsb
+	RET
+SYM_FUNC_END(memcpy)
-- 
2.25.1

