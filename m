Return-Path: <kvm+bounces-25814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A087896AF00
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:16:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C551A1C23647
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8A9E823C8;
	Wed,  4 Sep 2024 03:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kaDwkPcv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C3973451;
	Wed,  4 Sep 2024 03:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419676; cv=none; b=tU/JWVFokS4eU3C3T6oDhq3CIDbC4B/3xBkFxUzCv7NdDj/PqSczVE45FFNILa3Lzw+yFxqwqinwDQhwI8+Iz/Rz7MGU8CuDmeSWKXphgsHHKY4jotY9UxTGqWxX0Rj9PaFY44iAzU3LUnJPD4/uXeFM4RE18sCchsL997xpr64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419676; c=relaxed/simple;
	bh=XkVvA1F9Zc4YZMj/WX+e9PpU3SrBeleKnicgyV8p5Ho=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GJX0UHeUtiGJlURBOoNL1F2z4BWUB8FekUtXhOpUinDrBs1VLeDuPHvMyIIcQ6KPCTpeGCb+8i3UZs3QvC2OvasNSCepCp6mKc4POYinJ6lUOK+z9qPPEFZ3Z1dYUQanflF9lnlf2WXbIo8UOFBzQWCR+N0Wd9D8wWZ2ixhma/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kaDwkPcv; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419675; x=1756955675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XkVvA1F9Zc4YZMj/WX+e9PpU3SrBeleKnicgyV8p5Ho=;
  b=kaDwkPcvONtbO/LkzhhTyLe966cqZgRyjASJpDsMocyOkQb9mXWscCI3
   u7YXMepjBSSyAa2rga5Idx3mBF6lDnvgMGQrUhVHDRzLgBJvPnrGv8hbV
   MERNOkUUxONzekNn4UovII7snhkzZKoSZsBA7fNCySXDcd1iU7qbpb//S
   kvK1WlqCX410bEZYXKALDq19uqIo20iO6aKzQHt52b2bFi7e+r4tMcNTn
   QVCAprFTd+lxJ3C+1xAYSS80M2XWqGunQR9ZG9Xx4Afy0Ra71OXF+vvv2
   4bqJr5wHmEEk8jY49UhHnfqPxxhIrNK3bt9jd35UZJTjxwbe1PGkRL7qH
   w==;
X-CSE-ConnectionGUID: QESr2VnAQT2pZQqQ0fSjlQ==
X-CSE-MsgGUID: 9oEqC8NnT46l2yzWFhLjSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564656"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564656"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:02 -0700
X-CSE-ConnectionGUID: AZ5I2h3vTvO7+55aKkm1bw==
X-CSE-MsgGUID: zWCtVkeqRr+hfWQlcxm+wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106257"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:01 -0700
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
Subject: [PATCH 07/21] KVM: TDX: Add load_mmu_pgd method for TDX
Date: Tue,  3 Sep 2024 20:07:37 -0700
Message-Id: <20240904030751.117579-8-rick.p.edgecombe@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX uses two EPT pointers, one for the private half of the GPA space and
one for the shared half. The private half uses the normal EPT_POINTER vmcs
field, which is managed in a special way by the TDX module. For TDX, KVM is
not allowed to operate on it directly. The shared half uses a new
SHARED_EPT_POINTER field and will be managed by the conventional MMU
management operations that operate directly on the EPT root. This means for
TDX the .load_mmu_pgd() operation will need to know to use the
SHARED_EPT_POINTER field instead of the normal one. Add a new wrapper in
x86 ops for load_mmu_pgd() that either directs the write to the existing
vmx implementation or a TDX one.

tdx_load_mmu_pgd() is so much simpler than vmx_load_mmu_pgd() since for the
TDX mode of operation, EPT will always be used and KVM does not need to be
involved in virtualization of CR3 behavior. So tdx_load_mmu_pgd() can
simply write to SHARED_EPT_POINTER.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX MMU part 2 v1:
- update the commit msg with the version rephrased by Rick.
  https://lore.kernel.org/all/78b1024ec3f5868e228baf797c6be98c5397bd49.camel@intel.com/

v19:
- Add WARN_ON_ONCE() to tdx_load_mmu_pgd() and drop unconditional mask
---
 arch/x86/include/asm/vmx.h |  1 +
 arch/x86/kvm/vmx/main.c    | 13 ++++++++++++-
 arch/x86/kvm/vmx/tdx.c     |  5 +++++
 arch/x86/kvm/vmx/x86_ops.h |  4 ++++
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index d77a31039f24..3e003183a4f7 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -237,6 +237,7 @@ enum vmcs_field {
 	TSC_MULTIPLIER_HIGH             = 0x00002033,
 	TERTIARY_VM_EXEC_CONTROL	= 0x00002034,
 	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
+	SHARED_EPT_POINTER		= 0x0000203C,
 	PID_POINTER_TABLE		= 0x00002042,
 	PID_POINTER_TABLE_HIGH		= 0x00002043,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d63685ea95ce..c9dfa3aa866c 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -100,6 +100,17 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx_vcpu_reset(vcpu, init_event);
 }
 
+static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
+			int pgd_level)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
+		return;
+	}
+
+	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -229,7 +240,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.write_tsc_offset = vmx_write_tsc_offset,
 	.write_tsc_multiplier = vmx_write_tsc_multiplier,
 
-	.load_mmu_pgd = vmx_load_mmu_pgd,
+	.load_mmu_pgd = vt_load_mmu_pgd,
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2ef95c84ee5b..8f43977ef4c6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -428,6 +428,11 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 */
 }
 
+void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
+{
+	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index debc6877729a..dcf2b36efbb9 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -130,6 +130,8 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
+
+void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
@@ -142,6 +144,8 @@ static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
+
+static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.34.1


