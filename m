Return-Path: <kvm+bounces-51405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90555AF710B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:56:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2C5D1C8130A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7654A2E2F03;
	Thu,  3 Jul 2025 10:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YVVpVp27"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA9A2E2F01
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540156; cv=none; b=IfcmKuVWNpMizw6L8+/R4DeP9Sy10KYdbwTZ0nCS6WDcoSwuEdFuvKF9PPC9YfWYswk7iVm/cVAUooCUELv0/6sBbJ9sZEdb4LPtc8NZzA8Mozzr1TVb9xL2T3Ek/zRhZ65eG7n44Q58W7Whel9IK5HKTjeWGxKdGcXASNt/reE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540156; c=relaxed/simple;
	bh=bK2H4Sjxn8jIbqguLEyikckLKymu2OrHkt6J+D8cwLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VJqtK6fI7niyu9CIdFOFHFqAHoQ9XkW3ZelTf3r7yQ9VwHTjbVFnoSVNMkMlRIzWnaEsqJ2nmRvSQix+ne6XbRCihiyxuIAGbLGKWOXscmTyTk6Vy98N0RKxcoorDkyYDYDWp7zb5JU93QlWVXqbO2ERuo/OzQLa/9co2uHroew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YVVpVp27; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-451e2f0d9c2so5411625e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540153; x=1752144953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ThHRepOjVOPYIURDCNeQdikGEVpKaGb//EjFvlftJxg=;
        b=YVVpVp27PhxhfOi4Ar8UaZy8ZxPRIPnB5e082vxABekN9b1zFt4D4hi25wFEgSuTbY
         UOSqqEcoeRBhTk8rsuVx45dSDhEQmTBar8kTq7ATSlTzP9byzKAmaGtzmAXoSZKLj/Wh
         ARcMrPC98brvFueKz9HxuE8vfGYps9GWssGQPOla+Q3zuU1Udr8re4cXD6MllilLqDtb
         P36K+vWgbtMLYgnOs58BR3qbSS4kou89KFOYwXQ8E8BMbnI6N62PXxALGQ9OX4EMSsLs
         VHoooe/NpvYjvzJmCnWWPpSXSm6CrokQ+njM7kC294z4Ncx1SpFwHNBhsAWFHpZ90usO
         YbfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540153; x=1752144953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ThHRepOjVOPYIURDCNeQdikGEVpKaGb//EjFvlftJxg=;
        b=DfsfcJGFXKF5Mdx8f+2yARjtq3fhYvVJJdv7ov7EOg160hLiHv6ds4+o5M+h0/FNKy
         hre9PjL4iku5AV30CDBo/0IF7SzfZd4J9uUBIz1/3T6o75Z2hyMa/ZOMlo1o7eT27shf
         OhBBA3ErAjhcAqxsvlb/x5g+Vsr7cuJDhxwnzmwgmxUPN1CA737BgR/P07B0Ns5kcftR
         NCCy0lz+Q2a6mjmf9evqZV4ezAEx4vWPfRnlDMQDKAREMqM5wECYR9yYwF4qyi9GmHHc
         /WjkhWYCfut1RQW11ksTze+9Ty9jGF3GuKOnmS75V3KrBQ2DExWXE4zsbuqYocUrol1G
         fHjA==
X-Forwarded-Encrypted: i=1; AJvYcCVBEEZnZpRiVLeIJTzD25wJNFsBkbT/oTFu68BwJ4tTAPPIlJxTbaalHCZTOkfjlmHBWsw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzszd0Po3XFJ20lUGyn+J/33JIbFqhthVT4AHgvbVKoWqurTgMh
	n3eHbWPLP4iDs/blW8DMLV3y7Xa18BkG7s9N+W8J6uWnfjNMq4FqaH1ezsMju1UckYI=
X-Gm-Gg: ASbGncuCLFXKBVPoXjH7ewrJnSfovuWIRvI190dsNwAVyent8r6/Ry6ANCejI76Ynvg
	ZGVstwa1awSrF/dsBBQ2XvwgvlHHEOHRdm4uv9Q1gUcUVNqa6fS/kIPreMS/GhXVLxPypVzi9bA
	WwIzQUSObSJiFuJVaQT0+a34B6+hRSfxVB/owHRS2Ml9cihlVXyf2sHzK3Jue7Q4GqESEuMzrEj
	6HCTk8dxG9Rmjvg/ketgaVzZ/NaTpVYHHwuXmbKaJjxs367uy4mkNMYr9r0cstDxHppFCBfldSt
	Afrz+UASIqxlZ1ElktKQfZFRJ4KOHTQK6l9F59uGi27zV+r3xaxSeRWW55QMFGStAlQq0PEJnsU
	s+/1dlb+hsf4=
X-Google-Smtp-Source: AGHT+IHIbewtIS4hSJa1mCuaiIjfjhd4Oy7tVjRfFIBcswnH773BBovjpNdcNQAcYJg3AxkQMprC2Q==
X-Received: by 2002:a05:600c:3f10:b0:43c:ed33:a500 with SMTP id 5b1f17b1804b1-454ab34622dmr22498465e9.10.1751540153083;
        Thu, 03 Jul 2025 03:55:53 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9989fcesm23254235e9.16.2025.07.03.03.55.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:55:52 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 02/69] system/runstate: Document qemu_add_vm_change_state_handler()
Date: Thu,  3 Jul 2025 12:54:28 +0200
Message-ID: <20250703105540.67664-3-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/system/runstate.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/system/runstate.h b/include/system/runstate.h
index fdd5c4a5172..b6e8d6beab7 100644
--- a/include/system/runstate.h
+++ b/include/system/runstate.h
@@ -14,6 +14,16 @@ void runstate_replay_enable(void);
 typedef void VMChangeStateHandler(void *opaque, bool running, RunState state);
 typedef int VMChangeStateHandlerWithRet(void *opaque, bool running, RunState state);
 
+/**
+ * qemu_add_vm_change_state_handler:
+ * @cb: the callback to invoke
+ * @opaque: user data passed to the callback
+ *
+ * Register a callback function that is invoked when the vm starts or stops
+ * running.
+ *
+ * Returns: an entry to be freed using qemu_del_vm_change_state_handler()
+ */
 VMChangeStateEntry *qemu_add_vm_change_state_handler(VMChangeStateHandler *cb,
                                                      void *opaque);
 VMChangeStateEntry *qemu_add_vm_change_state_handler_prio(
-- 
2.49.0


