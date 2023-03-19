Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21B56C0003
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 09:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjCSIWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 04:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCSIWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 04:22:41 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112D422C95
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 01:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679214159; x=1710750159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QlvC8KjyOonSyQURFfiETkdw4gYK4IaymmJRQr/dpF8=;
  b=ey4VF4wu1pAo7TAc0In55P83hCf3WW7L93m0qgqrwkFtq378zIjiKUDa
   X3JfXE5QHXVICGTiQK8QerNSQ1bB/SAPT0GnaYEjdYXH8y6k4mFXvJmjo
   Q8nlRew26Bejo4fgi20Z1A2R/GZ90DLm2aUcCeRq6fuEKv5QCepszyHy7
   OPYD6r20uD4TrjcxfOXC0xCFKGQZfuwTiTZB3DA4XpMtevuM6fyhNSrQu
   7rxIpLFyC8712kAIFxeoXTw7rHKlkS1xOZlX92E7vkQsxD+AEYyuJDbXp
   byT137jRpJqB3A9nvgYedonk/9V8eAO1KtqUkgD8D0qgPaycwi1ihICJc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="340849320"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="340849320"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:22:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="749741102"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="749741102"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.209.111])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:22:37 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     chao.gao@intel.com, robert.hu@linux.intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v2 1/4] x86: Allow setting of CR3 LAM bits if LAM supported
Date:   Sun, 19 Mar 2023 16:22:22 +0800
Message-Id: <20230319082225.14302-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230319082225.14302-1-binbin.wu@linux.intel.com>
References: <20230319082225.14302-1-binbin.wu@linux.intel.com>
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

If LAM is supported, VM entry allows CR3.LAM_U48 (bit 62) and CR3.LAM_U57
(bit 61) to be set in CR3 field.

Change the test result expectations when setting CR3.LAM_U48 or CR3.LAM_U57
on vmlaunch tests when LAM is supported.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 lib/x86/processor.h | 2 ++
 x86/vmx_tests.c     | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 3d58ef7..8373bbe 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -55,6 +55,8 @@
 #define X86_CR0_PG		BIT(X86_CR0_PG_BIT)
 
 #define X86_CR3_PCID_MASK	GENMASK(11, 0)
+#define X86_CR3_LAM_U57_BIT	(61)
+#define X86_CR3_LAM_U48_BIT	(62)
 
 #define X86_CR4_VME_BIT		(0)
 #define X86_CR4_VME		BIT(X86_CR4_VME_BIT)
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 7bba816..1be22ac 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7000,7 +7000,11 @@ static void test_host_ctl_regs(void)
 		cr3 = cr3_saved | (1ul << i);
 		vmcs_write(HOST_CR3, cr3);
 		report_prefix_pushf("HOST_CR3 %lx", cr3);
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+		if (this_cpu_has(X86_FEATURE_LAM) &&
+		    ((i==X86_CR3_LAM_U57_BIT) || (i==X86_CR3_LAM_U48_BIT)))
+			test_vmx_vmlaunch(0);
+		else
+			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 		report_prefix_pop();
 	}
 
-- 
2.25.1

