Return-Path: <kvm+bounces-6618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAA368379EA
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:46:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62E4D283B39
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB17760272;
	Mon, 22 Jan 2024 23:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U1/Ucmm5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93165FEF9;
	Mon, 22 Jan 2024 23:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967737; cv=none; b=dmqz/8xU9dUyb4Pgf9b55mnteAJVAX5b1Zi6JDpg47b0TXzfBNecuKfVc7gW/InOeR4Hkiw1On8ZimOz1rVfBRUQah0T1VJHtZw2XQ7YVGie5uZHP1XEUiHEcXeAlZOqczGeYwzGjzvq/SunMb8+cSRNTYC34aZdrD92v2OIRik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967737; c=relaxed/simple;
	bh=2mvBgTwpdWt/PzjwOyjHQ0MI5GiwmKCv6Q/+g/Yz7lo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N880uRm5Vr0fmalFEdErYLE8J+b/X9/6hOL4sAwAD6HI7/FjhY31ybJwy+OTAtRIA9PIqwV1Tgt4Wl0Bj2ukbn8D/o9sydzdcYB5LXjoA+Mb5OSQwxgogFodwviLoaxr+ZQYu2r7VFmPHVgLm78Ss2DkpN2HH8jaAK6/7cFR2zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U1/Ucmm5; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967736; x=1737503736;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2mvBgTwpdWt/PzjwOyjHQ0MI5GiwmKCv6Q/+g/Yz7lo=;
  b=U1/Ucmm5BVKkiO+LB8ytqSQsiMDYePZnfWhN7xcgMWY1xXpueF0MdOlt
   ov8dLf4RBqrlz/jf1AphNlWHJn/bo2mIRMel12NrmWY5ZLeYVDCBaYo3G
   FD1spFPbFiG4YhvHmbMTcDp/2xdQxNMYuBaWbfHcikaFJBpGbH+gEY9L3
   83cgV0ELxyE6a26N4u/lSHj661L67JPvblDeMgYWq/KWucwxNxMH2Da64
   gsZ5lVVluILJHi4j6RCbAc/Oe5QY8lU2msxvyRZrs66nCh49iC/57m3Og
   sZGAHefVsaNLkBFVIRGg4is3qtZm9rYsqXyARJ8zdsvdlS66JfHtsSUK0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016390"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016390"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468123"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:31 -0800
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
	tina.zhang@intel.com
Subject: [PATCH v18 049/121] KVM: x86/tdp_mmu: Apply mmu notifier callback to only shared GPA
Date: Mon, 22 Jan 2024 15:53:25 -0800
Message-Id: <9f64fe39a205b769bf08f2996efb0b5afc6c1900.1705965635.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

The private GPAs that typically guest memfd backs aren't subject to MMU
notifier because it isn't mapped into virtual address of user process.
kvm_tdp_mmu_handle_gfn() handles the callback of the MMU notifier,
clear_flush_young(), clear_young(), test_gfn() and change_pte().  Make
kvm_tdp_mmu_handle_gfn() aware of private mapping and skip private mapping.

Even with AS_UNMOVABLE set, those mmu notifier are called.  For example,
ksmd triggers change_pte().

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v18:
- newly added
---
 arch/x86/kvm/mmu/tdp_mmu.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e7514a807134..fdc6e2221c33 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1157,9 +1157,29 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 	 * into this helper allow blocking; it'd be dead, wasteful code.
 	 */
 	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
+		gfn_t start, end;
+
+		/*
+		 * This function is called on behalf of mmu_notifier of
+		 * clear_flush_young(), clear_young(), test_gfn(), and
+		 * change_pte().  They apply to only shared GPAs.
+		 */
+		WARN_ON_ONCE(range->only_private);
+		WARN_ON_ONCE(!range->only_shared);
+		if (is_private_sp(root))
+			continue;
+
+		/*
+		 * For TDX shared mapping, set GFN shared bit to the range,
+		 * so the handler() doesn't need to set it, to avoid duplicated
+		 * code in multiple handler()s.
+		 */
+		start = kvm_gfn_to_shared(kvm, range->start);
+		end = kvm_gfn_to_shared(kvm, range->end);
+
 		rcu_read_lock();
 
-		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
+		tdp_root_for_each_leaf_pte(iter, root, start, end)
 			ret |= handler(kvm, &iter, range);
 
 		rcu_read_unlock();
-- 
2.25.1


