Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0033B51C782
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383252AbiEESWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383240AbiEESTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:42 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFFB5DA1E;
        Thu,  5 May 2022 11:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774555; x=1683310555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YNoW9z1ClCT7swG5JfpwbF3FFn47leQenTkTt1akezE=;
  b=MNUYsTUnOaywXuL/FpdO4Bn2jHnGuvSqymdOz/JYQ9VLPYWvk63ALnxf
   geeShMjHVpeYX1EyNnj95yF/ouakGO5pbqf0c1Rm5DkWZomybvbsZgpgi
   Z78OvA15MrZplPh39pOn5TDYquEgSnxf8GmWMcROTGmk9f9woBiFKp4AF
   yxA+NpYS2Uzsm0++3Eqw9qZoeXWN6nBD6zMoGe42u0L1jkNbu/ghVvfrW
   wrr6HAR3tA70kReH6/zKWhklphEOh0XGGWVRkDuRbo7OoCjtCieSG0rgn
   whCsMQSGaR8kDFIxzZ8ElIl64t0BwHLEPSx+MrzKxr0Jk2Vw63yWsarDZ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248742023"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="248742023"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:45 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083270"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:45 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 039/104] KVM: x86/mmu: Disallow fast page fault on private GPA
Date:   Thu,  5 May 2022 11:14:33 -0700
Message-Id: <7a8550ac1ed70fea901756f84b10960a07089140.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX requires TDX SEAMCALL to operate Secure EPT instead of direct memory
access and TDX SEAMCALL is heavy operation.  Fast page fault on private GPA
doesn't make sense.  Disallow fast page fault on private GPA.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f4758b1b5202..8b26729cb9c4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3108,8 +3108,16 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 	return false;
 }
 
-static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
+static bool page_fault_can_be_fast(struct kvm *kvm, struct kvm_page_fault *fault)
 {
+	/*
+	 * TDX private mapping doesn't support fast page fault because the EPT
+	 * entry is read/written with TDX SEAMCALLs instead of direct memory
+	 * access.
+	 */
+	if (kvm_is_private_gpa(kvm, fault->addr))
+		return false;
+
 	/*
 	 * Do not fix the mmio spte with invalid generation number which
 	 * need to be updated by slow page fault path.
@@ -3213,7 +3221,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	u64 *sptep = NULL;
 	uint retry_count = 0;
 
-	if (!page_fault_can_be_fast(fault))
+	if (!page_fault_can_be_fast(vcpu->kvm, fault))
 		return ret;
 
 	walk_shadow_page_lockless_begin(vcpu);
-- 
2.25.1

