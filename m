Return-Path: <kvm+bounces-41898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A21DDA6E901
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:00:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6CDB17A3428
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 04:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D86B01DE3D1;
	Tue, 25 Mar 2025 04:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fpfbsSv+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E6E1C8613
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878771; cv=none; b=fN1h9roh8oh+NidAU+3IW42xQCvlLrypI8iad4eJBdjZwQZKpnjSrUqM3PPNKf/+mgfkVmYxOs66OmVmOWJ7RYFUV/LhXqiRSBkqiAkzR2GjeNkFoPiXLq3NRue02B9Vi8uqqYpXLkHElUwoyjIa4K2VkvA82f4f0lWTfPSCDdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878771; c=relaxed/simple;
	bh=piVasCmKgTUZXzlRO3aGVtpokwsP4hp92oBXPrtacbY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oVPBuYngmH0x0bNlEAivEXbDVJ3SOG2ywEKrx1WtsMSXDrnB1X+O9fjLC4nHyllDU8uwzftSaBSHY9G1hWLrO2ECjFXZtpcZQT4PVE30ikPKmtM/+kDMkVOZhbjIVE7FL2SepiGr5Qed32NTj5ypgKk0Vfmjcb0JZeXHk0G+gtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fpfbsSv+; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3012a0c8496so6518246a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878769; x=1743483569; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8rvUTTGe7RSowwob33glnfX6lSJ/LNSVbNxwketpLmc=;
        b=fpfbsSv+h7r0FueNEARxaucgMBrMtdbhYiwK5U3PyD07hV1gB5Gd7ePWPwHqv36ScE
         ux+RHmHqUoiIq4fRmCF2nHxz40tcJMtKEA1NFdXSLhmQAinC8p2GFnQLF5BjhFwNXaZH
         0GbMgrAUZaSL8ax04A1AjAOLgp4ZeNrZ69yE7nPHnKOn1+w0TbkjyglKpfT9XEa6Zagg
         AFarUBWf5QqaQE/Hx4DC87IZbl0AqQWQO7bQuIWGYCO4ZuuFYo3EAweZjEkpDGJd4UvC
         IUlWjtHzjpPJ2PP0iY83XcJc7t7L8qDSuJE/pMy9XMY2Mc6qnyolcr2elrawILbT/f8Q
         SAMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878769; x=1743483569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8rvUTTGe7RSowwob33glnfX6lSJ/LNSVbNxwketpLmc=;
        b=nlQU28282qATL03k095iIR8LDFW/gVAvTxfftF/An57Bf9mPnbpLBRO5fLcM8uRf+0
         JwJ+TmvcxP51+rWmxnK08vLSDmiq3x6kn6Ap9mLmFDsgm/DHx8Fhk21RWuTebR9pAJ3o
         B0jv2vg9ZiRadRLEfpuOWZRuv/wgE6z/EfvEkbTDr+ae99oQ+nFaD971W3SIsD7a7vkd
         T0qsFOC1JKuPT5yG5az8YpEdFSxty9NHWR84SjGMDpZxldFcQ9sxu4ikOWRuqAQS8iRE
         HzOuvEuJa0c9OsBKje/9bkf0kTjbBQxg4EF7P5HEECNIKCNGmydZC1YFQWGaoc4BA8lH
         ix7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXjjYNO1h0tii0xdt3GvvbcN/mPIM6zWrmgC1rBwymF93OwOt2l7qDI8OwnIRwSAAMGjwA=@vger.kernel.org
X-Gm-Message-State: AOJu0YykxuCHSap9el/6+wGHKv9Pu+fituPDN1wP8VfUEZubULV5RdIT
	yK2/cMVeYjyOGB4g3cubjAA5voFtO7j+PTI8ErPI7gs3MOYXn5N16yv+P9w8xxQ=
X-Gm-Gg: ASbGncuWr4A8aFWRbeD/5of3hqNqwWGD1ClQyNb8yv7JfQR66Q0FjDr9IzwcXNu/neL
	zTBgaXqWyHLRU8nl6jDNLOZQZJ81SFczoyhqkBC8Ccn6GnoCgdSl7t/PYOK1nJvQebA1e7sOLHV
	UgzFkiuaPL1oUzn7FETW8Cr1sapsKJOntVTFwV3HbpB3yNcoQahYGH0SaaUgZnTpNeKZX/rWx8l
	hqaeiTz96su6tMpc5+B0/0ivtgU4uaB74i9a93Q4qPX7NvritKS9e/Fd5/hNSD+7RulpUuvpTjI
	cv1tYK0YpKY8ltAsV0deUlrWysZog2wlqiijuJhQAZ7T
X-Google-Smtp-Source: AGHT+IGd5UXWo/Lkrytq7CX1i0u6UBOb0hauVyNgTE4qX82WgibZ4vfYtc9KuC+rTMrhj/xFHAo1Dg==
X-Received: by 2002:a17:90b:35c4:b0:2ee:b6c5:1def with SMTP id 98e67ed59e1d1-3030fe75747mr22925455a91.8.1742878768857;
        Mon, 24 Mar 2025 21:59:28 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:28 -0700 (PDT)
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
Subject: [PATCH v3 08/29] exec/cpu-all: remove exec/cpu-defs include
Date: Mon, 24 Mar 2025 21:58:53 -0700
Message-Id: <20250325045915.994760-9-pierrick.bouvier@linaro.org>
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
index e5d852fbe2c..db44c0d3016 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -23,7 +23,6 @@
 #include "hw/core/cpu.h"
 
 /* page related stuff */
-#include "exec/cpu-defs.h"
 #include "exec/target_page.h"
 
 #include "cpu.h"
-- 
2.39.5


