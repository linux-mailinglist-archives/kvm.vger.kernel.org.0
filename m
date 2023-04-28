Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721346F1B92
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 17:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346042AbjD1PaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 11:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346081AbjD1PaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 11:30:12 -0400
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CB41BDC
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 08:30:11 -0700 (PDT)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.guest.codethink.co.uk)
        by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1psPOM-005zz5-Je; Fri, 28 Apr 2023 15:48:10 +0100
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org, richard.henderson@linaro.org
Subject: [PATCH v3 08/19] qemu/bitops.h: Limit rotate amounts
Date:   Fri, 28 Apr 2023 15:47:46 +0100
Message-Id: <20230428144757.57530-9-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230428144757.57530-1-lawrence.hunter@codethink.co.uk>
References: <20230428144757.57530-1-lawrence.hunter@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dickon Hood <dickon.hood@codethink.co.uk>

Rotates have been fixed up to only allow for reasonable rotate amounts
(ie, no rotates >7 on an 8b value etc.)  This fixes a problem with riscv
vector rotate instructions.

Signed-off-by: Dickon Hood <dickon.hood@codethink.co.uk>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/qemu/bitops.h | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/qemu/bitops.h b/include/qemu/bitops.h
index 03213ce952c..c443995b3ba 100644
--- a/include/qemu/bitops.h
+++ b/include/qemu/bitops.h
@@ -218,7 +218,8 @@ static inline unsigned long find_first_zero_bit(const unsigned long *addr,
  */
 static inline uint8_t rol8(uint8_t word, unsigned int shift)
 {
-    return (word << shift) | (word >> ((8 - shift) & 7));
+    shift &= 7;
+    return (word << shift) | (word >> (8 - shift));
 }
 
 /**
@@ -228,7 +229,8 @@ static inline uint8_t rol8(uint8_t word, unsigned int shift)
  */
 static inline uint8_t ror8(uint8_t word, unsigned int shift)
 {
-    return (word >> shift) | (word << ((8 - shift) & 7));
+    shift &= 7;
+    return (word >> shift) | (word << (8 - shift));
 }
 
 /**
@@ -238,7 +240,8 @@ static inline uint8_t ror8(uint8_t word, unsigned int shift)
  */
 static inline uint16_t rol16(uint16_t word, unsigned int shift)
 {
-    return (word << shift) | (word >> ((16 - shift) & 15));
+    shift &= 15;
+    return (word << shift) | (word >> (16 - shift));
 }
 
 /**
@@ -248,7 +251,8 @@ static inline uint16_t rol16(uint16_t word, unsigned int shift)
  */
 static inline uint16_t ror16(uint16_t word, unsigned int shift)
 {
-    return (word >> shift) | (word << ((16 - shift) & 15));
+    shift &= 15;
+    return (word >> shift) | (word << (16 - shift));
 }
 
 /**
@@ -258,7 +262,8 @@ static inline uint16_t ror16(uint16_t word, unsigned int shift)
  */
 static inline uint32_t rol32(uint32_t word, unsigned int shift)
 {
-    return (word << shift) | (word >> ((32 - shift) & 31));
+    shift &= 31;
+    return (word << shift) | (word >> (32 - shift));
 }
 
 /**
@@ -268,7 +273,8 @@ static inline uint32_t rol32(uint32_t word, unsigned int shift)
  */
 static inline uint32_t ror32(uint32_t word, unsigned int shift)
 {
-    return (word >> shift) | (word << ((32 - shift) & 31));
+    shift &= 31;
+    return (word >> shift) | (word << (32 - shift));
 }
 
 /**
@@ -278,7 +284,8 @@ static inline uint32_t ror32(uint32_t word, unsigned int shift)
  */
 static inline uint64_t rol64(uint64_t word, unsigned int shift)
 {
-    return (word << shift) | (word >> ((64 - shift) & 63));
+    shift &= 63;
+    return (word << shift) | (word >> (64 - shift));
 }
 
 /**
@@ -288,7 +295,8 @@ static inline uint64_t rol64(uint64_t word, unsigned int shift)
  */
 static inline uint64_t ror64(uint64_t word, unsigned int shift)
 {
-    return (word >> shift) | (word << ((64 - shift) & 63));
+    shift &= 63;
+    return (word >> shift) | (word << (64 - shift));
 }
 
 /**
-- 
2.40.1

