Return-Path: <kvm+bounces-25824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B9E96AF18
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:19:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4CBB1C236EF
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CEE613D61A;
	Wed,  4 Sep 2024 03:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ytze5hD2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5C0139CFC;
	Wed,  4 Sep 2024 03:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419684; cv=none; b=sN5lkjCKT/EOa4wHmDOzKI3hZspXThPihW+ehDJritr0+hNlih7AHyYoD/4QnCVTpA72MmY4AxqM/7E9XexQNjhT3FbKK86TawAn8LAff+D2sbVfVQuaREbzYceC+ZQ3F+/SMn+LlkIbLXtsjWrzqKeVSCIt0CITYpVGRCnJ500=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419684; c=relaxed/simple;
	bh=P5V/xRC5gwlM8RuyOqE/ALPqpDAH8g0S2cKP5+h2srI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QT2FwGCieRJfrmC2ePC3eIlzFYa4DIUvOssjS0dGG/ju+re2sMX9E8VSIxQix2CYeHWE8thPC5Pu9qgasujOCXvzBrBzBiN071g6dJNvP0fLrb39yREIQ2GZPDMPk8paffSk26yio9pyLDuojw6T2hThBURFZadbYZw3hbmZpyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ytze5hD2; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419682; x=1756955682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P5V/xRC5gwlM8RuyOqE/ALPqpDAH8g0S2cKP5+h2srI=;
  b=Ytze5hD2eClOpgW4s2+SxPRmprQ4Wi+FKilipRhOfcJWh1/3MxXF/aJu
   aX1/PzqUw+aepiWoxK4xOH4xu/ZxhuTvSgFZc/0ex20eZm96pO486homU
   7Bd9i4ieY8SqHt1S1JTpANM05Q9eOt7VVyYVewH7wVRWpwWii55RYMNPF
   Hw6zRcAOPWmRb3tj5HtROjCCebsKBgGu2VWwgwg2tsdWBp2TWJ1CzhPfT
   phCwphNVBA+VMN92Dx1tLPRKPiUqoHV8DTApPJ7wFAe/7WYZ6j5BwnfS/
   1B9nap8vx/wnhIYw67rPc+x4NOA/dzd86RTbH/osfNnyzLjclqH2L/cki
   Q==;
X-CSE-ConnectionGUID: T3g6alZdQ/mbP7igriSTGA==
X-CSE-MsgGUID: JlcLZrAeTzK9uHHYuH7YDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564705"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564705"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:10 -0700
X-CSE-ConnectionGUID: 37obUln5S3GaxwtSWbZkhw==
X-CSE-MsgGUID: waJ59fTCT9qWto0vgk/xig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106341"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:09 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 15/21] KVM: TDX: Implement hook to get max mapping level of private pages
Date: Tue,  3 Sep 2024 20:07:45 -0700
Message-Id: <20240904030751.117579-16-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement hook private_max_mapping_level for TDX to let TDP MMU core get
max mapping level of private pages.

The value is hard coded to 4K for no huge page support for now.

Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU part 2 v1:
 - Split from the big patch "KVM: TDX: TDP MMU TDX support".
 - Fix missing tdx_gmem_private_max_mapping_level() implementation for
   !CONFIG_INTEL_TDX_HOST

v19:
 - Use gmem_max_level callback, delete tdp_max_page_level.
---
 arch/x86/kvm/vmx/main.c    | 10 ++++++++++
 arch/x86/kvm/vmx/tdx.c     |  5 +++++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index bf6fd5cca1d6..5d43b44e2467 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -184,6 +184,14 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return tdx_vcpu_ioctl(vcpu, argp);
 }
 
+static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	if (is_td(kvm))
+		return tdx_gmem_private_max_mapping_level(kvm, pfn);
+
+	return 0;
+}
+
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -337,6 +345,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.mem_enc_ioctl = vt_mem_enc_ioctl,
 	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
+
+	.private_max_mapping_level = vt_gmem_private_max_mapping_level
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b8cd5a629a80..59b627b45475 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1582,6 +1582,11 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return ret;
 }
 
+int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	return PG_LEVEL_4K;
+}
+
 #define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
 
 static int __init setup_kvm_tdx_caps(void)
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index d1db807b793a..66829413797d 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -142,6 +142,7 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
+int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 #else
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
@@ -185,6 +186,7 @@ static inline int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 
 static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
+static inline int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn) { return 0; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.34.1


