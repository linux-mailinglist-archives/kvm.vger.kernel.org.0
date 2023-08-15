Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FBB77D0C1
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 19:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238720AbjHORTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 13:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238705AbjHORTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 13:19:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40651BC7;
        Tue, 15 Aug 2023 10:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692119951; x=1723655951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BoNjcydlwVP9IfhBLhVhZL9vVzO2yH4AyILTumiROh0=;
  b=QdtnaR9t0YnmjwpFejUdWX6A2J9/iu39WM7TOCdaC618aeEj8+1VErZJ
   TEFu1TV0RfUppsvS2BBdBO9WuR0GsM1vvb5qoUfCEfyGz2AFUNzxsT1CP
   cfaDg/MrdG/Ruo7wsr1iKUG4CQPUKSBszTlucG/Ul6jgyes3ij3Pcw/FJ
   ciJ3NiQpgqBYA98Q1QguN6Clbs0KPy1+12nEoYliUvl/rBIT8nGTH2iWi
   tT1YrL9uJWfrvSowcYGrn/Kl1d6c0CYkCZrvm5iu/tUyidCdrTJcyt3Fr
   AE6DzXDuE7XkOkpbYJYyg4tsqHyBNrAXET7ppZXRyifVuhPExEgebQp0J
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="362488586"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="362488586"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 10:19:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="848148968"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="848148968"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 10:19:04 -0700
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
Subject: [PATCH 1/8] KVM: gmem: Make kvm_gmem_bind return EBADF on wrong fd
Date:   Tue, 15 Aug 2023 10:18:48 -0700
Message-Id: <ea8d844e59a6586cc722dfa1af203560aa4795de.1692119201.git.isaku.yamahata@intel.com>
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

When kvm_gmem_bind() fails fget(), return EBADF instead of EINVAL because
EBADF is more appropriate.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/guest_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index db644f7fa48b..c81d2bb9ae93 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -479,7 +479,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	file = fget(fd);
 	if (!file)
-		return -EINVAL;
+		return -EBADF;
 
 	if (file->f_op != &kvm_gmem_fops)
 		goto err;
-- 
2.25.1

