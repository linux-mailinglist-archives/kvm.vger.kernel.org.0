Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596D512B077
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2019 03:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfL0CHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Dec 2019 21:07:48 -0500
Received: from mga17.intel.com ([192.55.52.151]:38924 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbfL0CHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Dec 2019 21:07:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Dec 2019 18:07:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,361,1571727600"; 
   d="scan'208";a="223675044"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga001.fm.intel.com with ESMTP; 26 Dec 2019 18:07:31 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v9 5/7] KVM: X86: Enable CET bits update in IA32_XSS
Date:   Fri, 27 Dec 2019 10:11:31 +0800
Message-Id: <20191227021133.11993-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191227021133.11993-1-weijiang.yang@intel.com>
References: <20191227021133.11993-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously, KVM did not support setting any bits in XSS
so it's hardcoded to check and inject a #GP if Guest
attempted to write a non-zero value to XSS, now it supports
CET related bits setting.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 12 ++++++++++--
 arch/x86/kvm/vmx/vmx.c          |  6 +-----
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4e59f17ded50..64bf379381e4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -620,6 +620,7 @@ struct kvm_vcpu_arch {
 
 	u64 xcr0;
 	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
 	u32 guest_xstate_size;
 
 	struct kvm_pio_request pio;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 546cfe123ba7..126a31b99823 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -125,8 +125,16 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	}
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
-	if (best && (best->eax & (F(XSAVES) | F(XSAVEC))))
-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+	if (best && (best->eax & (F(XSAVES) | F(XSAVEC)))) {
+		u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
+
+		best->ebx = xstate_required_size(xstate, true);
+		vcpu->arch.guest_supported_xss =
+			(best->ecx | ((u64)best->edx << 32)) &
+			kvm_supported_xss();
+	} else {
+		vcpu->arch.guest_supported_xss = 0;
+	}
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 95063cc7da89..0a75b65d03f0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2081,11 +2081,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		     !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
 		       guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
 			return 1;
-		/*
-		 * The only supported bit as of Skylake is bit 8, but
-		 * it is not supported on KVM.
-		 */
-		if (data != 0)
+		if (data & ~vcpu->arch.guest_supported_xss)
 			return 1;
 		vcpu->arch.ia32_xss = data;
 		if (vcpu->arch.ia32_xss != host_xss)
-- 
2.17.2

