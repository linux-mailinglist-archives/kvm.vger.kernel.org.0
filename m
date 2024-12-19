Return-Path: <kvm+bounces-34121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ABCB9F76FD
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 09:14:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB05C16208B
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 08:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AB0821770F;
	Thu, 19 Dec 2024 08:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FSrq4/ca"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D79216E3E
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 08:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734596060; cv=none; b=N5K3M4T+vlMPU32c4sOU//DF1F7A84m2Z9IOfbnLFN4UyCY/Cd+RdkjKnTpSC4cvcpGCZMdfWUyDsBdJu7GA7JgESKkIaoYTNaxPrJqEWlfY08SSWIxlU1zbIDa/u0hE3ehwgVHZI/DCol+w2EIpGYEbU/wfQkOKfK0U42dn+2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734596060; c=relaxed/simple;
	bh=V6ehyfXRT03O4FtDAD3WitXv+2QkhSbJcwip23ZQEPY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OaRVFaTawrgOufcJmQXK5w2/UFrKCaerkyJx+oOAmf6aX7FEaRaYe77MrC5nGQVLaokg1v7LLssUesmIGH+1DyBYYFdMxWFjwsY+d4+TGrwTaTdLFyWQgPpBhEjINim12wsFphMyA8KnFyRgpIc1Pe7AYWOH+XG+BOV/R31SlnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FSrq4/ca; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734596058; x=1766132058;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V6ehyfXRT03O4FtDAD3WitXv+2QkhSbJcwip23ZQEPY=;
  b=FSrq4/caheZmPxJKSrRxiYIkR4suBIKGatyJE6oc7sUw8DNG8JiWve0f
   0sDSZbrIYZYQaD5uYAFmVjABFpbQzbqriU2FlC/dVmqGYEFbk94R3HVLm
   0UfcGDXPHR4spbhFExpLmO2cabjYTXk6OJvMQRdTcC2lIy0HjqfZ9Q7dq
   rJmMN7LT9Usa7bjCW3nqyVlRydBAZLCv2IYOUnZ4gbYBFZhQlEfJ1xWqW
   ivpuKTDRa7EhidXGfAUkT/Inf2PgNwpmQp9HNxLG88AgyuuI1zLZBcXyR
   R64QOQkfIGUYVt1g6k2/+KLv4zsKMWKbOgW2NigGqZ438ux5ZikkMuJ+H
   A==;
X-CSE-ConnectionGUID: 01SqeV3pTMKKEfZMgXsjfg==
X-CSE-MsgGUID: htR7K2YRRIerm5OYRQleaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="34378616"
X-IronPort-AV: E=Sophos;i="6.12,247,1728975600"; 
   d="scan'208";a="34378616"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2024 00:14:18 -0800
X-CSE-ConnectionGUID: UdqI/7S7RU+8fDk7cvji/Q==
X-CSE-MsgGUID: UGRcWDG8RRON72z74aDHVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="129097518"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 19 Dec 2024 00:14:15 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v6 1/4] i386/cpu: Support thread and module level cache topology
Date: Thu, 19 Dec 2024 16:32:34 +0800
Message-Id: <20241219083237.265419-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241219083237.265419-1-zhao1.liu@intel.com>
References: <20241219083237.265419-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow cache to be defined at the thread and module level. This
increases flexibility for x86 users to customize their cache topology.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 target/i386/cpu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 525339945920..87ffb9840cc1 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -243,9 +243,15 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
     uint32_t num_ids = 0;
 
     switch (share_level) {
+    case CPU_TOPOLOGY_LEVEL_THREAD:
+        num_ids = 1;
+        break;
     case CPU_TOPOLOGY_LEVEL_CORE:
         num_ids = 1 << apicid_core_offset(topo_info);
         break;
+    case CPU_TOPOLOGY_LEVEL_MODULE:
+        num_ids = 1 << apicid_module_offset(topo_info);
+        break;
     case CPU_TOPOLOGY_LEVEL_DIE:
         num_ids = 1 << apicid_die_offset(topo_info);
         break;
@@ -253,10 +259,6 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
         num_ids = 1 << apicid_pkg_offset(topo_info);
         break;
     default:
-        /*
-         * Currently there is no use case for THREAD and MODULE, so use
-         * assert directly to facilitate debugging.
-         */
         g_assert_not_reached();
     }
 
-- 
2.34.1


