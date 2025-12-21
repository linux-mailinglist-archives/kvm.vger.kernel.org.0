Return-Path: <kvm+bounces-66457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 54944CD3BE8
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:44:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BDF593040670
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE7B62512F5;
	Sun, 21 Dec 2025 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ItCt4Kn1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB5E24677A;
	Sun, 21 Dec 2025 04:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291518; cv=none; b=UjFI28OiKB2PpNv+0oR0/t2v+636O0uS1sV9I/LZsKA0FWs8C29/cZVXOuwQGY/l1efyzmVo5cC4RzqrnPMAb8Nh9dzztfO55LQSYVLrBJvBP1jlzvLjYw2l3Dtr/Le4sFzD62LTv1QtfEkE3QKQ6W7jjr23JyaDbaXe+HQT6G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291518; c=relaxed/simple;
	bh=C96fso0takpJoB+lZHZrvgABzsP9IPXlheUDjBPjYoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngrMJedeSwS6pJcjoet7EuwzHaFavxWkoQvcxLiZzqy+jEx30kzlrNAFPIUSu3PsKaMU1naN8RSls7EdHKBy9Gg1YVS+9w5pJ7CV0MsR7o11mYMduvAT5aoMwl16sBOfPpNs4px/8ARKgt6wu4UFwrvbt5UVvQQ4s/wkmWJW55g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ItCt4Kn1; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291517; x=1797827517;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C96fso0takpJoB+lZHZrvgABzsP9IPXlheUDjBPjYoI=;
  b=ItCt4Kn1odMaBemkOVKL/pEwNokmRv+89qugo5nmdHhMxpRWuWU83y+J
   aRgVYTp5KAAzOCpN/Dq9YpaqI3VIraUS5uZFRccBrnCv2+YPzQ9WWRwOZ
   mu1VrbvVPfGUWwvhqK6t3Y0tU6r/hRqFXndjkjAlcCB3UjLs0oaqAdYak
   En+8C0FiZivFuGTeA82FRyCsuVRqLtuWQ0WTRlFj4YSZ1HFCZG9Eb1PcR
   GguJCX4vuul/fgEpv6GEzvJdcBSQeIYAsNrWJegxdKuAEIljjA8JWEZm5
   DWZjdanFOwZA6DEjStb58rZxIbQYkZsPrYclOFVuKQ23GSUzIOmTIcDjR
   A==;
X-CSE-ConnectionGUID: TeX24nrqQ4OL2XdtIk2p3g==
X-CSE-MsgGUID: tMbm4fo3Q8ecBmFUK3rgGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132442"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132442"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:56 -0800
X-CSE-ConnectionGUID: zsIMERelQuK2yRGQrPoFYA==
X-CSE-MsgGUID: 9jbmbcysTGeucac/yPPtEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229885072"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:56 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH 15/16] KVM: x86: Expose APX sub-features to guests
Date: Sun, 21 Dec 2025 04:07:41 +0000
Message-ID: <20251221040742.29749-16-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251221040742.29749-1-chang.seok.bae@intel.com>
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
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
No change since last version
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 10 ++++++++--
 arch/x86/kvm/reverse_cpuid.h    |  4 ++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9dedb8d77222..d75a76152340 100644
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
index 55b32784c392..e9437bedcafe 100644
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
@@ -1641,8 +1645,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
index e538b5444919..f8587586d031 100644
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
 
@@ -91,6 +94,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_24_0_EBX]      = {      0x24, 0, CPUID_EBX},
 	[CPUID_8000_0021_ECX] = {0x80000021, 0, CPUID_ECX},
 	[CPUID_7_1_ECX]       = {         7, 1, CPUID_ECX},
+	[CPUID_29_0_EBX]      = {      0x29, 0, CPUID_EBX},
 };
 
 /*
-- 
2.51.0


