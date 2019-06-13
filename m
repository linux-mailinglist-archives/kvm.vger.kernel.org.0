Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDF7437C4
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733010AbfFMPBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:01:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732560AbfFMOgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 10:36:54 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7390F89C37;
        Thu, 13 Jun 2019 14:36:54 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FEC81001B2B;
        Thu, 13 Jun 2019 14:36:51 +0000 (UTC)
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
Subject: [PATCH v2 18/20] hw/i386/pc: Let pc_build_feature_control() take a MachineState argument
Date:   Thu, 13 Jun 2019 16:34:44 +0200
Message-Id: <20190613143446.23937-19-philmd@redhat.com>
In-Reply-To: <20190613143446.23937-1-philmd@redhat.com>
References: <20190613143446.23937-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 13 Jun 2019 14:36:54 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let the pc_build_feature_control_file() function take a generic MachineState
argument.

Suggested-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/pc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 39155a14d9..0969efa87d 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1521,10 +1521,9 @@ void pc_cpus_init(PCMachineState *pcms)
     }
 }
 
-static void pc_build_feature_control_file(PCMachineState *pcms,
+static void pc_build_feature_control_file(MachineState *ms,
                                           FWCfgState *fw_cfg)
 {
-    MachineState *ms = MACHINE(pcms);
     X86CPU *cpu = X86_CPU(ms->possible_cpus->cpus[0].cpu);
     CPUX86State *env = &cpu->env;
     uint32_t unused, ecx, edx;
@@ -1594,7 +1593,7 @@ void pc_machine_done(Notifier *notifier, void *data)
     acpi_setup();
     if (pcms->fw_cfg) {
         fw_cfg_build_smbios(MACHINE(pcms), pcms->fw_cfg);
-        pc_build_feature_control_file(pcms, pcms->fw_cfg);
+        pc_build_feature_control_file(MACHINE(pcms), pcms->fw_cfg);
         /* update FW_CFG_NB_CPUS to account for -device added CPUs */
         fw_cfg_modify_i16(pcms->fw_cfg, FW_CFG_NB_CPUS, pcms->boot_cpus);
     }
-- 
2.20.1

