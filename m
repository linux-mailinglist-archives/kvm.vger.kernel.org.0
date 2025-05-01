Return-Path: <kvm+bounces-45056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E70AA5AE9
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:26:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BC9E1BA7648
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDBE826F461;
	Thu,  1 May 2025 06:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kWtI0x9e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891E727CCE9
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080658; cv=none; b=g/9e5jdzP37svxLy0TXQ3mXPRJmdCD23BUeLfNdXiEakceMDMbku0xtnxpmNqCfZeo/beH3w3uQhIsx7PX5KuMdLvxADchc0f/cTa8FMK6o3DyVDoVA5Q+FbT9xeY3cGLUCgRLquJ3vlXbBuGdh9tEGF+KoE3Z0Crpb753Zui44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080658; c=relaxed/simple;
	bh=+iKKYOvRmMooldKUJzaqyMz3h+8d3iomR+Gy39atOb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rh0GR6u+18yQIcMXIEfuqOFjqotr7ySDe3J1NKjaiOS0geRTvkl98p88IWdxMT0mjSEJRjuw1/jkfqyTQYAC8cBQAoOoWBHQcsB4HXbLLIDfRUleVQnl+8be6+nJihBhNZ0zzApgEzpeJv5foM7tG0KCeTrY6Q4cdv0nat2yf4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kWtI0x9e; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7376e311086so1001362b3a.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080655; x=1746685455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fFKnCJEsWbUz8XpZfd99k3cLIjXrE+Y/dzrUU3M9eY4=;
        b=kWtI0x9eVygtpkv9SymNINxBMzFyQtvvYk0ANPrOGwzQyyV74W3oR8KdSYR53sc4Cw
         rhtCvLx9dwXnhEJIZ2NVGYuSI0SXiR/5ow+l15hDiFk8h97t14/qy9Ah6Gbl2ruFil67
         CA5erC2oFk/cZtbysBWqooVtUDINFOqVF+dV8f5YhIOb6JcQ7qBo6ER6q/05mGvNidgY
         +39ZmkIjuoyIMLcsuBRuLyxcMYX4WvciYwhzQDX2vKP6Ia+f5j0FJeEI4qA0Nhj+2/pt
         yjd42HGkV6VB+Fq2Tf9VTDSG1AwX0GQACxbSxJlhFL0pE/3gYCx9wFBFixeIkabz4CAA
         XQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080655; x=1746685455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fFKnCJEsWbUz8XpZfd99k3cLIjXrE+Y/dzrUU3M9eY4=;
        b=XVRTMJ3qZzHZpMOZ3T3Gpckdgvyz6ik2dDoW+yQoyuIEYK+gerA/2VrhhD0V1E7wtI
         b78M48Jx3xmP315dm7rK3SEq18sTWR1rJ8ddS5D6suyN3HiMPnSCxbo+T1i29N9hYsM4
         H06cj9dZ0rxUTFVq2gT975b0feUbneaKYShvc2XuAKfPSrZlhDqwYnlGg6ap7JUkgKt5
         e127VOcSVEpe9udnW5i5OpybsH7L1YqE1mGGhPZeiZGQfOrDwhJuqeRgW3mqahKLYHJb
         jE6mGYvzrsBeUeOfYteY5PslR+Db0cMOr8EzTBBBBE/2Up6ptlyqbzEKzgWz8K2I7L0I
         Aewg==
X-Forwarded-Encrypted: i=1; AJvYcCWsYWlB25D6G1yTVL0BNRHhekgZsAUyFWnxQ+3qOY2UQ3MNb1cqmmQEIW34AfwnPM3YevQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHcFz8+yjVV4GqjRqB/Xf6N9KswPvtqha9FecO2q1LxPPJa9Qo
	4YwSvxvCY5byelX+P1yS+IJRQfCgic6yoyZB4X/BKm595V/CjNH6Cb5kNHpYopQ=
X-Gm-Gg: ASbGncvw6f8JQROLDToJRC1npJHCw+Hru7UNJEdDVaMJE4i86rdAg3sApGnG+Oa2+lO
	KPZ/MqypnUdy7bW8ypJ+nBE7pPqPXfywaFQtvKyXEwMtTOVVTbgv6V4J5VMyTVFHKx8iNZxVjWg
	CFOe9CmJFs8JwbJAc9HeSxEnsplXlGvlaledD2lBYp690nRzdiUqHZOOOQKULsZ8E4SU+qTStZX
	eAZ6ebkHfS0UBG+UITDZ1+Lqo1FZJ7X37JLh7Cn1e8EHYL1Epn+uKhpQDvE9AeifuH5KpU2ex/u
	1ReaiGQUlSxv8B8d6/hU7YBXKwwTN/l3H9zr8vOi
X-Google-Smtp-Source: AGHT+IHRt4EsN5RAvnHPj8pBa6/Pz1ailx/SIo7/AvzZvxJwjfgrzXqyG2+jW/OA7KvO7RhZpbUhTw==
X-Received: by 2002:a05:6a00:2d1c:b0:736:562b:9a9c with SMTP id d2e1a72fcca58-7404924ee9cmr2371669b3a.18.1746080654733;
        Wed, 30 Apr 2025 23:24:14 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:14 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 26/33] target/arm/arch_dump: compile file once (system)
Date: Wed, 30 Apr 2025 23:23:37 -0700
Message-ID: <20250501062344.2526061-27-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 06d479570e2..95a2b077dd6 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -15,7 +15,6 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
-  'arch_dump.c',
   'arm-powerctl.c',
   'arm-qmp-cmds.c',
   'cortex-regs.c',
@@ -38,6 +37,7 @@ arm_common_system_ss.add(files('cpu.c'), capstone)
 arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
 arm_common_system_ss.add(files(
+  'arch_dump.c',
   'debug_helper.c',
   'helper.c',
   'vfp_fpscr.c',
-- 
2.47.2


