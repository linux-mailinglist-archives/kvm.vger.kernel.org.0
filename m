Return-Path: <kvm+bounces-45363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82A97AA8AC3
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:53:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD355172753
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FCCD19CC0E;
	Mon,  5 May 2025 01:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="haYluuT3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB601B4F15
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409964; cv=none; b=nvGjpjH3SuTzmskJ5nIa9yKQ+EvVflYDGhdd6AMqWOvjb5Ro9aVIHZTZbh9CJMZ7jnxFYQhAR6epj2XSXQ0FiOUD/2iUW7Ug44rNIO7rlgPksI9DMgG+8f21BKe9H66GeyFpNqDkS4qvbHnHJ5N/fWZ555Ap2XpqKUd63b3J/Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409964; c=relaxed/simple;
	bh=J9HlJDzufDt0TmXN5e1KZjrJI0BzQvUdiXxvlC8/NkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nsldew2clD69miHLSAiigwwPBgR/aU4C9mUf5gHgDsGekHMZG8Jb2xBg94eN+U+FJEaPS1+58msRVFFraZU8Z7vwg72dsJTf/g9KnbphZX5kLQ6qpj2nteseP3gDq2xjF7gSaPrjbW2zZ9ld4oTjr/OqUE+UQ7SCg1a9RqNZC+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=haYluuT3; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7394945d37eso3163768b3a.3
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409962; x=1747014762; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+dY2+B45FTbIh7DFuLp2IDYyX3GgPA0isTzUNUEtsE4=;
        b=haYluuT3SkljMQ1it9tuWTOcEnh0V0XYhbI0pQtLg3yXFvKTPGzt5HcY0FkAl2FzGK
         ee/BB+p3lSz9nzBTn8eJpDigDCpEebbFbtyplbegzEPiQGKphoEV/hWwip0quj5oWtQX
         wL0+Hn2MEiisjRTiauBe5sKmX+4wPBM2ewjkTA1g3qWwP/lfqYQ9uDJRhqyTqmobEsBi
         K566NNLZNRCzEaM2X/trzb8hwTaP2bbewkZFetbuQNCqOOi22v41DqDKKb9q+6RNJbJm
         3HhIq/xxX+8GdphyA0ZdRzP1mWvxEKDbd1Uaj+25rcQx96xGzV/g4jQHL012bzCA/HZe
         KWjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409962; x=1747014762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+dY2+B45FTbIh7DFuLp2IDYyX3GgPA0isTzUNUEtsE4=;
        b=ck+nqCFjGUq4cbsjT3Uk0+Eh5Cu9U4T+q3P8TG9234aqunzta5ADmAcKLRDN4cmMq9
         l8tCnq0JAr6rW6C2q8LIhlQhd3zu6vj8TjjHzKEdHmpbGEFMl1ro+CN8tcEmXyiC0CpG
         xWc3p+/9OEnb3QIPUWMNJ/+1zbX4gu0N5i9lGepsejCi3ah8RuDFGotb64YpVi+EBoV8
         VrCNtWqFXUDIwt9NOV0GR4WWqkljC+ZNFMYTpd7GmnLdr/3QxO5eTyFBHr4uRyIIdEWI
         FqBRPSG0Nc6mnG1YqIPxP1ODthB9c1wYl5mQtwQIrdJ/C7c3YIRcF2R60KgVlbrB7rc6
         f92g==
X-Forwarded-Encrypted: i=1; AJvYcCVjDggYUz7Ily4xMJQ/oKxZVAWPyy9FIc9biZ6Fo4yWDhRWCKxLCX/fm+YdpwbtR00MR1s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL64ibBmE0Lbu2u3/gRApwuXcEJQfDmUe4uKP/jM1erMuAnWMO
	a98JrfwesraMRKeRQySYyuIOCMdp8rNLp0HiygzGD35pq3B/uELMNySQ6u6MUCU=
X-Gm-Gg: ASbGncvHGMdT3uFBhIg74dQZQwcNSWIxtd3FiGBJLH8UcI/ELjjkz8XGOWjhWbjziCu
	HaJThiXWL5GMsWpHpOu4RU5Ax9FCQkhkQerMhZhCxd8+cRT0+/NrlXUGSBW7sHm4ygqd39XyvFp
	pgPus7RBFZmGV7NdZGpae4wvjlE9S1gy6xL0xOcaD3ZFlLBmo4jrCCbk16zWRchpjBBKEP4otuS
	AbNZqVP92+8qVYU36CdinNNfpE2HdNuESBCtvXPjecwwP4zkx4O/9Y3iFjyU5cTzi9oYyqz05aA
	KbrrfxMH31sBOFrWjW+gK+gb7rfrmsRTEpwAg1ho
X-Google-Smtp-Source: AGHT+IGwGPzb6lFi2Op/Qg5QVCFLUtbbcfO9DQX2e8IUchkEKTdytp85tL6CL/OsVBWd1f+gFvvx/Q==
X-Received: by 2002:a05:6a20:3d81:b0:1f5:9208:3ac7 with SMTP id adf61e73a8af0-20e97ea6076mr7778420637.41.1746409962540;
        Sun, 04 May 2025 18:52:42 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:42 -0700 (PDT)
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
Subject: [PATCH v5 16/48] target/arm/helper: use vaddr instead of target_ulong for probe_access
Date: Sun,  4 May 2025 18:51:51 -0700
Message-ID: <20250505015223.3895275-17-pierrick.bouvier@linaro.org>
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

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.h        | 2 +-
 target/arm/tcg/op_helper.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/arm/helper.h b/target/arm/helper.h
index 95b9211c6f4..0a4fc90fa8b 100644
--- a/target/arm/helper.h
+++ b/target/arm/helper.h
@@ -104,7 +104,7 @@ DEF_HELPER_FLAGS_1(rebuild_hflags_a32_newel, TCG_CALL_NO_RWG, void, env)
 DEF_HELPER_FLAGS_2(rebuild_hflags_a32, TCG_CALL_NO_RWG, void, env, int)
 DEF_HELPER_FLAGS_2(rebuild_hflags_a64, TCG_CALL_NO_RWG, void, env, int)
 
-DEF_HELPER_FLAGS_5(probe_access, TCG_CALL_NO_WG, void, env, tl, i32, i32, i32)
+DEF_HELPER_FLAGS_5(probe_access, TCG_CALL_NO_WG, void, env, vaddr, i32, i32, i32)
 
 DEF_HELPER_1(vfp_get_fpscr, i32, env)
 DEF_HELPER_2(vfp_set_fpscr, void, env, i32)
diff --git a/target/arm/tcg/op_helper.c b/target/arm/tcg/op_helper.c
index 38d49cbb9d8..33bc595c992 100644
--- a/target/arm/tcg/op_helper.c
+++ b/target/arm/tcg/op_helper.c
@@ -1222,7 +1222,7 @@ uint32_t HELPER(ror_cc)(CPUARMState *env, uint32_t x, uint32_t i)
     }
 }
 
-void HELPER(probe_access)(CPUARMState *env, target_ulong ptr,
+void HELPER(probe_access)(CPUARMState *env, vaddr ptr,
                           uint32_t access_type, uint32_t mmu_idx,
                           uint32_t size)
 {
-- 
2.47.2


