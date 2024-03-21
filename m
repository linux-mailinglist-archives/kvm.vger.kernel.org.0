Return-Path: <kvm+bounces-12387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DEEB885AAA
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:28:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A4A8282FF0
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 14:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F89385959;
	Thu, 21 Mar 2024 14:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MMI8SamQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B169E85955
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 14:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711031258; cv=none; b=LGwTkCsfSbG7Nb0IBQpjdyfJZp634dnTLxsAbGsUa4ugb4mfOUxydcBAK03jsKvfsluDv0XuF1t8AwIG3NR0/CLklHb4yekS3q+/iemqK0kHSM6E2vg7EvcWEpW6RFpcHyEOPQMx2svO5WIRc7OC7GRU2WY48XaEn26/t4A5/WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711031258; c=relaxed/simple;
	bh=O2KStJE5a2MoPMypMlBC3/x2H33PnsUliJtrKXRTlFY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c9eN9NYLwJ9O0oZDgha1rMoirSM+T53ui5uVtB90fACl6X6k4qJ4Kj5Jc6U6FQuznLtyktoJaaT7NufJ+ttZp7mg/ZEVHcgb3YljJ0WZ78SD6JDwqkrYblIxFQs6szvRFXCFa427eEVK7B3EIZeWe5A1N0/3t/0HLDtGi0J0gQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MMI8SamQ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711031257; x=1742567257;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O2KStJE5a2MoPMypMlBC3/x2H33PnsUliJtrKXRTlFY=;
  b=MMI8SamQPWJQP4ivJg2Qr6W9gW0Md43Tp24n5tL2UP8pcBIKapEjyFyK
   m7fhj2/OoPzNvHhM/+23LgrW2edEK2oe3Z4VYdzhFpqXLaDt7jgI6e+iD
   +89egH7JUgpIQl5x/BEZ4Sk879b+L4xDG8Jm4zoAjgr9Lh3clSH5jKF1w
   mJdD4aIcYANDLF3Z39T89mx7pLxDBH6zdL82n5QwicsUJ6FZkPBLT8+P+
   kVAnPDDcRrScltIid1XFCBfDsAv1HCAn33+Xl+M4EPlxbI91zHNWSxsvv
   p0UPabS0vFLnGzC/PLm93YKffq5ey7fhNiue6hHQMzPrIPJL2VQCVqP4R
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9806426"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="9806426"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 07:27:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="14527882"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 21 Mar 2024 07:27:31 -0700
From: Zhao Liu <zhao1.liu@linux.intel.com>
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
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v10 05/21] i386/cpu: Fix i/d-cache topology to core level for Intel CPU
Date: Thu, 21 Mar 2024 22:40:32 +0800
Message-Id: <20240321144048.3699388-6-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
References: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

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
index 33760a2ee163..eedc2c5ea6e0 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6113,12 +6113,12 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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


