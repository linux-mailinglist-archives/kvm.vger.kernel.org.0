Return-Path: <kvm+bounces-45536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD974AAB7D5
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57CB31899218
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 465E334AA92;
	Tue,  6 May 2025 00:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jNCaqNMp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484D13B2F5B
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487254; cv=none; b=k5hkhmau2Zk+2IeAIIKt0Ho3p4gaRjKqXNaoe0zyRARcXLDHcYdj8Pyad8l+3XSWUxDyxp12moSSSA2XxItpKmk09pydqAT3Fthne1z//7NsQaY0z27iSfSP7hcYAHIX043FwIE19nt4Vgc0tFpi9G+O7g1LLQJzFRgTYJ3HC0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487254; c=relaxed/simple;
	bh=JFv4YlTrDm1SIM/o00YgUrqEFpXOxh+2IWOwbnFpb2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fjn8+JY2MhYWkMVkBnq6bCYiLipHTyzf25IFPJ+bqvFWmz+D42r1FS57N0vD2yboI0r4f6FIB4ciMQfGADv9i6m8e6MzVP87TygnBYqWBLlg6f3xaoD+DKRQmKomc2jcVilSA1FD/4uZSNfkqdeRPpvxEBnJtvBz1zxFYHUltbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jNCaqNMp; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2295d78b433so49567395ad.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487251; x=1747092051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rXLXuVNGEyfjK9Yd01QUJZvt/uyYRhxbr8cOAxNhYLE=;
        b=jNCaqNMpNh+bXNEwd6F++XyIkh2kwx1+j6HDxJXa93+Nl+UBtpmoHDCAp9+vWvIQ2Z
         jo9KPmapyY/8GGrYl2blNJSlAwP7wu/8RmC4Z2OZgfwsWr4lcQZhANQ9bmbv+dNFEiJt
         GjxbKWtHwn08EAcxdbmvmMqzRzwois6LUu+h1e1E/8AX8gh8Zma7FJoUh+5eWjhxiLo1
         fS3w4+Hhd/OmkyrLJ9M1Xp4eCsp4Gw4IJIe9yFAWHw2xsXFXm5JHrDELIsIrdGjBBe8A
         uLq8CWK01o6KVI0FiKhvS4NDyiWBgm6zgfTRuj4BeBxI2OB6yIqhi+5JaOkwE8VrcBsz
         P8LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487251; x=1747092051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rXLXuVNGEyfjK9Yd01QUJZvt/uyYRhxbr8cOAxNhYLE=;
        b=QA4iFmIp4WmVHaNUo1umnI/4ua+FKuK7g5fU5si+rkBdnOzY9Y68jvmaKd3LKe/fq+
         ZlKOGx/yPYxFV2u0m/qfpxuHZQ8gqqoUFh5VgVzgbgXh/VW1Sec8Hc3cILAoWPmzJH4t
         GG5KEG225gDg2fChm17rdhuhoYDZnhzD1Nw+uue9vp6VMdeT9wKhP0T5Lo57gorBYPOV
         uER+ysHBORiiu9+BjCs4kcTxvqAKM4/ILKep7wuurjvn0wRdJKOe2ZLFUGgKbT5NTE75
         B34yuA4BMkdFGmN5sMD5JqJywEo4MKyaieh1dr/ygFKMlukhqbCzqs3adZpwHoQd7yl7
         M+/Q==
X-Forwarded-Encrypted: i=1; AJvYcCV+13O/yAN2KF5dlNSkEVELPe8pZa8TC7HYZb6phcMCzV32SO/r2UVsLbJw8/VgHG7eMMc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxF3leUje4eV1eql1MCz9P1BfwEJuvqh9PZvyQ/300bIEtW3Df6
	N8Y9KApQOeXqnxM6R63u5imPLBDmJNutQKUkIfTFF9Jh27HfwpGdlsQ52I2Py4E=
X-Gm-Gg: ASbGncvAEX4QK7Lf6sWONUGwLmT0+V1nlYx0JTeE1WmwxdUf4kXiievUmhXuN9L6W6w
	QO08/NIFGUyNotV8OMiiznpUTkuRLSBrPlD7PRaAlVx+LazF6WKn4yCeruWPmYMx+ETQyZmmtpO
	xB/8D0jhhGaaFZO6yY4yGL+T/eAu8y9LHHq1FEE9Y/MI6WIFuxJ89zr5yh0PY5nK2HIDtAaacZc
	mx0wYnrie0umfrKj2RgU81k3/H7paPBw4II99BJi1pEr+df7+ug/edijilMjHRgzl2/8pcIOkwS
	LcjGRrxdp6GlfzHQCHAMyFaO+i2Yb2mYRusHNu5p
X-Google-Smtp-Source: AGHT+IEsUBiJC/ed4EmIFp4CMdEt2kVOvqBf+kcMrtQEGptIGUO9Gn+sgYxrtYlliG0ZSCN4Z64t6A==
X-Received: by 2002:a17:903:fb0:b0:223:88af:2c30 with SMTP id d9443c01a7336-22e32a50fa5mr15676655ad.16.1746487251596;
        Mon, 05 May 2025 16:20:51 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:51 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 35/50] target/arm/kvm-stub: compile file once (system)
Date: Mon,  5 May 2025 16:20:00 -0700
Message-ID: <20250505232015.130990-36-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 29a36fb3c5e..bb1c09676d5 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -15,7 +15,7 @@ arm_system_ss.add(files(
   'arm-qmp-cmds.c',
   'machine.c',
 ))
-arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
+arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
 arm_user_ss = ss.source_set()
@@ -32,6 +32,7 @@ arm_user_ss.add(files(
 arm_common_system_ss.add(files('cpu.c'), capstone)
 arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
+arm_common_system_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
 arm_common_system_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
-- 
2.47.2


