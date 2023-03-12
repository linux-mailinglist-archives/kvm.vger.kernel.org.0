Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3CB6B64A3
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbjCLKAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjCLKAK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:00:10 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CB55290E
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615153; x=1710151153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jkZalD4WLnW2RygY3Rdw9FI1fFHFECWi4sd35Zqkeow=;
  b=irj26duKFbxqxxvXWDwCbXiDX0vj2KLyKzrFP/nf5VkTOIVaLJV3werH
   RHHk2Ii+miN9TLIG802gdZZtthT1xyRD542pRkByIzgwqAsfHkdstjieO
   aT8xbf2ygAsHEH1qdHoEaIa9ddB8JubuAzQhb5owlPm7Jz/uTIC9LtfXd
   4SzlfBvTWjz2k9tQro/0Nwi799W5xM0fWGj/7nKyNbDrPcB2OQcarY6RB
   pnRGlwYzkcmT0/4pHgt4WGD4cqoJGyY+9GORNcqnZjADyx2lh84o+dXYj
   hYlMHXMcaHESaVFJr4agHuwSaAYCGCUED5jNUsxRsDaenFGpCIvpKXXTG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344729"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344729"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627388"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627388"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:05 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-6 13/13] pkvm: x86: Switch to use shadow EPT for nested guests
Date:   Mon, 13 Mar 2023 02:03:45 +0800
Message-Id: <20230312180345.1778588-14-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180345.1778588-1-jason.cj.chen@intel.com>
References: <20230312180345.1778588-1-jason.cj.chen@intel.com>
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

From: Chuanxiao Dong <chuanxiao.dong@intel.com>

Shadow EPT currently is per VM which is configured when creating
VM. The shadow EPTP won't be changed at runtime. So just configure
the EPTP for vmcs02 when the first this vmcs02 is loaded and skip
the later EPTP sync from vmcs12 to vmcs02.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/nested.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.c b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
index 3a338f7f5a69..f43e559cb594 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
@@ -572,6 +572,14 @@ static void sync_vmcs12_dirty_fields_to_vmcs02(struct vcpu_vmx *vmx, struct vmcs
 	if (vmx->nested.dirty_vmcs12) {
 		for (i = 0; i < max_emulated_fields; i++) {
 			field = emulated_fields[i];
+			if (field.encoding == EPT_POINTER)
+				/*
+				 * EPTP is configured as shadow EPTP when the first
+				 * time the vmcs02 is loaded. As shadow EPTP is not
+				 * changed at the runtime, also cannot use the virtual
+				 * EPT from KVM high, no need to sync to vmcs02 again.
+				 */
+				continue;
 			val = vmcs12_read_any(vmcs12, field.encoding, field.offset);
 			phys_val = emulate_field_for_vmcs02(vmx, field.encoding, val);
 			__vmcs_writel(field.encoding, phys_val);
@@ -860,6 +868,15 @@ int handle_vmptrld(struct kvm_vcpu *vcpu)
 						vmcs_load_track(vmx, vmcs02);
 						pkvm_init_host_state_area(pkvm_hvcpu->pcpu, vcpu->cpu);
 						vmcs_writel(HOST_RIP, (unsigned long)__pkvm_vmx_vmexit);
+						/*
+						 * EPTP is mantained by pKVM and configured with
+						 * shadow EPTP from its corresponding shadow VM.
+						 * As shadow EPTP is not changed at runtime, set
+						 * it to EPTP when the first time this vmcs02 is
+						 * loading.
+						 */
+						vmcs_write64(EPT_POINTER,
+							     shadow_vcpu->vm->sept_desc.shadow_eptp);
 						shadow_vcpu->last_cpu = vcpu->cpu;
 						shadow_vcpu->vmcs02_inited = true;
 					} else {
-- 
2.25.1

