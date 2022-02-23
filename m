Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF274C1906
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 17:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243020AbiBWQtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 11:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243019AbiBWQtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 11:49:43 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7D549FB4;
        Wed, 23 Feb 2022 08:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645634955; x=1677170955;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Bgt30IoON41EDSfpC3I1slWTpq2C/LiEym6tqqerch4=;
  b=cSw5O91xcWwZ/0nfG6PmkJBXN7lkuOnaFvgKbzrgcog2063DsdUxJp+l
   8cFYrH2m1vzpXsQmkdnn2RnP8/OuRR7HC3ycy1JlPwbm0rUOocr2vUe0V
   uBKjm24EwH0eNofOKJXfIjYK9KLiFuNbEg7on2UCh4LHFgp0BBFLUTTSL
   85QALT8FmVsrO8pX7jgByV7cRvu1tx7NbbqkHLaBhXGG9iALOtGzW4zcu
   2DgoD5jgLrTU6vGl8Cv2EBLWBaF8x+gmYAHm7liCD/e0yMHufl6kTsFck
   7Qlg8s1m4Z1yuJCRCKWFz0xsW5MbHKCx0W0/G8m/hg1aP9WmxzlkMTCn4
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="251938959"
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="251938959"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 08:44:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="591767550"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 23 Feb 2022 08:44:12 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 41D533BC; Wed, 23 Feb 2022 18:44:28 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] KVM: s390: Don't cast parameter in bit operations
Date:   Wed, 23 Feb 2022 18:44:20 +0200
Message-Id: <20220223164420.45344-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While in this particular case it would not be a (critical) issue,
the pattern itself is bad and error prone in case somebody blindly
copies to their code.

Don't cast parameter to unsigned long pointer in the bit operations.
Instead copy to a local variable on stack of a proper type and use.

Fixes: d77e64141e32 ("KVM: s390: implement GISA IPM related primitives")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/s390/include/asm/kvm_host.h | 5 ++++-
 arch/s390/kvm/interrupt.c        | 6 +++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index a22c9266ea05..f1c4a1b9b360 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -867,7 +867,10 @@ struct kvm_s390_gisa {
 			u8  reserved03[11];
 			u32 airq_count;
 		} g1;
-		struct {
+		struct { /* as a 256-bit bitmap */
+			DECLARE_BITMAP(b, 256);
+		} bitmap;
+		struct { /* as a set of 64-bit words */
 			u64 word[4];
 		} u64;
 	};
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index db933c252dbc..04e055cbd080 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -304,7 +304,7 @@ static inline int gisa_in_alert_list(struct kvm_s390_gisa *gisa)
 
 static inline void gisa_set_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
 {
-	set_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
+	set_bit_inv(IPM_BIT_OFFSET + gisc, gisa->bitmap.b);
 }
 
 static inline u8 gisa_get_ipm(struct kvm_s390_gisa *gisa)
@@ -314,12 +314,12 @@ static inline u8 gisa_get_ipm(struct kvm_s390_gisa *gisa)
 
 static inline void gisa_clear_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
 {
-	clear_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
+	clear_bit_inv(IPM_BIT_OFFSET + gisc, gisa->bitmap.b);
 }
 
 static inline int gisa_tac_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
 {
-	return test_and_clear_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
+	return test_and_clear_bit_inv(IPM_BIT_OFFSET + gisc, gisa->bitmap.b);
 }
 
 static inline unsigned long pending_irqs_no_gisa(struct kvm_vcpu *vcpu)
-- 
2.34.1

