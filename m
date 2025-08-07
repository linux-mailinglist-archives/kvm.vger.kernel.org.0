Return-Path: <kvm+bounces-54238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A7F0B1D519
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:45:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADE033A9F92
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B108E26A1C1;
	Thu,  7 Aug 2025 09:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iwDFbdYA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E1E26561E;
	Thu,  7 Aug 2025 09:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559887; cv=none; b=TabgeZJApDTlhRV2ZLhEmz/uzQLQLj4BEXaaj7+ov5wuDYxl+yd8FxuApBIQ0t8zPCH2UmYZJYkfYNxaendHh220xivn6vjQW8ccZ37X3+iwfQ7pXU0R+vWuc1Nop0QyWa8A+VbxdHufbqnjMi/DqbrIYjYoQcTMD/8pEMEHuaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559887; c=relaxed/simple;
	bh=qiLN5p7E1cncHCdKCu04aYYinJrV0muMqx7d+uTLLCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SM4E2KFwOStTL3aA4qDVBfrfeeUhxjcvVQ1ENc9iazyKMoa2HrvOVyBkbcafu8nUbIbULK0u6IV/jU63rBDrxrsfPCnsirlVxcoQ821v5P/U4NUHfVIE4Ou8t7aPKnRYTfhMMJfl6ahqZOYxGqM+SAMdMusgGdwhYAveux4zQNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iwDFbdYA; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559886; x=1786095886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qiLN5p7E1cncHCdKCu04aYYinJrV0muMqx7d+uTLLCY=;
  b=iwDFbdYAS//1FQwsPVEFGfKGEBqruzTilJdYD8lj1p4oaEEPmdm2h+W9
   ZWlcc/CyvjU2Y1rSFxwu9EiUNcBe4GzZcULHaMQdK4dd+C3YhuJzk7Ldg
   KJAK3xbqxNB4DwAPFreSzMC5gMPnmpTZVnhJLL4tiQzS135qyN1gDxVIi
   V2aMJ8SOMaM1VTm8vd4LinMwUxBJCs1afuJnSwSjmbm5eBkK+As33o1wl
   fSAk6cYHW4Vf2peN0yDO1R1E3zZzmX8cGZ7RDEtIyfvm4PiJZ9wANncYv
   ZHKZHAIY+u+K8KuKHNZblRIK1zALU0VxaaJrDJ7Plkj0DzvXJgvJ5Ccpi
   g==;
X-CSE-ConnectionGUID: mSOIJdLASXmNEytmt84GLA==
X-CSE-MsgGUID: Ix3T/bf8Q4KsVF0fCmHX1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="67157551"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="67157551"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:44:46 -0700
X-CSE-ConnectionGUID: 2vO472MPQjOSURecjrqO/g==
X-CSE-MsgGUID: vdFGwaw1RPe4mb/xWJKNwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="202196393"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:44:41 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	pgonda@google.com,
	zhiquan1.li@intel.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	yan.y.zhao@intel.com
Subject: [RFC PATCH v2 13/23] KVM: x86: Introduce hugepage_set_guest_inhibit()
Date: Thu,  7 Aug 2025 17:44:10 +0800
Message-ID: <20250807094410.4621-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250807093950.4395-1-yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TDX requires guests to accept S-EPT mappings created by the host KVM. Due
to the current implementation of the TDX module, if a guest accepts a GFN
at a lower level after KVM maps it at a higher level, the TDX module will
emulate an EPT violation VMExit to KVM instead of returning a size mismatch
error to the guest. If KVM fails to perform page splitting in the VMExit
handler, the guest's accept operation will be triggered again upon
re-entering the guest, causing a repeated EPT violation VMExit.

To facilitate passing the guest's accept level information to the KVM MMU
core and to prevent the repeated mapping of a GFN at different levels due
to different accept levels specified by different vCPUs, introduce the
interface hugepage_set_guest_inhibit(). This interface specifies across
vCPUs that mapping at a certain level is inhibited from the guest.

The KVM_LPAGE_GUEST_INHIBIT_FLAG bit is currently modified in one
direction (set), so no clear interface is provided.

Link: https://lore.kernel.org/all/a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com/ [1]
Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- new in RFC v2
---
 arch/x86/kvm/mmu.h     |  3 +++
 arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index b122255c7d4e..c2d8819f3438 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -326,4 +326,7 @@ static inline bool kvm_is_gfn_alias(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn & kvm_gfn_direct_bits(kvm);
 }
+
+void hugepage_set_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level);
+bool hugepage_test_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level);
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 13910ae05f76..1c639286aac2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -721,12 +721,14 @@ static struct kvm_lpage_info *lpage_info_slot(gfn_t gfn,
 }
 
 /*
- * The most significant bit in disallow_lpage tracks whether or not memory
- * attributes are mixed, i.e. not identical for all gfns at the current level.
+ * The most 2 significant bits in disallow_lpage tracks whether or not memory
+ * attributes are mixed, i.e. not identical for all gfns at the current level,
+ * or whether or not guest inhibits the current level of hugepage at the gfn.
  * The lower order bits are used to refcount other cases where a hugepage is
  * disallowed, e.g. if KVM has shadow a page table at the gfn.
  */
 #define KVM_LPAGE_MIXED_FLAG	BIT(31)
+#define KVM_LPAGE_GUEST_INHIBIT_FLAG   BIT(30)
 
 static void update_gfn_disallow_lpage_count(const struct kvm_memory_slot *slot,
 					    gfn_t gfn, int count)
@@ -739,7 +741,8 @@ static void update_gfn_disallow_lpage_count(const struct kvm_memory_slot *slot,
 
 		old = linfo->disallow_lpage;
 		linfo->disallow_lpage += count;
-		WARN_ON_ONCE((old ^ linfo->disallow_lpage) & KVM_LPAGE_MIXED_FLAG);
+		WARN_ON_ONCE((old ^ linfo->disallow_lpage) &
+			     (KVM_LPAGE_MIXED_FLAG | KVM_LPAGE_GUEST_INHIBIT_FLAG));
 	}
 }
 
@@ -1647,6 +1650,18 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
 				 start, end - 1, can_yield, true, flush);
 }
 
+bool hugepage_test_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+{
+	return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_GUEST_INHIBIT_FLAG;
+}
+EXPORT_SYMBOL_GPL(hugepage_test_guest_inhibit);
+
+void hugepage_set_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+{
+	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_GUEST_INHIBIT_FLAG;
+}
+EXPORT_SYMBOL_GPL(hugepage_set_guest_inhibit);
+
 /*
  * Split large leafs crossing the boundary of the specified range
  *
-- 
2.43.2


