Return-Path: <kvm+bounces-23912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8547F94F9F6
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:54:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A54C1F24EC4
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 940491A072C;
	Mon, 12 Aug 2024 22:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZJSVWoMU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB8D1A00D7;
	Mon, 12 Aug 2024 22:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502926; cv=none; b=CONCFm7XNHza5lE/Lv+cSrMpRkv2SPfbSaKquTHf/gbeNJTFs1I7PVlA3/+hb1GiC9htN3ndlFq7EWc5XpbiHVnWgdIXab4ahbjxNjeurdEtiy4n02ygJE7dpTUdPyjpNUYO8HAKX2Eu3BZjh/wcj2kta/lVF28ohciWgDByeuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502926; c=relaxed/simple;
	bh=1FN9h/71MwOxJhAZ/a05tDf76AvluKRe9GPevp3JzsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tknlVWF9nUV/HAply6oY4X8mU21Dgs1h3/YP7Y5nWV4RzjAX2Kj5uj6wmFxRw/JLd0uicPhjwSuv3zh8f+lJJTb1UZR0QImLP32mrNmJyX69P+JB8HDt4Fc8ovMCR0ftQVcTtf527D0aEw+j9dx3NWfvkw9grPrLq6TTbBdujAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZJSVWoMU; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502925; x=1755038925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1FN9h/71MwOxJhAZ/a05tDf76AvluKRe9GPevp3JzsQ=;
  b=ZJSVWoMUs893Ankbqd+4Y80gcophYZ0Z6twnYZueyX/+Vb+FnHp0wCJA
   KOnifz73FoCTv3jPz9soScD7HB485lyfrYaOzjp8dsWJz+4HBkg0FM6eg
   T0E6ppAEmtYnOYS6Cz/7FfV4hjCWA9helQv+lo+CiBP+kutLOdeI/Em7x
   SDSXyltf6aSJ6+vs/EjNAchpw1n8ehHU8zzsZCBrw/Dm93wLQoaiK2yC3
   p7tawHRZozzAZmtJ15Ia7AeuuJgQatBssGIEOHrKaIaL9+PP34Qgf4fCm
   iJ2A3aU5016fX0m0QoM06M53ZMIeuiE0L2phIDURxKcKHsVVCHH41ri/y
   w==;
X-CSE-ConnectionGUID: Vnd5zBH1TramLTMmtLut6g==
X-CSE-MsgGUID: Ml12hal/TtCb6oTEQPkYcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041470"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041470"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:38 -0700
X-CSE-ConnectionGUID: HmcPPDCuTFW8zo7niScD5g==
X-CSE-MsgGUID: oLMK0bC9RNSd2YSILDXI1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008442"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:38 -0700
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
Subject: [PATCH 20/25] KVM: X86: Introduce tdx_get_kvm_supported_cpuid()
Date: Mon, 12 Aug 2024 15:48:15 -0700
Message-Id: <20240812224820.34826-21-rick.p.edgecombe@intel.com>
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

Two future TDX ioctl's will want to filter output by supported CPUID

Add a helper in TDX code instead of using
kvm_get_supported_cpuid_internal() directly for two reasons:
1. Logic around which CPUID leaf ranges to query would need to be
   duplicated.
2. Future patches will add TDX specific fixups to the CPUID data provided
   by kvm_get_supported_cpuid_internal().

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v1:
 - New patch
---
 arch/x86/kvm/vmx/tdx.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ba7b436fae86..b2ed031ac0d6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1014,6 +1014,30 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	return ret;
 }
 
+static int __maybe_unused tdx_get_kvm_supported_cpuid(struct kvm_cpuid2 **cpuid)
+{
+	int r;
+	static const u32 funcs[] = {
+		0, 0x80000000, KVM_CPUID_SIGNATURE,
+	};
+
+	*cpuid = kzalloc(sizeof(struct kvm_cpuid2) +
+			sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES,
+			GFP_KERNEL);
+	if (!*cpuid)
+		return -ENOMEM;
+	(*cpuid)->nent = KVM_MAX_CPUID_ENTRIES;
+	r = kvm_get_supported_cpuid_internal(*cpuid, funcs, ARRAY_SIZE(funcs));
+	if (r)
+		goto err;
+
+	return 0;
+err:
+	kfree(*cpuid);
+	*cpuid = NULL;
+	return r;
+}
+
 static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 {
 	struct msr_data apic_base_msr;
-- 
2.34.1


