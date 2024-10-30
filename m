Return-Path: <kvm+bounces-30103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 891E59B6CBD
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:10:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FAC11F221E1
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF2912296ED;
	Wed, 30 Oct 2024 19:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KBB92bkW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0302281FE;
	Wed, 30 Oct 2024 19:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314883; cv=none; b=BiTgPPywhiqSqkFZYvqTeO5+6j4pf8oEqMw8j6S3nQmtrznCS/dkgA6y8nMmvGEjabkeIyJ2Q6rpv4Ahf0KoI8WOEmLYBg/l3RrmdtZuhA9NcyXeaf3QTbO3Pxxw2/frB4HZecgR1ZLcer/hJQeU0ioMuggoRie2i7aMU9y8sAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314883; c=relaxed/simple;
	bh=2CVYgvFARR/9Ofmj+WCQSPOPjEa/ehZNBe3S2d4rNUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kno2uF9kGanvvKLEOSsN7mphxG4bKsamWbv3dgv7rJk0RDVWiylJ+8Jf5ftfsc13azfmwjRbZDd0PLztmZATtbyr6QkcM4M1/zGnHc7Gmd2P3aQPKZQdNmhZJGGg6JQkoNvTZJsrWyYIzOlcrnOun5aJicOx8GgTREcn9V/sZ4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KBB92bkW; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314880; x=1761850880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2CVYgvFARR/9Ofmj+WCQSPOPjEa/ehZNBe3S2d4rNUg=;
  b=KBB92bkWPjwQtUX3OFtFgMMW6uVo6gQG63tDHlCCOX6gEfmRJ4eZ4Sln
   +h7imxeLtR3M8gFxrBRcp25gsj4CSRxXEnfLsef0OGhE4kPEAOxD7Bq75
   Cb4bn+8Z69N+L5UaZ2by9rXESuzj9XEgpEIm5SvKi6pNe3DETzmlaO08X
   EBYm/jMFnlbPohXDKtk4XPt3rzf2elCQTZB5aRNXQgysxBBnjbkXOLVAT
   HEcNaBBHLWcT2HwkveaPN7V+ooZocYU4Fm4zDrDyPGNLn2xpWoGBdCDF0
   o9a3wfGRv7UxYCgbgPXh9vC0W5p4x/AgqAVyK8c0YRz6WP9+v6oRPE3vG
   w==;
X-CSE-ConnectionGUID: q5xeqredS1GrvnP7rQ4abw==
X-CSE-MsgGUID: TYCMro0ARxmenu3qS/0soQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678863"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678863"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:09 -0700
X-CSE-ConnectionGUID: WxANfO81RhqAnMRdHJ9OsQ==
X-CSE-MsgGUID: vbdhL48zSX2xJ2zq+5XdpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499471"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:08 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com
Subject: [PATCH v2 25/25] KVM: x86/mmu: Taking guest pa into consideration when calculate tdp level
Date: Wed, 30 Oct 2024 12:00:38 -0700
Message-ID: <20241030190039.77971-26-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

For TDX, the maxpa (CPUID.0x80000008.EAX[7:0]) is fixed as native and
the max_gpa (CPUID.0x80000008.EAX[23:16]) is configurable and used
to configure the EPT level and GPAW.

Use max_gpa to determine the TDP level.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v2:
 - Use if else for cpuid_query_maxguestphyaddr() (Paolo)

uAPI breakout v1:
 - New patch
---
 arch/x86/kvm/cpuid.c   | 14 ++++++++++++++
 arch/x86/kvm/cpuid.h   |  1 +
 arch/x86/kvm/mmu/mmu.c |  9 ++++++++-
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 14be20e003f4..e7179ce8eadc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -423,6 +423,20 @@ int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu)
 	return 36;
 }
 
+int cpuid_query_maxguestphyaddr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 0x80000000);
+	if (!best || best->eax < 0x80000008)
+		goto not_found;
+	best = kvm_find_cpuid_entry(vcpu, 0x80000008);
+	if (best)
+		return (best->eax >> 16) & 0xff;
+not_found:
+	return 0;
+}
+
 /*
  * This "raw" version returns the reserved GPA bits without any adjustments for
  * encryption technologies that usurp bits.  The raw mask should be used if and
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 00570227e2ae..61b839aa3548 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -37,6 +37,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 u32 xstate_required_size(u64 xstate_bv, bool compacted);
 
 int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu);
+int cpuid_query_maxguestphyaddr(struct kvm_vcpu *vcpu);
 u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu);
 
 static inline int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9a0fbec33984..2e253a488949 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5474,12 +5474,19 @@ void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
 
 static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 {
+	int maxpa;
+
+	if (vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM)
+		maxpa = cpuid_query_maxguestphyaddr(vcpu);
+	else
+		maxpa = cpuid_maxphyaddr(vcpu);
+
 	/* tdp_root_level is architecture forced level, use it if nonzero */
 	if (tdp_root_level)
 		return tdp_root_level;
 
 	/* Use 5-level TDP if and only if it's useful/necessary. */
-	if (max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)
+	if (max_tdp_level == 5 && maxpa <= 48)
 		return 4;
 
 	return max_tdp_level;
-- 
2.47.0


