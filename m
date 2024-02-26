Return-Path: <kvm+bounces-9723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C43866D66
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:01:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CBD21F23775
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 101857B3C1;
	Mon, 26 Feb 2024 08:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MxDdlcdF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812EF7E56A;
	Mon, 26 Feb 2024 08:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936139; cv=none; b=TQZB2cztTHg2BhDTnvoKtOVW8SWB9CIg248vcgINPBna3xb2E0tmYXXV0oc50Vyya9xEdRe1ErRlCaLTYezMOSOhUGZXUiAe822IHb4X+zwKMy7w7o7dISSRmLaPbfkDI/ZEWrNL71uCkG7HVGUzIBIcxvVhjWHI4A8cAOko2x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936139; c=relaxed/simple;
	bh=PfEUloIaN0+m6wTf244BqhPSXX4Whs3+DiuXu81jwnY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Clw63XQhANY6jLE0cSWiSwTxbAG63lote0dCpEWr2ROnvCj5eLjdwLtSQ3ZBQEQSCZlDBYRLVc6BkTXD+NFSweMOAK/nbe1M2uOqxQq0dGD4Y26OYtwwOT5pHwffPJ5hasKqfT2Yh1W980KmVPUCyA+Pu2MEub7G1oFG3lgWzZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MxDdlcdF; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936138; x=1740472138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PfEUloIaN0+m6wTf244BqhPSXX4Whs3+DiuXu81jwnY=;
  b=MxDdlcdF+bIgSdhb00qqJOR6KPF+ODMX6dEGSgrzZ8tBSLqCqClTp1CV
   p41JWNiW4BerETvy6iPVJLjrK0r7fAkU/i2mxMc+QRYqzGlXUGdzrJ9uK
   gOc1O8UbBPowm2A5/vvurj/4e6ciN+MGY4RZecVV9AizduLZ9XfIsAoLd
   eeJjAjsVdRiHfjbyzgAbQ2D6gv+zQP/Sy8Nxx05RRSvVfascv7wQGFXMY
   8bjx7Z6VcH/VU9XG8fzkLI8xcRsh5djnes575qoV03cmpSqNMhKiAs71o
   PU1/3PZ4r4awSbx5PraR6ef4z1Tbex1xYDatuvnS8muGSUSNidZ1rIENB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069592"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069592"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272680"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:57 -0800
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
	tina.zhang@intel.com,
	Yao Yuan <yuan.yao@intel.com>
Subject: [PATCH v19 099/130] KVM: TDX: Handle vmentry failure for INTEL TD guest
Date: Mon, 26 Feb 2024 00:26:41 -0800
Message-Id: <f4fff979b347302c88a114efccb616a9895860f5.1708933498.git.isaku.yamahata@intel.com>
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

From: Yao Yuan <yuan.yao@intel.com>

TDX module passes control back to VMM if it failed to vmentry for a TD, use
same exit reason to notify user space, align with VMX.
If VMM corrupted TD VMCS, machine check during entry can happens.  vm exit
reason will be EXIT_REASON_MCE_DURING_VMENTRY.  If VMM corrupted TD VMCS
with debug TD by TDH.VP.WR, the exit reason would be
EXIT_REASON_INVALID_STATE or EXIT_REASON_MSR_LOAD_FAIL.

Signed-off-by: Yao Yuan <yuan.yao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 71ab48cf72ba..cba0fd5029be 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1320,6 +1320,28 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		goto unhandled_exit;
 	}
 
+	/*
+	 * When TDX module saw VMEXIT_REASON_FAILED_VMENTER_MC etc, TDH.VP.ENTER
+	 * returns with TDX_SUCCESS | exit_reason with failed_vmentry = 1.
+	 * Because TDX module maintains TD VMCS correctness, usually vmentry
+	 * failure shouldn't happen.  In some corner cases it can happen.  For
+	 * example
+	 * - machine check during entry: EXIT_REASON_MCE_DURING_VMENTRY
+	 * - TDH.VP.WR with debug TD.  VMM can corrupt TD VMCS
+	 *   - EXIT_REASON_INVALID_STATE
+	 *   - EXIT_REASON_MSR_LOAD_FAIL
+	 */
+	if (unlikely(exit_reason.failed_vmentry)) {
+		pr_err("TDExit: exit_reason 0x%016llx qualification=%016lx ext_qualification=%016lx\n",
+		       exit_reason.full, tdexit_exit_qual(vcpu), tdexit_ext_exit_qual(vcpu));
+		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		vcpu->run->fail_entry.hardware_entry_failure_reason
+			= exit_reason.full;
+		vcpu->run->fail_entry.cpu = vcpu->arch.last_vmentry_cpu;
+
+		return 0;
+	}
+
 	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
 
 	switch (exit_reason.basic) {
-- 
2.25.1


