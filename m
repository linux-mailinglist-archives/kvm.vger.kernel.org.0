Return-Path: <kvm+bounces-25820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A43D96AF0F
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:18:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 147F32853F6
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A060139D0B;
	Wed,  4 Sep 2024 03:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YTQRQ0v5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E2D8563E;
	Wed,  4 Sep 2024 03:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419681; cv=none; b=r0KzrR/IRsks2ixQktpk1FOYAJGp5qYDtydcjQss8E0Z92fmP7D+NLtQbEunEiZlwl7DiUOdE2ZqKexTEGuOCHMgZLVA29u7myji1FUTWiQZjUi07qnkjSreeQwLYQKfv558L/P9UHmeyTBrMHepmMlsNiMDbgP6p7pYKuoANUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419681; c=relaxed/simple;
	bh=wP6n/PTkt2MkcS+mzx6vYUWeiv3rxjJDxuCBmkWaUKA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nFWQYowp2fpJZB7OCgluNygo7n7dnaEuHx3uh8rkifRm4bZ5AGG6aFfO8w2AaYdBs1ZZWBXY9XKefoH6ACOVM01F8U0l4ykJncSZOeFmd75XnHJdJQgJNNbSs6uZRL2Aoc6Y+uS8o2wdMg+9P45B1l03ooZHzZSGNnzxTdkWKbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YTQRQ0v5; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419679; x=1756955679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wP6n/PTkt2MkcS+mzx6vYUWeiv3rxjJDxuCBmkWaUKA=;
  b=YTQRQ0v5Ghjnpa8TKA2iNJu8NnzRv8kbZDp54nrjlFFiZ6wBoCeeKD+k
   Ep6HLYxxYMPtftD10nSULJNUbVG70zWiJDprpbEBpyTvHVDbYcu3MNHzX
   GtIba7hbm3kn8Z0pXopvo22dq4aantwdca0H8qv+Vd9yZrCFexB9EkrP7
   oLZMJP5z71HORBq8y2tmwc6iIaciCCkNRF1DpMV/O9fEhSil4Ep4ZJwSp
   i01JDFNPBsAmoK6S02MgKc+R7bIw6DoU+kZIv9XAVlON0gWgGXYISJDlX
   2nvEBWOgTr+QdVsRysZMCcVYguepT/EPLTBLyUP6AAal4kzm/VdljTp1F
   g==;
X-CSE-ConnectionGUID: JPPdIrOGQSqmU1/9l1kmtA==
X-CSE-MsgGUID: WbaGPGImQjKiiAZsNG4Esw==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564678"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564678"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:08 -0700
X-CSE-ConnectionGUID: 7J4gV4u/SeK88DkfSUzc5g==
X-CSE-MsgGUID: Vjf2DoCwTn+HNFM3tZSqgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106299"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:06 -0700
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
Subject: [PATCH 11/21] KVM: x86/mmu: Add setter for shadow_mmio_value
Date: Tue,  3 Sep 2024 20:07:41 -0700
Message-Id: <20240904030751.117579-12-rick.p.edgecombe@intel.com>
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

Future changes will want to set shadow_mmio_value from TDX code. Add a
helper to setter with a name that makes more sense from that context.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[split into new patch]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU part 2 v1:
 - Split into new patch
---
 arch/x86/kvm/mmu.h      | 1 +
 arch/x86/kvm/mmu/spte.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 5faa416ac874..72035154a23a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -78,6 +78,7 @@ static inline gfn_t kvm_mmu_max_gfn(void)
 u8 kvm_mmu_get_max_tdp_level(void);
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
+void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index d4527965e48c..46a26be0245b 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -409,6 +409,12 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
+void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value)
+{
+	kvm->arch.shadow_mmio_value = mmio_value;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_value);
+
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask)
 {
 	/* shadow_me_value must be a subset of shadow_me_mask */
-- 
2.34.1


