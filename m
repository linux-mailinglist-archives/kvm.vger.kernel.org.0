Return-Path: <kvm+bounces-9160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2C6F85B6F8
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:16:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F6C61F257D6
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F5B865BAB;
	Tue, 20 Feb 2024 09:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T5GcXKey"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38286657B1
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 09:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708420344; cv=none; b=M2ZYge+BTLYzEzSIwYtNiY1gmZyxfjH01XamvO5Y2vw8oZCq8f2JNNSuMiUZzD8ndt+ndVYFirqhsDqZOmyBhFmhUzdftMlX7hjkcEfbONvCznKyNyNEcGQ0T5wEg3Wm96rzLDW1wH61qLdnr0E5v2Icee5kGlp3CXjhrLK+Woo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708420344; c=relaxed/simple;
	bh=N8NOOJ+pARZ8UH7DHP7I4LRh9UGou9oDu+xcL8Vc/Rs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YCAUIzHRRQE5wg9RGUgZEKMzv/jTZYAWyUXY4BB9q7kFeb5sCVCSDoiiJyO127u1FVV90eLORW2SUO7QSZyuJbV79urMib5Shb2E+LQ9m93JsIZUDIDZBJDEcNE7NE0J+PCRffyxc4ImFjpmsbL19V11S+mnsj55zB20f55M6g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T5GcXKey; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708420343; x=1739956343;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N8NOOJ+pARZ8UH7DHP7I4LRh9UGou9oDu+xcL8Vc/Rs=;
  b=T5GcXKeyZ/8Ifo91q68wiPSBT5SI0nIb4gvcTpt5O3aN/B7dGxdl+swi
   qGqZbaYIOPBShHyRE/57nCg2ENxIt474jeoyrLjE21gR+Sv54QEO/9xua
   gKhLZZYi0AXg0M0kFV0ZXHxAQ9tRLTu3PLwZw9b3TGjBwpB8WHDpXJDLZ
   9ewDliafsUDaFVxCe6+06rgGhN8mW3KnAdFbJ4xB85yEwDuETPFwlybcV
   TnmRh5AIqgm/WUl5SIE31IsUiQ6O9XhvWiN4StxGDErXwtKjDiCpkv8ld
   2WaKNrgP0qBVXBzZ1Zq8GfpAssS169M711QRGrSNBD25TG+vA8NxRq2ZC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2375027"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="2375027"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 01:12:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="5013100"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa007.jf.intel.com with ESMTP; 20 Feb 2024 01:12:17 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
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
Subject: [RFC 7/8] i386/pc: Support cache topology in -smp for PC machine
Date: Tue, 20 Feb 2024 17:25:03 +0800
Message-Id: <20240220092504.726064-8-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/pc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 25124a077eea..76148c3337cf 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1848,6 +1848,9 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     mc->nvdimm_supported = true;
     mc->smp_props.dies_supported = true;
     mc->smp_props.modules_supported = true;
+    mc->smp_props.l1_separated_cache_supported = true;
+    mc->smp_props.l2_unified_cache_supported = true;
+    mc->smp_props.l3_unified_cache_supported = true;
     mc->default_ram_id = "pc.ram";
     pcmc->default_smbios_ep_type = SMBIOS_ENTRY_POINT_TYPE_64;
 
-- 
2.34.1


