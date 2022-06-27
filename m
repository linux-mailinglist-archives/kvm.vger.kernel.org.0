Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C567555CE26
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241655AbiF0V4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241418AbiF0VzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E55640F;
        Mon, 27 Jun 2022 14:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366897; x=1687902897;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/jIO81u/RJYrHXhBzmbc+beycqBiMd2EoKXzDq8uJCQ=;
  b=nU8TgNXEc/rtwHBobX7WsyufxMglWNxL68+vdcnU4PZPPotrQZB02HuQ
   HvFrvmLqNzB50SabWZEpEVLNHuOSK3+2JIcFRB3lWwIKKKvCPuHdK7OVW
   u7fdBTJgAz1+25DcjyloqVb3atyu1lk/IL8uoNWhaW8jfP/8Bq1b254Oo
   SVuEyzjuGZLY8TAgXHOnuucDxa10SMtl4iH+j2vOEf3PNpKaGZyhd8kri
   YLPbcTv8PUIbcT+d9ifF48FGdK4uFJhkqMxNyjCqkyAJ9rv1MIOlWeV0g
   1w96U/rPXagz+szbCReOTqY+SN7zE4NO9mGw51GCglJq3EnDp69dcq4dT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609542"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609542"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:52 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863548"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:52 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v7 035/102] KVM: x86/mmu: Explicitly check for MMIO spte in fast page fault
Date:   Mon, 27 Jun 2022 14:53:27 -0700
Message-Id: <71e4c19d1dff8135792e6c5a17d3a483bc99875b.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 17252f39bd7c..51306b80f47c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3163,7 +3163,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		else
 			sptep = fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
 
-		if (!is_shadow_present_pte(spte))
+		if (!is_shadow_present_pte(spte) || is_mmio_spte(spte))
 			break;
 
 		sp = sptep_to_sp(sptep);
-- 
2.25.1

