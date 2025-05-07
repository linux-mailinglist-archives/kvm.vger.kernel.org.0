Return-Path: <kvm+bounces-45798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F3AAAEF81
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54B6B503766
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6DCE293B75;
	Wed,  7 May 2025 23:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tYg6cm5w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB398293759
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661393; cv=none; b=i3gWRL5JbUlBZc4+hvO2XqMv9zQpHtSIKc39gsRzVJzXBQkvAEs8i3DPuVyK+ODSGi0+uowrlbY890AZQWER8zl0YiDJwEKRz2yVXLMV0zFvq6wVh9/YxY7RpXZrsJYMzxhq2uXCBKlB1wZ/DuPNFU4BZ7Ezb8ZJfDa6QrDcqrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661393; c=relaxed/simple;
	bh=YqO7si6OOlzy9ll+3G2BXeQ1hVT+gQZ2E0kYWTNKBRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUV7nvK+cYjNPqXHSPGfvVxzv1J8HdCzEEAFSMT3+CCMHV/XbF8rZhF36TPcnHINNIuENkdutHNglu6sJs/GpKyq6KHKOgUSR+axwXZsPi5bf330vXS2gpVYTpeTa8rbmci0bAKDDc5GiKReh4v19mR9xA/RXZ59sFi6afT0aso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tYg6cm5w; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-30a99e2bdd4so428988a91.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661390; x=1747266190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EMEP48GWxCsRSx7QE2iBFebS5MEkI8l2Uk35GcFvWVQ=;
        b=tYg6cm5waMCFqAEIxJrRztEZAX2wXU1fvytRd2cIEv4ohuOQoHJ1wO4LLR45iHD2qp
         VJg6yxdW4zC9MPg+yk1wflLdkIdMEniWCgImz/CzSVFe1nydhp3QzNMTc1ng5upT0TBQ
         wkHDT/Q4C+xwGmvm/HmqH+1l6bsnoH3qoGgKGlq5OQZmujYN3o/vcoBrnThEsATgdQR8
         IEL2/u8XrKUZK3P8JNHYcdR+FxnQkqo6bdpTkwGHh1baIbi7wPKHd059qj6UKPgU1ZDq
         +CymtWm4F9/8al9jVUIMO1wbx/CpHnHehgUSYN6sQmsDV+P8odW5ArMdowMQUSyRcAb1
         9WeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661390; x=1747266190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EMEP48GWxCsRSx7QE2iBFebS5MEkI8l2Uk35GcFvWVQ=;
        b=sant8pGAwHcNLy7bzhCZ7ei1s6nauJZ3MRP1fEl0MaLONhf721Us507iCnTSdpgmvy
         XD336mo7dcQNqCT+TxFl+axUg3bVeWn6Z7s4TZ4EEf8GFXxYBfHZilep+pReNuHM6PAo
         ZBwOpnaPW4CnXwqom9Is3T5YPR9M8JWSrGLDDvyBxW4s0iKAsDX/f9k+lQVHdopJijiv
         ioaAIclWV8HQ30qLTtyUnt2FilpDI75F6U2cHvAz9i0dqSGEfrDP0QqMQ4mTs4hhzzCZ
         1kHaAYNuagghfBFzVwAACjmUJMmKGPHVX+clrGC+e3Pa553rZodQpgZHoMJULnA3HhW+
         Fpew==
X-Forwarded-Encrypted: i=1; AJvYcCWNMAPvfySKqNd325MhHxRtpZ60udu2WK/1Q08gdthoj8NfwfHfFFbBJ7N02sQZ0tZp9Z0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYTmBeXCLoou1aTa4ElpTHvW8G6WnK/Ua5ZNOkcWWGQoXhArH4
	3C9+hSw5Cwcex8rHrh61wYGLG3NwICp59ARQHLbp6dOYRUzP03aLMRyWM57XXw0=
X-Gm-Gg: ASbGncs/wB46WMukpRI8kpo0fETQ+Ig1lfjV990gUn+X44Xqqvd0cVBqHXFi6lpIwqH
	0JbNH9ME4DHGz5sqSADWaDD6ldVbDhoYbESGcQnQKDdyjnqkgiA94F8Npea3L2h6oJ0EjdyOCjr
	KQ4R4doZZjzTewxeo3psAng9pu3I8x9hJ5KwyRpBNds44C1dUH47uWViEbZjyaSchWNsJBLx2qx
	08lvV9jZ+4w981A0kutAsABn3PScb2Muzi9aSJWwnJbT4KhD+MdqqRsrH9Qk0fttpvDtTWckxf2
	M2uvMDpRFibcU3WnsdyY6q4W6bFBxDAvuwQZ113G
X-Google-Smtp-Source: AGHT+IEcU9dnskRHp617G3UulVikylQpHRfLIGjQ/yGDH7e1z5HXtg/D6CcYwWudm0EWP3DH+uoZgA==
X-Received: by 2002:a17:90b:4c88:b0:2fa:15ab:4de7 with SMTP id 98e67ed59e1d1-30aac19cf0dmr9668869a91.12.1746661390062;
        Wed, 07 May 2025 16:43:10 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:09 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 31/49] target/arm/ptw: replace TARGET_AARCH64 by CONFIG_ATOMIC64 from arm_casq_ptw
Date: Wed,  7 May 2025 16:42:22 -0700
Message-ID: <20250507234241.957746-32-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function needs 64 bit compare exchange, so we hide implementation
for hosts not supporting it (some 32 bit target, which don't run 64 bit
guests anyway).

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/ptw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/ptw.c b/target/arm/ptw.c
index 68ec3f5e755..44170d831cc 100644
--- a/target/arm/ptw.c
+++ b/target/arm/ptw.c
@@ -737,7 +737,7 @@ static uint64_t arm_casq_ptw(CPUARMState *env, uint64_t old_val,
                              uint64_t new_val, S1Translate *ptw,
                              ARMMMUFaultInfo *fi)
 {
-#if defined(TARGET_AARCH64) && defined(CONFIG_TCG)
+#if defined(CONFIG_ATOMIC64) && defined(CONFIG_TCG)
     uint64_t cur_val;
     void *host = ptw->out_host;
 
-- 
2.47.2


