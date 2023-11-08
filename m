Return-Path: <kvm+bounces-1248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0715B7E5DDE
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:01:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B44B82819C7
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 19:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 328A838DDC;
	Wed,  8 Nov 2023 19:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q/6YwCg6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5617836B1C;
	Wed,  8 Nov 2023 19:00:29 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D335C2116;
	Wed,  8 Nov 2023 11:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699470020; x=1731006020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XBjxJzF23ZyrUcL//Abo2czdnJUCDVfOQL8DmGgF2m8=;
  b=Q/6YwCg6+2ThjXVGKYUkH/NwkKs2WM3Mr4dWqgSqIQVxO/Oz5n5zVBYf
   jYp6GXxMOlfUWzdu3BbLo3abjybb/ZWUEvSyEpfaV1an6XDICcBRcR+sM
   bg+Egp6+zRJfD4f7VBtfaphGP1bANpcVhNdJDFDDHKOp63xSt5q1M3Okh
   JkHyxLzBfYeLEeu2VA55gqwejYlW/HpGqCmD2LqyqfElBx0ufefHktWox
   oDOxYrG/vj4qNVs/BZhJV3pY4KUKev3WAQz6gTud9mPOVUoGHfPLAYCuy
   Q141VC27lHrHuQ/HM5zcBHbfgn7wEmJCZq+W04emD/EaK93CCGtfKpe00
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="8486281"
X-IronPort-AV: E=Sophos;i="6.03,287,1694761200"; 
   d="scan'208";a="8486281"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:00:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,287,1694761200"; 
   d="scan'208";a="10892439"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orviesa001.jf.intel.com with ESMTP; 08 Nov 2023 11:00:19 -0800
From: Xin Li <xin3.li@intel.com>
To: kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	corbet@lwn.net,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	vkuznets@redhat.com,
	peterz@infradead.org,
	ravi.v.shankar@intel.com
Subject: [PATCH v1 07/23] KVM: VMX: Disable intercepting FRED MSRs
Date: Wed,  8 Nov 2023 10:29:47 -0800
Message-ID: <20231108183003.5981-8-xin3.li@intel.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231108183003.5981-1-xin3.li@intel.com>
References: <20231108183003.5981-1-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add FRED MSRs to the valid passthrough MSR list and disable intercepting
FRED MSRs only if FRED is enumerated after set CPUID.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5d4786812664..327e052d90c1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -700,6 +700,9 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
 		return true;
+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
+		/* FRED MSRs should be passthrough to FRED guests only */
+		return true;
 	}
 
 	r = possible_passthrough_msr_slot(msr) != -ENOENT;
@@ -7813,6 +7816,16 @@ static void vmx_vcpu_config_fred_after_set_cpuid(struct kvm_vcpu *vcpu)
 	secondary_vm_exit_controls_setbit(vmx,
 					  SECONDARY_VM_EXIT_SAVE_IA32_FRED |
 					  SECONDARY_VM_EXIT_LOAD_IA32_FRED);
+
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP0, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP1, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP2, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP3, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_FRED_STKLVLS, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP1, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP2, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP3, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_FRED_CONFIG, MSR_TYPE_RW);
 }
 
 static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
-- 
2.42.0


