Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05916E84F9
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbjDSWbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbjDSWa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:30:58 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48E87D91
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:30:23 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-38e3a1a07c8so265101b6e.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681943341; x=1684535341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8fg2apWNkO7XMTsfLYU3rTZlWorsx4wHesUuN9ZGrN4=;
        b=oZQY1fzcQ2RYxKCwReTTWy+GmZ/PBEP3SBF0kvBeLqQOWGkjrcZR4gyuCl4RxtgVzQ
         nwBHDOA23BM5M8iEvIVz5OvWo3hz1xbFuQ/2LM2VsYXsE7/RgRm/yDtBYZh15lSK5PSD
         1n7THk4d3gPqDeruBTROWbrT1tsn0do38RvTDvs14fht/9EstNXJmLuqtzYH4ng6xpoz
         usmQr5nl4eX+wZv36DeUk7p+OtUYYIut3jPir6TyJMoNO0kinVGloXgDzd8ZuBUtR1nD
         DM7M9Hdd0xjFRV9F2lkj7WKvRGmNTwXJTOk2yJjsqnH/+rpMwKS2k1RYgO9TUsqI9A1/
         mn+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681943341; x=1684535341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8fg2apWNkO7XMTsfLYU3rTZlWorsx4wHesUuN9ZGrN4=;
        b=gfWxfWQayX/uMfYUF2dyd5S75VA7LOk/akr7T8LwZsZo3GVqPzJ0Y1iWpgA32VFWuf
         HDAGZ35qiRF7dGhiUld8mAkP5EPkrRzbcBhftDv9rmY9Kfxn5WAb6uRyuR0eIhULWdlj
         mk44K8+7w+U07McTp0LDbmonVUcUq5bPegUUH2mDk9RFdYMgq5sJ1iiLReGsv0FfqPLx
         sCJNzSeCp2qAWoE30lBOkpC0KDTAUIuAZwpbZlQkKR1W5dThLVXOEB6jzjjqmo7Qn5Cc
         5RwIrA0aQqJ9oBblQep6ASJ5bzRyEb57aaGx+YFjmXErZvwTgTO5KyF2HwgGwq5Dkwoc
         o/hg==
X-Gm-Message-State: AAQBX9eFrQ3lgaRUjqOoQfHoqwKXZDIekjIAIFTDbdL6DDEhmXvmFi5x
        w9U7Q/NawsKK8hW8s0sZE48i53KGPQ+936kDEaA=
X-Google-Smtp-Source: AKy350bcbgE/EJ3Ej08OUUDHS562dStL1nY59dRLyQva3UBkO8qD2X/slMFNk57ZH7aSQKcUf51qPw==
X-Received: by 2002:a17:902:a504:b0:1a1:be45:9857 with SMTP id s4-20020a170902a50400b001a1be459857mr6646673plq.1.1681942754165;
        Wed, 19 Apr 2023 15:19:14 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:19:13 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Atish Patra <atishp@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 47/48] RISC-V: Add shared bounce buffer to support DBCN for CoVE Guest.
Date:   Wed, 19 Apr 2023 15:17:15 -0700
Message-Id: <20230419221716.3603068-48-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rajnesh Kanwal <rkanwal@rivosinc.com>

Early console buffer needs to be shared with the host for CoVE Guest.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/tty/serial/earlycon-riscv-sbi.c | 51 ++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/earlycon-riscv-sbi.c b/drivers/tty/serial/earlycon-riscv-sbi.c
index 311a4f8..9033cca 100644
--- a/drivers/tty/serial/earlycon-riscv-sbi.c
+++ b/drivers/tty/serial/earlycon-riscv-sbi.c
@@ -9,6 +9,14 @@
 #include <linux/init.h>
 #include <linux/serial_core.h>
 #include <asm/sbi.h>
+#include <asm/cove.h>
+#include <asm/covg_sbi.h>
+#include <linux/memblock.h>
+
+#ifdef CONFIG_RISCV_COVE_GUEST
+#define DBCN_BOUNCE_BUF_SIZE (PAGE_SIZE)
+static char dbcn_buf[DBCN_BOUNCE_BUF_SIZE] __aligned(PAGE_SIZE);
+#endif
 
 #ifdef CONFIG_RISCV_SBI_V01
 static void sbi_putc(struct uart_port *port, unsigned char c)
@@ -24,6 +32,33 @@ static void sbi_0_1_console_write(struct console *con,
 }
 #endif
 
+#ifdef CONFIG_RISCV_COVE_GUEST
+static void sbi_dbcn_console_write_cove(struct console *con, const char *s,
+					unsigned int n)
+{
+	phys_addr_t pa = __pa(dbcn_buf);
+	unsigned int off = 0;
+
+	while (off < n) {
+		const unsigned int rem = n - off;
+		const unsigned int size =
+			rem > DBCN_BOUNCE_BUF_SIZE ? DBCN_BOUNCE_BUF_SIZE : rem;
+
+		memcpy(dbcn_buf, &s[off], size);
+
+		sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE,
+#ifdef CONFIG_32BIT
+			  size, pa, (u64)pa >> 32,
+#else
+			  size, pa, 0,
+#endif
+			  0, 0, 0);
+
+		off += size;
+	}
+}
+#endif
+
 static void sbi_dbcn_console_write(struct console *con,
 				   const char *s, unsigned n)
 {
@@ -45,14 +80,26 @@ static int __init early_sbi_setup(struct earlycon_device *device,
 
 	/* TODO: Check for SBI debug console (DBCN) extension */
 	if ((sbi_spec_version >= sbi_mk_version(1, 0)) &&
-	    (sbi_probe_extension(SBI_EXT_DBCN) > 0))
+	    (sbi_probe_extension(SBI_EXT_DBCN) > 0)) {
+#ifdef CONFIG_RISCV_COVE_GUEST
+		if (is_cove_guest()) {
+			ret = sbi_covg_share_memory(__pa(dbcn_buf),
+						    DBCN_BOUNCE_BUF_SIZE);
+			if (ret)
+				return ret;
+
+			device->con->write = sbi_dbcn_console_write_cove;
+			return 0;
+		}
+#endif
 		device->con->write = sbi_dbcn_console_write;
-	else
+	} else {
 #ifdef CONFIG_RISCV_SBI_V01
 		device->con->write = sbi_0_1_console_write;
 #else
 		ret = -ENODEV;
 #endif
+	}
 
 	return ret;
 }
-- 
2.25.1

