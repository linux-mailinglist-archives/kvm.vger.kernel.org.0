Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF373F5CDB
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 13:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236770AbhHXLJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 07:09:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:3710 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236731AbhHXLJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 07:09:12 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="204423845"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="204423845"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 04:08:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="493501648"
Received: from lxy-dell.sh.intel.com ([10.239.159.31])
  by fmsmga008.fm.intel.com with ESMTP; 24 Aug 2021 04:08:25 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] KVM: VMX: Use cached vmx->pt_desc.addr_range
Date:   Tue, 24 Aug 2021 19:07:40 +0800
Message-Id: <20210824110743.531127-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210824110743.531127-1-xiaoyao.li@intel.com>
References: <20210824110743.531127-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The number of guest's valid PT ADDR MSRs is cached in
vmx->pt_desc.addr_range. Use it instead of calculating it again.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e0a9460e4dab..7ed96c460661 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2202,8 +2202,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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

