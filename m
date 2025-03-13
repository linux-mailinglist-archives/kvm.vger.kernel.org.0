Return-Path: <kvm+bounces-40982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A65A4A6013E
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:31:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A17419C13B4
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 19:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 692F71F3FD0;
	Thu, 13 Mar 2025 19:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tfe1kZ58"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87141EEA27;
	Thu, 13 Mar 2025 19:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741894233; cv=none; b=AFqpgdzsHsWiAy/CBUa9RNhrk/gTgcZ3Xi0jCoIvzmaT3t/l287nAiPytxo8k2/niSr03exN6cg8GtPFHcCZM7QZgBtPyXBLhbftGMC41ansaQGxM0dhgBPHCArmKeCeCcCVB939wO8N0JUOtcsAoE4XjU6aLVrqD0uZ5rO7MfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741894233; c=relaxed/simple;
	bh=STDnxg5RnvsGQfGEYHRsm51VOKb1VgyKotoO/k6K7PM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LOwFYQ/pSQxtbHAXBIPTorcR3Aq8yI/URNHeNezCCCe/E86SFiF18Df1zzaR2y5pCGlJAcOsUs3RYN9Hwl5uOrLmXuEaLJ1FpnFOES4gDBTZSWxGcHNnXqEGeKyC1V7OPSVTvNoAmeha3aYUPU5ilJt6kmiExNQnOv7uwSWbUeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tfe1kZ58; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741894232; x=1773430232;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=STDnxg5RnvsGQfGEYHRsm51VOKb1VgyKotoO/k6K7PM=;
  b=Tfe1kZ58IFDxSMy2jubsvVWXDkt6XlN2Xnw6O9pQWi0zHiaeeUQFCiY3
   y3qwxTUxbmiUA2OCfQKY8zc4niF2SRDraXiOnJsPo24Moet5RPzBJNaDZ
   xWvAv3shMEpVrqYAy0LXemJQjoCQrQx69eGLaAYuGslwfWccTSfzN3vJH
   DugB2I8Nx3Srr4+TE3s2Tth8A/5mekMprCf2CwYjwcpGXrRa86q9HD1k6
   dZFJ+eeaM/POOBwJJRuK3qvlXOqMXLBNYUZ2NIcO+8qDqiusjfyUOZOzY
   mi3aEBtSKvxX5xZXPNZKcuEKVbZwQBZrMxG2sKSGOelAQpPLhEaO72SSQ
   A==;
X-CSE-ConnectionGUID: lbbQ4ptZSeezANMl6ziqpw==
X-CSE-MsgGUID: EB8a/Y45QYmqy8KlcFfwdw==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="43237118"
X-IronPort-AV: E=Sophos;i="6.14,245,1736841600"; 
   d="scan'208";a="43237118"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 12:30:29 -0700
X-CSE-ConnectionGUID: Kb0yKv5TTiWExFD7Loje/Q==
X-CSE-MsgGUID: kpDyFZr4Sa2MXY5StS/gQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,245,1736841600"; 
   d="scan'208";a="151988219"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.125.108.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 12:30:28 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 13 Mar 2025 13:30:02 -0600
Subject: [PATCH 2/4] KVM: VMX: Move x86_ops wrappers under
 CONFIG_KVM_INTEL_TDX
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250313-vverma7-cleanup_x86_ops-v1-2-0346c8211a0c@intel.com>
References: <20250313-vverma7-cleanup_x86_ops-v1-0-0346c8211a0c@intel.com>
In-Reply-To: <20250313-vverma7-cleanup_x86_ops-v1-0-0346c8211a0c@intel.com>
To: Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2224;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=STDnxg5RnvsGQfGEYHRsm51VOKb1VgyKotoO/k6K7PM=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDOmXjYJFJpqarPVuVN98WNJ46j3O2Ysf1PtfX5Sw/97Pr
 44S1ueUOkpZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCRbd8Z/lnr/Pu9ImDV9U4P
 jyd9Z3nNmxfHGnceKVC7voS19TyvShgjw9Rvc28USUwss53gUb+xadb8SGveCUs2TX68z71eV1P
 dghMA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Rather than have a lot of stubs for x86_ops helpers, simply omit the
wrappers when CONFIG_KVM_INTEL_TDX=n.  This allows nearly all of
vmx/main.c to go under a single #ifdef.  That eliminates all the
trampolines in the generated code, and almost all of the stubs.

Based on a patch by Sean Christopherson <seanjc@google.com>

Link: https://lore.kernel.org/kvm/Z6v9yjWLNTU6X90d@google.com/
Cc: Sean Christopherson <seanjc@google.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 arch/x86/kvm/vmx/tdx.h     | 2 +-
 arch/x86/kvm/vmx/x86_ops.h | 2 +-
 arch/x86/kvm/vmx/main.c    | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 8f8070d0f55e..b43d7a7c8f1c 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -5,7 +5,7 @@
 #include "tdx_arch.h"
 #include "tdx_errno.h"
 
-#ifdef CONFIG_INTEL_TDX_HOST
+#ifdef CONFIG_KVM_INTEL_TDX
 #include "common.h"
 
 int tdx_bringup(void);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 19f770b0fc81..4704bed033b1 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -121,7 +121,7 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
-#ifdef CONFIG_INTEL_TDX_HOST
+#ifdef CONFIG_KVM_INTEL_TDX
 void tdx_disable_virtualization_cpu(void);
 int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_release_hkid(struct kvm *kvm);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 9d201ddb794a..ccb81a8b73f7 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -10,9 +10,8 @@
 #include "tdx.h"
 #include "tdx_arch.h"
 
-#ifdef CONFIG_INTEL_TDX_HOST
+#ifdef CONFIG_KVM_INTEL_TDX
 static_assert(offsetof(struct vcpu_vmx, vt) == offsetof(struct vcpu_tdx, vt));
-#endif
 
 static void vt_disable_virtualization_cpu(void)
 {
@@ -879,6 +878,7 @@ static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 
 	return 0;
 }
+#endif
 
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\

-- 
2.48.1


