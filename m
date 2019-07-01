Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32AC95BD10
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 15:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbfGANga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 09:36:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52104 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728795AbfGANga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 09:36:30 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8480E81F12;
        Mon,  1 Jul 2019 13:36:30 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 537BD6085B;
        Mon,  1 Jul 2019 13:36:27 +0000 (UTC)
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
Subject: [PATCH v3 09/15] hw/i386/pc: Let pc_build_smbios() take a FWCfgState argument
Date:   Mon,  1 Jul 2019 15:35:30 +0200
Message-Id: <20190701133536.28946-10-philmd@redhat.com>
In-Reply-To: <20190701133536.28946-1-philmd@redhat.com>
References: <20190701133536.28946-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 01 Jul 2019 13:36:30 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the FWCfgState object by argument, this will
allow us to remove the PCMachineState argument later.

Suggested-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/pc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 60ee71924a..2b6502a38c 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -887,7 +887,7 @@ static uint32_t x86_cpu_apic_id_from_index(unsigned int cpu_index)
     }
 }
 
-static void pc_build_smbios(PCMachineState *pcms)
+static void pc_build_smbios(PCMachineState *pcms, FWCfgState *fw_cfg)
 {
     uint8_t *smbios_tables, *smbios_anchor;
     size_t smbios_tables_len, smbios_anchor_len;
@@ -901,7 +901,7 @@ static void pc_build_smbios(PCMachineState *pcms)
 
     smbios_tables = smbios_get_table_legacy(&smbios_tables_len);
     if (smbios_tables) {
-        fw_cfg_add_bytes(pcms->fw_cfg, FW_CFG_SMBIOS_ENTRIES,
+        fw_cfg_add_bytes(fw_cfg, FW_CFG_SMBIOS_ENTRIES,
                          smbios_tables, smbios_tables_len);
     }
 
@@ -922,9 +922,9 @@ static void pc_build_smbios(PCMachineState *pcms)
     g_free(mem_array);
 
     if (smbios_anchor) {
-        fw_cfg_add_file(pcms->fw_cfg, "etc/smbios/smbios-tables",
+        fw_cfg_add_file(fw_cfg, "etc/smbios/smbios-tables",
                         smbios_tables, smbios_tables_len);
-        fw_cfg_add_file(pcms->fw_cfg, "etc/smbios/smbios-anchor",
+        fw_cfg_add_file(fw_cfg, "etc/smbios/smbios-anchor",
                         smbios_anchor, smbios_anchor_len);
     }
 }
@@ -1590,7 +1590,7 @@ void pc_machine_done(Notifier *notifier, void *data)
 
     acpi_setup();
     if (pcms->fw_cfg) {
-        pc_build_smbios(pcms);
+        pc_build_smbios(pcms, pcms->fw_cfg);
         pc_build_feature_control_file(pcms);
         /* update FW_CFG_NB_CPUS to account for -device added CPUs */
         fw_cfg_modify_i16(pcms->fw_cfg, FW_CFG_NB_CPUS, pcms->boot_cpus);
-- 
2.20.1

