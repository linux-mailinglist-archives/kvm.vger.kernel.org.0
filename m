Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11BDB18382E
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 19:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgCLSET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 14:04:19 -0400
Received: from mga05.intel.com ([192.55.52.43]:38331 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgCLSES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 14:04:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 11:04:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,545,1574150400"; 
   d="scan'208";a="277908742"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 12 Mar 2020 11:04:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Toni Spets <toni.spets@iki.fi>
Subject: [PATCH] KVM: VMX: Condition ENCLS-exiting enabling on CPU support for SGX1
Date:   Thu, 12 Mar 2020 11:04:16 -0700
Message-Id: <20200312180416.6679-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable ENCLS-exiting (and thus set vmcs.ENCLS_EXITING_BITMAP) only if
the CPU supports SGX1.  Per Intel's SDM, all ENCLS leafs #UD if SGX1
is not supported[*], i.e. intercepting ENCLS to inject a #UD is
unnecessary.

Avoiding ENCLS-exiting even when it is reported as supported by the CPU
works around a reported issue where SGX is "hard" disabled after an S3
suspend/resume cycle, i.e. CPUID.0x7.SGX=0 and the VMCS field/control
are enumerated as unsupported.  While the root cause of the S3 issue is
unknown, it's definitely _not_ a KVM (or kernel) bug, i.e. this is a
workaround for what is most likely a hardware or firmware issue.  As a
bonus side effect, KVM saves a VMWRITE when first preparing vmcs01 and
vmcs02.

Query CPUID directly instead of going through cpu_data() or cpu_has() to
ensure KVM is trapping ENCLS when it's supported in hardware, e.g. even
if X86_FEATURE_SGX1 (which doesn't yet exist in upstream) were disabled
by the kernel/user.

Note, SGX must be disabled in BIOS to take advantage of this workaround

[*] The additional ENCLS CPUID check on SGX1 exists so that SGX can be
    globally "soft" disabled post-reset, e.g. if #MC bits in MCi_CTL are
    cleared.  Soft disabled meaning disabling SGX without clearing the
    primary CPUID bit (in leaf 0x7) and without poking into non-SGX
    CPU paths, e.g. for the VMCS controls.

Fixes: 0b665d304028 ("KVM: vmx: Inject #UD for SGX ENCLS instruction in guest")
Reported-by: Toni Spets <toni.spets@iki.fi>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

This seems somewhat premature given that we don't yet know if the observed
behavior is a logic bug, a one off manufacturing defect, firmware specific,
etc...  On the other hand, the change is arguably an optimization
irrespective of using it as a workaround.

 arch/x86/kvm/vmx/vmx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40b1e6138cd5..50cab98382e7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2338,6 +2338,11 @@ static void hardware_disable(void)
 	kvm_cpu_vmxoff();
 }
 
+static bool cpu_has_sgx(void)
+{
+	return cpuid_eax(0) >= 0x12 && (cpuid_eax(0x12) & BIT(0));
+}
+
 static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 				      u32 msr, u32 *result)
 {
@@ -2418,8 +2423,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 			SECONDARY_EXEC_PT_USE_GPA |
 			SECONDARY_EXEC_PT_CONCEAL_VMX |
-			SECONDARY_EXEC_ENABLE_VMFUNC |
-			SECONDARY_EXEC_ENCLS_EXITING;
+			SECONDARY_EXEC_ENABLE_VMFUNC;
+		if (cpu_has_sgx())
+			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
 		if (adjust_vmx_controls(min2, opt2,
 					MSR_IA32_VMX_PROCBASED_CTLS2,
 					&_cpu_based_2nd_exec_control) < 0)
-- 
2.24.1

