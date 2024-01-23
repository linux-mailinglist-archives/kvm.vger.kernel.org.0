Return-Path: <kvm+bounces-6709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 83B20837BC0
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:07:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB457B2D9B0
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8D6D153509;
	Tue, 23 Jan 2024 00:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fHIGO4Wx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905E2151CE4;
	Tue, 23 Jan 2024 00:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969369; cv=none; b=jRtLXcROeJ06l69BwO6rMAgOZv8y/9ShAyztO9Cea27bM03OgoyRPASr5yB7KGhSiwMllnnQE314jBmIUOoaEtiYyeSLnky+f41zIw97cDKGeKszwwGJ1ME712IZnewpLl/B6M2LASaLGsKRVHrHxD4SapHWePVay5BkE+XU9co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969369; c=relaxed/simple;
	bh=oOdtFrbtkdulJhQpZoj4hAR/TTunbrVEH9i/DDy2uWA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wc41dBcMI1AwKDOc7VGNGx5SFKjNdCcw5Vy/g/ZbWffLfNcQtnJ1rnjWIUMJr9t4ia/ozux+fixGpSUB1sIK2T7NvmmHM8/g9leg/TTSFcpcKkXatkoPZjrZHGULbgsP4UeMuyVM/JkrVtPWtO0H1u62D62L5xfLPCZuzDzX0bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fHIGO4Wx; arc=none smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705969367; x=1737505367;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oOdtFrbtkdulJhQpZoj4hAR/TTunbrVEH9i/DDy2uWA=;
  b=fHIGO4Wx0fautjWxbPgo54EvTc/SRVTBgOY3rD/50y+oJSrqv+NLDqy2
   NOfkhWIcSTvxivm8RqEtJR+izOfaP01EPgfni01QrI3A712hkiEksmMPf
   SFUseUgykEwmQcsMpoerlO69fOD6ERy24JOEccLhSo7ZCgUDcCv7/fi3t
   rHlhb0tRkVgjaiR2OHiu5MGcEvc54aho3W4IAYIxLoO+esKGYaewDGhE3
   gFk4BmOSD6Hiy5BJAD+vRRZX9ntlfQwOU6WOgPPs92/326inTv+qmiHVY
   WB5iIJESj8z4O+jyx0tHVqzmvZFw8KvsHNij4W1DI/DtMDZwvRse6BTdr
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="405125706"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="405125706"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27825672"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:41 -0800
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
	tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v7 13/13] KVM: TDX: Allow 2MB large page for TD GUEST
Date: Mon, 22 Jan 2024 16:22:28 -0800
Message-Id: <1f8f8f8a9450cd83e2a38abec26b0725b6d1ded4.1705965958.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965958.git.isaku.yamahata@intel.com>
References: <cover.1705965958.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

Now that everything is there to support 2MB page for TD guest.  Because TDX
module TDH.MEM.PAGE.AUG supports 4KB page and 2MB page, set struct
kvm_arch.tdp_max_page_level to 2MB page level.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 9 ++-------
 arch/x86/kvm/vmx/tdx.c     | 4 ++--
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 42c8cf1abdf8..feb499dc381e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1544,14 +1544,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
-		if (is_shadow_present_pte(iter.old_spte)) {
-			/*
-			 * TODO: large page support.
-			 * Doesn't support large page for TDX now
-			 */
-			KVM_BUG_ON(is_private_sptep(iter.sptep), vcpu->kvm);
+		if (is_shadow_present_pte(iter.old_spte))
 			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
-		} else
+		else
 			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
 
 		/*
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f26caa496d1b..7ef1d3536f0e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -636,8 +636,8 @@ int tdx_vm_init(struct kvm *kvm)
 	 */
 	kvm_mmu_set_mmio_spte_value(kvm, 0);
 
-	/* TODO: Enable 2mb and 1gb large page support. */
-	kvm->arch.tdp_max_page_level = PG_LEVEL_4K;
+	/* TDH.MEM.PAGE.AUG supports up to 2MB page. */
+	kvm->arch.tdp_max_page_level = PG_LEVEL_2M;
 
 	/*
 	 * This function initializes only KVM software construct.  It doesn't
-- 
2.25.1


