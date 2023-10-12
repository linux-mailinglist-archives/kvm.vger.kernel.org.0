Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4397C647B
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 07:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347091AbjJLFQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 01:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377455AbjJLFQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 01:16:14 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AD8D61
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 22:15:51 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1c62d61dc96so4450235ad.0
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 22:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697087750; x=1697692550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9VumssqyPhV2g3eQM7/n//T8x0MORKj84YM3EuzCDgk=;
        b=PpBMcsLo0YLbCwEhfTkGiYXB/ljqeq5i+tc7tZeUFN3xxaV5pb+yuY+N93pff7q3g6
         FfISoZsgmYzxMKByO3sUxAzct2Tj5UzuP0p4PKWoD58YQ9Fygeqq0ntTRobM/dWnx62Z
         xKZig/1H5Zeg/jLhGBGLjtbpO266i7dzuetXzpwTBnek1W7p9WdpXj0c7av7o/xIC12F
         uGg4xj9jO3fQFgzAHSHWJ2KSIbic1tDTJzduPiVq0AxYHZG1Fo/fG1QXGYpbfeh2UNMr
         MwWoSvTxTgRIcvgP07aE8Vh4/BSNaDVFbejuJ0JnRAa/GLu6OhpAt/Ts7YWI1rsiObxS
         3PEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697087750; x=1697692550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9VumssqyPhV2g3eQM7/n//T8x0MORKj84YM3EuzCDgk=;
        b=k8MTQQZZE4g/k3FSb1kxA+VVTR9ULA+xFRSSi7Mgss9zIbtK5ogatmItsOvcq2bUZv
         ipZ0lFbELb+KYdbLWD2dYnJskYaO3wYNoXAgnh48o5UPuXSUj9dm47WUTaiXtZzZrDhV
         MAQZaKZXFIlAoxOZ4mhBaQjjZqGRb3Dk2YbJEbWoo8pCFBUqtmU7dpbeci7Gc56QCahR
         J6A13NVXkw0tF5KwyOTToueIrHCj7ZtBjaTuvx1ueT7ekoMmwlQjbgSIKqhNOFBk7hWg
         hTpSfxUhksM31zXPItvTlNyRvRQLmC9XtCcv3Sz603c+1YkfGTsxwgkXoEgKfnoxDo9f
         OAHQ==
X-Gm-Message-State: AOJu0YwwpB+zkK8hi09um1UX/Ohn0eygmO0hLFdetAiXHkVqAwsSh+fr
        sycdqZqNyK74R74ejyCZXdcqtA==
X-Google-Smtp-Source: AGHT+IFQ1W43pn4VQeKIkawEacDc40dCj7u4jClbhdGq+OcNM4Reual0u2XRPGbMPIHdZ7ZptLiBeQ==
X-Received: by 2002:a17:903:2341:b0:1c7:1f3f:b6dc with SMTP id c1-20020a170903234100b001c71f3fb6dcmr23793872plh.11.1697087750172;
        Wed, 11 Oct 2023 22:15:50 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([106.51.83.242])
        by smtp.gmail.com with ESMTPSA id s18-20020a17090330d200b001b9d95945afsm851309plc.155.2023.10.11.22.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 22:15:49 -0700 (PDT)
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
        linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>,
        Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 7/8] tty: Add SBI debug console support to HVC SBI driver
Date:   Thu, 12 Oct 2023 10:45:08 +0530
Message-Id: <20231012051509.738750-8-apatel@ventanamicro.com>
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

From: Atish Patra <atishp@rivosinc.com>

RISC-V SBI specification supports advanced debug console
support via SBI DBCN extension.

Extend the HVC SBI driver to support it.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 drivers/tty/hvc/Kconfig         |  2 +-
 drivers/tty/hvc/hvc_riscv_sbi.c | 76 ++++++++++++++++++++++++++++++---
 2 files changed, 70 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/hvc/Kconfig b/drivers/tty/hvc/Kconfig
index 4f9264d005c0..6e05c5c7bca1 100644
--- a/drivers/tty/hvc/Kconfig
+++ b/drivers/tty/hvc/Kconfig
@@ -108,7 +108,7 @@ config HVC_DCC_SERIALIZE_SMP
 
 config HVC_RISCV_SBI
 	bool "RISC-V SBI console support"
-	depends on RISCV_SBI_V01
+	depends on RISCV_SBI
 	select HVC_DRIVER
 	help
 	  This enables support for console output via RISC-V SBI calls, which
diff --git a/drivers/tty/hvc/hvc_riscv_sbi.c b/drivers/tty/hvc/hvc_riscv_sbi.c
index 31f53fa77e4a..da318d7f55c5 100644
--- a/drivers/tty/hvc/hvc_riscv_sbi.c
+++ b/drivers/tty/hvc/hvc_riscv_sbi.c
@@ -39,21 +39,83 @@ static int hvc_sbi_tty_get(uint32_t vtermno, char *buf, int count)
 	return i;
 }
 
-static const struct hv_ops hvc_sbi_ops = {
+static const struct hv_ops hvc_sbi_v01_ops = {
 	.get_chars = hvc_sbi_tty_get,
 	.put_chars = hvc_sbi_tty_put,
 };
 
-static int __init hvc_sbi_init(void)
+static int hvc_sbi_dbcn_tty_put(uint32_t vtermno, const char *buf, int count)
 {
-	return PTR_ERR_OR_ZERO(hvc_alloc(0, 0, &hvc_sbi_ops, 16));
+	phys_addr_t pa;
+	struct sbiret ret;
+
+	if (is_vmalloc_addr(buf))
+		pa = page_to_phys(vmalloc_to_page(buf)) + offset_in_page(buf);
+	else
+		pa = __pa(buf);
+
+	if (IS_ENABLED(CONFIG_32BIT))
+		ret = sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE,
+				count, lower_32_bits(pa), upper_32_bits(pa),
+				0, 0, 0);
+	else
+		ret = sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE,
+				count, pa, 0, 0, 0, 0);
+	if (ret.error)
+		return 0;
+
+	return count;
 }
-device_initcall(hvc_sbi_init);
 
-static int __init hvc_sbi_console_init(void)
+static int hvc_sbi_dbcn_tty_get(uint32_t vtermno, char *buf, int count)
 {
-	hvc_instantiate(0, 0, &hvc_sbi_ops);
+	phys_addr_t pa;
+	struct sbiret ret;
+
+	if (is_vmalloc_addr(buf))
+		pa = page_to_phys(vmalloc_to_page(buf)) + offset_in_page(buf);
+	else
+		pa = __pa(buf);
+
+	if (IS_ENABLED(CONFIG_32BIT))
+		ret = sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_READ,
+				count, lower_32_bits(pa), upper_32_bits(pa),
+				0, 0, 0);
+	else
+		ret = sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_READ,
+				count, pa, 0, 0, 0, 0);
+	if (ret.error)
+		return 0;
+
+	return ret.value;
+}
+
+static const struct hv_ops hvc_sbi_dbcn_ops = {
+	.put_chars = hvc_sbi_dbcn_tty_put,
+	.get_chars = hvc_sbi_dbcn_tty_get,
+};
+
+static int __init hvc_sbi_init(void)
+{
+	int err;
+
+	if ((sbi_spec_version >= sbi_mk_version(2, 0)) &&
+	    (sbi_probe_extension(SBI_EXT_DBCN) > 0)) {
+		err = PTR_ERR_OR_ZERO(hvc_alloc(0, 0, &hvc_sbi_dbcn_ops, 16));
+		if (err)
+			return err;
+		hvc_instantiate(0, 0, &hvc_sbi_dbcn_ops);
+	} else {
+		if (IS_ENABLED(CONFIG_RISCV_SBI_V01)) {
+			err = PTR_ERR_OR_ZERO(hvc_alloc(0, 0, &hvc_sbi_v01_ops, 16));
+			if (err)
+				return err;
+			hvc_instantiate(0, 0, &hvc_sbi_v01_ops);
+		} else {
+			return -ENODEV;
+		}
+	}
 
 	return 0;
 }
-console_initcall(hvc_sbi_console_init);
+device_initcall(hvc_sbi_init);
-- 
2.34.1

