Return-Path: <kvm+bounces-9159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B6CB485B6F7
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:16:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 476971F2570A
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 051F860EC8;
	Tue, 20 Feb 2024 09:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QnwjI3f0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBD860DFF
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 09:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708420339; cv=none; b=Z70iFlreBs3ckeFtgFbM2uIDQk4MHvMI3vQgswt1g9fZbPLEH/MvCtQQEV03Y9Kk8hbiywkcWjQ6nuu72ZAAr2aRMr8Yl1H1WuYq/I5ZttpXw7gRT8IvNaSRFhHw37FW7GknL+AdcGeS8GHfmj7Kq40sB3KF5pxPMGnQ12ZuNis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708420339; c=relaxed/simple;
	bh=sh2QkQ5wss3HOjZ8fhY8YalRgTw6t25jX5kKa/RtD7I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jtzT+tv6ur+IPmK53KdI2Wy50cwyFfU16KvSwA8utOSqG1hr2O4jjmj77XgyxP0l2TsChLjT0NIE18tuNrgOumsFlGFX5gy+CmbA8dl4WlDj9ETytpNi5kkkqoDqCriuZMu4o4kWcHs0OihagsJGjgSegD1icPKRL4ah9QuRxzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QnwjI3f0; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708420338; x=1739956338;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sh2QkQ5wss3HOjZ8fhY8YalRgTw6t25jX5kKa/RtD7I=;
  b=QnwjI3f0fStjKHA/kYFW8iwpqD8zoAR+fkFnGKfypfSR2RQyEFDWH/wT
   8X3ErEY/qWDt9njYB4jMm9LXpKnICtEeXvHUMZA2h4/BaXcJqHAuRC+X5
   wuhB/PMpl4mi1kTusaj4DqZ91NGqlRsRXJGz5nQhHbcBeN+qK50fkZleq
   t0glfNMtuzMupVDYnqT161VZsq7buQUjf17+Qvh7Joq+/ZLiUSB/1Enxp
   aTF+En1NWZl+4WpC3UoKcMCTGEhmRU8bvpWakuXkVYmn6TAE6Ww21TpUn
   PiBcuiwUvWvMd/pfwnfLGenKuqF5Ml4ZY2FjLyCXAhDDqBmgNpOTR1aVA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2375019"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="2375019"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 01:12:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="5013057"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa007.jf.intel.com with ESMTP; 20 Feb 2024 01:12:11 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 6/8] i386/cpu: Update cache topology with machine's configuration
Date: Tue, 20 Feb 2024 17:25:02 +0800
Message-Id: <20240220092504.726064-7-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

User will configure SMP cache topology via -smp.

For this case, update the x86 CPUs' cache topology with user's
configuration in MachineState.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index d7cb0f1e49b4..4b5c551fe7f0 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7582,6 +7582,27 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
 #ifndef CONFIG_USER_ONLY
     MachineState *ms = MACHINE(qdev_get_machine());
+
+    if (ms->smp_cache.l1d != CPU_TOPO_LEVEL_INVALID) {
+        env->cache_info_cpuid4.l1d_cache->share_level = ms->smp_cache.l1d;
+        env->cache_info_amd.l1d_cache->share_level = ms->smp_cache.l1d;
+    }
+
+    if (ms->smp_cache.l1i != CPU_TOPO_LEVEL_INVALID) {
+        env->cache_info_cpuid4.l1i_cache->share_level = ms->smp_cache.l1i;
+        env->cache_info_amd.l1i_cache->share_level = ms->smp_cache.l1i;
+    }
+
+    if (ms->smp_cache.l2 != CPU_TOPO_LEVEL_INVALID) {
+        env->cache_info_cpuid4.l2_cache->share_level = ms->smp_cache.l2;
+        env->cache_info_amd.l2_cache->share_level = ms->smp_cache.l2;
+    }
+
+    if (ms->smp_cache.l3 != CPU_TOPO_LEVEL_INVALID) {
+        env->cache_info_cpuid4.l3_cache->share_level = ms->smp_cache.l3;
+        env->cache_info_amd.l3_cache->share_level = ms->smp_cache.l3;
+    }
+
     qemu_register_reset(x86_cpu_machine_reset_cb, cpu);
 
     if (cpu->env.features[FEAT_1_EDX] & CPUID_APIC || ms->smp.cpus > 1) {
-- 
2.34.1


