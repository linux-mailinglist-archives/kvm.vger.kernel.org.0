Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FA85F0888
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiI3KUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbiI3KTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:04 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637B315ED32;
        Fri, 30 Sep 2022 03:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533142; x=1696069142;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kRqGXwvT6ecA6jYMlkVRsGMRjPs2V/ytrmrzFD9hsU0=;
  b=n2790kdtTG2QAjtg4hD2bJ2XWQnx4nNzcfUmtDo6sZ+NH7Sp4oVPZt2v
   BqMAfEOJf/EOHJomHLroU7w3MzXfuZmkV5hsBQllPYhw4Z48AFxlI1xwk
   w7Ikl2uQYbRTrxKoRuQElCKYZZgKpF1ijrIWnMJCrNK8/34cU4ZojDHhL
   d6FOOL26/SBDbi+4tDqZpNNlVuAxTfdjnUj54c2xvZkhq4rnjMivDuZzl
   kI7eFGtnbQVSsEM+FZOyMmPPPYBl/kMJvOmD+2P91xTsZuTSHmRSCMn0t
   OJECKcDNCHv/MpuILN5TmZ85CxWViM1YJkBaW+puOF4fmSLY7IbbJpEY/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870093"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870093"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:57 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807619"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807619"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:57 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 036/105] KVM: x86/mmu: Disallow fast page fault on private GPA
Date:   Fri, 30 Sep 2022 03:17:30 -0700
Message-Id: <cd04c6a8bf26efe38d790073197670bb8b2c3f0d.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index f4d7432cd9fc..2fd70876d346 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3225,8 +3225,16 @@ static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fau
 	return RET_PF_CONTINUE;
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
 	 * Page faults with reserved bits set, i.e. faults on MMIO SPTEs, only
 	 * reach the common page fault handler if the SPTE has an invalid MMIO
@@ -3336,7 +3344,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	u64 *sptep = NULL;
 	uint retry_count = 0;
 
-	if (!page_fault_can_be_fast(fault))
+	if (!page_fault_can_be_fast(vcpu->kvm, fault))
 		return ret;
 
 	walk_shadow_page_lockless_begin(vcpu);
-- 
2.25.1

