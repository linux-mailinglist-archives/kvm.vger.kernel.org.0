Return-Path: <kvm+bounces-936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF667E4286
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 90B86B21CBC
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8325347BB;
	Tue,  7 Nov 2023 14:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j2MbLED0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADE3347A2
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:59:09 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61399213E;
	Tue,  7 Nov 2023 06:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369117; x=1730905117;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+P8cR1cYyts9rDhYt6tuRlu6V1ZVPVeTaNd1IjKjI/0=;
  b=j2MbLED0le/okToyz0MdbWLToeI86VETuanUOlbMfQHHT9P83At5SmVc
   MUzTLISuUUgkX/6YPjAqZZMq6O8QndzcfIxdquvFOK6VLs938r3K1drTx
   aXg/XziAnK1gRIOO7uOZgq79r+k/behlYmL+RWkj1Zi74q47ieuGwQ3MT
   tKOKohqKD+TIv8CR512Xxy0LxS3H5PzJHWudZ3dsiU1PUluu64CY/VPYB
   z4F9mXPC36s/XCSbV3hAYEExZi0atjYWfrGhqa9IRXmYtfgK3Qud3eRdG
   8m1NDKeNox0E13ryArtlZdx8hG9BjmYqNtlaypNr2X9rQzAmlZBZVGS0G
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462271"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462271"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851367"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:10 -0800
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
Subject: [PATCH v17 042/116] KVM: x86/mmu: Add a new is_private member for union kvm_mmu_page_role
Date: Tue,  7 Nov 2023 06:56:08 -0800
Message-Id: <170a985ae8683895099bf04188ad1d31460d6af6.1699368322.git.isaku.yamahata@intel.com>
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

Because TDX support introduces private mapping, add a new member in union
kvm_mmu_page_role with access functions to check the member.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/mmu/mmu_internal.h |  5 +++++
 arch/x86/kvm/mmu/spte.h         |  6 ++++++
 3 files changed, 38 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9490ba898233..1c6121d06320 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -348,7 +348,12 @@ union kvm_mmu_page_role {
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
 		unsigned passthrough:1;
+#ifdef CONFIG_KVM_MMU_PRIVATE
+		unsigned is_private:1;
+		unsigned :4;
+#else
 		unsigned :5;
+#endif
 
 		/*
 		 * This is left at the top of the word so that
@@ -360,6 +365,28 @@ union kvm_mmu_page_role {
 	};
 };
 
+#ifdef CONFIG_KVM_MMU_PRIVATE
+static inline bool kvm_mmu_page_role_is_private(union kvm_mmu_page_role role)
+{
+	return !!role.is_private;
+}
+
+static inline void kvm_mmu_page_role_set_private(union kvm_mmu_page_role *role)
+{
+	role->is_private = 1;
+}
+#else
+static inline bool kvm_mmu_page_role_is_private(union kvm_mmu_page_role role)
+{
+	return false;
+}
+
+static inline void kvm_mmu_page_role_set_private(union kvm_mmu_page_role *role)
+{
+	WARN_ON_ONCE(1);
+}
+#endif
+
 /*
  * kvm_mmu_extended_role complements kvm_mmu_page_role, tracking properties
  * relevant to the current MMU configuration.   When loading CR0, CR4, or EFER,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e2df38457dae..f4451c67810a 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -144,6 +144,11 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 	return kvm_mmu_role_as_id(sp->role);
 }
 
+static inline bool is_private_sp(const struct kvm_mmu_page *sp)
+{
+	return kvm_mmu_page_role_is_private(sp->role);
+}
+
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 1a163aee9ec6..88db32cba0fd 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -264,6 +264,12 @@ static inline struct kvm_mmu_page *root_to_sp(hpa_t root)
 	return spte_to_child_sp(root);
 }
 
+static inline bool is_private_sptep(u64 *sptep)
+{
+	WARN_ON_ONCE(!sptep);
+	return is_private_sp(sptep_to_sp(sptep));
+}
+
 static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
 {
 	return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
-- 
2.25.1


