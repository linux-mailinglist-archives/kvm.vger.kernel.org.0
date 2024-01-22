Return-Path: <kvm+bounces-6620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15B678379E1
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:46:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48E951C26B4F
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0490605C5;
	Mon, 22 Jan 2024 23:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DZK8/+lm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D1960256;
	Mon, 22 Jan 2024 23:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967738; cv=none; b=Wix2rgQFH9oCWal0qTMkcAWaUzqoeg7v8hWVXUfe5paVzteL0bBsaJhk0jhwzJKU6V15xkERoIkfGMsxH98j0GGPUCBRwvKpEjWP1m/uLe8ERc+id/x6LyWdwG+pQ5POTWR1JqxF5I8V7bL93HPqVF2RSzzUox1JNDiESqwgip0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967738; c=relaxed/simple;
	bh=XbxLCw6iXi+/ZSpCUke3ciYl4z2W9JUfr59MqkX0L7w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r8F2NAI2Nbfn1uety0LivHgygOu6s8r+V2KPobFOgWaYngrPS9oz4ssVeXPk1d79mYLdWOi/SCVcKONm2ZDtbaTnFHpSqas1Eh9IE2bv0QmgFDSaPT6SmDE21RigYjxqxOao2vfU/HsToAK36D4Ytob2KOckLDwe0Hqy1qTEJfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DZK8/+lm; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967738; x=1737503738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XbxLCw6iXi+/ZSpCUke3ciYl4z2W9JUfr59MqkX0L7w=;
  b=DZK8/+lmsgikIlv+S7OIW1wMjMNoCwFv2TVWc1TVpr4vsb2633aKQjNR
   F7eFt6fiob3T/yNSLRjX7GHXHkPkgPX94hBxJruyAh3rTqEbmKNJmvGhY
   YcEPj4oMECrneO7AFAb9PqjMV7laV4CjrSiBVZvLO4Ym43doPVnTacHNV
   TIcturR5YkgucPYkvBnEBA/O7v1L65OTc7UX2/i4gNNR7FhjpBb7Ok5k0
   S8e/JulJOMd+sC00YdumBy0xQkdxCI9GsTynnAc9B67Flx6q33ner+t4q
   0uLxUHGHofEw5WFh0Rwqez3uPEnK23liJWdm8Utrzgp3wwtrBroaa4PN9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016394"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016394"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468131"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:32 -0800
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
Subject: [PATCH v18 050/121] KVM: x86/tdp_mmu: Sprinkle __must_check
Date: Mon, 22 Jan 2024 15:53:26 -0800
Message-Id: <8f7d5a1b241bf5351eaab828d1a1efe5c17699ca.1705965635.git.isaku.yamahata@intel.com>
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

TDP MMU allows tdp_mmu_set_spte_atomic() and tdp_mmu_zap_spte_atomic() to
return -EBUSY or -EAGAIN error.  The caller must check the return value and
retry.  Sprinkle __must_check to guarantee it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index fdc6e2221c33..2aacfab25e93 100644
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


