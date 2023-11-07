Return-Path: <kvm+bounces-985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D57A27E42BC
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:07:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9030B28253E
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025B738FA3;
	Tue,  7 Nov 2023 15:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DOGlBYfN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EFB374C9
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:05:03 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CF05FCB;
	Tue,  7 Nov 2023 07:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369319; x=1730905319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VJJSpmiiNTsWgxJeUeqnSkcKX7HX1R9ThJscX8x/hD8=;
  b=DOGlBYfNQbEpQrFfQ+Ifq30ccntgBFhge5kA5cZ5V/5rbrtU5ENj6+8j
   LsH/TOaQRdh5Mm9I0SCxVW9J3SEoHRhN4FP0QGs0VkydozoADaivRc8rw
   fToJdxQo9ulFsryz4ldSBHeZOTL+SiBcZoWaAKDToqpCt5q5GOo3l5uON
   EZA626bKoJ36nRMVYCfLc+X/Ken28bpz28BjIDiLc4V/bY3dc1CyS+gCb
   jBPxwuQuj7LdJQgfBCOwLdjMgCGh1jRSJkp1OVCUfNzYFlWO0BxdEu2kQ
   MSRSWySEKV5kM1zWpDaH/Ali3+/GV053oFfarhuoXSEP5EnJV0KkX8MXZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462620"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462620"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851606"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:26 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 098/116] KVM: TDX: Handle MSR IA32_FEAT_CTL MSR and IA32_MCG_EXT_CTL
Date: Tue,  7 Nov 2023 06:57:04 -0800
Message-Id: <55818d584dcbe96d3af2d21774f7d375e314507e.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

MCE and MCA is advertised via cpuid based on the TDX module spec.  Guest
kernel can access IA32_FEAT_CTL for checking if LMCE is enabled by platform
and IA32_MCG_EXT_CTL to enable LMCE.  Make TDX KVM handle them.  Otherwise
guest MSR access to them with TDG.VP.VMCALL<MSR> on VE results in GP in
guest.

Because LMCE is disabled with qemu by default, "-cpu lmce=on" to qemu
command line is needed to reproduce it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 01966d57c3d1..f074b3e77183 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1935,6 +1935,7 @@ bool tdx_has_emulated_msr(u32 index, bool write)
 		default:
 			return true;
 		}
+	case MSR_IA32_FEAT_CTL:
 	case MSR_IA32_APICBASE:
 	case MSR_EFER:
 		return !write;
@@ -1949,6 +1950,20 @@ bool tdx_has_emulated_msr(u32 index, bool write)
 int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
 	switch (msr->index) {
+	case MSR_IA32_FEAT_CTL:
+		/*
+		 * MCE and MCA are advertised via cpuid. guest kernel could
+		 * check if LMCE is enabled or not.
+		 */
+		msr->data = FEAT_CTL_LOCKED;
+		if (vcpu->arch.mcg_cap & MCG_LMCE_P)
+			msr->data |= FEAT_CTL_LMCE_ENABLED;
+		return 0;
+	case MSR_IA32_MCG_EXT_CTL:
+		if (!msr->host_initiated && !(vcpu->arch.mcg_cap & MCG_LMCE_P))
+			return 1;
+		msr->data = vcpu->arch.mcg_ext_ctl;
+		return 0;
 	case MSR_MTRRcap:
 		/*
 		 * Override kvm_mtrr_get_msr() which hardcodes the value.
@@ -1967,6 +1982,11 @@ int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
 	switch (msr->index) {
+	case MSR_IA32_MCG_EXT_CTL:
+		if (!msr->host_initiated && !(vcpu->arch.mcg_cap & MCG_LMCE_P))
+			return 1;
+		vcpu->arch.mcg_ext_ctl = msr->data;
+		return 0;
 	case MSR_MTRRdefType:
 		/*
 		 * Allow writeback only for all memory.
-- 
2.25.1


