Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C03576148
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 14:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbiGOM17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 08:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbiGOM1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 08:27:54 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47977820D1;
        Fri, 15 Jul 2022 05:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657888074; x=1689424074;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xaU1bVTEUOkyAFR0nUY+nDjQv6o17TmyQoeupy1mtaA=;
  b=jjxDPDekHyY5ptd4AKqpZzgTPy0hLaBCcRmCyNiqJ6XTn9+kakLyfrfX
   1m+oVV1qv8b8poets68jXa/XN+uKETIcAJYgZHa0iDMSRxZwOZ7WRKFo1
   Ibaxv4HSD78mDIBHrJGgRMBduZEPC/+p5IowrStiaP6ZDTHsojSRhrlAh
   F1/xg5SgWyTvQlirmbOwLVwIuyrNoeEzvbxf6Hc27D/FkRc13xKii7/sE
   Cp/FxROSt12VUJ623/ZYGIkyhOP6Qm4FQ6hFhXNh2BONaMq6D1qbXxsDG
   cqJRRV7GqwZmU1RJDKAQnNabC6DN05bqEqqNhVV4ZAkfWXJAcawqf9WPL
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="286521377"
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="286521377"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 05:27:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="923489371"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by fmsmga005.fm.intel.com with ESMTP; 15 Jul 2022 05:27:52 -0700
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, joro@8bytes.org, wanpengli@tencent.com,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: X86: Initialize 'fault' in kvm_fixup_and_inject_pf_error().
Date:   Fri, 15 Jul 2022 19:42:10 +0800
Message-Id: <20220715114211.53175-2-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220715114211.53175-1-yu.c.zhang@linux.intel.com>
References: <20220715114211.53175-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_fixup_and_inject_pf_error() was introduced to fixup the error code(
e.g., to add RSVD flag) and inject the #PF to the guest, when guest
MAXPHYADDR is smaller than the host one.

When it comes to nested, L0 is expected to intercept and fix up the #PF
and then inject to L2 directly if
- L2.MAXPHYADDR < L0.MAXPHYADDR and
- L1 has no intention to intercept L2's #PF (e.g., L2 and L1 have the
  same MAXPHYADDR value && L1 is using EPT for L2),
instead of constructing a #PF VM Exit to L1. Currently, with PFEC_MASK
and PFEC_MATCH both set to 0 in vmcs02, the interception and injection
may happen on all L2 #PFs.

However, failing to initialize 'fault' in kvm_fixup_and_inject_pf_error()
may cause the fault.async_page_fault being NOT zeroed, and later the #PF
being treated as a nested async page fault, and then being injected to L1.
So just fix it by initialize the 'fault' value in the beginning.

Fixes: 897861479c064 ("KVM: x86: Add helper functions for illegal GPA checking and page fault injection")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216178
Reported-by: Yang Lixiao <lixiao.yang@intel.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 031678eff28e..3246b3c9dfb3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12983,7 +12983,7 @@ EXPORT_SYMBOL_GPL(kvm_spec_ctrl_test_value);
 void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
-	struct x86_exception fault;
+	struct x86_exception fault = {0};
 	u64 access = error_code &
 		(PFERR_WRITE_MASK | PFERR_FETCH_MASK | PFERR_USER_MASK);
 
-- 
2.25.1

