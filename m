Return-Path: <kvm+bounces-20933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 552ED926DC4
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 05:01:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9E8F1F24F48
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 03:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D6E1B59A;
	Thu,  4 Jul 2024 03:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XT7DiQri"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896B417C67
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 03:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720062075; cv=none; b=CvKGIuR7a28FBiM92LZ5KHgHtngyAWP69xz7fl1TcUR55mpMUu7H9nrRJ29Rrm9cO8aj0b3hPXJUPRMqFPaYMo/8GnahLpJg51yr6j/nZFzq7UI2RGuZx3e5VTwXA55seORZuR7XxinB4QBsG4shw1GmOcWJBeszhVw3yx/9ggE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720062075; c=relaxed/simple;
	bh=7xazZwz0EnajiB5Y3BpYOkdjmqrqDIqJeO1R5Tf6FMU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L3u0ZC92G+/4T8AE4m+NIjayaY9qnYcTT3h858DWcn/ga7ZOQNgiCwNtQctdQ+SJ/xLSGt8VHcz2mUPwYy3RCSoB10zjRFd934ubTau5AwhD3+4iaKwlFPUHgqKrc+VhWDl2rCcqY8qo4eS4EZ8hCqDMEHH0JzpkFVxECF03l60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XT7DiQri; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720062074; x=1751598074;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7xazZwz0EnajiB5Y3BpYOkdjmqrqDIqJeO1R5Tf6FMU=;
  b=XT7DiQriR2FX6Z4mUcy61QZJ/jd8kO22Q/qIfYbyyK2X/9iP+7hdVhb8
   hhmDhkhKlwIR4cYQPLF0B3LibxRx6ZGw1+BEyx3HZqwGENm5QLq4xPKpy
   GkOrcXp2/e4/mC4vdBmNDNbTWvsekMm2p0mdJPO6v9TAT20qXHAu2khRy
   YF17kPJ1lPUDHrmOcGpDVKPd8cd2m99g4fYqeRc3S5766/Vcqka4BFwOH
   hdxVGW8TOuZ8bVZDxvtRE9BV+9yIGd0QTCbMkTzLzDHJITjAOkZ3mV4ij
   e0w7JG1xyOFP7JVYM0PcJohUqdznOw1jJH1S3X3zBtLf7w7uM4Ts/8/QA
   Q==;
X-CSE-ConnectionGUID: fzAqoshPSfuFUoawlLI2TQ==
X-CSE-MsgGUID: syT9+eg/Ts2x6/vnjZpHbg==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="39838163"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="39838163"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 20:01:13 -0700
X-CSE-ConnectionGUID: uK+DmRjmRO6RTIeeRo8L0Q==
X-CSE-MsgGUID: PAO0ufSFQueLjRECY+D3Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="51052503"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 03 Jul 2024 20:01:08 -0700
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
Subject: [PATCH 8/8] qemu-options: Add the description of smp-cache object
Date: Thu,  4 Jul 2024 11:16:03 +0800
Message-Id: <20240704031603.1744546-9-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240704031603.1744546-1-zhao1.liu@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since RFC v2:
 * Rewrote the document of smp-cache object.

Changes since RFC v1:
 * Use "*_cache=topo_level" as -smp example as the original "level"
   term for a cache has a totally different meaning. (Jonathan)
---
 qemu-options.hx | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/qemu-options.hx b/qemu-options.hx
index 8ca7f34ef0c8..4b84f4508a6e 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -159,6 +159,15 @@ SRST
         ::
 
             -machine cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.targets.1=cxl.1,cxl-fmw.0.size=128G,cxl-fmw.0.interleave-granularity=512
+
+    ``smp-cache='id'``
+        Allows to configure cache property (now only the cache topology level).
+
+        For example:
+        ::
+
+            -object '{"qom-type":"smp-cache","id":"cache","caches":[{"name":"l1d","topo":"core"},{"name":"l1i","topo":"core"},{"name":"l2","topo":"module"},{"name":"l3","topo":"die"}]}'
+            -machine smp-cache=cache
 ERST
 
 DEF("M", HAS_ARG, QEMU_OPTION_M,
@@ -5871,6 +5880,55 @@ SRST
         ::
 
             (qemu) qom-set /objects/iothread1 poll-max-ns 100000
+
+    ``-object '{"qom-type":"smp-cache","id":id,"caches":[{"name":cache_name,"topo":cache_topo}]}'``
+        Create an smp-cache object that configures machine's cache
+        property. Currently, cache property only include cache topology
+        level.
+
+        This option must be written in JSON format to support JSON list.
+
+        The ``caches`` parameter accepts a list of cache property in JSON
+        format.
+
+        A list element requires the cache name to be specified in the
+        ``name`` parameter (currently ``l1d``, ``l1i``, ``l2`` and ``l3``
+        are supported). ``topo`` parameter accepts CPU topology levels
+        including ``thread``, ``core``, ``module``, ``cluster``, ``die``,
+        ``socket``, ``book``, ``drawer`` and ``default``. The ``topo``
+        parameter indicates CPUs winthin the same CPU topology container
+        are sharing the same cache.
+
+        Some machines may have their own cache topology model, and this
+        object may override the machine-specific cache topology setting
+        by specifying smp-cache object in the -machine. When specifying
+        the cache topology level of ``default``, it will honor the default
+        machine-specific cache topology setting. For other topology levels,
+        they will override the default setting.
+
+        An example list of caches to configure the cache model (l1d cache
+        per core, l1i cache per core, l2 cache per module and l3 cache per
+        socket) supported by PC machine might look like:
+
+        ::
+
+              {
+                "caches": [
+                   { "name": "l1d", "topo": "core" },
+                   { "name": "l1i", "topo": "core" },
+                   { "name": "l2", "topo": "module" },
+                   { "name": "l3", "topo": "socket" },
+                ]
+              }
+
+        An example smp-cache object would look like:()
+
+        .. parsed-literal::
+
+             # |qemu_system| \\
+                 ... \\
+                 -object '{"qom-type":"smp-cache","id":id,"caches":[{"name":cache_name,"topo":cache_topo}]}' \\
+                 ...
 ERST
 
 
-- 
2.34.1


