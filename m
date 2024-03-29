Return-Path: <kvm+bounces-13074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CEA0A89167A
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 11:06:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8423C1F22B86
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 10:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22EF353812;
	Fri, 29 Mar 2024 10:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HwP8qpl6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED69535B4
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 10:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711706775; cv=none; b=hpvynsoZOnUVDd2UgCbjijRdq3+gZDmtgwIBnDoqjcYB1s/KMN5V89ImO2O5q2C6fXhO2m8Z2dNRVl+pGUIIzUdsfAJI5zOkqJItbfDL/OPiINPqx6aWrosx2gv8dc9SbK4xcd2WWpVmbRbWqZoBWa2aZlKopv+XZ8iHJ4B/hHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711706775; c=relaxed/simple;
	bh=nNPyld0ZVjtOrEm2t2CP+87Iy7y4IZ/jnSqhCZUWB2k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YaSp6BSOR6xHU2+ly9NCQh6CxvLHv2hUiHZlSn6bJx0Kvt66vwaVrS00tTmH3ygSizUyW5g3y5ZNvizInuAO0xcKHtNB526zrRo86GeSy3iXq8ykdO4cxVmLi2RepzjdLE+3whx3YIkV9wDLwmo47yn9xJRcaI/IVWnpBhS7BIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HwP8qpl6; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711706774; x=1743242774;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nNPyld0ZVjtOrEm2t2CP+87Iy7y4IZ/jnSqhCZUWB2k=;
  b=HwP8qpl6a5Fdwp0v5jko3KVbky6jamLcOuNb/o/KtZLeojzFIRVG/sy9
   l6ilhkxC0ODdO2U/PaJpneOe/jxaJe2vsBXYIhFhklpNVY0hMK584Fxgn
   nHzhivkLUWyXMYE/B2GcgyjYRgVtxQyQzzrw/zW0ftG2QutlvuAVHOY1s
   ynPbD+IJZ9YGcGUfRjw1blUBzBEpz7nwjAbO3MnhK4mhHKn3DP6bfEBiA
   /kpnF0A172XY6V2jsRyaNa1rjhhW9l4iaGQ+1b1rK/VC6jz1ubl6SR4vn
   LPkHy35J0uzh1I0ZgZVVZpy3ou7dHV6//zdIXd9HzICBoKp3ReAXeEdub
   A==;
X-CSE-ConnectionGUID: uiGmtduVR1WMgu1SWxqYYg==
X-CSE-MsgGUID: nzPSVdjES7WEuJzEtEI10A==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="17519212"
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="17519212"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 03:06:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="21441964"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 29 Mar 2024 03:06:10 -0700
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Tim Wiederhake <twiederh@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH for-9.1 2/7] target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and MSR_KVM_SYSTEM_TIME definitions
Date: Fri, 29 Mar 2024 18:19:49 +0800
Message-Id: <20240329101954.3954987-3-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
References: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

These 2 MSRs have been already defined in the kvm_para header
(standard-headers/asm-x86/kvm_para.h).

Remove QEMU local definitions to avoid duplication.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/kvm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 2f3c8bc3a4ed..be88339fb8bd 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -78,9 +78,6 @@
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


