Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E569314A3A
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 09:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhBII0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 03:26:14 -0500
Received: from mga12.intel.com ([192.55.52.136]:9711 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhBII0O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 03:26:14 -0500
IronPort-SDR: hIZFTFkXLEx/jHQ/QXpcOvLPe4tHixvgRyGFW3H6xJmXJk63vkqvHL162TACIfPnHVb0/Yv408
 3Rf6c0QKUBgg==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="160999382"
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="160999382"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 00:25:31 -0800
IronPort-SDR: 3GUykSCShpgFEcHg+Ffwgwf+MBbiuf0MYD1n4gte55KB9evjW1o/NfAEXGfASI2O2cwxkgkT+E
 BHfilBx5kmrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="378694156"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by fmsmga008.fm.intel.com with ESMTP; 09 Feb 2021 00:25:30 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH] KVM: nVMX: Sync L2 guest CET states between L1/L2
Date:   Tue,  9 Feb 2021 16:37:08 +0800
Message-Id: <20210209083708.2680-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When L2 guest status has been changed by L1 QEMU/KVM, sync the change back
to L2 guest before the later's next vm-entry. On the other hand, if it's
changed due to L2 guest, sync it back so as to let L1 guest see the change.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9728efd529a1..b9d8db8facea 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2602,6 +2602,12 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	/* Note: may modify VM_ENTRY/EXIT_CONTROLS and GUEST/HOST_IA32_EFER */
 	vmx_set_efer(vcpu, vcpu->arch.efer);
 
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE) {
+		vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
+		vmcs_writel(GUEST_INTR_SSP_TABLE, vmcs12->guest_ssp_tbl);
+		vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
+	}
+
 	/*
 	 * Guest state is invalid and unrestricted guest is disabled,
 	 * which means L1 attempted VMEntry to L2 with invalid state.
@@ -4152,6 +4158,12 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_IA32_EFER)
 		vmcs12->guest_ia32_efer = vcpu->arch.efer;
+
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE) {
+		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
+		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
+		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
+	}
 }
 
 /*
-- 
2.26.2

