Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAE57C6479
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 07:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbjJLFQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 01:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377308AbjJLFQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 01:16:11 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84716D44
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 22:15:46 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1c9b70b9656so4365805ad.1
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 22:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697087745; x=1697692545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/KVKi7QKmfPZrGchNrI6Bys6/KZCng6FE4wZxaod/J0=;
        b=DZaVzU0+AyzRJc3ufgtqqgJlOGxXQ3xades2Uu+jUbKqS15LvNRzis3rHmFBCFSNRG
         6uxFbGimWp8FuwvYU5DZwy6hQG8VkS7CRwUWhIV7lv7/HhjQehL71w6bDjuPq4qVKYmY
         dquOpgiI3jkqDo9iQLKxKKuxKyc8CbTLhldvXQxnrjgOra/z5KK0U1HP26VFl9ofujqH
         3EEcGu4sm/cF8k3mpcRVmjYhOe9qrz2vn1U9iX8lbCvj1M8DEW2xo7qO9aJWLvqm3qmW
         Wnk2XyWAqAblZoUQ3ZkzbQvrAHVeaD6yO9pBCoUxIOfyNbFOX0Rplf5j4S4VmRDW7AAb
         S7hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697087745; x=1697692545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/KVKi7QKmfPZrGchNrI6Bys6/KZCng6FE4wZxaod/J0=;
        b=NMhIEdB1hXf32DSG33Sjs5ocnDOOcuVALuUJXHVO8m828FG4d+cMFq9Ql4qcXLOsiN
         KWw6Pm32GGRBu5OkueL5HZMcST8FRjwVEhM1YiVMAf059PMI3VyWSnoyme7iiGF7JLNq
         5KqkIkXG0512IhA7xXxrcaF2D2SQt/xCALX+I59d9zuk0WFZcyZkv6husRRAjZhLbi8m
         E06FPLWEVq5PFELOXSr6M6B3mgg7Cb5ZFA6ETPU1Hs5rm+6+31ykv6gzcKu+NTyGV3zW
         FVtQaf2Xmfymzaz05UaK6Th6/3ACL5AHo419dwvKjw9/eP1A7T/SmwDxyI2JWTLsdapk
         P/KQ==
X-Gm-Message-State: AOJu0YzGZNp36AK3gAQxuzPHslEZbqYiZeZmN6gGDqh8CDsaGrlmBrCu
        +VAAVxf0VpTm+3jUwQwyPdYA1Q==
X-Google-Smtp-Source: AGHT+IGQA5WgnUWZWzG9GzMA7WhXboUt0Cn4w+hL60tDRhhBnvH97ndWcYP/2d/cQ1fXpGrnegy9iQ==
X-Received: by 2002:a17:903:278e:b0:1c9:dc52:9d69 with SMTP id jw14-20020a170903278e00b001c9dc529d69mr1250864plb.64.1697087745576;
        Wed, 11 Oct 2023 22:15:45 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([106.51.83.242])
        by smtp.gmail.com with ESMTPSA id s18-20020a17090330d200b001b9d95945afsm851309plc.155.2023.10.11.22.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 22:15:45 -0700 (PDT)
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
Subject: [PATCH v2 6/8] tty/serial: Add RISC-V SBI debug console based earlycon
Date:   Thu, 12 Oct 2023 10:45:07 +0530
Message-Id: <20231012051509.738750-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231012051509.738750-1-apatel@ventanamicro.com>
References: <20231012051509.738750-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/tty/serial/earlycon-riscv-sbi.c | 32 +++++++++++++++++++++----
 2 files changed, 29 insertions(+), 5 deletions(-)

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
index 27afb0b74ea7..c21cdef254e7 100644
--- a/drivers/tty/serial/earlycon-riscv-sbi.c
+++ b/drivers/tty/serial/earlycon-riscv-sbi.c
@@ -15,17 +15,41 @@ static void sbi_putc(struct uart_port *port, unsigned char c)
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
 
+static void sbi_dbcn_console_write(struct console *con,
+				   const char *s, unsigned int n)
+{
+	phys_addr_t pa = __pa(s);
+
+	if (IS_ENABLED(CONFIG_32BIT))
+		sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE,
+			  n, lower_32_bits(pa), upper_32_bits(pa), 0, 0, 0);
+	else
+		sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE,
+			  n, pa, 0, 0, 0, 0);
+}
+
 static int __init early_sbi_setup(struct earlycon_device *device,
 				  const char *opt)
 {
-	device->con->write = sbi_console_write;
-	return 0;
+	int ret = 0;
+
+	if ((sbi_spec_version >= sbi_mk_version(2, 0)) &&
+	    (sbi_probe_extension(SBI_EXT_DBCN) > 0)) {
+		device->con->write = sbi_dbcn_console_write;
+	} else {
+		if (IS_ENABLED(CONFIG_RISCV_SBI_V01))
+			device->con->write = sbi_0_1_console_write;
+		else
+			ret = -ENODEV;
+	}
+
+	return ret;
 }
 EARLYCON_DECLARE(sbi, early_sbi_setup);
-- 
2.34.1

