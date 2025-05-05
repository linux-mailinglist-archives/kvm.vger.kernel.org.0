Return-Path: <kvm+bounces-45353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1E4EAA8AB4
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:53:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08A0A172598
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E8F51A5B90;
	Mon,  5 May 2025 01:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mieJ7t0L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3358A1A0BF1
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409955; cv=none; b=MxWXb8V3P3bvQlz21/fm6PTeXghqQcNPETIhV9aKRu6b5RmYXszkUp71RVo0JVAvBhpUU9q7wMgvtdFBOBMckQGnEYT1cr652J/MYMDEeewDpsxHTmzRV37iuXMubByoxXvz4EDR3DNzgdgWImwLEafvJAtVyCTl9c3fvY/I7hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409955; c=relaxed/simple;
	bh=1hAGtngwcXI/K1ZVwOSxlRZCzxWzI2kpJ8rbj0YHGnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7YtuAIBCEwm9kKu0xivgfwhXJcmdpzLYL8BR205Jq4EIqEHRBiYqtsOu1xkBD3lfTu4HWN+P59yy2YGYBdtNJdPm5pjQh86NCyWqkbc67TwWK8C5LBecd+OW0TDFuxUpNgmzHm4RpBdJkWsK5qF4KN2EPP6Uzd9iFWJFaQ6U/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mieJ7t0L; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-736c1cf75e4so3409485b3a.2
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409953; x=1747014753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hckfD0sziqBh1sSWGP9c0OUCVTgvBeVKgVHtB7xMeJ4=;
        b=mieJ7t0Lu2JvFwS4e4RfJzdv0cFMpB2BfQ/lMd+xFX/n3IM0TuoiDkWT6PR/O2eFt1
         dA2QGEWjT62qbexkQltu3Ael8r6c/yNAuur1BTlSl/arnr4SrMlsQFQGb1JULX+6TXYP
         YJ3DUzUJj55J+fd7vnw0fY7Ob3TqcSHFmbNFMCszJjzJNtgex2Ei2mqLh9CJ+A4kHWV9
         hzSpW1S9V1Y1g8FMtVAM69InbuiWYfRKvDONC3pA3ngGeRwGRrWqX+EcZ6RsDeECC8K7
         1b5sdJ29n+RzBevg13lvKPMM9UIXoWkwj5/GZjgT34vBT+Fh4DVd8QLnPtw84/8pJP5+
         8fYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409953; x=1747014753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hckfD0sziqBh1sSWGP9c0OUCVTgvBeVKgVHtB7xMeJ4=;
        b=bgK7UGhI4oxl3fI42k3/BSzfo2o+V/+xlCIvUkK/C6jsAw/jjdcMjZ4efWyZgkuwYh
         C2OOO8tGqhhaZnxb9RnC/GdLe7YfqXBG5PYkJyBVevOW4NbCB5GiIQgWHLT2wkTcsQKn
         RtVGgFWCeEmEUR3o5efrsEy+CAuMlMceZ6S5eu79zgn+gMf1RUkCodCcX5cv7O7zZums
         baAyybm2ySSTKIQuo3lE31ZUwuFXKvAfkxct5YNVd7mXlmH+f8SH1P6RT+rNH5GhrcI7
         By0WRc5uvVihb/Uy9SzKsHJn24F329ToNy7gknF5sQl30HtJ22DzlPY+D+AIkp/WcXxd
         ZGfg==
X-Forwarded-Encrypted: i=1; AJvYcCWksUfsa21vVy96w38ZZ1DBKC+TNH22DycwzHkwRaJtIqhdeKbOVzFw6fIN3RgKx56rdvY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzM/qDiD1rYwWtxAJxlISKxX/5EinDAQTSErpVERRgruYdMHFFI
	sFvoNi3Hv5Hq1Qv6v8kceCCTMI2axQi3wXpr6YAWNrKIqeZJbCMvigYrEYQajoY=
X-Gm-Gg: ASbGnctWq7b8ogUY+QvQer2J4vDUl7wbG3nbHvHH60czObSe+tKmvohG33jWZfy1qCT
	3ND7h5gXV5p3/h61EzRpZf5fJrdf8Vbj56+gOhHgnSlscTuroQus9vmfyS4bQbUhS65MAisGyOk
	/qMcOqtUbJQME4b43DFuxzDNsj/bmcqnSL7/GyPNz0G2ItdQu95U2N8s6Iz7RDum6T5K244W4xj
	uTZvB4QfYYSRZs4l4+l0hlzxfcq8cNU456nLtk28IMYzDH75IqRnHZ3x26+nXgfmX7ymC7SI3Da
	ehPhnaKM0EtdAI0JEQyaBc3D270Jr+Ieh3p6mQvO
X-Google-Smtp-Source: AGHT+IFwncbL/3OpuXVRzOUuTtFA0UcYGtHTDKFtJ5+PikCCokHOgPA7NXr+7+rU55xaMgEVDb7NZQ==
X-Received: by 2002:a05:6a20:d049:b0:204:4573:d855 with SMTP id adf61e73a8af0-20e9610a742mr7965931637.9.1746409953485;
        Sun, 04 May 2025 18:52:33 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:33 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 06/48] target/arm/kvm-stub: add kvm_arm_reset_vcpu stub
Date: Sun,  4 May 2025 18:51:41 -0700
Message-ID: <20250505015223.3895275-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Needed in target/arm/cpu.c once kvm is possible.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm-stub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 2b73d0598c1..e34d3f5e6b4 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -99,3 +99,8 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp)
 {
     g_assert_not_reached();
 }
+
+void kvm_arm_reset_vcpu(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
-- 
2.47.2


