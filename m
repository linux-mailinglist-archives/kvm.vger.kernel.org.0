Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A3891A1B
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 00:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfHRW4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Aug 2019 18:56:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44352 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfHRW4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Aug 2019 18:56:06 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E518C058CA4;
        Sun, 18 Aug 2019 22:56:06 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-33.brq.redhat.com [10.40.204.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 836EE1C1;
        Sun, 18 Aug 2019 22:55:59 +0000 (UTC)
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
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 13/15] hw/i386/pc: Let pc_build_feature_control() take a MachineState argument
Date:   Mon, 19 Aug 2019 00:54:12 +0200
Message-Id: <20190818225414.22590-14-philmd@redhat.com>
In-Reply-To: <20190818225414.22590-1-philmd@redhat.com>
References: <20190818225414.22590-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Sun, 18 Aug 2019 22:56:06 +0000 (UTC)
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
index 460f55fd09..e57468a1a2 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1608,10 +1608,9 @@ void pc_cpus_init(PCMachineState *pcms)
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
@@ -1681,7 +1680,7 @@ void pc_machine_done(Notifier *notifier, void *data)
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

