Return-Path: <kvm+bounces-35947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35AEFA16696
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 07:14:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C77687A4222
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 06:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0D9F1865F0;
	Mon, 20 Jan 2025 06:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gWolf4mS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4E017B500
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 06:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737353632; cv=none; b=SZw4qiiULTAJ5p3g+OPed5esG64r/pdH31vOS0friEyZm/v/am1k+EYSETU1VmTf5bhuhyBeAlFL8Wt/A83zOcTjY3dXQfjzHZ8aBqRP58eI0Q0+2EWXoD6io7FwPYUQzQWuspHqxIHFw1+oviOEcjHDy1UvGQT/3MOvK5F5UE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737353632; c=relaxed/simple;
	bh=jXFvW8XudiOgqLJlxmJ8GiuJEXdXvfm/Zc0Q4NP5Ef8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GGmW5hzRFw5o2dEQAyo9O2sCudILMEqeNMvHNjvq3j2qlzk9Es7d6CdmelLbmLJOAWT6+6deC+LeVr0ro/Mimm+wkuTI12lwPnmx3wLk9PtE5ddcs4brVByhvZr5v63YBaNQX4dq3OosSz2F9ysHhDeQawzdmjldleFASgieobY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gWolf4mS; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43675b1155bso46964135e9.2
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2025 22:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737353629; x=1737958429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wKEZ5Gc0MaEdPP/MbnZX7nNPxiya+TPlVmj68CfFcS4=;
        b=gWolf4mSUGi6Z4stj3P/VIoOOqIi1pcFu7NUjfMc1zBxy5ZjRMLlRm8Lqtf9eiWcQN
         u4fwVQGEtezHWtbCbgwQ9UNnv+BoYIqNhzbrSABB3mgdbViDH6BaN6MY6R4+sJM4dYBD
         nbJpByNg3+wpRYvGomEmoYBhjc/N4IIhxroASUqsPiJS/DF46fOI8zwv/Uxf/fzZblUi
         L4/n8i7AKSJoM7ykmxriUD6FcZ6fF1MJ8fYvq4ijx17mY4DU1v3k8GVkaYbKQI5AsEQU
         3eu5RX0d/TFxlWoUTdWv4DIdPALUC0+LVZbPVr8B7DnMeeeMttMjOLTvZCuXcBlvomYo
         nDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737353629; x=1737958429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wKEZ5Gc0MaEdPP/MbnZX7nNPxiya+TPlVmj68CfFcS4=;
        b=OelRmq8srNnKVa5sQYLMTViKp4MDna1DIQ30KVCitFcgEHEsv/2HgFsQGgB6FkayrJ
         wU7WpB7ZE0ayIv3jNwqSKABbB+LrpQgxtcN7vMyDlT3zApT0XUD9ey4gkqFTceYcSmAr
         CyJ8xneXCRCs9g9/dws99VQcG5J5fSuMKL/v4QoxwlepKtnffqG5UF7QFLIs9C21JV/6
         g9erq4+rhN5S9j2aJmCNM4wo+qW19oRAbuJPKLIt1DpBwRH12M8z5o1YBfuk51eynpKE
         wj+8AsGdsKKgnF5QBMPzSfaqaFNWR+VmgXmWK1i6IL5BfUq9IcC5sPUFFlq0ENsIpZX0
         Zupg==
X-Forwarded-Encrypted: i=1; AJvYcCWMh5qcsZw77qurKdwy/xJI7/tah8tv3w8poXTK9+86e1l75bdyMewWrEHnPbZFVVxrvG0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzifOsZRBMaanpL8R7PeM7jUfEufk8ZgIinDkpSdR7OgM7mMqWp
	Ng60jTwDuBRRCgkVgDgAJkj5GGKTGWmNdAoJb3rd+qi/2b5560bdy3xcUnnq40zno2moJSyhdil
	4ZPE=
X-Gm-Gg: ASbGncsYgnhRvmNWwoPnMCJjv9bergVDJeo2SxNEyF6tDRxAIwpuV9/HjymCnnjGAWv
	uRFCZl71qr3SiGkeZkdVSadz+HdCVtEkJSSu3BcLWr7bvlAj8Sw/xM/KdxnEK6lWkjPyq1Y0s3b
	SHvClijOxIQFRJ9ywQEyhPojgYTrhysG+qVWax9zs/5fRTN286jt59Mw0Cj5kJB3SIBtu7uS5jL
	0xvxR2r4S9oko5Oy3frGIBwJOku+qmDtKustTzlfoWYrbC76zaY7fPso28vH1ZRi1tyiobPatVu
	F9CXcj/DUDY0fcYnWGbUzFMw26xjKELGfL0cauaBbbug
X-Google-Smtp-Source: AGHT+IF3ZixHgb9kVDxTB3w0WdS8jdw4KJ6vkxB5hgsmoOroKPAlcnW8aEEI/4k9aD5KloGvvlrCZw==
X-Received: by 2002:a05:600c:ccc:b0:434:e9ee:c3d with SMTP id 5b1f17b1804b1-4389141c1e5mr91481345e9.20.1737353628808;
        Sun, 19 Jan 2025 22:13:48 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3282a63sm9465662f8f.96.2025.01.19.22.13.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Jan 2025 22:13:47 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Kyle Evans <kevans@freebsd.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Warner Losh <imp@bsdimp.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <laurent@vivier.eu>
Subject: [PATCH 7/7] accels: Constify AccelOpsClass::cpu_thread_is_idle() argument
Date: Mon, 20 Jan 2025 07:13:10 +0100
Message-ID: <20250120061310.81368-8-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250120061310.81368-1-philmd@linaro.org>
References: <20250120061310.81368-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If a cpu_thread_is_idle() implementation accesses
@cpu fields, it shouldn't modify them. Make the
argument const in preparation.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/accel-ops.h        | 2 +-
 accel/kvm/kvm-accel-ops.c         | 2 +-
 target/i386/whpx/whpx-accel-ops.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index 137fb96d444..8cf353105e2 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -39,7 +39,7 @@ struct AccelOpsClass {
 
     void (*create_vcpu_thread)(CPUState *cpu); /* MANDATORY NON-NULL */
     void (*kick_vcpu_thread)(CPUState *cpu);
-    bool (*cpu_thread_is_idle)(CPUState *cpu);
+    bool (*cpu_thread_is_idle)(const CPUState *cpu);
 
     void (*synchronize_post_reset)(CPUState *cpu);
     void (*synchronize_post_init)(CPUState *cpu);
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index a81e8f3b03b..3fe26f54d30 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -72,7 +72,7 @@ static void kvm_start_vcpu_thread(CPUState *cpu)
                        cpu, QEMU_THREAD_JOINABLE);
 }
 
-static bool kvm_vcpu_thread_is_idle(CPUState *cpu)
+static bool kvm_vcpu_thread_is_idle(const CPUState *cpu)
 {
     return !kvm_halt_in_kernel();
 }
diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index ab2e014c9ea..ae4f1282801 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -77,7 +77,7 @@ static void whpx_kick_vcpu_thread(CPUState *cpu)
     }
 }
 
-static bool whpx_vcpu_thread_is_idle(CPUState *cpu)
+static bool whpx_vcpu_thread_is_idle(const CPUState *cpu)
 {
     return !whpx_apic_in_platform();
 }
-- 
2.47.1


