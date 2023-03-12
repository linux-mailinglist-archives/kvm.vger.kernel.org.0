Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7836B6479
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjCLJ5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjCLJ5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:57:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882E539BB6
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615006; x=1710151006;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/eWJ6e1HlOYoO5fNJod/SpkW+Yfz6UUDH/ixIb2ucl0=;
  b=g7PugCQOBafZeJyruFvrvXJNf+KPg3r3wbLXagQEejGt/6w+hNPUQdgh
   vXyaGzG4X/FiuUm4j/H8+CgnbRkLlIdLVE7kS4slTUokn007wz+5xpnfs
   ep/2Fkkpvsq9GYfNO2znlJgNOicNbTCXt0rfFzVhpG0+lQfuMojkkqylZ
   AD4fOasPezTEcIFXgK2pexUk1hrBFxHy2+t0ehq59EAgVOG+tb1AI4Hby
   LBMb5GhsD4eHwso0ImYRLN6bqqlrINY1cOXX++FIxjsDO50cA7+YpsdrK
   +jJ31vieWflrMNkDB/sZzl83fksJ+70MgfXRA7vTpaWJv6+tNVUqG4LF4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998072"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998072"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677533"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677533"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:50 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Zide Chen <zide.chen@intel.com>
Subject: [RFC PATCH part-4 1/4] pkvm: x86: Enable VPID for host VM
Date:   Mon, 13 Mar 2023 02:02:41 +0800
Message-Id: <20230312180244.1778422-2-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180244.1778422-1-jason.cj.chen@intel.com>
References: <20230312180244.1778422-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If VPID is disabled on a guest, upon VM entries, TLB entries associated
with VPID 0000H will be invalidated. Enable VPID for host VM to improve
VMX transition overhead.

Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
index ae10d550448d..e0c74d5ac2fa 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
@@ -289,6 +289,21 @@ int __pkvm_init_finalise(struct kvm_vcpu *vcpu, struct pkvm_section sections[],
 	secondary_exec_controls_setbit(&pkvm_host_vcpu->vmx, SECONDARY_EXEC_ENABLE_EPT);
 	vmcs_write64(EPT_POINTER, eptp);
 
+	/* enable vpid */
+	if (pkvm_hyp->vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_ENABLE_VPID) {
+		static u16 pkvm_host_vpid = VMX_NR_VPIDS - 1;
+
+		/*
+		 * Fixed VPIDs for the host vCPUs, which implies that it could conflict
+		 * with VPIDs from nested guests.
+		 *
+		 * It's safe because cached mappings used in non-root mode are associated
+		 * with EP4TA, which is managed by pKVM and unique for every guest.
+		 */
+		vmcs_write16(VIRTUAL_PROCESSOR_ID, pkvm_host_vpid--);
+		secondary_exec_controls_setbit(&pkvm_host_vcpu->vmx, SECONDARY_EXEC_ENABLE_VPID);
+	}
+
 	ept_sync_global();
 
 out:
-- 
2.25.1

