Return-Path: <kvm+bounces-45053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CEF28AA5AE3
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:26:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39F2C1BA79A9
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:26:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD09127C175;
	Thu,  1 May 2025 06:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="shOWyJWT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E68927C87E
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080655; cv=none; b=Y1ZrbiiDtMHlXVY5RCtnHn9PdWZGi7oNYoHKSnIijeqKu6muvvwbu62onk+SaYIvL/Ht0/lJA1jGnlQ0ubNadPvRdGDb5JF6Orw14ud+0zF31gwVwwWwObzazKP6Ztsj7ob++jjDkg0eq/JfwtkMcGBjXpnbq+DmAYU8Hp/0cAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080655; c=relaxed/simple;
	bh=g5L5wOXuLOHtNwdKF4+tpjNjoLAjLf3hSeZD7w0bOVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgmXW8576nU4pmMQBj7+7DsMIWytnoNPvNa+wOsfsZCwNVoYcsOLoXdge/Ujpf6o83ndswmIpo5YolBKU5NvnXoryCQ84xWO/3/YXylruehCHO5l4yofsxZDi5nf/UqHGXnZO9fsG5Ssiu5YN/bM0MRYRplRVR7zwaFnLADvB4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=shOWyJWT; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-736c277331eso1730604b3a.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080653; x=1746685453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AbIHH1S4kZio87pXSHaHXNfuYgqfHo9zKgyYkp9Oz1s=;
        b=shOWyJWT/z5NDIkMRzyRGpRgdS+w7VNYGxkoM/CbArUONE6FSe5VBFRpzvhSAbEWhE
         PFk9ZQsXgpEHEBhLtjQogQhy2DB2u7wECAZoLT9BHkfEfkKCnJAmNjyCAIwQcUJYgfF3
         mWrp6JWrTqM3LnWnkBo8OSXXziVmopu9lMr3YJMghebpZtogTb/mMrodhXDFj74avOw9
         /rZJgVzzfWqvYrWlvJ/oCW8glbf1wAZ11LZE2jie+6ZHINcBZrKARlpVz2nLa4Roe7gx
         hLj5Z23KfMQ2h2Y0+K6MjNI41KxGGZTJx4/1/wvLCx3PoeMI1XzBbG4z2zHquzCDfuUp
         MvYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080653; x=1746685453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AbIHH1S4kZio87pXSHaHXNfuYgqfHo9zKgyYkp9Oz1s=;
        b=V1saSPe/9WOoXqZ8wyvk0wnp34XzRVDtVoCMGb60ws2Xzp5JFtf49PPcZUfrQARcsz
         B0YEixwY2q3lWGJ55AJf/f3gMnY3BKKvaGaBqeXovhJUBFpzPMCEmQwePQrezjwSw/f/
         miSIzWzoBQuoLVPKfLRUBC3LORASk6TzFpbBWUHoNXTHYWTtU6ekB/ju/o6XTydGr4Ay
         v1jGp2PglZuU2kRCZ8h50J3gALHtbyO6dYK41JpjGyVJPcFA0RTyyp8uzP6R42nwnzMa
         UgrZdBD7P9pqJbApjsTWVI+dk+dEXR5blGGh1HWON6c//9Tn8C/xq5Og1RtbEDeBM+4i
         Q+Iw==
X-Forwarded-Encrypted: i=1; AJvYcCUo0JCN4i/jO/lkGjIpL0gm2wirkKdUHkQHR8N4lxy3pYU9G1/oXKZo2J6HUrDwvKWVOyo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhPK3XhQpDGCYhZrRcm+lCSs5Y0IOkML3N1lCOc+0lPZN6VEw6
	BiaLM0bc66R82+FHrBxrwLD6+3jKR5qdmhcYTBrF5Qt6WoeK3kFHGbiVIgPLvDw=
X-Gm-Gg: ASbGncs/v/rmR2MC9l2zfg6/dd46P68H8ewUbLuJUe53Jxv3vs4XozrnfAFFtt5l+/C
	0zxkujHjaWyFjcQEubgs9/s6SB40HJPB4M6bb4pMgi5IBwp1rnM9FY4WVPaVgLFBkvcpKuiBSD+
	mDAtney6PtHYKZ5T34Kp9FnWXdO6Pl9tr0Bmz2RT/6K1SaKgYFprlZORLGYZ0/uAGMSTxCgK/xq
	JR3QPjqJklwRBAsS+ukVCAwwGNizT6rNTGAnJsv335mZJQ+nWWb7SKQBMk0P5BqWeuRXyD/6LLl
	9kGHTC9jjU/ZlhM4ScbFlXA4jy17eyFmQwKhFD3qcsO/wdD9uKA=
X-Google-Smtp-Source: AGHT+IE+M2Qhe1mZXdpj+BeqZNGIoeFOrdKYtLvcOBl4KLwgVIF+m/BYToT/VO8K7wQPtU8U+I0ngw==
X-Received: by 2002:a05:6a20:3953:b0:1f3:237b:5997 with SMTP id adf61e73a8af0-20bdcca171emr1844660637.14.1746080653018;
        Wed, 30 Apr 2025 23:24:13 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:12 -0700 (PDT)
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
Subject: [PATCH v3 24/33] target/arm/vfp_fpscr: compile file twice (user, system)
Date: Wed, 30 Apr 2025 23:23:35 -0700
Message-ID: <20250501062344.2526061-25-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index c8c80c3f969..06d479570e2 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -2,7 +2,6 @@ arm_ss = ss.source_set()
 arm_common_ss = ss.source_set()
 arm_ss.add(files(
   'gdbstub.c',
-  'vfp_fpscr.c',
 ))
 arm_ss.add(zlib)
 
@@ -32,6 +31,7 @@ arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
 arm_user_ss.add(files(
   'debug_helper.c',
   'helper.c',
+  'vfp_fpscr.c',
 ))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
@@ -40,6 +40,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
 arm_common_system_ss.add(files(
   'debug_helper.c',
   'helper.c',
+  'vfp_fpscr.c',
 ))
 
 subdir('hvf')
-- 
2.47.2


