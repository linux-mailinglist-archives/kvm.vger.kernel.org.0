Return-Path: <kvm+bounces-60645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DA2B5BF553B
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:44:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5E3223505B7
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E527320A0B;
	Tue, 21 Oct 2025 08:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TSDWCiW3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19831291C13
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036265; cv=none; b=Fv3TfBaHUH288YJz6apPVg0yV4m09cCZrmJrmBsWnKIernC3jHRN3WlKyrzoVYgJvWzCE5TTGbHQvzVyatFsRq2H6s8/TW/15/R+ft8AZ4nFL7MOGojWV8cBO+NZoGYTcA8qLB2q+AJVek8cJyNrmmvWm+Mcy8yFftOLa1EYQ3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036265; c=relaxed/simple;
	bh=G1iuQahJsrYJ21IJS0Epi55ij3/ZHOuu0j/lP0L/reY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VLraze5wNorMH1vyt+IM4p0YsF+Z5ikRVBPbPyYIylwzfMh8oFWcWwiXlMGvh7933FIzOl8wTq17EcyLl8aqEgbOE5mnSn+TZpgA+TZg0RZbj8hNlLbivSmJvppeNvtXVwaOBkjdQS0ePIokwwo2SLyELhKkqFexzS47DVo7jLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TSDWCiW3; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-471066cfc2aso7591055e9.0
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 01:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761036262; x=1761641062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qI+hF79G3saS4cJM9gBn0qvW7x/aK3K4EItDfXm9eIU=;
        b=TSDWCiW390eCZVaqxfgLqMRLS6Pjb+6YIOZcoZXMUr9LfaLpRWZ777kspDkREV49O0
         i5r6oXXqm2hLIaJCKoGV46ZBu0t59LVyjW0XNGI16XGkEB6liEOZ9Hs7jES3CSleiXzM
         YxoQA44LjFP08pxvHXKcQr+s6W5tVxhCcbtYQVMej2ceLPeZachLxdsMqxqFGsClAYGI
         Ieb6hrAg4FUnGZhI8rNitpd2jgAeFsRmWLO1ODIGDUD4AX80skD421fg05bKMoy0VTKn
         erlxNXgNVBcilkbJ1AtLcylOmyZRec5ETMoj1guHYMsyK+cKnz5zFSJSkxYtEf50olZH
         agOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761036262; x=1761641062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qI+hF79G3saS4cJM9gBn0qvW7x/aK3K4EItDfXm9eIU=;
        b=ftago15YMkS3gBYpa55OqKFXcCxUX3fM5V2PL3HuyGlaRGYRp1JsV9mco+8cVBQ5lE
         OZDZtZ7SWsY4YqRahWszsA6NTAsDSmAVRVBVQ5B82z7hhdVpnT+WFAnE77PCP058nVpe
         oMUoAKmTYC9GEMQil6tk1UiRt9zxKArmp91L8S4MhEcql6MSfsCmiH0OvFK5BRBRFtkz
         gtW2dnW8cIGl8Gd3wWRQGSKzUqhhBoyeaMLNHfP//WXYJ3KrBQftGkS/wG1uuHz11/TT
         4z76hsr9Nd1tEzCyOgMwxHyNdBhm+SCyYwWiK44uWBFfqeV88wF+EYjo19uEvYgxLGQc
         pr0w==
X-Forwarded-Encrypted: i=1; AJvYcCVnUNGGO03z5F+7aYUAzYH96+gBd/73bVVrsA1gxAdWz2qga/LeI8zecXJk38rXSHlp0VY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1cLCzLu8scIQ9MDAnuBKgLx72LfP091uDzxRA2py35AfcLFD8
	eJG4ZQ8e8qlXsouaQZTalEZDrHIzY7+epfs3cM5kaaqaIMirBVhMCVe/CdehCLfiUus=
X-Gm-Gg: ASbGncvZn20pfFGa4qdyVHEigzQrWea8q0h7YsdNAYJ4naOX79MH3pTnyK1cB5YOnZk
	o7FJPucxLEJmpP1fd5mAj28axIp09Uk1cKNgP6MPe+/52hqrp4C2oRekvShsiTxtncwl9d6D0eF
	l4gIyyrbMxVzvz4QOH4GiyurwuCLl43tOkUF/q3uomfjdFxn1P5KZP2Q6mPSYf+T0UO0M2DnD5q
	kerq2ZzhMmwnrs5eVrX2nSw0rAxopCiKLzztPY45jDmoX6kz2OEwhi5EalxNqppZtdHNfOPuMpV
	IwNbn+3X5NS1EJkq3J05BaGREv6pf1keTxUYL9S1KylcFKOzjU8HbHuPajdB6PGcrPAM3tM1ViP
	gRwTo4IqNwqT+cilqViMEBvKLCQRJy6/7k3MIfyFvKGSHveETgV6Ul1WZbDg1MseAu0coNe3bZC
	F0G+GGsASHtKqt8xGH6ZwTCYQB9MqpBYu4RZeHKDOCArRlfrv0SA==
X-Google-Smtp-Source: AGHT+IE8rS6VZYx/i8JiXQJLTMpGlcor/1LQLKzg9IWBTT3rtLq5Bk5Lslt0pycRlR21ilSWorrGLA==
X-Received: by 2002:a05:600c:8b62:b0:45d:d97c:235e with SMTP id 5b1f17b1804b1-47117876bcdmr112776075e9.12.1761036262467;
        Tue, 21 Oct 2025 01:44:22 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5a0f7dsm18934148f8f.4.2025.10.21.01.44.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Oct 2025 01:44:21 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Chinmay Rath <rathc@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 07/11] target/ppc/kvm: Remove kvmppc_get_host_model() as unused
Date: Tue, 21 Oct 2025 10:43:41 +0200
Message-ID: <20251021084346.73671-8-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021084346.73671-1-philmd@linaro.org>
References: <20251021084346.73671-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/kvm_ppc.h | 6 ------
 target/ppc/kvm.c     | 5 -----
 2 files changed, 11 deletions(-)

diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index f24cc4de3c2..742881231e1 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -21,7 +21,6 @@
 
 uint32_t kvmppc_get_tbfreq(void);
 uint64_t kvmppc_get_clockfreq(void);
-bool kvmppc_get_host_model(char **buf);
 int kvmppc_get_hasidle(CPUPPCState *env);
 int kvmppc_get_hypercall(CPUPPCState *env, uint8_t *buf, int buf_len);
 int kvmppc_set_interrupt(PowerPCCPU *cpu, int irq, int level);
@@ -128,11 +127,6 @@ static inline uint32_t kvmppc_get_tbfreq(void)
     return 0;
 }
 
-static inline bool kvmppc_get_host_model(char **buf)
-{
-    return false;
-}
-
 static inline uint64_t kvmppc_get_clockfreq(void)
 {
     return 0;
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index cb61e99f9d4..43124bf1c78 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -1864,11 +1864,6 @@ uint32_t kvmppc_get_tbfreq(void)
     return cached_tbfreq;
 }
 
-bool kvmppc_get_host_model(char **value)
-{
-    return g_file_get_contents("/proc/device-tree/model", value, NULL, NULL);
-}
-
 /* Try to find a device tree node for a CPU with clock-frequency property */
 static int kvmppc_find_cpu_dt(char *buf, int buf_len)
 {
-- 
2.51.0


