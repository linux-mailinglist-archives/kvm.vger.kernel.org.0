Return-Path: <kvm+bounces-9677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA522866CB8
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:44:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63522281879
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D759604BB;
	Mon, 26 Feb 2024 08:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ic9reTHp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737115FDAF;
	Mon, 26 Feb 2024 08:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936100; cv=none; b=MGDrCyWrqjud1rRcP3nDMjpJKnxQik0eCvRnMsjPEG7J6rXfKKWWgWcn7RVwgek6LiqQ2EFr0w2iR1M3KhNTRmg5lfmQKB+uLgmukTTqgLK2iPrl/FMatH+O/HEAKXnPlK1izs7iT8oW8V3oLrjCD+HA9REkM/5ttnLu+fsbENY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936100; c=relaxed/simple;
	bh=F2Aq5/aMdhbNlEsFZSbUWHxeFsIV+hsLMCdd356a0sA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QAdx+35Sfilj71eBECALqBfp8HpdLqbwr+YkDtg9dpWgInCi/80AYz6k/ByM673FEXm6u+ypptwRXlcTgivNaTtqAZTqSwenihd4EMIaddT7aRPFNfl7uCc2wN6VUL/DiA0pxUL8uX24vRdsj5s92BJHsJnYnOnXHMYlTeLxkZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ic9reTHp; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936098; x=1740472098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F2Aq5/aMdhbNlEsFZSbUWHxeFsIV+hsLMCdd356a0sA=;
  b=ic9reTHpRInzMtCmwML4COq2IRqv2HnGLk5075regJrHirutjdcYEtpp
   MCe5FBJVRF4In/47/BX6i4+Xq/uK4RTe28FTjBOa4IQxfYRQp8jRsKHiS
   MKbnurSw0AfC/MAR46rtO3vqNXKtfw0KgVURkZWGqUK8zcGjpxB7Rw0Kt
   gkoqCBZwBf+E4/gBv31/ENKAz+JStgLfK21VjiT+bUnyKgk/2UgEsAYwK
   pCcL2ubYgqvkHbFXH0+77ty0yo5Dw2TWkA/B7rvE61leJ58k96XFtWA15
   r5h84fsrq4siR97hHcEzZ4qhhS1St203OerndOUQGHRsQVlRol2UO4zCR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155396"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155396"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615830"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:13 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v19 053/130] KVM: x86/mmu: Disallow fast page fault on private GPA
Date: Mon, 26 Feb 2024 00:25:55 -0800
Message-Id: <af70ce8626cb7366d9b86a41c5d731f8ebd144ff.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX requires TDX SEAMCALL to operate Secure EPT instead of direct memory
access and TDX SEAMCALL is heavy operation.  Fast page fault on private GPA
doesn't make sense.  Disallow fast page fault on private GPA.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
v19:
- updated comment to mention VM type other than TDX.
---
 arch/x86/kvm/mmu/mmu.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 84e7a289ad07..eeebbc67e42b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3339,8 +3339,18 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 	return RET_PF_CONTINUE;
 }
 
-static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
+static bool page_fault_can_be_fast(struct kvm *kvm, struct kvm_page_fault *fault)
 {
+	/*
+	 * TDX private mapping doesn't support fast page fault because the EPT
+	 * entry is read/written with TDX SEAMCALLs instead of direct memory
+	 * access.
+	 * For other VM type, kvm_is_private_gpa() is always false because
+	 * gfn_shared_mask is zero.
+	 */
+	if (kvm_is_private_gpa(kvm, fault->addr))
+		return false;
+
 	/*
 	 * Page faults with reserved bits set, i.e. faults on MMIO SPTEs, only
 	 * reach the common page fault handler if the SPTE has an invalid MMIO
@@ -3450,7 +3460,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	u64 *sptep;
 	uint retry_count = 0;
 
-	if (!page_fault_can_be_fast(fault))
+	if (!page_fault_can_be_fast(vcpu->kvm, fault))
 		return ret;
 
 	walk_shadow_page_lockless_begin(vcpu);
-- 
2.25.1


