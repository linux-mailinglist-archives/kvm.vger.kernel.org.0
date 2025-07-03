Return-Path: <kvm+bounces-51469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4966EAF7180
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1168B4A29C1
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0EFA2E49AA;
	Thu,  3 Jul 2025 11:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Tqgc5h7S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5166F2E498B
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540496; cv=none; b=SpBN5vxdqDTXNMxXJHcs8jmJuX7PWn4ZiJWnooU7aTpbC1fa8l6E+MaS7VcKzr2DwcA+iu4FyxqjyzYKHluA8PGwlJk4SPaSzkr+iBqlbDJTI/BL/ddK9uxWv3gog9+QPWQGlAe4t9d8QcAoLQqznGGvwnD1xvxwiJluHgEGxpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540496; c=relaxed/simple;
	bh=3PtxkksNM0gFqh1Tf0Qvi3CefXZ8Taq/vKGrXdqE/PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CkWgOKBc6ulz/JX5us3JlaGCJMoyb6ES7UwPNpCVOcn5YnKKWDZD/Noz4zcMMKj2E9atbtHGfNRcFhj9LAHKFpPiNNt2/lkkOo0mxSsBHd/DPlfGS2JH/kzUegXFACn8VaHTdu+XPAI0t5ihzJneqUDYavcCNdUZNsxCzIbsX98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Tqgc5h7S; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4538bc52a8dso55011895e9.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540493; x=1752145293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m478kLJmgkVJLppYyCk6e1zeeU4b7TwzrQ0ODlPJ2Ls=;
        b=Tqgc5h7SGWBjj9JFdIzXFydCZ7o+gitpIDSCWxYv3x/EexodA2c/iuxxnZsUWNgpZt
         xE6FftOkkvK+9Hi2fFft5Zy0RYpsZ4A+nmsGGuU1AG/jiqby/2B76a+SJfC0J8u56gyu
         iOqyRwkFxu1nWtX9RZfWpOBbzNnjzkWj4B0EMZgIB5EMG0oHgidz44hbVirBW3ZFWCRp
         3/rEi5qZEQQOJMhZOaP3UKh123FAmUg4OxC/AhutgZxzpqY5GzFnsTZSda5zq6iT5geo
         hXOhP1HjoqXi4vTPFSA1c6RkulCGWngVD1y2YAg7cErMyHPX8ipupX/iSPdcdt4dq/so
         I0ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540493; x=1752145293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m478kLJmgkVJLppYyCk6e1zeeU4b7TwzrQ0ODlPJ2Ls=;
        b=H7D4ew3peuyZB7XjxgmtAKOgKXTE8hH0atDRyi8cSfLCqKU9KEA/HTJakvsJaNP4WL
         2wXu7DeMEzY25lmvgFjmIlrryKGiACLFYeGt92lnwND04ImZQCDiEj8BNGDUiklfKsYS
         k+3Evku50It5TyKA2cGvqNyALm6ZEvC4LCqJKrmi8N0ayHcTymtW21dwPmRj+BxOHnS4
         Am3wCUerdH5nxMzaxChrabYVPuhQmLsaiSSAZ3GunnmiuosCHXChMtJjU3XM8OHAv3YC
         zFxNnQKWqKPxql5fX3lPPxB/sfofUvVrY3wQ+/UmI66qk3D+9gr2ncr7sLUrhisOg128
         qvkg==
X-Forwarded-Encrypted: i=1; AJvYcCUJktd38C4hJ55dfwRj263C3T7m2avmB76wz+tUUZvAsvMMCYVZrInN/hWvU5uh3GMRsOw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+GgX457fMiL98gEB8vDVUILGHmOxJa1yuClqj15A6apnidGtQ
	jqsXZMi2OX/Rkgg3pOXx9uIUR5T1mI4vq/p/NzOa03dBQy7Oj112PyTWqN8nBIEOV10=
X-Gm-Gg: ASbGncsiSiqF8WoOu7YzSgOPHn184ai8ZHRRFAeU+MkMxnskDIBCYKiPMiZnZSeWnxE
	K2f63CZ5i1z03eSoZfXF38/pC2a5/VcLD8lnxqE+aJ2WtE3Iy3smvXojEaqrYDuveXjxLX59NRo
	vJ1jsIIrvNX8BmdH2AaEt60ejEPbMTrSsPSUyhVpv6CYqZfpsGBb05DsBhn71ENTN9l/HyYzOqo
	nscEVEQd2DKWfP6XcAR4uZr0hr66nU2iuCxTspipeXdiA99ipWqzk2M0FY6YDraverskMRZcBaT
	Azg47ILiIP8Vlfp42/t8H9/d4mw+RF2harxUmTgZ5T2MPZFREFTrLZVKjzTCeNcTID6G0swHi4X
	eFhoEb1WGxmw=
X-Google-Smtp-Source: AGHT+IGIMgupF+X350G1iQE9ivRvgkFBJXHg/X2hkLxKMzy2IDW7GqsBRN5vVWJ19cFF9OZbbcgAug==
X-Received: by 2002:a05:6000:2802:b0:3a4:dfc2:b9e1 with SMTP id ffacd0b85a97d-3b32b4277acmr1682699f8f.2.1751540492512;
        Thu, 03 Jul 2025 04:01:32 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7fadf3sm18666026f8f.34.2025.07.03.04.01.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:01:32 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 66/69] accel/tcg: Factor mttcg_cpu_exec() out for re-use
Date: Thu,  3 Jul 2025 12:55:32 +0200
Message-ID: <20250703105540.67664-67-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/tcg/tcg-accel-ops-mttcg.h |  1 +
 accel/tcg/tcg-accel-ops-mttcg.c | 16 ++++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/accel/tcg/tcg-accel-ops-mttcg.h b/accel/tcg/tcg-accel-ops-mttcg.h
index 8bf2452c886..72eb1a71d61 100644
--- a/accel/tcg/tcg-accel-ops-mttcg.h
+++ b/accel/tcg/tcg-accel-ops-mttcg.h
@@ -14,5 +14,6 @@
 void mttcg_kick_vcpu_thread(CPUState *cpu);
 
 void *mttcg_cpu_thread_routine(void *arg);
+int mttcg_cpu_exec(CPUState *cpu);
 
 #endif /* TCG_ACCEL_OPS_MTTCG_H */
diff --git a/accel/tcg/tcg-accel-ops-mttcg.c b/accel/tcg/tcg-accel-ops-mttcg.c
index 4de506a80ca..6f2a992efad 100644
--- a/accel/tcg/tcg-accel-ops-mttcg.c
+++ b/accel/tcg/tcg-accel-ops-mttcg.c
@@ -91,10 +91,7 @@ void *mttcg_cpu_thread_routine(void *arg)
 
     do {
         if (cpu_can_run(cpu)) {
-            int r;
-            bql_unlock();
-            r = tcg_cpu_exec(cpu);
-            bql_lock();
+            int r = mttcg_cpu_exec(cpu);
             switch (r) {
             case EXCP_DEBUG:
                 cpu_handle_guest_debug(cpu);
@@ -130,3 +127,14 @@ void mttcg_kick_vcpu_thread(CPUState *cpu)
 {
     cpu_exit(cpu);
 }
+
+int mttcg_cpu_exec(CPUState *cpu)
+{
+    int ret;
+
+    bql_unlock();
+    ret = tcg_cpu_exec(cpu);
+    bql_lock();
+
+    return ret;
+}
-- 
2.49.0


