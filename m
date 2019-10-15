Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF4ED7BA0
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388084AbfJOQbi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:31:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388066AbfJOQbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:31:37 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6136810C093C;
        Tue, 15 Oct 2019 16:31:37 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7337A19C58;
        Tue, 15 Oct 2019 16:31:11 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <amarkovic@wavecomp.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        xen-devel@lists.xenproject.org,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 22/32] hw/i386/pc: Move gsi_state creation code
Date:   Tue, 15 Oct 2019 18:26:55 +0200
Message-Id: <20191015162705.28087-23-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Tue, 15 Oct 2019 16:31:37 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The block code related to IRQ start few lines later. Move
the comment and the pc_gsi_create() call where we start
to use the IRQs.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/pc_q35.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 52261962b8..6d096eff28 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -209,9 +209,6 @@ static void pc_q35_init(MachineState *machine)
                        rom_memory, &ram_memory);
     }
 
-    /* irq lines */
-    gsi_state = pc_gsi_create(&pcms->gsi, pcmc->pci_enabled);
-
     /* create pci host bus */
     q35_host = Q35_HOST_DEVICE(qdev_create(NULL, TYPE_Q35_HOST_DEVICE));
 
@@ -245,6 +242,9 @@ static void pc_q35_init(MachineState *machine)
     object_property_set_link(OBJECT(machine), OBJECT(lpc),
                              PC_MACHINE_ACPI_DEVICE_PROP, &error_abort);
 
+    /* irq lines */
+    gsi_state = pc_gsi_create(&pcms->gsi, pcmc->pci_enabled);
+
     ich9_lpc = ICH9_LPC_DEVICE(lpc);
     lpc_dev = DEVICE(lpc);
     for (i = 0; i < GSI_NUM_PINS; i++) {
-- 
2.21.0

