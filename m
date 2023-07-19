Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA297590C9
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 11:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjGSJA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 05:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbjGSJAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 05:00:51 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E71A19B1;
        Wed, 19 Jul 2023 02:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689757250; x=1721293250;
  h=from:to:cc:subject:date:message-id;
  bh=nF9H3bO49HKidU+fzoDygP2E0naSyQmKuj1/sp95mHk=;
  b=ceF1wHvXKPyPsoMJq+dbXFsZvPHK5oHMfE06ocWnxTNHr49LeHXFYyob
   A29H8gBobX/LL6n32li3tMjXwh2V06+SrFKfWle1vT7YBEQd6uXYwt0lb
   4KzFKuqyXRIbhGpuwW1V2X1CUi/0pkjy7dsBzaJDY8uzDMsMpJCN3Mwpt
   xicxCCKPKGZnvOr4OUety8KEn84qs5xY7CqL1YwyX0Q11Ds+Z1h2brGBW
   bvVq8HwqQAwLVkG7tITRPEkgoBhC9FR9xTaoJGN8t8cg8vqKi3I0RatBv
   wHA3nuyUuMi1SlR0KIdy6NTW403SnaXgFqL95BSkXPYdMcrimnBEk6p6G
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="397263959"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="397263959"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 02:00:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="701227029"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="701227029"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 02:00:48 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, stevensd@chromium.org,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] KVM: allow mapping of compound tail pages for IO or PFNMAP mapping
Date:   Wed, 19 Jul 2023 16:33:32 +0800
Message-Id: <20230719083332.4584-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
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

Allow mapping of tail pages of compound pages for IO or PFNMAP mapping
by trying and getting ref count of its head page.

For IO or PFNMAP mapping, sometimes it's backed by compound pages.
KVM will just return error on mapping of tail pages of the compound pages,
as ref count of the tail pages are always 0.

So, rather than check and add ref count of a tail page, check and add ref
count of its folio (head page) to allow mapping of the compound tail pages.

This will not break the origial intention to disallow mapping of tail pages
of non-compound higher order allocations as the folio of a non-compound
tail page is the same as the page itself.

On the other side, put_page() has already converted page to folio before
putting page ref.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 138292a86174..6f2b51ef20f7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2551,7 +2551,7 @@ static int kvm_try_get_pfn(kvm_pfn_t pfn)
 	if (!page)
 		return 1;
 
-	return get_page_unless_zero(page);
+	return folio_try_get(page_folio(page));
 }
 
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,

base-commit: 24ff4c08e5bbdd7399d45f940f10fed030dfadda
-- 
2.17.1

