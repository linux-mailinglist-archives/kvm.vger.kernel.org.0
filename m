Return-Path: <kvm+bounces-36838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 923FBA21AAA
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 11:03:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65CEE3A7C61
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 10:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 437201DE8AC;
	Wed, 29 Jan 2025 10:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y/Au/CFd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C2D1B6D17;
	Wed, 29 Jan 2025 10:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738144837; cv=none; b=Ha3hDsmy8KiMRzFJJuAaA0LqiU3lZ0oRse6Aa8F2oTjKg0kCsSkt34vv8oG7atGHFyX3nO2TQcrAWEFKw4YFLPXi4lsWD/k5LXhKvaXOYV09gMAUoC6g1c1Wc0bcSbn1Mi40X/7PFTcC8WEAV8/q6dVKPgN02EYUwmiRqybLoGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738144837; c=relaxed/simple;
	bh=+ixnKposbO4ed0uhOHW1IAo8kancv+oQmaa2H5HjQGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGDd7MxWqvzLKkii1Z6y3FyI2hmRQxWbSooWK3Ggetz5VMWN/dno+XM4sOQLbTA1cTTMQOk+qzlmqVHZ/hfrjP8L3NxM0H6ouGDBXBTysn/F62s8cWPb3tUNbwNcxZ2S54NDU0+oCaTFLpqCrssqn99VhaAlIX2x61CeGQnKTNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y/Au/CFd; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738144835; x=1769680835;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+ixnKposbO4ed0uhOHW1IAo8kancv+oQmaa2H5HjQGA=;
  b=Y/Au/CFdME8YRNSoP5V6m+YtHP7H8FuWjN0hXbT/b21u7z9kFi8Ucq1C
   uFBGf8anLzk3xHaayFQQSmg8l2UHM7LHOEMpIs0l6bvONeWVUP0wpt3eo
   gjd98V/ByPTDVMInZicI8Y0Gb/8hicpgAXJxc1uJT+E29hLdkrAKcQwU/
   aCvLfnd/OD+Lk++G7gZWp+UL3/bQGK/CMogQcid84rGlZv5iMpGKEhRzn
   X38zAMy8RSVbA3LjOEF5j7lT29yonDDQ9PCdC8iMSsHomHlB5Yg/VGiVa
   soYU1nEwSiTLPlCq8oRC56uvhYOfJyZS3ZVwAgpjhNADu5RasHVsuzjr7
   Q==;
X-CSE-ConnectionGUID: wy2I2Mi7QSKK2Xpsn1mUlA==
X-CSE-MsgGUID: 6T6AnkivQZ2a+2pkDICHEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11329"; a="50036092"
X-IronPort-AV: E=Sophos;i="6.13,243,1732608000"; 
   d="scan'208";a="50036092"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 02:00:17 -0800
X-CSE-ConnectionGUID: yYp5K29FQX6iXmhz1ubfrg==
X-CSE-MsgGUID: zl9NGE3ZRuGCW9VRVWe/Ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="132262821"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.0.178])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 02:00:13 -0800
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH V2 12/12] KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched behavior
Date: Wed, 29 Jan 2025 11:59:01 +0200
Message-ID: <20250129095902.16391-13-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250129095902.16391-1-adrian.hunter@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a flag KVM_DEBUGREG_AUTO_SWITCH to skip saving/restoring guest
DRs.

TDX-SEAM unconditionally saves/restores guest DRs on TD exit/enter,
and resets DRs to architectural INIT state on TD exit.  Use the new
flag KVM_DEBUGREG_AUTO_SWITCH to indicate that KVM doesn't need to
save/restore guest DRs.  KVM still needs to restore host DRs after TD
exit if there are active breakpoints in the host, which is covered by
the existing code.

MOV-DR exiting is always cleared for TDX guests, so the handler for DR
access is never called, and KVM_DEBUGREG_WONT_EXIT is never set.  Add
a warning if both KVM_DEBUGREG_WONT_EXIT and KVM_DEBUGREG_AUTO_SWITCH
are set.

Opportunistically convert the KVM_DEBUGREG_* definitions to use BIT().

Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[binbin: rework changelog]
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Message-ID: <20241210004946.3718496-2-binbin.wu@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
TD vcpu enter/exit v2:
- Moved from TDX "the rest" to "TD vcpu enter/exit"

TDX "the rest" v1:
- Update the comment about KVM_DEBUGREG_AUTO_SWITCH.
- Check explicitly KVM_DEBUGREG_AUTO_SWITCH is not set in switch_db_regs
  before restoring guest DRs, because KVM_DEBUGREG_BP_ENABLED could be set
  by userspace. (Paolo)
  https://lore.kernel.org/lkml/ea136ac6-53cf-cdc5-a741-acfb437819b1@redhat.com/
- Fix the issue that host DRs are not restored in v19 (Binbin)
  https://lore.kernel.org/kvm/20240413002026.GP3039520@ls.amr.corp.intel.com/
- Update the changelog a bit.
---
 arch/x86/include/asm/kvm_host.h | 11 +++++++++--
 arch/x86/kvm/vmx/tdx.c          |  1 +
 arch/x86/kvm/x86.c              |  4 +++-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e557a441fade..bcfd89c28308 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -606,8 +606,15 @@ struct kvm_pmu {
 struct kvm_pmu_ops;
 
 enum {
-	KVM_DEBUGREG_BP_ENABLED = 1,
-	KVM_DEBUGREG_WONT_EXIT = 2,
+	KVM_DEBUGREG_BP_ENABLED		= BIT(0),
+	KVM_DEBUGREG_WONT_EXIT		= BIT(1),
+	/*
+	 * Guest debug registers (DR0-3, DR6 and DR7) are saved/restored by
+	 * hardware on exit from or enter to guest. KVM needn't switch them.
+	 * DR0-3, DR6 and DR7 are set to their architectural INIT value on VM
+	 * exit, host values need to be restored.
+	 */
+	KVM_DEBUGREG_AUTO_SWITCH	= BIT(2),
 };
 
 struct kvm_mtrr {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0bce00415f42..0863bdaf761a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -652,6 +652,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
 
+	vcpu->arch.switch_db_regs = KVM_DEBUGREG_AUTO_SWITCH;
 	vcpu->arch.cr0_guest_owned_bits = -1ul;
 	vcpu->arch.cr4_guest_owned_bits = -1ul;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15447fe7687c..b023283e7ed4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10977,7 +10977,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_fpu.xfd_err)
 		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 
-	if (unlikely(vcpu->arch.switch_db_regs)) {
+	if (unlikely(vcpu->arch.switch_db_regs &&
+		     !(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))) {
 		set_debugreg(0, 7);
 		set_debugreg(vcpu->arch.eff_db[0], 0);
 		set_debugreg(vcpu->arch.eff_db[1], 1);
@@ -11024,6 +11025,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
 		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
+		WARN_ON(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH);
 		kvm_x86_call(sync_dirty_debug_regs)(vcpu);
 		kvm_update_dr0123(vcpu);
 		kvm_update_dr7(vcpu);
-- 
2.43.0


