Return-Path: <kvm+bounces-38948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B209A404F3
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:49:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2485862434
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEAF9205ABB;
	Sat, 22 Feb 2025 01:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BLNeYQ5D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BBB2054E7;
	Sat, 22 Feb 2025 01:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188817; cv=none; b=hgLCeFFymP/2nDl3s+TCwb3Ob0bMoIO21EsOtmc6d1WO1O0PFy9cxvyRbLxkShIS5nikIRB4pZgKzI3KybSH+TVwnXYAr/yVznTiIkazXQ/jTzz/xsRjSJAMva+O/Y0Iyw0o/TJKONOxKqeZdR/GUA33QQ9WOsrsqnm6t/1CaIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188817; c=relaxed/simple;
	bh=ME5W2oH81CP7EbcHz8CiWbMOrHZHpNdoq6XMHk/m2lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfXWcTnLSKDweMbw/wdH0ONbCubta4FIwRcFYNbmfrHoXCe/ZK132jZDP3kNCqSM05DOLqhWgtckv0GKCB68lFL6n2Gwe6hYXzl2eat3NKhXGiHNCUvokClxxvgMkZJ8AyAw5CvmkZeTTR9eiHf4zIF3l8BTjK4AhxllIdGBo+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BLNeYQ5D; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188817; x=1771724817;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ME5W2oH81CP7EbcHz8CiWbMOrHZHpNdoq6XMHk/m2lQ=;
  b=BLNeYQ5D9tGAukVc4ogY5FEr1m00cJsXJPXSdtVvIZPxLaM4t5lurgEv
   zDpc7d1rmI/E6TWqJESRSeIDoKMQotOSTOs7wyyOvb14ldvu5rWgu/1gz
   +WV+NoWft3qqklyffUw6tTU1Ee6zMLVZeDqsq5kzNJwOsq9WIbGBqmgry
   /t4zY5lc2YFd5ZndyWVrIsZyEQqks2jr5zHLlHbdupCfGyd5VEN/CKfKj
   xbZRSdfLEys6Yr2nCrWj+dHG9FmtvmVdxKiax0fz3CS/GGRXZdSEHM7Qt
   YCKIr0A0YQeLV+dRITFwNYCyAXvk/TEX4GmQeRqPoRTTg27w+WLb1Tp3q
   Q==;
X-CSE-ConnectionGUID: 7O0JhVZzTx2C2Djhjw3Eug==
X-CSE-MsgGUID: XHswPkv/Rv2mnjsk9r4i7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="52449055"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="52449055"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:56 -0800
X-CSE-ConnectionGUID: L32hzrCjT0yS4EKEr/REsA==
X-CSE-MsgGUID: 45/zR0DSSf2P6goKxsbhRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="120621703"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:53 -0800
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
Subject: [PATCH v3 10/16] KVM: TDX: Enforce KVM_IRQCHIP_SPLIT for TDX guests
Date: Sat, 22 Feb 2025 09:47:51 +0800
Message-ID: <20250222014757.897978-11-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014757.897978-1-binbin.wu@linux.intel.com>
References: <20250222014757.897978-1-binbin.wu@linux.intel.com>
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
TDX interrupts v3:
- No change.

TDX interrupts v2:
- New added.
---
 arch/x86/kvm/vmx/tdx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d52bfe39163a..e2288ec5d1a5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -14,6 +14,7 @@
 #include "mmu/spte.h"
 #include "common.h"
 #include "posted_intr.h"
+#include "irq.h"
 #include <trace/events/kvm.h>
 #include "trace.h"
 
@@ -658,8 +659,12 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
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


