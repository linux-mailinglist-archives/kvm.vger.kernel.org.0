Return-Path: <kvm+bounces-3255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97996801C1A
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 11:04:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4279F1F211A3
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3030215AD8;
	Sat,  2 Dec 2023 10:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kuuNYiyc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE5E19F;
	Sat,  2 Dec 2023 02:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701511473; x=1733047473;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=aDYDeaOzsRKl3ev8dC58rNFjF38aQ9l/2QXjjp0gHNA=;
  b=kuuNYiyc/pDkoT46m+N9x8z6QqhoASjGdUluT1jJFXb85y1a90tJGoO9
   U8ocQEdYuKY16rNuFoFZeK+gdEsxTDBzSuhg16enrqveXfWpzYG5bDSLL
   wEzvqI2VNJcxubuUqgXKWGI/AqpA3zos7jcZ1g6RAQ87udXb9efiIbgyj
   Jnn99j02n7MKDrN9QcKFhB5ROGxJg68Gi5pE9HqZwI27WnHzDgUDJgtOn
   qtMCbQz8x+fAAU0uaqXmxzJNXwUNcmcBp/u1L3lALUVku5axXKzh8NWyl
   t1IVCcTpr+A25kiSMCGz0wRTJadaooWBWDuvdz3siYO68dNSKlyGmLdqs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="392459638"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="392459638"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 02:04:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="887939832"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="887939832"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 02:04:30 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 39/42] KVM: VMX: add config KVM_INTEL_EXPORTED_EPT
Date: Sat,  2 Dec 2023 17:35:35 +0800
Message-Id: <20231202093535.15874-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add config KVM_INTEL_EXPORTED_EPT to let kvm_intel.ko support exporting EPT
to KVM external components (e.g. Intel VT-d).

This config will turn on HAVE_KVM_EXPORTED_TDP and
HAVE_KVM_MMU_PRESENT_HIGH automatically.

HAVE_KVM_MMU_PRESENT_HIGH will make bit 11 reserved as 0.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/Kconfig | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 950c12868d304..7126344077ab5 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -99,6 +99,19 @@ config X86_SGX_KVM
 
 	  If unsure, say N.
 
+config KVM_INTEL_EXPORTED_EPT
+	bool "export EPT to be used by other modules (e.g. iommufd)"
+	depends on KVM_INTEL
+	select HAVE_KVM_EXPORTED_TDP
+	select HAVE_KVM_MMU_PRESENT_HIGH if X86_64
+	help
+	  Intel EPT is architecturally guaranteed of compatible to stage 2
+	  page tables in Intel IOMMU.
+
+	  Enable this feature to allow Intel EPT to be exported and used
+	  directly as stage 2 page tables in Intel IOMMU.
+
+
 config KVM_AMD
 	tristate "KVM for AMD processors support"
 	depends on KVM && (CPU_SUP_AMD || CPU_SUP_HYGON)
-- 
2.17.1


