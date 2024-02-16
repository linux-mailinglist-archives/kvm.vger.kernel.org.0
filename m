Return-Path: <kvm+bounces-8867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C59FB857E70
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 15:02:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 667371F2851D
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 14:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B74812AAD9;
	Fri, 16 Feb 2024 14:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SvD5dpf5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6172512C550
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 14:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708092148; cv=none; b=NG/0yndtyOuhWnOu9/C8BAZRdAv0iuOh7zLpFrSlxY0htdNeXm9dvEr7+GkVYGETL6NzbGjpMQYljQRYY1lNZ9i2y0sha66lsMhfdh75iWYGZW/mP4TF5OuzwEmwLRi5Ywj6INLpbT5xJDc7JgW5fhpmDhmzI3gfCt6C4GqaheU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708092148; c=relaxed/simple;
	bh=K6LB6+MemA9fj3a/ZAx6PykgqUbVt5cwV8Jss8rIfdA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=owMP5i6C0vGTZpq7SUwzVg6KXdTKhnEqBk/fo80C4GenhHHSJRbl0BSiIp2jv7scseK3VEsLYBXadC5/yQX6YbNv9k2Ag4OH7vzb44SMHcBehDbubZXTxTMhnfuWWtHdnVwseIRAtY5ipII5/XxLcvcjxe6erUZ95ty3MWqvhu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SvD5dpf5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708092143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FhaTO4DXP/qUKknQgbcg7AfYeRWWKpGtUjyGYREPOM0=;
	b=SvD5dpf5I30ZXnWH3biz0M3lxR1GgS14HVV6D47fDOdnwBhpTLd2MJx1IeASttjLsMxMiV
	RJ2ALvPl4vBeXFmbPGF4nvxvyKEptjudaUNK3jiomDI1xOw07x9CT210Yta6hjMVSndxJl
	piNuFfBXUeyA13TYxXcyrywL3bRP8XY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-335-PyC4bJcdN-2Mq5uo3tMMUw-1; Fri,
 16 Feb 2024 09:02:18 -0500
X-MC-Unique: PyC4bJcdN-2Mq5uo3tMMUw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF80638125B1;
	Fri, 16 Feb 2024 14:02:13 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.39.192.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 66A0F2166B4F;
	Fri, 16 Feb 2024 14:02:11 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>
Cc: kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar() multiple times
Date: Fri, 16 Feb 2024 15:02:10 +0100
Message-ID: <20240216140210.70280-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

getchar() can currently only be called once on arm since the implementation
is a little bit too  naïve: After the first character has arrived, the
data register never gets set to zero again. To properly check whether a
byte is available, we need to check the "RX fifo empty" on the pl011 UART
or the "RX data ready" bit on the ns16550a UART instead.

With this proper check in place, we can finally also get rid of the
ugly assert(count < 16) statement here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/arm/io.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/lib/arm/io.c b/lib/arm/io.c
index c15e57c4..836fa854 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -28,6 +28,7 @@ static struct spinlock uart_lock;
  */
 #define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
 static volatile u8 *uart0_base = UART_EARLY_BASE;
+bool is_pl011_uart;
 
 static void uart0_init_fdt(void)
 {
@@ -59,7 +60,10 @@ static void uart0_init_fdt(void)
 			abort();
 		}
 
+		is_pl011_uart = (i == 0);
 	} else {
+		is_pl011_uart = !fdt_node_check_compatible(dt_fdt(), ret,
+		                                           "arm,pl011");
 		ret = dt_pbus_translate_node(ret, 0, &base);
 		assert(ret == 0);
 	}
@@ -111,31 +115,21 @@ void puts(const char *s)
 	spin_unlock(&uart_lock);
 }
 
-static int do_getchar(void)
+int __getchar(void)
 {
-	int c;
+	int c = -1;
 
 	spin_lock(&uart_lock);
-	c = readb(uart0_base);
-	spin_unlock(&uart_lock);
-
-	return c ?: -1;
-}
-
-/*
- * Minimalist implementation for migration completion detection.
- * Without FIFOs enabled on the QEMU UART device we just read
- * the data register: we cannot read more than 16 characters.
- */
-int __getchar(void)
-{
-	int c = do_getchar();
-	static int count;
 
-	if (c != -1)
-		++count;
+	if (is_pl011_uart) {
+		if (!(readb(uart0_base + 6 * 4) & 0x10))  /* RX not empty? */
+			c = readb(uart0_base);
+	} else {
+		if (readb(uart0_base + 5) & 0x01)         /* RX data ready? */
+			c = readb(uart0_base);
+	}
 
-	assert(count < 16);
+	spin_unlock(&uart_lock);
 
 	return c;
 }
-- 
2.43.0


