Return-Path: <kvm+bounces-23914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67AD994F9FA
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:54:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12E9C1F254D1
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 019B419AA68;
	Mon, 12 Aug 2024 22:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HVOCe3wl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00821A01B8;
	Mon, 12 Aug 2024 22:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502927; cv=none; b=C6Jxpa6fRqOdYHn17vlxxQ7ud2arHONafor/phZLZYYcxq1dQcs9yQGR7AgxX69WFEOStuYbjmukbO5wKpupNTcKPCW62Ksr58t1w8tlbxVoFLBNz9My7s5mn//lzVu3BtBH/htKlUEPe8hWMiOYLsJaIT3HuP1GDRTLLaqKJ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502927; c=relaxed/simple;
	bh=dzTCJEwxQIcUPZxgaA3bFSKSbYZ9P5mbXKvGZcycYO4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZpqeDx3YCwWgzpzdBLT9/t3+xVkJ0WUj7PHNK3byzWMXo2zzhzdjDWQsntBFEyVDGKpB26A3zOZvw1enc/NPfgTNGCvBt3tI784r7QyWwm1dDMnuiQ2Xef1ZGjI67QD8Jg5+Gv2c8KdJ3eWDsrN88qImTIrNT+JrD6dhS4y3KxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HVOCe3wl; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502926; x=1755038926;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dzTCJEwxQIcUPZxgaA3bFSKSbYZ9P5mbXKvGZcycYO4=;
  b=HVOCe3wldGQUcM+7opWdnsLlgoJFu4NRdL7c5GfwLiZeBVLlwu8e0Wqj
   7AwB/YjGWnfzsYhHHOMapdRYS+GHM5qjIRdhBQoGRUIq4/dhTdpFpxKQL
   o0naTtGyP52Rxe7aT1zsh5hA9rI2ZgpCDEjsw0ZUqqpAdC9wUAAYqRVqa
   3FHCZLvymOedSnYzy2qIb6TMX7MdLOktYOc0TTLEWQS8Ab4F0RF2oX0jG
   4CFNqDmVGN0dSmN+FVvI0jKTlaDFV5/viSP/bPZE/18WG0sd/afjJqwBB
   ymrbKwYhOl1Rgybg1Vk33FQvfrpgG0uv58KT9SQpAZf55FvOKXs/b8SRF
   w==;
X-CSE-ConnectionGUID: WJ8JmIR5Q0u1coycXNBaEQ==
X-CSE-MsgGUID: L70OmvONQ5GuOT1UEtoKIQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041462"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041462"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:37 -0700
X-CSE-ConnectionGUID: vJReIfazTm2eq16RzlEVXw==
X-CSE-MsgGUID: uiUN2SLKQBmKeki1qsp0vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008439"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:37 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com
Subject: [PATCH 19/25] KVM: X86: Introduce kvm_get_supported_cpuid_internal()
Date: Mon, 12 Aug 2024 15:48:14 -0700
Message-Id: <20240812224820.34826-20-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

TDX module reports a set of configurable CPUIDs. Directly report these
bits to userspace and allow them to be set is not good nor right. If a
bit is unknown/unsupported to KVM, it should be reported as unsupported
thus inconfigurable to userspace.

Introduce and export kvm_get_supported_cpuid_internal() for TDX to get
the supported CPUID list of KVM. So that TDX can use it to cap the
configurable CPUID list reported by TDX module.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v1:
 - New patch
---
 arch/x86/kvm/cpuid.c | 25 +++++++++++++++++++++++++
 arch/x86/kvm/cpuid.h |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7310d8a8a503..499479c769d8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1487,6 +1487,31 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 	return r;
 }
 
+int kvm_get_supported_cpuid_internal(struct kvm_cpuid2 *cpuid, const u32 *funcs,
+				     int funcs_len)
+{
+	struct kvm_cpuid_array array = {
+		.nent = 0,
+	};
+	int i, r;
+
+	if (cpuid->nent < 1 || cpuid->nent > KVM_MAX_CPUID_ENTRIES)
+		return -E2BIG;
+
+	array.maxnent = cpuid->nent;
+	array.entries = cpuid->entries;
+
+	for (i = 0; i < funcs_len; i++) {
+		r = get_cpuid_func(&array, funcs[i], KVM_GET_SUPPORTED_CPUID);
+		if (r)
+			return r;
+	}
+
+	cpuid->nent = array.nent;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_get_supported_cpuid_internal);
+
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(
 	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
 {
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 00570227e2ae..5cc13d1b7991 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -13,6 +13,8 @@ void kvm_set_cpu_caps(void);
 
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
 void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
+int kvm_get_supported_cpuid_internal(struct kvm_cpuid2 *cpuid, const u32 *funcs,
+				     int func_len);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(struct kvm_cpuid_entry2 *entries,
 					       int nent, u32 function, u64 index);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
-- 
2.34.1


