Return-Path: <kvm+bounces-45325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98C7FAA8412
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 433753AD665
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2387C17BB21;
	Sun,  4 May 2025 05:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w+HXSJUr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E686D1B3930
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336590; cv=none; b=CgcACJ7+0Q5XEq3blRjiV1yycsE5hIGSE6FS7t54MXdNoDprBB+dZQ/DEriF1UtMdcHhfOxitnsUCLNHKj/xCnQ1PtCQTXDaKlWvUzTC0D3FA47V9M/0YMHawsKJhzkXgEryNjVmpNM7TfyvBXBX05B4ywtgVT9s8C5CiW6gNMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336590; c=relaxed/simple;
	bh=xcabxzn/Z6HUqIvLlpT5e/w+21hxRUmopCLqRgt7ZX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQRxlOIR1Yd2QHvvbWtEQRvNr+FZobJtvgg7MQWTzC3Wk2hE1f7NHgNgnUR2+jS/2KHFubUB8MRx4tHzWvit8J5BnD8Wp57s2oSvifhlGIp3G8NueIbHZmADkJL9pDQ8v59EzFeyV1UbIu3aXS0ZB9//PXXLi2EpX9dMQIH2tIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=w+HXSJUr; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2240b4de12bso55784755ad.2
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336588; x=1746941388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZlgeH+rY7gWoAJ7wLcP0EAGnraHtpI1zUMj9EMPIpQ=;
        b=w+HXSJUrQ2B5WWDkAIlu4CWzXD2BGUCrAXLp+usDBls3BUSbC2Esu1QIz9X4fB1nan
         vr3Tyuv7EoCmkeL+IrY6ZCy0f/T2zzep6tBl/DKPQlKN3El7qLBHPe94Ktap6wAD3Z0l
         lYNAD437lfGOQVyBBeqQaIQqCcKICJN8Pu31uZpWO7G/Ov3QnXpS3QUmN2RNq8W2JDAz
         eZVum3dj/ascTalGU4tSEwS8kvHvzfBzwOwA3kNO+VkcuRhTpHcplYZ815d9h+qclYpR
         3cC9CQyv3r+K3e6kz84Hd/5U/cDdtSCDREORyA0N88Q49TY/O1BmaYFJ+GU+3snGZPkd
         MgrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336588; x=1746941388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rZlgeH+rY7gWoAJ7wLcP0EAGnraHtpI1zUMj9EMPIpQ=;
        b=GDbQ3VtilMXKo9FXOeIbhhf0O1sywjw6o3qPlqkE9b9aWP3/VyOpSsRW5sZ9oxvk/S
         WUwnD5b7JZMPzbaZVRL2EFo9YAn3ARWw/G2JBF//2MFtjnfgK3PFTIqjaalDJ24L5VQS
         G8zWNbMKLP3dNtbKjO0ibi/gMMOUtpH0eJV1ZpamHrluOF8MLkG3lD42vIwaU4yV8+Nb
         bYMd9SuvyiXHMaaVIoTrYCs/+9IbRh87+4+Y7EB4/7N/UOOUpJMKaYRlK+vPmSeHH843
         qYsbHPH0ja2gQBZqHyezkZMrbsVI+9aydAFWKDqrYew13HJ1ksKG9qVyFDmSQzPUxc1R
         Eeug==
X-Forwarded-Encrypted: i=1; AJvYcCW6RxF0Sc6vCnFj4ZqGmhvK9nKYKraSFrNhTUeR53tqRvjug+xrG52x9rvem2a561CQzCI=@vger.kernel.org
X-Gm-Message-State: AOJu0YySlTGdA+8fmflqU4H2bDRvrhU3nT4GAOikiDOGBlb9dUT7iMYx
	6VmSP8voAa2z9Hr+y9LwEovF07RdgCx0EunMbfRyb9PUovSYCvmKo+bEFWgjHBJ0sax3WW72v20
	WQ8U=
X-Gm-Gg: ASbGncvj6nUE+UK2GB40bU/QknI57lsRkO2LygtD5eGIkSKUPqZdIfsUX4w7uM3MMaO
	EEGg5d1s2yqIkWZ0BuFkoRLaXKFZ3QtiE+kFughdpsJcDV7HTGr+XbUM8fbLjtVu7MilK/o/sgF
	tek02ZcKM+DqeCm5wN0bPe8pu7iueKA+BfY+5WVxhJcWLkCC7xVSA+0o1r0XsR+xr9ONjE/DZaA
	lnJh4IX3qOQJCo0m73J/1iRXr0Xq4skvhIQpW6koZgNTx8ZhqnS18vshhOmKyxPOz+a49jvnW6n
	eVJ5dDEUfY0TNwqs+aMX+ILMjnQt2neTD081tpLj
X-Google-Smtp-Source: AGHT+IGvRnjHT32PK5YuBRc1hb6W3fJORtPLfFOYwa9VWFtEYD8F4Y3wY4BjdSzdWSGFbFMh9vP1nQ==
X-Received: by 2002:a17:902:d584:b0:220:c143:90a0 with SMTP id d9443c01a7336-22e1ea39b8fmr63196145ad.24.1746336588289;
        Sat, 03 May 2025 22:29:48 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:47 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 32/40] target/arm/ptw: replace TARGET_AARCH64 by CONFIG_ATOMIC64 from arm_casq_ptw
Date: Sat,  3 May 2025 22:29:06 -0700
Message-ID: <20250504052914.3525365-33-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
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

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/ptw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/ptw.c b/target/arm/ptw.c
index 424d1b54275..f3e5226bac5 100644
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


