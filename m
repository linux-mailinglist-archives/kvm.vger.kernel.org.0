Return-Path: <kvm+bounces-31568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E0259C4F9E
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:39:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84B78B24CE6
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69D0F20D4E3;
	Tue, 12 Nov 2024 07:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WZMgCD/3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EF820B814;
	Tue, 12 Nov 2024 07:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397092; cv=none; b=Gg617zf61Tl0nuEcBWWeE/cCWsIBQE/YuIR7aoDJEaZjTxgMTBrAKz4M5MNUDbt4sAjei7pWOFFc2ww6YAnvtHCrhV8X2kA5MPYGynCX5Jzh5fzNn/6jc8uxHWdVOZkqbdNG3R/OYRKJNPXOpM1dck0/dmXXIzChxYNFUAP9Mw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397092; c=relaxed/simple;
	bh=wMpGoehg1J/B3n5jSNSrNlfUDzijvrljKuSJUktw21o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0/OKCYlucHosH8AvjR1vOpwtg/uVBjFfjGeZUcfTgIY5VRIbJoHjfvzR3rBSMNJ25mXB0yRbD9P/EY81YEbCHz7yVE87q6+S24q0VRGxoBe6Js22jkaPyBkjS448vmdgJMUusX+1oICD17G6lJ2B2ukb5SRYJ++pPkne+qG8Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WZMgCD/3; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397091; x=1762933091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wMpGoehg1J/B3n5jSNSrNlfUDzijvrljKuSJUktw21o=;
  b=WZMgCD/3LDUgUBgjYEmlrHT+vkvTYThnmaWZ0an1F4tRnG0a2LHr8+bY
   mZBNESsNRuEKYelfeafQm628x9IKe7z37yrLpGrCNWkriMoBVoPXeTAPW
   Z82lYMl7OsrEmcyVZ9V3y0LlQFA5VbHrB08GNS9IVboucw0wwkzSgb52V
   3+Dgi3CAV81Sow/DFyRFOfWQbVanH21fUFzrrfJyblXojywtPDQLPIkjs
   cK9kvzXZDDqDAEtJfNAm5Bc0YLd9GlE/cCxQGqoNRxguNr9NtcsXeLAVb
   ZhMSFmjuEiIAPT0FbvzTa5Kvdy665Rf+oFmddB2OncnZW1OoMPGZIuRQK
   w==;
X-CSE-ConnectionGUID: r2z7AeLQQ0CcB7a+QIUw2Q==
X-CSE-MsgGUID: OV1V894QTTSHzPfWqYXhFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="42598621"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="42598621"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:38:10 -0800
X-CSE-ConnectionGUID: ACOXBA0fQl+UndL2pYoT6Q==
X-CSE-MsgGUID: cjJW8phnTEepnbzucvUpnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="110595076"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:38:06 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 05/24] KVM: VMX: Teach EPT violation helper about private mem
Date: Tue, 12 Nov 2024 15:35:39 +0800
Message-ID: <20241112073539.22056-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Teach EPT violation helper to check shared mask of a GPA to find out
whether the GPA is for private memory.

When EPT violation is triggered after TD accessing a private GPA, KVM will
exit to user space if the corresponding GFN's attribute is not private.
User space will then update GFN's attribute during its memory conversion
process. After that, TD will re-access the private GPA and trigger EPT
violation again. Only with GFN's attribute matches to private, KVM will
fault in private page, map it in mirrored TDP root, and propagate changes
to private EPT to resolve the EPT violation.

Relying on GFN's attribute tracking xarray to determine if a GFN is
private, as for KVM_X86_SW_PROTECTED_VM, may lead to endless EPT
violations.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
TDX MMU part 2 v2:
 - Rename kvm_is_private_gpa() to vt_is_tdx_private_gpa() (Paolo)

TDX MMU part 2 v1:
 - Split from "KVM: TDX: handle ept violation/misconfig exit"
---
 arch/x86/kvm/vmx/common.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 78ae39b6cdcd..7a592467a044 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -6,6 +6,12 @@
 
 #include "mmu.h"
 
+static inline bool vt_is_tdx_private_gpa(struct kvm *kvm, gpa_t gpa)
+{
+	/* For TDX the direct mask is the shared mask. */
+	return !kvm_is_addr_direct(kvm, gpa);
+}
+
 static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 					     unsigned long exit_qualification)
 {
@@ -28,6 +34,9 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
 			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
+	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa))
+		error_code |= PFERR_PRIVATE_ACCESS;
+
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
-- 
2.43.2


