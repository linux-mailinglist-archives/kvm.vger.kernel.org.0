Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3276B646D
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjCLJ4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjCLJ4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:56:13 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12A851FA5
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614959; x=1710150959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uW+75FyUIq5lWepgviwCvOehNU3GIxZyts3haiDicm8=;
  b=kEnK8BXWCJ4VMtaqf33LJUjhZzxQf6vHNQ9rW+y72qkkt34kB98+dBs7
   rx8oHcPvZZ4pdBboEgSkpIdIWRa+WduM+6Pa5fuvgRv2kxy5WyxmipN1E
   su+qdL0pil9pK2W3DlhXJjInENlKdgYXTnmwKxnV4fv3M4dBjdelNPPBV
   Ngx2vFEWLMKKJZwz06NWomE12ACrDGrEFgn7quLPfHxobbrF8qnPJXGfP
   HJRVKRyct8/SsQ1Y7XAIk+GXbuJ+ssC1GhDGQdUNdrELTbiu+f3Dz9g99
   GOnHG18K3N5PAQvhUFgCrlMSrrQMWMBa8QLwK2MeIUcYbJsOH2dA8lGIg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623048"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623048"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660821"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660821"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:16 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-3 12/22] pkvm: x86: Define linker script alias for kernel-proper symbol
Date:   Mon, 13 Mar 2023 02:01:42 +0800
Message-Id: <20230312180152.1778338-13-jason.cj.chen@intel.com>
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

Define a linker script alias of a kernel-proper symbol referenced by
pKVM code.

pKVM can directly use the alias defined symbol when sharing some
Linux kernel header files, for example, the global physical_mask used
by __PHYSICAL_MASK if CONFIG_DYNAMIC_PHYSICAL_MASK=true.

TODO: security analysis if a kernel symbol can be directly used by
pKVM.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/include/asm/pkvm_image.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/pkvm_image.h b/arch/x86/include/asm/pkvm_image.h
index 191776677ce2..ed026b740a78 100644
--- a/arch/x86/include/asm/pkvm_image.h
+++ b/arch/x86/include/asm/pkvm_image.h
@@ -37,6 +37,12 @@
 		*(NAME NAME##.*)		\
 	END_PKVM_SECTION
 
+/*
+ * Defines a linker script alias of a kernel-proper symbol referenced by
+ * PKVM code.
+ */
+#define PKVM_ALIAS(sym)  pkvm_sym(sym) = sym;
+
 #endif /* LINKER_SCRIPT */
 
 #endif /* __X86_INTEL_PKVM_IMAGE_H */
-- 
2.25.1

