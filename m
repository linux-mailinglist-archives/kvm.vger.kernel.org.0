Return-Path: <kvm+bounces-18582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A168D7553
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 14:26:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62438281E34
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 12:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E333B7AC;
	Sun,  2 Jun 2024 12:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1Oqg/tp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A897C38394
	for <kvm@vger.kernel.org>; Sun,  2 Jun 2024 12:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717331174; cv=none; b=oiK7fIXw/V9FQHn6fEmxTjOa/4zX8UJOnTyrCIWQQ/3Il8JJdzrw1vtGI2c/6wqZbhNYgCXnCtY79xnxPUmnEnCmhOjAHYNO/uHEMDsnaUeUiCTN4mfEJo4HbsiaM5XIxRXhja2Uqqw7DO/08NwfOLC9zAq4ax6Juke+7sTJrvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717331174; c=relaxed/simple;
	bh=lFOCyger+Cvum4USeOZwnOs5mMMmHZ6zekex9/cU82c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnQ1WOrSPTEkFQ/D56alcWxkqicRkpjJyHVqTSTxBVn7SeOHGxtmv4el5Thhhhl69sCjnDvKscPVQ83y5dKfKyPQu0QIwc1S02WXqXvugHoo6BXAxbt6Gfoc73gwwmOGUQfj7ZRJLOQ7uTauMuXmsyF/fvaxvTjZJ7FN4pDobDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L1Oqg/tp; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1f44b4404dfso30961535ad.0
        for <kvm@vger.kernel.org>; Sun, 02 Jun 2024 05:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717331173; x=1717935973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J0+Rqr5O31VyBP3nYRYAZ1XPI1Uu1EEL5+3UerSfcLk=;
        b=L1Oqg/tpvFWHcoauuZw+ma3Agf5h2uJexOks9PG3SOwE05SCMFzOXp7z3Yxt6BLhIF
         LKrWKRE2Ggs07s3j3+GH18O5oLDY46DJpxYAlvvvFfCBIrCfFlAbl3Q0Ep2s/9/1ki4o
         Jf2HKILPtlcJR9m+WmtCTQXsBiZeASaRbm/25s85RArQ+gHuBaBNCJyt8LRfv6LkS/sO
         xv5awJp21RKx3QY5GVypBRTDI9FDMkAR7tRBa2svBal37GDp0XUY2rZkbnfWZDp87WcP
         P6RPGJFnaua2SLOIZ1qJZsCGBNN7gRF0CISnjXEjRahBfUzZeV/HeoPARrDQ3XgYd/SV
         nudw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717331173; x=1717935973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J0+Rqr5O31VyBP3nYRYAZ1XPI1Uu1EEL5+3UerSfcLk=;
        b=qwyGGLMbdt2cL5cDGaS2Qw/OosTtwnsjsu8LZJM1YY4HWlTvvB5nWea5ueUoJEZYN8
         kXbV8TDHdWDsa3rEeR+1enM+xsR0sDBReC59xs6GkMX7cFlSnHNbis4sQvCKmNomsROc
         y/9EOl8a8akwO86pAiJlELggt34CfiW+n61DkRDm21HRFcfCo1e6uLaJbKZhoDyGdMVq
         FEeYsd0bP514OByZzhzu7sGhL+ywSsO6VZPyn6cUbTCfG9b2k3DVuXmwFEc31IDE3uiP
         ZQCAA6DVUhYxU/m9ugIlhvez0r0BAybPqgacfBcn9UZUEoWWIDQKToJMn+BSnCrw2ada
         LWUQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/aLmcbq2vbAcriyKYkF0w7ec2cz6sNfMMpIRfGKFgiEW+gJwgq6R1Dty6PBalueQZK0L6TTA7GJP8/ELy/kJUWvmc
X-Gm-Message-State: AOJu0YyYCFjFeHyOQA6VGCDGID9185s9ZXH3xYZ3FFz8iakk7vyu0UBi
	yGf3nHpFo0cWHdER25+lFtEZwXeQkd5DzWrTewu8/QJqYxDbpc4X
X-Google-Smtp-Source: AGHT+IHIciwb566nl0u55CKEkBnjZ9tl7Rifm+VvXDKA5BRrgV7+AfpURO1apfagzPrJSssT2em99w==
X-Received: by 2002:a17:902:f94d:b0:1ec:e3c2:790e with SMTP id d9443c01a7336-1f63700392amr57225025ad.19.1717331172769;
        Sun, 02 Jun 2024 05:26:12 -0700 (PDT)
Received: from wheely.local0.net (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6703f7673sm7834145ad.210.2024.06.02.05.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 05:26:12 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/4] powerpc/sprs: Fix report_kfail call
Date: Sun,  2 Jun 2024 22:25:55 +1000
Message-ID: <20240602122559.118345-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240602122559.118345-1-npiggin@gmail.com>
References: <20240602122559.118345-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Parameters to report_kfail are wrong. String to bool conversion is not
warned by gcc, and printf format did not catch it due to string variable
being passed at the format location.

Fixes: 8f6290f0e6 ("powerpc/sprs: Specify SPRs with data rather than code")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/sprs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index de9e87a21..33872136d 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -590,7 +590,7 @@ int main(int argc, char **argv)
 
 		if (sprs[i].width == 32 && !(before[i] >> 32) && !(after[i] >> 32)) {
 			/* known failure KVM migration of CTRL */
-			report_kfail(true && i == 136,
+			report_kfail(i == 136, pass,
 				"%-10s(%4d):\t        0x%08lx <==>         0x%08lx",
 				sprs[i].name, i,
 				before[i], after[i]);
-- 
2.43.0


