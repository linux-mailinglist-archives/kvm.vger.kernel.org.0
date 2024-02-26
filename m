Return-Path: <kvm+bounces-9752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E81D866DBB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 818711C23973
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 765CA131733;
	Mon, 26 Feb 2024 08:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AP+XfOpS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (unknown [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7436B12FF84;
	Mon, 26 Feb 2024 08:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936163; cv=none; b=cKYhP+UyqT8H6IRs7nW7mkoj8Qrc8TPkoVJbB/KWJzUw1SIHe808NAr37eT8COkagljaFFiqsuLGkepIoZoAdaRkHQzsr2GMeFYLrWcUjlt1F7HmBwwBBoVhXqOn8YU1jZzcXfJcS6CDE9nSeb7BtQCN3nNl01sfTWoOZhkyuB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936163; c=relaxed/simple;
	bh=GYUoCTMLboGXsWuOy4m9bSJkkeOM9TwHQqtrMXvV0wo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qH2RQqojcNlmnvMT88Sauh5LuEJcSR2va/MnzgIoSDNLPVb7iflRIFMCTWC2x6QwGjthDqFI8r2ioF7ltWEp5+lHqAcrTfDaJUgPeJoI5SWPWB324w76eDZnHOuGybAzFwITyuISf9dsprL+tatI/iV32OMYVoXAVdn90KSkR74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AP+XfOpS; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936161; x=1740472161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GYUoCTMLboGXsWuOy4m9bSJkkeOM9TwHQqtrMXvV0wo=;
  b=AP+XfOpSMOZs4DCCiNDuOS71873UyxcHmpcYWtKPnpCDpkKho2fwE2bt
   VwbBWqBDndYh94aNJHqm4Daf0IqO3xX6IyJapPn8FrN6I4l1nPNFRUpnD
   irT6jJB5fDDZCZPdh03yY5U34Er4VRTXwj9Uh7pCY4IW7VcI/5XwRJBm5
   jz3CCBAp1Cjrf3lBcpZ+D6regH1T4nPVWlCqlAPp+6Y8/DDgAuvaxjlM4
   fDmWDmB+nGI5blH5JuaMs4YdpBwaa6bDQCJnOqWiAQon0nvTwzcf3pW2H
   4wFkKdWz+/Np/ojO0P57OQ0Yyh70SKYFgL9IHwLr8KNyyg4WP+0c9zLBM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751427"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751427"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735163"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:13 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 129/130] RFC: KVM: x86: Add x86 callback to check cpuid
Date: Mon, 26 Feb 2024 00:27:11 -0800
Message-Id: <ac424b167210288cdf32ac940bcc6ec84f8a45b9.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
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
index 85c04aad6ab3..3a7140129855 100644
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
index 920fb771246b..e4d40e31fc31 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1638,6 +1638,7 @@ struct kvm_x86_ops {
 	void (*hardware_unsetup)(void);
 	int (*offline_cpu)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
+	int (*vcpu_check_cpuid)(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2, int nent);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	bool (*is_vm_type_supported)(unsigned long vm_type);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8cdcd6f406aa..b57006943247 100644
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


