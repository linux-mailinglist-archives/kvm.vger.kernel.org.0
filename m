Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13B073FB63
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 13:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjF0Lvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 07:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjF0Lvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 07:51:42 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252A92727
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 04:51:41 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-98377c5d53eso540099666b.0
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 04:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687866699; x=1690458699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5EM+qSWWOslftV8HcBXpILD27b+3+W5mkalItnU32xI=;
        b=zK/wO1TEMHYu1s8XH1PAIG4ggr3gqj0hxpHfpqqesgDccWWASPBRBwTqjxvaLS7OM/
         RhMBJrthSW8x7Vdiz/3rk8ib0FJBohtxOdjRkOHHxTNXzMH+9mJodaN5iBmJDghhQe6C
         aVf9y97NdoZtReSmqCSzF/SPOBoo2Rjd66wYrVJqBLCSDW5Y7Tb/1uD2lswOQV6Uqs7r
         jnrJYC9q6Z3xfVRXCLZ6b7P1d9qfr1IAeVNRqpWnYkEGqA9L6MTYjxDAlFpbQ2oSEOZ6
         On/49dj0L5K/TeWwyPNO6VoamET9qq1TBnwFBHI8G5Y7JBnd3tCu6O2RlijPXj4RAXqe
         gaEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687866699; x=1690458699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5EM+qSWWOslftV8HcBXpILD27b+3+W5mkalItnU32xI=;
        b=Zm1nrLyQ+s7Paq08mwK896UPHRUYuPUVcZz++pu7O41fdDTQK5YVG9f7scmSe2UXku
         mlDJP6ALm1SH8lxbYOrVqDue+wQKLJlnUmuDIUEbpYhq2W0hETv7zKmQEmwUgJxMVtZr
         Nsc3ydGyPJK+N/XvTJuL9sYWg1fFBPQKhfpTVZlocQq6psnbKrEy+W6ncpmC12FiCS4v
         nWIUhgG4o9/9B4ap2k2+/OyEzZIj3V0mIdIZ6sJl0eLzIx6wmWUDk4A3l1m04l/hpht7
         ftvQPJQP840QQvQasEv4AR/+kRP3wLf894szfxrDLhwVwoRFXXh3iE1DzOCbuEjyLKzu
         y/eA==
X-Gm-Message-State: AC+VfDwprJPpoCm787ZdC9H9MhUKb8ktyYTU90LkwENygbERisXA71yI
        gjXzYqTiECWWzBAWbiNe4sRggA==
X-Google-Smtp-Source: ACHHUZ6IqFkk/UBT9Y/2spa5T+pGGl9y+Nj7mw+jrVqROYCX1zp6Lg0qSp29vM1gcaCZRbjsPfXHcA==
X-Received: by 2002:a17:906:684c:b0:98e:4c96:6e18 with SMTP id a12-20020a170906684c00b0098e4c966e18mr4150187ejs.5.1687866699521;
        Tue, 27 Jun 2023 04:51:39 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.199.204])
        by smtp.gmail.com with ESMTPSA id ce23-20020a170906b25700b009920f18a5f0sm791874ejb.185.2023.06.27.04.51.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Jun 2023 04:51:39 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v3 2/6] target/ppc: Reorder #ifdef'ry in kvm_ppc.h
Date:   Tue, 27 Jun 2023 13:51:20 +0200
Message-Id: <20230627115124.19632-3-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230627115124.19632-1-philmd@linaro.org>
References: <20230627115124.19632-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Keep a single if/else/endif block checking CONFIG_KVM.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/kvm_ppc.h | 62 ++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 34 deletions(-)

diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index 2e395416f0..49954a300b 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -93,7 +93,34 @@ void kvmppc_set_reg_tb_offset(PowerPCCPU *cpu, int64_t tb_offset);
 
 int kvm_handle_nmi(PowerPCCPU *cpu, struct kvm_run *run);
 
-#else
+#define kvmppc_eieio() \
+    do {                                          \
+        if (kvm_enabled()) {                          \
+            asm volatile("eieio" : : : "memory"); \
+        } \
+    } while (0)
+
+/* Store data cache blocks back to memory */
+static inline void kvmppc_dcbst_range(PowerPCCPU *cpu, uint8_t *addr, int len)
+{
+    uint8_t *p;
+
+    for (p = addr; p < addr + len; p += cpu->env.dcache_line_size) {
+        asm volatile("dcbst 0,%0" : : "r"(p) : "memory");
+    }
+}
+
+/* Invalidate instruction cache blocks */
+static inline void kvmppc_icbi_range(PowerPCCPU *cpu, uint8_t *addr, int len)
+{
+    uint8_t *p;
+
+    for (p = addr; p < addr + len; p += cpu->env.icache_line_size) {
+        asm volatile("icbi 0,%0" : : "r"(p));
+    }
+}
+
+#else /* !CONFIG_KVM */
 
 static inline uint32_t kvmppc_get_tbfreq(void)
 {
@@ -440,10 +467,6 @@ static inline bool kvmppc_pvr_workaround_required(PowerPCCPU *cpu)
     return false;
 }
 
-#endif
-
-#ifndef CONFIG_KVM
-
 #define kvmppc_eieio() do { } while (0)
 
 static inline void kvmppc_dcbst_range(PowerPCCPU *cpu, uint8_t *addr, int len)
@@ -454,35 +477,6 @@ static inline void kvmppc_icbi_range(PowerPCCPU *cpu, uint8_t *addr, int len)
 {
 }
 
-#else   /* CONFIG_KVM */
-
-#define kvmppc_eieio() \
-    do {                                          \
-        if (kvm_enabled()) {                          \
-            asm volatile("eieio" : : : "memory"); \
-        } \
-    } while (0)
-
-/* Store data cache blocks back to memory */
-static inline void kvmppc_dcbst_range(PowerPCCPU *cpu, uint8_t *addr, int len)
-{
-    uint8_t *p;
-
-    for (p = addr; p < addr + len; p += cpu->env.dcache_line_size) {
-        asm volatile("dcbst 0,%0" : : "r"(p) : "memory");
-    }
-}
-
-/* Invalidate instruction cache blocks */
-static inline void kvmppc_icbi_range(PowerPCCPU *cpu, uint8_t *addr, int len)
-{
-    uint8_t *p;
-
-    for (p = addr; p < addr + len; p += cpu->env.icache_line_size) {
-        asm volatile("icbi 0,%0" : : "r"(p));
-    }
-}
-
 #endif  /* CONFIG_KVM */
 
 #endif /* KVM_PPC_H */
-- 
2.38.1

