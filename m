Return-Path: <kvm+bounces-9745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A55EB866DAB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:08:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46FFC1F21EEF
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2DDF12F59D;
	Mon, 26 Feb 2024 08:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=intel.com header.i=@intel.com header.b="emdlqhXg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C157912CDB7;
	Mon, 26 Feb 2024 08:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936158; cv=none; b=YzpKMa1qrlAago7RAXJP7/UyIj637MoAJmUoyg0u5rgLZBDuNtKpBdfPGAEdc5IPC6BcVlnvWs8IdqJVEvLzIsiFTrkszD280jC51V6A0q+5Xr/gMYOOQgjzqVRSpi3f8b7epE0bwg/AVfKVSj7wrOuA93PLvU7snLc1YBvIxao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936158; c=relaxed/simple;
	bh=CFO7sbhVxx28cd10/6BY0pfLdF4OfRuPbI0qHxYmeIY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FPO6oTKHlOWkCVrFewAXYylPRl14z7FT+QXl83HXvhEcUk85daDBWAeqlFcu3OB8d7BURIYaVKiTiaFcNjxYlIY8u/VvpGWjo+ZcXKmUIEJH65PA1Led1F82O1TL9a/9BpGv85t39h4RO6WA9fryrb7m15ECI4qEo0I/rDaJ060=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=emdlqhXg; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936155; x=1740472155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CFO7sbhVxx28cd10/6BY0pfLdF4OfRuPbI0qHxYmeIY=;
  b=emdlqhXgkPffBQ+eavdxnX3TwtCPwRWdfTGljCK7jLsIjyTGaxZRame8
   Ss89Vc4Oc5z1meMeKXlhMTIXFqhnJjJihdesEX+VQ5W0AJjgGSPTgn8no
   wF89RdZZJxAIo3zPFOwt+llM1yn/JdImlhPYYkRVqwoq7WSKUH4DrdvaO
   kO4NY+2JeT2mOvEIhSm/zCXPVHzcflrhJD/we4lQtzHtQBbKy7b1TtyiY
   z9fTeNWHHC1K0i5HCOeWTdnoecxmdCXJp1MfGyBf2kBgviwRF2hG50gwk
   fhmyAVc9VLnBy7BNY31ocTT1hSKMeQc/P3WpO+xpUJn0AMw7jg0s7YrWy
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751383"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751383"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735113"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:09 -0800
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
	tina.zhang@intel.com
Subject: [PATCH v19 119/130] KVM: TDX: Add methods to ignore guest instruction emulation
Date: Mon, 26 Feb 2024 00:27:01 -0800
Message-Id: <a70ca20449acd995100a52f2a1076a5197cc45da.1708933498.git.isaku.yamahata@intel.com>
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

Because TDX protects TDX guest state from VMM, instructions in guest memory
cannot be emulated.  Implement methods to ignore guest instruction
emulator.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 9fb3f28d8259..9aaa9bd7abf3 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -320,6 +320,30 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
 }
 #endif
 
+static int vt_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+					void *insn, int insn_len)
+{
+	if (is_td_vcpu(vcpu))
+		return X86EMUL_RETRY_INSTR;
+
+	return vmx_check_emulate_instruction(vcpu, emul_type, insn, insn_len);
+}
+
+static int vt_check_intercept(struct kvm_vcpu *vcpu,
+				 struct x86_instruction_info *info,
+				 enum x86_intercept_stage stage,
+				 struct x86_exception *exception)
+{
+	/*
+	 * This call back is triggered by the x86 instruction emulator. TDX
+	 * doesn't allow guest memory inspection.
+	 */
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return X86EMUL_UNHANDLEABLE;
+
+	return vmx_check_intercept(vcpu, info, stage, exception);
+}
+
 static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -976,7 +1000,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.load_mmu_pgd = vt_load_mmu_pgd,
 
-	.check_intercept = vmx_check_intercept,
+	.check_intercept = vt_check_intercept,
 	.handle_exit_irqoff = vt_handle_exit_irqoff,
 
 	.request_immediate_exit = vt_request_immediate_exit,
@@ -1005,7 +1029,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.enable_smi_window = vt_enable_smi_window,
 #endif
 
-	.check_emulate_instruction = vmx_check_emulate_instruction,
+	.check_emulate_instruction = vt_check_emulate_instruction,
 	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
-- 
2.25.1


