Return-Path: <kvm+bounces-37779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9AA0A301B5
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:53:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28C331889F59
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 226381D63C7;
	Tue, 11 Feb 2025 02:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gzQfU5gg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1301D5ACE;
	Tue, 11 Feb 2025 02:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242390; cv=none; b=JpMiG5oaj9a/bfi7HXDqaPwN14/50pwWGiMaLJIZyZZc4BdXSCJLjDeFiKTXCwAS9ZjiryNap1RVEuZvKi6FrVqbIgYMAlQM8PeTDOdxQyzO5jqDGtMI514sG6y26xrjCEuykND+kZd/GQnUYeeKVHiTpxRfYZ9nR1olH7+IBys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242390; c=relaxed/simple;
	bh=4ZjJT3SQODngSUmtn6bJJ64fMMTdXrkSzpJP2btL/a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEwCe7n/3sTVIr39K4XX6gm42HiQll8aVKjg2ifjMowqfMOA6RmEcgaOHD7LPnrRtih5ten/LAh3murrbc/K9J6tdJusquPEVwbw8W/OsMHR1cZhhbEd1VGl4wk6dQUpFMS+cOBr3HpI6CaBg/H6YFiimH3Uhzu4VWtxkekrcXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gzQfU5gg; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242389; x=1770778389;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4ZjJT3SQODngSUmtn6bJJ64fMMTdXrkSzpJP2btL/a4=;
  b=gzQfU5ggoekLXIChxFS5HlCWXBRisa9uY4Z4Egcm3I1ideH32JKk9iNC
   moteuGKdU9fVef6ctEsk6yOWSkhflTKE+So2gFyDKPvlniXV/xVVhjAHB
   KIQ2SLxd8C1dS3eP8XaaorV9Qca630GMrGY2WzGWZNTFWdedKy4FzI6SD
   aXPtoQuaIPz6AM3vZ36abMUVY/zYQUlThLqwxPO+00/Jqqt/WN93YUORB
   hhSegCf9toZW6wQmH7Vd4jj7gqZTBgGI3kL5qhg9O0JxU4aV2yZPq/2hL
   J3zOv2DDOyEgZKMypcUdosIJJOXWKUCnrEVyDLJ23WgAMbmKTVPVMEswK
   g==;
X-CSE-ConnectionGUID: i7XolAemSOmAlSKzpV4jtg==
X-CSE-MsgGUID: RMYMi3sKTBSelrGfy0TDcQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43506592"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43506592"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:09 -0800
X-CSE-ConnectionGUID: k7F5yYDoSt+b4S/1JCEeig==
X-CSE-MsgGUID: i61U/UOfQTSy/WrxOQjT/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112236403"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:05 -0800
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
Subject: [PATCH v2 1/8] KVM: x86: Have ____kvm_emulate_hypercall() read the GPRs
Date: Tue, 11 Feb 2025 10:54:35 +0800
Message-ID: <20250211025442.3071607-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
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
---
 arch/x86/kvm/x86.c | 15 ++++++++-------
 arch/x86/kvm/x86.h | 26 +++++++++-----------------
 2 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ace11303f90..29f33f7c9da9 100644
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


