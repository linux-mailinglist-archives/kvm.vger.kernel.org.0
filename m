Return-Path: <kvm+bounces-18385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D98D8D4915
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 12:01:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DC11283234
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 10:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E67A1761A7;
	Thu, 30 May 2024 10:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YDRMQE0D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573056F2FB
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 10:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717063253; cv=none; b=hDP2P+2Qt7OJlqPphTTrurdqXvvGml9yKvxfkZiLpWvxWxOD8Nu9+ygue13fAxlB64pA/TY1nosDjl0hgbd0wXHDoC4lytdyzEvwUKSrR4Zn8dxfKkjdnewdu4G1nfgpgm7LXivbsUdccrFGVjDUd/11GWKW1drTwwcXUe01Nk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717063253; c=relaxed/simple;
	bh=TkFL4JGvaBtqT8WMIo99wxT4H70mghAQsEG6xdgy1EE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OMfriFCddonGaU7/LQ+ENQnNcahUvtYtDjMkIuPilqGHfHCGq1X8fZOFimD7DVeclCd64BrBkRoFrcAF05qwTG/5OlsU5sADx6O/pt58NnXSV0eKvNn99VZyBVX7XGqb//BR3k2vSpiXQXL9B3EWRr07FT2U9o1LOwCZ9Vt1uU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YDRMQE0D; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717063253; x=1748599253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TkFL4JGvaBtqT8WMIo99wxT4H70mghAQsEG6xdgy1EE=;
  b=YDRMQE0D0rsUaWlKQXn6E1OBHsxarrJ8oH6kzIguY3SZx3GhtaFwNIku
   BU4uia9Q+xKETIW393kpWM8zyigdqT5c+BhHPAhlLEtH0YJgM4TcUnmTK
   nYaTTLbjuTtRgsy8EiBVwH2GX4jNoZm79E7UA+Fl8TN4kppff828/5LtH
   QI009mtdVnGQT+p4bsPiIp+z5HvnVXd2lNWrEFnisjOFZEhMfl9SxwBXh
   zE72s2AC1M/5mpwrSTmCDC+p+czFjTUbZfwbwwY0EjypxcHXEkeuyDkcx
   uL15/qOmLlmYdI/SgaimBj0/s8+2wSgcFhcTMHJkXHVpk6zYJq1evUIZE
   A==;
X-CSE-ConnectionGUID: nJxJl0aoSfKGYJajJmpYqA==
X-CSE-MsgGUID: rfipyUKOQTOm4mDMwVaJhw==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="31032560"
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="31032560"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 03:00:52 -0700
X-CSE-ConnectionGUID: /YQgvYFURk+y03VbFGoVyw==
X-CSE-MsgGUID: DC+EoqJ5R4+XMosDINLHMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="35705107"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 30 May 2024 03:00:47 -0700
From: Zhao Liu <zhao1.liu@intel.com>
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
Subject: [RFC v2 5/7] i386/cpu: Update cache topology with machine's configuration
Date: Thu, 30 May 2024 18:15:37 +0800
Message-Id: <20240530101539.768484-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530101539.768484-1-zhao1.liu@intel.com>
References: <20240530101539.768484-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

User will configure SMP cache topology via -smp.

For this case, update the x86 CPUs' cache topology with user's
configuration in MachineState.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3a2dadb4bce0..1bd1860ae625 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7764,6 +7764,27 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
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


