Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C83277D0C7
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 19:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238743AbjHORTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 13:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238708AbjHORTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 13:19:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873C51BCB;
        Tue, 15 Aug 2023 10:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692119952; x=1723655952;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OkwU5NRmSECTN4n1WrNtc+Oy7aJ1i53jsdIQEUuY6OA=;
  b=KRLrusZukpGbWoiE6WzJZIIibWnBUgB+eY4j8Roxcw4NKwuQX6dtHigS
   ij+9dYLSnPFDoxEe+mUtk7rP+uBB5GR1SeT0YAOtl5b5UYB8bcCJ4fEnL
   x4Y6PoUWFt4Yyg2RcpB7s3OPmA9pOz0nj7PqQsV+uXlEPMzOzjjPfuwOd
   2JRU3At0Ld4KrUYrD2hd2F9JnkItUSJfpb+ydQVJ0jKcJtiszIOcfPVeW
   o3tIhmj8O/PVUQD0fqJF84Ki0sXb2ApYpC7LarTPLufRjAI9K1now0/6N
   1lCF8tGjHWTPPAl+R5kwTsBSQC4IEU9Uckh/+v4GOJYn4SMhE0pXnA9HE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="362488602"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="362488602"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 10:19:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="848148975"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="848148975"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 10:19:05 -0700
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
Subject: [PATCH 3/8] KVM: gmem: Fix kvm_gmem_issue_arch_invalidate()
Date:   Tue, 15 Aug 2023 10:18:50 -0700
Message-Id: <ed4ab1239f0e048c25154884a1811214fb38587f.1692119201.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1692119201.git.isaku.yamahata@intel.com>
References: <cover.1692119201.git.isaku.yamahata@intel.com>
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

__filemap_get_folio() can return error.  Use IS_ERR_OR_NULL.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/guest_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index c81d2bb9ae93..ed03f1d12172 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -53,7 +53,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	struct folio *folio;
 
 	folio = kvm_gmem_get_huge_folio(inode, index);
-	if (!folio) {
+	if (IS_ERR_OR_NULL(folio)) {
 		folio = filemap_grab_folio(inode->i_mapping, index);
 		if (!folio)
 			return NULL;
-- 
2.25.1

