Return-Path: <kvm+bounces-46148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 57725AB328A
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 11:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 007911899731
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 09:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4B725C71B;
	Mon, 12 May 2025 08:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J4g56BTp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6CB25B69A;
	Mon, 12 May 2025 08:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747040267; cv=none; b=G9Jxq9nOUbhcGanqE85W976IzdE5paDG06PZzr7mVSlaDZ9lnLSE8mocoSxMONaOzd4iAr1grHlKbltHj2EacYOi1uQrnNeMfBx4yk4Wzwa35EQ1YdCtvIes4CY2WJatGAjPrA7vd+Is/csopvlPQnZZBfflsdEHHdhsFYV6GZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747040267; c=relaxed/simple;
	bh=krG29boC1nw0mvew+VXZrkh+APefvKGWDsm547BBetk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZDmsg/RrYXfAdKLJd3XtgRab8q+ZuWyALZWQ18iW/2d0I1qjE6d3eQPz12l6XJ4Jo9g86wppCfN8PZF7m8o8z/fzowZJhTkQ+6QE+5wtNhQDl+Y8gtLJ/BFPbWw+wuYVcPmQooZhf5hkDHsph+BDoGnF9MxfXk2eFabjZ1wXPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J4g56BTp; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747040265; x=1778576265;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=krG29boC1nw0mvew+VXZrkh+APefvKGWDsm547BBetk=;
  b=J4g56BTpgEffkRpwMKD8z/fnpx+j8B7k0FuoWpAc8cOfhlS9vKcEpbsy
   BMlvIDbIhB1sdBHq1Ilt50OIjiNFYc6NtkB5NTayAebH3N6A3aavwejYe
   +DfOrHQbM8rbg6A5KTpLxvUQIE7maS46k14UpjT1eSu99naK0lyTtUiNq
   WGHmY58o++OL69m/emttCjXbjXfgedIXG84c3LH2nfZDlNJVDArPTkh5f
   jdFqSb8iqjSCE+WT/mt6M0Bj2Tc4G5YhBSeT0oFyr0iVh5nZQiMmEjEUF
   98/l3QcKZvmJNf8+SLAbEWBSU3gK6GwspbhxJAc/0pJAz1kbIiicFTOev
   g==;
X-CSE-ConnectionGUID: ZRaWj8gaQGG5bf2a/aPpzA==
X-CSE-MsgGUID: ZGTTWy4/RvuxAKZ0vhcznw==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="59488706"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="59488706"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 01:57:45 -0700
X-CSE-ConnectionGUID: sI1dBwrtRHK+BLzNza+vsw==
X-CSE-MsgGUID: Vv8762iBQ8iwVu9vWeVZOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="138235779"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 01:57:45 -0700
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
	Kees Cook <kees@kernel.org>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH v7 2/6] x86/fpu: Initialize guest FPU permissions from guest defaults
Date: Mon, 12 May 2025 01:57:05 -0700
Message-ID: <20250512085735.564475-3-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250512085735.564475-1-chao.gao@intel.com>
References: <20250512085735.564475-1-chao.gao@intel.com>
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


