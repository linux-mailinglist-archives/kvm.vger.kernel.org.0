Return-Path: <kvm+bounces-6689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25AF8837880
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:21:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C92D91F21C59
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18E3282D86;
	Mon, 22 Jan 2024 23:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oi4mCESm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF50282D76;
	Mon, 22 Jan 2024 23:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967781; cv=none; b=TED1AN7zXK261BPKrQX59bP17cKguC1lKcvx/RF+YJBg+28GdC096B8hvh7LuFsPVEGBmsT9FDbz2Uj8cHFbQxmOzISTMfIfqwI5jlgZFjTgKTWyfOzbmh7G6033qkaLIsU8WV/GeU4Z9/ud9jeVHGO+zRpZypSnC8ZwaHRCF2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967781; c=relaxed/simple;
	bh=aUhdNswTSlh4dExBSB5iQ1sRamKjvsGJJ69O6iOhYK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J8cag85w/DGB83B+W2jLDgs8lyFa10eX7yldufgNNf+nYnLVfMeT5gjyrr8CBhpyMdA+eN9wvkYJH2u5mdS+Kw0UgIiZEUUFBLb9GRNf0cR8BZGwOvsIz9+NnzVx1kFDHWAGcT9tKnTCaxY6ow2me2JLSkQ2nfe8Pvez7lC8Pro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oi4mCESm; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967779; x=1737503779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aUhdNswTSlh4dExBSB5iQ1sRamKjvsGJJ69O6iOhYK8=;
  b=Oi4mCESm4HNoOUEcjkESGtYkzDkViB+YzwEKex5v7N/EFvJah1Kvd6bF
   qF5WlglCdU0OIzl47ctB7coYh0cgtzQBQ2iaipRXx6gt7ygTa+LfCh/l9
   cW8d1/xg/jb2kx/Sxk4E2M4+ciGpeNosV9QfNMFub6erROgL9lg0tIPdH
   Y6k8oDjFE9Vu8+25bSOtbDMnqvbkBOcUBYOk5YVF9TfM9DwMk/oetMtn+
   Sbz0is18XYjfaoc5J4f35VLGaWtepdjRjz7GpqCxHq+/Iu1yGujeQRHOp
   AIhZgw6h84NW5A3cYFgNcGQQT3SWCePVPQEnCKqev145AZjwflozQZyhl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217966"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217966"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27818051"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:59 -0800
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
Subject: [PATCH v18 119/121] RFC: KVM: x86: Add x86 callback to check cpuid
Date: Mon, 22 Jan 2024 15:54:35 -0800
Message-Id: <5f60a91ab6f0cb596ca37eb0f2365779dd59beb5.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
index ee0b82817c63..527db174d6b5 100644
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
index 54ac65b75f18..b83a790b01c8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1655,6 +1655,7 @@ struct kvm_x86_ops {
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


