Return-Path: <kvm+bounces-18516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B4768D5D94
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:06:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A33151F26299
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 09:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BD5215747C;
	Fri, 31 May 2024 09:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="heGfTpQ+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D0815697A;
	Fri, 31 May 2024 09:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717146244; cv=none; b=QW4eRSriMd8nQNO2x1ATo707Y9Dqr4tVt2IhWVbDbGAVuiodyYaMxzLmBx8PWLRPVF8Izpj/C7/cbRliWOkr0ClBOV1FFbMXVRannka7M7wKfGVfQA38YKsOKU2jb8FAUfBvuT5XhnOkOnTzHfPG2bm1EFpO2T5QGGLgsXDz+Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717146244; c=relaxed/simple;
	bh=RNQ631wq+tFcd6BAOu9FMkT9bNMeAzeuDXhiZg+LHe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6LtVTyjMmHBxOGkZ1uikJT0G5jih+rwv0kigJz08nF1ZFwgJd199OXTOaYTBFvAiS8co7SboOttjwTrwl77EpvhP9+gcexuJRSvWA3QNRtbRgfeZRA329G8+t/c1Q1fSFiS7zgEv1RTafSSUjBH0iG8Dt5ieVdhGhzQ0MASpwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=heGfTpQ+; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717146243; x=1748682243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RNQ631wq+tFcd6BAOu9FMkT9bNMeAzeuDXhiZg+LHe0=;
  b=heGfTpQ+INrfmthY0WwIuv+0Ec/SA24VMvQS5RFt2bY5Eb3dg29lFLig
   UTT8Nop9odIWtr3iK8KAwehmMHg9RcL3BvuOLPGADTipQLCrVp+0S6DkJ
   RTW4fbWH5qJeTXRsz3GkLxBbbFb+jckLstcOosFasPGhNZYAr/jYvxvne
   4rHderARvcB5DRpq0jXscIqRZlhLO+0QqQdjAK5nRcwvws790f/H6/8bP
   hrJK9mtP5yw/N8KtGKsJiYyxAFzQI8QB6ih6huXMlBn2QyKuZDL3JUXI9
   Zia1nivq2fK8RcidfEQvvk0R2AFj4cDSlYa5iOCUaXeYBl34RuSQxrzzO
   A==;
X-CSE-ConnectionGUID: dPq+XxmoT4a15+Dow+Mb/A==
X-CSE-MsgGUID: BkbUaT63ToOaiwPO/KcWHA==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="17480622"
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="17480622"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 02:04:00 -0700
X-CSE-ConnectionGUID: ZCghcb8kQuWOI6toIDkwiA==
X-CSE-MsgGUID: Bm2es+QJR1acdezFCvu0Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="36102759"
Received: from jf.jf.intel.com ([10.165.9.183])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 02:04:00 -0700
From: Yang Weijiang <weijiang.yang@intel.com>
To: tglx@linutronix.de,
	dave.hansen@intel.com,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	weijiang.yang@intel.com,
	john.allen@amd.com
Subject: [PATCH 6/6] x86/fpu/xstate: Warn if CET supervisor state is detected in normal fpstate
Date: Fri, 31 May 2024 02:03:31 -0700
Message-ID: <20240531090331.13713-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531090331.13713-1-weijiang.yang@intel.com>
References: <20240531090331.13713-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CET supervisor state bit is __ONLY__ enabled for guest fpstate, i.e.,
never for normal kernel fpstate. The bit is set when guest FPU config
is initialized.

For normal fpstate, the bit should have been removed when initializes
kernel FPU config settings, WARN_ONCE() if kernel detects normal fpstate
xfeatures contains CET supervisor state bit before xsaves operation.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kernel/fpu/xstate.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 05df04f39628..b1b3e0fe02c6 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -189,6 +189,8 @@ static inline void os_xsave(struct fpstate *fpstate)
 	WARN_ON_FPU(!alternatives_patched);
 	xfd_validate_state(fpstate, mask, false);
 
+	WARN_ON_FPU(!fpstate->is_guest && (mask & XFEATURE_MASK_CET_KERNEL));
+
 	XSTATE_XSAVE(&fpstate->regs.xsave, lmask, hmask, err);
 
 	/* We should never fault when copying to a kernel buffer: */
-- 
2.43.0


