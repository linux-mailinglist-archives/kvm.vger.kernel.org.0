Return-Path: <kvm+bounces-16974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DB188BF677
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 08:44:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C417C1F23167
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 06:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A7820DCC;
	Wed,  8 May 2024 06:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UAEUjb/G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593A41A2C15
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 06:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715150676; cv=none; b=iUTwSbCXSrW2MXv80ex/a3ESBig2eno5f7b9qIuA8/p3VpuYeYdGcHXPCuyXG5NcSTfe634jbHnZxSVv4iMfMYR8lBfBPlip5NfWVXPmsnHfmQHq6eUrDEnMCkNFqCEq/e6O4TtvpLsFvhGhNAa0DEzLJI46KNjQ09oedB3EkQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715150676; c=relaxed/simple;
	bh=hQrICqZXnIj7ZtIyESqqqcco4pHKYZ5QVSNgXaca+8A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KSKQ1B6EuIVTTXTXXwiFtTrQqDaQNWr3YJlxLyNP+1jsVCmyvEKyty0gnH5aFkAwnjV/mK4ColoxRsfdhm+Zn1UK9kCWXKwkR7xurgBr+14dbFYAsI77kD9Kai5RzJSjJETVvGY7th2cW7xER8+dJAm3/WXyDH9F8MXi8UvHIKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UAEUjb/G; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715150675; x=1746686675;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hQrICqZXnIj7ZtIyESqqqcco4pHKYZ5QVSNgXaca+8A=;
  b=UAEUjb/GfpNmJSObw9UnjzZuMFc3IzL5dCQoAuvCNDuvBwQPBBvzCfAI
   WWBQS7WkfqOnGivS2Lvyte93ARJudoBhpTEC59RMgwE1dCgeojgc+JoOt
   UVfPmdvHwFdMKXgh47ut821yScrJilOvjILaxG2x/VfUswyn+uZIma1VW
   kb1V9oiNzySfqErRHm5vwILXvccv+54tY+gTOp7WJpkqXt24sj0aO8DlK
   xwveJDymd6wVCH6n08iCsylcbZKUCWNF49zXvztjbCAoBjVeT/kfspHhC
   6HzfMdQi2obj4jQYd1pYbeRnFmEBQUAfpSNcJI6+okzRDV0pCCiRrurBq
   w==;
X-CSE-ConnectionGUID: CtYOrvJ9TZWayx4bpZs2tw==
X-CSE-MsgGUID: xxHJzf3+QrahZi5L0dZXDQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="11112960"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="11112960"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 23:44:35 -0700
X-CSE-ConnectionGUID: mEICq7kURhSdz9Cli+3XWQ==
X-CSE-MsgGUID: EGQtvVyhQMKnkdyLQVW3tA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="28876324"
Received: from unknown (HELO st-server.bj.intel.com) ([10.240.193.102])
  by fmviesa010.fm.intel.com with ESMTP; 07 May 2024 23:44:33 -0700
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH] KVM: selftests: x86: Prioritize getting max_gfn from GuestPhysBits
Date: Wed,  8 May 2024 14:42:05 +0800
Message-Id: <20240508064205.15301-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the max mappable GPA via GuestPhysBits advertised by KVM to calculate
max_gfn. Currently some selftests (e.g. access_tracking_perf_test,
dirty_log_test...) add RAM regions close to max_gfn, so guest may access
GPA beyond its mappable range and cause infinite loop.

Prioritize obtaining pa_bits from the GuestPhysBits field advertised by
KVM, so max_gfn can be limited to the mappable range.

Signed-off-by: Tao Su <tao1.su@linux.intel.com>
---
This patch is based on https://github.com/kvm-x86/linux/commit/b628cb523c65
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 1 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c     | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 81ce37ec407d..ff99f66d81a0 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -282,6 +282,7 @@ struct kvm_x86_cpu_property {
 #define X86_PROPERTY_MAX_EXT_LEAF		KVM_X86_CPU_PROPERTY(0x80000000, 0, EAX, 0, 31)
 #define X86_PROPERTY_MAX_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 0, 7)
 #define X86_PROPERTY_MAX_VIRT_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
+#define X86_PROPERTY_MAX_GUEST_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 16, 23)
 #define X86_PROPERTY_SEV_C_BIT			KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)
 #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 74a4c736c9ae..6c69f1dfeed2 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1074,7 +1074,9 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 		*pa_bits = kvm_cpu_has(X86_FEATURE_PAE) ? 36 : 32;
 		*va_bits = 32;
 	} else {
-		*pa_bits = kvm_cpu_property(X86_PROPERTY_MAX_PHY_ADDR);
+		*pa_bits = kvm_cpu_property(X86_PROPERTY_MAX_GUEST_PHY_ADDR);
+		if (*pa_bits == 0)
+			*pa_bits = kvm_cpu_property(X86_PROPERTY_MAX_PHY_ADDR);
 		*va_bits = kvm_cpu_property(X86_PROPERTY_MAX_VIRT_ADDR);
 	}
 }

base-commit: dccb07f2914cdab2ac3a5b6c98406f765acab803
-- 
2.34.1


