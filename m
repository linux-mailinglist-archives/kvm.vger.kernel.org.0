Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3958052A75E
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344994AbiEQPvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350799AbiEQPvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:51:31 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70CF227
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 08:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652802689; x=1684338689;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cHiPt+XcZXdU5PMPxLMx8JlJCddH7PwTNkDv1IBDh/g=;
  b=Q9PCK7JSlOGxfLzAPwuPdFTjYcZfMDZhPkbBz/7jWwT5jquLr0qLLRhH
   3mUU98KoXkfL7hfb1wJatapsBNQHw8dAe6tqWmwa8fIO2i+cQ9WFgUb+U
   rZX+jyWJ7Wq8H70REbv0n7TuwHpll4lZmjCbJhLN6GZOX1bBxwKWGGM+a
   afq3Nvgmj2yhToMxaQi5koP1olMk9XBrEF2gO4+dLmjtFfje55VpU7IuV
   repGd3gQPSQr64prRdGhHe168uHLm5qLRM5LHYfQWvy1LEfE87KMdV0p+
   QeWjGyodG6PFYmBcKWHhGlNRVswKoFjeg6wbCLLG07LHLrLGIxMIuq9Im
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="258788665"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="258788665"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:51:08 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="597199913"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:51:08 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, richard.henderson@linaro.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH] target/i386: Remove LBREn bit check when access Arch LBR MSRs
Date:   Tue, 17 May 2022 11:50:24 -0400
Message-Id: <20220517155024.33270-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Live migration can happen when Arch LBR LBREn bit is cleared,
e.g., when migration happens after guest entered SMM mode.
In this case, we still need to migrate Arch LBR MSRs.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/kvm/kvm.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a9ee8eebd7..e2d675115b 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3373,15 +3373,14 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
             int i, ret;
 
             /*
-             * Only migrate Arch LBR states when: 1) Arch LBR is enabled
-             * for migrated vcpu. 2) the host Arch LBR depth equals that
-             * of source guest's, this is to avoid mismatch of guest/host
-             * config for the msr hence avoid unexpected misbehavior.
+             * Only migrate Arch LBR states when the host Arch LBR depth
+             * equals that of source guest's, this is to avoid mismatch
+             * of guest/host config for the msr hence avoid unexpected
+             * misbehavior.
              */
             ret = kvm_get_one_msr(cpu, MSR_ARCH_LBR_DEPTH, &depth);
 
-            if (ret == 1 && (env->msr_lbr_ctl & 0x1) && !!depth &&
-                depth == env->msr_lbr_depth) {
+            if (ret == 1 && !!depth && depth == env->msr_lbr_depth) {
                 kvm_msr_entry_add(cpu, MSR_ARCH_LBR_CTL, env->msr_lbr_ctl);
                 kvm_msr_entry_add(cpu, MSR_ARCH_LBR_DEPTH, env->msr_lbr_depth);
 
@@ -3801,13 +3800,11 @@ static int kvm_get_msrs(X86CPU *cpu)
 
     if (kvm_enabled() && cpu->enable_pmu &&
         (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
-        uint64_t ctl, depth;
-        int i, ret2;
+        uint64_t depth;
+        int i, ret;
 
-        ret = kvm_get_one_msr(cpu, MSR_ARCH_LBR_CTL, &ctl);
-        ret2 = kvm_get_one_msr(cpu, MSR_ARCH_LBR_DEPTH, &depth);
-        if (ret == 1 && ret2 == 1 && (ctl & 0x1) &&
-            depth == ARCH_LBR_NR_ENTRIES) {
+        ret = kvm_get_one_msr(cpu, MSR_ARCH_LBR_DEPTH, &depth);
+        if (ret == 1 && depth == ARCH_LBR_NR_ENTRIES) {
             kvm_msr_entry_add(cpu, MSR_ARCH_LBR_CTL, 0);
             kvm_msr_entry_add(cpu, MSR_ARCH_LBR_DEPTH, 0);
 

base-commit: 8eccdb9eb84615291faef1257d5779ebfef7a0d0
-- 
2.27.0

