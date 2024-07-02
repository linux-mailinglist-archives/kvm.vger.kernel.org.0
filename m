Return-Path: <kvm+bounces-20854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E485B9243A9
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 18:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55FC2B20D12
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 16:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F011BD505;
	Tue,  2 Jul 2024 16:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VwWv5awd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657C01BC094
	for <kvm@vger.kernel.org>; Tue,  2 Jul 2024 16:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719938121; cv=none; b=Z8fLiakXwLgvQKrYk+C4uscOUn9rrhci/QuyX8AkirmiZYSidBrsLmwAxZYEMlTIPlj5NxArI9ncRC+T9yEZ8M1Q8kpVIQO1CVAt4ZiH8FL5Mxwydz9xZASBPzmVWIBsQ9HcJjtZ7AWmMrGLJkEDFQ1GIqPa/DWI+oobdnkqs+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719938121; c=relaxed/simple;
	bh=lygSVGqEW/V5wPZ/noOw52DNAd5cGOkDdbbjhHZVY1E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YVh2VX4/D81UC2w0MQUaQt27fwz2ZgiyRMok/XZq/BJH6BslCBXKrpmsVfwz3h/sPm6hmbMTPjfOxi8/QsfCdUM0+XCRS3M2bJKM1cdA4DGCJC1Fa2pR9k8wbqsPTGWLML1jFiAAAQHq9fGyyGJbrmJaaGXIba0Y/pvFJeUd9Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VwWv5awd; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-58b5f7bf3edso676631a12.0
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2024 09:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719938118; x=1720542918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=26ibk6G5TBJ3+G8dW2FBwDssd+gYK6j25tet2PWM190=;
        b=VwWv5awdijIG7LqOR/4YbaOmAdclOYoGRnz1ZLcctqUzOG7nPPZKHDW8nRL4+PTITm
         Nfd+g95x+jKS61YJwc7EibIdbfvP/+YiXlaaUDx1dkuBxTiUg/f4CnOBqYMBPmKkIpO5
         QV6/JpL0H7X7oGlwO6J9jPGFEyZA/fuIeCRP6OpJFpogK5ALuVIZXAw1hVK+lNPmrZKy
         C4EQJopILqz2H/GVLUcCBdhRbqeU+SGcLJXQwoNsaEOaJ080x+RQo9WQ+4/ar4UpGWp7
         KozV6soaYMxOB56Aq2Df8E0Vul7gO/mrEg3YLvv7mjgd0lF3Q03q9+8QZe8rojekalMs
         I8Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719938118; x=1720542918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=26ibk6G5TBJ3+G8dW2FBwDssd+gYK6j25tet2PWM190=;
        b=a7fE9H+7sovDCxBiqxUE+fhwJIxA7Bhwxq4si9Dj3xTzQSkB41hP5mEV0/UVOCTFpg
         ThxdewNiMWTznTjU+A7XT8vGQH2VxcpDWJWj7rDOjKFvDihtnO9BJx4pYrryDzpo/YBo
         GV2Xh9Va3R6NLtdu2L+lHYTfcmbwoWuY6rwCndcDs1ryUJIXnvGQqZULjWOhcjztBR8y
         WlRSGiDQDybgfI8qlYyAD2S3r/icSENPIFFfhSQulSYM0bEP+9wNUmxK8RXjAagVNi9L
         iWD1w0x5oDfvsDRQSXUmTx5N2ESWz5GBFJ93rKzD8uZpAdH1m2XLzRZrdKRmMpJdWDZP
         IFsg==
X-Gm-Message-State: AOJu0YwCBgym2b8f2vFAlY0tGTRJUtaEKlAm/zLkzD1JErNubrcnMW2r
	jm9lIET0hGEMczlN5+DLOquQkV2H/TiR7t63EhMGiOSU9z5KbJmNKeGie1JOYz4=
X-Google-Smtp-Source: AGHT+IHBhfNB7jsgIlUoHE4OPYBRUkv0au3wXdb9DmRC6/b+bjRYvNJ2M/3/OHm9YVxoyt5+KFsgIg==
X-Received: by 2002:a05:6402:5203:b0:57d:1696:fd14 with SMTP id 4fb4d7f45d1cf-5879ede2704mr8832949a12.8.1719938117526;
        Tue, 02 Jul 2024 09:35:17 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-58614f3d3f1sm5874972a12.94.2024.07.02.09.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 09:35:16 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id B60F55F8D1;
	Tue,  2 Jul 2024 17:35:15 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: pbonzini@redhat.com,
	drjones@redhat.com,
	thuth@redhat.com
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	christoffer.dall@arm.com,
	maz@kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvmarm@lists.linux.dev (open list:ARM)
Subject: [kvm-unit-tests PATCH v1 1/2] arm/pmu: skip the PMU introspection test if missing
Date: Tue,  2 Jul 2024 17:35:14 +0100
Message-Id: <20240702163515.1964784-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240702163515.1964784-1-alex.bennee@linaro.org>
References: <20240702163515.1964784-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The test for number of events is not a substitute for properly
checking the feature register. Fix the define and skip if PMUv3 is not
available on the system. This includes emulator such as QEMU which
don't implement PMU counters as a matter of policy.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Anders Roxell <anders.roxell@linaro.org>
---
 arm/pmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 9ff7a301..66163a40 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -200,7 +200,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits) {}
 #define ID_AA64DFR0_PERFMON_MASK  0xf
 
 #define ID_DFR0_PMU_NOTIMPL	0b0000
-#define ID_DFR0_PMU_V3		0b0001
+#define ID_DFR0_PMU_V3		0b0011
 #define ID_DFR0_PMU_V3_8_1	0b0100
 #define ID_DFR0_PMU_V3_8_4	0b0101
 #define ID_DFR0_PMU_V3_8_5	0b0110
@@ -286,6 +286,11 @@ static void test_event_introspection(void)
 		return;
 	}
 
+	if (pmu.version < ID_DFR0_PMU_V3) {
+		report_skip("PMUv3 extensions not supported, skip ...");
+		return;
+	}
+
 	/* PMUv3 requires an implementation includes some common events */
 	required_events = is_event_supported(SW_INCR, true) &&
 			  is_event_supported(CPU_CYCLES, true) &&
-- 
2.39.2


