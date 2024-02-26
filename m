Return-Path: <kvm+bounces-9686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F5AA866CDA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:47:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 28772B25120
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C09F626BB;
	Mon, 26 Feb 2024 08:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KrnSeZr8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E234B60BA8;
	Mon, 26 Feb 2024 08:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936105; cv=none; b=IkydHhxru7tIZWsZuhWJUefonMLI+liBkZKfT07A12/qdWfaa7lpbDdnfLHV72VYROwCnwtEJfcrEKN0ATYdTUMBJuHs66ko++F0nM72yMFLN9D9ZwQgwW4cXxvMcRjzFJG6ChqGLR8uktGHOZJYKiXaeDMXEpzjSxI1Xq1nNRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936105; c=relaxed/simple;
	bh=WUIyQRqsBA8fWp2BC5BUSOmDMUGqWMDNMhmPzCSRUbg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eeCNVLuXTMFnHMnPioKHkvI7sE3on+rV+NbAc0a0q0vAzmPRQF7JDkinIHycPrQ2xgsadqUFWmjAwqzZPPNz8aZgZ22WT6IJpRIh4nkzx3YJVHXfbAcGdkM2DapbP3jxO++JyLWuwZQF/3frECMLFNeJjxTWHghCvokQq+6j+6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KrnSeZr8; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936104; x=1740472104;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WUIyQRqsBA8fWp2BC5BUSOmDMUGqWMDNMhmPzCSRUbg=;
  b=KrnSeZr8iGAXQOUuWkSiDSSnLKeXAg3QWYR8v2GOKnm+ZhWVBcZw3w/y
   2azjPk+/luaTKbJJ+mbOfqzUH39tb4P4f8DOPhiYpmpR0yM5o/OiaaVwy
   a0rGN466rSN9K8Ze98XrQhIJf5OcKsErN7BrZrN5Pc7qNryUPT/Zozg0T
   q0D+kQfnNEXO668VTQcxEdMKbFfOeduqGcEqyBYXjo7m6Pj7+WRqrLTX8
   1o9KMHPjNR1iVuBbzaM1wcBZqQ0NNvihBdiZ+id4ycQ4wwZo+QLidUUsd
   KWdUJZZaKDs6p/fmwjRZuMcbZfBAHtmUK94SMLnEAgVqEINH2P7P7kcKB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155447"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155447"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615914"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:19 -0800
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
Subject: [PATCH v19 061/130] KVM: x86/tdp_mmu: Sprinkle __must_check
Date: Mon, 26 Feb 2024 00:26:03 -0800
Message-Id: <6dd201694cf2ce7f866e0634c3113db7a9024f8b.1708933498.git.isaku.yamahata@intel.com>
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

TDP MMU allows tdp_mmu_set_spte_atomic() and tdp_mmu_zap_spte_atomic() to
return -EBUSY or -EAGAIN error.  The caller must check the return value and
retry.  Sprinkle __must_check to guarantee it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
--
v19:
- Added Reviewed-by: Binbin
---
 arch/x86/kvm/mmu/tdp_mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 10507920f36b..a90907b31c54 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -507,9 +507,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
  *            no side-effects other than setting iter->old_spte to the last
  *            known value of the spte.
  */
-static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
-					  struct tdp_iter *iter,
-					  u64 new_spte)
+static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
+						       struct tdp_iter *iter,
+						       u64 new_spte)
 {
 	u64 *sptep = rcu_dereference(iter->sptep);
 
@@ -539,8 +539,8 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	return 0;
 }
 
-static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
-					  struct tdp_iter *iter)
+static inline int __must_check tdp_mmu_zap_spte_atomic(struct kvm *kvm,
+						       struct tdp_iter *iter)
 {
 	int ret;
 
-- 
2.25.1


