Return-Path: <kvm+bounces-51462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66C52AF7167
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:03:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9E925277E3
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9F552E49AE;
	Thu,  3 Jul 2025 11:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jJ8dNiUC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF892E6105
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540456; cv=none; b=nXqCLPC77fjCP+btbVNkGocSK8bTWJvfcuDRBzHh+PR9ayJxqqDKYg6D2gC5/Xq9CI661nsngQLVsWZ1D4rwyQ5+SK/RwawDEseccJ9K7EoqLSZtIaot/WWQthntDcEdSSSDRst6NVejFVJIL16w62Wcw/jwwVCFnkmkI8j8THc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540456; c=relaxed/simple;
	bh=3I9R6XXf/iyArBCM+fTAAssnAMbMJbeOaJnuYHW/1aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JjaQrV8WahesEKLlnXGQiRdjEgsXl5Th8V9Mb+OhmNWlLohHcwAGvEHiB8qI7mKYfqZX1+zw9aD6dyLlXms8ul+iZwxVCTCro1rdk5d/v+Uyu4kBwyfZtgDpVp3zKaC0unj9LO9yUm+nGKOAw0gvH1lG5dcx2wc1g/7FR6pTC6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jJ8dNiUC; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-453398e90e9so44655125e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540453; x=1752145253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KYagbleC/hcq8JgGV1mXFBe9rSbch4M6pqZHxCjKKEU=;
        b=jJ8dNiUCtAQeLnJGJ9u94XZaWwG2AitnvwjGoKBhKprmhpCtAHsccmnHkNVdbA2YTO
         QJoP3hffMJGQ5xDKYK6uJA4NOf+LYWrppofteo8d4lt/hi4mJdAbuzv9VegFK3+0aJYw
         5tNr8OpAwRoGjuAr+reoi1TOXEIUZpyaKfj9LDKKM1wpe/bTz4cf7LiGjcuVUT1C8kBe
         954beC+gK1TTfZTep7mSSL3Z18/jYaeNqPX9Q/dXj3muaYGSlqOr8935A74BYADzU9UH
         F20lMX/CTjSKROrBm1KnbHcN4XiDAVhO3nNkcM0EwV9TueGZ4eB3CKUKC6jwQUIlqY/E
         m5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540453; x=1752145253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KYagbleC/hcq8JgGV1mXFBe9rSbch4M6pqZHxCjKKEU=;
        b=B7F6GnydfojCmew2+Y6mDxLuvHBpXVpXCyL6DstQE9PNGWwkexdn1ISyHzCbQ5RKfS
         /3/J6cFqBDzBakGD22kTuVRZtPGIhz0XrrQQ/mZr7BZ3CrhoOxTYHk8+JQ7+oMyQTQu8
         enEtQdGGlDBvyYUzqx0Ck4J7Pgjgg+ded3YUn/uHxXVOHV5zTXXnTq8NIBedGsP05lmj
         G4jmMjqAuETPpklGLzoQUvWoE1m4t1ETzvqvKrzdKXfMKlG3xRdxkX7E/PxNnussW0Uy
         MIl7edvYMWtkKLgvDfF+6hJS/eOFSoXxlDC6L95RJgPLP/yebECHdRrAgygQAUA8og4B
         GCDw==
X-Forwarded-Encrypted: i=1; AJvYcCVhtdRAE+L0/EFwNGfzHhNEqnAqITdQOkvsVORSQlvHQaw5jwOvHJHM0GhQEi6Lj2qd9oA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSvuYcDd1ApVKBg+50ybrt/nU9Yc/x7wGJiTJWDTeb25NIrP/t
	ewPzdJQ6eQAa4cR6H4SB3f6cHVi67PRBPcb03cCGFbkFJpG/5VVoJISSx97FFDZwHsM=
X-Gm-Gg: ASbGncsgFsX1z+Vecq7QnVr23ZopeDXHzfVaWppVlY5xd+Ilb7OU871zMF447BW94cz
	VRk9nxZxqQ9FFyASsVwMJre9zU/I1tghvdpeZjFdGYPLUxGXS7B9wm8SqxwSMRacoZgceHgW5Hp
	CsQOEGNhGBN5kcbnXwULhIoo5dVfwZd7SZmrjnbMDEpd5BJzNU9xbT03+g/jigUCbcVd0S4Q0TC
	ZD2LggsQJAuYYZ+IaHtpEAxa1B9xrv7cIxLFrfU87hYU9xm5deKxyOcrmw6q9qH2wwnJHTk3Daq
	WQP4iy4sZuq+gcGmsIXMalRnuPUQGJC4+0Log6Ud1/V/tlXtUJeLHtBZQOXLDmebS2PTNJeur2z
	gtNSqvAtgIAcKqQiJVTVEMA==
X-Google-Smtp-Source: AGHT+IEUZBSTMiRrfLofYu4N1i7N32LdP3UEB9PeAX2Sv3szBKCnYkogmOlR7j4MaUfvKnOWbwm7rw==
X-Received: by 2002:a05:600c:4ecf:b0:450:d3b9:4b96 with SMTP id 5b1f17b1804b1-454ac2da3bfmr24724685e9.13.1751540453164;
        Thu, 03 Jul 2025 04:00:53 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e62144sm18639506f8f.92.2025.07.03.04.00.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:00:52 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 59/69] accel: Factor accel_cpu_realize() out
Date: Thu,  3 Jul 2025 12:55:25 +0200
Message-ID: <20250703105540.67664-60-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Factor accel_cpu_realize() out of accel_cpu_common_realize()
for re-use.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/accel-internal.h | 2 ++
 accel/accel-common.c   | 8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/accel/accel-internal.h b/accel/accel-internal.h
index d3a4422cbf7..b541377c349 100644
--- a/accel/accel-internal.h
+++ b/accel/accel-internal.h
@@ -14,4 +14,6 @@
 
 void accel_init_ops_interfaces(AccelClass *ac);
 
+bool accel_cpu_realize(AccelState *accel, CPUState *cpu, Error **errp);
+
 #endif /* ACCEL_SYSTEM_H */
diff --git a/accel/accel-common.c b/accel/accel-common.c
index 24038acf4aa..de010adb484 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -122,9 +122,8 @@ void accel_create_vcpu_thread(AccelState *accel, CPUState *cpu)
     }
 }
 
-bool accel_cpu_common_realize(CPUState *cpu, Error **errp)
+bool accel_cpu_realize(AccelState *accel, CPUState *cpu, Error **errp)
 {
-    AccelState *accel = current_accel();
     AccelClass *acc = ACCEL_GET_CLASS(accel);
 
     /* target specific realization */
@@ -147,6 +146,11 @@ bool accel_cpu_common_realize(CPUState *cpu, Error **errp)
     return true;
 }
 
+bool accel_cpu_common_realize(CPUState *cpu, Error **errp)
+{
+    return accel_cpu_realize(current_accel(), cpu, errp);
+}
+
 void accel_cpu_common_unrealize(CPUState *cpu)
 {
     AccelState *accel = current_accel();
-- 
2.49.0


