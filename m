Return-Path: <kvm+bounces-41899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3DE3A6E8FE
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:00:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB7B93AC555
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0AA31A83EE;
	Tue, 25 Mar 2025 04:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TRELP91L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC5D1DDA0C
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878772; cv=none; b=NjYjzMYuAv3VZ8/T+Y8YGHI5kHZbNnnoNvu3nA9gbqcnYt36vUQPQsq6h62hJqKeEv8Yx1XAKWfDPSX+Ygg283MDk2pFi9O/dXbm8xosT8IoqXO3ZbU5LcvSzHLmUZK6xZ3y0Nfm7+HQFJDNI6YHGxkGYjJT7G38quRphTzBPuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878772; c=relaxed/simple;
	bh=yM0EpOjD3O7cPEmakcmBeAajXfqGb0gTPK/JNtDgWag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DXaxIk46Z9x/D72OMCu3H3E89AYNOyYntUwlAB3zY/ZIZ8YP8QUwXx7gFLnzyL93tGxC8K7Uo/UTTYnEL85KLvcr8TFBY4LflNjVSaJb87lpbd7k4SNPpDRG6KYOIHow7NBXoC+qUQ7veED7mi6iNFn34nzJVzpN0Oh2zotORTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TRELP91L; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-301918a4e3bso9479853a91.3
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878771; x=1743483571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4oOs5VbZVOvjmzXBjhiG3M4+ph6BhOZ9OEQr0J3OxEc=;
        b=TRELP91LomokUd/tNj1opHg/WM06HPfujE4trNGqnRb2iE1o/pTwQ+cg9UDQv6X79h
         CVBPgzcNsOb32v1w0v5ouwkGLMUN7yPOc3usDynQvbrGZqWzRB80pZLXoxhSABvDlb51
         PPIBWaHp9hWqZVB5U8X4AJtLjERG2ElBX3TbuwBh1iaJtC+vAXfg/X35F7cQPtj+z+Pj
         W8088UhPmfeo3pB9ou7lI48WZqFyhXgpuF1liF5RGuMWZTUghsoP23leth2grQJKHOx+
         vYjQPYFWj6WEMVEz1TXhW5w4rfVr39YUdhb/CMtB01dkkyTTwdHE7X6/fvKGU5dNjxsP
         HT6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878771; x=1743483571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4oOs5VbZVOvjmzXBjhiG3M4+ph6BhOZ9OEQr0J3OxEc=;
        b=O8QVSetGWFaMDXggvY6Nroc1aSY/GYN94ZSRHMKzufBnjsp0RNmC0wv2VAkErx/74b
         5DF9pFbuuNgkoBB9OyTJgP6YqbOpWuTQ5I9zHsGT75WjZab//V/VpAjJpxLnv6V9NJ76
         vZebQbQkAB4jYOyCx/9472G3B4P1cx1bPAhX8r9x5+BuBqfAt+Qs/4MmtFG19TMG65Kx
         sa9TdwRT87hNuqnchSCviRXFncUkmInFyJPbyzik2PY0ai0UoWM9Eikh8xFaJrekoPku
         Qf34wHstdUoMMDvN/2iHG6HujlYX9qgtnw3RRbhw3VyBrtnnVUzyDdFk+FRDeooSbkqD
         AYSg==
X-Forwarded-Encrypted: i=1; AJvYcCVaHWU5ku9g2t9wwlhTXAMf0Aq2i3mo3dUB7FXoRrjt/No+wH/PmnXfFTJejgIAv1KJk08=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuI9yV37YQmw4fLBHQb94UGkxThekzmHb3Ab1YAvjeEh8NL2bn
	rZaeM+BdTlYQy46b6Zgb9GXonrJxt59S4X0HkRL7fmY/g3wTCNZAIfkqVjFD2Ug=
X-Gm-Gg: ASbGnctdxjs5HefuMXuajj51fdrIthrVdw5DoKP4LoPlVbgtoxS+JGJLEEu4fIlJlFI
	f1J13drioz+Wb8F54pTGa5ETYJWPImPJilrkIyY9uB+wPB3SYG31OiU8PA2PUEPgad2dPfOuUin
	TrDZtZlbtitdZsHPxbpC1Qmxi3LrJplfGucyiJs4qWFSV8c3MD4OjDZpSMcJLZhEb3gtqmwWn6Q
	tu07TUWmTl4i56/TtHDLk6QmYEs8A/ez+oXVxJ7KPTe465CXcOnBZyKJk5GwLxd655J04UVC0Mp
	OVeanYF6EyUd0jjnitlJaZRLojxbeTAfPaVW7aIrjqygqTLbo8h+DPY=
X-Google-Smtp-Source: AGHT+IFMmlkYsXzeL5u3McRmsvIC3ugcT7OUO/5VRCqbHDoGqy5n9HjN6AzZXS/dqwuovLHKOYS3Dw==
X-Received: by 2002:a17:90b:4cc1:b0:2ff:5cb7:5e73 with SMTP id 98e67ed59e1d1-3030feebe86mr22119927a91.23.1742878770766;
        Mon, 24 Mar 2025 21:59:30 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:30 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 10/29] exec/cpu-all: remove hw/core/cpu.h include
Date: Mon, 24 Mar 2025 21:58:55 -0700
Message-Id: <20250325045915.994760-11-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
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
 include/exec/cpu-all.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index d4705210370..d4d05d82315 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -20,7 +20,6 @@
 #define CPU_ALL_H
 
 #include "exec/cpu-common.h"
-#include "hw/core/cpu.h"
 
 #include "cpu.h"
 
-- 
2.39.5


