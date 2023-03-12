Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B044B6B645E
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjCLJzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCLJyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C8E38EBE
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614893; x=1710150893;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LCX0tcJfy6zrjMnvkHOn49dbb5C03Tdle9pcnn9ojmc=;
  b=LcZEBi1mLBTSjief692yQZ3LiQoZ4N6PFuri2234xEdqK4bHFjrUZ4um
   Dkb0ph/D+m+xS+nzrpxhPdoemMxWG2anXIc/gwtBwd8pRxS5CYNLDGebi
   94h5oe0zLVSS3vxhr3C2DuHyQPosS0R7OMLNY30DFpJ+ZL3iCRNOnp+6H
   TeaD1Ybz4mvNZBUswU8xrdLee5MarBVCyzHvp6tceRHBSPqVWvk+TswNx
   GRUxpAdkg3B8lSbDui6ExNFpLaiololXjaA/9DpByZf6rYeGN4OnYtY1f
   zDmMEiHq3QG0LmG9fgqFqQ0mfK8Wnv1a1LdzyBnWf76AcKM6stlMAatqH
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622967"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622967"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852409052"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852409052"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:41 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Zide Chen <zide.chen@intel.com>
Subject: [RFC PATCH part-2 17/17] pkvm: x86: Stub CONFIG_DEBUG_LIST in pKVM
Date:   Mon, 13 Mar 2023 02:01:12 +0800
Message-Id: <20230312180112.1778254-18-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180112.1778254-1-jason.cj.chen@intel.com>
References: <20230312180112.1778254-1-jason.cj.chen@intel.com>
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

From: Zide Chen <zide.chen@intel.com>

To work with CONFIG_DEBUG_LIST, pKVM need to have its own
list_debug.c since the /lib version doesn't build into pKVM binary.

Simply return true in __list_add_valid() and __list_del_entry_valid().

Signed-off-by: Zide Chen <zide.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/Makefile         |  1 +
 arch/x86/kvm/vmx/pkvm/hyp/lib/list_debug.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index 09b749def56b..5a92067ab05a 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -11,6 +11,7 @@ lib-dir		:= lib
 pkvm-hyp-y	:= vmx_asm.o vmexit.o
 
 pkvm-hyp-$(CONFIG_RETPOLINE)	+= $(lib-dir)/retpoline.o
+pkvm-hyp-$(CONFIG_DEBUG_LIST)	+= $(lib-dir)/list_debug.o
 
 pkvm-obj 	:= $(patsubst %.o,%.pkvm.o,$(pkvm-hyp-y))
 obj-$(CONFIG_PKVM_INTEL)	+= pkvm.o
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/lib/list_debug.c b/arch/x86/kvm/vmx/pkvm/hyp/lib/list_debug.c
new file mode 100644
index 000000000000..26d3b24f821f
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/lib/list_debug.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#include <linux/list.h>
+
+bool __list_add_valid(struct list_head *new, struct list_head *prev,
+		struct list_head *next)
+{
+	return true;
+}
+
+bool __list_del_entry_valid(struct list_head *entry)
+{
+	return true;
+}
-- 
2.25.1

