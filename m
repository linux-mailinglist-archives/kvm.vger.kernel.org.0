Return-Path: <kvm+bounces-21614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D27E930D3B
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 06:34:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62096B20E4F
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 04:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D94313B2A9;
	Mon, 15 Jul 2024 04:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D32tPnMQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87FF13A89C
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 04:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721018067; cv=none; b=hdRkKm+XC2ekRh9yaE9KhG16bflu9UsbslDKmilLxs3ha6ekfckaJNkCsBgEi1fGOknWVKD2HTrgBBpj+aD2MNheaU7voRjGZL6zmI1mL17OiamMMpxmUSa9lAeHZ97ksV/XwmAmGtoDjYqD7NrNeyF+vo469imvg2HJExGQSeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721018067; c=relaxed/simple;
	bh=ORQtPOUjRaH7fq192/3Uf+CcJuvKVSUruZo9xOxKbJw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=glO6ygplGQhM0uLi4jJYgVUsN9hnWU/DcivFqyh2HXlDVZXhwBltpRQIL2HG5JsQwjcBIiDkxV60dK6JcrUfpn2UP+BkLDmHqtKzwZEPnL1tHL3WAOjDGW1r40PQuNNl0c3bVx06yyKU+xUWVGzsQCPgbzyYHvNk4XkohWxbLhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D32tPnMQ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721018066; x=1752554066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ORQtPOUjRaH7fq192/3Uf+CcJuvKVSUruZo9xOxKbJw=;
  b=D32tPnMQvqSk0nJNaVEEU9x6PnS+10NVssb0MLmfrESWa31191SyAznX
   gzTZbXUPq8j0VPwL6JQZy0xJkzASl1vVk6pKP3dZlauCDrLzcTd/SbBa3
   18H3v7EFi/tGEaOgy4rznLjJJ7REa3seHg/WNshfbT8MxvfSnqrnVSMIj
   VoJShpMJwBVPsM3hnPgVzlydo7b9UNBuXbdOil3osvs9p4iuHoSHAFaAY
   ENA21jISt/hGojHo5L7ytUIs7v3Y4I5/R8mQsD7JeMT7MMQNShORLsg9V
   EYZSPoYAMEGDf3EVh7nHPWBWWbkJBLIST25F5IGUuIElru9+DHjatnJqk
   g==;
X-CSE-ConnectionGUID: nSpOYx7XQRuiA/mCKn4sSQ==
X-CSE-MsgGUID: Q+rEXTLGR0K9Xw0XTXridA==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="35809812"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="35809812"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2024 21:34:26 -0700
X-CSE-ConnectionGUID: 1TK6ChxeSL2fX8CDCR/HwQ==
X-CSE-MsgGUID: 4lGA0LgxTMmECm7U3JD7IQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="54043046"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 14 Jul 2024 21:34:22 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v3 2/8] target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and MSR_KVM_SYSTEM_TIME definitions
Date: Mon, 15 Jul 2024 12:49:49 +0800
Message-Id: <20240715044955.3954304-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240715044955.3954304-1-zhao1.liu@intel.com>
References: <20240715044955.3954304-1-zhao1.liu@intel.com>
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

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/kvm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 86e42beb78bf..6ad5a7dbf1fd 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -81,9 +81,6 @@
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


