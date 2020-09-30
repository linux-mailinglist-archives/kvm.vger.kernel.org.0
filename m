Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA40627DF3E
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 06:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgI3ERN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 00:17:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:60793 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgI3ERE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 00:17:04 -0400
IronPort-SDR: D+TNRhCS/ngZBrLq8leAiIkzE38v/NxNDbN9Yz8qMnMq1EQvrGdF7rX9C39Y5ZPza82TzsyTIZ
 uCefqzBkJMWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="150137447"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="150137447"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 21:17:02 -0700
IronPort-SDR: 2m0uC/+PueI+3xFKIkJ/h+wFBymlfWn9xqRmrWS0br+hsvYsfQ/76LW0RUpT2VWAnESq1ye2G5
 5VebHlzL3Z/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="415607865"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga001.fm.intel.com with ESMTP; 29 Sep 2020 21:17:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 3/5] KVM: x86: Move call to update_exception_bitmap() into VMX code
Date:   Tue, 29 Sep 2020 21:16:57 -0700
Message-Id: <20200930041659.28181-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930041659.28181-1-sean.j.christopherson@intel.com>
References: <20200930041659.28181-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that vcpu_after_set_cpuid() and update_exception_bitmap() are called
back-to-back, subsume the exception bitmap update into the common CPUID
update.  Drop the SVM invocation entirely as SVM's exception bitmap
doesn't vary with respect to guest CPUID.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c   | 1 -
 arch/x86/kvm/vmx/vmx.c | 3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 963bad7bc0ff..dd62156b8868 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -147,7 +147,6 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	/* Invoke the vendor callback only after the above state is updated. */
 	kvm_x86_ops.vcpu_after_set_cpuid(vcpu);
-	kvm_x86_ops.update_exception_bitmap(vcpu);
 }
 
 static int is_efer_nx(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4551a7e80ebc..223e070c48b2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7232,6 +7232,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			vmx_set_guest_uret_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
 		}
 	}
+
+	/* Refresh #PF interception to account for MAXPHYADDR changes. */
+	update_exception_bitmap(vcpu);
 }
 
 static __init void vmx_set_cpu_caps(void)
-- 
2.28.0

