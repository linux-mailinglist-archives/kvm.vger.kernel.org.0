Return-Path: <kvm+bounces-36837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 640C8A21AA8
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 11:03:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3FD93A71D5
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 10:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9776E1DE4CB;
	Wed, 29 Jan 2025 10:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="APIEcomw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D2B1B425D;
	Wed, 29 Jan 2025 10:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738144830; cv=none; b=BQ9n6OKTQx0JFM5ez+5VIvwcdOq7GcF+Id/o2Is1HiDyTclJ31duLlKhfZXSx4wxfTs27rnMx4wE7umxXB4s9BcDbtaqwvGcz1ZbquqLs3PzgK6ZTegXJ/jwbiOxUo7Xhd/jIHS2BAX/GlM1lnFmkLTXCYyk12k/aKIZYDtGpGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738144830; c=relaxed/simple;
	bh=O5+GagowUx55L99n/4Spax+D/MajyZfzqN8aWUlzMGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qhexn3B8WD2IZCjkS5waOTKAnXByuL2LrS8s0C7q3nirxqOV5SFPxEUtJqT2gnbJ4sVBkH1+WonKUqhk8DzJRHayP03FkGS4UXXKB48ynzLCnqoSIKk9TyUj3ZWIwZdf3aX/VwztjTnvSIZeRo/sj0KHYClp1pJQYRiUZLQr0Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=APIEcomw; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738144829; x=1769680829;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O5+GagowUx55L99n/4Spax+D/MajyZfzqN8aWUlzMGk=;
  b=APIEcomwLEm1XD76GrS30ep5x7SWT0Rnp06fVq9rqTdNvDxNe6QVR2fl
   IS5D65F0lJ6t5zgwXFR/lyVfcIPnInPHJk/g7Z1GBOkaTfWXpwJn0xp8z
   iGFK/CtAWzHmT6oRldvr4btMXx3JMl3/LAC1OxCStf3yD6IeCWGnvV3h4
   S+vv/FVQxLUtGpJTQPAjIp02hJCKLdQ08Zbvef06/aVVolBByb+frJqJW
   5emalOypa9gTb0F20Rx6vt8COsv47fJ1Bm1B36qUfL2Pc361keOoSVyBk
   aXyGVY3SOk9iJy/TwNbs8zihAUjFWJGm9MW9Asm0iRAfJ6+HOSRV6pYuU
   w==;
X-CSE-ConnectionGUID: GZu+ynKbSHWf6FmhmiojlQ==
X-CSE-MsgGUID: V72bPBGCTyiP9nTU1G4/Ag==
X-IronPort-AV: E=McAfee;i="6700,10204,11329"; a="50036081"
X-IronPort-AV: E=Sophos;i="6.13,243,1732608000"; 
   d="scan'208";a="50036081"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 02:00:13 -0800
X-CSE-ConnectionGUID: yeNmvhxYR3WFa/TbfQoPLA==
X-CSE-MsgGUID: xpVOc81CT1iA2H0czh5mzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="132262810"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.0.178])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 02:00:08 -0800
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
Subject: [PATCH V2 11/12] KVM: TDX: Save and restore IA32_DEBUGCTL
Date: Wed, 29 Jan 2025 11:59:00 +0200
Message-ID: <20250129095902.16391-12-adrian.hunter@intel.com>
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

Save the IA32_DEBUGCTL MSR before entering a TDX VCPU and restore it
afterwards.  The TDX Module preserves bits 1, 12, and 14, so if no
other bits are set, no restore is done.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
TD vcpu enter/exit v2:
 - New patch
 - Rebased due to moving host_debugctlmsr to struct vcpu_vt.
---
 arch/x86/kvm/vmx/tdx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 70996af4be64..0bce00415f42 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -705,6 +705,8 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	else
 		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
 
+	vt->host_debugctlmsr = get_debugctlmsr();
+
 	vt->guest_state_loaded = true;
 }
 
@@ -818,9 +820,14 @@ static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 #define TDX_REGS_UNSUPPORTED_SET	(BIT(VCPU_EXREG_RFLAGS) |	\
 					 BIT(VCPU_EXREG_SEGMENTS))
 
+#define TDX_DEBUGCTL_PRESERVED (DEBUGCTLMSR_BTF | \
+				DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI | \
+				DEBUGCTLMSR_FREEZE_IN_SMM)
+
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct vcpu_vt *vt = to_vt(vcpu);
 
 	/*
 	 * force_immediate_exit requires vCPU entering for events injection with
@@ -846,6 +853,9 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 
 	tdx_vcpu_enter_exit(vcpu);
 
+	if (vt->host_debugctlmsr & ~TDX_DEBUGCTL_PRESERVED)
+		update_debugctlmsr(vt->host_debugctlmsr);
+
 	tdx_user_return_msr_update_cache();
 
 	kvm_load_host_xsave_state(vcpu);
-- 
2.43.0


