Return-Path: <kvm+bounces-1251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF2D47E5DEF
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:01:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50460B211D8
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 19:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 895BE38F82;
	Wed,  8 Nov 2023 19:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JgSRSeJZ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A684237148;
	Wed,  8 Nov 2023 19:00:29 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA612118;
	Wed,  8 Nov 2023 11:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699470022; x=1731006022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g73pajj6LcG0nirmtYAP2EfGJEvaHaj/eDWN0wShpq4=;
  b=JgSRSeJZO319GMkkVM5oF00rMVvF1+b1e4gSCMAWyr9eNy6gQM4FSv98
   f3foPHOsjnEAGdUkZUZTk1Mtc1I/bXGHXbPbium5xt7BMz37nFLarWK41
   kjL8xFP2jkx9+T4jcB/AYxuGeywMT4p/sZhH0ajQoDsRyrU0S50tVMmB8
   rwR7sjGb/JhfJSHLs1SpCN5eS5n0IycTcPmpEgLJW/Qu1cDF44rVLWb9L
   bW+rYn2mfI5aMTxsOra26YDgeZoL64BM9OLT1+8oNxtN/4M7VsfipUScS
   6V6xHWyxvglwVRWGCRZ44oRVg3WrIi9r8dX/AMY//YyhefS2q/94oahb8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="8486310"
X-IronPort-AV: E=Sophos;i="6.03,287,1694761200"; 
   d="scan'208";a="8486310"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:00:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,287,1694761200"; 
   d="scan'208";a="10892452"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orviesa001.jf.intel.com with ESMTP; 08 Nov 2023 11:00:20 -0800
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
Subject: [PATCH v1 09/23] KVM: VMX: Switch FRED RSP0 between host and guest
Date: Wed,  8 Nov 2023 10:29:49 -0800
Message-ID: <20231108183003.5981-10-xin3.li@intel.com>
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

Switch MSR_IA32_FRED_RSP0 between host and guest in
vmx_prepare_switch_to_{host,guest}().

MSR_IA32_FRED_RSP0 is used during ring 3 event delivery only, thus
KVM, running on ring 0, can run safely with guest FRED RSP0, i.e.,
no need to switch between host/guest FRED RSP0 during VM entry and
exit.

KVM should switch to host FRED RSP0 before returning to user level,
and switch to guest FRED RSP0 before entering guest mode.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 +++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 41772ecdd368..d00ab9d4c93e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1344,6 +1344,17 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	}
 
 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
+
+	if (cpu_feature_enabled(X86_FEATURE_FRED) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_FRED)) {
+		/*
+		 * MSR_IA32_FRED_RSP0 is top of task stack, which never changes.
+		 * Thus it should be initialized only once.
+		 */
+		if (unlikely(vmx->msr_host_fred_rsp0 == 0))
+			vmx->msr_host_fred_rsp0 = read_msr(MSR_IA32_FRED_RSP0);
+		wrmsrl(MSR_IA32_FRED_RSP0, vmx->msr_guest_fred_rsp0);
+	}
 #else
 	savesegment(fs, fs_sel);
 	savesegment(gs, gs_sel);
@@ -1388,6 +1399,12 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 	invalidate_tss_limit();
 #ifdef CONFIG_X86_64
 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
+
+	if (cpu_feature_enabled(X86_FEATURE_FRED) &&
+	    guest_cpuid_has(&vmx->vcpu, X86_FEATURE_FRED)) {
+		vmx->msr_guest_fred_rsp0 = read_msr(MSR_IA32_FRED_RSP0);
+		wrmsrl(MSR_IA32_FRED_RSP0, vmx->msr_host_fred_rsp0);
+	}
 #endif
 	load_fixmap_gdt(raw_smp_processor_id());
 	vmx->guest_state_loaded = false;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f8c02bd37069..328a3447f064 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -276,6 +276,8 @@ struct vcpu_vmx {
 #ifdef CONFIG_X86_64
 	u64		      msr_host_kernel_gs_base;
 	u64		      msr_guest_kernel_gs_base;
+	u64		      msr_host_fred_rsp0;
+	u64		      msr_guest_fred_rsp0;
 #endif
 
 	u64		      spec_ctrl;
-- 
2.42.0


