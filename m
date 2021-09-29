Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAED41C260
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 12:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245412AbhI2KOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 06:14:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:28996 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245406AbhI2KOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 06:14:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="247430457"
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="247430457"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 03:12:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="707211705"
Received: from zhangyu-optiplex-7040.bj.intel.com ([10.238.154.154])
  by fmsmga006.fm.intel.com with ESMTP; 29 Sep 2021 03:12:17 -0700
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: [PATCH v2 2/2] KVM: nVMX: Reset vmxon_ptr upon VMXOFF emulation.
Date:   Thu, 30 Sep 2021 01:51:54 +0800
Message-Id: <20210929175154.11396-3-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210929175154.11396-1-yu.c.zhang@linux.intel.com>
References: <20210929175154.11396-1-yu.c.zhang@linux.intel.com>
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
index 25cf76c7fee8..d45b4041c8a5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -290,6 +290,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
 
 	vmx->nested.vmxon = false;
 	vmx->nested.smm.vmxon = false;
+	vmx->nested.vmxon_ptr = INVALID_GPA;
 	free_vpid(vmx->nested.vpid02);
 	vmx->nested.posted_intr_nv = -1;
 	vmx->nested.current_vmptr = INVALID_GPA;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 047992eb4b20..a66cc09f24d3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6887,6 +6887,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	vcpu_setup_sgx_lepubkeyhash(vcpu);
 
 	vmx->nested.posted_intr_nv = -1;
+	vmx->nested.vmxon_ptr = INVALID_GPA;
 	vmx->nested.current_vmptr = INVALID_GPA;
 	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
 
-- 
2.25.1

