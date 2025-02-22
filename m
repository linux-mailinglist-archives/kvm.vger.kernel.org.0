Return-Path: <kvm+bounces-38947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F84EA404F1
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:49:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6994E16969A
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDFAE204F92;
	Sat, 22 Feb 2025 01:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mh3jFsaB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660F6204696;
	Sat, 22 Feb 2025 01:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188815; cv=none; b=d4ny4Lik/mA3KHyTE9r7lOoMmrMAIQgQ5i03bcZU35wKFiFhaFUdXQ5NnGyb5lVhE+x5yEArjapLZVxEbylHLjkT/FHU5jdm2nUf6vyqTin2bfjSJ28dZBt+ts7pu4BB60Q/LIrsQmErXKyD7tHF4gE8bj5k9QPOHcNbq39z5KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188815; c=relaxed/simple;
	bh=MmargvCnsJPFH/AVwlQDxzF9ATtiRiCe/XH16TCG2Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ervqKqRQXy1KeGvSd9V2c4lxVlciUvnh36jQ7J4pohnLuuaoEmJ+AmY/kE1s2FBLy+Vn9r+qC9j0GyrSbiXM1fBpp1IuvtzANOd1dh1f1Jv3sV6bGc/R8MplteGY2ubqEj2YLkm5g5HWcfQkSEPNh+2wb9kF5DrWbjVBj+g2uoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mh3jFsaB; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188813; x=1771724813;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MmargvCnsJPFH/AVwlQDxzF9ATtiRiCe/XH16TCG2Sg=;
  b=mh3jFsaBmpMmWbs/TgzOt7Ylpxc5SEaq4aX1F4qB3ZzuzmRDbJosFvBa
   NQY7R46RrWiR5KQTSNZ6fCKvfGkg1NzjvhuWB+vzELKT7y6KB9nWcy+IU
   mMeOoY/3IDOM1bsdOv2mM37VgjeBcbEBBflRPKeyH6O1eio0yOWYbTcud
   brdIiNumtf3KHzS5DLUy7uAIzmB2kjebyQyOeYvCVuomHMQ8aMYfbCLda
   zZa843W2aL08/BVY1ssLNDneNCbK7bd+YX85GfreD/cdTmfwGKApAQHMr
   B5B0P9zniGleqLZOs8gN7e1jQoLESMNq10p0g+9LGyfUlJi7xqD97FTgj
   Q==;
X-CSE-ConnectionGUID: aulcHAJpQjaTSGabPcmCmw==
X-CSE-MsgGUID: 3w7O0Jo4QWi5Dw96a0KiuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="52449052"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="52449052"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:53 -0800
X-CSE-ConnectionGUID: 3pePhVbnRWOCEoIDdsb4Ug==
X-CSE-MsgGUID: E9Q0+NOVRC2oRY4xPpgMtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="120621692"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:50 -0800
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
Subject: [PATCH v3 09/16] KVM: TDX: Always block INIT/SIPI
Date: Sat, 22 Feb 2025 09:47:50 +0800
Message-ID: <20250222014757.897978-10-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014757.897978-1-binbin.wu@linux.intel.com>
References: <20250222014757.897978-1-binbin.wu@linux.intel.com>
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
TDX interrupts v3:
- No change.

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
index 0af357a992af..6a066b7fb3dc 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -118,8 +118,10 @@ static void vt_vcpu_free(struct kvm_vcpu *vcpu)
 
 static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
-	if (is_td_vcpu(vcpu))
+	if (is_td_vcpu(vcpu)) {
+		tdx_vcpu_reset(vcpu, init_event);
 		return;
+	}
 
 	vmx_vcpu_reset(vcpu, init_event);
 }
@@ -226,6 +228,18 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
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
@@ -591,7 +605,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 #endif
 
 	.check_emulate_instruction = vmx_check_emulate_instruction,
-	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
+	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
 	.msr_filter_changed = vmx_msr_filter_changed,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c6cd10d8791e..d52bfe39163a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2641,6 +2641,19 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
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
index 76374557b18e..de158098ff9b 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -130,6 +130,7 @@ void tdx_vm_free(struct kvm *kvm);
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
@@ -170,6 +171,7 @@ static inline void tdx_vm_free(struct kvm *kvm) {}
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
+static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
 static inline int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
-- 
2.46.0


