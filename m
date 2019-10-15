Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C9CD7B9A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388081AbfJOQbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:31:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727839AbfJOQbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:31:11 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A7C6780166F;
        Tue, 15 Oct 2019 16:31:10 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0599E19C58;
        Tue, 15 Oct 2019 16:31:04 +0000 (UTC)
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
Subject: [PATCH 21/32] hw/i386/pc: Reduce gsi_handler scope
Date:   Tue, 15 Oct 2019 18:26:54 +0200
Message-Id: <20191015162705.28087-22-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Tue, 15 Oct 2019 16:31:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pc_gsi_create() is the single function that uses gsi_handler.
Make it a static variable.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/pc.c         | 2 +-
 include/hw/i386/pc.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index a7597c6c44..59de0c8a1f 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -346,7 +346,7 @@ GlobalProperty pc_compat_1_4[] = {
 };
 const size_t pc_compat_1_4_len = G_N_ELEMENTS(pc_compat_1_4);
 
-void gsi_handler(void *opaque, int n, int level)
+static void gsi_handler(void *opaque, int n, int level)
 {
     GSIState *s = opaque;
 
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index d0c6b9d469..75b44e156c 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -172,8 +172,6 @@ typedef struct GSIState {
     qemu_irq ioapic_irq[IOAPIC_NUM_PINS];
 } GSIState;
 
-void gsi_handler(void *opaque, int n, int level);
-
 GSIState *pc_gsi_create(qemu_irq **irqs, bool pci_enabled);
 
 /* vmport.c */
-- 
2.21.0

