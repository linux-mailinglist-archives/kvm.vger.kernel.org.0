Return-Path: <kvm+bounces-37797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1DE3A301E2
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:59:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A19EB3ABAEA
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 136CF1D6195;
	Tue, 11 Feb 2025 02:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nn6rnO2F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728D21E9B01;
	Tue, 11 Feb 2025 02:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242647; cv=none; b=ZWSaQysDvElOIwX8AjRjz7l14CXSOie5PnMBQeaRBcEClAcU/aYp2iifdlAFrMzosTAb9WDhs6/H8iTnDznc4udFg//1k1SydtuTRGaxQH33QGxOPHsq9DcmbDtSvOYTrDC6Y2cVYIrvepBLeGEZP5J9uyzHgRMFmsZiV31t6to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242647; c=relaxed/simple;
	bh=m5srtxiUNG0XXeE8Ov3VMui0qMhR3DCCZOXxm+6ZHYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGUJxN1U+0Rq+ystoFaZIuRdC7LBWRqnPqiyy2QgruecWrYFJsrN5XTzVkwcMQ0bejHNKX1CdqRpy1GPttMtMCJlaUWENZz16Tcy0Jhj1cO8NLnpYHOHN1b17LTGVd8yp1EIoCwGGsfhbshEA7NTw3ZRQHECR9Iz/Hxve7ddwIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nn6rnO2F; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242646; x=1770778646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m5srtxiUNG0XXeE8Ov3VMui0qMhR3DCCZOXxm+6ZHYw=;
  b=nn6rnO2FfU75+0+gt4iOWfxfEPIfWonOJkNpv/Bqp66Y02g3guYIT2Bv
   AXE7dQr78MHfQkbRWJ46uSGCG8gvbjWyh+sQePt9cjY3bWr+0uparRUuF
   Hwn1C5tRkr0OmOO2Kxj8XRnkaAyR4N+PjEawnXQDBoO/cuYu8rZYYDZV0
   Cf0dvAnhg8G4rs9eh5esO0qrlwnIpbgbNaAScVuZiV23ud5THFFpphV6N
   B6+arxmHVZ5UAkVEtecGP5ejyQZmXIke3VuBERbX2bcBXDPL4L8ggvKqW
   CJ+VtVx9LaforaDP+1/r3GSq35ts2Qf4LCvlXFCrQ9XpAKj6NN/W/O25x
   g==;
X-CSE-ConnectionGUID: 4/8GWKfTR/uu2V/LfMWu1Q==
X-CSE-MsgGUID: 753r3/RhRvugSeDUrN0yKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43612474"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43612474"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:26 -0800
X-CSE-ConnectionGUID: lWdnTKb2TEa0ls8I4FCX4A==
X-CSE-MsgGUID: dlCQ12xwT72rBc5OZk+4nQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112355355"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:21 -0800
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
Subject: [PATCH v2 10/17] KVM: TDX: Always block INIT/SIPI
Date: Tue, 11 Feb 2025 10:58:21 +0800
Message-ID: <20250211025828.3072076-11-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Always block INIT and SIPI events for the TDX guest because the TDX module
doesn't provide API for VMM to inject INIT IPI or SIPI.

TDX defines its own vCPU creation and initialization sequence including
multiple seamcalls.  Also, it's only allowed during TD build time.

Given that TDX guest is para-virtualized to boot BSP/APs, normally there
shouldn't be any INIT/SIPI event for TDX guest.  If any, three options to
handle them:
1. Always block INIT/SIPI request.
2. (Silently) ignore INIT/SIPI request during delivery.
3. Return error to guest TDs somehow.

Choose option 1 for simplicity. Since INIT and SIPI are always blocked,
INIT handling and the OP vcpu_deliver_sipi_vector() won't be called, no
need to add new interface or helper function for INIT/SIPI delivery.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts v2:
- WARN on init event. (Sean)
- Improve comments about vcpu reset for TDX. (Xiaoyao, Sean)

TDX interrupts v1:
- Renamed from "KVM: TDX: Silently ignore INIT/SIPI" to
  "KVM: TDX: Always block INIT/SIPI".
- Remove KVM_BUG_ON() in tdx_vcpu_reset(). (Rick)
- Drop tdx_vcpu_reset() and move the comment to vt_vcpu_reset().
- Remove unnecessary interface and helpers to delivery INIT/SIPI
  because INIT/SIPI events are always blocked for TDX. (Binbin)
- Update changelog.
---
 arch/x86/kvm/vmx/main.c    | 18 ++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 13 +++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 8d91bd8eb991..1ff4903a1853 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -119,8 +119,10 @@ static void vt_vcpu_free(struct kvm_vcpu *vcpu)
 
 static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
-	if (is_td_vcpu(vcpu))
+	if (is_td_vcpu(vcpu)) {
+		tdx_vcpu_reset(vcpu, init_event);
 		return;
+	}
 
 	vmx_vcpu_reset(vcpu, init_event);
 }
@@ -215,6 +217,18 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
 }
 #endif
 
+static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * INIT and SIPI are always blocked for TDX, i.e., INIT handling and
+	 * the OP vcpu_deliver_sipi_vector() won't be called.
+	 */
+	if (is_td_vcpu(vcpu))
+		return true;
+
+	return vmx_apic_init_signal_blocked(vcpu);
+}
+
 static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
@@ -581,7 +595,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 #endif
 
 	.check_emulate_instruction = vmx_check_emulate_instruction,
-	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
+	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
 	.msr_filter_changed = vmx_msr_filter_changed,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 9737574b8049..bd349e3d4089 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2642,6 +2642,19 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 	return 0;
 }
 
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+	/*
+	 * Yell on INIT, as TDX doesn't support INIT, i.e. KVM should drop all
+	 * INIT events.
+	 *
+	 * Defer initializing vCPU for RESET state until KVM_TDX_INIT_VCPU, as
+	 * userspace needs to define the vCPU model before KVM can initialize
+	 * vCPU state, e.g. to enable x2APIC.
+	 */
+	WARN_ON_ONCE(init_event);
+}
+
 struct tdx_gmem_post_populate_arg {
 	struct kvm_vcpu *vcpu;
 	__u32 flags;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 91988a715d75..eb6a841f4842 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -129,6 +129,7 @@ void tdx_vm_free(struct kvm *kvm);
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
@@ -169,6 +170,7 @@ static inline void tdx_vm_free(struct kvm *kvm) {}
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
+static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
 static inline int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
-- 
2.46.0


