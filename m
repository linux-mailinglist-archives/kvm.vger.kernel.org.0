Return-Path: <kvm+bounces-36835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BFDAA21AA3
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 11:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23A673A1DD6
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 10:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293F41B4153;
	Wed, 29 Jan 2025 10:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D5gm67J1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E082E1D89F1;
	Wed, 29 Jan 2025 10:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738144820; cv=none; b=lvWEjHOgWiaAjHSo2EWFgDQtaXzA7652jjdWKNvjyaZii3/l+sqW9JEdrNpr51o3mlDJmIF4rLRbzH+kZk1AV4LEQJqWf3gpgFrltBmwRXpXR0kgY8TBRCXiMF7rAceGoGXKhxfq9q0kO/DW1Mo+fYjYPPz38Qs1qMMTEDDPR0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738144820; c=relaxed/simple;
	bh=FcF5hew6e4R7LhHMHDbHCpjzgUfNYWKUEr0/w5BRJm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qk8Rqk1s6RvtYpJKInkhR6kLE12cNLxgv2XHnwLCy5k70C/PfQMF4MkTFb8s9bDq+rURsIinWzjrkLAjnOJn6xIOrEkoM2sUo4g6cSI+7Vyc6kNqQodJTPn6BgCCqH1y8wwjISWkR8pFZKPHjIY1YgcS7HKl2Y+IfDhE9Hpg13Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D5gm67J1; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738144818; x=1769680818;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FcF5hew6e4R7LhHMHDbHCpjzgUfNYWKUEr0/w5BRJm8=;
  b=D5gm67J1I2KnxpdeySugSJOLWq50JE8VnnbCbMgNFtzPc4mL1IcTeb2L
   Aa1lECEf7QjvwoTOpGNi11VpbvZZW/xV/DIaof3IqwRDmaeOKcQFuoOf/
   Ni0bnSLsowyI4m4lmQrORkDK2hxj9ko7rrVIx5BAUTD2fRjOFczGj+tIO
   G/+zMZnsVlCqfsRBTiMsxh/m7MDNBYs6oSq5w1nM6+YmxXd8mpoAWc/jU
   pt+p50l7BKatiF5ugD3hmpoqLz8hMnb6hKTPzoXA8HY6gWaFDPaBm2kFG
   4f9Szipc807RMAusU617pWFPsGWrGRRIFEBuV3Hvepwgp7LZFfS8Z9xBc
   A==;
X-CSE-ConnectionGUID: NiYEgQLBT4ysxBwTxZZ+sw==
X-CSE-MsgGUID: SjPT4eHGQWyQKE1qGGv+ZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11329"; a="50036056"
X-IronPort-AV: E=Sophos;i="6.13,243,1732608000"; 
   d="scan'208";a="50036056"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 02:00:04 -0800
X-CSE-ConnectionGUID: /Vzw2NafRpakkDKRczyY2A==
X-CSE-MsgGUID: Je1P8rllQdKvUQCqlV4Eiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="132262752"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.0.178])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 01:59:58 -0800
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH V2 09/12] KVM: TDX: restore user ret MSRs
Date: Wed, 29 Jan 2025 11:58:58 +0200
Message-ID: <20250129095902.16391-10-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250129095902.16391-1-adrian.hunter@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Several user ret MSRs are clobbered on TD exit.  Restore those values on
TD exit and before returning to ring 3.

Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TD vcpu enter/exit v2:
 - No changes

TD vcpu enter/exit v1:
 - Rename tdx_user_return_update_cache() ->
     tdx_user_return_msr_update_cache() (extrapolated from Binbin)
 - Adjust to rename in previous patches (Binbin)
 - Simplify comment (Tony)
 - Move code change in tdx_hardware_setup() to __tdx_bringup().
---
 arch/x86/kvm/vmx/tdx.c | 44 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e4355553569a..a0f5cdfd290b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -729,6 +729,28 @@ int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+struct tdx_uret_msr {
+	u32 msr;
+	unsigned int slot;
+	u64 defval;
+};
+
+static struct tdx_uret_msr tdx_uret_msrs[] = {
+	{.msr = MSR_SYSCALL_MASK, .defval = 0x20200 },
+	{.msr = MSR_STAR,},
+	{.msr = MSR_LSTAR,},
+	{.msr = MSR_TSC_AUX,},
+};
+
+static void tdx_user_return_msr_update_cache(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
+		kvm_user_return_msr_update_cache(tdx_uret_msrs[i].slot,
+						 tdx_uret_msrs[i].defval);
+}
+
 static bool tdx_guest_state_is_invalid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
@@ -784,6 +806,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 
 	tdx_vcpu_enter_exit(vcpu);
 
+	tdx_user_return_msr_update_cache();
+
 	kvm_load_host_xsave_state(vcpu);
 
 	vcpu->arch.regs_avail &= ~TDX_REGS_UNSUPPORTED_SET;
@@ -2245,7 +2269,25 @@ static bool __init kvm_can_support_tdx(void)
 static int __init __tdx_bringup(void)
 {
 	const struct tdx_sys_info_td_conf *td_conf;
-	int r;
+	int r, i;
+
+	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
+		/*
+		 * Check if MSRs (tdx_uret_msrs) can be saved/restored
+		 * before returning to user space.
+		 *
+		 * this_cpu_ptr(user_return_msrs)->registered isn't checked
+		 * because the registration is done at vcpu runtime by
+		 * tdx_user_return_msr_update_cache().
+		 */
+		tdx_uret_msrs[i].slot = kvm_find_user_return_msr(tdx_uret_msrs[i].msr);
+		if (tdx_uret_msrs[i].slot == -1) {
+			/* If any MSR isn't supported, it is a KVM bug */
+			pr_err("MSR %x isn't included by kvm_find_user_return_msr\n",
+				tdx_uret_msrs[i].msr);
+			return -EIO;
+		}
+	}
 
 	/*
 	 * Enabling TDX requires enabling hardware virtualization first,
-- 
2.43.0


