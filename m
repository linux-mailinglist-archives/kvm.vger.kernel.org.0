Return-Path: <kvm+bounces-9158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 878D685B6F6
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:16:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5D0A286442
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70A1B60DEA;
	Tue, 20 Feb 2024 09:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LCY9PYKb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460ED60244
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 09:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708420333; cv=none; b=Py73Wc8MmRkUUF/TPahco7puWE9LoI438Q4XsdCni3Clru6Dg3H/HMY0lDUCwzX7HL2+04m/xj6UMElysCGS9RbjhcTHWTUTyiBikIv+45VVJsdSSEjaUFJ/magFV1JarUu2moTM0XisUvTrsmpawWB+l+6nvOWYjjSdalNhvfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708420333; c=relaxed/simple;
	bh=nmSGxPZR9yko6kQTreGOACQxkbHYm1OXOe8DkqwHjxw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uLZR244dRt2/zarhqosCjFK6+Hn+KyGsaPRbqwNPdGV1vD9sMZtaHZlWZ75iN/J5kbPQNO4HW3SrPsq6LprU/yk9NTUoo33sTgoSPgL7jMjrZ4kxand7OGt5zFHQt8jOn9ikkjQTLglHDtqChommXdg7pAV6iYtiRIAieeXSR/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LCY9PYKb; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708420332; x=1739956332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nmSGxPZR9yko6kQTreGOACQxkbHYm1OXOe8DkqwHjxw=;
  b=LCY9PYKb6n65x38sPMGFPYAPGObf1taaOodASshKzAsLyjPxkpKVvIBF
   yYYhrw+F1vcEXL1RM1wJYrV59TctdUq480UTwXw0LUbgES3WkcVshtsYY
   egDjPokKzbbjRo2A20mc/v0RtWrGMc7GPrKUOIrokHEq4DeLIjCxKFYsE
   OurmSW0Jg3BdlDZ5fnKJv34l5WCHblBF/r0ZO8Iz4tBt9MFo+2Zl6S0iv
   kdV6ikz5adyMRDyBgWfp112YIJbuHUBv4Wn4Ie2q3MAYgw3uT0hD3NHbT
   ZoQw5YRLj5cv3Om5cWeL06r/h49Y7kUzxcPMl6O9rILskIleCeBbc021o
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2375010"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="2375010"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 01:12:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="5013025"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa007.jf.intel.com with ESMTP; 20 Feb 2024 01:12:06 -0800
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
Subject: [RFC 5/8] i386/cpu: Support thread and module level cache topology
Date: Tue, 20 Feb 2024 17:25:01 +0800
Message-Id: <20240220092504.726064-6-zhao1.liu@linux.intel.com>
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

Allows cache to be defined at the thread and module level. This
increases flexibility for x86 users to customize their cache topology.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 725d7e70182d..d7cb0f1e49b4 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -241,9 +241,15 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
     uint32_t num_ids = 0;
 
     switch (share_level) {
+    case CPU_TOPO_LEVEL_THREAD:
+        num_ids = 1;
+        break;
     case CPU_TOPO_LEVEL_CORE:
         num_ids = 1 << apicid_core_offset(topo_info);
         break;
+    case CPU_TOPO_LEVEL_MODULE:
+        num_ids = 1 << apicid_module_offset(topo_info);
+        break;
     case CPU_TOPO_LEVEL_DIE:
         num_ids = 1 << apicid_die_offset(topo_info);
         break;
@@ -251,10 +257,6 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
         num_ids = 1 << apicid_pkg_offset(topo_info);
         break;
     default:
-        /*
-         * Currently there is no use case for SMT and MODULE, so use
-         * assert directly to facilitate debugging.
-         */
         g_assert_not_reached();
     }
 
-- 
2.34.1


