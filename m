Return-Path: <kvm+bounces-23919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81B1694FA03
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:56:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C934CB20AF2
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE5A1A3BA3;
	Mon, 12 Aug 2024 22:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BvsmysGB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507CC1A256B;
	Mon, 12 Aug 2024 22:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502932; cv=none; b=bnkglzDoM+YvHLJGIDgu5XweprCB8x147/2nXHU7Mi2JPsY+WbuJT06Zawgzs0d1WvLh7QDYRD0Pt1MekCpZdqtUjPVPmNRmUs7LNSWFVKBpTzQbHT6Ejf5IzznPD4yLwiAK5Mz0wA80fHdoJq47XOCqPuovM2Uk/EaqhobTFcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502932; c=relaxed/simple;
	bh=JmY2PRyqyu1ItXKiqbyGIaLSSKWF1EMftG8Hi8PJamE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mA/d9I9W2Drz1SHFI0FkPvmPOW9ca00gwJ1ixczSDhfLraKoQhgTZ2hynwqaHR3L5zXHMmdDiPriNTYF8wblRnTJKguSD0D2kxis9Yo9Q/bU7QEoorm1ZpXKd67JnTzUQaO3I1P41nDmgMNnUSbYrh2KBY8WLNC/W4H9QdMen3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BvsmysGB; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502930; x=1755038930;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JmY2PRyqyu1ItXKiqbyGIaLSSKWF1EMftG8Hi8PJamE=;
  b=BvsmysGBTQE/4HcnOS6tJuL8j7OPrQ5laadFM6x/C72mlwUDZmLULLKX
   l0LYHca0ogiBinicELQP3wM5V27r8leV3byaAAt7liS5nb+ugWIfM7yrt
   4T9HoG1mBKzZnaJeb1b/bt4bXbPK8gY9auCsUtKBMOJW6NY7gW/WgTiBM
   EaQZmkueNf2bmQ0E/xoST6WW2fck8gCW0RPYYviMtrVQAZ4/1/XqiNt/F
   Pxj71V2aQWpERTGrohgxwo7ETqi+w3sEbPD89jbhAco+Jtj1IbEtMBbi8
   cEk6jx0QiyTfkFCj1y4alqlD9w4bKu0+JLnuon5yYdjrrsYaUlu+EJAZX
   w==;
X-CSE-ConnectionGUID: TRmeUrG7SSycWDtfYrvaTA==
X-CSE-MsgGUID: 3bCsrP2uRRWR3gqZFsAnfg==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041505"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041505"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:41 -0700
X-CSE-ConnectionGUID: zKLNPFYKQmG6uYpjWjy2iA==
X-CSE-MsgGUID: lgUDR5isTBm2K1ojhMTOcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008465"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:40 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com
Subject: [PATCH 25/25] KVM: x86: Add CPUID bits missing from KVM_GET_SUPPORTED_CPUID
Date: Mon, 12 Aug 2024 15:48:20 -0700
Message-Id: <20240812224820.34826-26-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Originally, the plan was to filter the directly configurable CPUID bits
exposed by KVM_TDX_CAPABILITIES, and the final configured bit values
provided by KVM_TDX_GET_CPUID. However, several issues were found with
this. Both the filtering done with KVM_TDX_CAPABILITIES and
KVM_TDX_GET_CPUID had the issue that the get_supported_cpuid() provided
default values instead of supported masks for multi-bit fields (i.e. those
encoding a multi-bit number).

For KVM_TDX_CAPABILITIES, there was also the problem of bits that are
actually supported by KVM, but missing from get_supported_cpuid() for one
reason or another. These include X86_FEATURE_MWAIT, X86_FEATURE_HT and
X86_FEATURE_TSC_DEADLINE_TIMER. This is currently worked around in QEMU by
adjusting which features are expected. Some of these are going to be added
to get_supported_cpuid(), and that is probably the right long term fix.

For KVM_TDX_GET_CPUID, there is another problem. Some CPUID bits are fixed
on by the TDX module, but unsupported by KVM. This means that the TD will
have them set, but KVM and userspace won't know about them. This class of
bits is dealt with by having QEMU expect not to see them. The bits include:
X86_FEATURE_HYPERVISOR. The proper fix for this specifically is probably to
change KVM to show it as supported (currently a patch exists). But this
scenario could be expected in the end of TDX module ever setting and
default 1, or fixed 1 bits. It would be good to have discussion on whether
KVM community should mandate that this doesn't happen.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v1:
 - New patch
---
 arch/x86/kvm/vmx/tdx.c | 96 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d45b4f7b69ba..34e838d8f7fd 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1086,13 +1086,24 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	return ret;
 }
 
+/*
+ * This function is used in two cases:
+ * 1. mask KVM unsupported/unknown bits from the configurable CPUIDs reported
+ *    by TDX module. in setup_kvm_tdx_caps().
+ * 2. mask KVM unsupported/unknown bits from the actual CPUID value of TD that
+ *    read from TDX module. in tdx_vcpu_get_cpuid().
+ *
+ * For both cases, it needs fixup for the field that consists of multiple bits.
+ * For multi-bits field, we need a mask however what
+ * kvm_get_supported_cpuid_internal() returns is just a default value.
+ */
 static int tdx_get_kvm_supported_cpuid(struct kvm_cpuid2 **cpuid)
 {
-
 	int r;
 	static const u32 funcs[] = {
 		0, 0x80000000, KVM_CPUID_SIGNATURE,
 	};
+	struct kvm_cpuid_entry2 *entry;
 
 	*cpuid = kzalloc(sizeof(struct kvm_cpuid2) +
 			sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES,
@@ -1104,6 +1115,89 @@ static int tdx_get_kvm_supported_cpuid(struct kvm_cpuid2 **cpuid)
 	if (r)
 		goto err;
 
+	entry = kvm_find_cpuid_entry2((*cpuid)->entries, (*cpuid)->nent, 0x0, 0);
+	if (WARN_ON(!entry))
+		goto err;
+	/* Fixup of maximum basic leaf */
+	entry->eax |= 0x000000FF;
+
+	entry = kvm_find_cpuid_entry2((*cpuid)->entries, (*cpuid)->nent, 0x1, 0);
+	if (WARN_ON(!entry))
+		goto err;
+	/* Fixup of FMS */
+	entry->eax |= 0x0fff3fff;
+	/* Fixup of maximum logical processors per package */
+	entry->ebx |= 0x00ff0000;
+
+	/*
+	 * Fixup of CPUID leaf 4, which enmerates cache info, all of the
+	 * non-reserved fields except EBX[11:0] (System Coherency Line Size)
+	 * are configurable for TDs.
+	 */
+	entry = kvm_find_cpuid_entry2((*cpuid)->entries, (*cpuid)->nent, 0x4, 0);
+	if (WARN_ON(!entry))
+		goto err;
+	entry->eax |= 0xffffc3ff;
+	entry->ebx |= 0xfffff000;
+	entry->ecx |= 0xffffffff;
+	entry->edx |= 0x00000007;
+
+	entry = kvm_find_cpuid_entry2((*cpuid)->entries, (*cpuid)->nent, 0x4, 1);
+	if (WARN_ON(!entry))
+		goto err;
+	entry->eax |= 0xffffc3ff;
+	entry->ebx |= 0xfffff000;
+	entry->ecx |= 0xffffffff;
+	entry->edx |= 0x00000007;
+
+	entry = kvm_find_cpuid_entry2((*cpuid)->entries, (*cpuid)->nent, 0x4, 2);
+	if (WARN_ON(!entry))
+		goto err;
+	entry->eax |= 0xffffc3ff;
+	entry->ebx |= 0xfffff000;
+	entry->ecx |= 0xffffffff;
+	entry->edx |= 0x00000007;
+
+	entry = kvm_find_cpuid_entry2((*cpuid)->entries, (*cpuid)->nent, 0x4, 3);
+	if (WARN_ON(!entry))
+		goto err;
+	entry->eax |= 0xffffc3ff;
+	entry->ebx |= 0xfffff000;
+	entry->ecx |= 0xffffffff;
+	entry->edx |= 0x00000007;
+
+	/* Fixup of CPUID leaf 0xB */
+	entry = kvm_find_cpuid_entry2((*cpuid)->entries, (*cpuid)->nent, 0xb, 0);
+	if (WARN_ON(!entry))
+		goto err;
+	entry->eax = 0x0000001f;
+	entry->ebx = 0x0000ffff;
+	entry->ecx = 0x0000ffff;
+
+	/*
+	 * Fixup of CPUID leaf 0x1f, which is totally configurable for TDs.
+	 */
+	entry = kvm_find_cpuid_entry2((*cpuid)->entries, (*cpuid)->nent, 0x1f, 0);
+	if (WARN_ON(!entry))
+		goto err;
+	entry->eax = 0x0000001f;
+	entry->ebx = 0x0000ffff;
+	entry->ecx = 0x0000ffff;
+
+	for (int i = 1; i <= 5; i++) {
+		entry = kvm_find_cpuid_entry2((*cpuid)->entries, (*cpuid)->nent, 0x1f, i);
+		if (!entry) {
+			entry = &(*cpuid)->entries[(*cpuid)->nent];
+			entry->function = 0x1f;
+			entry->index = i;
+			entry->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+			(*cpuid)->nent++;
+		}
+		entry->eax = 0x0000001f;
+		entry->ebx = 0x0000ffff;
+		entry->ecx = 0x0000ffff;
+	}
+
 	return 0;
 err:
 	kfree(*cpuid);
-- 
2.34.1


