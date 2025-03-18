Return-Path: <kvm+bounces-41394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D9D2A677ED
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:33:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE7823BC577
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 15:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3744211A22;
	Tue, 18 Mar 2025 15:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nhPkzVsC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB971A5BBD;
	Tue, 18 Mar 2025 15:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742311886; cv=none; b=UWywBORQB7+OXrjA87KflkrMiRERgQmDOvscKBB09wDNT3AE6fWydmsJVRS2MIvORJ8edTmgXlPThbpzWtY+Dy5WgeSGVPXW+h6sxUuL1Z9ziThSXzowOraHDBYLErxVO5NM2SBbQcVdAWbQKAeMiyyOmQfwnElD0/d1L4UfSFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742311886; c=relaxed/simple;
	bh=LVoPauNoN9YJTCVXQmT71pckAtEqzejXxTzw3UGRIS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZpbdfwjONddAfpXtsk+Lf4oEWAUcx3GAk3gQCEMz2Ucv1sOCcDcQbwnrgYsb73de6EfHXk69rNnkCQVNQAObUWKMqH0yaf1gtoPGdZdETl4RgjTt6sZKsyh0CRyrAfwZ4TFIGv1k27CIMw3rz6slK8jHYz0PrcJt76459fee4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nhPkzVsC; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742311885; x=1773847885;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LVoPauNoN9YJTCVXQmT71pckAtEqzejXxTzw3UGRIS0=;
  b=nhPkzVsCTOCoZujy0ILctZlQ2sI6004w4D38FLMHR5EE5YRTfnQ6XsaD
   IOVis2YujYgXOA3xjmx0PEjIEVmJWsTnQkZhCth5EhmgXHv/P03k/s7dv
   kGpyohPV9UTtiGbkB2cpBA3PDAXyTBoJsCEeEkBCM0yWByUODeaUOPUrB
   W9GHlXZzwqwyIDRPoxVW1SIII6kOUORwk/HiN8h/YawgY0DEnKnRmUhbw
   TvKW79thrcmBUzukJ3UjghsLKhhse8RE8uYytjt+g4yJNXB2cO/+zWi1n
   s2jg2pCK9R4vBv0qsQuhHhf4pWVvwDckn+LlcYwPP6yvA7gzwQv+Cs813
   g==;
X-CSE-ConnectionGUID: 0pQ9OC/DTaykENJFxD9oCw==
X-CSE-MsgGUID: pakymEtVSyKYJp+icGgfCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="46224364"
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="46224364"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:31:24 -0700
X-CSE-ConnectionGUID: qOJUVvY6TzOuLYHUhPXUcQ==
X-CSE-MsgGUID: G57TWK+HTvGi+tSdoMTssA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="122122138"
Received: from spr.sh.intel.com ([10.239.53.19])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:31:19 -0700
From: Chao Gao <chao.gao@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	chang.seok.bae@intel.com,
	xin3.li@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Adamos Ttofari <attofari@amazon.de>,
	Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH v4 8/8] x86/fpu/xstate: Warn if guest-only supervisor states are detected in normal fpstate
Date: Tue, 18 Mar 2025 23:31:58 +0800
Message-ID: <20250318153316.1970147-9-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250318153316.1970147-1-chao.gao@intel.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

guest-only supervisor state bits should be __ONLY__ enabled for guest
fpstate, i.e., never for normal kernel fpstate. WARN_ONCE() if normal
kernel fpstate sees any of these features.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kernel/fpu/xstate.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 1418423bc4c9..f644647c0549 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -208,6 +208,8 @@ static inline void os_xsave(struct fpstate *fpstate)
 	WARN_ON_FPU(!alternatives_patched);
 	xfd_validate_state(fpstate, mask, false);
 
+	WARN_ON_FPU(!fpstate->is_guest && (mask & XFEATURE_MASK_SUPERVISOR_GUEST));
+
 	XSTATE_XSAVE(&fpstate->regs.xsave, lmask, hmask, err);
 
 	/* We should never fault when copying to a kernel buffer: */
-- 
2.46.1


