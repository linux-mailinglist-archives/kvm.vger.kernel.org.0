Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7085BD14
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 15:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbfGANhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 09:37:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41585 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbfGANhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 09:37:01 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9CED7307D860;
        Mon,  1 Jul 2019 13:36:51 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 467D8608BA;
        Mon,  1 Jul 2019 13:36:46 +0000 (UTC)
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
Subject: [PATCH v3 13/15] hw/i386/pc: Let pc_build_feature_control() take a MachineState argument
Date:   Mon,  1 Jul 2019 15:35:34 +0200
Message-Id: <20190701133536.28946-14-philmd@redhat.com>
In-Reply-To: <20190701133536.28946-1-philmd@redhat.com>
References: <20190701133536.28946-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 01 Jul 2019 13:37:00 +0000 (UTC)
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
index c49617a3f1..2ab2c637fd 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1518,10 +1518,9 @@ void pc_cpus_init(PCMachineState *pcms)
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
@@ -1591,7 +1590,7 @@ void pc_machine_done(Notifier *notifier, void *data)
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

