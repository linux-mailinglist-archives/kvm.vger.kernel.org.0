Return-Path: <kvm+bounces-23916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0251294F9FE
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A19741F25CEB
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E62FF1A2C11;
	Mon, 12 Aug 2024 22:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CVxKztXN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0AF1A08B2;
	Mon, 12 Aug 2024 22:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502930; cv=none; b=FmuRxDt0aGKi61ydIRozhmLkPHjm3eltXQLAuE/RykYCG8ymDPbkmbnWrybxyaeAOxVO0aHQfyjE40qzST7zo0IPsC3pEoLduQ06ieu2ZlZDnSXOI3QfJ4+O+Eg4oeUCZnwfHtezuopWT6OIzKQEcdPO72tplbX7Knqau0ENkMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502930; c=relaxed/simple;
	bh=2MzQYYq/0msuwhfOTrXxKe8Z3ljlCGUDX8nja35C1iA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ScqARreiC0ZFgGaMTeamuChKCr8jJVYrNNlD03O9vR0sWSa1dO2ckb6q3xuN3RnnGbkwZAqjH0PcIJf8I+x5J9regHpVEpY75MupCn8XOGDgpzbNnCb3DtXymCJf8I4hZ/49xApW2ca4Gk3JFg5vLg55JgC2HibzUjBw9taO1fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CVxKztXN; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502928; x=1755038928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2MzQYYq/0msuwhfOTrXxKe8Z3ljlCGUDX8nja35C1iA=;
  b=CVxKztXNPeS0w80VEosJdGOUZh7F4UlBg4n++JYE8w5EMHrNHC+VzOC2
   6vVDjUpS6C4NEzruBO6mnnzx4nJTY6cTOtVikziN29/2R3NBJFjJHtdBl
   /TeTzqCdUi6Oe39xgU5FpahlWKRcca9l+518Zsx6vPgHo/r4tYbXGrsTu
   aYSegT+I0JPcFBlM4qrp+lTwjIwAT2foqI3J4XnGgCoe+iz5ZrDEAwyMO
   DvdyQvNDfOmdsOfQYIiXDIrQMIqr0lceB0Vbdf0w2itssq3GMy5D48nqV
   nfD9nBHB8iqi8v+w2Qetesmvi2QQOvMPNLxM6LrEAWVdHddxYk3qc9ZVL
   Q==;
X-CSE-ConnectionGUID: /72AuM/DQU28AyNE1+vzkA==
X-CSE-MsgGUID: eZCgkK1yRcaWnu2+PAOBJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041484"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041484"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:39 -0700
X-CSE-ConnectionGUID: JaCyJs85Rr68YwOdobHgpA==
X-CSE-MsgGUID: G68QV+gbTpyfIgnSe7WLVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008452"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:39 -0700
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
Subject: [PATCH 22/25] KVM: TDX: Use guest physical address to configure EPT level and GPAW
Date: Mon, 12 Aug 2024 15:48:17 -0700
Message-Id: <20240812224820.34826-23-rick.p.edgecombe@intel.com>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

KVM reports guest physical address in CPUID.0x800000008.EAX[23:16],
which is similar to TDX's GPAW. Use this field as the interface for
userspace to configure the GPAW and EPT level for TDs.

Note,

1. only value 48 and 52 are supported. 52 means GPAW-52 and EPT level
   5, and 48 means GPAW-48 and EPT level 4.
2. value 48, i.e., GPAW-48 is always supported. value 52 is only
   supported when the platform supports 5 level EPT.

Current TDX module doesn't support max_gpa configuration. However
current implementation relies on max_gpa to configure  EPT level and
GPAW. Hack KVM to make it work.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v1:
 - New patch
---
 arch/x86/kvm/vmx/tdx.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index fe2bbc2ced41..c6bfeb0b3cc9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -514,23 +514,22 @@ static int setup_tdparams_eptp_controls(struct kvm_cpuid2 *cpuid,
 					struct td_params *td_params)
 {
 	const struct kvm_cpuid_entry2 *entry;
-	int max_pa = 36;
+	int guest_pa;
 
 	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x80000008, 0);
-	if (entry)
-		max_pa = entry->eax & 0xff;
+	if (!entry)
+		return -EINVAL;
+
+	guest_pa = (entry->eax >> 16) & 0xff;
+
+	if (guest_pa != 48 && guest_pa != 52)
+		return -EINVAL;
+
+	if (guest_pa == 52 && !cpu_has_vmx_ept_5levels())
+		return -EINVAL;
 
 	td_params->eptp_controls = VMX_EPTP_MT_WB;
-	/*
-	 * No CPU supports 4-level && max_pa > 48.
-	 * "5-level paging and 5-level EPT" section 4.1 4-level EPT
-	 * "4-level EPT is limited to translating 48-bit guest-physical
-	 *  addresses."
-	 * cpu_has_vmx_ept_5levels() check is just in case.
-	 */
-	if (!cpu_has_vmx_ept_5levels() && max_pa > 48)
-		return -EINVAL;
-	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
+	if (guest_pa == 52) {
 		td_params->eptp_controls |= VMX_EPTP_PWL_5;
 		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
 	} else {
@@ -576,6 +575,9 @@ static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
 		value->ebx = entry->ebx;
 		value->ecx = entry->ecx;
 		value->edx = entry->edx;
+
+		if (c->leaf == 0x80000008)
+			value->eax &= 0xff00ffff;
 	}
 
 	return 0;
@@ -1277,6 +1279,10 @@ static int __init setup_kvm_tdx_caps(void)
 		memcpy(dest, &source, sizeof(struct kvm_tdx_cpuid_config));
 		if (dest->sub_leaf == KVM_TDX_CPUID_NO_SUBLEAF)
 			dest->sub_leaf = 0;
+
+		/* Work around missing support on old TDX modules */
+		if (dest->leaf == 0x80000008)
+			dest->eax |= 0x00ff0000;
 	}
 
 	return 0;
-- 
2.34.1


