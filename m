Return-Path: <kvm+bounces-36602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57C42A1C64E
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 05:21:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B556D3A79AA
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 04:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308DE3C47B;
	Sun, 26 Jan 2025 04:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BP5xop/L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5E73232;
	Sun, 26 Jan 2025 04:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737865261; cv=none; b=qNcceynQCqyf+biPmh/+PkCxr/LZlAioTcFYuQfahdXfstKjkj+ZBR2vT+CPg3poV34aBKiGvPB+e5UWFgskL3+M8r4ub+nkVmEDK/kI0jf7zLaFGxQSv8jvgN6u/bPm2tAtQSXjuLKi0zE8QN0nqsPC1hTIRSBAWtwvHKayGkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737865261; c=relaxed/simple;
	bh=EdduNVEXm0ixU7iMv43eZMnNsilUg8zjTaBLlqvx4bc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cTVZFyA341NJ4IOb3oqVLRxhSwB1/hysVb82zmmWMsLMVNaTq7GdClvzkuxeVYC+3USEQTg12GxMgGPxSaAIl5OE7mlOT+05XpZXkFNn1NVgHNfS0mKN/8CRLKT7Myj8WcjNp0jgMMBeR19Hr+1k2EcUAHO3EzOMwm5S5Uv+Q4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BP5xop/L; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737865260; x=1769401260;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EdduNVEXm0ixU7iMv43eZMnNsilUg8zjTaBLlqvx4bc=;
  b=BP5xop/LFK9d8vM4jEHA4z3qD6AQ7RhMRkIAK/jnyPkZrP5z+LMreYoi
   /38EBeUGHZfdP9rnqtBbIqSx5/jkfLIm0MUf4oiSvYaunPVEvGrSHhye9
   A0u46tnfzO13qFDBvWF6rVveF8eENv/H8P3yGfTnvv7oLC8elqiEMAYt/
   TjMUbHyyM7V3ORmHu7w9CQDh3y+fkt9Eas3cqlLTA7QiwzusVGeylTYRw
   hTch12E8L49NbkejrOriOlJJcHg9Y/QqZ89TH5K70CH/0SontRGr6zz1Y
   IADuP6We/qWevERYjhpAIR5biK05IXHyVKaP2X4ZkWhhBUgczQbxhrqRr
   A==;
X-CSE-ConnectionGUID: ecs9yfIUTwed+ohHFl3jvQ==
X-CSE-MsgGUID: e7HulCscR4SDmAJDRLwiuw==
X-IronPort-AV: E=McAfee;i="6700,10204,11326"; a="63712510"
X-IronPort-AV: E=Sophos;i="6.13,235,1732608000"; 
   d="scan'208";a="63712510"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2025 20:20:59 -0800
X-CSE-ConnectionGUID: yEe0SZ8OQqKfSOy3mbkiuA==
X-CSE-MsgGUID: TUrhaHaoSt683cxUXiyysw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,235,1732608000"; 
   d="scan'208";a="108109404"
Received: from unknown (HELO HaiSPR.bj.intel.com) ([10.240.192.152])
  by orviesa006.jf.intel.com with ESMTP; 25 Jan 2025 20:20:56 -0800
From: Ethan Zhao <haifeng.zhao@linux.intel.com>
To: hpa@zytor.com,
	bp@alien8.de,
	tglx@linutronix.de,
	mingo@redhat.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	joro@8bytes.org,
	jmattson@google.com,
	wanpengli@tencent.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	etzhao@outlook.com
Subject: [PATCH] KVM: x86/cpudid: add type suffix to decimal const 48 fix building warning
Date: Sun, 26 Jan 2025 12:15:32 +0800
Message-Id: <20250126041532.3420420-1-haifeng.zhao@linux.intel.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The default type of a decimal constant is determined by the magnitude of
its value. If the value falls within the range of int, its type is int;
otherwise, if it falls within the range of unsigned int, its type is
unsigned int. This results in the constant 48 being of type int. In the
following min call,

g_phys_as = min(g_phys_as, 48);

This leads to a building warning/error (CONFIG_KVM_WERROR=y) caused by
the mismatch between the types of the two arguments to macro min. By
adding the suffix U to explicitly declare the type of the constant, this
issue is fixed.

Signed-off-by: Ethan Zhao <haifeng.zhao@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2cbb3874ad39..aa2c319118bc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1704,7 +1704,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			phys_as = entry->eax & 0xff;
 			g_phys_as = phys_as;
 			if (kvm_mmu_get_max_tdp_level() < 5)
-				g_phys_as = min(g_phys_as, 48);
+				g_phys_as = min(g_phys_as, 48U);
 		}
 
 		entry->eax = phys_as | (virt_as << 8) | (g_phys_as << 16);
-- 
2.31.1


