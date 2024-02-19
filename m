Return-Path: <kvm+bounces-9020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA056859D7E
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:52:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EE271F21A9D
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02DE42E40D;
	Mon, 19 Feb 2024 07:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZZLLBN70"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6133124B47;
	Mon, 19 Feb 2024 07:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328871; cv=none; b=WTvBXr6F/osXu7x8/gdcd+djA6QyRGQpG0omnoGNJmEHoC3GJVRM2m0SG4klZyFbWZ997fQ9dpY/dwoSiKDQe1M5xn/xpicULd91osnCpaCcXZhVzdr/IcD9V4YTsic1bokfeAiPp5afKcS7q95UdTE8UK3FdYmfWg5r6mhTTBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328871; c=relaxed/simple;
	bh=CJ0Jw/rZGxVuVyRHLbKDpIzAQO9DG/ph6iOAbNKFjzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMTUn0fI5Er1b94CtacZndKE4wo287djEyEOJ2PQBX+3qiNxDmZNHaR1jvqV5k5EvYFpL6johoTSaxbM9np/m3IuCy+PtKOKj7CAq9c+xCHGATz7kvHJBsHF2Ly0dmeBREUGz6xDOzSPbQE9itm1Mi3RgofmxgiA88O/wSN9sAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZZLLBN70; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328869; x=1739864869;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CJ0Jw/rZGxVuVyRHLbKDpIzAQO9DG/ph6iOAbNKFjzE=;
  b=ZZLLBN70XfKV1LaLqdB9OHpt84JhXZ9iiTmWz382BJlKhr5HLW1k9HBS
   akqrKVUVQS+HzGi36E/LwQSRCtuN6vJb0nurXru/XtfJfS8jKPbcQZrqy
   QsqgFwbvtc6IRGheyb96o5me8195Gpcr1PhU89Ml9oiLNNYYw+ll9qDAV
   oMEi8eO3uKG0svRzg0ULOeNveE5b/JMnibfKMlszi2d0LmceDRO/dP53S
   n7WZ/CTkK4WsbtEe/hxN3tALXBmfgUWjUk+vNIf2/7IYKxX45pmhyR/rl
   q54osEFVXEJ5sQFFaVfPWTJnfW77zjQdrZbBMnLFm4HAey48Obh6m5OqD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535053"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535053"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966078"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966078"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:43 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 07/27] x86/fpu/xstate: Warn if kernel dynamic xfeatures detected in normal fpstate
Date: Sun, 18 Feb 2024 23:47:13 -0800
Message-ID: <20240219074733.122080-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kernel dynamic xfeatures now are __ONLY__ enabled for guest fpstate, i.e.,
never for normal kernel fpstate. The bits are added when guest FPU config
is initialized. Guest fpstate is allocated with fpstate->is_guest set to
%true.

For normal fpstate, the bits should have been removed when initializes
kernel FPU config settings, WARN_ONCE() if kernel detects normal fpstate
xfeatures contains kernel dynamic xfeatures before executes xsaves.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kernel/fpu/xstate.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 3518fb26d06b..83ebf1e1cbb4 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -185,6 +185,9 @@ static inline void os_xsave(struct fpstate *fpstate)
 	WARN_ON_FPU(!alternatives_patched);
 	xfd_validate_state(fpstate, mask, false);
 
+	WARN_ON_FPU(!fpstate->is_guest &&
+		    (mask & XFEATURE_MASK_KERNEL_DYNAMIC));
+
 	XSTATE_XSAVE(&fpstate->regs.xsave, lmask, hmask, err);
 
 	/* We should never fault when copying to a kernel buffer: */
-- 
2.43.0


