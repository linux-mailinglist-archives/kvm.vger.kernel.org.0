Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E86437C9
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732564AbfFMPBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:01:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54258 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732555AbfFMOgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 10:36:36 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1649DB2DC8;
        Thu, 13 Jun 2019 14:36:36 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BF711001B0F;
        Thu, 13 Jun 2019 14:36:32 +0000 (UTC)
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
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 14/20] hw/i386/pc: Let pc_build_smbios() take a FWCfgState argument
Date:   Thu, 13 Jun 2019 16:34:40 +0200
Message-Id: <20190613143446.23937-15-philmd@redhat.com>
In-Reply-To: <20190613143446.23937-1-philmd@redhat.com>
References: <20190613143446.23937-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 13 Jun 2019 14:36:36 +0000 (UTC)
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
index 08df4f9895..c08869b52c 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -890,7 +890,7 @@ static uint32_t x86_cpu_apic_id_from_index(unsigned int cpu_index)
     }
 }
 
-static void pc_build_smbios(PCMachineState *pcms)
+static void pc_build_smbios(PCMachineState *pcms, FWCfgState *fw_cfg)
 {
     uint8_t *smbios_tables, *smbios_anchor;
     size_t smbios_tables_len, smbios_anchor_len;
@@ -904,7 +904,7 @@ static void pc_build_smbios(PCMachineState *pcms)
 
     smbios_tables = smbios_get_table_legacy(&smbios_tables_len);
     if (smbios_tables) {
-        fw_cfg_add_bytes(pcms->fw_cfg, FW_CFG_SMBIOS_ENTRIES,
+        fw_cfg_add_bytes(fw_cfg, FW_CFG_SMBIOS_ENTRIES,
                          smbios_tables, smbios_tables_len);
     }
 
@@ -925,9 +925,9 @@ static void pc_build_smbios(PCMachineState *pcms)
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
@@ -1593,7 +1593,7 @@ void pc_machine_done(Notifier *notifier, void *data)
 
     acpi_setup();
     if (pcms->fw_cfg) {
-        pc_build_smbios(pcms);
+        pc_build_smbios(pcms, pcms->fw_cfg);
         pc_build_feature_control_file(pcms);
         /* update FW_CFG_NB_CPUS to account for -device added CPUs */
         fw_cfg_modify_i16(pcms->fw_cfg, FW_CFG_NB_CPUS, pcms->boot_cpus);
-- 
2.20.1

