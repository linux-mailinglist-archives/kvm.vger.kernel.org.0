Return-Path: <kvm+bounces-45576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FA27AABFAB
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:35:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73C4B3B894B
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 588C626C3A4;
	Tue,  6 May 2025 09:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jntFF0oz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD187267733;
	Tue,  6 May 2025 09:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746523998; cv=none; b=Dt+TQ5q/4vBT4IhQbUZYfTOJ/H1myL/qHpFECIPGBt5jnyEVJBIWSPIPcUZxw0tgcbXvZNi1Z8zSX5SF8iq/OUVQOHA9KvVWdLgn6mTX+k4OWLUm2vp1WgAmHIS3sJmvqDAZsnodamKGC432hkJRwVlrz1LLLla3dhLAQTf3X3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746523998; c=relaxed/simple;
	bh=krG29boC1nw0mvew+VXZrkh+APefvKGWDsm547BBetk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pE1Vg5YE5M5/3eqG0hD1EP1iXdG2JJVyi+S+0bvH+wwGy4SRCR8yrzPXhdXXxT2GSwEbWdj1iv2CqMY4hWLf7KOTUdOcd2cHfcSOxYdKjWPjFXdq01u96+r/k1/DMCh5wKC6tUutrtsOFNT/8Fk5xPeL2UFYs/ftChSQoMLPOYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jntFF0oz; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746523997; x=1778059997;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=krG29boC1nw0mvew+VXZrkh+APefvKGWDsm547BBetk=;
  b=jntFF0ozVsmghek1bfIzoOgidAAdyZL3+j3Bqvot5GHl5OKL4f2fNAoZ
   WOHzQh6OFxNQz6hi3OMYHeojjeOtdbwoNvTZIoU1txc9McRA950/wgr3g
   GshzKXGVW/ZuexqgwMTnUTK30uKfuezc2dylgC95H74w/7uyohdEZFnrU
   azgLxIBEe1votIujLwYEcjfxV+gpRkNb5MLh14aNeh+gVAQi5FZupHGHv
   uDCst1kXIqau4UJOHCNVBtLZRyqrrYkz7v5Ly7BuFPVwSRiBdPJr9SNO2
   4dOHspV6RaqrSDNMLy4lhX1x15PQtxct3I1TN6ATuSJgpsNjuU6GChPQZ
   A==;
X-CSE-ConnectionGUID: bYIUCBOPTzOir2tonBCaEg==
X-CSE-MsgGUID: Y76iSdmyRGyRLlhrL6/FIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="35800405"
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="35800405"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 02:33:16 -0700
X-CSE-ConnectionGUID: E9/ql/JOQbuP+0zANAD8YA==
X-CSE-MsgGUID: 0k/g63DHSpmDmTgNRajr8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="135446906"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 02:33:12 -0700
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
	Oleg Nesterov <oleg@redhat.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Eric Biggers <ebiggers@google.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH v6 4/7] x86/fpu: Initialize guest FPU permissions from guest defaults
Date: Tue,  6 May 2025 17:36:09 +0800
Message-ID: <20250506093740.2864458-5-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250506093740.2864458-1-chao.gao@intel.com>
References: <20250506093740.2864458-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, fpu->guest_perm is copied from fpu->perm, which is derived from
fpu_kernel_cfg.default_features.

Guest defaults were introduced to differentiate the features and sizes of
host and guest FPUs. Copying guest FPU permissions from the host will lead
to inconsistencies between the guest default features and permissions.

Initialize guest FPU permissions from guest defaults instead of host
defaults. This ensures that any changes to guest default features are
automatically reflected in guest permissions, which in turn guarantees
that fpstate_realloc() allocates a correctly sized XSAVE buffer for guest
FPUs.

Suggested-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v6: Drop vcpu_fpu_config.user_* and collect reviews (Rick)
---
 arch/x86/kernel/fpu/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 2cd5e1910ff8..444e517a8648 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -553,8 +553,14 @@ void fpstate_reset(struct fpu *fpu)
 	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;
 	fpu->perm.__state_size		= fpu_kernel_cfg.default_size;
 	fpu->perm.__user_state_size	= fpu_user_cfg.default_size;
-	/* Same defaults for guests */
-	fpu->guest_perm = fpu->perm;
+
+	fpu->guest_perm.__state_perm	= guest_default_cfg.features;
+	fpu->guest_perm.__state_size	= guest_default_cfg.size;
+	/*
+	 * User features and sizes remain the same between guest FPUs
+	 * and host FPUs.
+	 */
+	fpu->guest_perm.__user_state_size = fpu_user_cfg.default_size;
 }
 
 static inline void fpu_inherit_perms(struct fpu *dst_fpu)
-- 
2.47.1


