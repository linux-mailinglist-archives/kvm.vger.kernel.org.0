Return-Path: <kvm+bounces-30642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D97949BC57F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 639A2B216F8
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58961FDF89;
	Tue,  5 Nov 2024 06:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X7IG5YSI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A2D1F708B
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788617; cv=none; b=tEN17LjbycMeZ1nlPDdmX3BFcvCa5B/G49v6sFzSDL3cdhTQjn9LAb9UQ7lLVbPEuXWY+BnvKpqnPDvP7NUmNw4wUFepb/wU8Qbu2w+0sG39iATINidmMTgq0pd9SO/FzNlm2C12WrAX/p3ewxYLI+L4TNMPHDjMjZEJwOVjaBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788617; c=relaxed/simple;
	bh=EMCLkioz6PKqWrBweYilnMeVfCok800taR5KSHSziyM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hp+svL6OGb75//59kHExxtUSZecsDU41sPCHjTsG6wd9fj9UkgQoQLxOgQHzPaVHWAk1QotnS/dPiKuI+ZQehUDmOgvGesnpiTdg3TRTh4Gb7HR31iqYAq0eJGKg5BJebDGEkudBc1LshrCa8M+v4lg/GuhtuE4kRFM0pQ65zZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X7IG5YSI; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788615; x=1762324615;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EMCLkioz6PKqWrBweYilnMeVfCok800taR5KSHSziyM=;
  b=X7IG5YSIzNhS2AXrQB7B/5JKKPhI55b1wUe+lZK9JVTucUcRKXOmCYhG
   ICjt/qWU+Zti9wuu2qtszfDD/M4MfWXKR4CT2U7YW6zcJPKadNVKD1AHr
   /9HwBkj3FCYExiiaTUF+MK95iwtV/wUrQYj8LZIeiVJxyPU8o3OjmzORs
   rcDjoJKQ8XRg4IMhVXMlnWkDgfEM343v0MBYBWxwv93Guox5bG0m7iTGR
   4ukEffxgLv8IA1yZH1Pl0ECGBazOOXM5zB2BkPWDEg4aAx8QT64LyUD9w
   I6pfNqTNL/+u8IYDJb2gK12uC6jPaaAzWK39hrORUnvplb2nItO57q66z
   g==;
X-CSE-ConnectionGUID: M1uUwq0WRIKh+uJQ7CUjzg==
X-CSE-MsgGUID: q75HXP8hSm2tuNuwf5Pjvg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689336"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689336"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:36:55 -0800
X-CSE-ConnectionGUID: /mqITyi7TM+2Y+yCpFQ9lQ==
X-CSE-MsgGUID: mzsjznpqSTuIPYeKU0/kIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83988646"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:36:51 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 08/60] i386/kvm: Export cpuid_entry_get_reg() and cpuid_find_entry()
Date: Tue,  5 Nov 2024 01:23:16 -0500
Message-Id: <20241105062408.3533704-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c      | 8 ++++----
 target/i386/kvm/kvm_i386.h | 4 ++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index b843de7f2379..afbf67a7fdaa 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -395,7 +395,7 @@ static bool host_tsx_broken(void)
 
 /* Returns the value for a specific register on the cpuid entry
  */
-static uint32_t cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry, int reg)
+uint32_t cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry, int reg)
 {
     uint32_t ret = 0;
     switch (reg) {
@@ -417,9 +417,9 @@ static uint32_t cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry, int reg)
 
 /* Find matching entry for function/index on kvm_cpuid2 struct
  */
-static struct kvm_cpuid_entry2 *cpuid_find_entry(struct kvm_cpuid2 *cpuid,
-                                                 uint32_t function,
-                                                 uint32_t index)
+struct kvm_cpuid_entry2 *cpuid_find_entry(struct kvm_cpuid2 *cpuid,
+                                          uint32_t function,
+                                          uint32_t index)
 {
     int i;
     for (i = 0; i < cpuid->nent; ++i) {
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 7ac4c3a91171..efb0883bd968 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -67,6 +67,10 @@ bool kvm_has_waitpkg(void);
 uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address);
 void kvm_update_msi_routes_all(void *private, bool global,
                                uint32_t index, uint32_t mask);
+uint32_t cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry, int reg);
+struct kvm_cpuid_entry2 *cpuid_find_entry(struct kvm_cpuid2 *cpuid,
+                                          uint32_t function,
+                                          uint32_t index);
 
 #endif /* CONFIG_KVM */
 
-- 
2.34.1


