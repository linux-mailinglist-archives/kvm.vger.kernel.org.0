Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A45CD91A10
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 00:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfHRWyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Aug 2019 18:54:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37964 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfHRWyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Aug 2019 18:54:49 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DEE121951D5A;
        Sun, 18 Aug 2019 22:54:48 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-33.brq.redhat.com [10.40.204.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A98E31C1;
        Sun, 18 Aug 2019 22:54:37 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Samuel Ortiz <sameo@linux.intel.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Rob Bradford <robert.bradford@intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Li Qiang <liq3ea@gmail.com>
Subject: [PATCH v4 03/15] hw/i386/pc: Use address_space_memory in place
Date:   Mon, 19 Aug 2019 00:54:02 +0200
Message-Id: <20190818225414.22590-4-philmd@redhat.com>
In-Reply-To: <20190818225414.22590-1-philmd@redhat.com>
References: <20190818225414.22590-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Sun, 18 Aug 2019 22:54:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The address_space_memory variable is used once.
Use it in place and remove the argument.

Suggested-by: Samuel Ortiz <sameo@linux.intel.com>
Reviewed-by: Li Qiang <liq3ea@gmail.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/pc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 75cdf57922..68086cc0fc 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -933,7 +933,7 @@ static void pc_build_smbios(PCMachineState *pcms)
     }
 }
 
-static FWCfgState *bochs_bios_init(AddressSpace *as, PCMachineState *pcms)
+static FWCfgState *bochs_bios_init(PCMachineState *pcms)
 {
     FWCfgState *fw_cfg;
     uint64_t *numa_fw_cfg;
@@ -941,7 +941,8 @@ static FWCfgState *bochs_bios_init(AddressSpace *as, PCMachineState *pcms)
     const CPUArchIdList *cpus;
     MachineClass *mc = MACHINE_GET_CLASS(pcms);
 
-    fw_cfg = fw_cfg_init_io_dma(FW_CFG_IO_BASE, FW_CFG_IO_BASE + 4, as);
+    fw_cfg = fw_cfg_init_io_dma(FW_CFG_IO_BASE, FW_CFG_IO_BASE + 4,
+                                &address_space_memory);
     fw_cfg_add_i16(fw_cfg, FW_CFG_NB_CPUS, pcms->boot_cpus);
 
     /* FW_CFG_MAX_CPUS is a bit confusing/problematic on x86:
@@ -1853,7 +1854,7 @@ void pc_memory_init(PCMachineState *pcms,
                                         option_rom_mr,
                                         1);
 
-    fw_cfg = bochs_bios_init(&address_space_memory, pcms);
+    fw_cfg = bochs_bios_init(pcms);
 
     rom_set_fw(fw_cfg);
 
-- 
2.20.1

