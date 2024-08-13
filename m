Return-Path: <kvm+bounces-23936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C084594FD17
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 07:11:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A65C1F23757
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 05:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E8D73B791;
	Tue, 13 Aug 2024 05:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NlTpE8KM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0522C1B4;
	Tue, 13 Aug 2024 05:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723525874; cv=none; b=F1vdVLkI9y7grHipPSOamH6MpyE5fVKfJW37KSESLZla/tzC6QRlg+vL9+N96TyiflOeJvWjSI5ja3UGlE0VSi2g8v1qxD5pElYDZPQX6fsyMFaQiUJ1sSSs3WnyAsdGkk/nkKCmmwbULY71SDmgeLBFZCxInA6gZQ/hpcpY+KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723525874; c=relaxed/simple;
	bh=/vFPHBrWVREVrxVvybhiICqrmR52uum2HVoSt9oKWQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioqNH/yGUK5ze1GPha108RSYUIKmVycxstOanng4iugT6he/SbGeFO3hk79cnvYAQPHWKlv36jB07mBPj58eeAGPB/CTqC3Od7MT+O+4tSy40uJ7RF/BlpHkyhpPVycOAHpK4sEPw41ak/NSN6rlYooW9zw5/ZO9kwGJE5sS8vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NlTpE8KM; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723525873; x=1755061873;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/vFPHBrWVREVrxVvybhiICqrmR52uum2HVoSt9oKWQg=;
  b=NlTpE8KMFnVLx8rD1r0UTd2IslgrZD9Aejd+md5CpTu1AvWzr3p+amop
   AgX8YNIpga1liV+UnnHWBQcQJ7cNT7gETUH18NG0He4r9C/T3+UdXgWO/
   Fk+mYbe9+8YTeDu7pR++ryCmtA9l8If3nFv5e0CtnrK39PjldOWeWWVXm
   wIgyIfJQDTc8xPD17EnpjYAI4yvEwjzWBuVM/h34j1dyKgxOrOyBisQbq
   HPb/bb+yq9Qg11YwPwRrVmaeS8WPVbEI/XeTdCLmTg3EJjJ1JBOwO0NWQ
   ycjTxO+/w1Gocd9+6o57USdMCE9XP/JfHVyAg5CIP91SFXUNuFNPLXgf+
   g==;
X-CSE-ConnectionGUID: 91yX03gtRv6rX1M+dU8NLw==
X-CSE-MsgGUID: YglIFaqEQbWjcGgZBwPdyQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="32239371"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="32239371"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 22:11:12 -0700
X-CSE-ConnectionGUID: pnYBqBApSMOnek8v1BJK6w==
X-CSE-MsgGUID: agJbRv1LS2uorvsSK8gvmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="58185533"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 22:11:09 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com,
	michael.roth@amd.com,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 2/2] KVM: x86: Use is_kvm_hc_exit_enabled() instead of opencode
Date: Tue, 13 Aug 2024 13:12:56 +0800
Message-ID: <20240813051256.2246612-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use is_kvm_hc_exit_enabled() instead of opencode.

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 arch/x86/kvm/x86.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a16c873b3232..d622aab8351d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3635,7 +3635,7 @@ static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
 		return 1; /* resume guest */
 	}
 
-	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
+	if (!is_kvm_hc_exit_enabled(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
 		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
 		return 1; /* resume guest */
 	}
@@ -3718,7 +3718,7 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
 	bool huge;
 	u64 gfn;
 
-	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
+	if (!is_kvm_hc_exit_enabled(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
 		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
 		return 1;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6e16c9751af7..9857c1984ef7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10171,7 +10171,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 		u64 gpa = a0, npages = a1, attrs = a2;
 
 		ret = -KVM_ENOSYS;
-		if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE)))
+		if (!is_kvm_hc_exit_enabled(vcpu->kvm, KVM_HC_MAP_GPA_RANGE))
 			break;
 
 		if (!PAGE_ALIGNED(gpa) || !npages ||
-- 
2.43.2


