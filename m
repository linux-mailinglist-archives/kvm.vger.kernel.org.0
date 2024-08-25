Return-Path: <kvm+bounces-25011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E12995E481
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 19:08:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4EB61F216DE
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 17:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E9415CD52;
	Sun, 25 Aug 2024 17:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jqi3O6es"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FF315442A
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 17:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724605719; cv=none; b=pQg+4e94W45Bl6ObyddosA9yon1yYw0qFMguiVaWffiPTEernFDAZm0t7/0vq+dF2desDNO5C1fZZFYoMxUHAE10o7CjvIA+5uS2BATMxI7Ekgx1hxIT/+080VIISrB7v/EenFXMZbZqwllNAefFpjR14w/Rlktr4slBO9foJu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724605719; c=relaxed/simple;
	bh=3dmDRLqbgjk6WsCgvQb/v8iExYY8qXNF7IuvGb4qIyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbfAeADUB/F6AkgWbDW5JBJg2Ugpjt7pPNNoo/9zG5cjO5hIGsyfnNbaMV0iNS/H8bIZyOKzdc8Keje1IfxDRmClQzHpMaKGQh7vFtmk9gWwv38RXttqwQIUblG7fg5EiUXAc5Gytc/aVSQWNzZIfhKN3PSSZZJMQVOhrK1pKBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jqi3O6es; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20231aa8908so27013735ad.0
        for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 10:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724605717; x=1725210517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3uvZgdBkzqRgKxJdiD6ICI93DbcAzIJAn5xzIEe2DlE=;
        b=jqi3O6esmiyLdsxxxwoKO6uUri0CnntQBa6dX48rErimmZGxhk9gU9Z9U8neALUijM
         oAoQOiG3bRemYfLPhavQGxL4y9j1t1NDP1yfo9ZTQYTopOu8cmWywi2L6i/yh4RYIJOo
         SJCKbJyS7aWx6RGkSjP+0nuDC0JSm6iz2/SIzjzXuJDbFXI/7J7RsWe5Q/9pjYuhWMZq
         /8SFbdLPzhDKrjMw9jO/0Et3aP5ojvfereZ/T3f8pxl/XGEK/7QMEKRuXKQlXkpe/oc0
         HgYt8wPHk3VdgDXpO5DOIG2Dt3DqOp4GQMAbeAIQn+gdfjuA2mc2/7iCBl7Awmd3HS2H
         ZTKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724605717; x=1725210517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3uvZgdBkzqRgKxJdiD6ICI93DbcAzIJAn5xzIEe2DlE=;
        b=S4TlgezOaoCCsl3PNVnOdr+6Zixht4XukwGrGLHjuH2ky0t/j6Ac1lBtsTuANelMOa
         QEgeg0BA8WhHnDRq/h+6m7QcXHF21ayOHbtfZJouUnOvFaA301DzfEmYikr2xVrXJcs9
         pPyT9IBgBlpjk1Wrxufsi7u5SCt6B4tQMtM5rLMGbAHGYMzc169SZzdWmaA1TZZd1s+V
         TEPTAg2qK8/5R0C6uRhBhEOawJslMejnmgyyvOAOaG8/kXwMTo9r0JSHoV2a2b3cH1el
         oyC04066lyhr7EbOD+8R/u5xONagRIth09NToz06oqE09VSWSAWcz6zOAZMbfTACMOQW
         Vhug==
X-Gm-Message-State: AOJu0YweKzs7CRLGn0zxjieD9Y63INOqFT0rKkoDGVb4camHZ5efomvY
	BSupoFloTQt2UskNlxXu+bVYv2y8BQ7xJ063dtFuiOE/kJSJnyiQrxdxgDKj
X-Google-Smtp-Source: AGHT+IE9/Dpje8Upv5MAJrw8Ui4K2DOheALKcYSW+r6BB5Zuv3KXlXZl0VXnkGhl9noA7oy5EnQVRw==
X-Received: by 2002:a17:903:22c9:b0:201:cda4:69cb with SMTP id d9443c01a7336-2039e4a8fedmr77819525ad.9.1724605716549;
        Sun, 25 Aug 2024 10:08:36 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855dd985sm56083165ad.164.2024.08.25.10.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 10:08:36 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v2 1/4] lib/report: Add helper methods to clear multiple prefixes
Date: Mon, 26 Aug 2024 01:08:21 +0800
Message-ID: <20240825170824.107467-2-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240825170824.107467-1-jamestiotio@gmail.com>
References: <20240825170824.107467-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a method to pop a specified number of prefixes and another method to
clear all prefixes.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/libcflat.h |  2 ++
 lib/report.c   | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index 16a83880..0286ddec 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -96,6 +96,8 @@ void report_prefix_pushf(const char *prefix_fmt, ...)
 					__attribute__((format(printf, 1, 2)));
 extern void report_prefix_push(const char *prefix);
 extern void report_prefix_pop(void);
+extern void report_prefix_popn(int n);
+extern void report_prefix_clear(void);
 extern void report(bool pass, const char *msg_fmt, ...)
 		__attribute__((format(printf, 2, 3), nonnull(2)));
 extern void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
diff --git a/lib/report.c b/lib/report.c
index 7f3c4f05..d45afedc 100644
--- a/lib/report.c
+++ b/lib/report.c
@@ -80,6 +80,19 @@ void report_prefix_pop(void)
 	spin_unlock(&lock);
 }
 
+void report_prefix_popn(int n)
+{
+	while (n--)
+		report_prefix_pop();
+}
+
+void report_prefix_clear(void)
+{
+	spin_lock(&lock);
+	prefixes[0] = '\0';
+	spin_unlock(&lock);
+}
+
 static void va_report(const char *msg_fmt,
 		bool pass, bool xfail, bool kfail, bool skip, va_list va)
 {
-- 
2.43.0


