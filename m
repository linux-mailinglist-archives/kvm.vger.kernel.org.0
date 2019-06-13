Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 125CE437D7
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733044AbfFMPBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:01:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33368 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732548AbfFMOgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 10:36:10 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DA41430860D5;
        Thu, 13 Jun 2019 14:36:09 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B227C1001B0F;
        Thu, 13 Jun 2019 14:36:06 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Rob Bradford <robert.bradford@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Li Qiang <liq3ea@gmail.com>
Subject: [PATCH v2 09/20] hw/i386/pc: Rename bochs_bios_init as more generic fw_cfg_arch_create
Date:   Thu, 13 Jun 2019 16:34:35 +0200
Message-Id: <20190613143446.23937-10-philmd@redhat.com>
In-Reply-To: <20190613143446.23937-1-philmd@redhat.com>
References: <20190613143446.23937-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 13 Jun 2019 14:36:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bochs_bios_init() function is not restricted to the Bochs
BIOS and is useful to other BIOS.
Since it is not specific to the PC machine, and can be reused
by other machines of the X86 architecture, rename it as
fw_cfg_arch_create().

Suggested-by: Samuel Ortiz <sameo@linux.intel.com>
Reviewed-by: Li Qiang <liq3ea@gmail.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
v2: Rename x86_create_fw_cfg() -> fw_cfg_arch_create() (MST)
---
 hw/i386/pc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index acde575ced..75fb1a154a 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -932,7 +932,7 @@ static void pc_build_smbios(PCMachineState *pcms)
     }
 }
 
-static FWCfgState *bochs_bios_init(PCMachineState *pcms)
+static FWCfgState *fw_cfg_arch_create(PCMachineState *pcms)
 {
     FWCfgState *fw_cfg;
     uint64_t *numa_fw_cfg;
@@ -1512,7 +1512,7 @@ void pc_cpus_init(PCMachineState *pcms)
      * Limit for the APIC ID value, so that all
      * CPU APIC IDs are < pcms->apic_id_limit.
      *
-     * This is used for FW_CFG_MAX_CPUS. See comments on bochs_bios_init().
+     * This is used for FW_CFG_MAX_CPUS. See comments on fw_cfg_arch_create().
      */
     pcms->apic_id_limit = x86_cpu_apic_id_from_index(max_cpus - 1) + 1;
     possible_cpus = mc->possible_cpu_arch_ids(ms);
@@ -1766,7 +1766,7 @@ void pc_memory_init(PCMachineState *pcms,
                                         option_rom_mr,
                                         1);
 
-    fw_cfg = bochs_bios_init(pcms);
+    fw_cfg = fw_cfg_arch_create(pcms);
 
     rom_set_fw(fw_cfg);
 
-- 
2.20.1

