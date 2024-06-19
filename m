Return-Path: <kvm+bounces-20021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2961B90F917
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:38:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3457E1C21AFB
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57E5C15F30D;
	Wed, 19 Jun 2024 22:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fmffDMEX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FE115B573;
	Wed, 19 Jun 2024 22:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836588; cv=none; b=OXj16GSmGRPLflFv4MduOTrxbtHWZx1NTVkNmk2KztV8yiP6lrXVcOsdWfm04rbPSsFlOGnOm0bUzHXDUCdwdBkyCzg0C+vjF2TIb59a3gCbnDskyW/VfgntZSCTTPGM4VB4au33pDOqCTr8NuonSAqXk54EhcmtPEqxVS3PBaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836588; c=relaxed/simple;
	bh=lqncN2do7NL+R425huiQkUvoZZdiNFBxemu6U6UT3ug=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=axJH+J5XH7HDFVq0I2+4KGXPiasDyH4MS+01lEfV1ZF/KvxChhjViTmNoPoDqFXm6kdidvL7irePcyxRHGIbFB85e0hVdzyZWtaTYx1AcX4H75BB/CFoNvIV5ctEcho+4xlAjYCTOba7hFTsa27dps4lng+KnQzyupqres9Kxss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fmffDMEX; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836587; x=1750372587;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lqncN2do7NL+R425huiQkUvoZZdiNFBxemu6U6UT3ug=;
  b=fmffDMEXXxUGIG4MQGyWJw1H08HasuZw3lil5bRGK0R7UqP9hN2h4bjU
   GDFX5vIW+OiullYBfSm9jdikHsysvRJNB/Pe4+uGicgie5puMPEJ8F8RF
   4iZiNgSHc0uN05jruBXViK7oGZMg0yMsviaMfksDdtpqH69w9WjfO2SOT
   57Lt0LRkWvGIks9IlPDBG7juLJ3JoXjHK+ycuEf4xxExFTE530UjNVoYT
   C+4yyTAzdK4DYKmX0YAm+yYVNkS72MwSqYTqP0b1laUrqyqZwQPNCAM08
   DR0rO98gEwZpn7g1ur/lTi6LYlj6amn5efuUdYKJbidktCX3SYfq4dIAm
   g==;
X-CSE-ConnectionGUID: S8GeqQcLSSGx5AnA/xHW0w==
X-CSE-MsgGUID: BJ8mGLP1QlSZiLlSUq/PSA==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15931963"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15931963"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:22 -0700
X-CSE-ConnectionGUID: A7gpxV9sQFmySh6QDL16jQ==
X-CSE-MsgGUID: i6E0d/UeTni7Wy7v2P0T7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793343"
Received: from ivsilic-mobl2.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.54.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:21 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	erdemaktas@google.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	sagis@google.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v3 08/17] KVM: x86/tdp_mmu: Take a GFN in kvm_tdp_mmu_fast_pf_get_last_sptep()
Date: Wed, 19 Jun 2024 15:36:05 -0700
Message-Id: <20240619223614.290657-9-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pass fault->gfn into kvm_tdp_mmu_fast_pf_get_last_sptep(), instead of
passing fault->addr and then converting it to a GFN.

Future changes will make fault->addr and fault->gfn differ when running
TDX guests. The GFN will be conceptually the same as it is for normal VMs,
but fault->addr may contain a TDX specific bit that differentiates between
"shared" and "private" memory. This bit will be used to direct faults to
be handled on different roots, either the normal "direct" root or a new
type of root that handles private memory. The TDP iterators will process
the traditional GFN concept and apply the required TDX specifics depending
on the root type. For this reason, it needs to operate on regular GFN and
not the addr, which may contain these special TDX specific bits.

Today kvm_tdp_mmu_fast_pf_get_last_sptep() takes fault->addr and then
immediately converts it to a GFN with a bit shift. However, this would
unfortunately retain the TDX specific bits in what is supposed to be a
traditional GFN. Excluding TDX's needs, it is also is unnecessary to pass
fault->addr and convert it to a GFN when the GFN is already on hand.

So instead just pass the GFN into kvm_tdp_mmu_fast_pf_get_last_sptep() and
use it directly.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep v3:
 - New patch
---
 arch/x86/kvm/mmu/mmu.c     | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
 arch/x86/kvm/mmu/tdp_mmu.h | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 138e7bbcda1e..e9c1783a8743 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3452,7 +3452,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		u64 new_spte;
 
 		if (tdp_mmu_enabled)
-			sptep = kvm_tdp_mmu_fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
+			sptep = kvm_tdp_mmu_fast_pf_get_last_sptep(vcpu, fault->gfn, &spte);
 		else
 			sptep = fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4a7518c9ba7e..067249dbbb5e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1801,12 +1801,11 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
  *
  * WARNING: This function is only intended to be called during fast_page_fault.
  */
-u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
+u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 					u64 *spte)
 {
 	struct tdp_iter iter;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	gfn_t gfn = addr >> PAGE_SHIFT;
 	tdp_ptep_t sptep = NULL;
 
 	tdp_mmu_for_each_pte(iter, vcpu->kvm, mmu, gfn, gfn + 1) {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 437ddd4937a9..1ba84487f3b7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -64,7 +64,7 @@ static inline void kvm_tdp_mmu_walk_lockless_end(void)
 
 int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level);
-u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
+u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 					u64 *spte);
 
 #ifdef CONFIG_X86_64
-- 
2.34.1


