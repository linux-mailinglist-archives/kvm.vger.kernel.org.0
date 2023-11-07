Return-Path: <kvm+bounces-1019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5AF67E42DC
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:10:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE2B71C212AE
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56201358B0;
	Tue,  7 Nov 2023 15:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZezbOYaW"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10063AC0B
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:05:17 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FBC5B85;
	Tue,  7 Nov 2023 07:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369317; x=1730905317;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2wVL223YHj8nDRmJY7rbAF1ROEcHmuKC+DEFUJUVpeU=;
  b=ZezbOYaWDgcb3yLM6zNE7gl+qmKnCfOT2lauZ2vmEfBBKtn2CC1Z9c4x
   kEwgWZj25S9HIm9IRMIZQ6uh3CjsUiTcuziNoTVdDOgoDXI93RQcsqzFl
   QseJHtYDW9UwKUNq8ia+dspsm8Ope9/Q5fuqg/TFv1Ky1arYYRYz8Fg03
   jYGPqLsIv4Pg57YS837eKg85USE/37XIVqtXpt9rrOOO+SZz73xNCqemG
   S36IZhhHf4hBoHp0h/N8CxC5kJ3MDK0qxJLek8RF4mySRxuKQfBY4Z6pv
   zJR/FxsioxATbuj3Z4mhESALUS3r2xAcE7RKgGcGDRTsrSsIJ5hNX2jSV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462553"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462553"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851539"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:22 -0800
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
	tina.zhang@intel.com,
	Yao Yuan <yuan.yao@intel.com>
Subject: [PATCH v17 083/116] KVM: TDX: Handle vmentry failure for INTEL TD guest
Date: Tue,  7 Nov 2023 06:56:49 -0800
Message-Id: <d1c3c9667fff26eaaf8147ae5f428c22e7ee3a65.1699368322.git.isaku.yamahata@intel.com>
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

From: Yao Yuan <yuan.yao@intel.com>

TDX module passes control back to VMM if it failed to vmentry for a TD, use
same exit reason to notify user space, align with VMX.
If VMM corrupted TD VMCS, machine check during entry can happens.  vm exit
reason will be EXIT_REASON_MCE_DURING_VMENTRY.  If VMM corrupted TD VMCS
with debug TD by TDH.VP.WR, the exit reason would be
EXIT_REASON_INVALID_STATE or EXIT_REASON_MSR_LOAD_FAIL.

Signed-off-by: Yao Yuan <yuan.yao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 012cfcc2b7b1..64570cedfd9a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1296,6 +1296,28 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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


