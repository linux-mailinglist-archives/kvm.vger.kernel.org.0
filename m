Return-Path: <kvm+bounces-973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 729627E42AF
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2FA61C21063
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E44437162;
	Tue,  7 Nov 2023 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j+tnbixE"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B8B34CF3
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:04:51 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E7961AC;
	Tue,  7 Nov 2023 07:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369323; x=1730905323;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+LuOYkpR2KcKZZFbkr/WgA/07b3nYcz5HREA/KDwih4=;
  b=j+tnbixEadv/rEzqpuArCK+jOJexBCrfgtISv2UQ++cnGvOU1Q9dCDPW
   6yJ5zlXy7KVk872N/kMFZY6Bb5GFE6gJb/a4aul8wS2VVR0KWpucDr1P8
   MjwG1bjxSlzvwEGoleFkJI+kNNvb4GrE9yi5cIOxD/UKyLn3dH82bIzqk
   lsSIJKENa9Gr0hOE+eFUaGx2tpOOD4AQ6lGpLYvHpDUcfIlFL7vMeDXN2
   MQDkcCxbPIy4eSfaXk8Ciy3MjUaTF4+ejdEJzjuBCR7GYkz/KxZaRaEu4
   QUyV6baOxnWMm5Ka2bDUQFDD+0u4hNxC6IHL2mJ1i91h93NCHpiRvrlHE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462695"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462695"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851672"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:29 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 114/116] RFC: KVM: x86: Add x86 callback to check cpuid
Date: Tue,  7 Nov 2023 06:57:20 -0800
Message-Id: <15f15894b1ba356bad587143345fe41675bba087.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

The x86 backend should check the consistency of KVM_SET_CPUID2 because it
has its constraint.  Add a callback for it.  The backend code will come as
another patch.

Suggested-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/lkml/ZDiGpCkXOcCm074O@google.com/
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/cpuid.c               | 20 ++++++++++++--------
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 3e4cf405a297..8ef0ed217f6e 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -20,6 +20,8 @@ KVM_X86_OP(hardware_disable)
 KVM_X86_OP(hardware_unsetup)
 KVM_X86_OP_OPTIONAL_RET0(offline_cpu)
 KVM_X86_OP(has_emulated_msr)
+/* TODO: Once all backend implemented this op, remove _OPTIONAL_RET0. */
+KVM_X86_OP_OPTIONAL_RET0(vcpu_check_cpuid)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(is_vm_type_supported)
 KVM_X86_OP_OPTIONAL(max_vcpus);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 33d99d5c9c16..edcafcd650db 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1627,6 +1627,7 @@ struct kvm_x86_ops {
 	void (*hardware_unsetup)(void);
 	int (*offline_cpu)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
+	int (*vcpu_check_cpuid)(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2, int nent);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	bool (*is_vm_type_supported)(unsigned long vm_type);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8074c5313d6f..5684a258094b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -136,6 +136,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 {
 	struct kvm_cpuid_entry2 *best;
 	u64 xfeatures;
+	int r;
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
@@ -155,15 +156,18 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 	 * enabling in the FPU, e.g. to expand the guest XSAVE state size.
 	 */
 	best = cpuid_entry2_find(entries, nent, 0xd, 0);
-	if (!best)
-		return 0;
-
-	xfeatures = best->eax | ((u64)best->edx << 32);
-	xfeatures &= XFEATURE_MASK_USER_DYNAMIC;
-	if (!xfeatures)
-		return 0;
+	if (best) {
+		xfeatures = best->eax | ((u64)best->edx << 32);
+		xfeatures &= XFEATURE_MASK_USER_DYNAMIC;
+		if (xfeatures) {
+			r = fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu,
+							  xfeatures);
+			if (r)
+				return r;
+		}
+	}
 
-	return fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu, xfeatures);
+	return static_call(kvm_x86_vcpu_check_cpuid)(vcpu, entries, nent);
 }
 
 /* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
-- 
2.25.1


