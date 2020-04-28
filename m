Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5996B1BD079
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 01:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgD1XKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 19:10:36 -0400
Received: from mga04.intel.com ([192.55.52.120]:60554 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgD1XKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 19:10:30 -0400
IronPort-SDR: yPQrueutqA7+ZzVCkeo6dpzVxsAKJ3M8rzadjLlra1EMRE3YKCphSfNuUsZhLTeLGU36F0vOOS
 jT65xECDLTow==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 16:10:28 -0700
IronPort-SDR: HBNXtjzUTGy9RAIvMbWj7UjVEywi0T3ruJwfW6/gbOr7TCtwpoBMi6TcjOmDKS/wBs8gbDZ23Q
 UybHlICfsxpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,328,1583222400"; 
   d="scan'208";a="257774906"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 28 Apr 2020 16:10:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: nVMX: Truncate writes to vmcs.SYSENTER_EIP/ESP for 32-bit vCPU
Date:   Tue, 28 Apr 2020 16:10:24 -0700
Message-Id: <20200428231025.12766-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200428231025.12766-1-sean.j.christopherson@intel.com>
References: <20200428231025.12766-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly truncate the data written to vmcs.SYSENTER_EIP/ESP on WRMSR
if the virtual CPU doesn't support 64-bit mode.  The SYSENTER address
fields in the VMCS are natural width, i.e. bits 63:32 are dropped if the
CPU doesn't support Intel 64 architectures.  This behavior is visible to
the guest after a VM-Exit/VM-Exit roundtrip, e.g. if the guest sets bits
63:32 in the actual MSR.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3ab6ca6062ce..bc91ce499a7a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1936,6 +1936,16 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 0;
 }
 
+static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
+						    u64 data)
+{
+#ifdef CONFIG_X86_64
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
+		return (u32)data;
+#endif
+	return (unsigned long)data;
+}
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -1973,13 +1983,17 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vmcs_write32(GUEST_SYSENTER_CS, data);
 		break;
 	case MSR_IA32_SYSENTER_EIP:
-		if (is_guest_mode(vcpu))
+		if (is_guest_mode(vcpu)) {
+			data = nested_vmx_truncate_sysenter_addr(vcpu, data);
 			get_vmcs12(vcpu)->guest_sysenter_eip = data;
+		}
 		vmcs_writel(GUEST_SYSENTER_EIP, data);
 		break;
 	case MSR_IA32_SYSENTER_ESP:
-		if (is_guest_mode(vcpu))
+		if (is_guest_mode(vcpu)) {
+			data = nested_vmx_truncate_sysenter_addr(vcpu, data);
 			get_vmcs12(vcpu)->guest_sysenter_esp = data;
+		}
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
-- 
2.26.0

