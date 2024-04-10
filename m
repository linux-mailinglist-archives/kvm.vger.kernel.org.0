Return-Path: <kvm+bounces-14128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3DF389FA03
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2FB11C230AC
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70F616F847;
	Wed, 10 Apr 2024 14:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wz4Hjh+e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B00616F270;
	Wed, 10 Apr 2024 14:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712759745; cv=none; b=lrYi71Ci1M9D0pIqHgONxWHL3xvdWzzQqqPQanzO8WPeu8io3qTiAeE5nXkHCBSaMjcYwepJndqzi2E78k0yxSKo3o1SyYkLgjSBWdVba4KvvITNhLLhWVtynyKY8Ml56YhWAJ84+p/HWsSXZVqI518jdvhHQiymFfTLn00MsYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712759745; c=relaxed/simple;
	bh=PyDLrkVKxGhZFcNlQk2wnU+WxUcndE/GUkxjE8uisg8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fNEzB9FyWJxeH4rBbpShYVKpm8RkqU3US9QiJkVZvoWKzR0Z9Tqse2gfzZLzjPshJiqV1M8lQpj+vihuCxCiFojdghpPSTlTXkSnhbWddscxHyeQNr4kKEiDYhaXbUMqK5dyPeL4LqbYc5sa4pj1INTfZWYvfAFEhOYWjbS5Ibo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wz4Hjh+e; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712759744; x=1744295744;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PyDLrkVKxGhZFcNlQk2wnU+WxUcndE/GUkxjE8uisg8=;
  b=Wz4Hjh+ePTFbwuchWof67o7uhxw+phdJJKqJ8ODdty5vs6mCmKH9ZI0C
   j1JVLVg1Nl0za/0Xfu3DwLomFoJkwYpSt/g1GGNoaE3A4BIv4wVr5ROSv
   tg+GpR4rCj5tAKCu+9rHq25OT02VxV3LQsJh26scGRtlfbqfGF4tVeUhy
   KopvZbruwjh8LIKb7YnupXDMjekf3R1etAz7e+VmZOMytbOUrRLiaOW6f
   HUWVnNM2HuMidtIMA6erVZoDqfkB1a5UMVORk1BsHD6zCt85x33rGYcDD
   JgnbK0vOBv9FGpPwHtYIqHiMFiQRrHniC4hAWV42HjPlSUTzoV9kq5lQF
   A==;
X-CSE-ConnectionGUID: bJ2k4buhQbW/j83CHNdFLQ==
X-CSE-MsgGUID: hXNyTvyrTZq2zsXDTv1wtw==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="18837813"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="18837813"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:43 -0700
X-CSE-ConnectionGUID: YnCVHT/lRVW2NGtLqZwYDw==
X-CSE-MsgGUID: d7WsIpY/QWOMw1BeUbZWYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="25095510"
Received: from unknown (HELO spr.sh.intel.com) ([10.239.53.118])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:40 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: daniel.sneddon@linux.intel.com,
	pawan.kumar.gupta@linux.intel.com,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH v3 06/10] KVM: VMX: Cache force_spec_ctrl_value/mask for each vCPU
Date: Wed, 10 Apr 2024 22:34:34 +0800
Message-Id: <20240410143446.797262-7-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20240410143446.797262-1-chao.gao@intel.com>
References: <20240410143446.797262-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

so that KVM can adjust the mask/value for each vCPU according to the
software mitigations the vCPU is using.

KVM_CAP_FORCE_SPEC_CTRL allows the userspace VMM to proactively enable
hardware mitigations (by setting some bits in IA32_SPEC_CTRL MSRs) to
protect the guest from becoming vulnerable to some security issues after
live migration. E.g., if a guest using the short BHB-clearing sequence
for BHI is migrated from a pre-SPR part to a SPR part will become
vulnerable for BHI. Current solution is the userspace VMM deploys
BHI_DIS_S for all guests migrated to SPR parts from pre-SPR parts.

But KVM_CAP_FORCE_SPEC_CTRL isn't flexible because the userspace VMM may
configure KVM to enable BHI_DIS_S for guests which don't care about BHI
at all or are using other mitigations (e.g, TSX abort sequence) for BHI.
This would cause unnecessary overhead to the guest.

To reduce the overhead, the idea is to let the guest communicate which
software mitigations are being used to the VMM via Intel-defined virtual
MSRs [1]. This information from guests is much more accurate. KVM can
adjust hardware mitigations accordingly to reduce the performance impact
to the guest as much as possible.

The Intel-defined value MSRs are per-thread scope. vCPUs _can_ program
different values to them. This means, KVM may need to apply different
mask/value to IA32_SPEC_CTRL MSR. So, cache force_spec_ctrl_value/mask
for each vCPU in preparation for adding support for intel-defined
virtual MSRs.

[1]: https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 11 +++++++----
 arch/x86/kvm/vmx/vmx.h    |  7 +++++++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 174790b2ffbc..efbc871d0466 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2390,7 +2390,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 		exec_control &= TERTIARY_EXEC_SPEC_CTRL_SHADOW;
 		if (exec_control & TERTIARY_EXEC_SPEC_CTRL_SHADOW)
 			vmcs_write64(IA32_SPEC_CTRL_MASK,
-				     vmx->vcpu.kvm->arch.force_spec_ctrl_mask);
+				     vmx->force_spec_ctrl_mask);
 
 		tertiary_exec_controls_set(vmx, exec_control);
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 93c208f009cf..cdfcc1290d82 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2161,7 +2161,7 @@ static void vmx_set_spec_ctrl(struct kvm_vcpu *vcpu, u64 val)
 		vmx->spec_ctrl_shadow = val;
 		vmcs_write64(IA32_SPEC_CTRL_SHADOW, val);
 
-		vmx->spec_ctrl |= vcpu->kvm->arch.force_spec_ctrl_value;
+		vmx->spec_ctrl |= vmx->force_spec_ctrl_value;
 	}
 }
 
@@ -4803,6 +4803,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	if (cpu_has_vmx_xsaves())
 		vmcs_write64(XSS_EXIT_BITMAP, VMX_XSS_EXIT_BITMAP);
 
+	vmx->force_spec_ctrl_mask = kvm->arch.force_spec_ctrl_mask;
+	vmx->force_spec_ctrl_value = kvm->arch.force_spec_ctrl_value;
+
 	if (cpu_has_spec_ctrl_shadow()) {
 		vmx->spec_ctrl_shadow = 0;
 		vmcs_write64(IA32_SPEC_CTRL_SHADOW, 0);
@@ -4816,7 +4819,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		 * guest modify other bits at will, without triggering VM-Exits.
 		 */
 		if (kvm->arch.force_spec_ctrl_mask)
-			vmcs_write64(IA32_SPEC_CTRL_MASK, kvm->arch.force_spec_ctrl_mask);
+			vmcs_write64(IA32_SPEC_CTRL_MASK, vmx->force_spec_ctrl_mask);
 		else
 			vmcs_write64(IA32_SPEC_CTRL_MASK, 0);
 	}
@@ -7251,8 +7254,8 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 		if (cpu_has_spec_ctrl_shadow()) {
 			vmx->spec_ctrl_shadow = vmcs_read64(IA32_SPEC_CTRL_SHADOW);
 			vmx->spec_ctrl = (vmx->spec_ctrl_shadow &
-					~vmx->vcpu.kvm->arch.force_spec_ctrl_mask) |
-					 vmx->vcpu.kvm->arch.force_spec_ctrl_value;
+					~vmx->force_spec_ctrl_mask) |
+					 vmx->force_spec_ctrl_value;
 		} else {
 			vmx->spec_ctrl = __rdmsr(MSR_IA32_SPEC_CTRL);
 		}
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 97324f6ee01c..a4dfe538e5a8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -287,6 +287,13 @@ struct vcpu_vmx {
 	 */
 	u64		      spec_ctrl_shadow;
 
+	/*
+	 * Mask and value of SPEC_CTRL MSR bits which the guest is not allowed to
+	 * change.
+	 */
+	u64		      force_spec_ctrl_mask;
+	u64		      force_spec_ctrl_value;
+
 	u32		      msr_ia32_umwait_control;
 
 	/*
-- 
2.39.3


