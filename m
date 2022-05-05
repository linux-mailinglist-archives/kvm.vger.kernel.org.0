Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B9751C75B
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383178AbiEESWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383211AbiEESTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A57A41FAE;
        Thu,  5 May 2022 11:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774553; x=1683310553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c4l/dtPeYjGdPkK10ruYt5hIF0woALL4dwVeXy0KjaY=;
  b=hRutbVcxKGYmQS4BmALpfPmhHvRcKPq0zrEaKPyhMl+RvrwdYqDcqYZu
   zrTYfrKtVot5MvrCfUhq5Tg8qcNWfaIbo+WteMU0lyxuV/kCPZ96VWIYZ
   EKiGDSkgeEdlUuirGXzlwvF52FkaFt8RKtIuSCO0BOS2gZwdy/Mahw4sa
   UrYqOxIqySq05pD6fQW6FfR/+Y32HXfJeArYIqHd1N3004YrZKqpW9Ean
   P4UXI5EDVE+JAm2KPjFctthkAw8p4pOMemcHATPrQ/gq9QEyC9MO4NtV8
   GuD/Fqo4oKKvcU95+Ob1VrpDkFMCHgM+BP9di/d8lThgwqosfgE1p36w7
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248742018"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="248742018"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:45 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083257"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:45 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 036/104] KVM: x86/mmu: Explicitly check for MMIO spte in fast page fault
Date:   Thu,  5 May 2022 11:14:30 -0700
Message-Id: <d1a1da631b44f425d929767fda74c90de2d87a8d.1651774250.git.isaku.yamahata@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

Explicitly check for an MMIO spte in the fast page fault flow.  TDX will
use a not-present entry for MMIO sptes, which can be mistaken for an
access-tracked spte since both have SPTE_SPECIAL_MASK set.

MMIO sptes are handled in handle_mmio_page_fault for non-TDX VMs, so this
patch does not affect them.  TDX will handle MMIO emulation through a
hypercall instead.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d1c37295bb6e..4a12d862bbb6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3184,7 +3184,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		else
 			sptep = fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
 
-		if (!is_shadow_present_pte(spte))
+		if (!is_shadow_present_pte(spte) || is_mmio_spte(spte))
 			break;
 
 		sp = sptep_to_sp(sptep);
-- 
2.25.1

