Return-Path: <kvm+bounces-36442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B4937A1AD5F
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:44:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E597E16413D
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ACF91D61A3;
	Thu, 23 Jan 2025 23:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ANldaWBv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002241D514F
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675881; cv=none; b=OAZIlZqiER8G13VRGFX3xWIxneDOsuqzXq9p5+PSWPrmJboxg0Ak26EhyMdPO5mLPEqyGZ2koEsDmRjZFOFveFg2UlqyaS5g9T0mFFKCh85zvBVa1QvD+QO5G8KEeCobM/PlHa4cwYYSTptl+vsxt6U/AaJ5Qp4cPVHNuDYGTWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675881; c=relaxed/simple;
	bh=+RWsapKn7VrlZrKBEoJngTX+sgVpkGZpz2JVXzmKACk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MJC5B+h6CUgHyeMTEztBEEqNyWC/SfT/wHyCehlCG9M14C8f2ZeD4LsSZ99nA7S3ypoVYecVjt5+0XFIjmLce+GRDImY+0AtIGiNTtKAGIHg6VbwhpNspmVdLZRgBEYX6parKSbNr3H0xJlGQRM6r0yfyMCSGCWPPMLVeNkpB2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ANldaWBv; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43635796b48so10273525e9.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675878; x=1738280678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSvw35u1c/GeD9pKIKqf6WHVcOBbPhJhoq/j5sOwl2I=;
        b=ANldaWBvBZd2jY44kHKuMuEMhGNUpZGch84GdJ+ceroO6862fhSQfwvmn+YEXe4coW
         thZ0ra3eBi2eyIPRJz2zgfHjuK4qZgS//gtxrSo3ucKPsEzh/jjW8nl2e7KCvgMVUL2F
         qIIvt+UdJ4rbfLA46SlWKtnMK/RoBpkdz12cg13L+dHnkZ0u5QcTtLTd3a6a+NEIYz57
         BRSQzTqo68wZDfqrvnU/VlixIUQcN5xFfHRYZw+LnNQfO9QtI8IjaRFkkI5MUVVCeL+4
         b6/aGl8uNZcDVQb97LjxHDIql7aVf0nDxKljWIFxB5/7m0AWVdfFijfGoQrVr9Um0Slh
         1B/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675878; x=1738280678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JSvw35u1c/GeD9pKIKqf6WHVcOBbPhJhoq/j5sOwl2I=;
        b=EPlLsoVTXIJCEsD+Q1JePJPFlZd2M8+JP4Y4pt0XUJsYK4Q8vyMGGV9VOVKWKpJsDD
         Cl+AEmxmaw1vx1ltunNDNhztkNFW0OOk5Rf0M3BF6ob+XaKPxPZTVbiszDnHNDmSpIP8
         nGoKliNOWfDM2UQjQzfqWT16vzLUbKuoS07t4F0YrYUgci3R1WhdhMK4zhPsEbJ7jWPv
         pFvV6JfyRlt0k5xgvu8TkBD76p/xPpC6RwOI927cfTiycD9AwKWqYM2i/ii+DODQN3c8
         inpHrQ/rhn6RIoi9mxOXkb0PjlKSm1XMVgVT+t/s+gxEbcfbz0SzAQ/Jf+WZgUPzaPxo
         AqhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJqQqO+5gNxfNyWOCFZlIBmCe3fY2h0PKL2zE8nQWzz9woJ9CZAZ1lpbuElUWdZ8pDt0g=@vger.kernel.org
X-Gm-Message-State: AOJu0YywEoAim6Us2yl3nwRg747DGT7ZXHp/KOct68uvmQFa4m6zg5l/
	cegW0l+CTb9iKb29kTi7OKGjEmLu0siY4i9g3gga32NMqepBbTXlWMdtWBmmC5U=
X-Gm-Gg: ASbGncstp1H3TNpiGcfQTV7ISxKgj/GCWnTjh3qgaikiMNd+6y+lI2YcpVj935tilWo
	dSfZjTCB+vY0q7rC5qd2zvZ3gRGFbGNzzFc8cQDj2PE6IWxgCjl2J6oC40X35PSTok8MHv/jVwP
	nWmxpqLveItlV+jpfDrsZ0VzdiZlNhz7baUQHvkRm8P0wBsBFuMT8JRO7+KArg+Vh+TED9MlpyJ
	jK+8xBguAMojsgpE9Z2BIQm7hezFfvqa0KkYyFrGgzNLZh224/0caVXuK73tPwpZWvE9VnT9CA7
	YRkhRnzO3GOi1TCP2i8nSsbDlO5gS6oZUsXNMueKZB9JrAkPOcnVlUST7QdFr3Pa1g==
X-Google-Smtp-Source: AGHT+IGo8PNbuw90Bq4/JTfJj+icg7kmRyyI+cmqGdvUrpM4r/a237PZVlDOFDC6zvKvXQiH9M0QlA==
X-Received: by 2002:a05:600c:3d05:b0:434:9e17:190c with SMTP id 5b1f17b1804b1-438b87f953fmr44596875e9.0.1737675878313;
        Thu, 23 Jan 2025 15:44:38 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd4857c3sm7081075e9.10.2025.01.23.15.44.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:44:37 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	qemu-s390x@nongnu.org,
	xen-devel@lists.xenproject.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 04/20] cpus: Cache CPUClass early in instance_init() handler
Date: Fri, 24 Jan 2025 00:43:58 +0100
Message-ID: <20250123234415.59850-5-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250123234415.59850-1-philmd@linaro.org>
References: <20250123234415.59850-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Cache CPUClass as early as possible, when the instance
is initialized.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 cpu-target.c         | 3 ---
 hw/core/cpu-common.c | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/cpu-target.c b/cpu-target.c
index 667688332c9..89874496a41 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -134,9 +134,6 @@ const VMStateDescription vmstate_cpu_common = {
 
 bool cpu_exec_realizefn(CPUState *cpu, Error **errp)
 {
-    /* cache the cpu class for the hotpath */
-    cpu->cc = CPU_GET_CLASS(cpu);
-
     if (!accel_cpu_common_realize(cpu, errp)) {
         return false;
     }
diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index cb79566cc51..ff605059c15 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -238,6 +238,9 @@ static void cpu_common_initfn(Object *obj)
 {
     CPUState *cpu = CPU(obj);
 
+    /* cache the cpu class for the hotpath */
+    cpu->cc = CPU_GET_CLASS(cpu);
+
     gdb_init_cpu(cpu);
     cpu->cpu_index = UNASSIGNED_CPU_INDEX;
     cpu->cluster_index = UNASSIGNED_CLUSTER_INDEX;
-- 
2.47.1


