Return-Path: <kvm+bounces-46203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5CAEAB423D
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E64F57B4A6D
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D00C7297118;
	Mon, 12 May 2025 18:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ShWVdcUB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF6E2BCF75
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073116; cv=none; b=VSF2NOjPueUmUMJFKAO1NkW+KoHX/kJi76CNBhUd8z59x6XKILpKFxpK/Dp20MQYO3uUxq1jvfLXZqHqYEX6cGU3hHUomRkF2m3oD6pRFFiOGQ0nfaILJJTYx/BG0E7V0RXLJMAxu9ovLrYps2mVSFtw4L93a6Ep6sY355HAId4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073116; c=relaxed/simple;
	bh=1EeclPzmYy7xWfD7EowRs87goZnUTxZAJc+Pof/Velg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rxmNFJlbSCwO2xcYaDrtq7EfMm+984sT08S1reyuiky3bgi2KexS5M7m3wrxEvjmqppy+C+roVtCXVpOUOKmm5IrqS3Ro+M01214TH0aHJSlQvM85apsknnpvPZBXY23njXIq27scb4O/1dqxy/N++qXVo0BUcgzEHx/ewPYRnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ShWVdcUB; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b13e0471a2dso3371718a12.2
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073113; x=1747677913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJMyYCTFAIbu3EwtVFYHiNKkH2seNanmqLNgECsCQ48=;
        b=ShWVdcUB2Td4GpvdhWdFxjnZINSQkHLxPnrv3hPsZOoY95mBglnfvmUDgRcrc3wOkC
         KJ37NwW6IIToXhjYgXPZIxqYe7m8f3uxACAOxuCt83q7zzCtTu2uDwOAhcCvbmippbXQ
         0jxhAelwZDCPzgKO/P6LvjvaHgEU+ZTGwGc7ol9HYjMwAsdrJD/DBvsRvCdQOL52TfBV
         UMolZNA6LG3YLz4iWy8Zkn9EQ6M8YCTfDVDybLJi9kxYH/eTSi84Gvsw33CSgBKgEneB
         bGl/ID+9/68mv2pqz76GCY8Z2qYoMdHwmXwwqlO1/y17lJOclXZ1rVZQJXmAZk1piz2/
         Jqag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073113; x=1747677913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJMyYCTFAIbu3EwtVFYHiNKkH2seNanmqLNgECsCQ48=;
        b=kfvmHCPKwc7AiwacNDxwhinJM0X6vFxxZxNjIjFJS+F6bLSQRD4RYVrG+yVs2+AO2q
         6e9BSMa7IpJF11ToRWm9Y07+4qRcxMiZST98ehx4r1vbPhLPqefBVq9BbpQx1/8/jnC0
         vgsDkfMgst1tq4uhFTrp/Hxun2fpU27ah0AFnA0/szCqi3hhtqjMN9Yrcc7wsJk/N+Oe
         3UnH/HuJ88kw2WYSRluX1CWmyT6YpJVjC6iqlNHoCvlm8OovMsftnKF7Sz9doHXVdjdf
         pFmyKbNE3nNb5FdOrQhcpG8JtZp3Po8fgKkItbqgRXvlMF+9RbX6NLnkrqqiUSDzknng
         ESLg==
X-Forwarded-Encrypted: i=1; AJvYcCUppVLxCVikeM4EPHgnkMBLeDGusXwoUKwFIE9q1YnesHIfs79hGKh3Hl0BJZbJT1zTc54=@vger.kernel.org
X-Gm-Message-State: AOJu0YzromfL1ORRjCeo5Q0ueoQAW/u0cDXh9LBy8s2Y4HlqLcgTLfua
	YYK0cFoLESDZNEU1weef2glRjVAhbE8xDdeaJWE5UizKVRtaUkPlNwiMG6R2bLY=
X-Gm-Gg: ASbGnctEFKCx858vvvjsy59dtcj7hnBaJx8CPPx/CoXUjCYjTJ2eN9Rrwb5Jt/7n1yg
	VVplwCIah7OOQNRtJh2HyTLDZ2x4cyrt9MfQLvKakDQhyFIcRfOq3d+79d2VgmGLc29F9rL3D+i
	FO4c/BkJ7YFpG1WaX2kwUN/dMfA1hgWNmHoZ7uc2xoJiPKBNKtISXPOSpxp7dgYvhSqqmXaTi6D
	zpzRq6GGD6ow2qOygqCbUadaeEupPvwg6xhFwwhBVkuHxgTJVP7WuC50DvFltPJOepcHCg9DiqG
	kbltN2CnQCbZeoA8W400s5wg5Bm1Lbt/Iwz+EzUb8A0evfixAHrjd5QFh0BgAw==
X-Google-Smtp-Source: AGHT+IHdpFnpSMK7x9VszJ7ESn4Xre+yM34qcZNm54/vUIBuvH533/FuI4IGWiU34ZcU4u+AyvAchw==
X-Received: by 2002:a17:902:c950:b0:22f:c83d:d726 with SMTP id d9443c01a7336-22fc8e99ec8mr190068085ad.33.1747073113601;
        Mon, 12 May 2025 11:05:13 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:13 -0700 (PDT)
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
Subject: [PATCH v8 02/48] include/system/hvf: missing vaddr include
Date: Mon, 12 May 2025 11:04:16 -0700
Message-ID: <20250512180502.2395029-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On MacOS x86_64:
In file included from ../target/i386/hvf/x86_task.c:13:
/Users/runner/work/qemu/qemu/include/system/hvf.h:42:5: error: unknown type name 'vaddr'
    vaddr pc;
    ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:43:5: error: unknown type name 'vaddr'
    vaddr saved_insn;
    ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:45:5: error: type name requires a specifier or qualifier
    QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
    ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:45:18: error: a parameter list without types is only allowed in a function definition
    QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
                 ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:45:36: error: expected ';' at end of declaration list
    QTAILQ_ENTRY(hvf_sw_breakpoint) entry;

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/hvf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/system/hvf.h b/include/system/hvf.h
index 7b45a2e1988..a9a502f0c8f 100644
--- a/include/system/hvf.h
+++ b/include/system/hvf.h
@@ -17,6 +17,7 @@
 #include "qemu/queue.h"
 #include "exec/vaddr.h"
 #include "qom/object.h"
+#include "exec/vaddr.h"
 
 #ifdef COMPILING_PER_TARGET
 # ifdef CONFIG_HVF
-- 
2.47.2


