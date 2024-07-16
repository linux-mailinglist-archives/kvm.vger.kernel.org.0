Return-Path: <kvm+bounces-21707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 272129326E2
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 14:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C38881F22194
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 12:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04CD119AD51;
	Tue, 16 Jul 2024 12:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="XKvbf9KC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF87E19AA5B
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 12:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721134258; cv=none; b=b3SvgZ7tc+CAa27HpbTSM68F9aVTZRvN7CrEpzLfLmGggns20cBSK20qFNUN6SOXlG2AqwASBYz4u2YFaXeU9nD4ZNQWcV7Txl/aORT3hMGu77icxxETfQ5+Vtb50aBoFZHd1KrrA9GqqQkR3sq1L2dz5VSqvX7yE9YVNWbLwOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721134258; c=relaxed/simple;
	bh=jrwt0yArFm3CPTwiARkoGA/UURR0W+T1QDJ5iEwGQkc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OKmjiobzPbINQKstVF3sNMn8/OtVM9uocZpd57Rdmb+88nFv4oCG2hJJwCVRetcrofDOWq0xwUK2euLw6tyUhBmaKaBEFwXHl0rcwdQ+AGkmPlyzW0HJRbzL6bl+nwCrZI7/yXdxZGahKXKVTRm6I4rDtlKtLN2er9EPeKGQJc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=XKvbf9KC; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-765590154b4so3226731a12.0
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 05:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721134256; x=1721739056; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VPi5Z5Dqnhv2/CUnyN+zY6OWPqGpJunZ/ZxJTeOyVqc=;
        b=XKvbf9KCedibzWw0aCuqAl21lmz4tz/fmKdhGn5yseDAc1DOymgBPbPolTTpNb3dNh
         OFn8sZUkV1euOQc+WoS1zSn2B8BWcuQjyAYiY7iYpKepCHjLLOjH/J2dIJZ4rtTg7KW7
         KvGTt8o/yw9HInYghsLEPjPw5qQC1LWlzrXPdRwkZSBYJm7pkXcVDieQRvPDer8ZCZ0Y
         OU6b3P0s1iL5lhPZVo4Vx3D3U84aTZ5rsNZIZAJX1F+TVGQ6ILq/TH4aNqJkNji3G85Z
         gItPTgth9qNt6gxLWTtkHJO+/YSs3p+hwEV/Xrv4Rmir9w8JanH/sbBaFNXcCetGU3SS
         uB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721134256; x=1721739056;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VPi5Z5Dqnhv2/CUnyN+zY6OWPqGpJunZ/ZxJTeOyVqc=;
        b=fP6bZ+lJ/k1582/sN410GI9NgLWxcDtFcnKe7ssN9cM6Bzru0cchlWbWutabZM2IQE
         Lmk6KfWaMss9F4LPGTvy3cKpYFgmqw5Tfnme5wzUxd22zJP91l2CindlyM93mD83L1X5
         9dUfow7/jvYIf8WdtShVrCXLnOdSGjdOMT8BMuzfZQV8DkR6VGm62TpFUQahTp+39ZhL
         tC1Lo1nv36jw0nL+It7D5wTf4y2lD5UkbPGGcroffRuBivGxfagHaQFYesNJHBGek+U7
         lXwWQoe8HUwBP5CDTaQb5fwBreUg0n/sfGd0bN2Dom4UJQo5Jd68YpCoPfcZrxNa0sQy
         EQ0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWG16UojWAGMpbQdb3+jN5XOhzBh8cCsojyp4xwhWfaZEDBT/RU/eRW3GAik0gl0sKMtKR4lA75nW7t3ACnbAZOC7K0
X-Gm-Message-State: AOJu0YzkdlIPJduFDu0xPXQMgOrsGXjB9UzPGW80A75/4ZAHKcVpsCRk
	zEHJZptPeIk0jBjcUIH6Tdbp8zb1fzu+oTDWBqI5NBxpF4FXxST41+ziPhM5z28=
X-Google-Smtp-Source: AGHT+IGiq7H1/utXn4jDP5eSrc47l3uUiIjjIuyDBP7855yWUI6xcCAqvptjtIWknKwAKTVj3TUcJA==
X-Received: by 2002:a05:6a21:10b:b0:1c0:bf35:ef42 with SMTP id adf61e73a8af0-1c3f11feb77mr1915725637.3.1721134256139;
        Tue, 16 Jul 2024 05:50:56 -0700 (PDT)
Received: from localhost ([157.82.202.230])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-1fc0bba7080sm57618265ad.89.2024.07.16.05.50.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 05:50:55 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Tue, 16 Jul 2024 21:50:32 +0900
Subject: [PATCH v3 3/5] target/arm: Always add pmu property for Armv8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240716-pmu-v3-3-8c7c1858a227@daynix.com>
References: <20240716-pmu-v3-0-8c7c1858a227@daynix.com>
In-Reply-To: <20240716-pmu-v3-0-8c7c1858a227@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

kvm-steal-time and sve properties are added for KVM even if the
corresponding features are not available. Always add pmu property for
Armv8. Note that the property is added only for Armv8 as QEMU emulates
PMUv3, which is part of Armv8.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/cpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 14d4eca12740..64038e26b2a9 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1744,6 +1744,8 @@ void arm_cpu_post_init(Object *obj)
     }
 
     if (arm_feature(&cpu->env, ARM_FEATURE_V8)) {
+        object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
+
         object_property_add_uint64_ptr(obj, "rvbar",
                                        &cpu->rvbar_prop,
                                        OBJ_PROP_FLAG_READWRITE);
@@ -1770,7 +1772,6 @@ void arm_cpu_post_init(Object *obj)
 
     if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
         cpu->has_pmu = true;
-        object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
     }
 
     /*

-- 
2.45.2


