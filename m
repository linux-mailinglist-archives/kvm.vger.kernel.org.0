Return-Path: <kvm+bounces-30834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 118879BDD30
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:50:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE4241F242BA
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6965D19006F;
	Wed,  6 Nov 2024 02:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VSibFtXS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160B518A92C
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 02:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730861400; cv=none; b=g6BEZPXQ9qYUKmzwwI4btdAInIiGlEFbijq0NqrzMk64Yo9rioDPUas6xf4VxtK7M5q4MlaZe2tP712vnBd8KaeMPEM5NG8XQ3SHdQZeyrhcoK69KJFej9ljIjk71Y6/UVsw2hVeoDHF/1Z/LrN45jZpVavK+vFRLhO1p1y3U8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730861400; c=relaxed/simple;
	bh=YCBXtXIe8Tj9CHWP8C3P1QBlVFRxdenXMtX2KpHHTFo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UtmyeuQ9+XBV5mo1SM7RXeIWqQEfHg+tm4CvV6DmMb1INHHYwPKBJfu21q+k8TPqYvgBD/GoYVLSW2eMZfIjxXdMHyq7B20cZSeWDIGB4E9QcJaPWAf+i6Dwn9AoBKT6kvWHqVY/qYa8XIs1nnvcdqJeHNTHf1rDO3anYp8aG9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VSibFtXS; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730861399; x=1762397399;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YCBXtXIe8Tj9CHWP8C3P1QBlVFRxdenXMtX2KpHHTFo=;
  b=VSibFtXSvGpnlD8FC6Vt8hhR+tojof1mnxZO/ZBHNjQLdVy+zitIhDCt
   PQ9WPSOmhEfn6MS1uL/sZH3GLejtelPr+GutQno/yWj0AHY8NfZqw/4S7
   CH7eOIE8Bj1r8Bj8S8OCxz7Ydb7BUAbOA/ISyXqNd1j9zBbSLH2aGr5D6
   BI3OchjDkmcGkZEx0Bm8SnQkuq21g0BPjNkueJg3OgHtKAr3K8PoXX4I5
   XaxmWZ2cljHEW09YA06BFkKsaZ1KJcPKfza1C58rKh8OMq/iCoCB3686D
   9DlvCnsr/l0BMyCG/o5V1r1ZaLQAPc1g1iWAsMMj+RGnDenzYM5ctih1Z
   w==;
X-CSE-ConnectionGUID: Tg8In+fZQiW8LiaVXwiGZw==
X-CSE-MsgGUID: S+ZIj9JTTwqltONyqqrmoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30492220"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30492220"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:49:59 -0800
X-CSE-ConnectionGUID: LtXUEkcQS06dIeJkGeBUoQ==
X-CSE-MsgGUID: G2sgJd0QRS+Risb+wHwD5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="115077984"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 05 Nov 2024 18:49:56 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 03/11] target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and MSR_KVM_SYSTEM_TIME definitions
Date: Wed,  6 Nov 2024 11:07:20 +0800
Message-Id: <20241106030728.553238-4-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241106030728.553238-1-zhao1.liu@intel.com>
References: <20241106030728.553238-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These 2 MSRs have been already defined in kvm_para.h (standard-headers/
asm-x86/kvm_para.h).

Remove QEMU local definitions to avoid duplication.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
---
 target/i386/kvm/kvm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4fb822511a12..54520a77d6af 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -95,9 +95,6 @@
 #define KVM_APIC_BUS_CYCLE_NS       1
 #define KVM_APIC_BUS_FREQUENCY      (1000000000ULL / KVM_APIC_BUS_CYCLE_NS)
 
-#define MSR_KVM_WALL_CLOCK  0x11
-#define MSR_KVM_SYSTEM_TIME 0x12
-
 /* A 4096-byte buffer can hold the 8-byte kvm_msrs header, plus
  * 255 kvm_msr_entry structs */
 #define MSR_BUF_SIZE 4096
-- 
2.34.1


