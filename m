Return-Path: <kvm+bounces-49739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7508AADD814
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48CBB1947B92
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4202FA623;
	Tue, 17 Jun 2025 16:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wJMu5p5N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439A92EA73B
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178042; cv=none; b=DmQo+bn0aA/unVMT+tz4W4l9x++m38V+2BOx8Sr3rh6rgcx4oqurJ1KXw4fqskcyZzqFjXr3ZXrcaixyWDuFZXNCTQ/pgz678mgm1/g//U0DNCMSK2wJltGKRkVZsxtegkF3l/XqDQiGF7GGyFB2YFUlwn9tvhCcBeRmC4JEnVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178042; c=relaxed/simple;
	bh=kTu6dPkC4IOXQYvNvVqyo+RhX9lzJZQ4i7Py43tKzf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oW+BgbBIDA6TBfCMkaAfdYo4MmFYlizJXXbVhEeUIyX23b88hi84UDovFLN2PNJiyrHPTbxiCdc6WH801EhCtdrYIZGK7+dcRcVEU8vNXwXHBg2d++rLw72tSg92q6Fuz7hwkouTFlDKpZsBF2FAibO49hWWgwRX66QU8RtZrxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wJMu5p5N; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a54700a463so865832f8f.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750178037; x=1750782837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e1HQznq99qoCK8P8PgCsYfpPefLsvFqz98NOZI1uUSU=;
        b=wJMu5p5NuzI3nZGGVhwdrU3Iu0evDPdQesG/ec30X30+xauYGzw8DpYQ3wpZdPUuNR
         RphofUTywhFtFfuUMFvJwzm5PfSDWnWu6pfeOm/YpP2jhfKSquvjntX/PGoQOGpF7ylI
         5xdOuJdX3kCCyDTcgEmHxzld/MnsKxZFLkCQSFObtSx7EJIC0djZ55ReKqmB8dGDSeoE
         WeRRVRSjoAdMXHmv30AFQ3wMWFNtzV55+tcSdvZSP96d6vVYTDAzoL9pi4nkCzH8Jbaz
         NEtStuhJAWc+d7zZo/Axssrfg+uj13VMO7xv7G+OoIfkGVQOl4yq7NSanDBMsA40Re/2
         88KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178037; x=1750782837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e1HQznq99qoCK8P8PgCsYfpPefLsvFqz98NOZI1uUSU=;
        b=O7uEoJWkpAsKmoZVfT2rd/7OmODL/6EA9fFgoEADpV00MUbWJIhCLkBhgUAunc1q5w
         ZTq+WzBfHqCBIAMcauRWo2Xu3ML1Q2UZs5dg/Rq2wrv0D4KdXtMunrYxmQ4T5MAcVfyl
         oIfzXhFzvJLdRGDZE5XlXMM9n9V4b4TxPvcaWxqGlAqSLvm802Cm7xTcBDNqZ65Dhw50
         ilA/iC6CWQk8rQsbaXFcZ8/TGmk14pHznnKbfDwGlWoma27laojjFQnuI8N6tgFCL+6/
         2zE1XwK3+QdQ6BNaUSTblFlsouyHq3/ErOjAbWa/maD5xPV2XD09L8oVf59jNuUDN8LM
         m3lA==
X-Forwarded-Encrypted: i=1; AJvYcCVFK0xLZzJgIfDuZTvnFDzmkbX7W9DcgfBhxD8RaA8v67+RyDr9MhOSSR27/AygXQ/ZYeg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBFaMOrSRHuSWzSP82INnwE49ZpM5j8ny8hI+1f/Kd3Sdk5lVb
	bDIiuJxDO1jpOoja6dVWCRASaLzj9tSI0nYq82a7KoabW88yk60ZvNq0YmmVHQya0dc=
X-Gm-Gg: ASbGncuxnn9u/TxyFVc8FHO2sDqlq7GuvApTpqhrPL8GojiGXLX35AsCZ5eNOy/79Ua
	mFtqeioeg2P1S03+PePEGpTKTZPoIN/Fk9Fz4AIC0CvqEkqB9i7ZnWBwhD8bDlEbxiN0pGYgii2
	FclxaP2p6xfSAqx+OkDJPLZXgn1hOjXTKJKBIOB03oqWfEl9O4vQ8OMuh+82Y5POtJt9PU5xaLI
	CdSQEFJCeKnPOEL7gFssB7IDnYYdk+8NzGSJPyur0GKHFdihSN1ethCsCZjoLYm+Z0ouJobx6VD
	WyaIrz7ADGFSbC0cCsVL16tsUf9Uy3t/69hft1jk6rVpFDqTQUXc5SujmdrRQBg=
X-Google-Smtp-Source: AGHT+IEuOlzuLgIb55MubMss/sq0ETxsqBxX/tP7MvZTc4WF4bNrfAkV6TatGGs3YrMBZLde9xPYaQ==
X-Received: by 2002:a05:6000:64b:b0:3a5:8977:e0fd with SMTP id ffacd0b85a97d-3a58977e508mr2505193f8f.0.1750178037635;
        Tue, 17 Jun 2025 09:33:57 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a53f79sm14266546f8f.4.2025.06.17.09.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:33:55 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 91A355F90D;
	Tue, 17 Jun 2025 17:33:52 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Cornelia Huck <cohuck@redhat.com>,
	qemu-arm@nongnu.org,
	Mark Burton <mburton@qti.qualcomm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC PATCH 07/11] target/arm: clamp value on icc_bpr_write to account for RES0 fields
Date: Tue, 17 Jun 2025 17:33:47 +0100
Message-ID: <20250617163351.2640572-8-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250617163351.2640572-1-alex.bennee@linaro.org>
References: <20250617163351.2640572-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If the user writes a large value to the register but with the bottom
bits unset we could end up with something illegal. By clamping ahead
of the check we at least assure we won't assert(bpr > 0) later in the
GIC interface code.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 hw/intc/arm_gicv3_cpuif.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/hw/intc/arm_gicv3_cpuif.c b/hw/intc/arm_gicv3_cpuif.c
index 4b4cf09157..165f7e9c2f 100644
--- a/hw/intc/arm_gicv3_cpuif.c
+++ b/hw/intc/arm_gicv3_cpuif.c
@@ -1797,6 +1797,9 @@ static void icc_bpr_write(CPUARMState *env, const ARMCPRegInfo *ri,
     trace_gicv3_icc_bpr_write(ri->crm == 8 ? 0 : 1,
                               gicv3_redist_affid(cs), value);
 
+    /* clamp the value to 2:0, the rest os RES0 */
+    value = deposit64(0, 0, 3, value);
+
     if (grp == GICV3_G1 && gicv3_use_ns_bank(env)) {
         grp = GICV3_G1NS;
     }
@@ -1820,7 +1823,7 @@ static void icc_bpr_write(CPUARMState *env, const ARMCPRegInfo *ri,
         value = minval;
     }
 
-    cs->icc_bpr[grp] = value & 7;
+    cs->icc_bpr[grp] = value;
     gicv3_cpuif_update(cs);
 }
 
-- 
2.47.2


