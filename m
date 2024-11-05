Return-Path: <kvm+bounces-30693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 65D419BC5C2
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:42:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01A6FB236B0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F421FEFC7;
	Tue,  5 Nov 2024 06:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YpJiD8Kd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6481FE0F1
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788836; cv=none; b=jEAEyeDxRZeLdYd9Fm4a4hxCKQfy671tleFNx8rLOELTRpPrqkJPvIsH911OngOkqrL66FtbBrJnqyORplKVNt0hj7BSWj+In1QvTUWs9lt9GfFKg7Nupu4aUjl8CEmNrLSeE+JzUe/zbkd/xDb6Uu8s9ZDdKtv6qHjTWqGC8JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788836; c=relaxed/simple;
	bh=oRT7vJ7+68FbrD5uefrUrGWOgNBDYndBP8Hc2+4+qeY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mQBpJEt8MrGR9vGUR47wOTfrNSre/d8QTf1T1b4X80Zr1C74ure9DZo8ujOz08tvn0zjfBVxgIhTZTe5M6pyJyiDbKXeYMrV6Tja+sLj4nChHzc5JnyS0kgXhPyIQooVSNBGCOYLZSgJNdCz7qTqf1Mvk4ZOTIWD/kGIkPU2dIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YpJiD8Kd; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788835; x=1762324835;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oRT7vJ7+68FbrD5uefrUrGWOgNBDYndBP8Hc2+4+qeY=;
  b=YpJiD8KdCeb0XfSOgvNA+KxmnhLK/z6S3jz4auqnZw/uyqsR5ojnuMrj
   3e+Nk/n81o5ZF1ak5gdUAx0qrw9WbZLUjvKVnppDXECVxnGjZh8ifEk4L
   Y0SUr9baBJb2qhtNZSGEIyiM4eS7tSUUIlKfUvhaDVZN4RMamtsKoPOoJ
   zkBo+QBI2lu2RFNP1apu6kKwzYcjH8nQGVr+19MuKsGUIAcGXQFA4L49G
   tI8lOD1u4k8aX1ad4THpZiqCaENg21frHBCQPhjk5os6uY7F+xA0P2dUV
   MpcOI+FbDy9Smn9JLfOMd5Ywuz0fv31G11/3yo50w0W8J/WvJkr2zLoR7
   A==;
X-CSE-ConnectionGUID: dRKmdDvhSWG7w1whxm1lng==
X-CSE-MsgGUID: 7J+FhkQCTDOkAYn33Xihow==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689964"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689964"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:40:35 -0800
X-CSE-ConnectionGUID: LzAzyvrmS+yTZ8bmyu8w1Q==
X-CSE-MsgGUID: 2ERfMEY6TBCvNuxBGJjdvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83990148"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:40:31 -0800
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
Subject: [PATCH v6 59/60] i386/cpu: Set up CPUID_HT in x86_cpu_realizefn() instead of cpu_x86_cpuid()
Date: Tue,  5 Nov 2024 01:24:07 -0500
Message-Id: <20241105062408.3533704-60-xiaoyao.li@intel.com>
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

Otherwise, it gets warnings like below when number of vcpus > 1:

  warning: TDX enforces set the feature: CPUID.01H:EDX.ht [bit 28]

This is because x86_confidential_guest_check_features() checks
env->features[] instead of the cpuid date set up by cpu_x86_cpuid()

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 472ab206d8fe..214a1b00a815 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6571,7 +6571,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         *edx = env->features[FEAT_1_EDX];
         if (threads_per_pkg > 1) {
             *ebx |= threads_per_pkg << 16;
-            *edx |= CPUID_HT;
         }
         if (!cpu->enable_pmu) {
             *ecx &= ~CPUID_EXT_PDCM;
@@ -7784,6 +7783,8 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
     Error *local_err = NULL;
     unsigned requested_lbr_fmt;
 
+    qemu_early_init_vcpu(cs);
+
 #if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
     /* Use pc-relative instructions in system-mode */
     tcg_cflags_set(cs, CF_PCREL);
@@ -7851,6 +7852,14 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
         }
     }
 
+    /*
+     * It needs to called after feature filter because KVM doesn't report HT
+     * as supported
+     */
+    if (cs->nr_cores * cs->nr_threads > 1) {
+        env->features[FEAT_1_EDX] |= CPUID_HT;
+    }
+
     /* On AMD CPUs, some CPUID[8000_0001].EDX bits must match the bits on
      * CPUID[1].EDX.
      */
-- 
2.34.1


