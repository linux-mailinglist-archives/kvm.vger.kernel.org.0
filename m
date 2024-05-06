Return-Path: <kvm+bounces-16692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77C5A8BC9AB
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A85491C216C3
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 08:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001281422B9;
	Mon,  6 May 2024 08:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T85YniSX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853E21422B7
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 08:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714984673; cv=none; b=pGyR9Ql0H9AkhlsUFEjCL0PT6iPR2nLZi6bGDpnxjqMUeNQxmGI7xWdl23NNIXhJ+Oh2h9fBP+d1mS8tghd26Ikuyfb1jAWZhXhsqFrUOsdiI7Ca4lViFHWk8oVgLjlFXz99Wo/tLzBw+vYQG1u6imCMt+97O8Qr9+KaQmFn+3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714984673; c=relaxed/simple;
	bh=1YsI4Fnl026ibo8C5oM4++UbsFuSKVGk5i1HUX040ys=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oT0CJp+jH0PgJQUXi+J7WesQNkqAJLxD2JbwWGFeup1ayBKiFEWgUS7Nc4EXhVBnlwbGvCL7KwqrCV0wrAs9wjXvYSa9/nRSCZryNSl76jqBHsbMMuM1fBnBzaSv7v3HRIrY7x1hCZhDZCtt2xz+dLVVhdGFL+082ZuF5JltVGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T85YniSX; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714984672; x=1746520672;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1YsI4Fnl026ibo8C5oM4++UbsFuSKVGk5i1HUX040ys=;
  b=T85YniSXhtxNevfAN4afO4/ENEn57Qv/XJW8tQpfVgliilZxRLp1PQm7
   tOoaT+YH8WWj4pMQ0CdtVKUEhhqOUBAK2SRRc+5ndrXR/+OCVCF9rJY6x
   cuGPNIfYfUyOOYUjlgYnEfWGG8dps00nn7xsr0Kma0/8FASIscrXiXBhk
   +oG5TMtSl2STO5cfwMIQU9c9+GSM4kgtYF83+t6yHxSsWJX29IZSHrVWI
   R6PdSAEV80TmArIi2UGArs4XlxHd5ALefcvDX8ivDwzUecvdGNHMW0W0W
   78vwkxjVohVKC22LKlMcVyyp+J4+5gbxoPy7IrDv9gepcmOFi4FZD1bVk
   g==;
X-CSE-ConnectionGUID: lVK9HhLfQs6xOqps5MyFjA==
X-CSE-MsgGUID: XEfbL6vFSwmdiquRBmcPYA==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="14533331"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="14533331"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 01:37:52 -0700
X-CSE-ConnectionGUID: JtEF03fMQCKxoB2LHt3g0Q==
X-CSE-MsgGUID: NLFPo/ICSoO+WRHnkSCYWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="28186723"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 06 May 2024 01:37:49 -0700
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
Subject: [PATCH v2 2/6] target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and MSR_KVM_SYSTEM_TIME definitions
Date: Mon,  6 May 2024 16:51:49 +0800
Message-Id: <20240506085153.2834841-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240506085153.2834841-1-zhao1.liu@intel.com>
References: <20240506085153.2834841-1-zhao1.liu@intel.com>
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


