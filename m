Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB5165BD0F
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 15:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbfGANg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 09:36:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41584 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727268AbfGANg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 09:36:27 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D61493092649;
        Mon,  1 Jul 2019 13:36:26 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 493C96085B;
        Mon,  1 Jul 2019 13:36:19 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, kvm@vger.kernel.org,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rob Bradford <robert.bradford@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v3 08/15] hw/i386/pc: Let fw_cfg_init() use the generic MachineState
Date:   Mon,  1 Jul 2019 15:35:29 +0200
Message-Id: <20190701133536.28946-9-philmd@redhat.com>
In-Reply-To: <20190701133536.28946-1-philmd@redhat.com>
References: <20190701133536.28946-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 01 Jul 2019 13:36:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We removed the PCMachineState access, we can now let the fw_cfg_init()
function to take a generic MachineState object.

Suggested-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/pc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 1e856704e1..60ee71924a 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -929,7 +929,7 @@ static void pc_build_smbios(PCMachineState *pcms)
     }
 }
 
-static FWCfgState *fw_cfg_arch_create(PCMachineState *pcms,
+static FWCfgState *fw_cfg_arch_create(MachineState *ms,
                                       const CPUArchIdList *cpus,
                                       uint16_t boot_cpus,
                                       uint16_t apic_id_limit)
@@ -1667,6 +1667,7 @@ void pc_memory_init(PCMachineState *pcms,
     MemoryRegion *ram_below_4g, *ram_above_4g;
     FWCfgState *fw_cfg;
     MachineState *machine = MACHINE(pcms);
+    MachineClass *mc = MACHINE_GET_CLASS(machine);
     PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
 
     assert(machine->ram_size == pcms->below_4g_mem_size +
@@ -1763,7 +1764,7 @@ void pc_memory_init(PCMachineState *pcms,
                                         option_rom_mr,
                                         1);
 
-    fw_cfg = fw_cfg_arch_create(pcms, mc->possible_cpu_arch_ids(machine),
+    fw_cfg = fw_cfg_arch_create(machine, mc->possible_cpu_arch_ids(machine),
                                 pcms->boot_cpus, pcms->apic_id_limit);
 
     rom_set_fw(fw_cfg);
-- 
2.20.1

