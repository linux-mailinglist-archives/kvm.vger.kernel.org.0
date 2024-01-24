Return-Path: <kvm+bounces-6800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4774483A2C2
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:20:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B1B21C27684
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 07:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F298717BB5;
	Wed, 24 Jan 2024 07:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AP6zDoOQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C320179BD
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080754; cv=none; b=YqDCevHf4VJpzOaIenOfckejXYHmjs+wmr9Tz8YspcAje9ZnwjIWhv5BcKU09K0qIbYscftnRrQ7W/pz70UUVX4Xf5roDtSeUEeiFbY7Th/JdjDR4nZYiqERAMVLfkoymaQ05qmZ00+HvvUlmqeOEFeXa83A9dJXc17p+q/WgYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080754; c=relaxed/simple;
	bh=pPPClfhj9IQdIq0V866wOfmP/whzQ6P713pc9mHBe5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=MR3ds3IXzPru36fgGBTyq+Pb1FLIiGbqfjt2+2Q8fRrTA+QkUj7lcC9NZwzs5nzzBCB1D1z1gpz/6ELC6qHPSFNqpsDfJ2yjx0sthLylpQVVBbuDCkLWJa+OlPmNwKMzw2CleoHY6MpeMAgVt9UEAub/c9+fcdDNojGSOEsej84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AP6zDoOQ; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o//r6+W1B3E6JfciIqikyfg8FCrGgEsOxJCsTaRjfBA=;
	b=AP6zDoOQM0SsGJ+uTIcawhK2UroEF9e3iowKuXBs6ISrTmZ2a/iGelOoJjJPTmXr2iKx2D
	iqFRh1oaEuBqP+IBNSs3rwe1CONpwS9m2xKt/FEgit2PnFSaUkAyZ/bGhHbbuIrvlgeKyb
	dXHgxsB8Ft6fUoZ6+fCT1kr2c7uwZ0I=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH 21/24] lib: Add strcasecmp and strncasecmp
Date: Wed, 24 Jan 2024 08:18:37 +0100
Message-ID: <20240124071815.6898-47-andrew.jones@linux.dev>
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
References: <20240124071815.6898-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We'll soon want a case insensitive string comparison. Add toupper()
and tolower() too (the latter gets used by the new string functions).

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/ctype.h  | 10 ++++++++++
 lib/string.c | 14 ++++++++++++++
 lib/string.h |  2 ++
 3 files changed, 26 insertions(+)

diff --git a/lib/ctype.h b/lib/ctype.h
index 48a9c16300f8..45c96f111e19 100644
--- a/lib/ctype.h
+++ b/lib/ctype.h
@@ -37,4 +37,14 @@ static inline int isspace(int c)
         return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\v' || c == '\f';
 }
 
+static inline int toupper(int c)
+{
+	return islower(c) ? c - 'a' + 'A' : c;
+}
+
+static inline int tolower(int c)
+{
+	return isupper(c) ? c - 'A' + 'a' : c;
+}
+
 #endif /* _CTYPE_H_ */
diff --git a/lib/string.c b/lib/string.c
index 6d8a6380db92..ab6a724a3144 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -54,11 +54,25 @@ int strncmp(const char *a, const char *b, size_t n)
 	return 0;
 }
 
+int strncasecmp(const char *a, const char *b, size_t n)
+{
+	for (; n--; ++a, ++b)
+		if (tolower(*a) != tolower(*b) || *a == '\0')
+			return tolower(*a) - tolower(*b);
+
+	return 0;
+}
+
 int strcmp(const char *a, const char *b)
 {
 	return strncmp(a, b, SIZE_MAX);
 }
 
+int strcasecmp(const char *a, const char *b)
+{
+	return strncasecmp(a, b, SIZE_MAX);
+}
+
 char *strchr(const char *s, int c)
 {
 	while (*s != (char)c)
diff --git a/lib/string.h b/lib/string.h
index 758dca8af36a..a28d75641530 100644
--- a/lib/string.h
+++ b/lib/string.h
@@ -15,6 +15,8 @@ extern char *strcat(char *dest, const char *src);
 extern char *strcpy(char *dest, const char *src);
 extern int strcmp(const char *a, const char *b);
 extern int strncmp(const char *a, const char *b, size_t n);
+int strcasecmp(const char *a, const char *b);
+int strncasecmp(const char *a, const char *b, size_t n);
 extern char *strchr(const char *s, int c);
 extern char *strrchr(const char *s, int c);
 extern char *strchrnul(const char *s, int c);
-- 
2.43.0


