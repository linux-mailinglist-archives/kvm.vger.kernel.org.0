Return-Path: <kvm+bounces-60662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9360BF6208
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 13:46:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10677481AD5
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 11:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 648BF332913;
	Tue, 21 Oct 2025 11:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UaIEMzHA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC80330B0E;
	Tue, 21 Oct 2025 11:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761047039; cv=none; b=PyELmxnvGe9LufRw6KNtwkSa8ufumcPXbdw/AfVjpeYrcFCimg3TQLDh6KFvrSPFCg23d2FmrXCCOc41mQkiqNDD1bmx032XPvFxaPsnoGTpMpY5OYFDtuhmGAzYueGiy9BO1j+vTsYH1i6tyviVVY4SapJHePOc3DfGAYwkl3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761047039; c=relaxed/simple;
	bh=OFNrsU3JRTQXEDjCXq5QJnSNFXxzAmK95k5S5RSLB/g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=arFYJscycsL3w52H8zGUHoow4InHgF7ZHnJ+PRbxv3AoxzfgLtHYuwF5cY3zwAuOFNuL9I4u/KRGreVgzTye9ZhcLmVzBb6n8Jc5FphwAMlsRRkafFk2D7JFu7Q+2LZwXy1l19NMl+o14a7xnSNLmQtr/MtLuc6m7PiTn2vh/cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UaIEMzHA; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761047038; x=1792583038;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OFNrsU3JRTQXEDjCXq5QJnSNFXxzAmK95k5S5RSLB/g=;
  b=UaIEMzHAgdoileQvUeW1FKJEQPkCap1uSoVPvb1IUE+mG2arhNEBV/Hs
   ykhWjUlyK1TqWEm6kjnEO2i2SYpNiyAm2sXIvvmlEsgDBYHV1IeE7GKsq
   9lLX+w3lU/7VFpA3PEtjwphQiz4hB9JKZXbvY4t5edoP3GYaFK/HV5sdl
   hcFXRnHcUv42qNj/0+0TX0nI2k28ENJGpk2i89DnrqML+oBG+5uCRnVk/
   yFQIxkdxJ7vRZN4Pn/8AW9DNJqg2U1qHYNnbTofIt0DNkDNrLCCvellIJ
   zqe124knDWLNqbkjzWEzANfgWx643c829RyI2kQNA4v67xQNVhYvDQW0H
   w==;
X-CSE-ConnectionGUID: +N7ueLBiTBeoXjyGVvalIw==
X-CSE-MsgGUID: jbcqfcwfQiqAX7RcVe5qOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62870403"
X-IronPort-AV: E=Sophos;i="6.19,244,1754982000"; 
   d="scan'208";a="62870403"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 04:43:58 -0700
X-CSE-ConnectionGUID: sa2P/jnWSHi66tKVHz4x2w==
X-CSE-MsgGUID: U2uPzI1dQUOrMIuCkM1ncw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,244,1754982000"; 
   d="scan'208";a="182774045"
Received: from jjgreens-desk21.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.228])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 04:43:56 -0700
From: Kai Huang <kai.huang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Move the misplaced export of kvm_zap_gfn_range()
Date: Wed, 22 Oct 2025 00:43:45 +1300
Message-ID: <20251021114345.159372-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, the export of kvm_zap_gfn_range() is misplaced, i.e., it's
not placed right after the kvm_zap_gfn_range() function body but after
kvm_mmu_zap_collapsible_spte().  Move it to the right place.

No functional change intended.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 18d69d48bc55..329cf3508f46 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6863,6 +6863,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	write_unlock(&kvm->mmu_lock);
 }
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_zap_gfn_range);
 
 static bool slot_rmap_write_protect(struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head,
@@ -7204,7 +7205,6 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 
 	return need_tlb_flush;
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_zap_gfn_range);
 
 static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 					   const struct kvm_memory_slot *slot)

base-commit: b850841a53c56665c1f623edd429b3fc1578e9a4
-- 
2.51.0


