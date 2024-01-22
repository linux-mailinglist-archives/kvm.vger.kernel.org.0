Return-Path: <kvm+bounces-6617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B91F8379E9
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:46:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7D9B283709
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB14B60271;
	Mon, 22 Jan 2024 23:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M4XOilq+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3A75FEF5;
	Mon, 22 Jan 2024 23:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967737; cv=none; b=BneyNo+uYNqeuV/ZZQW3HSE2WHWzbdWvPhTjDiYq/0qzUBtyCMNyhqyyWpGk9CXkuYKhWNGJ4/K2ffdf2gVxEGJs1tOF2Y+QLjhWVjAPmEeAXdFF4BDdomirWwfswCvn6HagSvj2mhq7vjPjxVVZyW29GAYud/Qh9NNmCiie99w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967737; c=relaxed/simple;
	bh=chY2+qiG2bxQXUnEknok9B3h78h3C4cnGm0duvtnKuY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ovrmtsYmI+7XL7jZS89J7lA9IV1atLdzPezwBZfpbAmuKXzocUtG/Hjzo0bRS1Aq+Cr7JHaoYFp08ztItBZgmCRO1NXpfL/Pf8fCWumZApcJkuurneSN2GMVyVu0bKmvrugYa2GgKlpVbFaCYxWtCRkzXXtH+4vlEvV5GWtqUkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M4XOilq+; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967736; x=1737503736;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=chY2+qiG2bxQXUnEknok9B3h78h3C4cnGm0duvtnKuY=;
  b=M4XOilq+mONao9XBxlE46WTRvBooVpn2PIQZZ1iu7FUoEC717ZdjM3C1
   XgG7JmHu2xEr7o4FBB0cfUkAfusFYYqXmL3ZdwCUAmierad2RIhgJaAkm
   YwFIKkf+cF5r9luAZQ6wuJEDxA/QuB9VCoyAfJC1IrUjNGvg0TA2/tCE/
   7guBynUGJ7aUuY1CbNCn6B70wXJ9d+79gPhz0rQDDkp9WPAYt4tmLDZVM
   6SMo8fG7seS6q+yja07Uvf91nIZ24bOTPvaWtFpR8P3UL2KR3yKPfURYd
   FQBrRD9pf5M8XNjJvSnmgWCeHBrn//cBw26yZbh2HUXl4VABQbp2UTDep
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016367"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016367"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468095"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:29 -0800
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
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH v18 044/121] KVM: x86/mmu: Assume guest MMIOs are shared
Date: Mon, 22 Jan 2024 15:53:20 -0800
Message-Id: <cce34006a4db0e1995ce007c917f834b117b12af.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chao Gao <chao.gao@intel.com>

Guest TD doesn't necessarily invoke MAP_GPA to convert the virtual MMIO
range to shared before accessing it.  When TD tries to access the virtual
device's MMIO as shared, an EPT violation is raised first.
kvm_mem_is_private() checks whether the GFN is shared or private.  If
MAP_GPA is not called for the GPA, KVM thinks the GPA is private and
refuses shared access, and doesn't set up shared EPT entry.  The guest
can't make progress.

Instead of requiring the guest to invoke MAP_GPA for regions of virtual
MMIOs assume regions of virtual MMIOs are shared in KVM as well (i.e., GPAs
either have no kvm_memory_slot or are backed by host MMIOs). So that guests
can access those MMIO regions.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e93bc16a5e9b..583ae9d6bf5d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4371,7 +4371,12 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+	/*
+	 * !fault->slot means MMIO.  Don't require explicit GPA conversion for
+	 * MMIO because MMIO is assigned at the boot time.
+	 */
+	if (fault->slot &&
+	    fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
 		if (vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM)
 			return RET_PF_RETRY;
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
-- 
2.25.1


