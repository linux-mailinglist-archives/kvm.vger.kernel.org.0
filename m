Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455AE6A6D24
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 14:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCANiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 08:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjCANis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 08:38:48 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BC63C3C;
        Wed,  1 Mar 2023 05:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677677926; x=1709213926;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0ya9OVlQeRmAihszF7JDK54S+/9aNnOM4bPs8NX4tO8=;
  b=ADTuM2wBUAYJk7VuWVV4b5NMxEB2Hca8XfHpxB/4Ag1ncPt9RGDPCjIg
   NY6w3VSV9DRiwspDNa6FGnd1SSCIBZ4/n3okZIet3hVV57Q/Zi/Ra0iz8
   tGaPjauRAt240MWGouQcaMOeX5YW9GZuKAN02yzJrPbL9r0XKIraYw49O
   eOhjLfvbnIw6+GoSUmYRR7ZpTjC/UhMGB3svzjZTsOCwOBeXkDFxwL+zW
   b8jFMLGN0cZ5e41qYOwtRL1xB4yyasF+hWMo6Vjp0Ayws52ttdRFqAF6c
   VMIerKVySwQgITl840nU0sPwioHZ2qZ0bL4Ki5wYoVExnQs+MmNb6ncYP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="334442618"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="334442618"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 05:38:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="624495674"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="624495674"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by orsmga003.jf.intel.com with ESMTP; 01 Mar 2023 05:38:44 -0800
From:   Wei Wang <wei.w.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Date:   Wed,  1 Mar 2023 21:38:41 +0800
Message-Id: <20230301133841.18007-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current KVM_BUG and KVM_BUG_ON assumes that 'cond' passed from callers is
32-bit as it casts 'cond' to the type of int. This will be wrong if 'cond'
provided by a caller is 64-bit, e.g. an error code of 0xc0000d0300000000
will be converted to 0, which is not expected. Improves the implementation
by using !!(cond) in KVM_BUG and KVM_BUG_ON. Compared to changing 'int' to
'int64_t', this has less LOCs.

Fixes: 0b8f11737cff ("KVM: Add infrastructure and macro to mark VM as bugged")
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 include/linux/kvm_host.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f06635b24bd0..d77ddf82c5c8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -881,20 +881,16 @@ static inline void kvm_vm_bugged(struct kvm *kvm)
 
 #define KVM_BUG(cond, kvm, fmt...)				\
 ({								\
-	int __ret = (cond);					\
-								\
-	if (WARN_ONCE(__ret && !(kvm)->vm_bugged, fmt))		\
+	if (WARN_ONCE(!!cond && !(kvm)->vm_bugged, fmt))	\
 		kvm_vm_bugged(kvm);				\
-	unlikely(__ret);					\
+	unlikely(!!cond);					\
 })
 
 #define KVM_BUG_ON(cond, kvm)					\
 ({								\
-	int __ret = (cond);					\
-								\
-	if (WARN_ON_ONCE(__ret && !(kvm)->vm_bugged))		\
+	if (WARN_ON_ONCE(!!(cond) && !(kvm)->vm_bugged))	\
 		kvm_vm_bugged(kvm);				\
-	unlikely(__ret);					\
+	unlikely(!!(cond));					\
 })
 
 static inline void kvm_vcpu_srcu_read_lock(struct kvm_vcpu *vcpu)
-- 
2.27.0

