Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79AE41768EA
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgCCABE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:01:04 -0500
Received: from mga03.intel.com ([134.134.136.65]:17168 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727389AbgCBX51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384789"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 55/66] KVM: VMX: Directly use VMX capabilities helper to detect RDTSCP support
Date:   Mon,  2 Mar 2020 15:56:58 -0800
Message-Id: <20200302235709.27467-56-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use cpu_has_vmx_rdtscp() directly when computing secondary exec controls
and drop the now defunct vmx_rdtscp_supported().

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f168da6f9b89..bb54974f950f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1687,11 +1687,6 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 	vmx_clear_hlt(vcpu);
 }
 
-static bool vmx_rdtscp_supported(void)
-{
-	return cpu_has_vmx_rdtscp();
-}
-
 /*
  * Swap MSR entry in host/guest MSR entry array.
  */
@@ -4074,7 +4069,7 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 		}
 	}
 
-	if (vmx_rdtscp_supported()) {
+	if (cpu_has_vmx_rdtscp()) {
 		bool rdtscp_enabled = guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP);
 		if (!rdtscp_enabled)
 			exec_control &= ~SECONDARY_EXEC_RDTSCP;
-- 
2.24.1

