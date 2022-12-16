Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7525564E8D9
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 10:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiLPJtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 04:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiLPJtg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 04:49:36 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6407D31DFB
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 01:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671184175; x=1702720175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bt9TYLqZw4RoghheoYihoIHhFL6ZTXmW3xA6aogLkwo=;
  b=fHzKGfaZZn9aMjOfKrksTyJg4ZIc3NXVfNOaIl7rK6d2Z7qqp/BB+6Ut
   lXH0nGYFzLg4WEgZTfK+vcKI3Mzl9gVjU8L8+/0M7agDlYQQGwLUHbxh1
   v97QymvYFuKfwSng2PQO2ljI4+PgxMq5+o24ga+WK50UFCkoUrugtKQug
   mtcwOlJVs79J1cvhZwQgl6nYhZ/B7Uf8i5DZRe1IweFrpZvuOpce4iOhi
   W0x80x2r3d7j54gmpgCZCpBsHHogUuooWMcXHMQUJHntSW3ijeXyLHvOe
   q/a/a+UcfUVa9NcrM36bz4Jw5cCNcRZkwNmLWDu68FfpCErskBx8Vw5CH
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="299270081"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="299270081"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 01:49:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="649752702"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="649752702"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by orsmga002.jf.intel.com with ESMTP; 16 Dec 2022 01:49:31 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, dwmw2@infradead.org,
        paul@xen.org
Subject: [PATCH v4 1/2] KVM: MMU: Introduce 'INVALID_GFN' and use it for GFN values
Date:   Fri, 16 Dec 2022 16:59:27 +0800
Message-Id: <20221216085928.1671901-2-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221216085928.1671901-1-yu.c.zhang@linux.intel.com>
References: <20221216085928.1671901-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, KVM xen and its shared info selftest code uses
'GPA_INVALID' for GFN values, but actually it is more accurate
to use the name 'INVALID_GFN'. So just add a new definition
and use it.

No functional changes intended.

Suggested-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/xen.c                                   | 4 ++--
 include/linux/kvm_types.h                            | 1 +
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d7af40240248..6908a74ab303 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -41,7 +41,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	int ret = 0;
 	int idx = srcu_read_lock(&kvm->srcu);
 
-	if (gfn == GPA_INVALID) {
+	if (gfn == INVALID_GFN) {
 		kvm_gpc_deactivate(gpc);
 		goto out;
 	}
@@ -659,7 +659,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		if (kvm->arch.xen.shinfo_cache.active)
 			data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_cache.gpa);
 		else
-			data->u.shared_info.gfn = GPA_INVALID;
+			data->u.shared_info.gfn = INVALID_GFN;
 		r = 0;
 		break;
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 76de36e56cdf..d21c0d7fee31 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -41,6 +41,7 @@ typedef u64            gpa_t;
 typedef u64            gfn_t;
 
 #define GPA_INVALID	(~(gpa_t)0)
+#define INVALID_GFN	(~(gfn_t)0)
 
 typedef unsigned long  hva_t;
 typedef u64            hpa_t;
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 721f6a693799..d65a23be88b1 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -20,7 +20,7 @@
 #include <sys/eventfd.h>
 
 /* Defined in include/linux/kvm_types.h */
-#define GPA_INVALID		(~(ulong)0)
+#define INVALID_GFN		(~(ulong)0)
 
 #define SHINFO_REGION_GVA	0xc0000000ULL
 #define SHINFO_REGION_GPA	0xc0000000ULL
@@ -419,7 +419,7 @@ static void *juggle_shinfo_state(void *arg)
 
 	struct kvm_xen_hvm_attr cache_destroy = {
 		.type = KVM_XEN_ATTR_TYPE_SHARED_INFO,
-		.u.shared_info.gfn = GPA_INVALID
+		.u.shared_info.gfn = INVALID_GFN
 	};
 
 	for (;;) {
-- 
2.25.1

