Return-Path: <kvm+bounces-24112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34F9C951608
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF7601F22DAE
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC68E13D518;
	Wed, 14 Aug 2024 08:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SU+m6C4C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B0C14264C
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723622568; cv=none; b=JrZ/2+/AdtyiJv4B7YjH1lYFN8n6jTsjr+XPPD3+AMIekwF7Ly68Upe5vr3TYYTVPBDlc6nEVoqRYMQ5/QXN31K/CGkgOOahfkTD5ZZuEs5bf4Cz+jgZr5ZzITgth0Mas5vhN3vaE7lcYUbFAu2ioDo4cJP9V0uDGxwWwbTrtaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723622568; c=relaxed/simple;
	bh=CS43UzH48cjlmpX92LFl+4C3u5GSWZlxQ4JoVqNlFE8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JPRHBQXM0Lgft/pKNAV/atuWGAbAX/mXJgrL0u45ZaKl2TIl6wFrav5vxpLmnJZCYm76z5cIs4f78DtC9QWSEWyZQ9cdoIbuN1IECMXSO4wkXH5xCwthhd81iRvIbzPirBGztPPGXJi3Oze7rmbjmJt9073NRAhmxM13aJUjmFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SU+m6C4C; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723622566; x=1755158566;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CS43UzH48cjlmpX92LFl+4C3u5GSWZlxQ4JoVqNlFE8=;
  b=SU+m6C4Cqfd59QNVOjJEuNESO1+6REwtZHLd1Mu7EcMsRxCCIHjJn3Au
   j8/m+u2ieYdjIRxxZygSVh/sBxoYqZl8JL9cB5DT6IHUSew+YpRdBfwlO
   xZQSvCKVylhIiSrupnJRTOvYrtLRAAn3mWOUutfi2QEvhrrT/0wh+zs97
   VZvYHTSobD+OpUL2F0w/UQOngw97XtrPyPJzwl7JGiSlUa9xopuR//6EK
   fsQZMht+RCsYAlCPM6QVjqtD1FN7LZoociZfB8L1JtekW91B86UTQxG6t
   88l+BfjYBKrq+0QVTnaLHKirEFu9gTO99wsOFJ+Zpzekk32V8Vg3CKLGd
   w==;
X-CSE-ConnectionGUID: W4EFHr66TomPPHAv7wRaTQ==
X-CSE-MsgGUID: BuJy5qmaRcuqVm9YCMPJfg==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="25584512"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="25584512"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 01:02:46 -0700
X-CSE-ConnectionGUID: KgvttIVYRdeLtaOXm/+pdw==
X-CSE-MsgGUID: prB1e/MfTna/Sx4+fuK1gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="59048969"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Aug 2024 01:02:45 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com
Subject: [PATCH 9/9] i386/cpu: Make invtsc migratable when user sets tsc-khz explicitly
Date: Wed, 14 Aug 2024 03:54:31 -0400
Message-Id: <20240814075431.339209-10-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240814075431.339209-1-xiaoyao.li@intel.com>
References: <20240814075431.339209-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When user sets tsc-frequency explicitly, the invtsc feature is actually
migratable because the tsc-frequency is supposed to be fixed during the
migration.

See commit d99569d9d856 ("kvm: Allow invtsc migration if tsc-khz
is set explicitly") for referrence.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 85ce405ece80..fb3519fc6836 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1865,9 +1865,10 @@ static inline uint64_t x86_cpu_xsave_xss_components(X86CPU *cpu)
  * Returns the set of feature flags that are supported and migratable by
  * QEMU, for a given FeatureWord.
  */
-static uint64_t x86_cpu_get_migratable_flags(FeatureWord w)
+static uint64_t x86_cpu_get_migratable_flags(X86CPU *cpu, FeatureWord w)
 {
     FeatureWordInfo *wi = &feature_word_info[w];
+    CPUX86State *env = &cpu->env;
     uint64_t r = 0;
     int i;
 
@@ -1881,6 +1882,12 @@ static uint64_t x86_cpu_get_migratable_flags(FeatureWord w)
             r |= f;
         }
     }
+
+    /* when tsc-khz is set explicitly, invtsc is migratable */
+    if ((w == FEAT_8000_0007_EDX) && env->user_tsc_khz) {
+        r |= CPUID_APM_INVTSC;
+    }
+
     return r;
 }
 
@@ -6129,7 +6136,7 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w)
 
     r &= ~unavail;
     if (cpu && cpu->migratable) {
-        r &= x86_cpu_get_migratable_flags(w);
+        r &= x86_cpu_get_migratable_flags(cpu, w);
     }
     return r;
 }
-- 
2.34.1


