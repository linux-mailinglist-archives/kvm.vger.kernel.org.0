Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47FE6B646C
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjCLJ4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjCLJ4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:56:05 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A0939BBC
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614953; x=1710150953;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1IiCdw3xxDYufsBe948Foxd4ZKOtjoCDrxrb5jTdTAs=;
  b=HrOz38AFMlGVZa3mvJX8POch6Au7GBTCrrn2IZXx8IOlHQsIc5RMVkTd
   X/VETzNJFLu34hEdjUImP6faMX715za2ITLOzeTscCtkp9ZD1gdCteu3C
   ORkH5wwGGlDhlX/3+l7AWTV25wvG/xWIwMb+tkQitNno9l/Y0t5ecrdak
   nCe0tAFdP6oHV6VOSZps/j3IMjzfFoPAiwpP2j1WdhD6MV7iz0+q1ne1O
   O9Uv/2OrSDs9hGvpPK9zguGMRYg38T5SA7mA6tw8Wp9petpbcSRzpJweE
   MReK0bYoZj6gVzCREMgvOEhpuLky86t7eRKYCIOXyXCsWlUnWdzMZw7Tu
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623045"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623045"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660818"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660818"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:15 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Shaoqin Huang <shaoqin.huang@intel.com>
Subject: [RFC PATCH part-3 11/22] pkvm: x86: Add early allocator based mm_ops
Date:   Mon, 13 Mar 2023 02:01:41 +0800
Message-Id: <20230312180152.1778338-12-jason.cj.chen@intel.com>
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

The buddy page allocator need setting up based on virtual memory mapping
(vmemmap), it is based on MMU page table. Meanwhile MMU page table
setup for virtual memory mapping needs page allocator as well.

Before pKVM setup buddy page allocator, uses a early page allocator
based mm_ops for MMU page table.

This patch adds such mm_ops based on early page allocator, and it
will be used later for MMU page table early setup.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/early_alloc.c | 26 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/early_alloc.h |  3 +++
 2 files changed, 29 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/early_alloc.c b/arch/x86/kvm/vmx/pkvm/hyp/early_alloc.c
index aac5cf243874..6c2bf46f23c9 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/early_alloc.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/early_alloc.c
@@ -7,12 +7,21 @@
 #include <asm/pkvm_spinlock.h>
 #include <pkvm.h>
 
+#include "pgtable.h"
+
 static unsigned long base;
 static unsigned long end;
 static unsigned long cur;
 
 static pkvm_spinlock_t early_lock = __PKVM_SPINLOCK_UNLOCKED;
 
+struct pkvm_mm_ops pkvm_early_alloc_mm_ops;
+
+unsigned long pkvm_early_alloc_nr_used_pages(void)
+{
+	return (cur - base) >> PAGE_SHIFT;
+}
+
 void *pkvm_early_alloc_contig(unsigned int nr_pages)
 {
 	unsigned long size = (nr_pages << PAGE_SHIFT);
@@ -40,8 +49,25 @@ void *pkvm_early_alloc_page(void)
 	return pkvm_early_alloc_contig(1);
 }
 
+static void pkvm_early_alloc_get_page(void *addr) { }
+static void pkvm_early_alloc_put_page(void *addr) { }
+static void pkvm_early_flush_tlb(void) { }
+
+static int pkvm_early_page_count(void *vaddr)
+{
+	return 512;
+}
+
 void pkvm_early_alloc_init(void *virt, unsigned long size)
 {
 	base = cur = (unsigned long)virt;
 	end = base + size;
+
+	pkvm_early_alloc_mm_ops.zalloc_page = pkvm_early_alloc_page;
+	pkvm_early_alloc_mm_ops.get_page = pkvm_early_alloc_get_page;
+	pkvm_early_alloc_mm_ops.put_page = pkvm_early_alloc_put_page;
+	pkvm_early_alloc_mm_ops.phys_to_virt = pkvm_phys_to_virt;
+	pkvm_early_alloc_mm_ops.virt_to_phys = pkvm_virt_to_phys;
+	pkvm_early_alloc_mm_ops.page_count = pkvm_early_page_count;
+	pkvm_early_alloc_mm_ops.flush_tlb = pkvm_early_flush_tlb;
 }
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/early_alloc.h b/arch/x86/kvm/vmx/pkvm/hyp/early_alloc.h
index 96c041557d92..a1c2127442e0 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/early_alloc.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/early_alloc.h
@@ -5,8 +5,11 @@
 #ifndef __PKVM_EARLY_ALLOC_H
 #define __PKVM_EARLY_ALLOC_H
 
+unsigned long pkvm_early_alloc_nr_used_pages(void);
 void *pkvm_early_alloc_contig(unsigned int nr_pages);
 void *pkvm_early_alloc_page(void);
 void pkvm_early_alloc_init(void *virt, unsigned long size);
 
+extern struct pkvm_mm_ops pkvm_early_alloc_mm_ops;
+
 #endif
-- 
2.25.1

