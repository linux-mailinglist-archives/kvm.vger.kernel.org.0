Return-Path: <kvm+bounces-60644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B02ABF552F
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 301874E4F82
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD1731AF21;
	Tue, 21 Oct 2025 08:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jTWpzVFL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3473A3054CE
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036260; cv=none; b=IYsSumF0Oacw1RwYRdIcgcfsdOc+NzpcnMvxh+VS2bQzdA6PX/Kf1TQPk41wqszb0j3LNB2eiF/qKVsgJ5uK6Z4ZcX0p/+oxBl3A3lV5vUUSjRtMpWcXhTBtdmHol8vXw7Ei4RuGrotf844pwOE0qinHnhKoZiGi3Ykb2fzVGiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036260; c=relaxed/simple;
	bh=hhbHkSkaXQlG5YNuuZyfYPTMWszpLmqd0kgPeH2ksf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kdSAc4JVI3l0cQOKtqi9mTNIRX41hszdSy2A/h78Pu4qT+zOG8NWYoZcidWTldYJdhVy/VUo82l3QUgckVMu4wnXqJOEIdo2GVZAYmz3x7y6kcKXpn4FPBZ1wdosaI1Xk9buD57VyJ4KgBIJRGknwysi6QPvdMW0v6nyt72CTDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jTWpzVFL; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47106fc51faso62624205e9.0
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 01:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761036257; x=1761641057; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EulFVp0cdEgXrWVzzt34/e5jn6jKRx8ym0Wu/90Pz4Y=;
        b=jTWpzVFLEOIdnJxLwXeS7OLMYmJqFTba4A9dncKJJRmJw8OVVWu+N1CdVyqg5CboSH
         5OuQ9GcGYM6X2GzdsK8ERPYcW3dLJT/RxFBPw/t8nmcAhZWvFzeMQTjn73vCbOzQL0Ta
         esDCsF7Ec2RPB9M2DnFPOB7ZVWlFfApf8/F2aae6qrHD1GWfi09+7s1mn2U/YJEk9mKX
         B/KqYsc7iWxuXd8SWvPO6KFsryGrzFcAN7HFnP6A2tTPhTX0SVcMaVOHanc8DdxwaXQL
         OD2ED3jXmGhC84ln7QYp3spDFo+tW1rJyuXBp7jv3LnjYhFrQoZsoBlImem6G4SbBOLc
         ekww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761036257; x=1761641057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EulFVp0cdEgXrWVzzt34/e5jn6jKRx8ym0Wu/90Pz4Y=;
        b=rSRzepqDUxxmEyC/ypCc9yAIxrr8xXn1ww4TgORK+QnWJcEiTgczopmmcZJywXYOjS
         G+gi94CTnts2TRQMevcXxZ/EmxdpxePNTgW096CgNNXlUEMpkUkEM4WTaX2Qfx8EdWmQ
         BiteHLRnOiOCxuXMnjNjDxJZfWdpZrX9kmFRw3kdDA50/Db+tT3MPWedZK/2jSm66ldh
         sEofSiI67TVhJiaUr/IuPqZsKJynS7wtdh1t1KEgbquWrYOvDuK1oDoqHwG3q7f7Mxg/
         OXivol+rZPQOhaWzT1TtNKKz6ZSzbKA7nJDqvom8ZZ1hKzDZop2IqcRf5vr13jnVadN5
         ZmYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXI+2SSI15c723D7gj2MJnj7JgjCrd4KaHnqgnpEMz9a4EE0kAighTibq+xVoA41zse+ow=@vger.kernel.org
X-Gm-Message-State: AOJu0YyU/Wk/HD5tTmTpiNb1BjBKMhx4TTvxT6RbpW2DT2r6ww4nSAqb
	tKfwyOxH5AUplWxWhjkvChGkdELAdK4pAN5UWiggImm36R1eoNVnigXSLP20rx/s87A=
X-Gm-Gg: ASbGncushs1xvVHwNryfJKLlAmY3balOVhDZ0UK5UFdtqC5/T2jfm4aoqv90r+6zZKD
	3HnoLdiy+QOhSHJevHDEOucz4KJYqFLN7lABCZtaG8dL0hcIrwYW2ueU+krB/Y5JpOk08RUpQ/o
	KyjczGHqBxLtZ6uNIrwWLeUxLVBN8mVq6ver1HzmLu/NNW6/OJlS7kYHd6+7J4wf13EbA+x3IXs
	BYIGV+8G7uuZhTMm53n9xCsHpqCAz86+W3FJszvXQFkJw72bag5TX0cxcV5n7YrmJ1ULAVFq1/c
	aUQF7dXFfYgQX4LIVnCoO7Sdo4YMjdynySGr5ksYF6TI45xrMvkjNzn9Vfn6PQiKq3hKBXMgHsP
	NpTFXo15QjvWGBp+ks0nz+GwbTwPw9AYGLO5lutTNP8liM2wcur+B9UE25BOKb315w4Z+ODiQ36
	XAn776r/JCuMQSI0BjBNxVd1wJSiAiw6vKA36DTnNVmETOPmA6iXGAV63T/WELeq4HIVLSy4g=
X-Google-Smtp-Source: AGHT+IEmd4GV6INTu4mcg5KDt0989nKH2jp2JP8h3QAR44T4Pq2UxoFRyjRrLBth8F3WNX4zMhdfAA==
X-Received: by 2002:a05:600c:5296:b0:46e:1b89:77f1 with SMTP id 5b1f17b1804b1-47117879898mr121510145e9.9.1761036257489;
        Tue, 21 Oct 2025 01:44:17 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47152959b55sm189711035e9.6.2025.10.21.01.44.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Oct 2025 01:44:17 -0700 (PDT)
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
Subject: [PATCH v2 06/11] target/ppc/kvm: Remove kvmppc_get_host_serial() as unused
Date: Tue, 21 Oct 2025 10:43:40 +0200
Message-ID: <20251021084346.73671-7-philmd@linaro.org>
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
 target/ppc/kvm.c     | 6 ------
 2 files changed, 12 deletions(-)

diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index a1d9ce9f9aa..f24cc4de3c2 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -22,7 +22,6 @@
 uint32_t kvmppc_get_tbfreq(void);
 uint64_t kvmppc_get_clockfreq(void);
 bool kvmppc_get_host_model(char **buf);
-bool kvmppc_get_host_serial(char **buf);
 int kvmppc_get_hasidle(CPUPPCState *env);
 int kvmppc_get_hypercall(CPUPPCState *env, uint8_t *buf, int buf_len);
 int kvmppc_set_interrupt(PowerPCCPU *cpu, int irq, int level);
@@ -134,11 +133,6 @@ static inline bool kvmppc_get_host_model(char **buf)
     return false;
 }
 
-static inline bool kvmppc_get_host_serial(char **buf)
-{
-    return false;
-}
-
 static inline uint64_t kvmppc_get_clockfreq(void)
 {
     return 0;
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index cd60893a17d..cb61e99f9d4 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -1864,12 +1864,6 @@ uint32_t kvmppc_get_tbfreq(void)
     return cached_tbfreq;
 }
 
-bool kvmppc_get_host_serial(char **value)
-{
-    return g_file_get_contents("/proc/device-tree/system-id", value, NULL,
-                               NULL);
-}
-
 bool kvmppc_get_host_model(char **value)
 {
     return g_file_get_contents("/proc/device-tree/model", value, NULL, NULL);
-- 
2.51.0


