Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0646F1B85
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 17:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346405AbjD1P2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 11:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346038AbjD1P2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 11:28:12 -0400
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE696199
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 08:27:45 -0700 (PDT)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.guest.codethink.co.uk)
        by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1psPON-005zz5-PZ; Fri, 28 Apr 2023 15:48:11 +0100
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org, richard.henderson@linaro.org
Subject: [PATCH v3 10/19] qemu/host-utils.h: Add clz and ctz functions for lower-bit integers
Date:   Fri, 28 Apr 2023 15:47:48 +0100
Message-Id: <20230428144757.57530-11-lawrence.hunter@codethink.co.uk>
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

From: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>

This is for use in the RISC-V vclz and vctz instructions (implemented in
proceeding commit).

Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/qemu/host-utils.h | 54 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/include/qemu/host-utils.h b/include/qemu/host-utils.h
index 3ce62bf4a56..d3b4dce6a93 100644
--- a/include/qemu/host-utils.h
+++ b/include/qemu/host-utils.h
@@ -107,6 +107,36 @@ static inline uint64_t muldiv64(uint64_t a, uint32_t b, uint32_t c)
 }
 #endif
 
+/**
+ * clz8 - count leading zeros in a 8-bit value.
+ * @val: The value to search
+ *
+ * Returns 8 if the value is zero.  Note that the GCC builtin is
+ * undefined if the value is zero.
+ *
+ * Note that the GCC builtin will upcast its argument to an `unsigned int`
+ * so this function subtracts off the number of prepended zeroes.
+ */
+static inline int clz8(uint8_t val)
+{
+    return val ? __builtin_clz(val) - 24 : 8;
+}
+
+/**
+ * clz16 - count leading zeros in a 16-bit value.
+ * @val: The value to search
+ *
+ * Returns 16 if the value is zero.  Note that the GCC builtin is
+ * undefined if the value is zero.
+ *
+ * Note that the GCC builtin will upcast its argument to an `unsigned int`
+ * so this function subtracts off the number of prepended zeroes.
+ */
+static inline int clz16(uint16_t val)
+{
+    return val ? __builtin_clz(val) - 16 : 16;
+}
+
 /**
  * clz32 - count leading zeros in a 32-bit value.
  * @val: The value to search
@@ -153,6 +183,30 @@ static inline int clo64(uint64_t val)
     return clz64(~val);
 }
 
+/**
+ * ctz8 - count trailing zeros in a 8-bit value.
+ * @val: The value to search
+ *
+ * Returns 8 if the value is zero.  Note that the GCC builtin is
+ * undefined if the value is zero.
+ */
+static inline int ctz8(uint8_t val)
+{
+    return val ? __builtin_ctz(val) : 8;
+}
+
+/**
+ * ctz16 - count trailing zeros in a 16-bit value.
+ * @val: The value to search
+ *
+ * Returns 16 if the value is zero.  Note that the GCC builtin is
+ * undefined if the value is zero.
+ */
+static inline int ctz16(uint16_t val)
+{
+    return val ? __builtin_ctz(val) : 16;
+}
+
 /**
  * ctz32 - count trailing zeros in a 32-bit value.
  * @val: The value to search
-- 
2.40.1

