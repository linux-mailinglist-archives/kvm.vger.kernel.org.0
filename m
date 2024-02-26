Return-Path: <kvm+bounces-9713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4948866D4D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:57:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 218081C22C6A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42B7A1F93E;
	Mon, 26 Feb 2024 08:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NXSAlv6D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE2F79DC5;
	Mon, 26 Feb 2024 08:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936131; cv=none; b=Z8xDLjFDHPoEw1J5kRN9bVeTEwCVXVb56nnhyD7T6MmNs+kksG9morNuppZMOV8iE6/UIWUJCUeGQFWF42C0DGq51Jr33pJDnXJq7vAZVTo0W0O3sh+A0J1wQqHEmhIto934eJY8aHmYRBJIjcSEqu38/iCPdDzCYFWYbRZvlyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936131; c=relaxed/simple;
	bh=J0itU+rEBhLn1btxTLuPmm/pBpAavEDlMWDiVUOlSCE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JibRA242OrgtHxf7sT3HalNi3tS40mo75KTKI8ck2LJi35/2I6VREDnbTPAMt2AZwMJwZuaqdYSEgMySUjhPKuW8cr1wX+ajqIQNbJjjYrvO/pKQqERDOSWLUXpDbf+U4HS8r3YPooGl7oeZrFbXvx+/giFRAW6RvzPP3JKIjK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NXSAlv6D; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936128; x=1740472128;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J0itU+rEBhLn1btxTLuPmm/pBpAavEDlMWDiVUOlSCE=;
  b=NXSAlv6DARUWxW2f0ft9fb1YF+e+xn27cXeE3NTNSqC1xuLTQ4pUTvd5
   nZkOfQeo23Ltk2uaKVq30MXxhPASkDYJjbZNoce/zArI4CJycnjJgPlDF
   p9mz1LYK4rqRNk68j4gDz9gQ/opsNMTc1xxvlO76EMsgSOAKnYOHXSy1Y
   3AW0Ivx/4YtpGiwRbJ/3Wp1Q+pQAE8hQ+8Pt8EJa9cbLcYSC081Yay8Gt
   GR1aptc0TwMkdgGh89U868d45XuWdMA8nZjD8GuPiErwPZTo7ktaUaBXM
   eO+Rq+copS4v8/ux8a8BcZIgAd4+8hHlGuL9wOn+rht/6Rk65CHhCOde2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069545"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069545"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272626"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:46 -0800
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
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH v19 088/130] KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched behavior
Date: Mon, 26 Feb 2024 00:26:30 -0800
Message-Id: <ca5d0399cdbbaa6c7c6528ad85b3560cec0f0752.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a flag, KVM_DEBUGREG_AUTO_SWITCHED_GUEST, to skip saving/restoring DRs
irrespective of any other flags.  TDX-SEAM unconditionally saves and
restores guest DRs and reset to architectural INIT state on TD exit.
So, KVM needs to save host DRs before TD enter without restoring guest DRs
and restore host DRs after TD exit.

Opportunistically convert the KVM_DEBUGREG_* definitions to use BIT().

Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 10 ++++++++--
 arch/x86/kvm/vmx/tdx.c          |  1 +
 arch/x86/kvm/x86.c              | 11 ++++++++---
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3ab85c3d86ee..a9df898c6fbd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -610,8 +610,14 @@ struct kvm_pmu {
 struct kvm_pmu_ops;
 
 enum {
-	KVM_DEBUGREG_BP_ENABLED = 1,
-	KVM_DEBUGREG_WONT_EXIT = 2,
+	KVM_DEBUGREG_BP_ENABLED		= BIT(0),
+	KVM_DEBUGREG_WONT_EXIT		= BIT(1),
+	/*
+	 * Guest debug registers (DR0-3 and DR6) are saved/restored by hardware
+	 * on exit from or enter to guest. KVM needn't switch them. Because DR7
+	 * is cleared on exit from guest, DR7 need to be saved/restored.
+	 */
+	KVM_DEBUGREG_AUTO_SWITCH	= BIT(2),
 };
 
 struct kvm_mtrr_range {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7aa9188f384d..ab7403a19c5d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -586,6 +586,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
 
+	vcpu->arch.switch_db_regs = KVM_DEBUGREG_AUTO_SWITCH;
 	vcpu->arch.cr0_guest_owned_bits = -1ul;
 	vcpu->arch.cr4_guest_owned_bits = -1ul;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b189e86a1f1..fb7597c22f31 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11013,7 +11013,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_fpu.xfd_err)
 		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 
-	if (unlikely(vcpu->arch.switch_db_regs)) {
+	if (unlikely(vcpu->arch.switch_db_regs & ~KVM_DEBUGREG_AUTO_SWITCH)) {
 		set_debugreg(0, 7);
 		set_debugreg(vcpu->arch.eff_db[0], 0);
 		set_debugreg(vcpu->arch.eff_db[1], 1);
@@ -11059,6 +11059,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
 		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
+		WARN_ON(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH);
 		static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
 		kvm_update_dr0123(vcpu);
 		kvm_update_dr7(vcpu);
@@ -11071,8 +11072,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * care about the messed up debug address registers. But if
 	 * we have some of them active, restore the old state.
 	 */
-	if (hw_breakpoint_active())
-		hw_breakpoint_restore();
+	if (hw_breakpoint_active()) {
+		if (!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))
+			hw_breakpoint_restore();
+		else
+			set_debugreg(__this_cpu_read(cpu_dr7), 7);
+	}
 
 	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
 	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
-- 
2.25.1


