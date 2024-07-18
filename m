Return-Path: <kvm+bounces-21899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4DF7935310
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:17:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 528741F21507
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A43114A62E;
	Thu, 18 Jul 2024 21:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UJ1GBcgn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A5F149C70;
	Thu, 18 Jul 2024 21:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337177; cv=none; b=mp60Cd6+Q62Fi8Efs0oOUy8CQKs9gumGE/JcSIrR6oiAC9zWf/f5mJqMJ7w5cwRhft3Z+jvb3LerNYIcP6Brvfxiu8wht8Ije2rOti66TlS618A6A6AWxIq5wSXpe2zrwPmwRI8YwHIbQdKAbvM4QF6xjKTePmL2Jd3gOrH5HWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337177; c=relaxed/simple;
	bh=AKxlZs6v/6XIO+vxKXJVP3JXsqABU0Ig9aw4VXt/5Wg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OJTEfMYAc75I7yJl0sSWJ13nsbPovKkNa3RuCGJc3JO6yLpk0/QyMlJxn1Eo4+9kEChI2MxKiRHORKoalfNKFRNf30LKCR0YmDbb4wfjKExfrNu1h0NKD/yyP30+qeCNqRQ8NLpbL6ugdbp95JAkBD3oZfCzI/tBHqv4TAkWAlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UJ1GBcgn; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337176; x=1752873176;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AKxlZs6v/6XIO+vxKXJVP3JXsqABU0Ig9aw4VXt/5Wg=;
  b=UJ1GBcgnGKUS6FVtj/C5Q+DeHecrJlJSZtogqRqhzLO4BBn5X4mLs7Hh
   IgKX04LAjAX4CN0th6KDcLvWih6aqD2I+8ogaL+GiN+jlX9CwJuWlJhSN
   EwT3zQDppwz6sxPjalRZyWjYIUU/VHc1EeVIls/RVMUrk3zQosMOVTJBW
   Oqgjrkno9+VaJR5E2PcYJ+IlXoqfBukeGa1JgytFHWhBq4lrn++vgWyP8
   yUIouRQjcZxOPXIZPGkNABIxBr1gmaIKGRVRaQ4rsUWveN999e9yMx4cv
   VEIGTUwTXNgLJRHw+sCurxcW26gVXbCzJzk8Xvrt5eK8T67bOF4jLOlh7
   A==;
X-CSE-ConnectionGUID: QLUjLxYGQWeuq6eq6c2luw==
X-CSE-MsgGUID: CopkzVvbQZetRZWF0VEocQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697479"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697479"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:52 -0700
X-CSE-ConnectionGUID: mD75KTJVQ8+BsDnj+Gr3gw==
X-CSE-MsgGUID: D6XuAqgKROawyXDz/MsKVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760433"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:52 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	erdemaktas@google.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	sagis@google.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v4 17/18] KVM: x86/tdp_mmu: Don't zap valid mirror roots in kvm_tdp_mmu_zap_all()
Date: Thu, 18 Jul 2024 14:12:29 -0700
Message-Id: <20240718211230.1492011-18-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
References: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't zap valid mirror roots in kvm_tdp_mmu_zap_all(), which in effect
is only direct roots (invalid and valid).

For TDX, kvm_tdp_mmu_zap_all() is only called during MMU notifier
release. Since, mirrored EPT comes from guest mem, it will never be
mapped to userspace, and won't apply. But in addition to be unnecessary,
mirrored EPT is cleaned up in a special way during VM destruction.

Pass the KVM_INVALID_ROOTS bit into __for_each_tdp_mmu_root_yield_safe()
as well, to clean up invalid direct roots, as is the current behavior.

Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v4:
 - New patch
---
 arch/x86/kvm/mmu/tdp_mmu.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2f3ba9d477e9..465c9fdb3301 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1044,19 +1044,23 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	struct kvm_mmu_page *root;
 
 	/*
-	 * Zap all roots, including invalid roots, as all SPTEs must be dropped
-	 * before returning to the caller.  Zap directly even if the root is
-	 * also being zapped by a worker.  Walking zapped top-level SPTEs isn't
-	 * all that expensive and mmu_lock is already held, which means the
-	 * worker has yielded, i.e. flushing the work instead of zapping here
-	 * isn't guaranteed to be any faster.
+	 * Zap all roots, except valid mirror roots, as all direct SPTEs must
+	 * be dropped before returning to the caller. For TDX, mirror roots
+	 * don't need handling in response to the mmu notifier (the caller) and
+	 * they also won't be invalid until the VM is being torn down.
+	 *
+	 * Zap directly even if the root is also being zapped by a worker.
+	 * Walking zapped top-level SPTEs isn't all that expensive and mmu_lock
+	 * is already held, which means the worker has yielded, i.e. flushing
+	 * the work instead of zapping here isn't guaranteed to be any faster.
 	 *
 	 * A TLB flush is unnecessary, KVM zaps everything if and only the VM
 	 * is being destroyed or the userspace VMM has exited.  In both cases,
 	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
 	 */
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	for_each_tdp_mmu_root_yield_safe(kvm, root)
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, -1,
+					   KVM_DIRECT_ROOTS | KVM_INVALID_ROOTS)
 		tdp_mmu_zap_root(kvm, root, false);
 }
 
-- 
2.34.1


