Return-Path: <kvm+bounces-60977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 733AAC0485D
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D6AD14E801F
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C12227F75C;
	Fri, 24 Oct 2025 06:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IrlMLm9O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCED7262FE7
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287742; cv=none; b=kXE115MpWBZ5t3GoPQLrW9a4zbzxjn8T0uIHt5jMFnKcsUqLSoRm/r6fGzgFl+JdJPWxb7+QDbt9SGXAfRsMRL4O9/2wHCCUeasfdNqw4rlA2OGov3jUGpW+6tloQIARV4Uh2anLCly3S4+g5nlEOx3j6o+j9g94aax/xHGADd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287742; c=relaxed/simple;
	bh=Xpun4Nrj9JAR8igc3/qGxsHnvDNDos1+csWD9q4bpnc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TMSrJ0SgdF8ZK7Piz60L5TXv2FQT2TCQEi2qUtASqVsWcZUrLdrY/sKqwToq149pArnDOW23mL5RUtaS9Mm3yC2Z0m38v9tm7vh2hZ2nwS/GC4lrd1nfBGWLe05MhmRh4Lt3fTXQQgtXXRlrWorMUo9lMxtw4b+KcMBKNIeaDA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IrlMLm9O; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761287741; x=1792823741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xpun4Nrj9JAR8igc3/qGxsHnvDNDos1+csWD9q4bpnc=;
  b=IrlMLm9OjNYQXzoojRkfUmU1jeHmmRaAx5FmfiBF1JF8bwOemJP1QWBQ
   Zd/eaRn8JxX88JWSex15DPBWJ0ujkR6k4Ct2dhJb1MYfyZkCCDyS0zz0Q
   X5grJSALepZjHG69hRjW0MpokY8/IYT/2lGM09VYmcy0t900o+RJuI2q4
   RIsKRqtUxx9ySz0SBgumh3buA26C4bt6uOOuoz5HeL7SONy+TmVdqJ8St
   41ibXp0nrU/aXZYAffzSqQ2gW7rRfliPDeyHXXkVa0pCzPVAS1SGdZ8Dw
   DL9XNVqJIXvnz/4i4+/LASsWwGN4QibXBzmxLFuZpEKSFgvC5fZ45IyM7
   w==;
X-CSE-ConnectionGUID: MODHzfjoQu6Ahc8lrxRdwQ==
X-CSE-MsgGUID: hmChvXSvRe2HW3M2GVMNtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62675698"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="62675698"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 23:35:41 -0700
X-CSE-ConnectionGUID: jRolYxpvRZSQV73Acdf+Eg==
X-CSE-MsgGUID: CE6ftexvT6uoAXJnvCnNIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="184276120"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 23 Oct 2025 23:35:37 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v3 16/20] i386/cpu: Mark cet-u & cet-s xstates as migratable
Date: Fri, 24 Oct 2025 14:56:28 +0800
Message-Id: <20251024065632.1448606-17-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251024065632.1448606-1-zhao1.liu@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cet-u and cet-s are supervisor xstates. Their states are saved/loaded by
saving/loading related CET MSRs. And there's a vmsd "vmstate_cet" to
migrate these MSRs.

Thus, it's safe to mark them as migratable.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 0bb65e8c5321..c08066a338a3 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1522,7 +1522,8 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .migratable_flags = XSTATE_FP_MASK | XSTATE_SSE_MASK |
             XSTATE_YMM_MASK | XSTATE_BNDREGS_MASK | XSTATE_BNDCSR_MASK |
             XSTATE_OPMASK_MASK | XSTATE_ZMM_Hi256_MASK | XSTATE_Hi16_ZMM_MASK |
-            XSTATE_PKRU_MASK | XSTATE_ARCH_LBR_MASK | XSTATE_XTILE_CFG_MASK |
+            XSTATE_PKRU_MASK | XSTATE_CET_U_MASK | XSTATE_CET_S_MASK |
+            XSTATE_ARCH_LBR_MASK | XSTATE_XTILE_CFG_MASK |
             XSTATE_XTILE_DATA_MASK,
     },
     [FEAT_XSAVE_XCR0_HI] = {
-- 
2.34.1


