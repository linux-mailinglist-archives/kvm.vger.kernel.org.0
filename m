Return-Path: <kvm+bounces-2400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF6D97F6D60
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:59:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 728A9281C63
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 07:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B92C11C8F;
	Fri, 24 Nov 2023 07:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k+KLlCkv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CDC170B;
	Thu, 23 Nov 2023 23:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700812723; x=1732348723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YrQMcIE+3fwJeUl1QCEA3wnA4x7/0zKhwJGfXTGGQIs=;
  b=k+KLlCkvlNLrW2KhO0POnBUiH1TB/JFFg2yq+eUoSZsgYnQIWTc/LL+t
   TfBwRDSE3RQVeOlkP/vcyCG8mjOdTuYiVVWEPnDC3P/8cK70SFLAIfDWi
   +RVjnFNI5KrgrkDVY9LBvMi9+A/XBy3gMMChe0dU8mp0UYX3U8YxpOiIT
   ClftX2zMRwDigJreosROd/iCRnUkMeyZe4Ui7CAYEyq/EviC+CVx1zviC
   1AJnMP4+8vn95FnHjdl1XD0rgwc5+x0VCKvPBMkRsXSmrH1Op8VGathM6
   um18ub8Chf8oLpqPurY0K1FcGTIckk+Be/smxu4Eh3rl0FUF6BSh8JQN3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="458872303"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="458872303"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="833629810"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="833629810"
Received: from unknown (HELO embargo.jf.intel.com) ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:37 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v7 07/26] x86/fpu/xstate: Warn if kernel dynamic xfeatures detected in normal fpstate
Date: Fri, 24 Nov 2023 00:53:11 -0500
Message-Id: <20231124055330.138870-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231124055330.138870-1-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kernel dynamic xfeatures now are __ONLY__ enabled for guest fpstate, i.e.,
none for normal kernel fpstate. The bits are added when guest FPU config
is initialized. Guest fpstate is allocated with fpstate->is_guest set to
%true.

For normal fpstate, the bits should have been removed when initializes
kernel FPU config settings, WARN_ONCE() if kernel detects normal fpstate
xfeatures contains kernel dynamic xfeatures before executes xsaves.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kernel/fpu/xstate.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index c032acb56306..d45f3e570e69 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -186,6 +186,9 @@ static inline void os_xsave(struct fpstate *fpstate)
 	WARN_ON_FPU(!alternatives_patched);
 	xfd_validate_state(fpstate, mask, false);
 
+	WARN_ON_FPU(!fpstate->is_guest &&
+		    (mask & XFEATURE_MASK_KERNEL_DYNAMIC));
+
 	XSTATE_XSAVE(&fpstate->regs.xsave, lmask, hmask, err);
 
 	/* We should never fault when copying to a kernel buffer: */
-- 
2.27.0


