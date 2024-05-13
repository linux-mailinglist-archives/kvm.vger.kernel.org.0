Return-Path: <kvm+bounces-17282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D3C8C39E0
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 03:42:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22A922813B9
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 01:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B811218645;
	Mon, 13 May 2024 01:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hgBSk1ZA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F6917BDC
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 01:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715564506; cv=none; b=L0Hir2E/KYw3+C/IGC7HmRH3B3vu4ZKfRtKr2+jLmb56mM50ZKCDzkWuC64nH+JupU9vTl27oQnAyj4q8WyDbatyIQfqgmamr6k/wruTkC8cGgkoUqDFQCHhxfzUZP5X5KKA7WvlJbspxP4+W2dJyBnsTceYZgStnEucrJxUNBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715564506; c=relaxed/simple;
	bh=KbPrRP/l8NREJHAm5wkBNGXDjECtVwgGIsvEpDBvfeE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Hmm0ALULtfpuDk7+QmSfCKc+kD0CqmcyRcbwfuSAw6x2xrTyUbsGybirpsjOeg3IOynV8mHKus9eTv3gXQPVe2aPAZltAWRklVTyukE5LVeXKhuDy/NFDgWn6Y4N8wvwUaK9STrKsTFshfka3ufsY4O4fNcr9+EtaKnrZSWnW5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hgBSk1ZA; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715564505; x=1747100505;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KbPrRP/l8NREJHAm5wkBNGXDjECtVwgGIsvEpDBvfeE=;
  b=hgBSk1ZAhQrb9gN1PAAoZzanGNunn/lnf13pfkOagJFWSnRb/OWDoszJ
   tl9DqYBkVgaJ6xeuNejILAQImTi7vWBaOkTcDH1ftNcJJFW1/tCdR/7Aw
   PH68dVUMJCUvdDiJiEjA1c5kLzkrNzqGq86+qMoKZI1nWdAm5CAKnU2ZO
   TtnilNfH2jtpCjn1azalThyNCTWIadxpkkkIG9y+JXMXXdUCBQUP0cNjB
   Rge32cJ34JFDOTRenwnVcoMx/wOsUnZIwtBhxXq9XbwJZoJUTdcpV/nXf
   peypgohieUwcjHYD44PFW2X6kHNJR6vaOkG2TtAEWwrJ7SpZERDGkuOSP
   w==;
X-CSE-ConnectionGUID: AgQSfurKS6+mZESfYqPcCw==
X-CSE-MsgGUID: O2uAk4F1SkawgLFvNBl6JA==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="22056035"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="22056035"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 18:41:44 -0700
X-CSE-ConnectionGUID: O46hQepFSM6E0B49UQyp6A==
X-CSE-MsgGUID: AdkaBZLDRgKjnAa5eKBsbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="30259385"
Received: from unknown (HELO st-server.bj.intel.com) ([10.240.193.102])
  by fmviesa010.fm.intel.com with ESMTP; 12 May 2024 18:41:42 -0700
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	yi1.lai@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH v3] KVM: selftests: x86: Prioritize getting max_gfn from GuestPhysBits
Date: Mon, 13 May 2024 09:40:03 +0800
Message-Id: <20240513014003.104593-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the max mappable GPA via GuestPhysBits advertised by KVM to calculate
max_gfn. Currently some selftests (e.g. access_tracking_perf_test,
dirty_log_test...) add RAM regions close to max_gfn, so guest may access
GPA beyond its mappable range and cause infinite loop.

Adjust max_gfn in vm_compute_max_gfn() since x86 selftests already
overrides vm_compute_max_gfn() specifically to deal with goofy edge cases.

Reported-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
This patch is based on https://github.com/kvm-x86/linux/commit/b628cb523c65

Changelog:
v2 -> v3:
 - Drop kvm_cpu_has_p(X86_PROPERTY_MAX_GUEST_PHY_ADDR) check
 - Change max_bits to guest_pa_bits
 - Add Yi Lai's Reported-by and Xiaoyao's Reviewed-by

v1 -> v2:
 - Only adjust vm->max_gfn in vm_compute_max_gfn()
 - Add Yi Lai's Tested-by

v1: https://lore.kernel.org/all/20240508064205.15301-1-tao1.su@linux.intel.com/
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 1 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c     | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 81ce37ec407d..ff99f66d81a0 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -282,6 +282,7 @@ struct kvm_x86_cpu_property {
 #define X86_PROPERTY_MAX_EXT_LEAF		KVM_X86_CPU_PROPERTY(0x80000000, 0, EAX, 0, 31)
 #define X86_PROPERTY_MAX_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 0, 7)
 #define X86_PROPERTY_MAX_VIRT_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
+#define X86_PROPERTY_MAX_GUEST_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 16, 23)
 #define X86_PROPERTY_SEV_C_BIT			KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)
 #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 74a4c736c9ae..9458b36a30a8 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1293,10 +1293,15 @@ const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
 unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 {
 	const unsigned long num_ht_pages = 12 << (30 - vm->page_shift); /* 12 GiB */
-	unsigned long ht_gfn, max_gfn, max_pfn;
+	unsigned long ht_gfn, max_gfn, max_pfn, guest_pa_bits;
 	uint8_t maxphyaddr;
 
-	max_gfn = (1ULL << (vm->pa_bits - vm->page_shift)) - 1;
+	guest_pa_bits = kvm_cpu_property(X86_PROPERTY_MAX_GUEST_PHY_ADDR);
+
+	if (!guest_pa_bits)
+		guest_pa_bits = vm->pa_bits;
+
+	max_gfn = (1ULL << (guest_pa_bits - vm->page_shift)) - 1;
 
 	/* Avoid reserved HyperTransport region on AMD processors.  */
 	if (!host_cpu_is_amd)

base-commit: a38297e3fb012ddfa7ce0321a7e5a8daeb1872b6
-- 
2.34.1


