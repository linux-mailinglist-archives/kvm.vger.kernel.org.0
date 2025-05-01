Return-Path: <kvm+bounces-45045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98A5DAA5AD8
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:25:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6F60173E7E
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1E127BF7B;
	Thu,  1 May 2025 06:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jI8qAhnM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF2C27A457
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080648; cv=none; b=c2oUNrfspL7Ry9RbZWNXDhL2xI4qJ62wbCONwW4ORhYisYV2fA7s0Vp31E+r74uRtFMzL32uxSP9oMAid59o6y70+bwcA/uTwSDeEm/Azk6rid3GOCyfB6HxOGEWr+1+nGYId3h/BU5IAtaoON+KQsGvKXxkZRVg+H5G366mEL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080648; c=relaxed/simple;
	bh=9tWuBNO+sqkTAArBBoIh+D5BW6z3y0T0wPKymFmxNjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kbd7Ad20CvWGXjMNgIYGmKpKkp1jFfRtYfcal01lRbNrUv1KAaBgWRY3nwtLNRVPoelt7k4ePHdbtUH5r/AAIhRY277HdTH2ccCQc7YNnlXoIX86eFio8nNRtSDiLcnbZyK2OY0T16WSW6ab4F8kxv2fEs1kENsHtCkrMaQipj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jI8qAhnM; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-736c1138ae5so707466b3a.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080647; x=1746685447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n3awBflLWeRzXlWd/2jRau0YKc04TlIhQ8bryKwVA7E=;
        b=jI8qAhnM+AwLOLgOS2Cn584JKjCLaTkIVsiGJdD9haHBp7R49fsagOBuxq8YyIot+9
         oR934jgK9Zr9jTeOEbe/RSADq64tjd64MBAALxvX9mPG7FD/C7iODpOc4Tr59ZtAT2uF
         E0fsMJegFeTD1B0p9sTuSh1lDoF+iV+oPjnWvr9fkbTKWBmmCeibCYD30FMsL/rXy43z
         h2fMwwP8sIaBnpR5AsKr1iWzTJNtfWkGc9FWGWuItdHZ8dFe0p7PrPu9f28NSlmJQ5Zt
         15r+RvLJ1hxUD7XG4CV1+15ym0LAlT22aFq0M82r1k//reDA3SjNidgnaydNVByQIbx6
         mGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080647; x=1746685447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n3awBflLWeRzXlWd/2jRau0YKc04TlIhQ8bryKwVA7E=;
        b=lTFLL2qIcFQkmVA6ttaJGhLinHW+Ijqpr7KL190h+W2Lx461tx49iNdZ9tQAoLaJMu
         Nth8NSFA67NENH121BjA+OOG7T95R4LF9Dpe2S24NhLqd4q+OvBqWZm8AeHvKa2hRt5d
         Q0SqXmD9Vle0GMm14KU82mAMpMLVHqu5IFtskJ9VJtZEKdyt3z6yp/PPo/7CN5o6E4w0
         kTVCnfkrZZfQYyd1EbyVY8xEpigCH2sGkKgHKOIRvk3PUujNkVdtbhfIm4pMx5TyrR53
         VlJUqyjUxY6jy9DgacZFx4ErWQYCvRWKdWOeHFP/IjzjzCQwR7lMSY2VLu+3ZNg/S+oP
         vMOw==
X-Forwarded-Encrypted: i=1; AJvYcCV702AuQ0PnEsUqZZySjpIVHbE2DjxOICLj+slflxlKJjzJ/1UUzBwvHLx6q4uldwgcP+4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFOPoI9L3AAqjkYjPZ3ap/8Y8oQljyLKovTGjTtYUXBXQfxP+Z
	T7Nexn2pXBrgMFAAFbRqEhoB+PGYQlJs/JqRB6JQ+w/KriGi5dEFqIfwFfLvkvw=
X-Gm-Gg: ASbGncvAfKls4VEhlZ8JeUhxoF1Bdbeq54FXiyxzatNbGghuKYdJkHbl7FmcLKgzxwR
	cMZ+d/NkBHaAJK4dOOl09tD6cSSDGICtbEU+xdfkUbMtBeEmNgKrLdIQ18ZPVrHAW5aKkl7e7sV
	w4Xv7AQE3a7G0mhSk8TTJeaLo8P1JhCRlGIJhGKrxPaFcOUD8YIXtlvh+lp9NkV0Sj8zIxZq+6j
	BJG2R/3m3cqS7JA0BWaHbWDuK/ZPXthFcZTVbQAP14CpLgnOMuMEvA51oc+ZZj7Lx06zIMZAogr
	y0KJI29W+MyRkEqClpaBWIeRKxuW/5svf09KxrXR0ufwSIhgZIY=
X-Google-Smtp-Source: AGHT+IGLOrXCRIOSVKYP4HGNXvk8Ab3WdRzAEazOrAXRXDNVWIYa9AFM0erziA9SQXy87Xjc5f+HbA==
X-Received: by 2002:a05:6a00:1411:b0:73e:235a:1fca with SMTP id d2e1a72fcca58-7403a82daf8mr8471635b3a.20.1746080646727;
        Wed, 30 Apr 2025 23:24:06 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:06 -0700 (PDT)
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
Subject: [PATCH v3 17/33] target/arm/debug_helper: remove target_ulong
Date: Wed, 30 Apr 2025 23:23:28 -0700
Message-ID: <20250501062344.2526061-18-pierrick.bouvier@linaro.org>
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
 target/arm/debug_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
index 357bc2141ae..50ef5618f51 100644
--- a/target/arm/debug_helper.c
+++ b/target/arm/debug_helper.c
@@ -381,7 +381,7 @@ bool arm_debug_check_breakpoint(CPUState *cs)
 {
     ARMCPU *cpu = ARM_CPU(cs);
     CPUARMState *env = &cpu->env;
-    target_ulong pc;
+    vaddr pc;
     int n;
 
     /*
-- 
2.47.2


