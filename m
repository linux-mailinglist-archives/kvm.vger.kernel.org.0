Return-Path: <kvm+bounces-47828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1529CAC5CC4
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 00:05:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CFE81BC173A
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 22:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4960216392;
	Tue, 27 May 2025 22:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VDRSrObS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FB01F63C1;
	Tue, 27 May 2025 22:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748383507; cv=none; b=W1iw029NeLWMvNstO+Kqa5MvySK5dAmcz/nCl7TmXFYhshJP01aRIsHY254acyhism1YDCY09JNIx8vMBidYUDKhEQI1DQUjaROQTsHzqWwxlaKqHXkm/4T2hzu6HPi037AWraaIZiOcEEorbAT0jtJ3yGnGcwJ3VxTXGqikgK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748383507; c=relaxed/simple;
	bh=oSRAwBLVtyo7MIa7mWnSvmOppYtBygtu0bkYdFD9SZg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kh7XP3hvCJJjFuEnJlchIWNZ7/kVsGqqcQ4MMzhfKOIV6wVw5gbu7aBjjdsGUaOHcw5AfiajUxdDnq6WFk37XCgHfn+5qqoEcntuqUwHeKbZNiSIxvOiKwvh8pLzJQYOSC70U1exsMNPWx3j9aIFNC6SIUAbCnD05Jexe4fmU1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VDRSrObS; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748383506; x=1779919506;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oSRAwBLVtyo7MIa7mWnSvmOppYtBygtu0bkYdFD9SZg=;
  b=VDRSrObSpZT93zx0VqATrW+N6tRKozhmHLILDRlyvUb97Qq7z3TvMPuk
   Ng2HZ2swWEix//Kb2y3Rh4prVm5BVPumpS3um3a73aFi9PF4JvjUpQlA8
   zrT76GqV2i1I6PktW4LwwcHkeKJH3iocq9AjWdMn8l9/6edafpBt9mJFD
   TY26SVYXqkm9cXBN5bMnR6l+YEqoSD7j2julWpg+R3EDkMlXbZxbYB7+k
   ntNnlf7Xik1DLR5+pWj5hEuv3bV54iav8/yH8uF3pEb/BQOdisV0amX/S
   7klKzrk8z4lITHuIfRDmOu+GI/dUNuS3zUHq6fjLO23E2z7geVs8Ov9uc
   w==;
X-CSE-ConnectionGUID: J61LZUnsSTWSFU2PAxXMwA==
X-CSE-MsgGUID: vDPUdB1UQSaWFEy2Q+pOQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11446"; a="54190106"
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="54190106"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 15:05:05 -0700
X-CSE-ConnectionGUID: vN2U/7HCRkmKRQoDU70FuQ==
X-CSE-MsgGUID: RbdNF3YxT5ed0VBlicVDHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="173973947"
Received: from lbogdanm-mobl3.ger.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.92])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 15:05:04 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lkp@intel.com,
	xiaoyao.li@intel.com,
	kai.huang@intel.com,
	seanjc@google.com,
	x86@kernel.org,
	dave.hansen@intel.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH] x86/tdx: Always inline tdx_tdvpr_pa()
Date: Tue, 27 May 2025 15:04:53 -0700
Message-ID: <20250527220453.3107617-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In some cases tdx_tdvpr_pa() is not fully inlined into tdh_vp_enter(),
which causes the following warning:

  vmlinux.o: warning: objtool: tdh_vp_enter+0x8: call to tdx_tdvpr_pa() leaves .noinstr.text section

tdh_vp_enter() is marked noinstr and so can't accommodate the function
being outlined. Previously this didn't cause issues because the compiler
inlined the function. However, newer Clang compilers are deciding to
outline it.

So mark the function __always_inline to force it to be inlined. This
would leave the similar function tdx_tdr_pa() looking a bit asymmetric
and odd, as it is marked inline but actually doesn't need to be inlined.
So somewhat opportunistically remove the inline from tdx_tdr_pa() so that
it is clear that it does not need to be inlined, unlike tdx_tdvpr_pa().

tdx_tdvpr_pa() uses page_to_phys() which can make further calls to
outlines functions, but not on x86 following commit cba5d9b3e99d
("x86/mm/64: Make SPARSEMEM_VMEMMAP the only memory model").

Fixes: 69e23faf82b4 ("x86/virt/tdx: Add SEAMCALL wrapper to enter/exit TDX guest")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505240530.5KktQ5mX-lkp@intel.com/
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
---
Previous discussion here:
https://lore.kernel.org/kvm/20250526204523.562665-1-pbonzini@redhat.com/

FWIW, I'm ok with the flatten version of the fix too, but posting this
just to speed things along in case.

And note, for full correctness, this and the flatten fix will depend on
the queued tip commit:
https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?id=cba5d9b3e99d6268d7909a65c2bd78f4d195aead

---
 arch/x86/virt/vmx/tdx/tdx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f5e2a937c1e7..626cc2f37dec 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1496,12 +1496,12 @@ void tdx_guest_keyid_free(unsigned int keyid)
 }
 EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
 
-static inline u64 tdx_tdr_pa(struct tdx_td *td)
+static u64 tdx_tdr_pa(struct tdx_td *td)
 {
 	return page_to_phys(td->tdr_page);
 }
 
-static inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
+static __always_inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
 {
 	return page_to_phys(td->tdvpr_page);
 }
-- 
2.49.0


