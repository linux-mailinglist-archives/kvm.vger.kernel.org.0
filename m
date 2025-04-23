Return-Path: <kvm+bounces-43926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 259ABA98883
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 13:26:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C83F4440C6
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 11:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AD5527055D;
	Wed, 23 Apr 2025 11:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ObH4CDqm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CBE270556
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 11:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745407599; cv=none; b=UVTAGAhwmmZQg8eGvGOvY7/u5a/P9ITKn6JP2bp542Ivilkgt8h4MZXYl6+OR61xyMOZJI/zyOvBPNyNd+gvFX9Elkf9onnE8LMUNzGjhv8AGZVdJNUPfv88O8Yb1fA3MHRtmD5coA5ZOuz568806qh9pXoimQKrsRmVaMv5MLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745407599; c=relaxed/simple;
	bh=ro6LZDTZ2hjHpKbMDlTvllYkUuuqO9mI3PXZKl+8Ub8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=obLx6ULEtbYErPvtTVdXMbioG/xVV3cK6jnxG5ugPqtwuKkH1NIPQ9QkdwoX8C6C/DGxJZon85IwY3cXiyzHnKaRIWyyKqMYcpf6d9tw4YvQZpjlXA/6IV1PPXILqdqMpK6GMFp4MMQsfk1ysf9G2YKRY/bn+Ot50pcw4RyvsDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ObH4CDqm; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745407598; x=1776943598;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ro6LZDTZ2hjHpKbMDlTvllYkUuuqO9mI3PXZKl+8Ub8=;
  b=ObH4CDqmCVPDYU6ii2PEgNYUITGrbwz0gBWqJjj9wHduNVwFzAbPi/S+
   E+wapPQN65UcTj3Ppb7MOKkZQfMGe62M1yjwepxmA1zXGo64IkM6TOf1F
   0/xofyuD2XOvcvFb4WU01UcxmR52eNla+FAHrU6e4eOyrVWGU1XTxzyI3
   0EOqEU0fkJLGANeuuWrM2PJfsYrzzMt4RPWCzmLoKkRJIrobhSrDhArOZ
   D9gnCWLS41cxhSKHOVoO2ced5HL2/QNlGisx5isVsnhGTtkI+d62wLj1l
   UDoXYcnk5LR1k63QWK6UoWOAfzrq5sh6LWM9F1NkD2dfnVdw+hexG8M5r
   g==;
X-CSE-ConnectionGUID: egGIMTVYSEOH6khtG8WJ7A==
X-CSE-MsgGUID: r4hvK3rSQcaQZlU57IFUhA==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="50825306"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="50825306"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 04:26:38 -0700
X-CSE-ConnectionGUID: 9A6bHYTjSUiobgHkXuiizw==
X-CSE-MsgGUID: bL+hEagfSoWySz+YUSAf0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137150786"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 23 Apr 2025 04:26:34 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Babu Moger <babu.moger@amd.com>,
	Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Tejus GK <tejus.gk@nutanix.com>,
	Jason Zeng <jason.zeng@intel.com>,
	Manish Mishra <manish.mishra@nutanix.com>,
	Tao Su <tao1.su@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 07/10] i386/cpu: Add a "cpuid-0x1f" property
Date: Wed, 23 Apr 2025 19:46:59 +0800
Message-Id: <20250423114702.1529340-8-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250423114702.1529340-1-zhao1.liu@intel.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Manish Mishra <manish.mishra@nutanix.com>

Add a "cpuid-0x1f" property so that CPU models can enable it and have
0x1f CPUID leaf natually as the Host CPU.

The advantage is that when the CPU model's cache model is already
consistent with the Host CPU, for example, SRF defaults to l2 per
module & l3 per package, 0x1f can better help users identify the
topology in the VM.

Adding 0x1f for specific CPU models should not cause any trouble in
principle. This property is only enabled for CPU models that already
have 0x1f leaf on the Host, so software that originally runs normally on
the Host won't encounter issues in the Guest with corresponding CPU
model. Conversely, some software that relies on checking 0x1f might
experience problems in the Guest due to the lack of 0x1f [*]. In
summary, adding 0x1f is also intended to further emulate the Host CPU
environment. Therefore, the "x-" prefix is not added to this property.

[*]: https://lore.kernel.org/qemu-devel/PH0PR02MB738410511BF51B12DB09BE6CF6AC2@PH0PR02MB7384.namprd02.prod.outlook.com/

Co-authored-by: Xiaoyao Li <xiaoyao.li@intel.com>
(Missing signed-off from Manish & Xiaoyao)
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Note:
  This patch integrates the idea from 2 previous posted patches (ordered
by post time)[1] [2]. Although the target cases are not exactly the same
as this patch, add the authorship of previous authors.

[1]: From Manish: https://lore.kernel.org/qemu-devel/20240722101859.47408-1-manish.mishra@nutanix.com/
[2]: From Xiaoyao: https://lore.kernel.org/qemu-devel/20240813033145.279307-1-xiaoyao.li@intel.com/
---
 target/i386/cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e0716dbe5934..26dc5b6a6a8c 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -9195,6 +9195,7 @@ static const Property x86_cpu_properties[] = {
     DEFINE_PROP_BOOL("x-intel-pt-auto-level", X86CPU, intel_pt_auto_level,
                      true),
     DEFINE_PROP_BOOL("x-l1-cache-per-thread", X86CPU, l1_cache_per_core, true),
+    DEFINE_PROP_BOOL("cpuid-0x1f", X86CPU, enable_cpuid_0x1f, false),
 };
 
 #ifndef CONFIG_USER_ONLY
-- 
2.34.1


