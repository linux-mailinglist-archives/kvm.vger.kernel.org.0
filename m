Return-Path: <kvm+bounces-46219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FFF4AB4244
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:20:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D2993A1615
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15A28297B65;
	Mon, 12 May 2025 18:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xjrvWlQg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA63B2BEC27
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073131; cv=none; b=ub8ilVyny1Ox5vwC0o5i0D7WgLTW13ivioKrx+zPdGPJneuFoJKdU4b7eBWNrXxeaOb+dzRAeq0E20EunBrQ9vVrvf/yHWtdKWEea3SgYcXE+1ubN01pdGvh4Xlo7wc9KiZZWEnz3vJddy27Qv7VtKDxl6S/nx7xkRJELozeHSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073131; c=relaxed/simple;
	bh=W5bJ8dD7jV40iX9n8KM51OJW7SzzAN0wdrHeuHY3Oxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuQSKm+TrI/YjvOCJDipC9mUVKkJdOBIGzhgm16ioYm6A+5ltPA2fQbfjW5WfVq9G327AaZzTadMjfLSZ3dX44hGZyBnEbx39NGIQ0w09d9XS/Efa3YKKMOxRgAHUJvTS9TMAh5/ew+52+CN4zaJjr2q4mc9mfgoiljxEtMWCe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xjrvWlQg; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22e7e5bce38so52926685ad.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073129; x=1747677929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oL0UJx+tg40cChK3kdl5R9FcbD/FZXeuaJQlLcp8OEc=;
        b=xjrvWlQgtJ3tc+sR4hBk04Lv81X+AeYoSHNItxoiK0koo/8f8k9Td91T7EX847arZQ
         qjAnfjPsjdkiuFzYurW0mEIiWjY09dgB0VJbU3ufPwQlstBJbY+Co5tbR7wnPu3eodad
         47sWvWZOBROdI6alNArkpZeinoODltGj+ketsLxQ3BnxfltJ8h3AoH3K8d+xDHn8XMQr
         ek7gIqperCg+823YuT3fO6gr/4lT0cmSqddvkdgTSK8uSlAmNlutO4h/YGWg5I75bNNG
         vQPg8n/Gf1kQK9cMpLK48jv0TagoZNp4jxbDzA/G37mLkQ/KJb8iqCys0rd7d8/tAq4R
         L7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073129; x=1747677929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oL0UJx+tg40cChK3kdl5R9FcbD/FZXeuaJQlLcp8OEc=;
        b=MiXet6uqato5eAFYzy+xdy7RXNpXb1hVkcL9+OXjW/hqLPFEACHBROPC8VolJncUpY
         eJVcMNu5cR0QMIY+KLEKksJwsoYEDeyJYUsEonmSL7XifsaRXrm9J45rMNZAsLeNmwCN
         +ohCyDaaIScuZNK8HAHUKVb1PCvofXBbTQ32Q4ymg3jOdTyCQNsp5ARNBDJbdOcF1rEX
         XMJSzrHBvT8Tb9Itfgy7qv3+xLIOo2xphMfMyP4D+qL5Z2u/KsGuYTKH6Gb9LJXDIZzl
         m9IqutU9Sf6pS38aGjiIsNKx7GSRYIHrIb+xdtg9pOmo8Fx0wIAjOZhHxCfMczRZr6SR
         6/bA==
X-Forwarded-Encrypted: i=1; AJvYcCUbcZqG3zf//oI1ggbAyzvC9ZVUUsBZlAuujT49ZgTxZtHKuQCrvusDTDFPh0K3BsuQLAM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9H9MVg91jsye566xLjjAQLKTyicpwVXkPItYaCOA1MIcrAqr9
	iQIgoTvMW7ieGVZrr0HSEXDMWy5q6TpkIDC7SVbo5uYs9Ns2roQeTw14rSZoKmM+V1etilmzZlG
	3
X-Gm-Gg: ASbGncsDue3PVuk2ckluFHRsqCfZaUacC4NIkBKSyEvFneUKenZsuKKDaU+OAwCDZxL
	qeXQ8mlnli0gzxj7zNlPooBiej93FxNEy3fq+fmZmLa3Bom66Rmop3Jo2MkhJNbJ4h1ALl+U2qA
	WuIDP7H6BBvtO6kUF56lmzz0U9QnZRvR9Ymvex4BZTs77Uu/6j67cN8y5mGreXGWYE4MMXEkhiR
	eCGFPqcl8/EDz73vVpLoDwaob+qQ0I0YC77wmw0a6TcwUs9Ljgzx+H4TpgtNXTM0Wn7qcfWz41b
	VmweyblFdHoqRNclWAidCQJKYex2IdZMHn1J/g6VWeFr9zaC0/U=
X-Google-Smtp-Source: AGHT+IH7qLvgpx/Cb/Pp3+k1HYQ0qX7j8tIRYiuCyLgrVakJqFp3QIBAFvYBptkwZOaClTHq6p5RBw==
X-Received: by 2002:a17:903:244b:b0:22c:336f:cb54 with SMTP id d9443c01a7336-22fc8b5976amr194066245ad.29.1747073128951;
        Mon, 12 May 2025 11:05:28 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:28 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 19/48] target/arm/helper: restrict include to common helpers
Date: Mon, 12 May 2025 11:04:33 -0700
Message-ID: <20250512180502.2395029-20-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 4a2d1ecbfee..3795dccd16b 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -12,7 +12,6 @@
 #include "cpu.h"
 #include "internals.h"
 #include "cpu-features.h"
-#include "exec/helper-proto.h"
 #include "exec/page-protection.h"
 #include "exec/mmap-lock.h"
 #include "qemu/main-loop.h"
@@ -35,6 +34,9 @@
 #include "cpregs.h"
 #include "target/arm/gtimer.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 #define ARM_CPU_FREQ 1000000000 /* FIXME: 1 GHz, should be configurable */
 
 static void switch_mode(CPUARMState *env, int mode);
-- 
2.47.2


