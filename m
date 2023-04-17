Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664146E4A69
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 15:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjDQN7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 09:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjDQN66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 09:58:58 -0400
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F2861A3
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 06:58:51 -0700 (PDT)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.guest.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1poPNO-0034ER-PQ; Mon, 17 Apr 2023 14:58:38 +0100
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org
Subject: [PATCH v2 08/17] qemu/host-utils.h: Add clz and ctz functions for lower-bit integers
Date:   Mon, 17 Apr 2023 14:58:12 +0100
Message-Id: <20230417135821.609964-9-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230417135821.609964-1-lawrence.hunter@codethink.co.uk>
References: <20230417135821.609964-1-lawrence.hunter@codethink.co.uk>
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
2.40.0

