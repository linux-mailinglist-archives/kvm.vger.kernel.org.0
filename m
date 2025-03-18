Return-Path: <kvm+bounces-41355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3667A668AC
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 05:52:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38C7B19A250C
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 04:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 760301CD214;
	Tue, 18 Mar 2025 04:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Mh7t/1+q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA1E1CAA76
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 04:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273503; cv=none; b=M1dnB08lY2ETwSA2d5xF5XlvDxinSLsGzzcZNq0S+2YWfVstkhB5ytDaQj9F98AEkMk96Iz6Y5T8y86JRjPFFnNZYU0+wqj7YFfh67JuTGMASzgiK5IGsbjilU0wVMYXD9MSxFpQ435qhgzUHvx0O+l/Yuf3g97v80Q8HBrJ+d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273503; c=relaxed/simple;
	bh=AlJxJ1V3OIfa8nEd9X/xqX+kJi7u+fJ4wLU1KzyMjYs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ST/G1Ziz89iyG7cM9iVGNaPalXA377N968rDU3t0AHzPqVq/yJ6HpD6yGdrzKH+9fNgLme4rx2uqTSD5wjEuYP/ldD5oxuP23M0kncGNbyE1R+qlwocU+ztwq0Qx/SoRGaUCH7P1TNF9GjKessemxNjwnMGQIseB6ykIVwMrarU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Mh7t/1+q; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2ff80290debso4298037a91.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742273501; x=1742878301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ovyvu8DCxOT3MJqFMX/qU9iZeR9dz9+LihTzZn+g4uA=;
        b=Mh7t/1+qipzx0lGSpDzXHI4y2ZGgTa4XcDGK4ITpqw6FtKyUYArF1WfCFiKO654nFE
         qFbWteMV1HbYOo6lcnzVHTshlz/WW6VUx2v5MAyaFq8NX3VH96I/GaC2tXW+LMT23Jzx
         Q4sHvfDc7Tjncc1i3nFhRdQT1ujOr5xwh2/H7zqGrKSbxSPk3Z4ZX+y4IrIHLNp8DHLZ
         Pyapp5SsxVyBmkcXyQ48d2ZY0CCkiuCjYrMhp6Z6WLtvAkdwWULFh02IIJXPDTvLY8w+
         7IiksNuNcot4uQBBibpt7fZ1UMliFnhBMf3CjWWInjEQg/y6yg9itx7gBFvozMoGQyHQ
         x3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742273501; x=1742878301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ovyvu8DCxOT3MJqFMX/qU9iZeR9dz9+LihTzZn+g4uA=;
        b=iEoOI1KrDSYP6RYim5Z5IZFKMEAUaDi2fuLd9z5D839GhNBuEl9bNhppffnl3p30+J
         Zkh9Peqxg5T5dgHMVIh7l7vUZ4hjqYsaD+CmaoWjGbsxHmkjWSdW0WvNM0RxStQMWkIo
         BV15GlBp8f5n1hC3bzPh7W3Q2enWHMCE7xdVw51I5ON6bTYNRry+O7GFNthyBsJAt4uE
         TsNJn3h70Q7QQYvPHMfz5zlAvimdehovZnh+X0GC5QKsQxpBoYiis9THqZeZgWb11phU
         5Kd+h/dIgZRLBnvRbsemmIx1gDV3ou/jEbVL1joYSgSoTqCBX5We4LlPgEFrhsdKQOkr
         Z7Xw==
X-Forwarded-Encrypted: i=1; AJvYcCXaxhuQ/0W0hvKVO8VJbpyL5Tn5BipwxG5/Ds9TAHIARv1zax9i8TFWD1k4Ivoaq6piKbo=@vger.kernel.org
X-Gm-Message-State: AOJu0YztaRO5cCmtgNA2B2Q532A+FFwk62FfrUxgwL/YAjX+q16UDe5w
	bKUuvGx+gqhwikwmdY+MfceIlIQ4Y3cusDvuymtwl1Dc2HmCT9MwsMzWsn7E8fiPj8wv0AAA1vJ
	6
X-Gm-Gg: ASbGncsuHk8jXeQ8lh/6vpEIDzZ0qOmLT+DYdUq30JVN8tjF/roV6EUtCWl8uQPbJpq
	N5W8Ab+NnCRn0PW1FHCj0d3AZEgcSr1KRddP1CV2rfhMwsbBUdcJPazm6P8Gk9LoY0FjrMfvj4I
	sSfkVihJY2/Lu2UakQbqkpbX4zaqyq0rWU+IJvl9RQ2bt14CvcMLEyddT7C2peV1MNzyT1Aj4ZL
	WloqQaot+l5d3BsjA2H+cdcy1rcn+NLPzxhhHu9IdC3ejQbDRKogCZ7gfS62kRPaR6c4vlBqOon
	CBOcdc8SDRfshQD2xDN1aQxnaTTzA1FxIvcuIaU9xGDm
X-Google-Smtp-Source: AGHT+IGpoy0HiXaK4W5rGsoIV6EB7nMCBdVrRX+IRN9Qga4zDbHRqASR/8vpI124f9RU9cNmPTSLpw==
X-Received: by 2002:a05:6a21:164a:b0:1f5:72eb:8b62 with SMTP id adf61e73a8af0-1f5c118eb0bmr21535312637.20.1742273501600;
        Mon, 17 Mar 2025 21:51:41 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711694b2csm8519195b3a.129.2025.03.17.21.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 21:51:41 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org,
	alex.bennee@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 09/13] target/arm/cpu: define ARM_MAX_VQ once for aarch32 and aarch64
Date: Mon, 17 Mar 2025 21:51:21 -0700
Message-Id: <20250318045125.759259-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will affect zregs field for aarch32.
This field is used for MVE and SVE implementations. MVE implementation
is clipping index value to 0 or 1 for zregs[*].d[],
so we should not touch the rest of data in this case anyway.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 27a0d4550f2..00f78d64bd8 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -169,11 +169,7 @@ typedef struct ARMGenericTimer {
  * Align the data for use with TCG host vector operations.
  */
 
-#ifdef TARGET_AARCH64
-# define ARM_MAX_VQ    16
-#else
-# define ARM_MAX_VQ    1
-#endif
+#define ARM_MAX_VQ    16
 
 typedef struct ARMVectorReg {
     uint64_t d[2 * ARM_MAX_VQ] QEMU_ALIGNED(16);
-- 
2.39.5


