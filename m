Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F02657614A
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 14:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbiGOM2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 08:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbiGOM15 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 08:27:57 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F111B820E2;
        Fri, 15 Jul 2022 05:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657888077; x=1689424077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dtN96Vtsk0x/JnLZa6/RM9i7qqgric7JQsZSYrj4I2s=;
  b=WDV6pdVxMLoPuC1Bp1n7oBVeH9tjYyK9NKxL8iQ8KwyJqG8IDolkr2TW
   puBgb2tlzHcbYK9uTQJ7MvoQl0QS4i7A5LLEaQj4t752uyLTGQUebzQk/
   mt71IKtvG2vAGgJHjl3Z/PrZFpWVfvcgAjq0x4KRHOo5EQRQT3VLpZghg
   x1dZdS/IWamRS16oeIdl48pnZWKqmkyGw+lu3AqLUt+AznEI8tSUw4V7P
   hGZ+/GBuPrhUc0vGH1LuBs/hLkwINsgM+DBKB2JkcilyMYCiaPtsYLusT
   M0x2bNtaGrUmVaaSL2j+jc2G5irwz7OGpGshHxzC/usM2su0wlHo9G8f3
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="286521390"
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="286521390"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 05:27:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="923489376"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by fmsmga005.fm.intel.com with ESMTP; 15 Jul 2022 05:27:54 -0700
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, joro@8bytes.org, wanpengli@tencent.com,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: X86: Fix the comments in prepare_vmcs02_rare()
Date:   Fri, 15 Jul 2022 19:42:11 +0800
Message-Id: <20220715114211.53175-3-yu.c.zhang@linux.intel.com>
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

Although EB.PF in vmcs02 is still set by simply "or"ing the EB of
vmcs01 and vmcs12, the explanation is obsolete. "enable_ept" being
set is not the only reason for L0 to clear its EB.PF.

Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 778f82015f03..634a7d218048 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2451,10 +2451,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 * is not easy (if at all possible?) to merge L0 and L1's desires, we
 	 * simply ask to exit on each and every L2 page fault. This is done by
 	 * setting MASK=MATCH=0 and (see below) EB.PF=1.
-	 * Note that below we don't need special code to set EB.PF beyond the
-	 * "or"ing of the EB of vmcs01 and vmcs12, because when enable_ept,
-	 * vmcs01's EB.PF is 0 so the "or" will take vmcs12's value, and when
-	 * !enable_ept, EB.PF is 1, so the "or" will always be 1.
+	 * Note that EB.PF is set by "or"ing of the EB of vmcs01 and vmcs12,
+	 * because when L0 has no desire to intercept #PF, vmcs01's EB.PF is 0
+	 * so the "or" will take vmcs12's value, otherwise EB.PF is 1, so the
+	 * "or" will always be 1.
 	 */
 	if (vmx_need_pf_intercept(&vmx->vcpu)) {
 		/*
-- 
2.25.1

