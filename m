Return-Path: <kvm+bounces-51325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB45BAF61E4
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 20:54:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05A5D1893FF2
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95361224B01;
	Wed,  2 Jul 2025 18:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AD+SyuJs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F912F7D0E
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 18:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482470; cv=none; b=qiCClOlVZJO8O3VWp9m9IXtNTys98A5KKEervP4Gax4afBlZ0bnLfQlQ6nj+WRAz0dFhJvvgXL60KON1835sQCC4WzLYiTgAD3Zzj+ZPtAe9ry3q276Wnvxva4/qnDEEeyTruzLV67s3/g+QZi3XSr6LCUP2cOlMK8qrs/jPXtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482470; c=relaxed/simple;
	bh=4KDm+9RfFQyZb64EFhKrtF4Y23m5BvXW3KljR85Cew8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L852fOtIUOfROop1Dh+IlXW3+4g9yddANU/xDLgJmUTdppiOfrviakhMXA7hVipCXSanxw4+ByQSP2cz/7JrPVM/tarVK8C8MdBwz1t2xOJ1PveLtJqEhk7sm5uBPVvc7lexM4Y57t3LRYzlAW0rndgKot8MuwZ/kuGAzAIa+jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AD+SyuJs; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a4fd1ba177so177074f8f.0
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 11:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751482467; x=1752087267; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAzT+CGbAi3kvmYQ13E5MHk/eJNqjsj98Rjqkr8WsQ8=;
        b=AD+SyuJsUSzw5NBUAo4JBLDGTfC6BmmEUWCM3euz9gvkaVD5ZJ4zCU5ptEZSALjPRn
         LF4zsi9Om7GdLL6mulsBF/Zztfmfsp/lqV1PAElD+/kK3WeSKPHA7kbo572oC8Z3U2B7
         Om48irRqdrDsKDeto0FXxW9lKBbQuCvZ059b/mYBxL0VWL300coyJcRpKF9SguLbvzmE
         s7C7tQOXbxDgPbiQwwwC7o6wsvjxhZ/IAi3Fi2xgdAqRURbREzzqQ19tfFa3QJs01P6h
         N2zAv6KGgceV4KSZ+idQ+eOMaEfMkUqTeYf4v56YmqHKNokL8b3OcDo62ZIlxsX6fzcy
         a+hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751482467; x=1752087267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GAzT+CGbAi3kvmYQ13E5MHk/eJNqjsj98Rjqkr8WsQ8=;
        b=uHaJxwGT9FS+/+0Z0iZeAlWA/3wh6DyL78Oy3UIshKx2noalms77OwJmCgYk/XiDui
         AMfTBFa3YC2K2Zsu+3PL/R3tpPrDzZyxXwM3EC8perFNJaTGF7KI4C+XzzB6FJAfcFdn
         3xv7oVWuBdRbJ8rN/XWfEnytfnWK1aGlwTiV7a+1ATsaOY0XXEff4GpBUKljvZoTmZMI
         f5NsLhZ0izRGK0V/ZJ20TlSeUjLTqXFoxdw+pD2hVkYsXeHpufTDPazjHgvC0sT56/th
         qRRr14ukJxP6XI0VDhRH6/ZCy5uFThblEr35xfaAtDdud+PhuAz3CNCiCQ8ef0AV+tzd
         4iuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCBLbbMUZ9JhZmhqJ+0Y6gOmAJNIOzN97GNxtUIzjfZpFVlOMDLVeBywA6ea1mz5CdNig=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSYUGljDFdyabYSnZIMpKdyEWAJ5kQrrlVO218gk6Chlyu1rav
	WY/NWvxdp8nD4IAMFy9oJBXhvvGrkYiEfZ1Uq0n3VSb2RRAzuB8VKMXpMuaE7sNHDYs=
X-Gm-Gg: ASbGnctXUPCRWi+CZ5OAH0auTqrOVLgYaUKQZuq3cD7GWMKwoKu7eDy/KVKFRa+E4cr
	Jg3oOhr8zNgrPbzrgLaKj6hN+mObAT8HfvToTH0w6ebEhnDdo+dSHzXFFGj66SGtFpy1ZMYvVCk
	Jmpiw/UC88Sh/wqzkkf6KGenC6xINwp0o3J7Dl0ZOe0jZmWmqNllE+ifSQE6afJxZiNL8iemYGS
	swPkja2XTQpbaKHdfpXbHpc6+NMl1e3No5qc9P5Kw3xwTsGO/dS5WtnxwRd6836wnHu69hnVzlS
	zBCJ5vXB3AQie74bu9ZT/oFERPTmCGX9VS8+ytFja2hCUq9y7kuaIJQFyq8ciP7BsE82dZyNPax
	9Jkvra6dwHeTjUixiPdQ7kAp/kWUmt5OGMKnM
X-Google-Smtp-Source: AGHT+IGSKjhsY9WI+hU2cySKNu1KrdU/ewxeUTc3VHcwvz5y1+FZQKQjtqw1T9mRm+ZdNPKinWfA5w==
X-Received: by 2002:a05:6000:26d3:b0:3a4:f7ae:77c9 with SMTP id ffacd0b85a97d-3b34281c504mr29220f8f.5.1751482466958;
        Wed, 02 Jul 2025 11:54:26 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e5f8absm16997747f8f.95.2025.07.02.11.54.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 11:54:26 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org
Subject: [PATCH v4 07/65] accel/kvm: Remove kvm_init_cpu_signals() stub
Date: Wed,  2 Jul 2025 20:52:29 +0200
Message-ID: <20250702185332.43650-8-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250702185332.43650-1-philmd@linaro.org>
References: <20250702185332.43650-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit 57038a92bb0 ("cpus: extract out kvm-specific code
to accel/kvm") the kvm_init_cpu_signals() stub is not necessary.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/stubs/kvm-stub.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index ecfd7636f5f..b9b4427c919 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -105,11 +105,6 @@ unsigned int kvm_get_free_memslots(void)
     return 0;
 }
 
-void kvm_init_cpu_signals(CPUState *cpu)
-{
-    abort();
-}
-
 bool kvm_arm_supports_user_irq(void)
 {
     return false;
-- 
2.49.0


