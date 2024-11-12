Return-Path: <kvm+bounces-31564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F04569C4F91
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:37:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9AEB1F25C11
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7504820B7F9;
	Tue, 12 Nov 2024 07:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iB7rW+eg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C5820A5FB;
	Tue, 12 Nov 2024 07:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397024; cv=none; b=HqARHr9J14ZvDLpW8EgX7BPJshh1dj4ajMCXlQG4AVwoAC2m3Ce+kj8Xn5/gj5sebskfvzqurN3lEgAKkgCVDNYhfrPVG3AArsSKZ70Xq5iF5aL9ihENyiJVnZ/8nA2f+QmRsvePfTsQlnaawA+A5i8qHB5FQ4sQj0FjxzIU/Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397024; c=relaxed/simple;
	bh=sYlwcimPr/bcLGxNCU6gu7tC+Bt3r+i40j9uiMiWFoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLOnGmd5ZKPstB5aL8VJZPdHKl8VRn5dXJ0Ijl5zPeTezvuVCGN8JEoHNW1Wl7dpp41BflOR0ADs6wcpjavwpih2pR/XIVMHXrFraB85Xx7EPCNES17jVL6m17CoNnulirqFCoOXWLodm6qfTfNZviMketF9LDtgDwmEn3fCWxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iB7rW+eg; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397023; x=1762933023;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sYlwcimPr/bcLGxNCU6gu7tC+Bt3r+i40j9uiMiWFoI=;
  b=iB7rW+egSHVgZuGlBH1kzC9Mol5ICrLfLEDEzqj42J+TXJjj7ccv3i0n
   aL3HevzbiFO7LRzBGNpfzPRRca3Gxtf6iZCj8b1jNCcQ1/ZJC6KfWz5Pn
   9oLuLb5GY4TRjLWaWwRrMW5EnQOJcvEYqYOpD8ukUknOJQn/5EgxliAjy
   7Vw5fjoRdIp4sluuzwEUuHIgpn7TQ22oL1ZgN5qgAcnYOEm/rjKvanzpC
   DFpIW1B/FbJpNxv8CwLexAYnN+MfcrZPBrDsk0OZ5w2UBRrlKCnCHTdcI
   JBnhLNcYWyWcAyo2Bhb0d75sii0Eyl2otdqU90WIOScB/PCIRUp8oTWIL
   A==;
X-CSE-ConnectionGUID: zp9osZzbQjOdWFwSjnJ0tQ==
X-CSE-MsgGUID: J+QGyxiyRteAkkn3INBd5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31389118"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31389118"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:37:03 -0800
X-CSE-ConnectionGUID: 1kvmQp4JSI6yopj1pAkjlw==
X-CSE-MsgGUID: hSC+T8WiRyeZJPfII3pgpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="87081579"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:36:56 -0800
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
Subject: [PATCH v2 01/24] KVM: x86/mmu: Implement memslot deletion for TDX
Date: Tue, 12 Nov 2024 15:34:26 +0800
Message-ID: <20241112073426.21997-1-yan.y.zhao@intel.com>
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

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Update attr_filter field to zap both private and shared mappings for TDX
when memslot is deleted.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
TDX MMU part 2 v2:
 - Update commit msg.

TDX MMU part 2 v1:
 - Clarify TDX limits on zapping private memory (Sean)

Memslot quirk series:
 - New patch
---
 arch/x86/kvm/mmu/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2e253a488949..68bb78a2306c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7126,6 +7126,7 @@ static void kvm_mmu_zap_memslot(struct kvm *kvm,
 		.start = slot->base_gfn,
 		.end = slot->base_gfn + slot->npages,
 		.may_block = true,
+		.attr_filter = KVM_FILTER_PRIVATE | KVM_FILTER_SHARED,
 	};
 	bool flush;
 
-- 
2.43.2


