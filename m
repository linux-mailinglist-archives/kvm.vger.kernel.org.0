Return-Path: <kvm+bounces-33382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B6309EA74F
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 05:49:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E66D1884C31
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 04:49:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6479C227570;
	Tue, 10 Dec 2024 04:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="DX1D2JpL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BC8226172
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 04:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806110; cv=none; b=MqxozBaGt5zNSedTyL+U74BdGlPmuxBzQw5UjeALlsFdHv/55/GijlTdly9oNZ/yRRxP/ESYb735pJE7wPVzEF/AxQA976f1stelolmOmHJcrvp1ErOl4gSr7EG6dxwsWbSYQhBK04O3glGsUPdJxLOiTedWwIBqWazdtgSLNf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806110; c=relaxed/simple;
	bh=9K7NrVzrbk5zz8fArku3rhqwGcmFNqaR7Yk2Id/TbxM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uW7BkyvdlnipPXgIhG+RCiacUnEwwpKmw21I3N2C2S4bN25GbXFOXGuE421LvPetDZb2wEsnTG60h6/24UBHkNoyuWql7B2yAXchKiCK3tUJOzXijKCVK5lxTwpufY8OulyRHAiIc4fHrPtj+ZUtOZEJ53c4eT4FfUAppIb5P5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=DX1D2JpL; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a761a622dcso32916565ab.0
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 20:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1733806107; x=1734410907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yRbGcOGIFedl5zXM/s8LtJtUrXe3GqVVa7RjCBtA0DA=;
        b=DX1D2JpLkwHdGALRrxs6+egZAICy7LCZWbethDZC6H6FxCqy2ajs0dhJT7XEkJeLuf
         vD9Q/FPQxaaEx8XSdQXtY2k1OiUiUgWUr8tIkH55EFl8jMy/5JpiNEnbXpZ2rw1r0250
         lNKdK5ETDRXYJ5+X5wmnol417Hxt2/MXsnXow3uigCy1U7t+sbfsVdsIM0Aw859ZQt4Y
         4GYzyl7h1tWcCuVYQNjL5dBHxnnpD2TCG+Q/BYpe079q+Mxulv7yFfG/23k6Ygo/kQUM
         gPwZlPx8zFjkpzua7rLdFTV4+vRIoYem9Q875E28aP3GS9ayiOAy4yswMRW9GP3HCbpA
         ODsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733806107; x=1734410907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yRbGcOGIFedl5zXM/s8LtJtUrXe3GqVVa7RjCBtA0DA=;
        b=ErxlIZpvXiRoRvUfAnhuH3GxZ5Xxbv/V497nverdznbC/I8JWGWibpPh9U24y9Vj5S
         okJBhRO8PBqRk1BH4vhDo+8e9DVUSGe6tgnYs637ZwvaUl6ypLhjvJDijgxbC7xfsQJy
         Onr3xv9o32lVRqateqNxi78Xmord00/e2U+5O1Gn5NMtgiwMVsvidFOQO6TdsASOKDfN
         nGimAxyYOk7twiJsCDzzlQJnqKiUQeN5AtAxo7jvLKlAL5tsx7tF3Mrqfs5Ve8MK5pCm
         qTi5C0MmZXYldAyJGRdlOIS9PxNoUKuCFJtvhRioNEN0R589OMnfhe4VHsdj5bgZ5Ptl
         J9Qw==
X-Gm-Message-State: AOJu0Ywey3V7gIGseES58dbEh5QovItlqPwharerRJtMMqTruTTgQ/46
	ikOWj9htybzFCvvNJl1ZkRLY99WcpGmjLhH+/BuRMwnCa6IaQq1RxRpXh+UXnL4F9h0Z3Mi/nPr
	DZUSEOEMcCdm2093+t4JvbNqaO0gwQtdiB66uaEqouI2n7CcbXQxfeQQ45F4U5MfISZ4l7ElqWb
	40YT+Nvejw33Oo+CRsbd0gek9q+qPuHLQaz9Q4jTG/
X-Gm-Gg: ASbGncs011EaNBL6ldFriy5fLMv5TJSmHMvZ4EoDToEUyvGjVBWX5HWSPnjnu4xJHx8
	s0SXLbkcJPyLru/jmfSDwutqfCPssuw6F8xjsVr3V6RZsbyGIbyK03neEdgcIo3dcavkv7WXl2L
	zL6eS+NEtwoZ6WyaFtf5YyTmc/I469LfcaYvmpMLyMMN6zT38n7+9ZQkpB2/bcS2Bl5tLvhyAa2
	SxFkxJp9hZ2UVXfTavbX4HdFLWg4vi16a9hd0PlEZhkDViFdOHOPOxERTvJYBPOgepFZyVA+Tyy
	ImElGkDGF8I3s2ONVM/B4TPJg9Y0Y3g=
X-Google-Smtp-Source: AGHT+IGnd/3/3HSUcD1YzxrcNY1JRIT/2Z/946oOLXWvWjdVeJH2tugeoG8Ni1oFCB96f2hWFIQu+g==
X-Received: by 2002:a05:6e02:12c3:b0:3a7:1a65:2fbd with SMTP id e9e14a558f8ab-3a9dbb2693bmr31803395ab.17.1733806106962;
        Mon, 09 Dec 2024 20:48:26 -0800 (PST)
Received: from sholland-0826.internal.sifive.com ([147.124.94.167])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a9c9da809dsm17022405ab.4.2024.12.09.20.48.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Dec 2024 20:48:26 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: kvm@vger.kernel.org
Cc: Samuel Holland <samuel.holland@sifive.com>
Subject: [kvm-unit-tests PATCH 3/3] riscv: Support UARTs with different I/O widths
Date: Mon,  9 Dec 2024 22:44:42 -0600
Message-Id: <20241210044442.91736-4-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241210044442.91736-1-samuel.holland@sifive.com>
References: <20241210044442.91736-1-samuel.holland@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Integration of ns16550-compatible UARTs is often done with 16 or 32-bit wide
registers. Add support for these using the standard DT properties.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---
 lib/riscv/io.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/lib/riscv/io.c b/lib/riscv/io.c
index 8d684ccd..011b5b1d 100644
--- a/lib/riscv/io.c
+++ b/lib/riscv/io.c
@@ -25,8 +25,34 @@
  */
 #define UART_EARLY_BASE ((u8 *)(unsigned long)CONFIG_UART_EARLY_BASE)
 static volatile u8 *uart0_base = UART_EARLY_BASE;
+static u32 uart0_reg_shift = 1;
+static u32 uart0_reg_width = 1;
 static struct spinlock uart_lock;
 
+static u32 uart0_read(u32 num)
+{
+	u32 offset = num << uart0_reg_shift;
+
+	if (uart0_reg_width == 1)
+		return readb(uart0_base + offset);
+	else if (uart0_reg_width == 2)
+		return readw(uart0_base + offset);
+	else
+		return readl(uart0_base + offset);
+}
+
+static void uart0_write(u32 num, u32 val)
+{
+	u32 offset = num << uart0_reg_shift;
+
+	if (uart0_reg_width == 1)
+		writeb(val, uart0_base + offset);
+	else if (uart0_reg_width == 2)
+		writew(val, uart0_base + offset);
+	else
+		writel(val, uart0_base + offset);
+}
+
 static void uart0_init_fdt(void)
 {
 	const char *compatible[] = {"ns16550a"};
@@ -50,6 +76,17 @@ static void uart0_init_fdt(void)
 			abort();
 		}
 	} else {
+		const fdt32_t *val;
+		int len;
+
+		val = fdt_getprop(dt_fdt(), ret, "reg-shift", &len);
+		if (len == sizeof(*val))
+			uart0_reg_shift = fdt32_to_cpu(*val);
+
+		val = fdt_getprop(dt_fdt(), ret, "reg-io-width", &len);
+		if (len == sizeof(*val))
+			uart0_reg_width = fdt32_to_cpu(*val);
+
 		ret = dt_pbus_translate_node(ret, 0, &base);
 		assert(ret == 0);
 	}
@@ -80,9 +117,9 @@ void puts(const char *s)
 {
 	spin_lock(&uart_lock);
 	while (*s) {
-		while (!(readb(uart0_base + UART_LSR_OFFSET) & UART_LSR_THRE))
+		while (!(uart0_read(UART_LSR_OFFSET) & UART_LSR_THRE))
 			;
-		writeb(*s++, uart0_base);
+		uart0_write(0, *s++);
 	}
 	spin_unlock(&uart_lock);
 }
-- 
2.39.3 (Apple Git-146)


