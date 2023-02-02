Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6267B687E68
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 14:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjBBNTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 08:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbjBBNT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 08:19:28 -0500
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CC48C1E5
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 05:19:26 -0800 (PST)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.office.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pNYvM-004Q6t-LH; Thu, 02 Feb 2023 12:42:45 +0000
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Max Chou <max.chou@sifive.com>
Subject: [PATCH 35/39] crypto: Move SM4_SBOXWORD from target/riscv
Date:   Thu,  2 Feb 2023 12:42:26 +0000
Message-Id: <20230202124230.295997-36-lawrence.hunter@codethink.co.uk>
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

From: Max Chou <max.chou@sifive.com>

    - Share SM4_SBOXWORD between target/riscv and target/arm.

Signed-off-by: Max Chou <max.chou@sifive.com>
Reviewed-by: Frank Chang <frank.chang@sifive.com>
---
 include/crypto/sm4.h       |  7 +++++++
 target/arm/crypto_helper.c | 10 ++--------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/crypto/sm4.h b/include/crypto/sm4.h
index 9bd3ebc62e..33478562a4 100644
--- a/include/crypto/sm4.h
+++ b/include/crypto/sm4.h
@@ -1,6 +1,13 @@
 #ifndef QEMU_SM4_H
 #define QEMU_SM4_H
 
+#define SM4_SBOXWORD(WORD) ( \
+    sm4_sbox[((WORD) >> 24) & 0xff] << 24 | \
+    sm4_sbox[((WORD) >> 16) & 0xff] << 16 | \
+    sm4_sbox[((WORD) >>  8) & 0xff] <<  8 | \
+    sm4_sbox[((WORD) >>  0) & 0xff] <<  0   \
+)
+
 extern const uint8_t sm4_sbox[256];
 
 #endif
diff --git a/target/arm/crypto_helper.c b/target/arm/crypto_helper.c
index d28690321f..4e97af9879 100644
--- a/target/arm/crypto_helper.c
+++ b/target/arm/crypto_helper.c
@@ -707,10 +707,7 @@ static void do_crypto_sm4e(uint64_t *rd, uint64_t *rn, uint64_t *rm)
             CR_ST_WORD(d, (i + 3) % 4) ^
             CR_ST_WORD(n, i);
 
-        t = sm4_sbox[t & 0xff] |
-            sm4_sbox[(t >> 8) & 0xff] << 8 |
-            sm4_sbox[(t >> 16) & 0xff] << 16 |
-            sm4_sbox[(t >> 24) & 0xff] << 24;
+        t = SM4_SBOXWORD(t);
 
         CR_ST_WORD(d, i) ^= t ^ rol32(t, 2) ^ rol32(t, 10) ^ rol32(t, 18) ^
                             rol32(t, 24);
@@ -744,10 +741,7 @@ static void do_crypto_sm4ekey(uint64_t *rd, uint64_t *rn, uint64_t *rm)
             CR_ST_WORD(d, (i + 3) % 4) ^
             CR_ST_WORD(m, i);
 
-        t = sm4_sbox[t & 0xff] |
-            sm4_sbox[(t >> 8) & 0xff] << 8 |
-            sm4_sbox[(t >> 16) & 0xff] << 16 |
-            sm4_sbox[(t >> 24) & 0xff] << 24;
+        t = SM4_SBOXWORD(t);
 
         CR_ST_WORD(d, i) ^= t ^ rol32(t, 13) ^ rol32(t, 23);
     }
-- 
2.39.1

