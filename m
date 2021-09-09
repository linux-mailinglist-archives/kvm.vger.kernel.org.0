Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1944044B3
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 07:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350542AbhIIFKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 01:10:23 -0400
Received: from mga05.intel.com ([192.55.52.43]:51851 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229995AbhIIFKT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 01:10:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="306244436"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="306244436"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:09:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="466238162"
Received: from zhangyu-optiplex-7040.bj.intel.com ([10.238.154.154])
  by fmsmga007.fm.intel.com with ESMTP; 08 Sep 2021 22:09:03 -0700
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: [PATCH] KVM: nVMX: Reset vmxon_ptr upon VMXOFF emulation.
Date:   Thu,  9 Sep 2021 20:48:46 +0800
Message-Id: <20210909124846.13854-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Currently, 'vmx->nested.vmxon_ptr' is not reset upon VMXOFF
emulation. This is not a problem per se as we never access
it when !vmx->nested.vmxon. But this should be done to avoid
any issue in the future.

Also, initialize the vmxon_ptr when vcpu is created.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 1 +
 arch/x86/kvm/vmx/vmx.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 90f34f12f883..e4260f67caac 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -289,6 +289,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 
 	vmx->nested.vmxon = false;
+	vmx->nested.vmxon_ptr = -1ull;
 	vmx->nested.smm.vmxon = false;
 	free_vpid(vmx->nested.vpid02);
 	vmx->nested.posted_intr_nv = -1;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0c2c0d5ae873..9a3e35c038f2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6886,6 +6886,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 
 	vcpu_setup_sgx_lepubkeyhash(vcpu);
 
+	vmx->nested.vmxon_ptr = -1ull;
 	vmx->nested.posted_intr_nv = -1;
 	vmx->nested.current_vmptr = -1ull;
 	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
-- 
2.17.1

