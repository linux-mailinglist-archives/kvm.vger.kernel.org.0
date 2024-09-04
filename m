Return-Path: <kvm+bounces-25812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3E1396AEFC
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:15:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5ED831F25444
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFC4378274;
	Wed,  4 Sep 2024 03:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J1B8VSON"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3873B4F20E;
	Wed,  4 Sep 2024 03:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419675; cv=none; b=g0l0s8S/IRNwp/MfzkKQQX/OaYxpTgA0S8wBXgba56aAgB7sB0G9iewU58L/tFuGH9nb1nzYaAFK8eGQkvPAk+6GNDpoDVgyjJK3aQmvqYVx8ZzVdHNpFpFfx/C/S+V+uQxysTd621ZNmT39tDINy0PdYR1qGzWfUpmXgJjOwvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419675; c=relaxed/simple;
	bh=w+GKyCxiK7UnwLz7nTaK27EoEWg1ukTr+XO1hSqevvk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=luNA7Xb/c0z4jsfXykzXhCqhPR4/sytiBLT3ZkWfozOpRcZ6p686nRVRSgoIhRnvHf25EcJV+bDFnzxPWhuxKY1g8HxH4Al/z+LaGikSBhDBKNZXaMrtMnX5lMJO2//9C+HPpjdzoLr+USLwNJcAiIzIJCR1b1rhp9YWx1pJngE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J1B8VSON; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419673; x=1756955673;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w+GKyCxiK7UnwLz7nTaK27EoEWg1ukTr+XO1hSqevvk=;
  b=J1B8VSONQfwmGgCy6iy93VHiaOJ+iuJmAVyPIf1iGVOMG93LKmeEgMho
   OnH8iNtQPN80j2jxxnc/SEBqCXqJAkZoF4S/thiid6a5lSKVW/jqMN70b
   tJ+vPc9Bq6vMeWfUtzNCsfAFS2m3ujGro7+2YyRu+Nt8i+0JDrJdFt3Hy
   5TwT3vDYF3uEJD0NkgxToZDLrN4yL4DIPGaEkh41zoHgps0XeEDoX/tHg
   mZmI/cvBNMTxnMvJ0GXYTMX5A63rODXuyXcTzR2TG5RRI3lerZSFVUk3S
   4P1elXn0wDpjxCQGoApHdiv57dG+j6UuRJuPrd+sQNRSPO2qfIq2Eu1z3
   g==;
X-CSE-ConnectionGUID: 2hG7oIIvSdKB1VxIPhyoJg==
X-CSE-MsgGUID: 5Zr2ENC7T1q9SD8dIBCsqA==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564632"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564632"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:00 -0700
X-CSE-ConnectionGUID: kNhRQgSqSUCgZO44tWkFXA==
X-CSE-MsgGUID: kc6yr9tFQWiamHJtDlbcWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106228"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:07:59 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	Yuan Yao <yuan.yao@linux.intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH 03/21] KVM: x86/mmu: Do not enable page track for TD guest
Date: Tue,  3 Sep 2024 20:07:33 -0700
Message-Id: <20240904030751.117579-4-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yan Zhao <yan.y.zhao@intel.com>

TDX does not support write protection and hence page track.
Though !tdp_enabled and kvm_shadow_root_allocated(kvm) are always false
for TD guest, should also return false when external write tracking is
enabled.

Cc: Yuan Yao <yuan.yao@linux.intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
v19:
- drop TDX: from the short log
- Added reviewed-by: BinBin
---
 arch/x86/kvm/mmu/page_track.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 561c331fd6ec..26436113103a 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -35,6 +35,9 @@ static bool kvm_external_write_tracking_enabled(struct kvm *kvm)
 
 bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
 {
+	if (kvm->arch.vm_type == KVM_X86_TDX_VM)
+		return false;
+
 	return kvm_external_write_tracking_enabled(kvm) ||
 	       kvm_shadow_root_allocated(kvm) || !tdp_enabled;
 }
-- 
2.34.1


