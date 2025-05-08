Return-Path: <kvm+bounces-45951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A310AAFEBF
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:15:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65E203A49D1
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 077FC288507;
	Thu,  8 May 2025 15:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FDvVrdVw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEBD288504
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716848; cv=none; b=Pf1UQLTSedi+ZRSfncEAD2rD53HXF0DVrKlHeQHh07GWFPVYVytwixUWND+EG5l2AAH71s8Plgnc5zAQUt1QNIb62ezE6uFmJgQlKbZmgLk70RA+ZWu0eN5hjtwo1p7SAGN1P7y8mC974EUzQ8pE+KExDH4kVI+D2+/iIcgZ3WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716848; c=relaxed/simple;
	bh=NV3mTH60gcvIjwnn6kwqKcY8PoQJ7+HSm/o7zQJIltk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJy3mgDuSj/FAhvHvFaGCMpptEx8eCc+wrhmLWvDYKwRkkZa1PCr3//U7Zr5+tEKsZKpsgbrUBWIl68bw3z3fvIN0VkeHoiu5au9a+ZrGeGZxKWy2FnfmsKKcV3txsb+8Q5ez5wycDzNcEqV4/fZRI7HKKuS0Inta+wu/xArXJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FDvVrdVw; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716843; x=1778252843;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NV3mTH60gcvIjwnn6kwqKcY8PoQJ7+HSm/o7zQJIltk=;
  b=FDvVrdVw9/27qnApeYjV8+c9WhSwNJmarv90WbfzTIWKgIMlr8fPJCcx
   IbbRuLMb97UzfAYZx5Ze0Y6sJOAJSYJ/jL9lCGiMES6cDQBer6zAqpFDi
   IxZjcDdnkjo7JzKrqp9r/T+R9AWWiODdwII9qDmgA+4q/zOJZzvZMDvqL
   LU/1+jRj0Mlpwof2UsXlCFub8URtCpYtpUC/mJRbMETpFa5a7dxkMuvm0
   B1ISITJNbJRrtA5uhZLBjEdq9gzJkMu+CQ0fRGgGAIOqZzCfhQaTOiOg4
   G//rW4n1TL6jkwdhdVn+5AsJXgNucfe0s4mHdtjMHbb1Cno5xTh8epsoz
   Q==;
X-CSE-ConnectionGUID: 4vMDgcB8T1yeiioqPcKFPw==
X-CSE-MsgGUID: ETyU8Jr7TBetvVEJdQsShw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888539"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888539"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:07:23 -0700
X-CSE-ConnectionGUID: DO4YXkSLR3q6mKaO6TWudQ==
X-CSE-MsgGUID: TUh9Rcj7RV2U3xhDfSZNiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440496"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:07:20 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 48/55] i386/tdx: Add XFD to supported bit of TDX
Date: Thu,  8 May 2025 10:59:54 -0400
Message-ID: <20250508150002.689633-49-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just mark XFD as always supported for TDX. This simple solution relies
on the fact KVM will report XFD as 0 when it's not supported by the
hardware.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.h     | 1 +
 target/i386/kvm/tdx.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 132312d70a54..a223e09a25c4 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1126,6 +1126,7 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_XSAVE_XSAVEC     (1U << 1)
 #define CPUID_XSAVE_XGETBV1    (1U << 2)
 #define CPUID_XSAVE_XSAVES     (1U << 3)
+#define CPUID_XSAVE_XFD        (1U << 4)
 
 #define CPUID_6_EAX_ARAT       (1U << 2)
 
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index df6b71568321..528b5cb4ae47 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -628,6 +628,12 @@ static void tdx_add_supported_cpuid_by_xfam(void)
     e->edx |= (tdx_caps->supported_xfam & CPUID_XSTATE_XCR0_MASK) >> 32;
 
     e = find_in_supported_entry(0xd, 1);
+    /*
+     * Mark XFD always support for TDX, it will be cleared finally in
+     * tdx_adjust_cpuid_features() if XFD is unavailable on the hardware
+     * because in this case the original data has it as 0.
+     */
+    e->eax |= CPUID_XSAVE_XFD;
     e->ecx |= (tdx_caps->supported_xfam & CPUID_XSTATE_XSS_MASK);
     e->edx |= (tdx_caps->supported_xfam & CPUID_XSTATE_XSS_MASK) >> 32;
 }
-- 
2.43.0


