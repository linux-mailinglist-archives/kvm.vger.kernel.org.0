Return-Path: <kvm+bounces-17399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 162AE8C5E86
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:01:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46A001C21233
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B2322F00;
	Wed, 15 May 2024 01:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ELClGgbz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBEB79C8;
	Wed, 15 May 2024 01:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715734808; cv=none; b=DchnOauOSx5Oj/40XJ8HH6pC1+BECVDdfk9evILnk2WG91qIfJuTA+SOeaOP20iWsedf9YmwwwRLaHzeM1XSktdZZOSKH2tMffclelXsBLfBqnQLvdmTjsqG1UAUIBepmyynb1oHfHs2vfjaSUbveElaBYzrVYMyPt38R8AYSZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715734808; c=relaxed/simple;
	bh=EiPyaz12Hs/yvu2vb2xAWA/RYdi5EWxAwUrWQYyN7dw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=omXYjLZAJZNkVKgFuc27xWr/qpePJh5RuQC+A5VCpKBUiyTLGGRf0aBAWJoPmkXx9JJ10zEJ7V6TZ8sI6AJ0Hz3mSnbg1rwsedW+zT1UcUMN6CVBh0kzfo0CgyzkAdcS8s1Ae1mDg4JP04fr8NeNEWxTMviU3tpEed3kwtOa+Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ELClGgbz; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715734805; x=1747270805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EiPyaz12Hs/yvu2vb2xAWA/RYdi5EWxAwUrWQYyN7dw=;
  b=ELClGgbzEWPPrOQH8LYy5ogKNpc3jx+tSlMjye+JiqFExsvgHzzG5Ct9
   qitUmcVoDVhkpetFmKXVQPz5vbo3K958kRmRMhGVT03kWxl2yOMXpRV1l
   8LbUHuVOAbukSalUjQQG+pKGdz0qOk53LdC849VmgH4RwWTxnPM+c11ou
   m9S6XowJ3sIy4Kexg/CBE4bx12e/9BNqlro6U4IbhtA6j4mgHkZFGQ+PL
   wHHZ5P2WBZXY+5wXa8IAPV48xnOhAOvnlndsOA4s65ZWz6dVJMGh0TysD
   dVgIKg510yGYw1RLTnUyDBprb/sYn7JLzwlRuHSPAPF4+93uxjxdsxfBv
   A==;
X-CSE-ConnectionGUID: JscFULhURNOu5LsnGHxd2A==
X-CSE-MsgGUID: KLCznybqRSyZBVQ8OZh0XA==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11613944"
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="11613944"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:04 -0700
X-CSE-ConnectionGUID: 59cLFGsYRK+7uA0a878tEw==
X-CSE-MsgGUID: G3nbzKu1SHaBw238yzeYqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="30942724"
Received: from oyildiz-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.51.34])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:02 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com,
	erdemaktas@google.com,
	sagis@google.com,
	yan.y.zhao@intel.com,
	dmatlack@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for TDX shared bit of GPA
Date: Tue, 14 May 2024 17:59:40 -0700
Message-Id: <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Introduce a "gfn_shared_mask" field in the kvm_arch structure to record GPA
shared bit and provide address conversion helpers for TDX shared bit of
GPA.

TDX designates a specific GPA bit as the shared bit, which can be either
bit 51 or bit 47 based on configuration.

This GPA shared bit indicates whether the corresponding physical page is
shared (if shared bit set) or private (if shared bit cleared).

- GPAs with shared bit set will be mapped by VMM into conventional EPT,
  which is pointed by shared EPTP in TDVMCS, resides in host VMM memory
  and is managed by VMM.
- GPAs with shared bit cleared will be mapped by VMM firstly into a
  mirrored EPT, which resides in host VMM memory. Changes of the mirrored
  EPT are then propagated into a private EPT, which resides outside of host
  VMM memory and is managed by TDX module.

Add the "gfn_shared_mask" field to the kvm_arch structure for each VM with
a default value of 0. It will be set to the position of the GPA shared bit
in GFN through TD specific initialization code.

Provide helpers to utilize the gfn_shared_mask to determine whether a GPA
is shared or private, retrieve the GPA shared bit value, and insert/strip
shared bit to/from a GPA.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX MMU Part 1:
 - Update commit log (Yan)
 - Fix documentation on kvm_is_private_gpa() (Binbin)

v19:
- Add comment on default vm case.
- Added behavior table in the commit message
- drop CONFIG_KVM_MMU_PRIVATE

v18:
- Added Reviewed-by Binbin
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu.h              | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aabf1648a56a..d2f924f1d579 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1519,6 +1519,8 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+	gfn_t gfn_shared_mask;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 3c7a88400cbb..dac13a2d944f 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -321,4 +321,37 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
 		return gpa;
 	return translate_nested_gpa(vcpu, gpa, access, exception);
 }
+
+/*
+ *			default or SEV-SNP	TDX: where S = (47 or 51) - 12
+ * gfn_shared_mask	0			S bit
+ * is_private_gpa()	always false		true if GPA has S bit clear
+ * gfn_to_shared()	nop			set S bit
+ * gfn_to_private()	nop			clear S bit
+ *
+ * fault.is_private means that host page should be gotten from guest_memfd
+ * is_private_gpa() means that KVM MMU should invoke private MMU hooks.
+ */
+static inline gfn_t kvm_gfn_shared_mask(const struct kvm *kvm)
+{
+	return kvm->arch.gfn_shared_mask;
+}
+
+static inline gfn_t kvm_gfn_to_shared(const struct kvm *kvm, gfn_t gfn)
+{
+	return gfn | kvm_gfn_shared_mask(kvm);
+}
+
+static inline gfn_t kvm_gfn_to_private(const struct kvm *kvm, gfn_t gfn)
+{
+	return gfn & ~kvm_gfn_shared_mask(kvm);
+}
+
+static inline bool kvm_is_private_gpa(const struct kvm *kvm, gpa_t gpa)
+{
+	gfn_t mask = kvm_gfn_shared_mask(kvm);
+
+	return mask && !(gpa_to_gfn(gpa) & mask);
+}
+
 #endif
-- 
2.34.1


