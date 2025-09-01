Return-Path: <kvm+bounces-56445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1536BB3E4FC
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 15:29:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A3F57B1A49
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 13:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D66A133A006;
	Mon,  1 Sep 2025 13:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GHNtX/gG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC0D338F47
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 13:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756733207; cv=none; b=kz69WD2hlRS5OhzicUY9slJNmI6HX9JGittxF9uCEdHqiIR+z6aB4l0QUW4pTDVReYNgzSoup0EgPooWrkPueFGhLuwuU/jn5EQ19qdLWANX+Or6Sdfm3gqGIgeAUc5iWwN/em9ilmD8fyZ6Zc4O2ynxqxakomGTjPm5noUkKLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756733207; c=relaxed/simple;
	bh=LQRA+oVQeOXXMZNbZ2NbNOy5R/9C3F5csqDGI/P1hnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gd4TCMJee3WEN3ayQXzCkOc1fLvq0NFe1WVGe+XhrijLeSkasQ2oukkadNF7b+mrgR9XJXDJazPjvY9Xf0jWNnHpEdJb+d7+5LiJxnew/Ggf9sNHm9XtFEzZiNjZAGXQ0W0GIAxaYU6r1STUxuiHZt9eachxvODFEk8kTCpkl0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GHNtX/gG; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45b84367affso19771795e9.3
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 06:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756733204; x=1757338004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IyXvNak2OKRXWskNTtQkqe4CdzhDwlWUh7NjxtzZsaw=;
        b=GHNtX/gGN1Rks/wn6sIawdGw/xadDr79O1lZZNXa6Jtds5QGLrm/4C226wOnFAKPkm
         7PqVzoO+nkqP4cEN+rA5lQ71KehAxHkJxlCA1BnLAwct4p5MEanPvrCBPM9540ETbK1u
         h3Yx8Ky7/PgEe8G11rqyy4ZTT9BzaSJNJgZ76KhX2GrBSTVgWQU19XETQnvS2AqtTNjj
         R7M0k2PPKjp6qfscLV6FGQVuLlvlBfa6zvyIJnBPjeelDj4DzQ00wQqgduMr4UE7aHNO
         Mi0dNVILjE7i5tU3HGF5BPpoRBj1kiReOskxCRY99/qMifZ02RG45e+yXYXRUvxZqNvX
         cnLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756733204; x=1757338004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IyXvNak2OKRXWskNTtQkqe4CdzhDwlWUh7NjxtzZsaw=;
        b=U0SWeNvo0m/Qv0oVeGmv1eAiN8LZgLxDeK85qpALdRmAyFpk2tmlJUw9gKaU/tjZ7o
         bTwz5VFgRSAv5TbvRcSZ/OwDPLMLg6c5WzUbGKJ0iRjChHgX6NVp3PKTaIzV/QaYCZ4P
         5wlXIGAFuDYp5LobI8v6Nqn6GJ5QH+fPcbBLovMyWjI5+TJu0ENYmAMjGIvmDnALMAjW
         nUAxjLlaQCi/0A1k9RsUJjHTSS9uzOzbhiwH1QewIvEFCypRh/MYWuv1CmjkL8PEkOPu
         Lll0PplfHaqUKZQ8+nNyfT1KYPWiPJryfxMjggZ1xqq7SVTtVY+cNhADHFjShjahfZQH
         LXmw==
X-Forwarded-Encrypted: i=1; AJvYcCVDvSOImDGMWk/87rNrsRshCJfmvriT+BaqPDNoKtWoHP7jIT9x5tg+sn7jJCShFJp5jUw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxqm+4UuGptH28yhm+31eSDmW8Jk+H6ooYtPV7PRaaJYDqXOUvC
	bPaOefSJBKaMZAsPh2Mov9mgppkgztJcibuKzyi7pOVp8jdej9HAU5U7j2Y5fq02V8M=
X-Gm-Gg: ASbGnctQK6sL8nkIm+31hI8mYfQ1mqRWWkbknk++6emGiojwKjQVc9kiFl/hyXlUqX1
	72rHMlcsmdKOuc+6VkdVtq7sVfFjLzK02p7AU71S0gv7pErX7TPfa0jyK55e3YVGbF/Ngeq1cBd
	BaEc62KtejSymb/sbRjHkBWOpay5z5WcBMEzCf1fQStNw64Z0ylIUdS2e7DNTXmYladQbhscgI5
	yIfm5M62XxbNOxXi4mIgycfbGZQJJezoSMegdG/r3UIuTuk/yzZ1HB4GWJ1FGFtZB80XceWAIpW
	/AY8PyYOVD+I0QJkYeXpfrt9TMGoSVMlHsGYunXP638oCXSJgRmW3L0T6gSeTymDGDV1Uf0+H3T
	vKZaPMg098YW8Toed94vvv9aF+fIzEIiiu/EQqnSxxZM8YGACel7Se96delnCWtZey6FWi8lw
X-Google-Smtp-Source: AGHT+IFxk1oMEs+7TSEUZFjOaTMjdD9yFbHhe/UTsg1JhXdhq8eWAumv9rYthd/OcoCrSH7dulAkvQ==
X-Received: by 2002:a05:600c:8b22:b0:459:dde3:1a56 with SMTP id 5b1f17b1804b1-45b855b3b23mr62404115e9.28.1756733203643;
        Mon, 01 Sep 2025 06:26:43 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f306c93sm240511515e9.14.2025.09.01.06.26.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 01 Sep 2025 06:26:43 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	kvm@vger.kernel.org,
	Glenn Miles <milesg@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Markus Armbruster <armbru@redhat.com>
Subject: [PATCH v2 3/3] docs/devel/style: Mention alloca() family API is forbidden
Date: Mon,  1 Sep 2025 15:26:26 +0200
Message-ID: <20250901132626.28639-4-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250901132626.28639-1-philmd@linaro.org>
References: <20250901132626.28639-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Suggested-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 docs/devel/style.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/docs/devel/style.rst b/docs/devel/style.rst
index d025933808e..941fe14bfd4 100644
--- a/docs/devel/style.rst
+++ b/docs/devel/style.rst
@@ -446,8 +446,8 @@ Low level memory management
 ===========================
 
 Use of the ``malloc/free/realloc/calloc/valloc/memalign/posix_memalign``
-APIs is not allowed in the QEMU codebase. Instead of these routines,
-use the GLib memory allocation routines
+or ``alloca/g_alloca/g_newa/g_newa0`` APIs is not allowed in the QEMU codebase.
+Instead of these routines, use the GLib memory allocation routines
 ``g_malloc/g_malloc0/g_new/g_new0/g_realloc/g_free``
 or QEMU's ``qemu_memalign/qemu_blockalign/qemu_vfree`` APIs.
 
-- 
2.51.0


