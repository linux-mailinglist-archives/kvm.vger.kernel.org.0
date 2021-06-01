Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C36396F84
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbhFAIvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:51:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:45213 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233808AbhFAIur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 04:50:47 -0400
IronPort-SDR: JnW+IM80NHSYz4bwzIUuky+mrke9svHpaIT/N6XfeCLb+nqT9+fLPDTDRPTT6aEw2U2ZWECdmA
 25YYAnjrVYcg==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="267381474"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="267381474"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:48:36 -0700
IronPort-SDR: 3+wwGZUYS9nCMhfMTiSsaiUlxW+DwLjhmFE/Wi97D/GXrBpq3RyO1SteaZUshAaqI/FXU3XUPI
 w4oB3bcw5upg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="437967849"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2021 01:48:33 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, robert.hu@intel.com,
        robert.hu@linux.intel.com
Subject: [PATCH 13/15] kvm/vmx/nested: Support Tertiary VM-Exec control in vmcs02
Date:   Tue,  1 Jun 2021 16:47:52 +0800
Message-Id: <1622537274-146420-14-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
References: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b04184b..f5ec215 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2222,6 +2222,7 @@ static void prepare_vmcs02_early_rare(struct vcpu_vmx *vmx,
 static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
 	u32 exec_control;
+	u64 vmcs02_ter_exec_ctrl;
 	u64 guest_efer = nested_vmx_calc_efer(vmx, vmcs12);
 
 	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs)
@@ -2344,6 +2345,18 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	vm_entry_controls_set(vmx, exec_control);
 
 	/*
+	 * Tertiary EXEC CONTROLS
+	 */
+	if (cpu_has_tertiary_exec_ctrls()) {
+		vmcs02_ter_exec_ctrl = vmx->tertiary_exec_control;
+		if (nested_cpu_has(vmcs12,
+				   CPU_BASED_ACTIVATE_TERTIARY_CONTROLS))
+			vmcs02_ter_exec_ctrl |= vmcs12->tertiary_vm_exec_control;
+
+		tertiary_exec_controls_set(vmx, vmcs02_ter_exec_ctrl);
+	}
+
+	/*
 	 * EXIT CONTROLS
 	 *
 	 * L2->L1 exit controls are emulated - the hardware exit is to L0 so
-- 
1.8.3.1

