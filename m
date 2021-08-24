Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A564A3F5CDC
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 13:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236797AbhHXLJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 07:09:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:3711 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236744AbhHXLJO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 07:09:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="204423849"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="204423849"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 04:08:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="493501658"
Received: from lxy-dell.sh.intel.com ([10.239.159.31])
  by fmsmga008.fm.intel.com with ESMTP; 24 Aug 2021 04:08:28 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] KVM: VMX: RTIT_CTL_BRANCH_EN has no dependency on other CPUID bit
Date:   Tue, 24 Aug 2021 19:07:41 +0800
Message-Id: <20210824110743.531127-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210824110743.531127-1-xiaoyao.li@intel.com>
References: <20210824110743.531127-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per Intel SDM, RTIT_CTL_BRANCH_EN bit has no dependency on any CPUID
leaf 0x14.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7ed96c460661..4a70a6d2f442 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7116,7 +7116,8 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 
 	/* Initialize and clear the no dependency bits */
 	vmx->pt_desc.ctl_bitmask = ~(RTIT_CTL_TRACEEN | RTIT_CTL_OS |
-			RTIT_CTL_USR | RTIT_CTL_TSC_EN | RTIT_CTL_DISRETC);
+			RTIT_CTL_USR | RTIT_CTL_TSC_EN | RTIT_CTL_DISRETC |
+			RTIT_CTL_BRANCH_EN);
 
 	/*
 	 * If CPUID.(EAX=14H,ECX=0):EBX[0]=1 CR3Filter can be set otherwise
@@ -7134,12 +7135,11 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 				RTIT_CTL_CYC_THRESH | RTIT_CTL_PSB_FREQ);
 
 	/*
-	 * If CPUID.(EAX=14H,ECX=0):EBX[3]=1 MTCEn BranchEn and
-	 * MTCFreq can be set
+	 * If CPUID.(EAX=14H,ECX=0):EBX[3]=1 MTCEn and MTCFreq can be set
 	 */
 	if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_mtc))
 		vmx->pt_desc.ctl_bitmask &= ~(RTIT_CTL_MTC_EN |
-				RTIT_CTL_BRANCH_EN | RTIT_CTL_MTC_RANGE);
+					      RTIT_CTL_MTC_RANGE);
 
 	/* If CPUID.(EAX=14H,ECX=0):EBX[4]=1 FUPonPTW and PTWEn can be set */
 	if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_ptwrite))
-- 
2.27.0

