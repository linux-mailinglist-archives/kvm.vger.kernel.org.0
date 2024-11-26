Return-Path: <kvm+bounces-32511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 594539D955B
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 11:20:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17561284AC1
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFB981D45FB;
	Tue, 26 Nov 2024 10:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c98D9fg0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CAB1D416B;
	Tue, 26 Nov 2024 10:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732616320; cv=none; b=f24+S8iofUqa6sVxM8nRwlTDJXTidwNRNHDH6+/cWw3MvhirERud8qmJrx8YVs9ZVqpRHkjrx8OGZFTArgze7WEeMTUgAIcpjSnIIEEvv7xhigCB0zfa9sJCmqfWb3FPoIqQvDRAbfAkDQAYSvrHbKDoTMTfPY9BE5gJElJu7QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732616320; c=relaxed/simple;
	bh=sN/Lhm/c9ZOH94D/2wwFPRvzgWlfLZNOyiz0mTNtkSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljZuAoBQvPxv03QjY5f/wsREF3RolDXx8iOaLvmTQJLUAvGKa0n1ujbtR7hSAZ4X3341JxMTc1Gb8Yh07ZzZxx32zHMve7Q1wlghl4taSDbBfpsUburGYS4F7YEWde6Va4GssKSDrxvHz2JcJVIaC1T7pYdz1gIl+g/cdhzeKLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c98D9fg0; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732616319; x=1764152319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sN/Lhm/c9ZOH94D/2wwFPRvzgWlfLZNOyiz0mTNtkSk=;
  b=c98D9fg0BHao4DaJUGcEJ0be2IdYTr1KW5N7evOMZs0ZWHF9xIMNwbVR
   P/UlV3NntoC2OU1Z6WrQVDNBuAVp/Qf//08Pspm3Oma9YDsVnW3gAx8GL
   k98foSEYidqypzfMxkR1OwGwis6CAS2uiYuiSs18ouUqtW/iymdeGXw3B
   AL+49hPkUoT2UjmDbAciQcr/dyZDaseY+ptwF5/8OJnX1kVIf+D4W8tPy
   /FlLMWOwDzXbUsnM+PuqtuZ/LoUKazZZoPUpuaObPZm9iqjuGDYk9Z/g6
   DuxDfqumHY0RxTavJ2ZEIQaVa4zBK1C0giAlKMEK5wJn2MXMW0cIK4YuQ
   g==;
X-CSE-ConnectionGUID: Su/yWf1XTveF+MoYxGtwVA==
X-CSE-MsgGUID: NvSKWTdzRJSyRrxQpVNXzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="32139901"
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="32139901"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 02:18:38 -0800
X-CSE-ConnectionGUID: OmHFPTkARACT8iy7HmY/vQ==
X-CSE-MsgGUID: 3E4BJCSrQKaeI8PSKkCU6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="96631866"
Received: from spr.sh.intel.com ([10.239.53.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 02:18:34 -0800
From: Chao Gao <chao.gao@intel.com>
To: tglx@linutronix.de,
	dave.hansen@intel.com,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH v2 6/6] x86/fpu/xstate: Warn if CET supervisor state is detected in normal fpstate
Date: Tue, 26 Nov 2024 18:17:10 +0800
Message-ID: <20241126101710.62492-7-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241126101710.62492-1-chao.gao@intel.com>
References: <20241126101710.62492-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

CET supervisor state bit is __ONLY__ enabled for guest fpstate, i.e.,
never for normal kernel fpstate. The bit is set when guest FPU config
is initialized.

For normal fpstate, the bit should have been removed when initializes
kernel FPU config settings, WARN_ONCE() if kernel detects normal fpstate
xfeatures contains CET supervisor state bit before xsaves operation.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kernel/fpu/xstate.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 0b86a5002c84..3b60d3775705 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -187,6 +187,8 @@ static inline void os_xsave(struct fpstate *fpstate)
 	WARN_ON_FPU(!alternatives_patched);
 	xfd_validate_state(fpstate, mask, false);
 
+	WARN_ON_FPU(!fpstate->is_guest && (mask & XFEATURE_MASK_CET_KERNEL));
+
 	XSTATE_XSAVE(&fpstate->regs.xsave, lmask, hmask, err);
 
 	/* We should never fault when copying to a kernel buffer: */
-- 
2.46.1


