Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5A8263DF7
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 09:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbgIJHEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 03:04:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44221 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730316AbgIJHCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 03:02:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599721343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O4TiFU/E5h3g7pzVC+3Y38BqYPnJSqtGxVteMoOcLyc=;
        b=Ge45G/Q7ydS3jUaZqXQh9HXcOMzKMn41SLmLNo8T4W7cBzC59cGRIZ7IRmr6CMDfa7D++m
        5GYrIes4BnRi0XpE804YXgA2vH7aq9uTz1sZfdpo7sqeRtirlVcMN7++hoAv9UE7CPwfC1
        SQizXblDPBxhOoAOyQpKP3WfnfhpUYY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-CBaVnEybPHW-ZIv9UAnXlg-1; Thu, 10 Sep 2020 03:02:03 -0400
X-MC-Unique: CBaVnEybPHW-ZIv9UAnXlg-1
Received: by mail-wm1-f70.google.com with SMTP id x81so1295171wmg.8
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 00:02:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O4TiFU/E5h3g7pzVC+3Y38BqYPnJSqtGxVteMoOcLyc=;
        b=SSXxVhxE1Bps3fskwZZ4kRH0dwbQ4LRGE1BBTguwAGoi41sJaL3Vcvr2LN8HuJNVEM
         DOW5LaVqLRydRngweIYdWM8B++e2BezKBbfsUHCITHgp5kYpQlv3zRIRsbl8suYhL9bs
         cV95+pCIS92CCSNzWA/pDZlIGoeA9x8yLT6V4WO/mXXE7XTZ+T2bsVOdGYxkBPf2VThG
         fGuB9DEnJ6V1toWrvaFnEHstVWlpMjVfl4JakxgsIJY39apnvzXZgidTfvP2WDMC5isz
         UEiWmpUVyO3GTjIAIIg9GdZhoda7tE43jUuzo0zMkRb5Aszpi/h95sSqhoVrMk7pVCJK
         spWw==
X-Gm-Message-State: AOAM530Mp7fszbOUnh7NulR/nd9yqHY+WDtJNvkVFoMm///Og0LnHvEm
        U2H1idbWIUTnvpUQ7zePYaGfxwXId1lzagxCGpBYy5GOcBlnbAFRX0BSMMAdPJfoE+1xhg3uZ4O
        wrOchMeBmGcUv
X-Received: by 2002:a1c:c256:: with SMTP id s83mr7016242wmf.93.1599721322696;
        Thu, 10 Sep 2020 00:02:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRCTkH+/DmTsf56gy1ymOQ2OzxrWvy46F4cviEpju4FPjr5Ind5bZnv+UsKffp56Gc1+5NYw==
X-Received: by 2002:a1c:c256:: with SMTP id s83mr7016210wmf.93.1599721322497;
        Thu, 10 Sep 2020 00:02:02 -0700 (PDT)
Received: from x1w.redhat.com (65.red-83-57-170.dynamicip.rima-tde.net. [83.57.170.65])
        by smtp.gmail.com with ESMTPSA id z15sm7347660wrv.94.2020.09.10.00.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 00:02:01 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        qemu-trivial@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Joel Stanley <joel@jms.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 5/6] hw/pci-host/q35: Rename PCI 'black hole as '(memory) hole'
Date:   Thu, 10 Sep 2020 09:01:30 +0200
Message-Id: <20200910070131.435543-6-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200910070131.435543-1-philmd@redhat.com>
References: <20200910070131.435543-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to use inclusive terminology, rename "blackhole"
as "(memory)hole".

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/pci-host/q35.h |  4 ++--
 hw/pci-host/q35.c         | 38 +++++++++++++++++++-------------------
 tests/qtest/q35-test.c    |  2 +-
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/hw/pci-host/q35.h b/include/hw/pci-host/q35.h
index 070305f83df..0fb90aca18b 100644
--- a/include/hw/pci-host/q35.h
+++ b/include/hw/pci-host/q35.h
@@ -48,8 +48,8 @@ typedef struct MCHPCIState {
     PAMMemoryRegion pam_regions[13];
     MemoryRegion smram_region, open_high_smram;
     MemoryRegion smram, low_smram, high_smram;
-    MemoryRegion tseg_blackhole, tseg_window;
-    MemoryRegion smbase_blackhole, smbase_window;
+    MemoryRegion tseg_hole, tseg_window;
+    MemoryRegion smbase_hole, smbase_window;
     bool has_smram_at_smbase;
     Range pci_hole;
     uint64_t below_4g_mem_size;
diff --git a/hw/pci-host/q35.c b/hw/pci-host/q35.c
index b67cb9c29f8..21f58ccfa28 100644
--- a/hw/pci-host/q35.c
+++ b/hw/pci-host/q35.c
@@ -266,20 +266,20 @@ static const TypeInfo q35_host_info = {
  * MCH D0:F0
  */
 
-static uint64_t blackhole_read(void *ptr, hwaddr reg, unsigned size)
+static uint64_t memoryhole_read(void *ptr, hwaddr reg, unsigned size)
 {
     return 0xffffffff;
 }
 
-static void blackhole_write(void *opaque, hwaddr addr, uint64_t val,
+static void memoryhole_write(void *opaque, hwaddr addr, uint64_t val,
                             unsigned width)
 {
     /* nothing */
 }
 
-static const MemoryRegionOps blackhole_ops = {
-    .read = blackhole_read,
-    .write = blackhole_write,
+static const MemoryRegionOps memoryhole_ops = {
+    .read = memoryhole_read,
+    .write = memoryhole_write,
     .endianness = DEVICE_NATIVE_ENDIAN,
     .valid.min_access_size = 1,
     .valid.max_access_size = 4,
@@ -393,12 +393,12 @@ static void mch_update_smram(MCHPCIState *mch)
     } else {
         tseg_size = 0;
     }
-    memory_region_del_subregion(mch->system_memory, &mch->tseg_blackhole);
-    memory_region_set_enabled(&mch->tseg_blackhole, tseg_size);
-    memory_region_set_size(&mch->tseg_blackhole, tseg_size);
+    memory_region_del_subregion(mch->system_memory, &mch->tseg_hole);
+    memory_region_set_enabled(&mch->tseg_hole, tseg_size);
+    memory_region_set_size(&mch->tseg_hole, tseg_size);
     memory_region_add_subregion_overlap(mch->system_memory,
                                         mch->below_4g_mem_size - tseg_size,
-                                        &mch->tseg_blackhole, 1);
+                                        &mch->tseg_hole, 1);
 
     memory_region_set_enabled(&mch->tseg_window, tseg_size);
     memory_region_set_size(&mch->tseg_window, tseg_size);
@@ -456,7 +456,7 @@ static void mch_update_smbase_smram(MCHPCIState *mch)
     } else {
         lck = false;
     }
-    memory_region_set_enabled(&mch->smbase_blackhole, lck);
+    memory_region_set_enabled(&mch->smbase_hole, lck);
     memory_region_set_enabled(&mch->smbase_window, lck);
     memory_region_transaction_commit();
 }
@@ -601,13 +601,13 @@ static void mch_realize(PCIDevice *d, Error **errp)
     memory_region_set_enabled(&mch->high_smram, true);
     memory_region_add_subregion(&mch->smram, 0xfeda0000, &mch->high_smram);
 
-    memory_region_init_io(&mch->tseg_blackhole, OBJECT(mch),
-                          &blackhole_ops, NULL,
-                          "tseg-blackhole", 0);
-    memory_region_set_enabled(&mch->tseg_blackhole, false);
+    memory_region_init_io(&mch->tseg_hole, OBJECT(mch),
+                          &memoryhole_ops, NULL,
+                          "tseg-hole", 0);
+    memory_region_set_enabled(&mch->tseg_hole, false);
     memory_region_add_subregion_overlap(mch->system_memory,
                                         mch->below_4g_mem_size,
-                                        &mch->tseg_blackhole, 1);
+                                        &mch->tseg_hole, 1);
 
     memory_region_init_alias(&mch->tseg_window, OBJECT(mch), "tseg-window",
                              mch->ram_memory, mch->below_4g_mem_size, 0);
@@ -619,13 +619,13 @@ static void mch_realize(PCIDevice *d, Error **errp)
      * This is not what hardware does, so it's QEMU specific hack.
      * See commit message for details.
      */
-    memory_region_init_io(&mch->smbase_blackhole, OBJECT(mch), &blackhole_ops,
-                          NULL, "smbase-blackhole",
+    memory_region_init_io(&mch->smbase_hole, OBJECT(mch), &memoryhole_ops,
+                          NULL, "smbase-hole",
                           MCH_HOST_BRIDGE_SMBASE_SIZE);
-    memory_region_set_enabled(&mch->smbase_blackhole, false);
+    memory_region_set_enabled(&mch->smbase_hole, false);
     memory_region_add_subregion_overlap(mch->system_memory,
                                         MCH_HOST_BRIDGE_SMBASE_ADDR,
-                                        &mch->smbase_blackhole, 1);
+                                        &mch->smbase_hole, 1);
 
     memory_region_init_alias(&mch->smbase_window, OBJECT(mch),
                              "smbase-window", mch->ram_memory,
diff --git a/tests/qtest/q35-test.c b/tests/qtest/q35-test.c
index b7cf1449906..7cddd0a7f61 100644
--- a/tests/qtest/q35-test.c
+++ b/tests/qtest/q35-test.c
@@ -231,7 +231,7 @@ static void test_smram_smbase_lock(void)
         qpci_config_writeb(pcidev, MCH_HOST_BRIDGE_F_SMBASE, i);
         g_assert(qpci_config_readb(pcidev, MCH_HOST_BRIDGE_F_SMBASE) == 0x02);
 
-        /* RAM access should go into black hole */
+        /* RAM access should go into memory hole */
         qtest_writeb(qts, SMBASE, SMRAM_TEST_PATTERN);
         g_assert_cmpint(qtest_readb(qts, SMBASE), ==, 0xff);
     }
-- 
2.26.2

