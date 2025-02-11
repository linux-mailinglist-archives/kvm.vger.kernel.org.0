Return-Path: <kvm+bounces-37798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7966A301E6
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 04:00:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7897188C22E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A26361E9B3A;
	Tue, 11 Feb 2025 02:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q9Jy6IQ5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705C21E9B20;
	Tue, 11 Feb 2025 02:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242649; cv=none; b=Oe09f3Il5UkCBLfjy9JSo8I7hi+mImtJs6Z/F9Q5Njyceqh2DX9p+1ykoOLt9jTgMSV/Dg9LGPvR8NaXZENGUEqp0jN09XQcaveafyxeQni+wlkaOULe9VltLPyemwDwdhn8dPeFfpf3nx7Mljt85G/bt5jv+sdMNC51RXPrWOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242649; c=relaxed/simple;
	bh=VJXEff56lStQBPGfmawPOxR5BfoAbbKjmYmLYPKNlvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGP+86gb0A1Yb2RUd+YhpfiTz/SKvdY0LRge+4qzdQDw3GJ/it/oKoY+mVQr9rggAKQ3q1RWkpR04zIx1MJb7QcAQ+3cefVrw4Tj25h6pdlgxGPobvOm7MtFO2mwLL7NBSOmUuJM8xc/iZ1T/zK/5Vrp4kTY1/clkLT7jVbjmtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q9Jy6IQ5; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242649; x=1770778649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VJXEff56lStQBPGfmawPOxR5BfoAbbKjmYmLYPKNlvA=;
  b=Q9Jy6IQ5dQGeqHW7yawXi8ufiU65S8mzgmfYHNtCOKK4/uHY4VsPuudm
   IzXnlf49D/a3CZteSztC6afITLMgqZgh54nciHkyja7BIfMSeUyqH/bEo
   t4HDBQqAHjowc6BSkimSnsRoVYKpZ0QEWNToIQc3TEX4IYvddwVAj5M5o
   5rHf9sHt1gdgVxoofC3eni8IGOxh7FEdhAr3fLCC7IPjVK+yVi+eS1T6j
   PEKkqAYZtj0ryeJVd/LIRTEam16DZJiMkB0tgGgrxuKwxeBBIp/OfhR2N
   uRZU+vVABu2qQ0NiAyWr0gSKHXiUyQOaNClzIfPoWN/UaVHPHrxMQUJnS
   Q==;
X-CSE-ConnectionGUID: vVC3Tz6hRhWC3Qtmru242A==
X-CSE-MsgGUID: sHoB74r8RVWmM5h4K24YIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43612481"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43612481"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:29 -0800
X-CSE-ConnectionGUID: 1vxBCD6EQiOwBb9IengWpw==
X-CSE-MsgGUID: 3u3oO0HCQlOh2ycIJzQ4Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112355366"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:25 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 11/17] KVM: TDX: Enforce KVM_IRQCHIP_SPLIT for TDX guests
Date: Tue, 11 Feb 2025 10:58:22 +0800
Message-ID: <20250211025828.3072076-12-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enforce KVM_IRQCHIP_SPLIT for TDX guests to disallow in-kernel I/O APIC
while in-kernel local APIC is needed.

APICv is always enabled by TDX module and TDX Module doesn't allow the
hypervisor to modify the EOI-bitmap, i.e. all EOIs are accelerated and
never trigger exits.  Level-triggered interrupts and other things depending
on EOI VM-Exit can't be faithfully emulated in KVM.  Also, the lazy check
of pending APIC EOI for RTC edge-triggered interrupts, which was introduced
as a workaround when EOI cannot be intercepted, doesn't work for TDX either
because kvm_apic_pending_eoi() checks vIRR and vISR, but both values are
invisible in KVM.

If the guest induces generation of a level-triggered interrupt, the VMM is
left with the choice of dropping the interrupt, sending it as-is, or
converting it to an edge-triggered interrupt.  Ditto for KVM.  All of those
options will make the guest unhappy. There's no architectural behavior KVM
can provide that's better than sending the interrupt and hoping for the
best.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts v2:
- New added.
---
 arch/x86/kvm/vmx/tdx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index bd349e3d4089..4b3251680d43 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -13,6 +13,7 @@
 #include "mmu/spte.h"
 #include "common.h"
 #include "posted_intr.h"
+#include "irq.h"
 #include <trace/events/kvm.h>
 #include "trace.h"
 
@@ -663,8 +664,12 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	if (kvm_tdx->state != TD_STATE_INITIALIZED)
 		return -EIO;
 
-	/* TDX module mandates APICv, which requires an in-kernel local APIC. */
-	if (!lapic_in_kernel(vcpu))
+	/*
+	 * TDX module mandates APICv, which requires an in-kernel local APIC.
+	 * Disallow an in-kernel I/O APIC, because level-triggered interrupts
+	 * and thus the I/O APIC as a whole can't be faithfully emulated in KVM.
+	 */
+	if (!irqchip_split(vcpu->kvm))
 		return -EINVAL;
 
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
-- 
2.46.0


