Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67FF6B64A2
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjCLKAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjCLJ7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B1251F8F
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615130; x=1710151130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uSSps+n8kuY9g/GF9FbOkXe2GUn6Pc1ldp9U4vK2UYo=;
  b=mfiL4GI0WKnBee2OgG0+Ec1ShqjtQBtaDvMs69W341qpeIQrMzmalCkE
   KEpx7b+oPfLjHvY2yKtBv4KtSEa0d0cSq5S/B8ZjBBr5kC2cYejHujq4d
   psOdIf9TuJ7U60k59aKfI3TEBv/XkiScQdTFGrk0+DR5h+Oi8XM7pcR00
   JvEbyunYbqlf0x1+OIzv4XopZ0pfiUeTPdUzkkCkTExKLHuvP7tsts6+4
   nZ5o2xmyGKSzjly32bh57ci8wXuCZxkR5QSlLB2Kg64rhC96cRHMEP4OV
   i/ZxQO0bmJ6XxfvkMr48NgSSkzqcgRAL+Ht4nYInJSMj0/1Fplmjn6Pw+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344710"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344710"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627354"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627354"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:00 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-6 09/13] pkvm: x86: Introduce PKVM_ASSERT
Date:   Mon, 13 Mar 2023 02:03:41 +0800
Message-Id: <20230312180345.1778588-10-jason.cj.chen@intel.com>
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

Add new file bug.h to support PKVM_ASSERT.

If CONFIG_PKVM_INTEL_DEBUG enabled, print out assertion information then
call into Linux BUG(), otherwise just do a dead loop.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/bug.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/bug.h b/arch/x86/kvm/vmx/pkvm/hyp/bug.h
new file mode 100644
index 000000000000..ca333708cc98
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/bug.h
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#ifndef __PKVM_BUG_H
+#define __PKVM_BUG_H
+
+#ifdef CONFIG_PKVM_INTEL_DEBUG
+#include <linux/printk.h>
+
+#define PKVM_ASSERT(c)                                          \
+do {                                                            \
+	if (!(c)) {                                             \
+		pr_err("assertion failed %s: %d: %s\n",         \
+			__FILE__, __LINE__, #c);                \
+		BUG();                                          \
+	}                                                       \
+} while (0)
+#else
+#define PKVM_ASSERT(c) do { } while (!(c))
+#endif
+
+#endif
-- 
2.25.1

