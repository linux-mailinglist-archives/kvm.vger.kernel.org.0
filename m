Return-Path: <kvm+bounces-6653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 617D8837834
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9384B1C25256
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338276A028;
	Mon, 22 Jan 2024 23:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i3FPsYuZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D106B66B2A;
	Mon, 22 Jan 2024 23:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967756; cv=none; b=YDsTaqZCtBU9PhFRtSm8OFjkvXXlJwhmEqzWXN1SgcKhlpCycNWn7J0bik6NJBEhzLW0nEY+13poSXcRu/IDPWsJnHo/MGYxTaVkY5KuHjWHLlJ3rJgBeCzRR6yNfVRtGw4AJMmmihLSoNuyKkEJUtxCWZEWwg78r4PxMaqPKdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967756; c=relaxed/simple;
	bh=pRNuUXdQy1I92AMetXqbIk5d7IJc6yvwFOqRbbDa4xo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FIv4APXKKaDSn7qUyGkdunqZ22zmLQxISdjrZyxS9DP4WiPasRcWfLdeuPB+0A3lXGdIxvlTTQowjzoNnnjLd5n3mVQh299AZheLZyKOqkdYXnTHnvEMiJk06rBmMlCsoatL7YPW3xtwZNiIHoLzBI6lbTillo3t2C4YYci1MPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i3FPsYuZ; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967754; x=1737503754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pRNuUXdQy1I92AMetXqbIk5d7IJc6yvwFOqRbbDa4xo=;
  b=i3FPsYuZcX+2QWkNy2EmdOAtREqHvtYuXgCdOIlyk9tJZyMEnVNsWzBS
   /Kq2HdQFXbp0t3kv99YCTGyqXovprg1+/vxLbtFAHSd02HDBOGY6Txq/0
   3nUHlvs/a10kay+QDRhKCkCoDvMAyTpmFpo61LxwZtdL/aWmg0Pbel31l
   F7GL8Nyggnd4wRlQtpFw0ipOt0LzJhjLUMIy2ytp/Tio16nOT3lmN4Emq
   i08qdr+VGCFuVJDn9YO08nvqd0xg1G1xIKdSj65AMTbEENVWITYi5vlV+
   oRi+ZToR4z0J0Hj53ppn1ETu9YIHplFMgThfAr0wftGbRAc/cHTgqy3Rz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217821"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217821"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27817943"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:47 -0800
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
Subject: [PATCH v18 088/121] KVM: TDX: Handle vmentry failure for INTEL TD guest
Date: Mon, 22 Jan 2024 15:54:04 -0800
Message-Id: <bb3248cc0ca1cac6071825b868879f703e970009.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
index eea36f990e17..cb4a8a8d8e1b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1365,6 +1365,28 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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


