Return-Path: <kvm+bounces-38346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AEAEFA37DC0
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:04:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FA94189730F
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 09:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25D51B0F32;
	Mon, 17 Feb 2025 08:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jE8vIIhf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D151A4AAA;
	Mon, 17 Feb 2025 08:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739782724; cv=none; b=O4jQpPfypfXQ0WDolAdSXlbXaRFo9Pg9KxufMaAbOEttlSk7DyiiljWJcj4+vEFdolRwXsv9BinsfoFd2cuFWEdb6m1iqv8EZls9JD5imaPU+aXZr/eFzR8JIv/8ZNKolo/hU0TYK+9lB0eZMifMF4RreX3yD1EVUefAcTIzdRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739782724; c=relaxed/simple;
	bh=icQZctjBaNyUMIgCBFQc6IRMZ5I1Ya14Tv26LTpGTPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/nnzORL/m1enwtUNzUiLhBwE0MswELJwI3MfPjWEdWoTeLEWBXwrYjqp0xfmRTvRTW7t7+wlCJk1JtxfkFRW92h8mHZviMN6dRgi4GS2Ig/V2ijeF7hBnwkqQ2Z0C0GujYkEtL6uxN8zE3bkUfoJUaUm2GM0ll4+RoNpC7TF4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jE8vIIhf; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739782723; x=1771318723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=icQZctjBaNyUMIgCBFQc6IRMZ5I1Ya14Tv26LTpGTPY=;
  b=jE8vIIhfUpITWCZVhvjHS8Kmz46UBnlEu3gH4PSr2mX2i6fZV0DC7W35
   78Qnr5u8ug1u26x/jm1U9rutrBW9/62Q14/bC75Bd66qiCA6O9TkTHdyo
   ngPqxAg3duto7DaWtuSVqHc0yScCVSxo5eM7niIbFBwEwNVL1eatYI+I+
   HTLrfZh5NbbLEBb0Wg6i3RXUuW5Mr65zfD6mF5VbVUgTYtkERVboaRW2/
   B5cBO1UH+R7yB7IbK/S2iDhTFAJTf+9gPtzeGcxyXtSLDCuMRFPnRw5jo
   QVAh/hH9VPk5KV7BJnYmN2PjW67SC4v+6A47aaPwwDposNu8efkj3ubow
   Q==;
X-CSE-ConnectionGUID: 4iRWRtNOQ1ywg34vocKndQ==
X-CSE-MsgGUID: sOuBm3g2TY2ZP0UODj3Wzw==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="40579480"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="40579480"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:58:42 -0800
X-CSE-ConnectionGUID: zgcqOHeATSOfthLbmdfzBQ==
X-CSE-MsgGUID: UgeUSULcSvGrFocJFJtIEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118697583"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:58:39 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 2/2] KVM: x86/mmu: Bail out kvm_tdp_map_page() when VM dead
Date: Mon, 17 Feb 2025 16:57:31 +0800
Message-ID: <20250217085731.19733-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250217085535.19614-1-yan.y.zhao@intel.com>
References: <20250217085535.19614-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bail out of the loop in kvm_tdp_map_page() when a VM is dead. Otherwise,
kvm_tdp_map_page() may get stuck in the kernel loop when there's only one
vCPU in the VM (or if the other vCPUs are not executing ioctls), even if
fatal errors have occurred.

kvm_tdp_map_page() is called by the ioctl KVM_PRE_FAULT_MEMORY or the TDX
ioctl KVM_TDX_INIT_MEM_REGION. It loops in the kernel whenever RET_PF_RETRY
is returned. In the TDP MMU, kvm_tdp_mmu_map() always returns RET_PF_RETRY,
regardless of the specific error code from tdp_mmu_set_spte_atomic(),
tdp_mmu_link_sp(), or tdp_mmu_split_huge_page(). While this is acceptable
in general cases where the only possible error code from these functions is
-EBUSY, TDX introduces an additional error code, -EIO, due to SEAMCALL
errors.

Since this -EIO error is also a fatal error, check for VM dead in the
kvm_tdp_map_page() to avoid unnecessary retries until a signal is pending.

The error -EIO is uncommon and has not been observed in real workloads.
Currently, it is only hypothetically triggered by bypassing the real
SEAMCALL and faking an error in the SEAMCALL wrapper.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 08ed5092c15a..3a8d735939b5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4700,6 +4700,10 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
 	do {
 		if (signal_pending(current))
 			return -EINTR;
+
+		if (vcpu->kvm->vm_dead)
+			return -EIO;
+
 		cond_resched();
 		r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
 	} while (r == RET_PF_RETRY);
-- 
2.43.2


