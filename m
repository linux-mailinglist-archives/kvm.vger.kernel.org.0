Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB1422E0BB
	for <lists+kvm@lfdr.de>; Sun, 26 Jul 2020 17:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgGZPeu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jul 2020 11:34:50 -0400
Received: from mga03.intel.com ([134.134.136.65]:17603 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbgGZPet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jul 2020 11:34:49 -0400
IronPort-SDR: AOgtFdQFnzlP9Oc0sUQO8RYuoU9sY6kzxAZSinp1MU/AjLpq3iUyeNbctem3R/6EIpPXw+61Ec
 5G7Nr4AwJRzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="150890967"
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="150890967"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2020 08:34:49 -0700
IronPort-SDR: NXrOWjH1RLcaiExj4XpLnh36TaRO56/eefdj2tClDV0JCwKXUooP2R3loK+MmcN+3HKW4aE0nY
 77lEbFvRgMNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="303177534"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 26 Jul 2020 08:34:47 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v13 02/10] KVM: x86/vmx: Make vmx_set_intercept_for_msr() non-static and expose it
Date:   Sun, 26 Jul 2020 23:32:21 +0800
Message-Id: <20200726153229.27149-4-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200726153229.27149-1-like.xu@linux.intel.com>
References: <20200726153229.27149-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's reasonable to call vmx_set_intercept_for_msr() in other vmx-specific
files (e.g. pmu_intel.c), so expose it without semantic changes hopefully.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 arch/x86/kvm/vmx/vmx.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dcde73a230c6..162c668d58f5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3772,8 +3772,8 @@ static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitm
 	}
 }
 
-static __always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
-			     			      u32 msr, int type, bool value)
+__always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
+					 u32 msr, int type, bool value)
 {
 	if (value)
 		vmx_enable_intercept_for_msr(msr_bitmap, msr, type);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 0d06951e607c..08c850596cfc 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -356,6 +356,8 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
 int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
 int vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 			      struct x86_exception *e);
+void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
+			      u32 msr, int type, bool value);
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
-- 
2.21.3

