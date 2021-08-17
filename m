Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CBC3EE9E9
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 11:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbhHQJcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 05:32:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:49582 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239478AbhHQJcP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 05:32:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="238111542"
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="238111542"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 02:31:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="449200757"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga007.fm.intel.com with ESMTP; 17 Aug 2021 02:31:40 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     kvm@vger.kernel.org, yu.c.zhang@linux.intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v1 5/5] KVM: x86: nVMX: Ignore user space set value to MSR_IA32_VMX_VMCS_ENUM
Date:   Tue, 17 Aug 2021 17:31:13 +0800
Message-Id: <1629192673-9911-6-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is actually "read-only" MSR, its value is determined by VMCS12 fields
existence.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9a733c703662..4d13e19d7677 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1426,7 +1426,6 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_IA32_VMX_EPT_VPID_CAP:
 		return vmx_restore_vmx_ept_vpid_cap(vmx, data);
 	case MSR_IA32_VMX_VMCS_ENUM:
-		vmx->nested.msrs.vmcs_enum = data;
 		return 0;
 	case MSR_IA32_VMX_VMFUNC:
 		if (data & ~vmx->nested.msrs.vmfunc_controls)
-- 
2.27.0

