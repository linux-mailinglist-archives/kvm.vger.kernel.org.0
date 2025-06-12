Return-Path: <kvm+bounces-49235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91DC4AD6A4E
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:20:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8B0B7A54F9
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90702147EA;
	Thu, 12 Jun 2025 08:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kxWpBcHD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9064C15573F;
	Thu, 12 Jun 2025 08:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716392; cv=none; b=BiJ1xAVcrDKeb4LFdcfJzf5hPjGR6h0DRxV4IZm5UjdxSDGlCEErxWM0ozNuT5nUpaYhFjuNyaTUPFIXZyypbKIgaJl+205GRI/Ix5qVeRtEWbxdvw2tqhvB5P/hp97+jT5b7q47qmFpai7Vuz+uWG9lDukL7ZTTd4+PngyA8pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716392; c=relaxed/simple;
	bh=SYXMvbToRweHKkEdcDdTpmD0lk4fIWIET91tfrPxn0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psFg7jopOxKkZnTPgOyejZf71fu83t4sGnmWO0Pil05WrTPZw3RU7Dh7M/JWYtkBKRl+HtEUCVEYhWQB5RLbI9suEZDoK+MrFkA5rkKPBOEHJA7xvyyhbFaTxLqM3lu2WiO2j0CO7v+rex+s2Kio3beP+gYokouIGLuIsaH8yZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kxWpBcHD; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749716391; x=1781252391;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SYXMvbToRweHKkEdcDdTpmD0lk4fIWIET91tfrPxn0g=;
  b=kxWpBcHDoDigiBE8pSNH1tKuhJYXm/hUxK4rpaUA6J/SIuIVBAmPnN/r
   Q6G9h5XJGOmguA1jedkjj/+3KezOeMon8a8p2PAfm6ItfxBzlX86YGy/v
   qy586XEPk9zY70K/Yycm/kRk/NArk/wDU+TOVqijLnvQdCJPdzmtZ6Zsa
   zJ7fVdMqAA8uut3NV3sbbwN5dIPO+9fvUb5uTK/3fJrwFuFhb7+PFGxSQ
   rGBXR8O5tNn9ovfhLf3EtXn1dKaY5FvRcAbO/xQVAjtCzSs/nzZqdGkpg
   028RKwG86CPk0CZrPMHF01LJ1RsdUaNNFTFJBLHmO4PYxRCUlLmYCZt5L
   g==;
X-CSE-ConnectionGUID: KHqkoJWOQQqDczg9BqGaRg==
X-CSE-MsgGUID: htZkr1wgThWVBJsYSGEO3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51759991"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="51759991"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:19:50 -0700
X-CSE-ConnectionGUID: q94ITojUTHWQGBgPzi8UFA==
X-CSE-MsgGUID: gfK92fZrRBCeFGcHeKhl9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="147322373"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:19:50 -0700
From: Chao Gao <chao.gao@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	dapeng1.mi@linux.intel.com,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH 1/2] KVM: x86: Deduplicate MSR interception enabling and disabling
Date: Thu, 12 Jun 2025 01:19:46 -0700
Message-ID: <20250612081947.94081-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250612081947.94081-1-chao.gao@intel.com>
References: <20250612081947.94081-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extract a common function from MSR interception disabling logic and create
disabling and enabling functions based on it. This removes most of the
duplicated code for MSR interception disabling/enabling.

No functional change intended.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/svm/svm.c | 23 +++++++++--------------
 arch/x86/kvm/svm/svm.h | 10 +---------
 arch/x86/kvm/vmx/vmx.c | 25 +++++++++----------------
 arch/x86/kvm/vmx/vmx.h | 10 +---------
 4 files changed, 20 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5453478d1ca3..cc5f81afd8af 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -685,21 +685,21 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	return svm_test_msr_bitmap_write(msrpm, msr);
 }
 
-void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
+void svm_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type, bool enable)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	void *msrpm = svm->msrpm;
 
 	/* Don't disable interception for MSRs userspace wants to handle. */
 	if (type & MSR_TYPE_R) {
-		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
+		if (!enable && kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
 			svm_clear_msr_bitmap_read(msrpm, msr);
 		else
 			svm_set_msr_bitmap_read(msrpm, msr);
 	}
 
 	if (type & MSR_TYPE_W) {
-		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
+		if (!enable && kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
 			svm_clear_msr_bitmap_write(msrpm, msr);
 		else
 			svm_set_msr_bitmap_write(msrpm, msr);
@@ -709,19 +709,14 @@ void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	svm->nested.force_msr_bitmap_recalc = true;
 }
 
-void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
+void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-	void *msrpm = svm->msrpm;
-
-	if (type & MSR_TYPE_R)
-		svm_set_msr_bitmap_read(msrpm, msr);
-
-	if (type & MSR_TYPE_W)
-		svm_set_msr_bitmap_write(msrpm, msr);
+	svm_set_intercept_for_msr(vcpu, msr, type, false);
+}
 
-	svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
-	svm->nested.force_msr_bitmap_recalc = true;
+void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
+{
+	svm_set_intercept_for_msr(vcpu, msr, type, true);
 }
 
 void *svm_alloc_permissions_map(unsigned long size, gfp_t gfp_mask)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8d3279563261..faa478d9fc62 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -696,15 +696,7 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 
 void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
 void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
-
-static inline void svm_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
-					     int type, bool enable_intercept)
-{
-	if (enable_intercept)
-		svm_enable_intercept_for_msr(vcpu, msr, type);
-	else
-		svm_disable_intercept_for_msr(vcpu, msr, type);
-}
+void svm_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type, bool enable);
 
 /* nested.c */
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 277c6b5b5d5f..559261b18512 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3952,7 +3952,7 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 	vmx->nested.force_msr_bitmap_recalc = true;
 }
 
-void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
+void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type, bool enable)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
@@ -3963,35 +3963,28 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	vmx_msr_bitmap_l01_changed(vmx);
 
 	if (type & MSR_TYPE_R) {
-		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
+		if (!enable && kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
 			vmx_clear_msr_bitmap_read(msr_bitmap, msr);
 		else
 			vmx_set_msr_bitmap_read(msr_bitmap, msr);
 	}
 
 	if (type & MSR_TYPE_W) {
-		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
+		if (!enable && kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
 			vmx_clear_msr_bitmap_write(msr_bitmap, msr);
 		else
 			vmx_set_msr_bitmap_write(msr_bitmap, msr);
 	}
 }
 
-void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
+void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
-
-	if (!cpu_has_vmx_msr_bitmap())
-		return;
-
-	vmx_msr_bitmap_l01_changed(vmx);
-
-	if (type & MSR_TYPE_R)
-		vmx_set_msr_bitmap_read(msr_bitmap, msr);
+	vmx_set_intercept_for_msr(vcpu, msr, type, false);
+}
 
-	if (type & MSR_TYPE_W)
-		vmx_set_msr_bitmap_write(msr_bitmap, msr);
+void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
+{
+	vmx_set_intercept_for_msr(vcpu, msr, type, true);
 }
 
 static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a26fe3d9e1d2..31acd8c726e3 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -388,21 +388,13 @@ void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 
 void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
 void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
+void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type, bool enable);
 
 u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
 u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 
 gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 
-static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
-					     int type, bool value)
-{
-	if (value)
-		vmx_enable_intercept_for_msr(vcpu, msr, type);
-	else
-		vmx_disable_intercept_for_msr(vcpu, msr, type);
-}
-
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 
 /*
-- 
2.47.1


