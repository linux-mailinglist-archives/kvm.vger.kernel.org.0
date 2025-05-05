Return-Path: <kvm+bounces-45377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC78AA8AD8
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:55:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39AAD3A85DC
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA321E1A2D;
	Mon,  5 May 2025 01:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KImCqz0y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4C51DE8B5
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409978; cv=none; b=E/5lki1lUAWgR3baHMko+aWMzgbKS/WzB7R3LChDu5cYggA5LXeydzLyR8094NBmWZiKLInDqD0r3WENEXALqgMEpCjOCoAKBNv2/N3b/5Dvoyz2oweHxkoxgC9u37D7Ko3biieEhxKaxnFc9QeDOcQRZKooPFyMfaE6yL8AMGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409978; c=relaxed/simple;
	bh=nio9YJkiK2g8f7JN+bhkPA8UAPODA+S829FcakWQE/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ent7hYkfD48aZen6jnc9qF8BT+MR6C4BqPOQl+dnExsX+KzSnpvnvUZYs88HNWjgzWFlBBo582k9ZJQ40IG6ZArJeFL8QwO5V1KJZ4/KxCSA3rRLkniUi53FsNDdqHcXgPMJhde1ajIBsJ43vnmaj3siweKXhNVscms1q+XZ/UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KImCqz0y; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-736a7e126c7so3433311b3a.3
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409976; x=1747014776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rVtP/RnhHG9awohdmhc7BZy6oUycGDI8ImSQa94LuXo=;
        b=KImCqz0y7kVi078ed0kKcFYEziKWK3rLbOYU5Zrr6o9xNACUBlZngBpdcl3y5eEoHH
         xwXT7YcMp2z7SuO8D8+F+xmswNk82LNKNEjPePEJYwklNJdJdlOGCH6YXwaINyDf71uG
         4YQSp7XiyBfSeIK22+QqR8D1/ss/MI7p+QeUuMx7rFarQ2ZojTfsTumQTi8S4Ty+/eJQ
         UcVTIlQbu771d//SNfoepgcwI6bwvyTMLxb53wmwB1J99SXhLo2JFd7SRy/bIgpm+DR3
         xgpxzknms0KXxusFUh2jqy/d7v8n7AV92YiIoyynQ1Sc/11S8P/tMAQuzS+UYN7AseF9
         gI8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409976; x=1747014776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rVtP/RnhHG9awohdmhc7BZy6oUycGDI8ImSQa94LuXo=;
        b=auFrGB6PDq0CMbv6FmykQrFOCCuV7VMit1G1jJneu/lSDpk/VG6N6FOgmpf93xJrXj
         7mGvuRhk9Fm2ujFFTvA1Lvxiyy5qlz+78JjYxlkzcM0nw0FvMX8zha3SESMmHuyGeNNx
         1e7S1cZuFM5U84LTBdY1ChmLh4oPy1ZwWqbwutZSJFL+fUCnJbz0gr1LY1YmTnWYVUW5
         C7Dt1sEubftbM9aNBgeLfqBwhLmuVDuBaYR4u5EAuow72leBEM43fXVHI36nK4uXGJsn
         qOFI1cQD4fHz+0T5LD7a1Wazoyeo7ow/kOixJpxgm/fdWP/hfF9f6132ZYOn8XO2s7HK
         3ZJw==
X-Forwarded-Encrypted: i=1; AJvYcCV1daQxTNUbJnr58WiZK0lPrQM3RWvXw90lQ6fZi3uROvi7HIF5Qho1PNlDs+Kv51uWBS0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxJDOXPuqfjKxb9Ejr/fZg00rGIiEWc7tsfjLWKxIOPUiqGLMM
	Hhh91qiaE5CCpyCC8qWjlsLLinr4GpWBUQNEwgk73ihsVvLh4mxI2o2lEucxE1A=
X-Gm-Gg: ASbGnctToxZAZM6KUIWUl/otL3qQTXURLQ+Ml5rrNNqqGLBMAkEc34Pg/01FNEhDeRC
	IpIpCyQ9SLTTCP8mM5sN95Jp6PfZpM5J+uOac89ugCuFjXy0afFyj3tGy5u98dObPHNGhZxShY+
	X+C9UXjGi7BBNHiK26JlkJpVABRXAtBMa0lc505tJvvGYO1a8zeplhXjNkJwRmXU3vWEBgVr4Mi
	/qtOXIlwn+Z8E1RnhyXzXFAIbCdqa3xKglqOn7o0rOuIzL1YcjBnXVltoCEm1KjQfAAFEwDWhiV
	HqnjB885rePrHXMALsuvm/pG3GKimVtDVFuE/vxOaV/9yoj535Q=
X-Google-Smtp-Source: AGHT+IFCVf22Y8b++NohiLhDf7F1rpFLdSCNO7L9sTB0r+8DXUCBJ/9XAzockGK74r3gOY9XTNVHLA==
X-Received: by 2002:a05:6a20:cfa9:b0:1f5:8e33:c417 with SMTP id adf61e73a8af0-20e96206094mr8736271637.2.1746409976114;
        Sun, 04 May 2025 18:52:56 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:55 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 30/48] target/arm/cortex-regs: compile file once (system)
Date: Sun,  4 May 2025 18:52:05 -0700
Message-ID: <20250505015223.3895275-31-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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
index 7db573f4a97..6e0327b6f5b 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -16,7 +16,6 @@ arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arm-qmp-cmds.c',
-  'cortex-regs.c',
   'machine.c',
   'ptw.c',
 ))
@@ -38,6 +37,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
 arm_common_system_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
+  'cortex-regs.c',
   'debug_helper.c',
   'helper.c',
   'vfp_fpscr.c',
-- 
2.47.2


