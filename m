Return-Path: <kvm+bounces-43927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 708C9A98885
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 13:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6CE67AE944
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 11:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F41270567;
	Wed, 23 Apr 2025 11:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MWIMvZpH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB0C26E14D
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 11:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745407603; cv=none; b=W7tprTnbaOsVNo+RL6aZcXioLqdBvWVUXQmbL9Uw7jEJW9dR2pIvxnfgzylguqMYhTEmYeCwVhu4z9j1Fojjsyj3yaeWzGOBhoHtGu6tExwaf8D4O+NaZXewoqbhcVECDbT4oPuEk5iCqxowxgQyRDD9SMNK4DbXMH3F4jypn4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745407603; c=relaxed/simple;
	bh=4q6Or/+6p9mp+08bZ9Ij5ZWPX5A6SM+UoEM54szMPr4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tUCd2CdYio7XXMVpas/mKSrNF9WWmd25xmGt3xnKCMGBVrpb7DmLLRYoRY3EW8z/G9rMJ4K6jjWhrd58e0PbVrzSFHSnBqWdtzidLHl7Bk7kgfcmzff0DuqCWsn5CIYUrmVySvlEz6XpWZpLvcq+McF9yJQWQaiJcA1WYhyNtC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MWIMvZpH; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745407602; x=1776943602;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4q6Or/+6p9mp+08bZ9Ij5ZWPX5A6SM+UoEM54szMPr4=;
  b=MWIMvZpHuNKGw8ax/i7jIDGyaDSdiJ8fZ6+GDo5cz2aKFw0tw2Sb56FO
   iVohAtjEh74DppFeXBnU5JtaGJhkc8asRZibP7eAXS3mL8C586QHVf86k
   Qr4kDJ1gDNAzuLaZKF55qfU5ifR7/bnsWebDUP5gu5jDs4kR9tBYnBGr+
   +A1Q8PkKHcamBs3+J2RGM6UFcXCegCSFYHL4OKbk2co5GVGlqSM4zXNdM
   Y4Sgwzie5Dc208Q8qdJ1CXgs14RkxfbkxlV7Iqgqw8KD0SDmaNSrAHFm/
   MEs2jfLpSylI/N16PrvyxIPETcT+yFm1AMf0QyhJ1EEmFedWIOYJdNDHo
   w==;
X-CSE-ConnectionGUID: z0xJ2nAHRyeSUp1jo6duvA==
X-CSE-MsgGUID: ZM7uAuueTGSUVYzKHDvWAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="50825313"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="50825313"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 04:26:41 -0700
X-CSE-ConnectionGUID: LydGAKfyTp+US07j7VmH9A==
X-CSE-MsgGUID: MQJmjqnKRnGYG4bE3LBY/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137150812"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 23 Apr 2025 04:26:38 -0700
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
Subject: [RFC 08/10] i386/cpu: Enable 0x1f leaf for SierraForest by default
Date: Wed, 23 Apr 2025 19:47:00 +0800
Message-Id: <20250423114702.1529340-9-zhao1.liu@intel.com>
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

Host SierraForest CPU has 0x1f leaf by default, so that enable it for
Guest CPU by default as well.

Suggested-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 26dc5b6a6a8c..2a518b68e67a 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -4856,8 +4856,11 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             },
             {
                 .version = 3,
-                .note = "with srf-sp cache model",
+                .note = "with srf-sp cache model and 0x1f leaf",
                 .cache_info = &xeon_srf_cache_info,
+                .props = (PropValue[]) {
+                    { "cpuid-0x1f", "on" },
+                }
             },
             { /* end of list */ },
         },
-- 
2.34.1


