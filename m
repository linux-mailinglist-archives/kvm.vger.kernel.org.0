Return-Path: <kvm+bounces-9685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F220866CD3
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:47:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B75BF281DA2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0076169B;
	Mon, 26 Feb 2024 08:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l2Z44U/U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BEA60876;
	Mon, 26 Feb 2024 08:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936105; cv=none; b=sGhgyqEdFUf8lWb7lOV77o+02SbrUKwPdJtp/cW9WLAoMPYBQs/QSmrVrc8v9XruHABGFOvqP02GRH8qb15y7LoG3/H5OzC1e+cPMp3S/Waah4Yh0W4PuvqwbS1NJhH2AS946qZqKgVB67x4JR9lsG1FP01p09CG/ijyH/K+OVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936105; c=relaxed/simple;
	bh=JTMod/uEmH5xtpRfr6dh/AqM/hDApc2nFe1BtZqLSW4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qmkJLLocgZ0XIpEJcN+G4fUDMZJTZGWnM2St24jtGUGzzEOkX/QBIm3bskK/hllzxkFrx36De0wuyB6GocyxfAxA5uxRkIF51Z1++NEE/9KeEpsWoL8CnCJtUEFWeZn2fM6shm5ZZy9DPcXYc3Rq4h8TDoXXgatefOsf0RJT6fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l2Z44U/U; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936103; x=1740472103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JTMod/uEmH5xtpRfr6dh/AqM/hDApc2nFe1BtZqLSW4=;
  b=l2Z44U/URH/LRmIQ0ckFvOKQ6Lej7k8IXtDGoTHnQ01PVXyma/zelY/U
   daFBvg8qSpMGN4QlU/5APDZRApfa9/a25p+uLwH8TNsoqVWQ2KHYZWt39
   0SZpnRgiI+5Q8MCbjw3p9GvweEVq6inR1bHn0K2LEHv2QS1Ao5BVb3Msq
   NpHVEzQ2+YCJPxnuAQ7XwdDiZkJarOLh4g9yJ62Fkl6XsoIQDyBR7QeUN
   XGMosTlpZud4fOIM9n23tHbJ0Cz9ezhVG7nhuZjjlJBRti34eSMHt1RYA
   imdZOZd1hMqvDZ4mxN/rSbu5iJjWUuVTc1YwLULC/CAMHorFh+IA358ex
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155436"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155436"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615905"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:18 -0800
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
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v19 060/130] KVM: x86/tdp_mmu: Apply mmu notifier callback to only shared GPA
Date: Mon, 26 Feb 2024 00:26:02 -0800
Message-Id: <dead197f278d047a00996f636d7eef4f0c8a67e8.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
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
clear_flush_young(), clear_young(), test_young()() and change_pte().  Make
kvm_tdp_mmu_handle_gfn() aware of private mapping and skip private mapping.

Even with AS_UNMOVABLE set, those mmu notifier are called.  For example,
ksmd triggers change_pte().

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
v19:
- type: test_gfn() => test_young()

v18:
- newly added

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e7514a807134..10507920f36b 100644
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
+		 * clear_flush_young(), clear_young(), test_young()(), and
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


