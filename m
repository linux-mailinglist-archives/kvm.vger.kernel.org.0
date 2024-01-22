Return-Path: <kvm+bounces-6683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86121837873
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:19:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B99111C26921
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 709207FBCA;
	Mon, 22 Jan 2024 23:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WMtblFXD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C495A7E783;
	Mon, 22 Jan 2024 23:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967772; cv=none; b=CR2Sf75HkPkhh5I8VFzBe7mHp8jCyRXmh8irpqJ5UMwX22Yu4R7xYslSyPtm+fyWYnZmYR8MWBUzAYmXy9i+u9M5wOZBj5F3V9wXswu1Y/BXRFfR4VB+tFgw/0fIS7dAl5odxmxHbrwCTo8Nm5yCyjb3CuVKNg5tr5HX8AMbiFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967772; c=relaxed/simple;
	bh=fWkG+QnbDV5OyHOrKYrSw9rXQ9AWwBja2tgCFwvWsXs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kX7gYwbAawW4Iw2tWgnee2ix3tZU/waLrlaf0IzRZrb1nDsHR0fHuqx2StfiQJyqsGrakGLnf9Q2h6NQ0BZNoDqhHaecHAYcTgg95FeK2pczSO/lfBMdsu3vVwFAK4ct4vE8T1mpk6abM/ecc51IZamExs81c0C+T7Z5nBSd9u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WMtblFXD; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967770; x=1737503770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fWkG+QnbDV5OyHOrKYrSw9rXQ9AWwBja2tgCFwvWsXs=;
  b=WMtblFXDu28kZEZxZg1whk5O1amcW58/5UBqI34VyzyUeGH0ubtRfPCW
   /8TEiL7JH8xdTbYTrqtTMoxbfS7Rnr1yGO2epkVmjLsARmXuh5KjO0uB7
   3pGTVCDdQzigvnmY95yhCJCRi9hV0gIbMJs8gsAcnUFEQmxlvgYTfaD8y
   Bgm8mpjRaYxXYpJQKl5YmqVFKYgzloetnb4wbC/yo5rS/8aFwkdhmB43r
   f+b1HX7QOczKA5KwDef6WY3CHaG6/VcCMAApRfSYC/WyhV/EoXaSrR1SF
   Ai38Poq8JR/ja5uKRDC5bMRoSaWHQzzrzIlkktj27bJolybHBgPiK8dVq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217917"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217917"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27818011"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:55 -0800
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
Subject: [PATCH v18 108/121] KVM: TDX: Add methods to ignore guest instruction emulation
Date: Mon, 22 Jan 2024 15:54:24 -0800
Message-Id: <a05c85cf4bb9c75becb1ef0606823f540570e205.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
index 335b94301e2a..420c68330e61 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -335,6 +335,30 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
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
@@ -958,7 +982,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.load_mmu_pgd = vt_load_mmu_pgd,
 
-	.check_intercept = vmx_check_intercept,
+	.check_intercept = vt_check_intercept,
 	.handle_exit_irqoff = vt_handle_exit_irqoff,
 
 	.request_immediate_exit = vt_request_immediate_exit,
@@ -987,7 +1011,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.enable_smi_window = vt_enable_smi_window,
 #endif
 
-	.check_emulate_instruction = vmx_check_emulate_instruction,
+	.check_emulate_instruction = vt_check_emulate_instruction,
 	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
-- 
2.25.1


