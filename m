Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD61D687DAF
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 13:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjBBMoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 07:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjBBMo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 07:44:26 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2DC8D61F
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 04:43:58 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvJ-004Q6t-8z; Thu, 02 Feb 2023 12:42:42 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org
Subject: [PATCH 24/39] target/riscv: add zvknh cpu properties
Date:   Thu,  2 Feb 2023 12:42:15 +0000
Message-Id: <20230202124230.295997-25-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
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
 target/riscv/cpu.c | 10 +++++++++-
 target/riscv/cpu.h |  2 ++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 0da04d0be1..a78d9ae120 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -101,6 +101,8 @@ static const struct isa_ext_data isa_edata_arr[] = {
     ISA_EXT_DATA_ENTRY(zve32f, true, PRIV_VERSION_1_12_0, ext_zve32f),
     ISA_EXT_DATA_ENTRY(zve64f, true, PRIV_VERSION_1_12_0, ext_zve64f),
     ISA_EXT_DATA_ENTRY(zvkb, true, PRIV_VERSION_1_12_0, ext_zvkb),
+    ISA_EXT_DATA_ENTRY(zvknha, true, PRIV_VERSION_1_12_0, ext_zvknha),
+    ISA_EXT_DATA_ENTRY(zvknhb, true, PRIV_VERSION_1_12_0, ext_zvknhb),
     ISA_EXT_DATA_ENTRY(zvkns, true, PRIV_VERSION_1_12_0, ext_zvkns),
     ISA_EXT_DATA_ENTRY(zhinx, true, PRIV_VERSION_1_12_0, ext_zhinx),
     ISA_EXT_DATA_ENTRY(zhinxmin, true, PRIV_VERSION_1_12_0, ext_zhinxmin),
@@ -798,13 +800,19 @@ static void riscv_cpu_realize(DeviceState *dev, Error **errp)
          * In principle zve*{x,d} would also suffice here, were they supported
          * in qemu
          */
-        if ((cpu->cfg.ext_zvkb || cpu->cfg.ext_zvkns) &&
+        if ((cpu->cfg.ext_zvkb || cpu->cfg.ext_zvkns || cpu->cfg.ext_zvknha) &&
             !(cpu->cfg.ext_zve32f || cpu->cfg.ext_zve64f || cpu->cfg.ext_v)) {
             error_setg(
                 errp, "Vector crypto extensions require V or Zve* extensions");
             return;
         }
 
+        if (cpu->cfg.ext_zvknhb && !(cpu->cfg.ext_zve64f || cpu->cfg.ext_v)) {
+            error_setg(errp,
+                       "Zvknhb extension requires V or Zve64f extensions");
+            return;
+        }
+
         /* Set the ISA extensions, checks should have happened above */
         if (cpu->cfg.ext_zdinx || cpu->cfg.ext_zhinx ||
             cpu->cfg.ext_zhinxmin) {
diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index 56008ef9b9..ebee902806 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -462,6 +462,8 @@ struct RISCVCPUConfig {
     bool ext_zve32f;
     bool ext_zve64f;
     bool ext_zvkb;
+    bool ext_zvknha;
+    bool ext_zvknhb;
     bool ext_zvkns;
     bool ext_zmmul;
     bool ext_smaia;
-- 
2.39.1

