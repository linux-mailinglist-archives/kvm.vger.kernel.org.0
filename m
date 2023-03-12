Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5476B644B
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjCLJyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCLJyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB2C2CFFB
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614838; x=1710150838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HdTODpgsrkkGKJmOobJHES2OG7r2AJqH2m8RbxM1kXs=;
  b=Pt+zHWx4zHVPQ1REDk7q96lTpP1nQDmWEimnOFzzsbc9kCaqMNbcdcq3
   d8Igk0cv25LBwxB37GZwyavYc9WqQhCRctH55JvVg9hNyviaepV2mTMii
   H54sRgFzn1tDuvqgpnnizQS9OsD7OJcambPnRMSbHa/EMvy3tatCxLgUF
   GEAPMx98iW/rvZkckw0aAoEzhVVRQdDLnNojCEatSq5d9D4BbnbCSZzGk
   5jifqyy0DMIL+f54Wz/KayVfVqRGo8oKf1KhdtdHFjv17+RCx1wLgJcZe
   dVtUTNOLxB+jtjwjfgsUlpo2pVsRgk1X8u+fN6Vu3wDrXdRmKN5XyIzUk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622823"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622823"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:53:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852408907"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852408907"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:53:55 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-1 2/5] pkvm: arm64: Make page allocator arch agnostic
Date:   Mon, 13 Mar 2023 02:00:45 +0800
Message-Id: <20230312180048.1778187-3-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180048.1778187-1-jason.cj.chen@intel.com>
References: <20230312180048.1778187-1-jason.cj.chen@intel.com>
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

Move arm64 arch specific definitions in memory.h to asm/kvm_pkvm.h
and remove unnecessary asm/kvm_hyp.h including in page_alloc.c.
Then memory.h and page_alloc.c are arch agostic and can be moved
to general dir.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/arm64/include/asm/kvm_pkvm.h        | 3 +++
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 4 +---
 arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 1 -
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 01129b0d4c68..2cc283feb97d 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -8,12 +8,15 @@
 
 #include <linux/memblock.h>
 #include <asm/kvm_pgtable.h>
+#include <asm/kvm_mmu.h>
 
 /* Maximum number of VMs that can co-exist under pKVM. */
 #define KVM_MAX_PVMS 255
 
 #define HYP_MEMBLOCK_REGIONS 128
 
+#define __hyp_va(phys)	((void *)((phys_addr_t)(phys) - hyp_physvirt_offset))
+
 int pkvm_init_host_vm(struct kvm *kvm);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 void pkvm_destroy_hyp_vm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index ab205c4d6774..e7d05f41ddf2 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -2,7 +2,7 @@
 #ifndef __KVM_HYP_MEMORY_H
 #define __KVM_HYP_MEMORY_H
 
-#include <asm/kvm_mmu.h>
+#include <asm/kvm_pkvm.h>
 #include <asm/page.h>
 
 #include <linux/types.h>
@@ -15,8 +15,6 @@ struct hyp_page {
 extern u64 __hyp_vmemmap;
 #define hyp_vmemmap ((struct hyp_page *)__hyp_vmemmap)
 
-#define __hyp_va(phys)	((void *)((phys_addr_t)(phys) - hyp_physvirt_offset))
-
 static inline void *hyp_phys_to_virt(phys_addr_t phys)
 {
 	return __hyp_va(phys);
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 803ba3222e75..ef164102ab6a 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -4,7 +4,6 @@
  * Author: Quentin Perret <qperret@google.com>
  */
 
-#include <asm/kvm_hyp.h>
 #include <nvhe/gfp.h>
 
 u64 __hyp_vmemmap;
-- 
2.25.1

