Return-Path: <kvm+bounces-33270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC5839E88ED
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 02:11:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B3B21658B9
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 01:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7756A15CD42;
	Mon,  9 Dec 2024 01:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LjMHMbQi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C56156991;
	Mon,  9 Dec 2024 01:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733706375; cv=none; b=DoXfWof/YbEyP+7Cl1We9i6XWygI2Oc7Vgp9TT1D4naTgbBxtuTp3zzvepoNweaHcEQKvK9Q9RxfeU6+fYvrifCSIZZdgxI+LjLYNvC7EdXEdXDNGz0sgLo1Y+ADno7Y0XhZ72oUtsEmQy71gquT3H9qAUJTPWR0Rl+3SYY93P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733706375; c=relaxed/simple;
	bh=m/w0JApcq5EEWNqflmSyzjBHGVbFC+llGIy3taAB2PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6byxkI/oGzRa2WcPt1mfpB6r7Fytq/mDaLcw5yEyv5zX9CrZlHjV/9ntcDsHXdoshJuZrjV3esWTYkHxFeleSKsbuQkiIrIksBUXeutpK1Ikgf4SGrNB0AtVfrnE9r5iPKW5Pc5LmTOKtSbOgqaO03LHR4qoVOP6ZnBHXaJLd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LjMHMbQi; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733706374; x=1765242374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m/w0JApcq5EEWNqflmSyzjBHGVbFC+llGIy3taAB2PI=;
  b=LjMHMbQikj7hzzCD8UCErY+pnpTP1Tv1uOzGdO5AymKK4lvJ8d5sArer
   J0j4XobvJ6kSfJFYoD5/9f+Ybpj10UFZxPJPN/Y/pW2svgW+ZS+4CdR0L
   Yc0OjQFricw+7hugTRpgZR46K7uKZqozB4lwoVzkqv/v/ZBosXadys8rm
   96S69d9wsBQGhq6Y7T1wKD0rbumdTEQgjEcRCvQm0V50jwnVsPunitrC1
   gMK0Yx3WWFHxo1e7YuI62zqcaQnRm9grTD/EIug+TFqWMb4s8fcxZe5fU
   sK7eRwdngK8a2mRLZhIW4oy4/h1wJr/L+pQBQG1nygk1WjUUxsTgYnmyh
   Q==;
X-CSE-ConnectionGUID: L1+m8VoiTy6sOysM75DPbw==
X-CSE-MsgGUID: /1SjBbTDSaCuUo83p6ErSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="36833723"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="36833723"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:06:14 -0800
X-CSE-ConnectionGUID: 6yr84rY1TpGYM03NqA6TQg==
X-CSE-MsgGUID: Uuz3TbaKTP+8sH9LB1u/Lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="95402515"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:06:10 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 11/16] KVM: TDX: Always block INIT/SIPI
Date: Mon,  9 Dec 2024 09:07:25 +0800
Message-ID: <20241209010734.3543481-12-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
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
TDX interrupts breakout:
- Renamed from "KVM: TDX: Silently ignore INIT/SIPI" to
  "KVM: TDX: Always block INIT/SIPI".
- Remove KVM_BUG_ON() in tdx_vcpu_reset(). (Rick)
- Drop tdx_vcpu_reset() and move the comment to vt_vcpu_reset().
- Remove unnecessary interface and helpers to delivery INIT/SIPI
  because INIT/SIPI events are always blocked for TDX. (Binbin)
- Update changelog.
---
 arch/x86/kvm/lapic.c    |  2 +-
 arch/x86/kvm/vmx/main.c | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 474e0a7c1069..f93c382344ee 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3365,7 +3365,7 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 
 	if (test_and_clear_bit(KVM_APIC_INIT, &apic->pending_events)) {
 		kvm_vcpu_reset(vcpu, true);
-		if (kvm_vcpu_is_bsp(apic->vcpu))
+		if (kvm_vcpu_is_bsp(vcpu))
 			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		else
 			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 8ec96646faec..7f933f821188 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -115,6 +115,11 @@ static void vt_vcpu_free(struct kvm_vcpu *vcpu)
 
 static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
+	/*
+	 * TDX has its own sequence to do init during TD build time (by
+	 * KVM_TDX_INIT_VCPU) and it doesn't support INIT event during TD
+	 * runtime.
+	 */
 	if (is_td_vcpu(vcpu))
 		return;
 
@@ -211,6 +216,18 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
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
@@ -565,7 +582,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 #endif
 
 	.check_emulate_instruction = vmx_check_emulate_instruction,
-	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
+	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
 	.msr_filter_changed = vmx_msr_filter_changed,
-- 
2.46.0


