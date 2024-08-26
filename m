Return-Path: <kvm+bounces-25022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E185C95E6AC
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 04:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F76A281652
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 02:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D76432D052;
	Mon, 26 Aug 2024 02:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WMT5VopW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8803B1119A;
	Mon, 26 Aug 2024 02:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724638878; cv=none; b=BbxESQQAh2XqgzoEY4dLDvEAoIQ6vNSD7EeGEBfPZ+hNLfHWo7fLRksZH+2CP/IxMh25yZ7URLvivr7wWsjPAIGNeLyLx0PauoBnXVGqPztCSHd49/ijj92Q1lKpPqh8fzWarPMwAj8dEfMWd9YhL1wwhbUrKly205P+op67ly4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724638878; c=relaxed/simple;
	bh=zwKP1TfpkDPqv5+F3ezCyw1T2c5N24g3EVi+MC5aFhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzfSjgQ3J/bsPFaay2kpFt0Z3wWJXOimQlins/BwGwKoGCdMiYEPx55djLSTvPs/bOBLJEoyltqAxgW6uBEDcR2aybk6dWPNhbqLh7Ig/1SB3FSsSe2t4bJ7JjikNSKSyRomKkByj46cpyLJTd1HK88r0qpNopyelO7RVPtplac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WMT5VopW; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724638876; x=1756174876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zwKP1TfpkDPqv5+F3ezCyw1T2c5N24g3EVi+MC5aFhw=;
  b=WMT5VopWjZEBiI7Rc/hDGOEwYKOSe6sOKyDJIFyJ6Js1mYXoxv/Y9Kkd
   dw4f6ofdb03PtPCiXRswedAqj0AmeekTWvKmXhJ69JA8b6JnSg9QeuQjO
   drHmrtEQlBMYsjneSmThyA83+ljfUi8rlfxgcwFQ6hWjymleyg9OYj9L+
   84uxIsU1PD8deWmJdiVxlXZUKBs2zjn67aUv1fLpkmBdcuHpe8RtPS52n
   MpLLCNwUchwvNEgvZBWKn+02YCmJILyjKtkrnMtHqYjjeDfZ1RRquywoT
   gIpIhm+C3KI3h9v0mCocnf65V+USnizLERJRet0GejE9srt11oURG2hzt
   Q==;
X-CSE-ConnectionGUID: JWE+HA4uQQezK1oA1w80mA==
X-CSE-MsgGUID: u5bKLlrgRJ+ITFxuKoAbXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11175"; a="23207997"
X-IronPort-AV: E=Sophos;i="6.10,176,1719903600"; 
   d="scan'208";a="23207997"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2024 19:21:16 -0700
X-CSE-ConnectionGUID: nPl52zwGTYWXV+WuFfQbYA==
X-CSE-MsgGUID: J6r/5EVzTqCKsticZajTyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,176,1719903600"; 
   d="scan'208";a="62336553"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2024 19:21:14 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	yuan.yao@linux.intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com
Subject: [PATCH v3 2/2] KVM: x86: Use user_exit_on_hypercall() instead of opencode
Date: Mon, 26 Aug 2024 10:22:55 +0800
Message-ID: <20240826022255.361406-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240826022255.361406-1-binbin.wu@linux.intel.com>
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use user_exit_on_hypercall() instead of opencode.

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 arch/x86/kvm/x86.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 714c517dd4b7..9b3d55474922 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3637,7 +3637,7 @@ static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
 		return 1; /* resume guest */
 	}
 
-	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
+	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
 		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
 		return 1; /* resume guest */
 	}
@@ -3720,7 +3720,7 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
 	bool huge;
 	u64 gfn;
 
-	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
+	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
 		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
 		return 1;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e521f14ad2b2..c41ba387cc8c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10165,7 +10165,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 		u64 gpa = a0, npages = a1, attrs = a2;
 
 		ret = -KVM_ENOSYS;
-		if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE)))
+		if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE))
 			break;
 
 		if (!PAGE_ALIGNED(gpa) || !npages ||
-- 
2.46.0


