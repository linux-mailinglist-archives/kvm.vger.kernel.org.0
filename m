Return-Path: <kvm+bounces-26273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BFDE973B04
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:09:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A6BE8B24183
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 15:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AA2F199948;
	Tue, 10 Sep 2024 15:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IY36+MD+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56482199389
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725980940; cv=none; b=n7DIL1nSPR+77gm2VLl/TXUpoyMzFzbNeBBpCXmuFnxVLbkC0QE5bK6CAkUwvU0zuUN/8YvrHK8VLdmmhNmKPu9L3UYuevZr54j9OaziDpXS6s2JGHs7TkTQQ5EUL4PuTdkrX3alFU8/XgE8dfd6HFqCPMP+2RDqVKR3246Pc9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725980940; c=relaxed/simple;
	bh=EEgrZ3NBfO/BMgHEa+wmeTsPBRCMjb5z/lIDoDQAkso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/4tGVJ8NDzPpdSIoU3HCof6z2JfeEDK+bWZtaohdoSWMS+/bkjwpjH6ILeUSipwWQb7oKBGSW4TQtojElea84PBerPJyRC3YBheyIk3dU+3XIhdXR6O2cI1b/f1kfNlsJ4w2imH7vB3Q4zlC/D2PHkEW+N5flw7FLUGUdAFpq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IY36+MD+; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2d8881850d9so642096a91.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 08:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725980938; x=1726585738; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jJ0SGbueLL+CmiAymH1gcSoFZqvjzIWyBVOl8YOSxQk=;
        b=IY36+MD+jmjGV9HQnVujfW7hlVwWgTudgNwI3VpKZdJdIscyQ1z5afAFsEBBsb3Dun
         umS/IGyVn344FaWJPkGWi0+e/Gwxhu6qa47/qrMswqi4iZHH8w0RLKQexkDemfBl2rnA
         +6ccjJgjY+rmTsQ93b5xx1LKkGXmKQKIrRTQBhVnWuZ65E0rEt2fSoTm8RVoCLZmk4OW
         GaKhnUgDsuKF8iXae/Nlr50RKQyRzZrXksFRN66lHfzIJm7HEVlzBgD98+K9/WJdH7OL
         QuszAL1Jh1MliakvPoajTuIioTRd+3zM8yXD21UkKIbM2qPE6cIcMN0Rqbg7nh6tNSPF
         pPhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725980938; x=1726585738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJ0SGbueLL+CmiAymH1gcSoFZqvjzIWyBVOl8YOSxQk=;
        b=SGjV3lkeoxpdrgnVctaIdrEN4Xd0kpkTKPNgu9/JKLxA+scVR8SlG5QsBc4+fppCql
         jivP7ShB+h15hjwtOX9h3MuVRfjMMO56pz1GY+DMxu103neBj7XCg4fiXffXSAr7U6EI
         lAPJTzqjoProMlIWJV9ua/YjxpQNoloXHKvKUVgvJUk+Y8dUhk59x6GdwlRCiVECOVg5
         G9Q91ziEGNOo3M9C2Vo/nR6tJNy+Wwf4tu/M64+vJqJO67I3pdKIEmSZlekmbDlDjF8L
         +vKBa3eemt+TOJE0lfj7KMl8J3zolmS1e0hCiRf+iSLdo0yKDzMOKU7FPt3PCGYgRLWT
         btLg==
X-Gm-Message-State: AOJu0YwTu8l8Y9VvSMqZZB9BnPBk7qTQ6ku9wTNTcuAC4FSxJnG57sgz
	HErt0MhmeYm8AC5917sTUvLXTwWRJYFDYveoRxrASPBVoc/Q/u10VwxVCsC2
X-Google-Smtp-Source: AGHT+IG0iyMqvqxpu0X/2Og0DCIqsyuVLf32tPr2K/8TAm+mC5FKKAucoitOwNcYmiCvgmXTVcflaA==
X-Received: by 2002:a17:90b:3b8b:b0:2d8:84df:fa0a with SMTP id 98e67ed59e1d1-2dad50e8778mr14157637a91.32.1725980937974;
        Tue, 10 Sep 2024 08:08:57 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2db041a02c7sm6615120a91.19.2024.09.10.08.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 08:08:57 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 1/2] lib/report: Add helper method to clear multiple prefixes
Date: Tue, 10 Sep 2024 23:08:41 +0800
Message-ID: <20240910150842.156949-2-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240910150842.156949-1-jamestiotio@gmail.com>
References: <20240910150842.156949-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a method to pop a specified number of prefixes. This method is
useful when tests want to clear multiple prefixes at once.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/libcflat.h |  1 +
 lib/report.c   | 21 +++++++++++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index 16a83880..eec34c3f 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -96,6 +96,7 @@ void report_prefix_pushf(const char *prefix_fmt, ...)
 					__attribute__((format(printf, 1, 2)));
 extern void report_prefix_push(const char *prefix);
 extern void report_prefix_pop(void);
+extern void report_prefix_popn(int n);
 extern void report(bool pass, const char *msg_fmt, ...)
 		__attribute__((format(printf, 2, 3), nonnull(2)));
 extern void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
diff --git a/lib/report.c b/lib/report.c
index 7f3c4f05..0756e64e 100644
--- a/lib/report.c
+++ b/lib/report.c
@@ -60,23 +60,32 @@ void report_prefix_push(const char *prefix)
 	report_prefix_pushf("%s", prefix);
 }
 
-void report_prefix_pop(void)
+static void __report_prefix_pop(void)
 {
 	char *p, *q;
 
-	spin_lock(&lock);
-
-	if (!*prefixes) {
-		spin_unlock(&lock);
+	if (!*prefixes)
 		return;
-	}
 
 	for (p = prefixes, q = strstr(p, PREFIX_DELIMITER) + 2;
 			*q;
 			p = q, q = strstr(p, PREFIX_DELIMITER) + 2)
 		;
 	*p = '\0';
+}
 
+void report_prefix_pop(void)
+{
+	spin_lock(&lock);
+	__report_prefix_pop();
+	spin_unlock(&lock);
+}
+
+void report_prefix_popn(int n)
+{
+	spin_lock(&lock);
+	while (n--)
+		__report_prefix_pop();
 	spin_unlock(&lock);
 }
 
-- 
2.43.0


