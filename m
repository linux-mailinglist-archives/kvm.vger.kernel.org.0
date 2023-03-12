Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCB16B6464
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjCLJzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjCLJz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:55:28 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF3A515EE
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614909; x=1710150909;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=glvLe9O3fZVMXa86DbZH/2DRnOS1N+7vPTdy8O1ZRrc=;
  b=UkS3h0PmmCj0YLgm7xTLnsWTM7VzDbsetS+LE/rZiNibWNSLbMQqbkjV
   EjunknBCMlRadHJinPJc4NFWhr3+dnpQZ3MhcgDJPLi1fN3SfF76J6WNO
   nFGJgvDNJOdTU+2otIeJaxVlcMQXhb1Y1/C2HGptkeoSWnMPjbw+7yXKk
   BV6z6ej6PkBRfhWbP9J0I5KRQ+7isrPwI9bhqJrnTGuKFI2DanLepBw8s
   Fefmmv/PCGV6aV4S57o+S2kZjhH9jEFSDbVtoLZr8nE14a1xb7kP2OFLV
   EBT2rDms1yuz79qFWj93slxPh0d5AarfkuwEYoldFFZRXx8ARruvXPEKp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623020"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623020"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660789"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660789"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:03 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-3 03/22] pkvm: x86: Add memset lib
Date:   Mon, 13 Mar 2023 02:01:33 +0800
Message-Id: <20230312180152.1778338-4-jason.cj.chen@intel.com>
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

pKVM need its own memset library for the page allocator.

It cannot directly use arch/x86/lib/memset_64.S as memset_64.S is based
on ALTERNATIVE section which pKVM does not support yet.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/Makefile        |  1 +
 arch/x86/kvm/vmx/pkvm/hyp/lib/memset_64.S | 24 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index 970341ab63a3..f659debf4d76 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -10,6 +10,7 @@ lib-dir		:= lib
 
 pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o
 
+pkvm-hyp-y	+= $(lib-dir)/memset_64.o
 pkvm-hyp-$(CONFIG_RETPOLINE)	+= $(lib-dir)/retpoline.o
 pkvm-hyp-$(CONFIG_DEBUG_LIST)	+= $(lib-dir)/list_debug.o
 
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/lib/memset_64.S b/arch/x86/kvm/vmx/pkvm/hyp/lib/memset_64.S
new file mode 100644
index 000000000000..8c30d2f5f925
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/lib/memset_64.S
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright 2002 Andi Kleen, SuSE Labs */
+
+#include <linux/linkage.h>
+
+/*
+ * ISO C memset - set a memory block to a byte value. This function uses
+ * enhanced rep stosb to override the fast string function.
+ * The code is simpler and shorter than the fast string function as well.
+ *
+ * rdi   destination
+ * rsi   value (char)
+ * rdx   count (bytes)
+ *
+ * rax   original destination
+ */
+SYM_FUNC_START(memset)
+	movq %rdi,%r9
+	movb %sil,%al
+	movq %rdx,%rcx
+	rep stosb
+	movq %r9,%rax
+	RET
+SYM_FUNC_END(memset)
-- 
2.25.1

