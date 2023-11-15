Return-Path: <kvm+bounces-1768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF44E7EBDC2
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:20:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DEA8B21184
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7567B611B;
	Wed, 15 Nov 2023 07:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P5FKGonF"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B48566D
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:20:38 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17168E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032837; x=1731568837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o/b2r+JMHXnuhXbhX0S0LbDCiTLPdhuFZMas2aP1BKY=;
  b=P5FKGonFGiFAkKaAQ9xkB0WbELLE3EkoJmcY5Fc00QfgloBPZEzh/MJ3
   /1xz9k9LpKXTWE9+erB1GomeTkBgcOaVuNupGXn7frPNkD1Wy/lLLA8o/
   OM7TJ2s1V/rx+N67DzQjcYdS82gcPiMsWDHGI6UThnzD5PUbCw4WFOm+j
   xZmjO0+2z+bgGbg6VfgZt3w1LC+u3vmmRi/X/UxmKkuz90piIdQcwo5sq
   4atEDMpzXzrnnxkurGHpJYzE8rXX63lExIb8rNSV2+9ab/W00bzCEOe5V
   GoC9u2f8F9yh2kwZ85RyA27pwXDveSYKsFHDSu5hpJ1S2Vx9IkVeIGzQW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623186"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623186"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:20:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714799831"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714799831"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:20:26 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v3 40/70] i386/tdx: Skip BIOS shadowing setup
Date: Wed, 15 Nov 2023 02:14:49 -0500
Message-Id: <20231115071519.2864957-41-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
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
index fde5467c4750..2f299355a5e3 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1170,17 +1170,20 @@ void x86_bios_rom_init(MachineState *ms, const char *default_firmware,
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


