Return-Path: <kvm+bounces-9750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E58A5866DB5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:09:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A067A285758
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FD73130AE7;
	Mon, 26 Feb 2024 08:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dg823Kt2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (unknown [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C05512F588;
	Mon, 26 Feb 2024 08:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936161; cv=none; b=ulDsoXohb4wmaJFkOWnI1HjFokTPkfVNEQ+wsdbn4HTzB/WhgI7YmsNLTP2lEzDtLzN3zqsrY7Xglld5VDIJgGSceC7yRLtve+SwRi8mLKVcq74UNpd96pQwRyxkJYQ7Ndr9I9MCCTYGeJJgjjpcPN1BU9o+f88MUBI8ylmYRFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936161; c=relaxed/simple;
	bh=kw0IabQRxVN3vncG2oiy3raswwUfUrRevEA6BZ0XDZg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q0R9sOZsIDpCU7Qh0GtbBzJhaSryEHg1+XkXsbFqJOJRcK6T5NpfWpsfplyMqKALxG4t/LG+NSg1MVo3jdNa0Jdkl/eUB3KVay8TIX3nMC6WKfIbVlcmYinSBDp6pCorKsEqXbLicPWIYoYKAiotHO3Y+7BmjBpfiSEE95RspQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dg823Kt2; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936159; x=1740472159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kw0IabQRxVN3vncG2oiy3raswwUfUrRevEA6BZ0XDZg=;
  b=Dg823Kt2rRgPRLYXh/A1O0ivGyIFfgq+3kNxqT1M6wyHySiX5iFk/8U+
   o5BDAfqXOthgRblZLxJGmLjZ+g502oW+QRreAbiAA327yy+bgDDGFyTji
   OAU6xA3DXD7dO7YwvVKouf0cu3C+TPFHw2ryj2Y1TeofKsSO+icVGJ2bn
   EKGMVQ/xJNXXNieS8yn9CUEeUbU6lwDfUbH7cae5xek3JmLSevummLYVs
   yFMnAEMaGZumzidymGVGkDjbcFuGaIjhjOw6Oe7O01Z55CiP56+A7Li/G
   bI4L1zbcdCLsGyAHZFpYL8cZ2FxmNx14Cj5NyQ1VvVtfLaU4Wen6tbpYC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751413"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751413"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735145"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:11 -0800
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
Subject: [PATCH v19 126/130] KVM: TDX: Inhibit APICv for TDX guest
Date: Mon, 26 Feb 2024 00:27:08 -0800
Message-Id: <38e2f8a77e89301534d82325946eb74db3e47815.1708933498.git.isaku.yamahata@intel.com>
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

TDX doesn't support APICV, inhibit APICv for TDX guest.  Follow how SEV
does it.  Define a new inhibit reason for TDX, set it on TD
initialization, and add the flag to kvm_x86_ops.required_apicv_inhibits.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 9 +++++++++
 arch/x86/kvm/vmx/main.c         | 3 ++-
 arch/x86/kvm/vmx/tdx.c          | 4 ++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2686c080820b..920fb771246b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1300,6 +1300,15 @@ enum kvm_apicv_inhibit {
 	 * mapping between logical ID and vCPU.
 	 */
 	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
+
+	/*********************************************************/
+	/* INHIBITs that are relevant only to the Intel's APICv. */
+	/*********************************************************/
+
+	/*
+	 * APICv is disabled because TDX doesn't support it.
+	 */
+	APICV_INHIBIT_REASON_TDX,
 };
 
 struct kvm_arch {
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index c46c860be0f2..2cd404fd7176 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -1022,7 +1022,8 @@ static void vt_post_memory_mapping(struct kvm_vcpu *vcpu,
 	 BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |			\
 	 BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
 	 BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |		\
-	 BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED))
+	 BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |		\
+	 BIT(APICV_INHIBIT_REASON_TDX))
 
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f706c346eea4..7be1be161dc2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2488,6 +2488,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 		goto teardown;
 	}
 
+	kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_TDX);
+
 	return 0;
 
 	/*
@@ -2821,6 +2823,8 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 		return -EIO;
 	}
 
+	WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm));
+	vcpu->arch.apic->apicv_active = false;
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	tdx->td_vcpu_created = true;
 	return 0;
-- 
2.25.1


