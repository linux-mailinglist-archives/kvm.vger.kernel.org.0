Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7B77AA091
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbjIUUlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbjIUUlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:41:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A775B422;
        Thu, 21 Sep 2023 13:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695327287; x=1726863287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LZO5yjdBhkI2eq5MmnoYAkLMHFYrLWe3TrIyqhKkZPU=;
  b=VIaZlZxCI1JQuQnDmTFFVbkdoT8u44sVkbHmvQJ8KgQBTIfAcrRsWts+
   sv0b8WMqv/QmWZWSeID/QEL1b3TdATpnP6ccQERE5oUeV5xNyRuykX2VQ
   NHbEYCbr3nnyy4Xo/yYkDoNx/wHUHgEE8NQyIJ6uXRS4ch4ptscYql9te
   ADPmcTXxHJYtsXr7/OwLheGVdLFezRhxdiznRgpqFH+mKhuRaLtKNaFjF
   IRiYz2mV7oxrZywnz3O4MGqlWFXzRf2GPb0Df0nUiJV5up98zVbsfq1uQ
   nfNYDgIshJJ3/9GQgjG6KC6UioQB6efvScUXlt2ke8TTiySpPrW5jVMjj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="383401590"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="383401590"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 13:14:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="696897783"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="696897783"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 13:14:45 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Subject: [RFC PATCH v2 1/6] KVM: gmem: Truncate pages on punch hole
Date:   Thu, 21 Sep 2023 13:14:34 -0700
Message-Id: <f987dcde3b051371b496847282022c679e9402e4.1695327124.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1695327124.git.isaku.yamahata@intel.com>
References: <cover.1695327124.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Although kvm_gmem_punch_hole() keeps all pages in mapping on punching hole,
it's common expectation that pages are truncated.  Truncate pages on
punching hole.  As page contents can be encrypted, avoid zeroing partial
folio by refusing partial punch hole.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/guest_mem.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index a819367434e9..01fb4ca861d0 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -130,22 +130,32 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	struct list_head *gmem_list = &inode->i_mapping->private_list;
+	struct address_space *mapping  = inode->i_mapping;
 	pgoff_t start = offset >> PAGE_SHIFT;
 	pgoff_t end = (offset + len) >> PAGE_SHIFT;
 	struct kvm_gmem *gmem;
 
+	/*
+	 * punch hole may result in zeroing partial area.  As pages can be
+	 * encrypted, prohibit zeroing partial area.
+	 */
+	if (offset & ~PAGE_MASK || len & ~PAGE_MASK)
+		return -EINVAL;
+
 	/*
 	 * Bindings must stable across invalidation to ensure the start+end
 	 * are balanced.
 	 */
-	filemap_invalidate_lock(inode->i_mapping);
+	filemap_invalidate_lock(mapping);
 
 	list_for_each_entry(gmem, gmem_list, entry) {
 		kvm_gmem_invalidate_begin(gmem, start, end);
 		kvm_gmem_invalidate_end(gmem, start, end);
 	}
 
-	filemap_invalidate_unlock(inode->i_mapping);
+	truncate_inode_pages_range(mapping, offset, offset + len - 1);
+
+	filemap_invalidate_unlock(mapping);
 
 	return 0;
 }
-- 
2.25.1

