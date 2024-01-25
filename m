Return-Path: <kvm+bounces-6898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DDE783B738
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:40:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90C4D1C215D5
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 02:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 363B17468;
	Thu, 25 Jan 2024 02:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aeTLuqt1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AE66FAD
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 02:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706150425; cv=none; b=IEzsfzm8OR+Y4Lp7MCmZwgHWV5Cl22R3iqSq9BXqdKFtyHamjdTmvRhwCx4taUVfoQcpXDPWAA5r/ZydZl+f5KC6HY2bZ7REPL9DsFIUbPcGzeDHKwc9eq5CEGcsnpEQv3GuC9nm9xVvHnmME2rWig0uN8WPlZG2m7wsUUmoEnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706150425; c=relaxed/simple;
	bh=nblpklNzUZKD78eAt5m3cZr0n/f8GwIruXeYbHNh9Ok=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MGoY00e/v2XeEbEcP6xoYZmttWidISD28OivFM3ESZOAlt1USKp1ofbc9M1NrGyP1uoXgPivysesa9vkCHhmeOdxh99N46Qp7TbUi02covBFOEtplAlZxF4cl0Gk5eMIqO4850H20eEtCtvryALUZoQYLEKZ9O31jqIlKm2mn0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aeTLuqt1; arc=none smtp.client-ip=192.55.52.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706150423; x=1737686423;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nblpklNzUZKD78eAt5m3cZr0n/f8GwIruXeYbHNh9Ok=;
  b=aeTLuqt1FEfwoNUy6DiwbfIAbjOQ3v5LKQhpcfaWCzceDM7xRFiLPwVO
   8E9BuYY9ZpaMDjzEmrVRQwiTD8Uk5mQhxKJli4fq3SSy1WhxOaD6jrhvN
   ymJ/jlcxhCVXE9FaW7ZCoV1tK8k2cdUCWYCSc/8YWiX7SC1Eh49POZcHi
   pXFEjUOGM5HctLp3ywauDbPRJqtBRBHanLVyG5FQSQgGaXYk0nwVj82TA
   wyFFDZ68R7qksFdLhyl+AvbkwdFWC94XQrXi6Uj5X83OfxiW0bg45NnA9
   JxuRK/mPVD/9o25K8CU5fjob9ImhW9BBrkipwypw3XVLWgStf3Y4Ih2FO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="401687454"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="401687454"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 18:40:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2120530"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa003.jf.intel.com with ESMTP; 24 Jan 2024 18:40:21 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com
Subject: [PATCH v3 1/3] i386/cpuid: Decrease cpuid_i when skipping CPUID leaf 1F
Date: Wed, 24 Jan 2024 21:40:14 -0500
Message-Id: <20240125024016.2521244-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125024016.2521244-1-xiaoyao.li@intel.com>
References: <20240125024016.2521244-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Existing code misses a decrement of cpuid_i when skip leaf 0x1F.
There's a blank CPUID entry(with leaf, subleaf as 0, and all fields
stuffed 0s) left in the CPUID array.

It conflicts with correct CPUID leaf 0.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by:Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/kvm/kvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 76a66246eb72..dff9dedbd761 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1914,6 +1914,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
         case 0x1f:
             if (env->nr_dies < 2) {
+                cpuid_i--;
                 break;
             }
             /* fallthrough */
-- 
2.34.1


