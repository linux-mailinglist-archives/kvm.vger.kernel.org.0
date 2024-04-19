Return-Path: <kvm+bounces-15257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3DAF8AADC0
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:31:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 615322830FF
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 11:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2581A823D9;
	Fri, 19 Apr 2024 11:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZMunLnB/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB91685C66;
	Fri, 19 Apr 2024 11:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713526212; cv=none; b=lo0+H8TmEYHXoJ6shXcBlWjctFvvcqPi91lTUPkXA2PmDE+qionnU55WSGLBQVRvWwl1HMi/TFlOMXzoKkjibjx5TFcjdzPUGTs6KBepE5rW7Tk7SgdhA5t7pO6pqBKec1lv+k/gaipDzoafe6xRpAUckYLEI5ME00xpFSaJ0K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713526212; c=relaxed/simple;
	bh=EfxuQvgZxrKIqalOkLU0/iGKp1QmVcDLcPW6Z90R+hw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bQ4tgEEGBkcHlTttdWTv6VsmT+Q6dYk+yvgGHBuyrHnLzMtEFPL4Cb/eTA+jRcazkqbALqd2QV/EMytbWzAIQigZ8N1cVWmPlvYUuF9Tu5e92Nu3t3Fq6udhgvK9gVLPOdxJu7txOjqja8XoOdKLp5XR7l20jvOYftip2w/kAnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZMunLnB/; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713526211; x=1745062211;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EfxuQvgZxrKIqalOkLU0/iGKp1QmVcDLcPW6Z90R+hw=;
  b=ZMunLnB/9J+dEjXAyi6tYfXYK8/PWUpBYvCA/tEa0yO1Pay41DOQaY2B
   Vhbg0WTR1r+QnNZ0GROaQKS4vqQyoLlBDirXR8onRun5mxv4SVeeAIO3z
   80ir3ttc0ZtOCS+XpfwY9f166Pszx4lVl+rpsr7UnKIbxkt/3XBVIdtQl
   rneFXgAlMlpyk0Xt/iJjPukistAubC4YQ2nQqAs8YIac1FEVbbu2EisTV
   mQhhcZc5Asw2cAvH97eKLZG4a18010qa5JNqCS6iFSeKLzSEIv91hlLnT
   yYsBrOwpulm8k/xNfJEbbc04gh4rTsAIW/1HHG4wvF2CrD9k2JBiP6ZIB
   Q==;
X-CSE-ConnectionGUID: t4NgJ8htRQ2ydgivU6d0dw==
X-CSE-MsgGUID: a9ErndH0QOKDt8Yj7rfIZA==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="20513185"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="20513185"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 04:30:10 -0700
X-CSE-ConnectionGUID: svVfShsZTt6Q6b8orX+6ug==
X-CSE-MsgGUID: f1Dq37D1SyGiTMLAq46RLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23389413"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmviesa008.fm.intel.com with ESMTP; 19 Apr 2024 04:30:09 -0700
From: Wei Wang <wei.w.wang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wei Wang <wei.w.wang@intel.com>
Subject: [RFC PATCH v2 5/5] KVM: x86/pmu: Remove KVM_X86_PMU_OP_OPTIONAL
Date: Fri, 19 Apr 2024 19:29:52 +0800
Message-Id: <20240419112952.15598-6-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20240419112952.15598-1-wei.w.wang@intel.com>
References: <20240419112952.15598-1-wei.w.wang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to the removal of KVM_X86_OP_OPTIONAL, remove
KVM_X86_PMU_OP_OPTIONAL() to simplify the usage of kvm_pmu_ops.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h | 20 +++++++-------------
 arch/x86/kvm/pmu.c                     |  7 +------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index f852b13aeefe..ac10ac5cb1fa 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -1,28 +1,22 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#if !defined(KVM_X86_PMU_OP) || !defined(KVM_X86_PMU_OP_OPTIONAL)
+#if !defined(KVM_X86_PMU_OP)
 BUILD_BUG_ON(1)
 #endif
 
 /*
- * KVM_X86_PMU_OP() and KVM_X86_PMU_OP_OPTIONAL() are used to help generate
- * both DECLARE/DEFINE_STATIC_CALL() invocations and
- * "static_call_update()" calls.
- *
- * KVM_X86_PMU_OP_OPTIONAL() can be used for those functions that can have
- * a NULL definition, for example if "static_call_cond()" will be used
- * at the call sites.
+ * KVM_X86_PMU_OP() is used to help generate both DECLARE/DEFINE_STATIC_CALL()
+ * invocations and static_call_update() calls.
  */
 KVM_X86_PMU_OP(rdpmc_ecx_to_pmc)
 KVM_X86_PMU_OP(msr_idx_to_pmc)
-KVM_X86_PMU_OP_OPTIONAL(check_rdpmc_early)
+KVM_X86_PMU_OP(check_rdpmc_early)
 KVM_X86_PMU_OP(is_valid_msr)
 KVM_X86_PMU_OP(get_msr)
 KVM_X86_PMU_OP(set_msr)
 KVM_X86_PMU_OP(refresh)
 KVM_X86_PMU_OP(init)
-KVM_X86_PMU_OP_OPTIONAL(reset)
-KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
-KVM_X86_PMU_OP_OPTIONAL(cleanup)
+KVM_X86_PMU_OP(reset)
+KVM_X86_PMU_OP(deliver_pmi)
+KVM_X86_PMU_OP(cleanup)
 
 #undef KVM_X86_PMU_OP
-#undef KVM_X86_PMU_OP_OPTIONAL
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index c6f8e9ab2866..7a145a9b75ca 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -80,20 +80,15 @@ static struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
 #define KVM_X86_PMU_OP(func)					     \
 	DEFINE_STATIC_CALL_NULL(kvm_x86_pmu_##func,			     \
 				*(((struct kvm_pmu_ops *)0)->func));
-#define KVM_X86_PMU_OP_OPTIONAL KVM_X86_PMU_OP
 #include <asm/kvm-x86-pmu-ops.h>
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
 {
 	memcpy(&kvm_pmu_ops, pmu_ops, sizeof(kvm_pmu_ops));
 
-#define __KVM_X86_PMU_OP(func) \
-	static_call_update(kvm_x86_pmu_##func, kvm_pmu_ops.func);
 #define KVM_X86_PMU_OP(func) \
-	WARN_ON(!kvm_pmu_ops.func); __KVM_X86_PMU_OP(func)
-#define KVM_X86_PMU_OP_OPTIONAL __KVM_X86_PMU_OP
+	static_call_update(kvm_x86_pmu_##func, kvm_pmu_ops.func);
 #include <asm/kvm-x86-pmu-ops.h>
-#undef __KVM_X86_PMU_OP
 }
 
 static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
-- 
2.27.0


