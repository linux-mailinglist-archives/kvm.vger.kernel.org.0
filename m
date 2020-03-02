Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A357176471
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 20:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgCBT5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 14:57:40 -0500
Received: from mga05.intel.com ([192.55.52.43]:30422 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbgCBT5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 14:57:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 11:57:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="438404986"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 02 Mar 2020 11:57:39 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 4/6] KVM: x86: Drop return value from kvm_cpuid()
Date:   Mon,  2 Mar 2020 11:57:34 -0800
Message-Id: <20200302195736.24777-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302195736.24777-1-sean.j.christopherson@intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the boolean return from kvm_cpuid() now that all callers ignore
the return value.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_emulate.h | 2 +-
 arch/x86/kvm/cpuid.c               | 4 +---
 arch/x86/kvm/cpuid.h               | 2 +-
 arch/x86/kvm/x86.c                 | 4 ++--
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index ded06515d30f..20a26dc792ce 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -220,7 +220,7 @@ struct x86_emulate_ops {
 			 struct x86_instruction_info *info,
 			 enum x86_intercept_stage stage);
 
-	bool (*get_cpuid)(struct x86_emulate_ctxt *ctxt, u32 *eax, u32 *ebx,
+	void (*get_cpuid)(struct x86_emulate_ctxt *ctxt, u32 *eax, u32 *ebx,
 			  u32 *ecx, u32 *edx, bool check_limit);
 	int (*get_cpuid_maxphyaddr)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_long_mode)(struct x86_emulate_ctxt *ctxt);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c320126e0118..869526930cf7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -997,8 +997,7 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
 	return max && function <= max->eax;
 }
 
-/* Returns true if the requested leaf/function exists in guest CPUID. */
-bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
+void kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	       u32 *ecx, u32 *edx, bool check_limit)
 {
 	const u32 function = *eax, index = *ecx;
@@ -1049,7 +1048,6 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 		}
 	}
 	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, found);
-	return found;
 }
 EXPORT_SYMBOL_GPL(kvm_cpuid);
 
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 7366c618aa04..5df64ff25663 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -22,7 +22,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 			      struct kvm_cpuid2 *cpuid,
 			      struct kvm_cpuid_entry2 __user *entries);
-bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
+void kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	       u32 *ecx, u32 *edx, bool check_limit);
 
 int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5467ee71c25b..bfff92fcf0d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6203,10 +6203,10 @@ static int emulator_intercept(struct x86_emulate_ctxt *ctxt,
 	return kvm_x86_ops->check_intercept(emul_to_vcpu(ctxt), info, stage);
 }
 
-static bool emulator_get_cpuid(struct x86_emulate_ctxt *ctxt,
+static void emulator_get_cpuid(struct x86_emulate_ctxt *ctxt,
 			u32 *eax, u32 *ebx, u32 *ecx, u32 *edx, bool check_limit)
 {
-	return kvm_cpuid(emul_to_vcpu(ctxt), eax, ebx, ecx, edx, check_limit);
+	kvm_cpuid(emul_to_vcpu(ctxt), eax, ebx, ecx, edx, check_limit);
 }
 
 static int emulator_get_cpuid_maxphyaddr(struct x86_emulate_ctxt *ctxt)
-- 
2.24.1

