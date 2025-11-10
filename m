Return-Path: <kvm+bounces-62570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D3BAC48934
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:32:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0C2AB4F1DB5
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A11A5339B2F;
	Mon, 10 Nov 2025 18:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HC6gNXIW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A5B338929;
	Mon, 10 Nov 2025 18:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799111; cv=none; b=eEpHjwUCb5PRSkowhIsW9vsYxL5ymxB4c/Wo1RzrNz6N6ycja5MZK7jzLiEP0axX8ibTkOI54Y+1lkVb8aXPxANF5PDcJVg60JDnk9R/f9IcaNDhciGd3ueoRCiCXpYGLdNxORSWfQ/f90ygJeq8t3Z8hfqsMIpbqylPqnZ2w9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799111; c=relaxed/simple;
	bh=M90FqDepqn9vD16vcF4PCVp4pHvNqNNxEQXBCJXAYWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSq2UEdVyZiPeTOR6yPHie2ARypJjnoywnotdH7T07ceHih7Jz00m6qNQaiPTxmj5YOaXi36OKQs8N/HPSVEELiuAyQ9hqoDLstw53uRn90rCj/YGO2SErqUdC3upWPopDRzk23k3fix9QzF2QtbWI6gu1WpVXC5Y03hZaLgkac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HC6gNXIW; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799110; x=1794335110;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M90FqDepqn9vD16vcF4PCVp4pHvNqNNxEQXBCJXAYWI=;
  b=HC6gNXIWN1gPcjbNG8Ob5on+62LFDZRU2FTTEzrhclJVfqAjA5ijAENL
   yCd8bYfidmEdyEb3Sb0HSCTAbOCUWpD/6KIihbW6M12tzjZXeCVujDhn/
   EDyD8VPWjeKhSEW6nrlU0K5BouovyGw0aX3ZUfm+f6SvLxcXDhxM81rYR
   UhJJTgh5jUWFVrwLRZJ5ww+8WeKWQtyPE4pGxJLl6XsmalodSbI+T6NmN
   0DKH7lMGN8rtwg8ZMoguT8KY8Amnx23/6bDfSKpXGApzspn5JRIK9vCM+
   wVUQGr0R5Ovyv0Gb3d2hJCb+Q0ENwwXAJSC+JNIbW+leOUzqc7bEJiJSd
   w==;
X-CSE-ConnectionGUID: MvZy/K8WThCgbE7dTswcuQ==
X-CSE-MsgGUID: d/UAvDbFQ4+uD45s5ttfvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305532"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305532"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:25:10 -0800
X-CSE-ConnectionGUID: dzQZpdE1SeWFykSb4QxwMw==
X-CSE-MsgGUID: bYZux5neTfqIDgGSJYsvfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396267"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:25:10 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 19/20] KVM: x86: Expose APX sub-features to guests
Date: Mon, 10 Nov 2025 18:01:30 +0000
Message-ID: <20251110180131.28264-20-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110180131.28264-1-chang.seok.bae@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add CPUID leaf 0x29 sub-leaf 0 to enumerate APX sub-features to guests.
This leaf currently defines the following sub-features:

  * New Conditional Instructions (NCI)
  * New Data Destination (NDD)
  * Flags Suppression (NF)

The CPUID leaf is only exposed if the APX feature is enabled.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 10 ++++++++--
 arch/x86/kvm/reverse_cpuid.h    |  4 ++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 940f83c121cf..763872080c64 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -794,6 +794,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_24_0_EBX,
 	CPUID_8000_0021_ECX,
 	CPUID_7_1_ECX,
+	CPUID_29_0_EBX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b90e58f2a42f..95c25de641ca 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1063,6 +1063,10 @@ void kvm_set_cpu_caps(void)
 		F(AVX10_512),
 	);
 
+	kvm_cpu_cap_init(CPUID_29_0_EBX,
+		F(APX_NCI_NDD_NF),
+	);
+
 	kvm_cpu_cap_init(CPUID_8000_0001_ECX,
 		F(LAHF_LM),
 		F(CMP_LEGACY),
@@ -1640,8 +1644,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	}
 	case 0x29: {
-		/* No APX sub-features are supported yet */
-		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+		if (!(kvm_caps.supported_xcr0 & XFEATURE_MASK_APX)) {
+			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+			break;
+		}
 		break;
 	}
 	case KVM_CPUID_SIGNATURE: {
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index e9d9fb4070ca..a8eca23ee2d4 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -50,6 +50,9 @@
 #define X86_FEATURE_AVX10_256		KVM_X86_FEATURE(CPUID_24_0_EBX, 17)
 #define X86_FEATURE_AVX10_512		KVM_X86_FEATURE(CPUID_24_0_EBX, 18)
 
+/* Intel-defined sub-features, CPUID level 0x00000029:0 (EBX) */
+#define X86_FEATURE_APX_NCI_NDD_NF	KVM_X86_FEATURE(CPUID_29_0_EBX, 0)
+
 /* CPUID level 0x80000007 (EDX). */
 #define KVM_X86_FEATURE_CONSTANT_TSC	KVM_X86_FEATURE(CPUID_8000_0007_EDX, 8)
 
@@ -92,6 +95,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_24_0_EBX]      = {      0x24, 0, CPUID_EBX},
 	[CPUID_8000_0021_ECX] = {0x80000021, 0, CPUID_ECX},
 	[CPUID_7_1_ECX]       = {         7, 1, CPUID_ECX},
+	[CPUID_29_0_EBX]      = {      0x29, 0, CPUID_EBX},
 };
 
 /*
-- 
2.51.0


