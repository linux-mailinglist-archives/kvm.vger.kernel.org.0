Return-Path: <kvm+bounces-31579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 513059C4FBB
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:44:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB80BB2553D
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE7B020C000;
	Tue, 12 Nov 2024 07:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YrsJzqMU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C4E20BB49;
	Tue, 12 Nov 2024 07:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397216; cv=none; b=QCJS4BwjnvbVvMWY139mK1QtW6kDj1gIWWDLWKLZqmfeCKPQ2OJFmWYnh397RQN3RFhKPIQFThcmYDbS1bkPSv4GbI1oyEpS54FNKFQx0GgN9bbvMhLh+0Vnt68W8R1HdpxKDIE5aeQ2V3qmpfxIo3sTv4a0Ux+/2mnY3CcVWes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397216; c=relaxed/simple;
	bh=ATuGK4QHEOp9CzuIj/HnUEsWjzZZ+yVOHjj0esAelLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEpOMn7yll5tvAS96kKhTvVNEoHGFRMGe/ppeDT/GLEO+KLRxvXaEc9PNNyAmZH9e7/4ZqLgw5Olx5dx2oaWyXaP02RrSwUfaC0Qbsxkh3Eq+aNcMbpBGzQGhL0nDMUMRCeGVX3VGdkp+VPsdDoeW8jQiUJbdyjtGs2Ctp7vkoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YrsJzqMU; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397215; x=1762933215;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ATuGK4QHEOp9CzuIj/HnUEsWjzZZ+yVOHjj0esAelLs=;
  b=YrsJzqMUI/IG0hfd9PDpU0DzhE0gPefmeyHm7LZxlCpH07A3UUywoxIM
   F3vAe8rsr6C8PBCK3RSffQqkBMMprcATm6JmcAT8HgCQqM0k9fz3c3vxq
   tasdfTia+nYLePS3XZ4+u2/rqcyPCQ55WEq6zxREUfnOZL6fCp+orZbxE
   T/cpdsA35Xc+y96bwppCK8z/zlQnP5jhtxjFLLLjibjsoc4uFNe5I+5VS
   JNF49hRVvPmA4i90uUrIZ7A20auPmBTIpKxwmdSnOPEv8WY8gYmez5GdC
   3bJccNpA6VoHmFcQ/tFu6Rq2CZXAjgSHIkYmcTZ2rUOUGvAiCspUtSIxC
   Q==;
X-CSE-ConnectionGUID: zfPrR7s7Qd6x0P9hEr199g==
X-CSE-MsgGUID: kfga5oBZR0GWqh7xfc7AKg==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="31090630"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="31090630"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:40:14 -0800
X-CSE-ConnectionGUID: kbajvGrFSlOzLveGKflLCA==
X-CSE-MsgGUID: BNbJ+AG9QH6xkIzJ6kMmCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="92089301"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:40:09 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 16/24] KVM: TDX: Set per-VM shadow_mmio_value to 0
Date: Tue, 12 Nov 2024 15:37:43 +0800
Message-ID: <20241112073743.22214-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
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

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX MMU part 2 v2:
 - Added Paolo's rb.

TDX MMU part 2 v1:
 - Split from the big patch "KVM: TDX: TDP MMU TDX support".
 - Remove warning for shadow_mmio_value
---
 arch/x86/kvm/mmu/spte.c |  2 --
 arch/x86/kvm/vmx/tdx.c  | 15 ++++++++++++++-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index a831e76f379a..817c68ad8bd5 100644
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
index 8832f76e4a22..37696adb574c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -5,7 +5,7 @@
 #include "mmu.h"
 #include "x86_ops.h"
 #include "tdx.h"
-
+#include "mmu/spte.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -415,6 +415,19 @@ int tdx_vm_init(struct kvm *kvm)
 
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
 	 * TDX has its own limit of maximum vCPUs it can support for all
 	 * TDX guests in addition to KVM_MAX_VCPUS.  TDX module reports
-- 
2.43.2


