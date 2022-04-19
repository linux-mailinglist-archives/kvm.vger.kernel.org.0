Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2B1506993
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 13:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350961AbiDSLUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 07:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349339AbiDSLUJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 07:20:09 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B991F615;
        Tue, 19 Apr 2022 04:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650367047; x=1681903047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ApOZ19KKY/ZegfPl38ecJIUqs9w6pgZB1hZZKzFij3s=;
  b=BRnt9L87HfORXI/r+ybbi1Xfnq1hUAEHA0lvbHZ4UtNgVtZQJZ8InIIo
   gtwE0IWi1v0dsBktznltjJprAVgT8hYksmtn2yHH1Skj1wBYVWMbHop6m
   U0383P4ZqI2Ordkz1nT2qCPs9bxSry+CXh7lfS17hzDkg/UDC7Cr3xMJ/
   bcMhFBlT+VgzUhqZMBDEEGeg5xsPfWGVezUxHc9R92LrmiYw9hhmPy9cm
   wfJpXWu/tCazxmN41YZU7TW/jlw0IuYGNPv5VonOaPR7azNqRlRd7ze0j
   oIJvR0J5hIqtoc4uYtlBx5WTxQvXe+v6T4Ql3xPwK4bYdx6a/fvOnaHxH
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="350189753"
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="350189753"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 04:17:16 -0700
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="554683738"
Received: from csambran-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.58.20])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 04:17:14 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, jmattson@google.com,
        joro@8bytes.org, wanpengli@tencent.com
Subject: [PATCH 1/3] KVM: x86/mmu: Rename reset_rsvds_bits_mask()
Date:   Tue, 19 Apr 2022 23:17:02 +1200
Message-Id: <efdc174b85d55598880064b8bf09245d3791031d.1650363789.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1650363789.git.kai.huang@intel.com>
References: <cover.1650363789.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename reset_rsvds_bits_mask() to reset_guest_rsvds_bits_mask() to make
it clearer that it resets the reserved bits check for guest's page table
entries.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 69a30d6d1e2b..2931785f1e73 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4369,8 +4369,8 @@ static bool guest_can_use_gbpages(struct kvm_vcpu *vcpu)
 			     guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
 }
 
-static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
-				  struct kvm_mmu *context)
+static void reset_guest_rsvds_bits_mask(struct kvm_vcpu *vcpu,
+					struct kvm_mmu *context)
 {
 	__reset_rsvds_bits_mask(&context->guest_rsvd_check,
 				vcpu->arch.reserved_gpa_bits,
@@ -4669,7 +4669,7 @@ static void reset_guest_paging_metadata(struct kvm_vcpu *vcpu,
 	if (!is_cr0_pg(mmu))
 		return;
 
-	reset_rsvds_bits_mask(vcpu, mmu);
+	reset_guest_rsvds_bits_mask(vcpu, mmu);
 	update_permission_bitmask(mmu, false);
 	update_pkru_bitmask(mmu);
 }
-- 
2.35.1

