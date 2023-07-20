Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929B575BB31
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 01:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjGTXdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 19:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjGTXdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 19:33:13 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0542271E;
        Thu, 20 Jul 2023 16:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689895992; x=1721431992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XgEvWWJfCSkaHXBU9qxLzS4Sis3yAaVmilVG11RQU2I=;
  b=L9wSSiW8AyJ6wMdwFw4Na4MHLObdhz0U4eI7XThUVgCgRapwy0/jU8+Y
   c/2chd8rQk0gAoXZiyxP9dOfetmdFPTi8TBrH0WHAnCOg2HfOqik3fPj1
   Rvs6CWVlk4INIrCBOoHlVv+7yohrjZjll+Vau7lBXQzUim+0Q3/5n4YnE
   2gdZ2ItVziMQJBvktwU1mClGix1niEt0N7QzXwvgVD1QdM1QyUCAiI5Fp
   xW+eaiiUVC8ZUjVUzoCvVg1B2aL8FDFCEgRcR5M0maxyr+vbymhMb2NyT
   FBH/3hmHgXigxoRfwzgAKQ9OLATpmOO71trghqHbS14TLpbavM+IPK4pd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="364355909"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="364355909"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 16:33:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="727891782"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="727891782"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 16:33:10 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [RFC PATCH v4 02/10] KVM: x86/mmu: Guard against collision with KVM-defined PFERR_IMPLICIT_ACCESS
Date:   Thu, 20 Jul 2023 16:32:48 -0700
Message-Id: <0d71b1cdd5d901478cbfd421b4b0071cce44e16a.1689893403.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1689893403.git.isaku.yamahata@intel.com>
References: <cover.1689893403.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Add an assertion in kvm_mmu_page_fault() to ensure the error code provided
by hardware doesn't conflict with KVM's software-defined IMPLICIT_ACCESS
flag.  In the unlikely scenario that future hardware starts using bit 48
for a hardware-defined flag, preserving the bit could result in KVM
incorrectly interpreting the unknown flag as KVM's IMPLICIT_ACCESS flag.

WARN so that any such conflict can be surfaced to KVM developers and
resolved, but otherwise ignore the bit as KVM can't possibly rely on a
flag it knows nothing about.

Fixes: 4f4aa80e3b88 ("KVM: X86: Handle implicit supervisor access with SMAP")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 05943ccb55a4..a9bbc20c7dfd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5822,6 +5822,17 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	int r, emulation_type = EMULTYPE_PF;
 	bool direct = vcpu->arch.mmu->root_role.direct;
 
+	/*
+	 * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP
+	 * checks when emulating instructions that triggers implicit access.
+	 * WARN if hardware generates a fault with an error code that collides
+	 * with the KVM-defined value.  Clear the flag and continue on, i.e.
+	 * don't terminate the VM, as KVM can't possibly be relying on a flag
+	 * that KVM doesn't know about.
+	 */
+	if (WARN_ON_ONCE(error_code & PFERR_IMPLICIT_ACCESS))
+		error_code &= ~PFERR_IMPLICIT_ACCESS;
+
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		return RET_PF_RETRY;
 
-- 
2.25.1

