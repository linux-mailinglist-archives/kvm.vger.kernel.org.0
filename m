Return-Path: <kvm+bounces-24111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 947BD951607
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:03:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4983D285AFF
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CC7513D2B2;
	Wed, 14 Aug 2024 08:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FAsVuJSU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082DB1422BD
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723622566; cv=none; b=rr+yAqRxD+HWdD+OtC9XsjUCQFMvnLcYm42JQc3rj/NTKWVXIZO5zxSVoQp41zCXq7GqWdvmL2onNdf+o5tf5im0zeHxVBxUQkMCv7ZIcEl6SHUmok32Ow01bVxF1E1PLT+itdZRBvDk7yyidVwAz1Rp2CSf7+5vhRABYMv+ATc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723622566; c=relaxed/simple;
	bh=YQXU1V8cjOIRfFnAkE3ZUsJxcIpDFj6x85Y7iJEOblI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GiotfhNJ/03BWUaTCJcUL6KM84NBR5DXivVSrk++8NpbsG2ICyEYUtVPKBy3xlblY5D41/Sxcx6JuaPLqg5EuOnuOKgYxiXwaqvBOKxAFBzTi2nTgVHoMTi5tHDppdsZGUlu2PJx8JUkaxZz7hC/XHVTWRIUFlEYVed4S0oKyDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FAsVuJSU; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723622565; x=1755158565;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YQXU1V8cjOIRfFnAkE3ZUsJxcIpDFj6x85Y7iJEOblI=;
  b=FAsVuJSUhjhd/Y9c+6E21bfNvNCvm7l9FUOBRAi5DwYcMMQGJk/KxSqX
   ljSdzf7CRMWpljpTPUq+mj2804jSYvAYwUPM8fdh/kDHjcD4N8Ct/eani
   7qsl9D1DV0b3QKNAepM0TACF7YVzBdXC/XsUeZzLtsRlKH2R+Cq51JKbz
   5e6zKIfS/ZIRWoL2hB3irap9QxNQUs+BiYwf76m5Jq2Fe7dMhT30ywQcE
   6G568WlLusethbDs0b5SJuUwolgDn6Gb7UyOCStf4AS16m5MgqWaybWgR
   za1mAScm8TTt9BBxMUJrz2St6JOnIceSRroi6W/kYVB4aVBuH+C3kSvYl
   A==;
X-CSE-ConnectionGUID: T2bXfMHQT7WyOqDSAI17IA==
X-CSE-MsgGUID: jKq6PBzPTtyGxU61haXxOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="25584508"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="25584508"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 01:02:44 -0700
X-CSE-ConnectionGUID: aHkv1BIkToCVIdaFFa7Yyg==
X-CSE-MsgGUID: t1AZl/TdSAq9Ftp1CBFuKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="59048966"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Aug 2024 01:02:43 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com
Subject: [PATCH 8/9] i386/cpu: Drop AMD alias bits in FEAT_8000_0001_EDX for non-AMD guests
Date: Wed, 14 Aug 2024 03:54:30 -0400
Message-Id: <20240814075431.339209-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240814075431.339209-1-xiaoyao.li@intel.com>
References: <20240814075431.339209-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The AMD alias bits are reserved for Intel.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index fed805e04aeb..85ce405ece80 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6118,6 +6118,11 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w)
 #endif
         break;
 
+    case FEAT_8000_0001_EDX:
+        if (cpu && !IS_AMD_CPU(&cpu->env)) {
+            unavail = CPUID_EXT2_AMD_ALIASES;
+        }
+        break;
     default:
         break;
     }
-- 
2.34.1


