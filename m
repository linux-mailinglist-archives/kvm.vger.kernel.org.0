Return-Path: <kvm+bounces-14124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B44C489F9F9
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:36:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E54B11C22B57
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA4916E877;
	Wed, 10 Apr 2024 14:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LTHwJL1U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3FF16DECE;
	Wed, 10 Apr 2024 14:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712759723; cv=none; b=jKRPk/d1vg6pbb5/8RQyTyAcEdzlXy0+TyLIy9vkwwa7BrBhMYS0GyBSt5xZLJ89vPhYAgZfT3BaBM4rZILts77lkcmJDesWuL1Yz9B7QRism7WdxOpNNftsLgfi13vZ1SsvaWhYGh7LBZgEMj6/VrqRhsJJ0TwS+FhLboS7S3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712759723; c=relaxed/simple;
	bh=2OcWNwE6hI9rpeiZBy7dyOdf0VxZdQ5gXISCKaAfKFE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NyKKyMa2QB7M/2Ba5j5r7H7c6k3ffgKn2vOUrfJbq1d1B6nFmwMCh8wLiugGTh+y9B2G9PyEMaZOdbGj540mewaQheP9TuFp0aB3GFWJq2fYDSbTJVUXCtFrx90IXjKpcfj1iITo5E+hMIMjS1sLpeH6NBKt4PdGTYjNkFxOE9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LTHwJL1U; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712759722; x=1744295722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2OcWNwE6hI9rpeiZBy7dyOdf0VxZdQ5gXISCKaAfKFE=;
  b=LTHwJL1U7xnzPORI7oGPCtBlT6kLenNpqSa4KMMY7qe18kFcE5tCwsb0
   t2tWYDH3MEuzYhEoeMiqSiyP9ZqH3rTCZsLwQgCYDaP6B/tpoS3JbIuYG
   8wdDUvXJdH82Nym1wfgPqdbzkJwzP5tvszDy2j04Wmg4UK8D2zE6WxnjL
   p8R/m5RxjjTFYLhhhwJZJyuRDd70DlqtCIdK5sKPZbsiY5BtnuXPZQ/9I
   Zz0vuMpGQX9dUYvUA/l0eoxStT7w8PYpDSNs0SaeSousFv9vi1rbFaVme
   656tGAU/kiqUKNgS5mfVbg+dfGjLKpkJojFYkkcTHaHCTEEvsKC6uI6iM
   A==;
X-CSE-ConnectionGUID: ZQ92OsueSPqbU3zStK7VdA==
X-CSE-MsgGUID: V1BZAS0TRjOjAK5t6EoAEw==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="18837752"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="18837752"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:21 -0700
X-CSE-ConnectionGUID: tkOZQ7LkRWWM8ctnydozkw==
X-CSE-MsgGUID: 0yQ9ABfoTr279Clfls7JBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="25095493"
Received: from unknown (HELO spr.sh.intel.com) ([10.239.53.118])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:18 -0700
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
Subject: [RFC PATCH v3 02/10] KVM: VMX: Cache IA32_SPEC_CTRL_SHADOW field of VMCS
Date: Wed, 10 Apr 2024 22:34:30 +0800
Message-Id: <20240410143446.797262-3-chao.gao@intel.com>
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

This field is effectively the value of IA32_SPEC_CTRL MSR in guest's
view. Cache it for nested VMX transitions. The value should be
propagated between vmcs01 and vmcs02 so that across nested VMX
transitions, in guest's view, IA32_SPEC_CTRL MSR won't be changed
magically.

IA32_SPEC_CTRL_SHADOW field may be changed by guest if IA32_SPEC_CTRL
MSR is pass-thru'd to the guest. So, update the cache right after
VM-exit to ensure it is always consistent with the value in guest's
view.

A bonus is vmx_get_msr() can return the cache directly thus no need
to make a VMREAD.

No functional change intended.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 12 ++++++++----
 arch/x86/kvm/vmx/vmx.h |  6 ++++++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a6154d725025..93c208f009cf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2009,7 +2009,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 
 		if (cpu_has_spec_ctrl_shadow())
-			msr_info->data = vmcs_read64(IA32_SPEC_CTRL_SHADOW);
+			msr_info->data = to_vmx(vcpu)->spec_ctrl_shadow;
 		else
 			msr_info->data = to_vmx(vcpu)->spec_ctrl;
 		break;
@@ -2158,6 +2158,7 @@ static void vmx_set_spec_ctrl(struct kvm_vcpu *vcpu, u64 val)
 	vmx->spec_ctrl = val;
 
 	if (cpu_has_spec_ctrl_shadow()) {
+		vmx->spec_ctrl_shadow = val;
 		vmcs_write64(IA32_SPEC_CTRL_SHADOW, val);
 
 		vmx->spec_ctrl |= vcpu->kvm->arch.force_spec_ctrl_value;
@@ -4803,6 +4804,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(XSS_EXIT_BITMAP, VMX_XSS_EXIT_BITMAP);
 
 	if (cpu_has_spec_ctrl_shadow()) {
+		vmx->spec_ctrl_shadow = 0;
 		vmcs_write64(IA32_SPEC_CTRL_SHADOW, 0);
 
 		/*
@@ -7246,12 +7248,14 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 		return;
 
 	if (flags & VMX_RUN_SAVE_SPEC_CTRL) {
-		if (cpu_has_spec_ctrl_shadow())
-			vmx->spec_ctrl = (vmcs_read64(IA32_SPEC_CTRL_SHADOW) &
+		if (cpu_has_spec_ctrl_shadow()) {
+			vmx->spec_ctrl_shadow = vmcs_read64(IA32_SPEC_CTRL_SHADOW);
+			vmx->spec_ctrl = (vmx->spec_ctrl_shadow &
 					~vmx->vcpu.kvm->arch.force_spec_ctrl_mask) |
 					 vmx->vcpu.kvm->arch.force_spec_ctrl_value;
-		else
+		} else {
 			vmx->spec_ctrl = __rdmsr(MSR_IA32_SPEC_CTRL);
+		}
 	}
 
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f26ac82b5a59..97324f6ee01c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -281,6 +281,12 @@ struct vcpu_vmx {
 #endif
 
 	u64		      spec_ctrl;
+	/*
+	 * Cache IA32_SPEC_CTRL_SHADOW field of VMCS, i.e., the value of
+	 * MSR_IA32_SPEC_CTRL in guest's view.
+	 */
+	u64		      spec_ctrl_shadow;
+
 	u32		      msr_ia32_umwait_control;
 
 	/*
-- 
2.39.3


