Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4843C25E65
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 09:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfEVHCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 03:02:08 -0400
Received: from mga18.intel.com ([134.134.136.126]:31984 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728670AbfEVHCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 03:02:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 00:02:04 -0700
X-ExtLoop1: 1
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2019 00:02:03 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yu-cheng.yu@intel.com
Cc:     weijiang.yang@intel.com
Subject: [PATCH v5 6/8] KVM: x86: Allow Guest to set supported bits in XSS
Date:   Wed, 22 May 2019 15:00:59 +0800
Message-Id: <20190522070101.7636-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190522070101.7636-1-weijiang.yang@intel.com>
References: <20190522070101.7636-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that KVM supports setting CET related bits in XSS.
Previously, KVM did not support setting any bits in XSS
so hardcoded its check to inject a #GP if Guest
attempted to write a non-zero value to XSS.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 13 ++++++++++---
 arch/x86/kvm/vmx/vmx.c          |  7 ++-----
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8c3f0ddc7676..035367694056 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -620,6 +620,7 @@ struct kvm_vcpu_arch {
 
 	u64 xcr0;
 	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
 	u32 guest_xstate_size;
 
 	struct kvm_pio_request pio;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7be16ef0ea4a..b645a143584f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -122,9 +122,16 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	}
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
-	if (best && (best->eax & (F(XSAVES) | F(XSAVEC))))
-		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
-			    kvm_supported_xss(), true);
+	if (best) {
+		if (best->eax & (F(XSAVES) | F(XSAVEC)))
+			best->ebx = xstate_required_size(vcpu->arch.xcr0 |
+				    kvm_supported_xss(), true);
+
+		vcpu->arch.guest_supported_xss = best->ecx &
+			kvm_supported_xss();
+	} else {
+		vcpu->arch.guest_supported_xss = 0;
+	}
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1c0d487a4037..dec6bda20235 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1945,12 +1945,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_XSS:
 		if (!vmx_xsaves_supported())
 			return 1;
-		/*
-		 * The only supported bit as of Skylake is bit 8, but
-		 * it is not supported on KVM.
-		 */
-		if (data != 0)
+		if (data & ~vcpu->arch.guest_supported_xss)
 			return 1;
+
 		vcpu->arch.ia32_xss = data;
 		if (vcpu->arch.ia32_xss != host_xss)
 			add_atomic_switch_msr(vmx, MSR_IA32_XSS,
-- 
2.17.2

