Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D516B274A08
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 22:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgIVUTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 16:19:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726785AbgIVUTt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 16:19:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600805988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jiMyrJEnAYgkkVWygOH1TIFk/RLS8Nq9gl/xrF7Oldk=;
        b=ih5Y9jS+2imi9EmR0vnj9XG8lToA1rzahkOyQFgyvkLQYrdxMn3VvqgrIUlpo8PHQ1EkX3
        oqjlWxLnlh5XIbiFvwqQ7QQXZmI2RpzcxP/XcWsjh4JRRvmhpSBOUKIbfdO3vpr6VplElN
        ixioHXBize3kKdGEkeuFzHkE3himPTE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-NJpeCggvNqm9K1aDoFmkpg-1; Tue, 22 Sep 2020 16:19:46 -0400
X-MC-Unique: NJpeCggvNqm9K1aDoFmkpg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1905E8B1242;
        Tue, 22 Sep 2020 20:19:45 +0000 (UTC)
Received: from localhost (unknown [10.10.67.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 085B473689;
        Tue, 22 Sep 2020 20:19:38 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sergio Lopez <slp@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 3/3] i386/kvm: Delete kvm_allows_irq0_override()
Date:   Tue, 22 Sep 2020 16:19:22 -0400
Message-Id: <20200922201922.2153598-4-ehabkost@redhat.com>
In-Reply-To: <20200922201922.2153598-1-ehabkost@redhat.com>
References: <20200922201922.2153598-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As IRQ routing is always available on x86,
kvm_allows_irq0_override() will always return true, so we don't
need the function anymore.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 target/i386/kvm_i386.h | 1 -
 hw/i386/fw_cfg.c       | 2 +-
 hw/i386/microvm.c      | 2 +-
 hw/i386/pc.c           | 2 +-
 target/i386/kvm-stub.c | 5 -----
 target/i386/kvm.c      | 5 -----
 6 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/target/i386/kvm_i386.h b/target/i386/kvm_i386.h
index 064b8798a26..b11704cc772 100644
--- a/target/i386/kvm_i386.h
+++ b/target/i386/kvm_i386.h
@@ -32,7 +32,6 @@
 
 #endif  /* CONFIG_KVM */
 
-bool kvm_allows_irq0_override(void);
 bool kvm_has_smm(void);
 bool kvm_has_adjust_clock_stable(void);
 bool kvm_has_exception_payload(void);
diff --git a/hw/i386/fw_cfg.c b/hw/i386/fw_cfg.c
index 33441ad4840..e06579490c4 100644
--- a/hw/i386/fw_cfg.c
+++ b/hw/i386/fw_cfg.c
@@ -123,7 +123,7 @@ FWCfgState *fw_cfg_arch_create(MachineState *ms,
     fw_cfg_add_bytes(fw_cfg, FW_CFG_ACPI_TABLES,
                      acpi_tables, acpi_tables_len);
 #endif
-    fw_cfg_add_i32(fw_cfg, FW_CFG_IRQ0_OVERRIDE, kvm_allows_irq0_override());
+    fw_cfg_add_i32(fw_cfg, FW_CFG_IRQ0_OVERRIDE, 1);
 
     fw_cfg_add_bytes(fw_cfg, FW_CFG_E820_TABLE,
                      &e820_reserve, sizeof(e820_reserve));
diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index 60d32722301..05fb0536dcc 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -225,7 +225,7 @@ static void microvm_memory_init(MicrovmMachineState *mms)
     fw_cfg_add_i16(fw_cfg, FW_CFG_NB_CPUS, machine->smp.cpus);
     fw_cfg_add_i16(fw_cfg, FW_CFG_MAX_CPUS, machine->smp.max_cpus);
     fw_cfg_add_i64(fw_cfg, FW_CFG_RAM_SIZE, (uint64_t)machine->ram_size);
-    fw_cfg_add_i32(fw_cfg, FW_CFG_IRQ0_OVERRIDE, kvm_allows_irq0_override());
+    fw_cfg_add_i32(fw_cfg, FW_CFG_IRQ0_OVERRIDE, 1);
     fw_cfg_add_bytes(fw_cfg, FW_CFG_E820_TABLE,
                      &e820_reserve, sizeof(e820_reserve));
     fw_cfg_add_file(fw_cfg, "etc/e820", e820_table,
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index b55369357e5..0bc569d4c6b 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -859,7 +859,7 @@ void pc_guest_info_init(PCMachineState *pcms)
     MachineState *ms = MACHINE(pcms);
     X86MachineState *x86ms = X86_MACHINE(pcms);
 
-    x86ms->apic_xrupt_override = kvm_allows_irq0_override();
+    x86ms->apic_xrupt_override = true;
     pcms->numa_nodes = ms->numa_state->num_nodes;
     pcms->node_mem = g_malloc0(pcms->numa_nodes *
                                     sizeof *pcms->node_mem);
diff --git a/target/i386/kvm-stub.c b/target/i386/kvm-stub.c
index 872ef7df4c8..92f49121b8f 100644
--- a/target/i386/kvm-stub.c
+++ b/target/i386/kvm-stub.c
@@ -13,11 +13,6 @@
 #include "cpu.h"
 #include "kvm_i386.h"
 
-bool kvm_allows_irq0_override(void)
-{
-    return 1;
-}
-
 #ifndef __OPTIMIZE__
 bool kvm_has_smm(void)
 {
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index cf6dc90f7c5..c419c52ec58 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -148,11 +148,6 @@ bool kvm_has_exception_payload(void)
     return has_exception_payload;
 }
 
-bool kvm_allows_irq0_override(void)
-{
-    return !kvm_irqchip_in_kernel() || kvm_has_gsi_routing();
-}
-
 static bool kvm_x2apic_api_set_flags(uint64_t flags)
 {
     KVMState *s = KVM_STATE(current_accel());
-- 
2.26.2

