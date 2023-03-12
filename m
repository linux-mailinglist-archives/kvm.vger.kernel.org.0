Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8116B6477
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbjCLJ5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjCLJ5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:57:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBF251CAD
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615000; x=1710151000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/JVF401448jOaIWe1MURab9cRvsgbmH68Q7sC5IHKAk=;
  b=E6xc2V8LK4IbjXPia+NSP6vB9YYI5N39D96kHoo3xdR7RvdWEv1C56cb
   G3Lf214mWxADfMq/91nSh8fSqDuDBkKQud2Gm0MFoh6RXYpWP6x9/ZhmD
   KXU9WXn1l8F9ddilPa7w+1YpEw2SCVlZug9zvAJ6Rrob3qCLKnRA7NmTs
   ZJ5qSD3of7Q3XB3UOffl1jRjfG5pF9hnzIihai/zWLuUazEe3EaKedRxU
   sSPkE5/Y5u1CT7tNOR0KQkxtrxP27aX8kPdL/DR0x/lXuEdS4u/6mJ+8R
   6PF7FSs4SxvLKH3LA6mV6pf8AxotaaMOu5zKbz/qv0nihBsOZZ8YISCMv
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623068"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623068"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660856"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660856"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:30 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-3 21/22] pkvm: x86: Introduce find_mem_range API
Date:   Mon, 13 Mar 2023 02:01:51 +0800
Message-Id: <20230312180152.1778338-22-jason.cj.chen@intel.com>
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

From: Chuanxiao Dong <chuanxiao.dong@intel.com>

Add find_mem_range API support to indicate if a memory address belonging
to system memory. This is used to check if an EPT violation caused by
memory accessing in the later patch.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/memory.c | 37 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/memory.h |  8 +++++++
 2 files changed, 45 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/memory.c b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
index eb913cf08691..d3e479860189 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/memory.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
@@ -6,6 +6,8 @@
 #include <linux/types.h>
 #include <asm/kvm_pkvm.h>
 
+#include "memory.h"
+
 unsigned long __page_base_offset;
 unsigned long __symbol_base_offset;
 
@@ -26,3 +28,38 @@ unsigned long pkvm_virt_to_symbol_phys(void *virt)
 {
 	return (unsigned long)virt - __symbol_base_offset;
 }
+
+bool find_mem_range(unsigned long addr, struct mem_range *range)
+{
+	int cur, left = 0, right = hyp_memblock_nr;
+	struct memblock_region *reg;
+	unsigned long end;
+
+	range->start = 0;
+	range->end = ULONG_MAX;
+
+	/* The list of memblock regions is sorted, binary search it */
+	while (left < right) {
+		cur = (left + right) >> 1;
+		reg = &hyp_memory[cur];
+		end = reg->base + reg->size;
+		if (addr < reg->base) {
+			right = cur;
+			range->end = reg->base;
+		} else if (addr >= end) {
+			left = cur + 1;
+			range->start = end;
+		} else {
+			range->start = reg->base;
+			range->end = end;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+bool mem_range_included(struct mem_range *child, struct mem_range *parent)
+{
+	return parent->start <= child->start && child->end <= parent->end;
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/memory.h b/arch/x86/kvm/vmx/pkvm/hyp/memory.h
index 87b53275bc74..c9175272096b 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/memory.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/memory.h
@@ -12,4 +12,12 @@
 unsigned long pkvm_virt_to_symbol_phys(void *virt);
 #define __pkvm_pa_symbol(x) pkvm_virt_to_symbol_phys((void *)x)
 
+struct mem_range {
+	unsigned long start;
+	unsigned long end;
+};
+
+bool find_mem_range(unsigned long addr, struct mem_range *range);
+bool mem_range_included(struct mem_range *child, struct mem_range *parent);
+
 #endif
-- 
2.25.1

