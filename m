Return-Path: <kvm+bounces-9762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B774866DD4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:13:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C6E71C23A85
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 966EC13475E;
	Mon, 26 Feb 2024 08:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OFmB7O7U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82EE1EB27;
	Mon, 26 Feb 2024 08:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936192; cv=none; b=mhS0OlElxNiTKXW4AiZUVrnksb8rbPIzez1gIA8Pr4709EpsAXjDNsVDHdXgrp3nxQPYCUj298hJ0eyDyAbuGXShR5giH/fnArZkrW1o/20l1K8K2QHCssaasjJp8AbQKpGlT4CaV1vZrcJKXaWQO5lMSIMyXplj0HA+x9+s2Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936192; c=relaxed/simple;
	bh=1Ryj6u4U9BulVOUlWacagZD4U9GjBBr6paLN/Y3sP80=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tbWzAqxfVhLDKJNmgfgUfwLSvc/s9WYQPLQOBAo2u7akrvn5Ky0gbZoBq7kZH36PdKxEUeGwyVmv09wWhw/mXyGVuY3zYS5tSlsFWPOhiBG5YdpPsZm+CknqH/t6LBv8RTxRv6rordn8CNQZuGn7biveMcjbyL/vz50EI1Qe9G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OFmB7O7U; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936191; x=1740472191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Ryj6u4U9BulVOUlWacagZD4U9GjBBr6paLN/Y3sP80=;
  b=OFmB7O7UcgzbkUTZnW9wU+JaA//593FWMu6WwCCmDU2MecNet3AGt1Hn
   giEGdKRhllfTSlLOwjJ1k09H6/uBJWBorjjfH4luyYZux/yaA9sd8ayEZ
   ETq6FKdovk4t/BpjYtB2QFHTU/Gu8d9munVuya956xUR6eWzQbIERVSsK
   J0Cw0vpW6btIEdWvGta4kvVypd5El/SPUsWn6uRUlz7ehvrFSGP8grkSY
   GdGpa7rfWF3EmcoWP6HTsQfL0Z6jH75ZsjTu/YuDciu+jtDTfWe3j3Z4X
   qGKLJ23Suebc4IacYY0nNJ9foRcZt97xHqlIy7dMLCkdzUHODdyEGIDQZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="14623303"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="14623303"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6519404"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:33 -0800
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
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v8 06/14] KVM: MMU: Introduce level info in PFERR code
Date: Mon, 26 Feb 2024 00:29:20 -0800
Message-Id: <4d61104bff388a081ff8f6ae4ac71e05a13e53c3.1708933624.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933624.git.isaku.yamahata@intel.com>
References: <cover.1708933624.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

For TDX, EPT violation can happen when TDG.MEM.PAGE.ACCEPT.
And TDG.MEM.PAGE.ACCEPT contains the desired accept page level of TD guest.

1. KVM can map it with 4KB page while TD guest wants to accept 2MB page.

  TD guest will get TDX_PAGE_SIZE_MISMATCH and it should try to accept
  4KB size.

2. KVM can map it with 2MB page while TD guest wants to accept 4KB page.

  KVM needs to honor it because
  a) there is no way to tell guest KVM maps it as 2MB size. And
  b) guest accepts it in 4KB size since guest knows some other 4KB page
     in the same 2MB range will be used as shared page.

For case 2, it need to pass desired page level to KVM MMU page fault
handler. Use bit 29:31 of kvm PF error code for this purpose.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++++
 arch/x86/kvm/mmu/mmu.c          | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e4d40e31fc31..c864a1ff2eb1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -262,6 +262,8 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_BIT 4
 #define PFERR_PK_BIT 5
 #define PFERR_SGX_BIT 15
+#define PFERR_LEVEL_START_BIT 29
+#define PFERR_LEVEL_END_BIT 31
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
 #define PFERR_GUEST_ENC_BIT 34
@@ -274,6 +276,7 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_MASK	BIT(PFERR_FETCH_BIT)
 #define PFERR_PK_MASK		BIT(PFERR_PK_BIT)
 #define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
+#define PFERR_LEVEL_MASK	GENMASK_ULL(PFERR_LEVEL_END_BIT, PFERR_LEVEL_START_BIT)
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
 #define PFERR_GUEST_ENC_MASK	BIT_ULL(PFERR_GUEST_ENC_BIT)
@@ -283,6 +286,8 @@ enum x86_intercept_stage;
 				 PFERR_WRITE_MASK |		\
 				 PFERR_PRESENT_MASK)
 
+#define PFERR_LEVEL(err_code)	(((err_code) & PFERR_LEVEL_MASK) >> PFERR_LEVEL_START_BIT)
+
 /* apic attention bits */
 #define KVM_APIC_CHECK_VAPIC	0
 /*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b8d6ce02e66d..081df7855065 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4625,6 +4625,11 @@ bool __kvm_mmu_honors_guest_mtrrs(bool vm_has_noncoherent_dma)
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
+	u8 err_level = PFERR_LEVEL(fault->error_code);
+
+	if (err_level)
+		fault->max_level = min(fault->max_level, err_level);
+
 	/*
 	 * If the guest's MTRRs may be used to compute the "real" memtype,
 	 * restrict the mapping level to ensure KVM uses a consistent memtype
-- 
2.25.1


