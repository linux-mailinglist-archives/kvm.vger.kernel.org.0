Return-Path: <kvm+bounces-51519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16899AF7F05
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:36:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9C1E4E57C5
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B989289E3F;
	Thu,  3 Jul 2025 17:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UeMqIZ34"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF792F19B4
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751564160; cv=none; b=YT3nD85yHXnN+GDVO59unrF/b9KmF4Q+Q65siYevzMcqs8G70YGtRbpcqk/6wk1750SPWXKf+x7x7bSHEkPif3cP/XjYyglHkCDH95HxmhjidyELvQPeKCFFmmu7T6QNA0m6UXsAEIG7vEL0D/8uEYDGrQqWbD7Kj9LQAvIGfGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751564160; c=relaxed/simple;
	bh=njPoXRQRG1yoBXiHFwkbShRx/OM2C3gsjQYmGVUpDHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vcl/mm3Tu7VCo2h11zZljLz1I92V3/ItjaGtdQurYV9SHIGYazCTISRvVHy0GG6hF6NRt9YehwdusxvXjbmW5LxLwhPVlsHvpetz3uRW9LvnaqU2H45px7edibpcIARthjGKCgsb9yp+5bZ+wCKccNzM6xTy3+cX0YJvx+4vbdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UeMqIZ34; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a4f72cba73so857284f8f.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751564157; x=1752168957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+kY7uW5JX/anEAPOjEFSJRgZ/Z18sVaGkA4phFJT/u8=;
        b=UeMqIZ34LP/cwqpYPY3qDayeA98xPiITX+G12yNXjnkHSU+PM/Y2sH28s1H9CWP0gk
         Qe/c4G+oNlfPnrr3yhFd6v2QS974C0bvcwf79qimXOfoJ+N5HA5zqVZp1mKUbf+l1B12
         rBQdZDoeCK5eFJ2nIGrEtrgYiwyAeaDDVXoD+OHx7epH0xRBqNN7gh0CXmXR7pJddPah
         34FwL6ApJ2c1+t6yKAy94ACEcfDEBLqIfnsOKnEnqlIbnZwHRPChp1Z5//MNk7qMog+7
         A1CC218pQvO3jRWWMuyYT4TD5RVTh1NaewL0ioKKv21dCNU+0DOyDK4csFDZiABh5RA0
         dwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751564157; x=1752168957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+kY7uW5JX/anEAPOjEFSJRgZ/Z18sVaGkA4phFJT/u8=;
        b=sHX4xthPuFUz5tO0E3M13EH9Sruerlx67GkXNwpvuG51qB9E+Xdmm6bvPSEyF/ph+x
         J/EPdcrKPXOYrYWULLdKk85V6IWFTGsXtmgi977NyF3XJtXF/bSYTsVmSiXvX5wFa6Rr
         yIVUOl69QwlMm8btBr3XT3tHT6z1b7l5YgwzA56N9aA/39wAFkE3tVsU0ij6A28BotDx
         bKMPggfGfs/DierdlDn9koynucmsoZZgRFLZkOee4CkjpoR5vVum9liiwxOjH/xaTXPg
         Vzwre5kR6y9rDOa1rWMfLIgAQrUja/vLyJX/5F7xvScSu7KJQBp+judRnFVxBl6myKa7
         QCgw==
X-Forwarded-Encrypted: i=1; AJvYcCUAkyR+ukQY3BFJY3PG3WvJDH/C3NrsDqWrmKIe8FGFVje1j7rQ7M4cMrsa9D8tXqZ4bvI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeYcVvUIwZImCit2RxP8ogn5wrhBxVixtIkxuS+HpEAFX1HZ6I
	hGFCm06DDMiJt8uVmn6cR7TN6RXtTtmYr/fn042MhvO3QybQav8aWxZeBSyPbdM+XO4=
X-Gm-Gg: ASbGncuTdLHjm7bZCI2UZvoKin9mDzqmXYHxctStSTeYJZwuQW8WC0mQ6xH7ublEyY2
	bY+dpYYq7YJuHoQAzclutA0yDUv3lL/KoZq9scaHVl5JwMCXypwCrJOws8g+22/oMcWUIf07EW6
	hUftG12zTLwLmxzC7YH02U264uGaimgbVFqPPf1CoCwclpw6KJbQ5ObGycwetSl7liLGIgMm6+s
	coeW1MddNzHgHEwrBMyodoF6+XY8RYQZB+140Qr983pAi2VF+UcMlbLyU7uqudIT6v/IDqYZjFn
	F6AwDLcPPovWrDeEjt03g2ie5nugCuCp2pDhN5XteKHcakI3J1qxJpLfqIWC63HhvbFoqEXeqX0
	btTRV9KRg/EjMfYuK8f9xFh6LkXMe4CNg0ozl
X-Google-Smtp-Source: AGHT+IEJthAlUnsrPZh7yceFyiLjMsbF3fhEwKPu5c0UU1+XM3fol5UMo8Y8THxiFaE4vLlTRN08ow==
X-Received: by 2002:a05:6000:42c2:b0:3a6:daff:9e5 with SMTP id ffacd0b85a97d-3b492c3d957mr48154f8f.7.1751564157347;
        Thu, 03 Jul 2025 10:35:57 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bead7csm31899885e9.39.2025.07.03.10.35.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 10:35:56 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org
Subject: [PATCH v6 34/39] accel/kvm: Directly pass KVMState argument to do_kvm_create_vm()
Date: Thu,  3 Jul 2025 19:32:40 +0200
Message-ID: <20250703173248.44995-35-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703173248.44995-1-philmd@linaro.org>
References: <20250703173248.44995-1-philmd@linaro.org>
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
---
 accel/kvm/kvm-all.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 0cd9b2f29ab..f1c3d4d27c7 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2470,13 +2470,10 @@ uint32_t kvm_dirty_ring_size(void)
     return kvm_state->kvm_dirty_ring_size;
 }
 
-static int do_kvm_create_vm(MachineState *ms, int type)
+static int do_kvm_create_vm(KVMState *s, int type)
 {
-    KVMState *s;
     int ret;
 
-    s = KVM_STATE(ms->accelerator);
-
     do {
         ret = kvm_ioctl(s, KVM_CREATE_VM, type);
     } while (ret == -EINTR);
@@ -2646,7 +2643,7 @@ static int kvm_init(AccelState *as, MachineState *ms)
         goto err;
     }
 
-    ret = do_kvm_create_vm(ms, type);
+    ret = do_kvm_create_vm(s, type);
     if (ret < 0) {
         goto err;
     }
-- 
2.49.0


