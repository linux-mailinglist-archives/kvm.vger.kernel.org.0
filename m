Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134A5741BD4
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 00:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjF1WoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 18:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjF1Wn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 18:43:27 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B3F2718;
        Wed, 28 Jun 2023 15:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687992205; x=1719528205;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6umfemwMrYz7WsXi1NlQUufCvU391Sg+THAWamuc+xA=;
  b=iApbV70icuAbdT/5dIrjojSKpNPuTyJJ4R2J4ZJR2jDJdWjiR53zQhI1
   lTT3XZqi4AERoQmOB8DTTDZR0T2+JwkBrGaQZmFqr0p62yNt7fnnCqBuJ
   cRkDkAduMul4IdKXFE0GO8zLDKKQD1sUwZROeJHwdxra7tq1jFtzS66Xx
   6iKQhbpI2Q55XhMUSpv/figvEtRgUUUoezCJ3KfllsfZedk/7j/8nP+t4
   X/7durnmWT3F2RijVbnSgAPwwOLF0CX6VYCXIC4sms9bTGHAbTH2R68gl
   er00vDvW+k4OcyfcGYmEi76O2UOcbXymrZLgIYr6qPtR2ElZZgLvjsXjP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="392699165"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="392699165"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 15:43:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="830300010"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="830300010"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 15:43:24 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [RFC PATCH v3 08/11] KVM: Fix set_mem_attr ioctl when error case
Date:   Wed, 28 Jun 2023 15:43:07 -0700
Message-Id: <358fb191b3690a5cbc2c985d3ffc67224df11cf3.1687991811.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1687991811.git.isaku.yamahata@intel.com>
References: <cover.1687991811.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

kvm_vm_ioctl_set_mem_attributes() discarded an error code of xa_err()
unconditionally.  If an error occurred at the beginning, return error.

Fixes: 3779c214835b ("KVM: Introduce per-page memory attributes")
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
Changes v2 -> v3:
- Newly added
---
 virt/kvm/kvm_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 422d49634c56..fdef56f85174 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2423,6 +2423,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	gfn_t start, end;
 	unsigned long i;
 	void *entry;
+	int err = 0;
 
 	/* flags is currently not used. */
 	if (attrs->flags)
@@ -2447,14 +2448,17 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	KVM_MMU_UNLOCK(kvm);
 
 	for (i = start; i < end; i++) {
-		if (xa_err(xa_store(&kvm->mem_attr_array, i, entry,
-				    GFP_KERNEL_ACCOUNT)))
+		err = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
+				      GFP_KERNEL_ACCOUNT));
+		if (err)
 			break;
 	}
 
 	KVM_MMU_LOCK(kvm);
-	if (i > start)
+	if (i > start) {
+		err = 0;
 		kvm_mem_attrs_changed(kvm, attrs->attributes, start, i);
+	}
 	kvm_mmu_invalidate_end(kvm);
 	KVM_MMU_UNLOCK(kvm);
 
@@ -2463,7 +2467,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	attrs->address = i << PAGE_SHIFT;
 	attrs->size = (end - i) << PAGE_SHIFT;
 
-	return 0;
+	return err;
 }
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
-- 
2.25.1

