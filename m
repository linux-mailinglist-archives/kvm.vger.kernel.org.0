Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F7E303412
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbhAZFOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:14:17 -0500
Received: from mga14.intel.com ([192.55.52.115]:22889 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbhAYJVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:21:49 -0500
IronPort-SDR: FYregR+jhb/yYFFLFBNgzOTNt11eQRV0loOpncGnH8O70biI6K0w5LC7dTK8bKRETTBDFBAfmJ
 hHVPkBWFqgbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="178915821"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="178915821"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:07:23 -0800
IronPort-SDR: KbzRGf7xP/vQcQXBTGhjXtwidXB7YYJjN8HgSrzMcp0M99wvyaHcxX/NYWyRsUmPKyGxJcRAFf
 aRy/QmdUjulg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="402223944"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2021 01:07:21 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     chang.seok.bae@intel.com, kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 10/12] kvm/vmx/nested: Support tertiary VM-Exec control in vmcs02
Date:   Mon, 25 Jan 2021 17:06:18 +0800
Message-Id: <1611565580-47718-11-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9eb1c0b..de36129 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2232,6 +2232,7 @@ static void prepare_vmcs02_early_rare(struct vcpu_vmx *vmx,
 static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
 	u32 exec_control, vmcs12_exec_ctrl;
+	u64 vmcs02_ter_exec_ctrl;
 	u64 guest_efer = nested_vmx_calc_efer(vmx, vmcs12);
 
 	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs)
@@ -2351,6 +2352,18 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
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

