Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24C7218E402
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 20:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgCUTh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Mar 2020 15:37:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:55983 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbgCUThz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Mar 2020 15:37:55 -0400
IronPort-SDR: YEPGJGsmLH+vBwZWtcRTk5LgGPZL23LPz+7Z8txALzKWKhpjpqoraeMaHfheFkH398LkHPERu3
 m1BYZKoTVQRA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 12:37:54 -0700
IronPort-SDR: 7/Pw17EirO65eChZhWblkEnEYmODISes7aBhq9UXgg0738zsHHSc1re5gY5JBmp+uRnM8Vm1L2
 DnB4/pEbGW4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,289,1580803200"; 
   d="scan'208";a="445353684"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 21 Mar 2020 12:37:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] KVM: VMX: Gracefully handle faults on VMXON
Date:   Sat, 21 Mar 2020 12:37:51 -0700
Message-Id: <20200321193751.24985-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200321193751.24985-1-sean.j.christopherson@intel.com>
References: <20200321193751.24985-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gracefully handle faults on VMXON, e.g. #GP due to VMX being disabled by
BIOS, instead of letting the fault crash the system.  Now that KVM uses
cpufeatures to query support instead of reading MSR_IA32_FEAT_CTL
directly, it's possible for a bug in a different subsystem to cause KVM
to incorrectly attempt VMXON[*].  Crashing the system is especially
annoying if the system is configured such that hardware_enable() will
be triggered during boot.

Oppurtunistically rename @addr to @vmxon_pointer and use a named param
to reference it in the inline assembly.

Print 0xdeadbeef in the ultra-"rare" case that reading MSR_IA32_FEAT_CTL
also faults.

[*] https://lkml.kernel.org/r/20200226231615.13664-1-sean.j.christopherson@intel.com
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 07634caa560d..3aba51d782e2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2218,18 +2218,33 @@ static __init int vmx_disabled_by_bios(void)
 	       !boot_cpu_has(X86_FEATURE_VMX);
 }
 
-static void kvm_cpu_vmxon(u64 addr)
+static int kvm_cpu_vmxon(u64 vmxon_pointer)
 {
+	u64 msr;
+
 	cr4_set_bits(X86_CR4_VMXE);
 	intel_pt_handle_vmx(1);
 
-	asm volatile ("vmxon %0" : : "m"(addr));
+	asm_volatile_goto("1: vmxon %[vmxon_pointer]\n\t"
+			  _ASM_EXTABLE(1b, %l[fault])
+			  : : [vmxon_pointer] "m"(vmxon_pointer)
+			  : : fault);
+	return 0;
+
+fault:
+	WARN_ONCE(1, "VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x%llx\n",
+		  rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr) ? 0xdeadbeef : msr);
+	intel_pt_handle_vmx(0);
+	cr4_clear_bits(X86_CR4_VMXE);
+
+	return -EFAULT;
 }
 
 static int hardware_enable(void)
 {
 	int cpu = raw_smp_processor_id();
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
+	int r;
 
 	if (cr4_read_shadow() & X86_CR4_VMXE)
 		return -EBUSY;
@@ -2246,7 +2261,10 @@ static int hardware_enable(void)
 	INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
 	spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
 
-	kvm_cpu_vmxon(phys_addr);
+	r = kvm_cpu_vmxon(phys_addr);
+	if (r)
+		return r;
+
 	if (enable_ept)
 		ept_sync_global();
 
-- 
2.24.1

