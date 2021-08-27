Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4303F94BC
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 09:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244333AbhH0HEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 03:04:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:6111 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244305AbhH0HD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 03:03:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="205045881"
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="205045881"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 00:03:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="495553026"
Received: from lxy-dell.sh.intel.com ([10.239.159.31])
  by fmsmga008.fm.intel.com with ESMTP; 27 Aug 2021 00:03:04 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/7] KVM: VMX: Use precomputed vmx->pt_desc.addr_range
Date:   Fri, 27 Aug 2021 15:02:44 +0800
Message-Id: <20210827070249.924633-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210827070249.924633-1-xiaoyao.li@intel.com>
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The number of guest's valid PT ADDR MSRs is precomputed in
vmx->pt_desc.addr_range. Use it instead of calculating again.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v2:
 - Refine comment to use 'precomputed' instead of 'cached'
 - Use precomputed value in vmx_get_msr() as well
---
 arch/x86/kvm/vmx/vmx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5535a86aea37..96a2df65678f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1889,8 +1889,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
 		if (!vmx_pt_mode_is_host_guest() ||
-			(index >= 2 * intel_pt_validate_cap(vmx->pt_desc.caps,
-					PT_CAP_num_address_ranges)))
+		    (index >= 2 * vmx->pt_desc.addr_range))
 			return 1;
 		if (index % 2)
 			msr_info->data = vmx->pt_desc.guest.addr_b[index / 2];
@@ -2205,8 +2204,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!pt_can_write_msr(vmx))
 			return 1;
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
-		if (index >= 2 * intel_pt_validate_cap(vmx->pt_desc.caps,
-						       PT_CAP_num_address_ranges))
+		if (index >= 2 * vmx->pt_desc.addr_range)
 			return 1;
 		if (is_noncanonical_address(data, vcpu))
 			return 1;
-- 
2.27.0

