Return-Path: <kvm+bounces-37552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0154A2B980
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 04:11:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17BDC1889A06
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 03:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07CCA189520;
	Fri,  7 Feb 2025 03:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V2WdRQOn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997F215B99E;
	Fri,  7 Feb 2025 03:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738897839; cv=none; b=aseIYIySadc4zYNtN0jP2KywkLiXT++qlnQ7a9+mHlmuxoPq6IU+iWWywa48yHC0ML7SVmxHMm3xiLKSz7OaJz5S0SCXqMGUzbrq0GWtMAaa7nBWty8sx3bLIySzMHyirsbe/S/LeiAS3RoZfnBCAqQkBcGAQgCOci317mO/hGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738897839; c=relaxed/simple;
	bh=i49YZ8XKMLB6OSNTyXAHmqR6isI1HtHi4zigGDW2RSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjPkJz4wOxtxxZxm5rBqLrW+/OvbDIUvQ7N9TS1zSjsN7g83ZAvYPL/wphV2LvuSzgBiX3x7IinlVksVb3semozcK7aypMXSq4BpL91THxGLSoC2S7/16HjpfTuhw46a39Gfh5mrYXqKCnuFoV0yy7mE14cDiYNOslWHWR9L5Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V2WdRQOn; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738897838; x=1770433838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i49YZ8XKMLB6OSNTyXAHmqR6isI1HtHi4zigGDW2RSI=;
  b=V2WdRQOnD5DRfiy6/wZvIF+O3vU+RIroRmgj8F+Pqe8SictxVdSvWBMe
   5VlYFuotcAKr9HDjuX0hlZ7Xpaku1l6m7o+nNkO2+jP4DdBdbuLDaVl22
   V39eIqAHt3v2TDU7rU6mUxs3SUA7qwCu4eYApuLKFTatc90hKOyed88nn
   HKNPWC4BZjew8sjvnTchby4813CmDMfReXCaM81qZ6S9vpDu3cM1VAo1a
   hb/8+Fr6CZv1GHk85e8XiV28/V/EZA1gxGYl/bG/+zSEy+FtK62g/ZheN
   SuSE5MPfb/kkvci0/R+GZsvj8iBrTPRZx9N8VekaR/NqMbmPYYeBxZNm6
   A==;
X-CSE-ConnectionGUID: klctfO7FRL24rSdDao2OkA==
X-CSE-MsgGUID: 4xoeqIqbTFmis43cyUFouw==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="38731418"
X-IronPort-AV: E=Sophos;i="6.13,266,1732608000"; 
   d="scan'208";a="38731418"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 19:10:37 -0800
X-CSE-ConnectionGUID: +bzVq0biSbi6FMaMSsL5Nw==
X-CSE-MsgGUID: wz3Y71LDSfyyNDplkIr/ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,266,1732608000"; 
   d="scan'208";a="116412270"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 19:10:35 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 4/4] KVM: x86/mmu: Free obsolete roots when pre-faulting SPTEs
Date: Fri,  7 Feb 2025 11:09:31 +0800
Message-ID: <20250207030931.1902-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250207030640.1585-1-yan.y.zhao@intel.com>
References: <20250207030640.1585-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Always free obsolete roots when pre-faulting SPTEs in case it's called
after a root is invalidated (e.g., by memslot removal) but before any
vcpu_enter_guest() processing of KVM_REQ_MMU_FREE_OBSOLETE_ROOTS.

Lack of kvm_mmu_free_obsolete_roots() in this scenario can lead to
kvm_mmu_reload() failing to load a new root if the current root hpa is an
obsolete root (which is not INVALID_PAGE). Consequently,
kvm_arch_vcpu_pre_fault_memory() will retry infinitely due to the checking
of is_page_fault_stale().

It's safe to call kvm_mmu_free_obsolete_roots() even if there are no
obsolete roots or if it's called a second time when vcpu_enter_guest()
later processes KVM_REQ_MMU_FREE_OBSOLETE_ROOTS. This is because
kvm_mmu_free_obsolete_roots() sets an obsolete root to INVALID_PAGE and
will do nothing to an INVALID_PAGE.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 47fd3712afe6..72f68458049a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4740,7 +4740,12 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	/*
 	 * reload is efficient when called repeatedly, so we can do it on
 	 * every iteration.
+	 * Before reload, free obsolete roots in case the prefault is called
+	 * after a root is invalidated (e.g., by memslot removal) but
+	 * before any vcpu_enter_guest() processing of
+	 * KVM_REQ_MMU_FREE_OBSOLETE_ROOTS.
 	 */
+	kvm_mmu_free_obsolete_roots(vcpu);
 	r = kvm_mmu_reload(vcpu);
 	if (r)
 		return r;
-- 
2.43.2


