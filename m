Return-Path: <kvm+bounces-15823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 38B128B0EEB
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:45:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED4B2B2215F
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B832816D4D9;
	Wed, 24 Apr 2024 15:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E9laUdWV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834C315FCEA
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713972984; cv=none; b=iviosY0rLMMia5G5gEs8LSSy9eTcJ8fsMWbDDo5uMZCuvtxsJlccLxvf109r23CZLuDNapcEZy2IpFUayYzOBLm3usQJhLp5CmEHNpO44HVMZWiS356PSUbj9sFpgflzGvCUYjUECGbK6QkFF4pH6dFCdIKUDMhKWkyWCf42KR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713972984; c=relaxed/simple;
	bh=9tKjP2w8CDRD8/O3XDaFivQaS6ttVvB9ofndc394p0c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KB6CSeWYzqhjd35luARilyXSipjTbeJ7ZH7BmX3LyfqtY79gEZOAUUgkDbpIQk41hT19106O/aZi2dRK4AN0MveuXMsC/miXKYPLp61DoFhAQG01IqDqfi4IPknoGEmM8mRbf0cwOrd2PkGOtTqARQf2fPGxqyqbTTd52WJpZFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E9laUdWV; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713972982; x=1745508982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9tKjP2w8CDRD8/O3XDaFivQaS6ttVvB9ofndc394p0c=;
  b=E9laUdWVRrO6XYJM7RLLCKGNuPwCX+TCgur9CTYhFJv7VNSLpbuKexxH
   VXoQ3bof6zVOYPYqecsy36p+w7ieXvIYx3K0dZ5Y0Xvx4G+eYWLpz1ZWK
   MvJitcElYE/rFJTggERlDYzNWLVXh9nTfGyh83H5AUWiKV0G8FSXHhljC
   BsU5X2WRnx/BjhGtz1NLJrVFU5GKS8nxvdusqrxwMLqHtBPC6tl7g/1E9
   /f5nF2ZiQLedW8h8Sh0kT38wJvEVgzUFXg6S4BYrLnq6q0r+JH4KycWBY
   /zJq/WZR066nmqCVX8kRZiN/iE4dgxZYPSCV2YEUknTaKH//MkH1bluP/
   A==;
X-CSE-ConnectionGUID: AyF6rQlTSsetzFzxcY8NdQ==
X-CSE-MsgGUID: LmKAlY/6Q2OLuQc+36vY3Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="12545633"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="12545633"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 08:36:22 -0700
X-CSE-ConnectionGUID: AqFcYHVAS9SJxeiGifIczg==
X-CSE-MsgGUID: gtZ1m92SQLSY4Pblcg/hKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="25363065"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 24 Apr 2024 08:36:17 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v11 05/21] i386/cpu: Fix i/d-cache topology to core level for Intel CPU
Date: Wed, 24 Apr 2024 23:49:13 +0800
Message-Id: <20240424154929.1487382-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240424154929.1487382-1-zhao1.liu@intel.com>
References: <20240424154929.1487382-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For i-cache and d-cache, current QEMU hardcodes the maximum IDs for CPUs
sharing cache (CPUID.04H.00H:EAX[bits 25:14] and CPUID.04H.01H:EAX[bits
25:14]) to 0, and this means i-cache and d-cache are shared in the SMT
level.

This is correct if there's single thread per core, but is wrong for the
hyper threading case (one core contains multiple threads) since the
i-cache and d-cache are shared in the core level other than SMT level.

For AMD CPU, commit 8f4202fb1080 ("i386: Populate AMD Processor Cache
Information for cpuid 0x8000001D") has already introduced i/d cache
topology as core level by default.

Therefore, in order to be compatible with both multi-threaded and
single-threaded situations, we should set i-cache and d-cache be shared
at the core level by default.

This fix changes the default i/d cache topology from per-thread to
per-core. Potentially, this change in L1 cache topology may affect the
performance of the VM if the user does not specifically specify the
topology or bind the vCPU. However, the way to achieve optimal
performance should be to create a reasonable topology and set the
appropriate vCPU affinity without relying on QEMU's default topology
structure.

Fixes: 7e3482f82480 ("i386: Helpers to encode cache information consistently")
Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
Changes since v3:
 * Changed the description of current i/d cache encoding status to avoid
   misleading to "architectural rules". (Xiaoyao)

Changes since v1:
 * Split this fix from the patch named "i386/cpu: Fix number of
   addressable IDs in CPUID.04H".
 * Added the explanation of the impact on performance. (Xiaoyao)
---
 target/i386/cpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index fd6af0d76321..46155b07466e 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6249,12 +6249,12 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             switch (count) {
             case 0: /* L1 dcache info */
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1d_cache,
-                                    1, cs->nr_cores,
+                                    cs->nr_threads, cs->nr_cores,
                                     eax, ebx, ecx, edx);
                 break;
             case 1: /* L1 icache info */
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1i_cache,
-                                    1, cs->nr_cores,
+                                    cs->nr_threads, cs->nr_cores,
                                     eax, ebx, ecx, edx);
                 break;
             case 2: /* L2 cache info */
-- 
2.34.1


