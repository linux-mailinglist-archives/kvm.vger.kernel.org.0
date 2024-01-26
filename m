Return-Path: <kvm+bounces-7167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DEC583DBC7
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:26:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3772283C65
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC891EB45;
	Fri, 26 Jan 2024 14:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TRtF+z1e"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1CD1EA76
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279068; cv=none; b=bNIe8Uxil7Hi61kMLyiJT+jPPZ1N/gxSw64YmLehvpvEdeMHR3N0CrWdBAnj3jRspoYF9YT1VsBQSVFrDzC9imMGLdGqEmoXRWKc/0frmeG7ru18f/P2Suvp+um/Tqy8KcwhI6SmO0CdHV2iE3N3VggsI8wPiy+tY8zs3+KH75Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279068; c=relaxed/simple;
	bh=l1H1ayVgtr0y/F9BTxnc/6VhhP1h6adG+2QUfjicTZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=k+aPVtE/3ALckdUjKK5UcoQhXOLLsUKyd2GxxbUD6ST42XFubfIexB8lS6qe7S+mhOuC4XhkJ8qfjIJ2ShQHMiaQC/C/Y9e5G5Wkun2zV4zGP66/oYC9cOy1p2yAq2+zSU6V+oKO1woVLTFpeIxEr3YXwb6VRCTT4yM+FGLkB3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TRtF+z1e; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sKLWTFHf0UYVnJ+oUmmhwMrq46laxuqPb1YHaaLZsb4=;
	b=TRtF+z1e3GThrswZDDX9TUDilpV/ELFcwpv+58PbbPchgX8yDmTO018bgI4QyqaNPW1Rgf
	oUcDEKHWwtSmNUzPPXPDx7nWsExfyrQPcyUO4gXUZvSWDxKRptoB/M+KBsalNNG6VhMj/R
	WVYKs0bvR/MpN5xkd0MkP1w+FXhUqMU=
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
Subject: [kvm-unit-tests PATCH v2 21/24] lib: Add strcasecmp and strncasecmp
Date: Fri, 26 Jan 2024 15:23:46 +0100
Message-ID: <20240126142324.66674-47-andrew.jones@linux.dev>
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
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
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: Thomas Huth <thuth@redhat.com>
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


