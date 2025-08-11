Return-Path: <kvm+bounces-54419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7075CB212CF
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 19:07:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46D403E2FFC
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 17:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6945E262FF1;
	Mon, 11 Aug 2025 17:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pA+NwpqK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04322D3A74
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 17:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754931983; cv=none; b=AX0XnZJ0z7thXpuYg1PLpiNGPBmoTU/zDBrrpOCG9GmbkZtwL9Gon/0WVNZSOB6Fo28mHDMAGJeveOuKBY2W4HROOhhL5buv0v7CAaryPPoUX6adRzy/fg7+RzsuZC3smtKH33xAqDboORUeT0AvFHDlFa3jMSMy+o5dcHeISwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754931983; c=relaxed/simple;
	bh=biYhynh5VtlPMW5C9lkL839XZRJSsoYCWslawzM4S+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YfirIRqHMpIzQugYUw21xpnmYDo/5RpBgS8b76bRw7V9fUktBq8WYBuRqbSVxHlSjrhPkk/ToMd/0DALyCiagfo1T/adqA4c4/8IWM0PiAjWvciPDvvQ7OMhvTi+jcWSd57pfKQuW1KnBjCG5SKwmz0VdWF7a1XnStZmG+iKroA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pA+NwpqK; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-459e3926cbbso19381095e9.1
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 10:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754931980; x=1755536780; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hbl7ajSiNJK7b98o2AX/9HHrEnoB7DYhJ//FpfdP6jM=;
        b=pA+NwpqKb7RLvaBu1O74rZy6fouIVtHAi5JCEED4yGcGJliDXC4v2Uo0CvGleIl1/S
         njdArSRzeWnW2HWiu82k7t6d7isakTOraYg/pYalzPMQBOe5rQuuWrnd7SvkeTlTCBn/
         1NSBRoCaxkOMRQ+PGXTSaWCJVlG09rFSbZ/B7Gq6zOxKadJztL/TU1Z1Z4iDM1jWrn8r
         dMkLPCzfjhkDU/zxESUevmH7Gi4x2aRJLEkpv6NUeRrKk7wZ2A+gEbkGJRrRET8DmPhA
         +W6UfdqZ3pi1rThrxqf60P0xHo9akYJLB0BT4UZA74KiLxbCYg/OJTwr8Y0SwopdY3m8
         l/LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754931980; x=1755536780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hbl7ajSiNJK7b98o2AX/9HHrEnoB7DYhJ//FpfdP6jM=;
        b=HDwwxhYR4WTYGxGGexBK/S0yK5NSzkfMYwKGOT0u67ufmDY7d4IIvshiDXx+wYGuyb
         2oR2g419WFBlMNZ32h3jQY8cXhZYG3HlzwmJYEuTxMPRyO6VnL7bAH6aTh3BTNJ/baUq
         YRE8qoRUJxz15SX5Czco1oZWi55xmB3SuI82eUu2sJ2JY7fi7GItbVEuWXEVY1Zxp/43
         ptMJv9Jn+6Sy0fhp/ogkIP2JwWV8ujiVnt1h/6JnyV3Gud2F1clnMEG05Dx+Ay351wos
         LkcAAdobq1u4etSer5FS3QE4yDRmttTPfCkM6ahmWxL/JKjNsjK+/ox5gRzZ8ZcMgE5D
         mmqA==
X-Forwarded-Encrypted: i=1; AJvYcCWODEA3kLChqhSznc2dA2efw5/j8/XGjfTG8pcYo1BZ/5StEo2RUbCn4BF98L9bocMvuxM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuLo9YWzTGJuwxkxVf2edqINAMs983vMK/qy4ZEXU8n4R/KVnT
	Mjluy4FNxpER1yC/r28wh/doDa5+xWjMOAZWmDlz5e+XC2S4sYMoL8cmdoXyqJIilEc=
X-Gm-Gg: ASbGncudb2d7PvmR4jq7FYQuPCbWhxFoMC9OYdkgUQGixuwJ1hiumrcdcYVQmlU7oeQ
	V63Jg3ugbqLM1ik/iA/kRjly0GqroQkPDmA+cuKObmn8kICPmpbty3B+iyrkIeiQYWMqHbRTxBI
	TAnVIFbdt4yirNpcrxJbJTYPt9PkxLNR8YuMIAbnFRILY15Sl5a0TsV3wrrlqA7EK4FS3movQ9K
	gd/1Ggl4GpknvPbkHZEyrsZihFVGIlgioOAaOAMl0DzrNQDeyaxU3I9WmT3bGp/c+6q0JXjYBcZ
	1OC/IlsexlmPhJftPD9YLlzSi+GM4mvMj9SVmuku/V3VC/N7Av2pSMhRFaZG5ju1jN4rz7x1BX1
	sVOnjP8/UmEF+zA7N0oUik8mSTZfSnhU2HKm9UG4wm7H8cNB5HDbZcXf5DO4eoaclBJ/jwR0e
X-Google-Smtp-Source: AGHT+IHs9VhBLuyq5DxMA3Sqc0EWtw1Yz98FWwe/a6XU5QQ2lahjqbMswlIp69fYsNKRzJHrl1XcwA==
X-Received: by 2002:a05:6000:2886:b0:3b7:9589:1fd1 with SMTP id ffacd0b85a97d-3b91100eca2mr436223f8f.44.1754931979737;
        Mon, 11 Aug 2025 10:06:19 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e6214640sm272712305e9.1.2025.08.11.10.06.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 10:06:19 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Miguel Luis <miguel.luis@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Haibo Xu <haibo.xu@linaro.org>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Alexander Graf <agraf@csgraf.de>,
	Claudio Fontana <cfontana@suse.de>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Mads Ynddal <mads@ynddal.dk>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-arm@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [RFC PATCH 01/11] accel/system: Introduce hwaccel_enabled() helper
Date: Mon, 11 Aug 2025 19:06:01 +0200
Message-ID: <20250811170611.37482-2-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250811170611.37482-1-philmd@linaro.org>
References: <20250811170611.37482-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

hwaccel_enabled() return whether any hardware accelerator
is enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/hw_accel.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/system/hw_accel.h b/include/system/hw_accel.h
index fa9228d5d2d..49556b026e0 100644
--- a/include/system/hw_accel.h
+++ b/include/system/hw_accel.h
@@ -39,4 +39,17 @@ void cpu_synchronize_pre_loadvm(CPUState *cpu);
 void cpu_synchronize_post_reset(CPUState *cpu);
 void cpu_synchronize_post_init(CPUState *cpu);
 
+/**
+ * hwaccel_enabled:
+ *
+ * Returns: %true if a hardware accelerator is enabled, %false otherwise.
+ */
+static inline bool hwaccel_enabled(void)
+{
+    return hvf_enabled()
+        || kvm_enabled()
+        || nvmm_enabled()
+        || whpx_enabled();
+}
+
 #endif /* QEMU_HW_ACCEL_H */
-- 
2.49.0


