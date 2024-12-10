Return-Path: <kvm+bounces-33381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F221A9EA74E
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 05:48:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B322E28823E
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 04:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE36226196;
	Tue, 10 Dec 2024 04:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="LRIa6E68"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1121D5CD6
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 04:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806109; cv=none; b=csAu3TUUt3TFoGDKTBFMT4hSNZBIVghB3SJ7OtXHKxhvpI72abLvJ5u6LILEvXIOngGReI5/91j+0DjLInAGWOTpuldxFOzHfxP9ZCEmpDoNkA8fEYldcqgNMbfns7/GxsGGI6oKb0TTVmIVcqeAJAc8HvdXGTmBvhYgzeEW4jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806109; c=relaxed/simple;
	bh=6Met0bLkuC/BY5/H2rkzscI5izQ0VhZIhPNMPl/U2Tk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tkzYFZOoX2vCfWYV7u7h+R0/RLqrwCf4I+LS0CITndIZ3wWDIj8MaP6H6vro5mBtCOuceRtcJdVCpsQE19GYmnQMgq/y5Dix3Ac9+WOvkAFDCiCaP66n1rw6PFm4PG4H4kfk7Vwch2QnAzERDzwCz9t8ujq/0VyuVrsT4aP/i2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=LRIa6E68; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3a9cb8460f7so17146025ab.2
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 20:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1733806106; x=1734410906; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7tFkQ34FQNo469g3ex0tCmBXb4amDFlSD6bxTbq0zVY=;
        b=LRIa6E68Cmsg1ItcLNqFZrSOuHWdQHZ17QrKa5PIjvKhyvHwFTOmUa1RyuF81sB7JG
         uj78xlxJD81NjC5+HbklDaZoS3TuTJTgsxpozoLeLugQrsEullXzE+w0osvRkqNPr2Ix
         HzZAMizcPaqlMOcmaThea8DPwA1tpyZDRSnyj7fzxVn0c8eoBKIiUyb4A+IQdvQCHcWz
         WuZAWAtNdQIWYOG85RUwDWNy0SqZ6oudN1H00LrvYBKz8TGZW0O99pU9MoKZFFiCgn1+
         0OoMiEKaIqsTRXMZ9WoEfis1Xz60cUP0/l3l/+MtametxmVGh+jIjao2wb+ELEXsQnkg
         KsxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733806106; x=1734410906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7tFkQ34FQNo469g3ex0tCmBXb4amDFlSD6bxTbq0zVY=;
        b=mzUUsCv0kW/u6yLRLLxP3wyYmnHQ8+lUzNgLIsNJduvpeGjjUTxYEFu38ycKyMEVGy
         aS1TDYnNkJ8kvBDgMjWWf02Do+CCKX+/ieIS1KtxstwZtZye+NT77X7uuXhaLu0r2rHm
         AgCH7qazLEpXTbOk3AUsk7zMJKQDt3UK/5sHd83/IrmArCoMjWCJK24pqjbkQTatLRWf
         xomnzDzpPdg6JccdcMM2r4TJo6G05tpczS0/J5tN2wGRta45E7Azk4iOJAGnii4zvAMD
         X2ymFqkFiCR7muSoBUi9bq+f64Y1mwzLbkKYDTFAKINGyjZrutX0GPLDGdz61QyIhOVB
         IAPQ==
X-Gm-Message-State: AOJu0YwO/q+f8i4w4/1a1abV5//gCCLMIOoD5FM0ouQEKcPgQjg8hf0H
	PeAuTwoGFlJ8fz2kvfR4KQgfv+OHsZGSp18lNZ0fdB90BdisB/S0PtsmR4mUKJ83OBE3uYHI4mo
	Is5pCWY6kb115A1T40no0/MJmUtIodeO6eMM4YO0QDf2PakIIaw+CK5bcb7XvV8xxdQa3GrVwn6
	hagizT2rojLayw5ltVKB92oPNjzfoqorvYHu84WXHG
X-Gm-Gg: ASbGnctO4bT2tbcRsyv6yqZA5MEDQzYjA+Jz7X6QyDJuweXuZfXobQgPYH0f03S4O8e
	V3HikEZzMr1budEZR2ZtkNgG8h7BwWKF+M7COcd7Xpxug1RcJSbnVfmfkUhTTYTSQ4wjsPSA9EV
	L74BFnnGk+Ny/3KwMKXSdelk/Fb+DPf2ZAf6UWTg5/a4Fz0lg8hxMcuTuWweYzals8gautEwcf7
	VEfOPFH0LwdnV6IWMmtSDjqlC6p5wwhQD8RNMCpV0DKw3yrdRwFNcJHPVe2Tmt+zwbtJhnWdsgm
	eZzaYWFbdeeC9DoQj9pmmyumEfalr8Q=
X-Google-Smtp-Source: AGHT+IH98YwIymiX/boxuM6sNjtUPcO8y3plWGtX0MM7kr2nNVZE9xv3TNkuBeperQYS1ZfUrJ+0Uw==
X-Received: by 2002:a05:6e02:1806:b0:3a7:7ee3:108d with SMTP id e9e14a558f8ab-3a9dbb48a6cmr33890775ab.23.1733806105957;
        Mon, 09 Dec 2024 20:48:25 -0800 (PST)
Received: from sholland-0826.internal.sifive.com ([147.124.94.167])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a9c9da809dsm17022405ab.4.2024.12.09.20.48.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Dec 2024 20:48:25 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: kvm@vger.kernel.org
Cc: Samuel Holland <samuel.holland@sifive.com>
Subject: [kvm-unit-tests PATCH 2/3] riscv: Rate limit UART output to avoid FIFO overflows
Date: Mon,  9 Dec 2024 22:44:41 -0600
Message-Id: <20241210044442.91736-3-samuel.holland@sifive.com>
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

This is necessary when running tests on bare metal.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---
 lib/riscv/io.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/riscv/io.c b/lib/riscv/io.c
index b3f587bb..8d684ccd 100644
--- a/lib/riscv/io.c
+++ b/lib/riscv/io.c
@@ -13,6 +13,9 @@
 #include <asm/setup.h>
 #include <asm/spinlock.h>
 
+#define UART_LSR_OFFSET		5
+#define UART_LSR_THRE		0x20
+
 /*
  * Use this guess for the uart base in order to make an attempt at
  * having earlier printf support. We'll overwrite it with the real
@@ -76,8 +79,11 @@ void io_init(void)
 void puts(const char *s)
 {
 	spin_lock(&uart_lock);
-	while (*s)
+	while (*s) {
+		while (!(readb(uart0_base + UART_LSR_OFFSET) & UART_LSR_THRE))
+			;
 		writeb(*s++, uart0_base);
+	}
 	spin_unlock(&uart_lock);
 }
 
-- 
2.39.3 (Apple Git-146)


