Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3C67C022C
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 19:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbjJJRGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 13:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbjJJRFl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 13:05:41 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61814FC
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 10:05:36 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1c60f1a2652so420815ad.0
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 10:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1696957535; x=1697562335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XoCkBvDoaE+G9yGkJwlCtJkOL/TuRqipkz8zh1jvWHI=;
        b=AA2jQLm6/yeH/yYoMJAer6K2L8kTm74KVZ2ig382ezZ5hfVEIfthok6IseJqgZoOlh
         vWfEIhzBiGXl3yYiJcNbH4JvQrrLKeqB6xJgDDKho5pYjvnH2TbGu/Ou7ADp/My5B6bc
         1/Ere0xGHWsk9TFKbg03APmOpAdYBrE2L29GhruQ9gyvWfjZ4tl6ipieikZobQb/6P4O
         UV4bGnn6r7nn7E3xlaEzqJfcK5dGEnbRDxiO4MCqZS5gEPECi7TMkILDhBlm3CVGIMMg
         KJxmn91UM4Ptg96wP7F6dyOMQDMA1pqTZFpTMYQxhPdyuPN7bLqOcHaOlG9PdDlPCHZp
         IG/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696957535; x=1697562335;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XoCkBvDoaE+G9yGkJwlCtJkOL/TuRqipkz8zh1jvWHI=;
        b=Tpeh1ox2Xgbty5CjkEq/ERUTjKr+O4qEbZUTCa9hdA05tN0SS8k1vdcURmSM3WZ7r1
         BP+iiIEAiUHGxpgiYBqWDPXyf3b7KaKaXJUxL++JKZxj/uTNJDq57mr+60j/W0Ce28HD
         /Y/wsfF2/jWdIPlD7U2Ke1PUTWwJ0IBKAiDsznJ9WBGIKEMfW+tDw28p9h6i4BP5jh72
         JDLKg/izsCOFwCt+t/PdOByve3NRlyPXvMu1wfcp0NRLhe9QLcgMY4IjCD6mHApLxjjf
         sx0ZrU8U5zIRAXEf4fAoGUbJHQEo0n1nlHybhMRZ/KLufPNakH3QysPSJjuF0HR+7BMW
         37gA==
X-Gm-Message-State: AOJu0YxR1OcaAh6bo0L7qNvrNTlRtPEpnMR0anKEys8YZ4CMta9knRR+
        XK8ytHV6ubE9mp9aofgYjKtNjA==
X-Google-Smtp-Source: AGHT+IHpTSgdyOa/WMmXoVeNp80pjqgJQqPCX1bVN2+pKlqZykfXt/hGxysni37Tvg40ZjWZcGGrLw==
X-Received: by 2002:a17:902:d2ca:b0:1c3:76c4:7242 with SMTP id n10-20020a170902d2ca00b001c376c47242mr26123429plc.22.1696957535339;
        Tue, 10 Oct 2023 10:05:35 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id w19-20020a1709027b9300b001b89536974bsm11979868pll.202.2023.10.10.10.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 10:05:34 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 4/6] tty/serial: Add RISC-V SBI debug console based earlycon
Date:   Tue, 10 Oct 2023 22:35:01 +0530
Message-Id: <20231010170503.657189-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231010170503.657189-1-apatel@ventanamicro.com>
References: <20231010170503.657189-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We extend the existing RISC-V SBI earlycon support to use the new
RISC-V SBI debug console extension.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 drivers/tty/serial/Kconfig              |  2 +-
 drivers/tty/serial/earlycon-riscv-sbi.c | 35 ++++++++++++++++++++++---
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index bdc568a4ab66..cec46091a716 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -87,7 +87,7 @@ config SERIAL_EARLYCON_SEMIHOST
 
 config SERIAL_EARLYCON_RISCV_SBI
 	bool "Early console using RISC-V SBI"
-	depends on RISCV_SBI_V01
+	depends on RISCV_SBI
 	select SERIAL_CORE
 	select SERIAL_CORE_CONSOLE
 	select SERIAL_EARLYCON
diff --git a/drivers/tty/serial/earlycon-riscv-sbi.c b/drivers/tty/serial/earlycon-riscv-sbi.c
index 27afb0b74ea7..b1da34e8d8cd 100644
--- a/drivers/tty/serial/earlycon-riscv-sbi.c
+++ b/drivers/tty/serial/earlycon-riscv-sbi.c
@@ -10,22 +10,49 @@
 #include <linux/serial_core.h>
 #include <asm/sbi.h>
 
+#ifdef CONFIG_RISCV_SBI_V01
 static void sbi_putc(struct uart_port *port, unsigned char c)
 {
 	sbi_console_putchar(c);
 }
 
-static void sbi_console_write(struct console *con,
-			      const char *s, unsigned n)
+static void sbi_0_1_console_write(struct console *con,
+				  const char *s, unsigned int n)
 {
 	struct earlycon_device *dev = con->data;
 	uart_console_write(&dev->port, s, n, sbi_putc);
 }
+#endif
+
+static void sbi_dbcn_console_write(struct console *con,
+				   const char *s, unsigned int n)
+{
+	phys_addr_t pa = __pa(s);
+
+	sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE,
+#ifdef CONFIG_32BIT
+		  n, pa, (u64)pa >> 32,
+#else
+		  n, pa, 0,
+#endif
+		  0, 0, 0);
+}
 
 static int __init early_sbi_setup(struct earlycon_device *device,
 				  const char *opt)
 {
-	device->con->write = sbi_console_write;
-	return 0;
+	int ret = 0;
+
+	if ((sbi_spec_version >= sbi_mk_version(2, 0)) &&
+	    (sbi_probe_extension(SBI_EXT_DBCN) > 0))
+		device->con->write = sbi_dbcn_console_write;
+	else
+#ifdef CONFIG_RISCV_SBI_V01
+		device->con->write = sbi_0_1_console_write;
+#else
+		ret = -ENODEV;
+#endif
+
+	return ret;
 }
 EARLYCON_DECLARE(sbi, early_sbi_setup);
-- 
2.34.1

