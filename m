Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E196B6466
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjCLJz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjCLJzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:55:40 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9154D2A0
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614919; x=1710150919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NpVq0tN8XID6dFGHx5ZB/HJK+y5R2021byqOdPebhHo=;
  b=cSYUQH8uK3txhWA+sqF7a6rT6q6hG2qdnsTn9RH6uE29ozeR7V3VDEQd
   WPmsyYERhQQen2r2qML31phuh/RMIqAJTguCP78UzTHCF36V8mHhbB408
   Fym3YySk1mhLGeqdg0/AgJM6mGfvSTFh100ksDSOfoHuNGy4k5UlmrFd3
   Ag+WDu1GF2yke9G7SSsPjtcOrhWYHRuFUb1cRo2dSJ2WbzjQmkU83TBFW
   fzlYRaP6KlLBhEC26K92K1KxiuV0xsmiq6LJBrwIAzu6r33UWV2Y4cu0k
   FyV4ZZiiGE4l8Dld+hJZvlknfSz7AxX8d/P7evT+OUsRcmbiarYvmkuLD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623025"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623025"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660797"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660797"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:05 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Shaoqin Huang <shaoqin.huang@intel.com>
Subject: [RFC PATCH part-3 05/22] pkvm: x86: Generate pkvm_constants.h for pKVM initialization
Date:   Mon, 13 Mar 2023 02:01:35 +0800
Message-Id: <20230312180152.1778338-6-jason.cj.chen@intel.com>
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

The pKVM runtime data structure is private in VMX root mode, it shall
not be exposed to host Linux. Meanwhile during pKVM initialization, host
need to allocate memory for pKVM based on such runtime data structure.

Generate pkvm_constants.h to provide constants such as structure size to
the pKVM init without dragging in the definitions themselves.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/.gitignore                |  1 +
 arch/x86/kvm/vmx/pkvm/Makefile         | 17 +++++++++++++++++
 arch/x86/kvm/vmx/pkvm/pkvm_constants.c | 15 +++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/arch/x86/kvm/.gitignore b/arch/x86/kvm/.gitignore
index 615d6ff35c00..04913dc233b1 100644
--- a/arch/x86/kvm/.gitignore
+++ b/arch/x86/kvm/.gitignore
@@ -1,2 +1,3 @@
 /kvm-asm-offsets.s
 /kvm-asm-offsets.h
+pkvm_constants.h
diff --git a/arch/x86/kvm/vmx/pkvm/Makefile b/arch/x86/kvm/vmx/pkvm/Makefile
index ed0629baf449..fa90a7375f6f 100644
--- a/arch/x86/kvm/vmx/pkvm/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/Makefile
@@ -7,3 +7,20 @@ pkvm-obj		:= pkvm_host.o
 
 obj-$(CONFIG_PKVM_INTEL)	+= $(pkvm-obj)
 obj-$(CONFIG_PKVM_INTEL)	+= hyp/
+
+always-y := pkvm_constants.h pkvm-constants.s
+
+define rule_gen_hyp_constants
+        $(call filechk,offsets,__PKVM_CONSTANTS_H__)
+endef
+
+CFLAGS_pkvm-constants.o = -I $(src)/include
+CFLAGS_pkvm-constants.o += -I $(srctree)/virt/kvm/pkvm
+$(obj)/pkvm-constants.s: $(src)/pkvm_constants.c FORCE
+	        $(call if_changed_dep,cc_s_c)
+
+$(obj)/pkvm_constants.h: $(obj)/pkvm-constants.s FORCE
+	        $(call if_changed_rule,gen_hyp_constants)
+
+obj-intel-pkvm := $(addprefix $(obj)/, $(pkvm-obj))
+$(obj-intel-pkvm): $(obj)/pkvm_constants.h
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_constants.c b/arch/x86/kvm/vmx/pkvm/pkvm_constants.c
new file mode 100644
index 000000000000..729147e6b85f
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_constants.c
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#include <linux/kbuild.h>
+#include <linux/bug.h>
+#include <vdso/limits.h>
+#include <buddy_memory.h>
+
+int main(void)
+{
+	DEFINE(PKVM_VMEMMAP_ENTRY_SIZE, sizeof(struct hyp_page));
+	return 0;
+}
-- 
2.25.1

