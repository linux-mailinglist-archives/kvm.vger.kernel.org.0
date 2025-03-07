Return-Path: <kvm+bounces-40359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56A48A56E0E
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:41:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 183D5167A68
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D93242459C3;
	Fri,  7 Mar 2025 16:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cTImjqV1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2B92459C0;
	Fri,  7 Mar 2025 16:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365566; cv=none; b=Z6WFGMjXxsfrA0NQUug+25t58nz9s1U2ZYHFBaAmsiw2uFjNoWwF3Swwg3Om62P4mGrd/0c/KLhoWk6R0sAcDoaP5Y8UDhnzlB/cBmQMH2oEMYqA41piQt9kkz7qO3zZ4DdD1rgFkJbMd2TkXXhco/L2N+biLXBRFRTkxdV/SWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365566; c=relaxed/simple;
	bh=X4xuzp/N/cz6sQP/VWh9/G4Yy55wbtWxPC/0J7I4lRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGNN6k3j+PoR3vVHbXpUGdMx9MaXobLYqECWaVHbvc2gySTihZmGnzRBDNEUlGSOOmsZL5KIdhqwZudyNNQLDHrjFXhTKMe86wVg+JFqhuby7P41gEFpCg9ddJNRe1xqSo8kMptmZ/XSAaonKWoyPl+wOeQ2SBjRazgQ2V/LxMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cTImjqV1; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741365564; x=1772901564;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X4xuzp/N/cz6sQP/VWh9/G4Yy55wbtWxPC/0J7I4lRc=;
  b=cTImjqV16I3C6PqysCi0PyDuU8R1Orne5fHGJkOCMt/ibzsyP/FPw7A5
   X7YzvEq6v2rzeAj4oihM8l1WMNNrBjAQCb6hl7uxFI6fCZJpzrzVipq33
   m89iTwpZbuGuga4MNUvyy/oAAml0YcdFZuVb2tLqu3TOkFBaw7VoOEBgc
   JnchH7st4PqQQNs3aMGC8OsiOKRY/RQCRCjRp0ADz3Ltuy6RJlhPVcOeU
   Wc3v3aT4feNmHQvIntQ+ilMP/wT3iDI7Q33pBhZeaqPm498VG4+s2TYpF
   senYKMtEGE2jNZ8k5iq4rmtVNm+hG8qWIngqtgu16MQjH1uq+5lmtZgnU
   A==;
X-CSE-ConnectionGUID: X0loT+B9SyqMVqs1nPmigQ==
X-CSE-MsgGUID: n2niRv29TmWUlCKS2WrEWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46344484"
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="46344484"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:24 -0800
X-CSE-ConnectionGUID: N0O6DtYQS2Cydw31vqnyow==
X-CSE-MsgGUID: IP6nfA3ZQ2K3WD8m23fAmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="124397993"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:21 -0800
From: Chao Gao <chao.gao@intel.com>
To: chao.gao@intel.com,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de
Subject: [PATCH v3 09/10] x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Date: Sat,  8 Mar 2025 00:41:22 +0800
Message-ID: <20250307164123.1613414-10-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250307164123.1613414-1-chao.gao@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Define a new XFEATURE_MASK_KERNEL_DYNAMIC mask to specify the features
that can be optionally enabled by kernel components. This is similar to
XFEATURE_MASK_USER_DYNAMIC in that it contains optional xfeatures that
can allows the FPU buffer to be dynamically sized. The difference is that
the KERNEL variant contains supervisor features and will be enabled by
kernel components that need them, and not directly by the user. Currently
it's used by KVM to configure guest dedicated fpstate for calculating
the xfeature and fpstate storage size etc.

Kernel dynamic features are enabled for the guest FPU and disabled for
the kernel FPU, effectively making them guest-only features.

Set XFEATURE_CET_KERNEL as the first kernel dynamic feature, as it is
required only by the guest FPU for the upcoming CET virtualization
support in KVM.

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
I am tempted to rename XFEATURE_MASK_KERNEL_DYNAMIC to
XFEATURE_MASK_GUEST_ONLY. But I am not sure if this was discussed
and rejected.
---
 arch/x86/include/asm/fpu/xstate.h | 5 ++++-
 arch/x86/kernel/fpu/xstate.c      | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index 8990cf381bef..f342715d204b 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -42,9 +42,12 @@
 #define XFEATURE_MASK_USER_RESTORE	\
 	(XFEATURE_MASK_USER_SUPPORTED & ~XFEATURE_MASK_PKRU)
 
-/* Features which are dynamically enabled for a process on request */
+/* Features which are dynamically enabled per userspace request */
 #define XFEATURE_MASK_USER_DYNAMIC	XFEATURE_MASK_XTILE_DATA
 
+/* Features which are dynamically enabled per kernel side request */
+#define XFEATURE_MASK_KERNEL_DYNAMIC	XFEATURE_MASK_CET_KERNEL
+
 /* All currently supported supervisor features */
 #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
 					    XFEATURE_MASK_CET_USER | \
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 12613ebdbb5d..e5284e67dfec 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -826,6 +826,7 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	/* Clean out dynamic features from default */
 	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
 	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
+	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_KERNEL_DYNAMIC;
 
 	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
 	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
-- 
2.46.1


