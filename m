Return-Path: <kvm+bounces-16036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7FA78B348B
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 11:53:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 263CA1C21667
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 09:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C255140391;
	Fri, 26 Apr 2024 09:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="icOwCLYZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C3614039A
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 09:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714125200; cv=none; b=dYPGL9wwHgKEDcwQXLrS7KGwaaV9VxNb/jBtQ0oXfQEM8Dz5thHOkclTAUiIiQNCV2VIQmk75fn6yT0moSz2QQqu9Mt8nzSxOl870V0UIvc4idbMbobCDD0/s/8nBYaxV8o0rZTutBBjvvW6IGEwWMJXnombxt9JwcCoWjbc4BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714125200; c=relaxed/simple;
	bh=e+wzAqKxUeDUa8pgRYNdxpSqCSHlDsBB3q4TuojcMl4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Frq47OTrFAn0nnyquZY7R/tslGvrtvzsPb+nRSRmawn7z/j1Q/F5fQ8HkK4uf+WnEzWzYwRw0bqoLzNGL/DrN9iBJG+Oz1DKq5hb6DX5s9wjcKRwag3yCarR7gsWPAO2uHUNj9hUX5M8bA48zJvXI2Hk4nXMUs2AiM1VRyxPrHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=icOwCLYZ; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714125199; x=1745661199;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e+wzAqKxUeDUa8pgRYNdxpSqCSHlDsBB3q4TuojcMl4=;
  b=icOwCLYZvW1uqq+PcLBNnj9NkzZWPg7WgzFwZTxjPuHIxbqWK7MPwpuY
   yhiDeYZrj1KMszNImXoApNygrLCjl1/J0TVy5tea2rMS8z8VxXQhkP2xy
   R7DoI/lNO8F9D+Qs5husEewY+fQPrYOhzys5opkST98TQASvuJ6K85EeP
   S/rQL+VT/aIHm9vModpC+jO3PwP/zt6pDDCW3kInIV8em5+ykuu2nFU45
   Leu9Utr6+QnCpzmCYR/H/pQ3OPyu0uQQ68zingRTomKEt5n+HwFAPLnVm
   oANTgDuVz8FTCoqpdN2dAQH0+lBFB6vpknM5SI+OZRFDTsVrE+H2LhLLG
   A==;
X-CSE-ConnectionGUID: 1VrhE93RQdq+PGrBOd0X2w==
X-CSE-MsgGUID: mCUlNmElS6aci3jZsnCf+g==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9707403"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="9707403"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 02:53:18 -0700
X-CSE-ConnectionGUID: 9bVs7V2VS4GVZosEHzSEng==
X-CSE-MsgGUID: NtGGV9tXTFuXChK71Hdowg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="25412319"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa008.fm.intel.com with ESMTP; 26 Apr 2024 02:53:16 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 2/6] target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and MSR_KVM_SYSTEM_TIME definitions
Date: Fri, 26 Apr 2024 18:07:11 +0800
Message-Id: <20240426100716.2111688-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240426100716.2111688-1-zhao1.liu@intel.com>
References: <20240426100716.2111688-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These 2 MSRs have been already defined in the kvm_para header
(standard-headers/asm-x86/kvm_para.h).

Remove QEMU local definitions to avoid duplication.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/kvm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index d9e03891113f..b2c52ec9561f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -79,9 +79,6 @@
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


