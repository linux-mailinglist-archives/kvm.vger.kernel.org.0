Return-Path: <kvm+bounces-45797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72F88AAEF80
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCE88503890
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAE0C293B6D;
	Wed,  7 May 2025 23:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="abP37BcE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9541D293758
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661393; cv=none; b=s3ELmlkwzT/AhJOmVh2/NgOpmwMTerPCzw0ZF2XoyVT9KKiuCvLLFs72qFo+KhxxwLdwdhU1b8CXbsCsvBYNQQtV+/QKD84Uli/N6kED8qIi5JLyu/qP+k8oPhd5vsOHnMfTvrYz/nqS+eKcSLtmkue5XoKxiwK89UYAOfPK6zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661393; c=relaxed/simple;
	bh=ENP2hN0JkLSGgU+MLNHwU2T/tGgXwB94KuX7uaX3DAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0M739GuVnXEr+0VuDPH+pyu2GfcMz0Dy1wIF4CfYrjSy1sxVSy6pYB+hPQ9GZIAeP9daRIzwMXTqz4519OGj48f2teP+AFjyB7GHyYaEKxJxnyHmUVD61VVcGxWPXF3+LAJykUxOPG51JuTjBOVTMh8dst5tZBH6Z/Dz/w+4cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=abP37BcE; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b1fcb97d209so1435380a12.1
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661391; x=1747266191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E27VnLHwdjjgu7+qzkSpdD6sP1u8J5fzfB0GITxze0s=;
        b=abP37BcEiwkMvTPG8vvL54XQh4ElaZVABt90g22EHucUyL45oW7AxtuySbIgXKZ5Jc
         lhnPzz2oFWa2K+uRvzUXAe02OgIActNRnc3+pl/MvlAiTrKXE8Z9chpwYHqtMPx0q8JD
         Jma0n/OL2bUHVEFh9hW/eVX8tQEk8YKA+irCDaTNsbwfdU8OzU2a83vKJHxNHqZP6QYf
         ffJ2mlhFYSQFtzt8wngbVTe8vlWZQ9JycGFtnhjFUm8GwlA4n9T1BzLvsnsoKp2vcxgg
         Cq6PNfpGPXsamextJBYbHHqhaNmuE3c6dFu6Pc3pIlnXcIc+1/Gm/jYM1PEO39RttyDo
         6MIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661391; x=1747266191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E27VnLHwdjjgu7+qzkSpdD6sP1u8J5fzfB0GITxze0s=;
        b=r4eRB8mppgQNtEJNYcg2dnmr+L2Z2YM0BfvI1ycFXfHmMOytKOl9r8haiOSDxLVg/Q
         sMuUZVaWMpuPtJP4S0bSzmnMvR8brbmG7GLx5BpQVSmWRq3zB9HDKxW6dZBl+9eAPrn2
         G27RXWxu+HXMcXoXzyKA9jYFKLiDRAafFrJwTSRMWu9PyCR60RMtg3rjNXnc3BkpOiFf
         3y25lhoGpeYgTazEcwZEs0gU78ZadhD6JYcI+FhVNlmJhrLbau30irdWLqysfATvYNap
         08sq+Mdjv5mGwLaE5WTv6cFUNtOZueFhK7wU1CIsGLflhAN4Fhj2+rwjYcQ86bCJL2BF
         5OGA==
X-Forwarded-Encrypted: i=1; AJvYcCWWbUOEHFX8rh4kNYlZYTKfbfe7mWXb8oyQlaa+jxEISYUStCiED6t23skj0Vuu0FYNp9s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHfvM49NnA8JM0YE6OIzp/aBUvvy2/oXfUcj8B6AzHC0gQTfMI
	+JNcq9ysrYxUOh7kfBV3dGq06pnrzW6H0aWWfFc0TnXvfZB7CO9Uq+pZPL94pzs=
X-Gm-Gg: ASbGnctAqulJYuFJYxX2u6ZenpLRddvXacO4v6O3dcnWGJja0zQYs7V7KWByh690KP+
	gMb+ZYYbscK4usQT2Alx4xfeWDRZextkv7bfYD9RAwkZjzch1eQGwhsGSN8VUQcDr813A9CpoTy
	59N1jkOKQ6rlwy9vDoNzjwgn0Aycr87d1BuG2UKtPP88MMHAYEhp8Sy9F00e/0a8WO46klMEEpe
	dY+t0CG/3XWmMH7VIlhb4NbaPkJ25Y0scVHlZfl67zyensJUaaU1Aw9nG6cjTPPJrxDuzRk+HRN
	o70P4o92XoU1hq9kPp3TLHqhqge1lR94PKYSdCVx
X-Google-Smtp-Source: AGHT+IGctSV+DtKGe121ux6Zk+dI1dkMdB7jLPCmVMZdvVH6IdFd/gND7HK0CrSpxI3zMYELxI5nOw==
X-Received: by 2002:a17:903:8c4:b0:221:751f:cfbe with SMTP id d9443c01a7336-22e84751aa3mr23792315ad.19.1746661390879;
        Wed, 07 May 2025 16:43:10 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:10 -0700 (PDT)
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
Subject: [PATCH v7 32/49] target/arm/ptw: compile file once (system)
Date: Wed,  7 May 2025 16:42:23 -0700
Message-ID: <20250507234241.957746-33-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 6e0327b6f5b..151184da71c 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -17,7 +17,6 @@ arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arm-qmp-cmds.c',
   'machine.c',
-  'ptw.c',
 ))
 
 arm_user_ss = ss.source_set()
@@ -40,6 +39,7 @@ arm_common_system_ss.add(files(
   'cortex-regs.c',
   'debug_helper.c',
   'helper.c',
+  'ptw.c',
   'vfp_fpscr.c',
 ))
 
-- 
2.47.2


