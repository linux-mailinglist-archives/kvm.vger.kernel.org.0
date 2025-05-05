Return-Path: <kvm+bounces-45390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E045AA8AEE
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE63F1887D6E
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A5819FA93;
	Mon,  5 May 2025 01:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qfRCLZUG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977211991CF
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746410189; cv=none; b=DCEoVrbFzXNoKp4oE3JcAM7xL0gOYKStktiZAwvtiFkR3+XOMSew/IwknFKSDK7Zm3Qbm5DX75Lxng5ANwMqJhtXV1q0fsdbNc2ig/d5iNLDL+wTldNa3YoTiaGSjTNh2X5NdS8VOgDnhIEsYJOgitUleW9rM1tpeUslW7kzz4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746410189; c=relaxed/simple;
	bh=HU1iZ7u9SIdxS9ovfMMnQI/l0UP9ebLyEgbI38vs5Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaX9RPuvyYiAZ16sR6Ug56PHuFhD+pJT73aYcNTW3XFNVbz3tIvzQC4KZR4ernIebImmBXg9GvKl3koaQ5IK8/kPAmWLCxJGRlO+DU9Gege0ZjYFqYsdtGzFcT8adORBLfyH7Mca5pZeXUy0+NDV9NdyGCF/+nXVqBXh5NstBPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qfRCLZUG; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-879d2e419b9so3712764a12.2
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746410187; x=1747014987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZO3KsYydwb/hhf/3jAlul68iv5kVCsUNHbrEnCVSccQ=;
        b=qfRCLZUGWJiPiv2amXmxtytis/rrf2XT0VVzNK7c3aVx34Riyoo79x0PQANwSRngw8
         DqWYIk27KqbREq9o3L/lykhl227dY8Sn01cV74yZeci4XYe4TvBEOxq6t9c6QUpsIZEK
         yxdJBhMjug9IZFhFEhSJAwyJinJHZU5PdUSsQSJ4dy2gWeMWRguuMXEhHHrB/uRNNkXo
         GwbeRWJQ2VcFXHfjU79XaETKEbByNFTwtBrXUVO9Q+uWB2NOgoU1XkJaddJBsVj4opbG
         9Ou9x00orZJ8zV97KoE7x6k67/2TIYlTyGYe3Ps2LJmpnucpt2pA969Q/h3d4GV4MPFF
         VhJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746410187; x=1747014987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZO3KsYydwb/hhf/3jAlul68iv5kVCsUNHbrEnCVSccQ=;
        b=orRmajxgePRxmWYfnmgl/s8wYBpd1pvxdeYoXV72ZLDEBEoTnv8dDiIVhTeB+i+Ri1
         Lhw1t5klfm4iazlcM8+65EQOC+fIuY8SSfF/tbdbmb9z0wnin1sRN2YRE1Y1s3dDOVQE
         JcslShOoxb0py84j/9T6r85G9zJjGzkPRgFUkUGCnuXWP1l9HaKuUbP+Jf3EbHsKce0Z
         GSh1BKe+L/VA1GbWZuyuBJk3hUbxFHEkAu1Pz8v207DaVeyLdLq+Sv6oTAyQ8eTFu/+g
         jAWB1LXzlJAJj4OyuZQr/kOw9Ukeo4BPkHmFmnOxq/NClJKttpOIbUBt3NylaYTBKFZ3
         gnEQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/dsHZpnFFByF6D1t3BkSfJp7eP0FLhweTn0++n7SOEJh5Hy4KgbOtSqu33ZK9srHQo2E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRYFH1Ji1FMCyCcxGczpDgaxCPGmWRR0FuckqLrN1E/WXrP3G+
	B8xclpK7lShoQVakdWYdMi0k2jUMERSh4pTvLAbQD+ldD8Y3r67grudm06SK45I=
X-Gm-Gg: ASbGncsxagwxBEukXZjk5NelTwJml+JsoNLtdF9x5NHGP1X5oa7Mpp8Ok1n7AenA1ad
	y+Co2bSkbfliRBlWzymYoxX7aq/u+lZTZMXNvQhE9uRdvKDYm7Q8q06Z4FYBujvjlNvV4XHIo6r
	5eNGHoPj0JBDEXM0AzqushcvCMe9lROY/ffygije+WPBkLoaTUjlVIOKvQyWU/1KUk5pW52Y8ac
	BJYu7Iko02nDq8UYfGwFyNCVQm+8mNzTp0Dhwzz5MgVAk4bNin1FeFCbxmttRDXZH28aiibco+s
	GjextKdGDjkreeckv+OiRBpRiHv8oe17IplXCVbE
X-Google-Smtp-Source: AGHT+IH175QUPJQzYav/+wT4s9mklMwFf3mSzJzmCFtDGR27Aua7f548KaJOC+1dQss+Y/arG83hIg==
X-Received: by 2002:a17:90b:2dc7:b0:303:75a7:26a4 with SMTP id 98e67ed59e1d1-30a5adf923dmr11588398a91.7.1746410186889;
        Sun, 04 May 2025 18:56:26 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a47640279sm7516495a91.44.2025.05.04.18.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:56:26 -0700 (PDT)
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
Subject: [PATCH v5 43/48] target/arm/tcg/iwmmxt_helper: compile file twice (system, user)
Date: Sun,  4 May 2025 18:52:18 -0700
Message-ID: <20250505015223.3895275-44-pierrick.bouvier@linaro.org>
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
 target/arm/tcg/iwmmxt_helper.c | 4 +++-
 target/arm/tcg/meson.build     | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/iwmmxt_helper.c b/target/arm/tcg/iwmmxt_helper.c
index 610b1b2103e..ba054b6b4db 100644
--- a/target/arm/tcg/iwmmxt_helper.c
+++ b/target/arm/tcg/iwmmxt_helper.c
@@ -22,7 +22,9 @@
 #include "qemu/osdep.h"
 
 #include "cpu.h"
-#include "exec/helper-proto.h"
+
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
 
 /* iwMMXt macros extracted from GNU gdb.  */
 
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 8623152a645..3482921ccf0 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -30,7 +30,6 @@ arm_ss.add(files(
   'translate-mve.c',
   'translate-neon.c',
   'translate-vfp.c',
-  'iwmmxt_helper.c',
   'm_helper.c',
   'mve_helper.c',
   'neon_helper.c',
@@ -65,8 +64,10 @@ arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
 arm_common_system_ss.add(files(
   'crypto_helper.c',
   'hflags.c',
+  'iwmmxt_helper.c',
 ))
 arm_user_ss.add(files(
   'crypto_helper.c',
   'hflags.c',
+  'iwmmxt_helper.c',
 ))
-- 
2.47.2


