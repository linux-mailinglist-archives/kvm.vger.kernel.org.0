Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172AF6B3A1E
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 10:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjCJJRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 04:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjCJJQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 04:16:47 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1327910A2B8
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 01:12:46 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1paYne-00GpVx-V4; Fri, 10 Mar 2023 09:12:30 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org
Subject: [PATCH 29/45] target/riscv: Add zvknh cpu properties
Date:   Fri, 10 Mar 2023 09:11:59 +0000
Message-Id: <20230310091215.931644-30-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310091215.931644-1-lawrence.hunter@codethink.co.uk>
References: <20230310091215.931644-1-lawrence.hunter@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nazar Kazakov <nazar.kazakov@codethink.co.uk>

Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
---
 target/riscv/cpu.c | 11 ++++++++++-
 target/riscv/cpu.h |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index cd87eec919..3ffbdd53cc 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -111,6 +111,8 @@ static const struct isa_ext_data isa_edata_arr[] = {
     ISA_EXT_DATA_ENTRY(zvfhmin, true, PRIV_VERSION_1_12_0, ext_zvfhmin),
     ISA_EXT_DATA_ENTRY(zvkb, true, PRIV_VERSION_1_12_0, ext_zvkb),
     ISA_EXT_DATA_ENTRY(zvkned, true, PRIV_VERSION_1_12_0, ext_zvkned),
+    ISA_EXT_DATA_ENTRY(zvknha, true, PRIV_VERSION_1_12_0, ext_zvknha),
+    ISA_EXT_DATA_ENTRY(zvknhb, true, PRIV_VERSION_1_12_0, ext_zvknhb),
     ISA_EXT_DATA_ENTRY(zhinx, true, PRIV_VERSION_1_12_0, ext_zhinx),
     ISA_EXT_DATA_ENTRY(zhinxmin, true, PRIV_VERSION_1_12_0, ext_zhinxmin),
     ISA_EXT_DATA_ENTRY(smaia, true, PRIV_VERSION_1_12_0, ext_smaia),
@@ -1217,7 +1219,7 @@ static void riscv_cpu_realize(DeviceState *dev, Error **errp)
     * In principle zve*x would also suffice here, were they supported
     * in qemu
     */
-    if ((cpu->cfg.ext_zvkb || cpu->cfg.ext_zvkned) &&
+    if ((cpu->cfg.ext_zvkb || cpu->cfg.ext_zvkned || cpu->cfg.ext_zvknha) &&
         !(cpu->cfg.ext_zve32f || cpu->cfg.ext_zve64f ||
             cpu->cfg.ext_zve64d || cpu->cfg.ext_v)) {
         error_setg(
@@ -1225,6 +1227,13 @@ static void riscv_cpu_realize(DeviceState *dev, Error **errp)
         return;
     }
 
+    if (cpu->cfg.ext_zvknhb &&
+        !(cpu->cfg.ext_zve64f || cpu->cfg.ext_zve64d || cpu->cfg.ext_v)) {
+            error_setg(errp,
+                       "Zvknhb extension requires V or Zve64{f,d} extensions");
+            return;
+    }
+
 #ifndef CONFIG_USER_ONLY
     if (cpu->cfg.pmu_num) {
         if (!riscv_pmu_init(cpu, cpu->cfg.pmu_num) && cpu->cfg.ext_sscofpmf) {
diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index 4f3b97e0f1..5d101fc405 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -472,6 +472,8 @@ struct RISCVCPUConfig {
     bool ext_zve64d;
     bool ext_zvkb;
     bool ext_zvkned;
+    bool ext_zvknha;
+    bool ext_zvknhb;
     bool ext_zmmul;
     bool ext_zvfh;
     bool ext_zvfhmin;
-- 
2.39.2

