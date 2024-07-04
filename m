Return-Path: <kvm+bounces-20932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D514D926DC3
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 05:01:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C91A1F24DCA
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 03:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA37217C73;
	Thu,  4 Jul 2024 03:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hczHqWAW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCE71BDCF
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 03:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720062070; cv=none; b=GbuaXxXqGhH9S0iyMiA6E9bOm0xYPSubWeSpM9a/TFC7BYNQfNDn1zlXfFL4rKcLLVCRLGddBMRQbwYaLExVdb1O6zN2xjk4xIIv/BRcVfjk7sYtSVfO3qyt7Tb4hcnznQenSm+boRVVfZFHj8/sBs+eeGrhBCxhHvCrOqdVozo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720062070; c=relaxed/simple;
	bh=5b9XogeXsVEL7ylTEoEbdPkYX3f+Rc5K1Le5/8Ng2nM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VG7VjUC5Mt3pRMRiYl/yE21ug6Bs2ac3EK/Xvs6XHGB9MYGTbAAkHYnynaRZ4xDHFce5pynI9YOnBt7e52bB1Mh+FwOW8785zvxzOblLwotMHqpEvQIuTln9O3WB685R70QWoCuNBJatPZvo4FjdUk/0VZ8LkiGpqq9oTlIXjMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hczHqWAW; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720062068; x=1751598068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5b9XogeXsVEL7ylTEoEbdPkYX3f+Rc5K1Le5/8Ng2nM=;
  b=hczHqWAWxwgL3AbZHaP/qjknohqQ7t5WwV8Rppp+u0YV5RT5qzKcuCf7
   kNCegVtQP6NqAFvUkvmKq2EzxXzvLBJP9w03yIGZsvoUus2PvR8U6v7nT
   SRhf4EF7WAgh/4NT29TUKA0AOQLGCyIbl5EZZvB8Df48oRIQWg5FwAnHt
   TQwwY9fPOUrNDXPQIK/1aP2UoUFQPU5ItbidgKW9wNVJyNCFN4N5JrcPW
   XIsOA2cxnI4N+JZTVoWSp20f+dQbY34vZi+fOobYiwAPI63NNoHfSKkye
   5IIEQPmtEjxJin+G+GoJQwOcBpAjvFRrHwcDaHFVqTF3lorQB7RtMLkkd
   g==;
X-CSE-ConnectionGUID: DBrUlwd1RCak24kOpOaMcQ==
X-CSE-MsgGUID: set8z8RWRdaCugoO1GuwYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="39838150"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="39838150"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 20:01:08 -0700
X-CSE-ConnectionGUID: 7hVCaK83SaCzBXqUcS03NQ==
X-CSE-MsgGUID: MBIRtr8ERn++cWHf40ULow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="51052471"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 03 Jul 2024 20:01:03 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 7/8] i386/pc: Support cache topology in -machine for PC machine
Date: Thu,  4 Jul 2024 11:16:02 +0800
Message-Id: <20240704031603.1744546-8-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240704031603.1744546-1-zhao1.liu@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow user to configure l1d, l1i, l2 and l3 cache topologies for PC
machine.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since RFC v2:
 * Used cache_supported array.
---
 hw/i386/pc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 77415064c62e..1614a3b1bf19 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1773,6 +1773,10 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     mc->nvdimm_supported = true;
     mc->smp_props.dies_supported = true;
     mc->smp_props.modules_supported = true;
+    mc->smp_props.cache_supported[SMP_CACHE_L1D] = true;
+    mc->smp_props.cache_supported[SMP_CACHE_L1I] = true;
+    mc->smp_props.cache_supported[SMP_CACHE_L2] = true;
+    mc->smp_props.cache_supported[SMP_CACHE_L3] = true;
     mc->default_ram_id = "pc.ram";
     pcmc->default_smbios_ep_type = SMBIOS_ENTRY_POINT_TYPE_AUTO;
 
-- 
2.34.1


