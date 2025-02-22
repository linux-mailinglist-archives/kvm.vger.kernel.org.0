Return-Path: <kvm+bounces-38927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BD9FA404C3
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:41:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6EE217939D
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D76D81F7919;
	Sat, 22 Feb 2025 01:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bn7SRBpZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575F21E2847;
	Sat, 22 Feb 2025 01:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188458; cv=none; b=CuNSaj9x115N/RJcmYUfHm76ggHOHj6bYn6lBg3JOUzGZ5A5UaJ7CaeQb5VXz6QzyBAXPGF8LwOa+4Y4reEoerG50Ce+lTOekXEZbKny+ojGYN4zjQaHdhs17dZMwOhc0pSo/g1RTiWVZBP68JQNbZeaDeHQOHOp4tP3LuMx/9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188458; c=relaxed/simple;
	bh=cMGVQk/B4sh5x7ZgVUEmqPIMM1GzcauaGKpabgrjf9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4BKXrkz/g9E63ccx9d4Ivhf1VlWwwtRNMXp6FzaI9rvBl6gdmPriECkukE0pQ8qRlm9j5sQufuU9wL0ZmUm4dgea/tA5L3xLQAS+ByNRBEMD5Ru9tYAoe7XK5kDw1OCxUzov0+qhNF7yXPYZes87S4o3ZqkAiexdTb8nWt0UUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bn7SRBpZ; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188456; x=1771724456;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cMGVQk/B4sh5x7ZgVUEmqPIMM1GzcauaGKpabgrjf9Q=;
  b=Bn7SRBpZH6tqFycPY1DJzCIGBcvd+amjmG3FB1MH0eZ8mT+PP7O4EPOO
   JmBu3DFHFZtCVQKPqzPR+Ulz8cjEl7OvDHhshy7sGroQeZZ1Kz9Bd+eco
   orZhvYwRHWfTN48XpK3WSX8lGFwlDE6TN6OAXig0tLlDxVJ7xwAmEeC0S
   b4r0b30mBAWUPfXH3aL+AhYuwSRKdmTG91q3UaRqCz/o9HGsF3pVnCXQr
   xHVPlJucZ4MNX/73rdTdes84uKOoHSdPvGXF/06Vh7HaT89GurlJ/+0Xq
   mXany81cX1X6CLQDlx29ojeSvntm1usvprEwof9sgNWUOLKxWgNNu/2Fv
   w==;
X-CSE-ConnectionGUID: 2o//q4wLQuuzUYOeyKziJA==
X-CSE-MsgGUID: vHIDQ8IbRFi6E3I78XgvsQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11352"; a="40893250"
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="40893250"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:40:56 -0800
X-CSE-ConnectionGUID: Pktr7dBZQg6sorfNrTgZrA==
X-CSE-MsgGUID: PknHIJhURECoi7jVnMx5eQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="146370229"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:40:53 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v3 1/9] KVM: x86: Have ____kvm_emulate_hypercall() read the GPRs
Date: Sat, 22 Feb 2025 09:42:17 +0800
Message-ID: <20250222014225.897298-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014225.897298-1-binbin.wu@linux.intel.com>
References: <20250222014225.897298-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Have ____kvm_emulate_hypercall() read the GPRs instead of passing them
in via the macro.

When emulating KVM hypercalls via TDVMCALL, TDX will marshall registers of
TDVMCALL ABI into KVM's x86 registers to match the definition of KVM
hypercall ABI _before_ ____kvm_emulate_hypercall() gets called.  Therefore,
____kvm_emulate_hypercall() can just read registers internally based on KVM
hypercall ABI, and those registers can be removed from the
__kvm_emulate_hypercall() macro.

Also, op_64_bit can be determined inside ____kvm_emulate_hypercall(),
remove it from the __kvm_emulate_hypercall() macro as well.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
---
Hypercalls exit to userspace v3:
- Add RB from Kai.
---
 arch/x86/kvm/x86.c | 15 ++++++++-------
 arch/x86/kvm/x86.h | 26 +++++++++-----------------
 2 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0bf1727d9f72..62dded70932d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10022,13 +10022,16 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
-			      unsigned long a0, unsigned long a1,
-			      unsigned long a2, unsigned long a3,
-			      int op_64_bit, int cpl,
+int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, int cpl,
 			      int (*complete_hypercall)(struct kvm_vcpu *))
 {
 	unsigned long ret;
+	unsigned long nr = kvm_rax_read(vcpu);
+	unsigned long a0 = kvm_rbx_read(vcpu);
+	unsigned long a1 = kvm_rcx_read(vcpu);
+	unsigned long a2 = kvm_rdx_read(vcpu);
+	unsigned long a3 = kvm_rsi_read(vcpu);
+	int op_64_bit = is_64_bit_hypercall(vcpu);
 
 	++vcpu->stat.hypercalls;
 
@@ -10131,9 +10134,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	if (kvm_hv_hypercall_enabled(vcpu))
 		return kvm_hv_hypercall(vcpu);
 
-	return __kvm_emulate_hypercall(vcpu, rax, rbx, rcx, rdx, rsi,
-				       is_64_bit_hypercall(vcpu),
-				       kvm_x86_call(get_cpl)(vcpu),
+	return __kvm_emulate_hypercall(vcpu, kvm_x86_call(get_cpl)(vcpu),
 				       complete_hypercall_exit);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 91e50a513100..8b27f70c6321 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -621,25 +621,17 @@ static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
 	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
 }
 
-int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
-			      unsigned long a0, unsigned long a1,
-			      unsigned long a2, unsigned long a3,
-			      int op_64_bit, int cpl,
+int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, int cpl,
 			      int (*complete_hypercall)(struct kvm_vcpu *));
 
-#define __kvm_emulate_hypercall(_vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, complete_hypercall)	\
-({												\
-	int __ret;										\
-												\
-	__ret = ____kvm_emulate_hypercall(_vcpu,						\
-					  kvm_##nr##_read(_vcpu), kvm_##a0##_read(_vcpu),	\
-					  kvm_##a1##_read(_vcpu), kvm_##a2##_read(_vcpu),	\
-					  kvm_##a3##_read(_vcpu), op_64_bit, cpl,		\
-					  complete_hypercall);					\
-												\
-	if (__ret > 0)										\
-		__ret = complete_hypercall(_vcpu);						\
-	__ret;											\
+#define __kvm_emulate_hypercall(_vcpu, cpl, complete_hypercall)			\
+({										\
+	int __ret;								\
+	__ret = ____kvm_emulate_hypercall(_vcpu, cpl, complete_hypercall);	\
+										\
+	if (__ret > 0)								\
+		__ret = complete_hypercall(_vcpu);				\
+	__ret;									\
 })
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
-- 
2.46.0


