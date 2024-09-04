Return-Path: <kvm+bounces-25819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECC6796AF0B
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:18:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B55C1C236EF
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3879912DD88;
	Wed,  4 Sep 2024 03:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TgQZqPzt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647BB83A09;
	Wed,  4 Sep 2024 03:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419680; cv=none; b=EotKz9ils1J3zDQwdfQufNbGxwAY45qwBFRihlr6jIQ62KEEVQPnHYCxRPRloHugq1/rjF+/ymQBtQVH2e41ZWiZi1Ms5wfLFVwhiqMtdD6tuQtDNCCcM5XebBg42sNi+sq4RvQReoVIBhqvRX52OSkVX2kb+PqTwXh0pkdilYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419680; c=relaxed/simple;
	bh=2SyccfbB6s6km++2Ia3ZkwXk8k1gu6IyfFGyB63uYas=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gz7qnv04y9cVo/j7aY5Fidm5NU4U6Rq8gkNpPANwKaGPxSLH7UIElDN0nKTCU5w+RalyW2QHTxAVKShJNrWLm7YJNIeXrOFeGB2AByrJkUzhSu1HQ+i+UaL9awQMuQxQm9bl9T5EPuCUURDqaiqbEeUt9ufJUdXRljvMuTZZ8N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TgQZqPzt; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419678; x=1756955678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2SyccfbB6s6km++2Ia3ZkwXk8k1gu6IyfFGyB63uYas=;
  b=TgQZqPzt9JWuAcCy6RAX5pzJDERxX7eahJwALFFx3PUwkrnZvbByE0rl
   sL98IX63aiep8XmrbuDIIJCzm8b2sO9bLyz+BxsfrOIEy0p50NINMI4V9
   JBVCQA4qJ3R2q6P8qTtYw+bUL6tqP1bXz1VmebPxDEqhKTg/HURpxonV4
   LvYbex4W1cn4SddOGR+LlV2CCZtOOODhu9AdRadApXiz//pOPSXJx1kB/
   E8RDMlCutKeKVzq8DVjx88E7RIYT/LdtMdMOKsNQSUcO+fEA7qHB3i26E
   4ZAP+pFQYqykUg1De+ANJdF2PUDeN7QR3/vln0RMrnpxLpAvqiC2aCuBp
   Q==;
X-CSE-ConnectionGUID: g1Mxmek/Q4iBswtW+QHkvA==
X-CSE-MsgGUID: DHZpvTmWRoaP9+/z5Y42wg==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564687"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564687"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:08 -0700
X-CSE-ConnectionGUID: 2ACuqrUzQteHeoXQFgRBQg==
X-CSE-MsgGUID: N7sIXiqQQoSX0c6zwYroEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106309"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:07 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 12/21] KVM: TDX: Set per-VM shadow_mmio_value to 0
Date: Tue,  3 Sep 2024 20:07:42 -0700
Message-Id: <20240904030751.117579-13-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Set per-VM shadow_mmio_value to 0 for TDX.

With enable_mmio_caching on, KVM installs MMIO SPTEs for TDs. To correctly
configure MMIO SPTEs, TDX requires the per-VM shadow_mmio_value to be set
to 0. This is necessary to override the default value of the suppress VE
bit in the SPTE, which is 1, and to ensure value 0 in RWX bits.

For MMIO SPTE, the spte value changes as follows:
1. initial value (suppress VE bit is set)
2. Guest issues MMIO and triggers EPT violation
3. KVM updates SPTE value to MMIO value (suppress VE bit is cleared)
4. Guest MMIO resumes.  It triggers VE exception in guest TD
5. Guest VE handler issues TDG.VP.VMCALL<MMIO>
6. KVM handles MMIO
7. Guest VE handler resumes its execution after MMIO instruction

Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU part 2 v1:
 - Split from the big patch "KVM: TDX: TDP MMU TDX support".
 - Remove warning for shadow_mmio_value
---
 arch/x86/kvm/mmu/spte.c |  2 --
 arch/x86/kvm/vmx/tdx.c  | 15 ++++++++++++++-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 46a26be0245b..4ab6d2a87032 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -94,8 +94,6 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 	u64 spte = generation_mmio_spte_mask(gen);
 	u64 gpa = gfn << PAGE_SHIFT;
 
-	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value);
-
 	access &= shadow_mmio_access_mask;
 	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
 	spte |= gpa | shadow_nonpresent_or_rsvd_mask;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0c08062ef99f..9da71782660f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -6,7 +6,7 @@
 #include "mmu.h"
 #include "tdx.h"
 #include "tdx_ops.h"
-
+#include "mmu/spte.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -344,6 +344,19 @@ int tdx_vm_init(struct kvm *kvm)
 {
 	kvm->arch.has_private_mem = true;
 
+	/*
+	 * Because guest TD is protected, VMM can't parse the instruction in TD.
+	 * Instead, guest uses MMIO hypercall.  For unmodified device driver,
+	 * #VE needs to be injected for MMIO and #VE handler in TD converts MMIO
+	 * instruction into MMIO hypercall.
+	 *
+	 * SPTE value for MMIO needs to be setup so that #VE is injected into
+	 * TD instead of triggering EPT MISCONFIG.
+	 * - RWX=0 so that EPT violation is triggered.
+	 * - suppress #VE bit is cleared to inject #VE.
+	 */
+	kvm_mmu_set_mmio_spte_value(kvm, 0);
+
 	/*
 	 * This function initializes only KVM software construct.  It doesn't
 	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
-- 
2.34.1


