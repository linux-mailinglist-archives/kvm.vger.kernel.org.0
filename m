Return-Path: <kvm+bounces-63471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id AC75AC671CE
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:21:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3477B3622FF
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C0C2329C67;
	Tue, 18 Nov 2025 03:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zki6Zi1G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D36328B4F
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436056; cv=none; b=gq8z81ewPSM5Gxrct5oGS69vbMKta7tDIJwdy5KQjLemVY4vq335esQ1yn08W5PVUQvyxFbHyM5AeIIew4VldfBnIsWMUv+SnY79lJfChbMQQ+zCyChRxrOC7K8b4XugANzCbjt7jbOMr2ZLcggg+FZctT4zKFlEpkIucBe4BU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436056; c=relaxed/simple;
	bh=DZ3sfvrb+qc8GsNdFeIp7NVIUjHrM1Kf/7Vu9/XqA3o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C1WbovL0sE4uTkONK57wQYJUosRrfSvYhnVaXNqrJasUlG46ROClzibp/sTL8u7XPMVoPR2kaE0+XaYx4LXhd22hPsYDIp7gB0YMg7r2m4SdnZMHWlW0IGEtboXKUpHxvvYtVw+CHYV0Pmvw42N7xXGdZMZVuFQz/o9/Bu6g2Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zki6Zi1G; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436055; x=1794972055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DZ3sfvrb+qc8GsNdFeIp7NVIUjHrM1Kf/7Vu9/XqA3o=;
  b=Zki6Zi1GUM+xwnx0M+mrNSZosUYdv+CgYcT9sZEDX/Qgv1L7zHNrpCld
   Z3hW2QSzPEoa0YgMgn7J2oTG9S+fTkgi5WQP9m1nBxBLfIpNgdeblelY0
   htwC+IdoDQjbR+FD8K1sNPeXQZ/nOyzq2H9KijuHwHDmXkMGBii7zCSre
   HQ98SHilbPLY11jSvN4cVoBOCs23J45tX+nPiWwHzjlmPBABGC53Wid6M
   952TnQNVtmVzE44mjBKugQ41D1KxnPMUFQLLE/NsOO8JZPmIxiQB8OyAT
   JAvznwvOSAvWhaShlkrwgxRZQ0YjqschanUYdvk9E0+mzw+jQeL7KFZtJ
   w==;
X-CSE-ConnectionGUID: MrT3ebtdTlSEV465+rVAuw==
X-CSE-MsgGUID: eouFhm40ToCoHUUTOfTdFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053834"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053834"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:20:55 -0800
X-CSE-ConnectionGUID: ERNT0Nx1ThaAhGyQlfd4jA==
X-CSE-MsgGUID: LxvIqZGURLCoPlJQgObojA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537207"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:20:51 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	Xin Li <xin@zytor.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 11/23] i386/cpu: Add missing migratable xsave features
Date: Tue, 18 Nov 2025 11:42:19 +0800
Message-Id: <20251118034231.704240-12-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118034231.704240-1-zhao1.liu@intel.com>
References: <20251118034231.704240-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Xtile-cfg & xtile-data are both user xstates. Their xstates are cached
in X86CPUState, and there's a related vmsd "vmstate_amx_xtile", so that
it's safe to mark them as migratable.

Arch lbr xstate is a supervisor xstate, and it is save & load by saving
& loading related arch lbr MSRs, which are cached in X86CPUState, and
there's a related vmsd "vmstate_arch_lbr". So it should be migratable.

PT is still unmigratable since KVM disabled it and there's no vmsd and
no other emulation/simulation support.

Note, though the migratable_flags get fixed,
x86_cpu_enable_xsave_components() still overrides supported xstates
bitmaps regardless the masking of migratable_flags. This is another
issue, and would be fixed in follow-up refactoring.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - Mark XSTATE_ARCH_LBR_MASK as migratable in FEAT_XSAVE_XSS_LO.
 - Add TODO comment.
---
 target/i386/cpu.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 859cb889a37c..d2a89c03caec 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1484,6 +1484,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             .ecx = 1,
             .reg = R_ECX,
         },
+        .migratable_flags = XSTATE_ARCH_LBR_MASK,
     },
     [FEAT_XSAVE_XSS_HI] = {
         .type = CPUID_FEATURE_WORD,
@@ -1522,7 +1523,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .migratable_flags = XSTATE_FP_MASK | XSTATE_SSE_MASK |
             XSTATE_YMM_MASK | XSTATE_BNDREGS_MASK | XSTATE_BNDCSR_MASK |
             XSTATE_OPMASK_MASK | XSTATE_ZMM_Hi256_MASK | XSTATE_Hi16_ZMM_MASK |
-            XSTATE_PKRU_MASK,
+            XSTATE_PKRU_MASK | XSTATE_XTILE_CFG_MASK | XSTATE_XTILE_DATA_MASK,
     },
     [FEAT_XSAVE_XCR0_HI] = {
         .type = CPUID_FEATURE_WORD,
@@ -2154,8 +2155,13 @@ static uint64_t x86_cpu_get_migratable_flags(X86CPU *cpu, FeatureWord w)
     for (i = 0; i < 64; i++) {
         uint64_t f = 1ULL << i;
 
-        /* If the feature name is known, it is implicitly considered migratable,
-         * unless it is explicitly set in unmigratable_flags */
+        /*
+         * If the feature name is known, it is implicitly considered migratable,
+         * unless it is explicitly set in unmigratable_flags.
+         *
+         * TODO: Make the behavior of x86_cpu_enable_xsave_components() align
+         * with migratable_flags masking.
+         */
         if ((wi->migratable_flags & f) ||
             (wi->feat_names[i] && !(wi->unmigratable_flags & f))) {
             r |= f;
-- 
2.34.1


