Return-Path: <kvm+bounces-10395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFDBC86C10B
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:43:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7595D1F21138
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C87247F65;
	Thu, 29 Feb 2024 06:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dWMnZGtp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E6E4595B
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188912; cv=none; b=aGhJSTqyXe6eVY9dovJI2KFxT4mu3PgExbGpw7xruQ1Z4AUXpw4D3Fy08V4ONCNak6MXHJYwJMHHpMYJ/YpMi6skv1s51FZ9Lj8O5BYyu4yU4OtS3ASvj9j0ev8nLj8F2b/itla182o0lehLQm3wBpVei6fgBbX8bnD8uC2uC/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188912; c=relaxed/simple;
	bh=w+3FVIgu6+6PP0tbc6InvSJYIh6/cEjrfhsEEHWGAEQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dW5Wq7sPNhUxukrvH5xyxlq26HDOsBWVUqvJ3yFUnu08pQ5Yl2yfYffexYaWxRfuvrPl6o4clTU1AGIyiHDOwVtXDKBQmyjwycHyUs7CqP0uuycku4f8FVGS0c+7SR6Zb1SJ/Ia+q4aOM7N1ey2ZlpQNxrusKU+yxjmpPK6btEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dWMnZGtp; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188911; x=1740724911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w+3FVIgu6+6PP0tbc6InvSJYIh6/cEjrfhsEEHWGAEQ=;
  b=dWMnZGtpQ04YJVACU9DwUn14yFiEuFde53oes70dSxp6QoJ8lHjc/w4M
   vt4vkrwIg6TIeykMEraLLiq7o1mz+fnRxUGI7+5K52OhjZH5syx1JDsD3
   VJHiAFQClgZ2AtYcLIdUkCmemArASJn+0rFi4NBguYF6J+fTn2krgSbGf
   MrwTQ3UqGlmwp1MJGx13nEp4deutoynr2AHU5Tuv0Hl3z8Js7+rlmwHlU
   naP5f5t4UoEPpVgle6vDnRA/OW6GJHKN2GawRPKPswlvQ8g+DYW+wHBAP
   88AGfMa6S2mGtffsXZL/bj02yeobtUA+j/8ZZllcsj03CFXDP8rFztQTC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802950"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802950"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:41:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8075755"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:41:45 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 39/65] i386/tdx: Skip BIOS shadowing setup
Date: Thu, 29 Feb 2024 01:37:00 -0500
Message-Id: <20240229063726.610065-40-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TDX doesn't support map different GPAs to same private memory. Thus,
aliasing top 128KB of BIOS as isa-bios is not supported.

On the other hand, TDX guest cannot go to real mode, it can work fine
without isa-bios.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
Changes in v1:
 - update commit message and comment to clarify
---
 hw/i386/x86.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 5a0cadc88c4f..61c45dfc14dd 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1190,17 +1190,20 @@ void x86_bios_rom_init(MachineState *ms, const char *default_firmware,
     }
     g_free(filename);
 
-    /* map the last 128KB of the BIOS in ISA space */
-    isa_bios_size = MIN(bios_size, 128 * KiB);
-    isa_bios = g_malloc(sizeof(*isa_bios));
-    memory_region_init_alias(isa_bios, NULL, "isa-bios", bios,
-                             bios_size - isa_bios_size, isa_bios_size);
-    memory_region_add_subregion_overlap(rom_memory,
-                                        0x100000 - isa_bios_size,
-                                        isa_bios,
-                                        1);
-    if (!isapc_ram_fw) {
-        memory_region_set_readonly(isa_bios, true);
+    /* For TDX, alias different GPAs to same private memory is not supported */
+    if (!is_tdx_vm()) {
+        /* map the last 128KB of the BIOS in ISA space */
+        isa_bios_size = MIN(bios_size, 128 * KiB);
+        isa_bios = g_malloc(sizeof(*isa_bios));
+        memory_region_init_alias(isa_bios, NULL, "isa-bios", bios,
+                                bios_size - isa_bios_size, isa_bios_size);
+        memory_region_add_subregion_overlap(rom_memory,
+                                            0x100000 - isa_bios_size,
+                                            isa_bios,
+                                            1);
+        if (!isapc_ram_fw) {
+            memory_region_set_readonly(isa_bios, true);
+        }
     }
 
     /* map all the bios at the top of memory */
-- 
2.34.1


