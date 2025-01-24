Return-Path: <kvm+bounces-36496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B5306A1B6EB
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:38:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B29F9188C7F0
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9AC377F10;
	Fri, 24 Jan 2025 13:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j2dnHqOc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770AA42AB0
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725863; cv=none; b=Hl4gyNlYNV4T+Ra8v/fbkCkMbhkngSr3S+hNjBPrz6hwg0fHLhorAW93nQlBI2kJswd6kvZsohOb40crlJZwGMLyXozaF9VFmYWIDqqysKxRj27En4nGd1JXA7zMeNMzRKo16zTERocsBq+K0ZTZE1pUpfTfIbXFwkv5jreh8ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725863; c=relaxed/simple;
	bh=Cfpj4WCxfFDeTOSQgHq6/UjikY4uRx0YKjE6SJdKb/c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e9c9+T21paUnMyALY4PWkI/ovGhWgAEdHNuN9yfENbWIY3V/kFC4jwbxgSKhsWEFwaYmVk7dUk5f8P7zVvme+4boDQ6gMs1gvKB0ntyWu1hDcwtkD2UKVfVW5VN+PuaCyscJa4vJsxzh+4h6E+g3dEpZoPnWmQ1zmsG7vNIgglU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j2dnHqOc; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725863; x=1769261863;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cfpj4WCxfFDeTOSQgHq6/UjikY4uRx0YKjE6SJdKb/c=;
  b=j2dnHqOcgLYnLNmqi8YLLfYngnBxSi1rBF6yMt1r4eMatiniFS4gsyqs
   LzrInNHPBaCKhViDZpI0UZ7CgC3o8/sgDsmOX+gAuHkSjdE8oZPHiXjhC
   tgYjAVOW2hOrmVJUEJFlhtP59AlZ9zTsFZ99K83LO06j+/ALHvcuOBTsy
   gTEWSL7B6f97QEnGqepQFzOH7Z1WOi6l4BatDuydUOuuHDFUqcB+ZNnup
   AWS2CDX3VurpFd8OKq3tka1SxumfPMRGG1BaTrs3OTbQ4XDgTIhgShrF4
   4wUvmuyJrNxswuJKP2WBPBi9DB+RHCQnatlqzZ3lPSaRpp42e7bpp3f8X
   w==;
X-CSE-ConnectionGUID: I+r8H5AdQkOoIWYfELXBBg==
X-CSE-MsgGUID: bs7f6z+ESsG0YqaRMPM+4A==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246252"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246252"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:37:43 -0800
X-CSE-ConnectionGUID: rE3BlB5cTS6u0AEIazFIlA==
X-CSE-MsgGUID: V2mWSehdQZWsGWPdWoKM1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804196"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:37:38 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 11/52] i386/tdx: Wire CPU features up with attributes of TD guest
Date: Fri, 24 Jan 2025 08:20:07 -0500
Message-Id: <20250124132048.3229049-12-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For QEMU VMs,
  - PKS is configured via CPUID_7_0_ECX_PKS, e.g., -cpu xxx,+pks  and
  - PMU is configured by x86cpu->enable_pmu, e.g., -cpu xxx,pmu=on

While the bit 30 (PKS) and bit 63 (PERFMON) of TD's attributes are also
used to configure the PKS and PERFMON/PMU of TD, reuse the existing
configuration interfaces of 'cpu' for TD's attributes.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index dcb19a18e405..653942d83bcb 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -19,6 +19,8 @@
 #include "tdx.h"
 
 #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
+#define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
+#define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
 
 static TdxGuest *tdx_guest;
 
@@ -151,6 +153,15 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
     return KVM_X86_TDX_VM;
 }
 
+static void setup_td_guest_attributes(X86CPU *x86cpu)
+{
+    CPUX86State *env = &x86cpu->env;
+
+    tdx_guest->attributes |= (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_PKS) ?
+                             TDX_TD_ATTRIBUTES_PKS : 0;
+    tdx_guest->attributes |= x86cpu->enable_pmu ? TDX_TD_ATTRIBUTES_PERFMON : 0;
+}
+
 static int setup_td_xfam(X86CPU *x86cpu, Error **errp)
 {
     CPUX86State *env = &x86cpu->env;
@@ -214,6 +225,8 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
     init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
                         sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
 
+    setup_td_guest_attributes(x86cpu);
+
     r = setup_td_xfam(x86cpu, errp);
     if (r) {
         return r;
-- 
2.34.1


