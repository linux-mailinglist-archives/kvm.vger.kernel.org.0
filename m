Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1253C79E53E
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 12:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbjIMKt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 06:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239745AbjIMKtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 06:49:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD3219AD;
        Wed, 13 Sep 2023 03:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694602155; x=1726138155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vea9mvBaSY1mfkjysqPlMz9IcbWDu86rAIRw2ANf9IU=;
  b=S3B5mHPMRO04ej1QqK8YST3CxjOPhX/PJ+GA7bcc1SPCwSPFj51UwKIW
   I+0yTwV0jXkxBeSWFc3XIP00+Gz4jFkCq3dPT0a6qgc1hcexTjJwgrAVS
   8NsgedDGxo89PvAaj4z+WgI7jnB1dDhLMDZlvbE7jRtavRWzgtVQDwE4R
   pgVK8vCM1mYnQz7R3mXOoB7VWs9gvirXjoPVH+7OjV+Zw/l1Vl3gZE7At
   6T3xqm/gb6A4Re1Da0zsGv5aHRH1EjpSjVlv2powyT+MFdf91SnsWRfXX
   WGMTAVZ+7BI4hs4mdYXnLpirT+cYeF2LtzQuCfugs0VOpVJjAY18OToAH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="464994949"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="464994949"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 03:49:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="737451852"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="737451852"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 03:49:07 -0700
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
Subject: [RFC PATCH 1/6] KVM: guest_memfd: Add config to show the capability to handle error page
Date:   Wed, 13 Sep 2023 03:48:50 -0700
Message-Id: <56cd2f6f42351f2f27a07e5764bab7f689cc0059.1694599703.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1694599703.git.isaku.yamahata@intel.com>
References: <cover.1694599703.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add config, HAVE_GENERIC_PRIVATE_MEM_HANDLE_ERROR, to indicate kvm arch
can handle gmem error page.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/Kconfig     | 3 +++
 virt/kvm/guest_mem.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 1a48cb530092..624df45baff0 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -112,3 +112,6 @@ config KVM_GENERIC_PRIVATE_MEM
        select KVM_GENERIC_MEMORY_ATTRIBUTES
        select KVM_PRIVATE_MEM
        bool
+
+config HAVE_GENERIC_PRIVATE_MEM_HANDLE_ERROR
+	bool
diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index 85903c32163f..35d8f03e7937 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -307,6 +307,9 @@ static int kvm_gmem_error_page(struct address_space *mapping, struct page *page)
 	pgoff_t start, end;
 	gfn_t gfn;
 
+	if (!IS_ENABLED(CONFIG_HAVE_GENERIC_PRIVATE_MEM_HANDLE_ERROR))
+		return MF_IGNORED;
+
 	filemap_invalidate_lock_shared(mapping);
 
 	start = page->index;
-- 
2.25.1

