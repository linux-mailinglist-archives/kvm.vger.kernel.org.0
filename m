Return-Path: <kvm+bounces-51435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7D3FAF7137
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:59:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D5514813C4
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D23742E427C;
	Thu,  3 Jul 2025 10:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m1T/rPzJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E15A2E3AFD
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540315; cv=none; b=B1SwyMg9eCNbg+6euzYenj1g6idFWFK8KiiZAoXTotTkHIbl33X1Q/PDFtef05Y1urfG4ILmApoGoWf09Pf1gBfB9uoMgMyYKK2V8Q5aDFhEHpOT4PfwJgp/wzgpx7aB93bqgtpLk5TNixeWAD85TENlpLZWjVibekMLh5S+O7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540315; c=relaxed/simple;
	bh=uImJ31K7qNpUW92kw6+BpDCmDEmHisrROwReGyHxypw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XBVzOhpKVqnCaLwozgNVVCe/ly+KMJ9XIEskU/RnovQLYOmkGAqy3vvVNbgEq+gYNL1xKohaLQtItv4BVN2m3FfHlJ77w878Zkz+nG4j2XJ0BxqXZq89ly0C46ooOTRlW2IP/33FAVcTxRJBoBntkup6ZZQku8C3Hi5LWTRrbXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=m1T/rPzJ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-453647147c6so83865455e9.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540312; x=1752145112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Nod2XnKcLFCGDw4Al66TFSscA1L5ljopnzhztAklYo=;
        b=m1T/rPzJafyTTAplGMbEL6ZkUEusH+Zj66BDcH3WF087aKxVaXdaFol7QJUpdUthdq
         2ILv/ovUvr596tc5vQ361gGz43uTYUAvPcdr/lFM3kWrqdjMzmF58u6HK12aav4+kTWR
         CVbCaGwr9ErExl83IOio3dbGmrs/ggJGtdDuQwpsLpwG9eGPpixS9NKL4Vxb/aJn8SC1
         5N+qtwKZhmL8w1HuV6DDsuMH4UoWlC+zLfSwYhEG7XVFqP2KpJokepZvHmmQ6eFbN4Zz
         1XgKOoaBeKVGu/WVOfpdxFD3YxpG1ggNbY5K1XjT59lX2ccaom2sFpyoVGDkrLAOVs55
         4X5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540312; x=1752145112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Nod2XnKcLFCGDw4Al66TFSscA1L5ljopnzhztAklYo=;
        b=Pv6IFpHswRBy0METnosVl7QgokAOdkluPCOKQlJrfO9KYpNsocq7kewEa2+0QXH5j7
         xEqPgZOkxWmA4tC0Nfjbka72NdJ+lwmM9tMNj4rpHsaG4pMpgQelABv+xaD2rlcPB6mm
         3gL92aMIGyxE9ISbIyXggXgndZb2jLhDAo/dm7+q1VCdlVWGwAa/60Rj0y9Iw5ehMt5D
         H+NKZABGSk8b2jNnLV1nJquhWVFsrXF61L/5F0BI6lhd9bDOrXvyzmyS4d2QPzz6bQBU
         AeKfCuZmIQDMVYT8zHzlSKFnnmshcLPR1Le6Y+TNAPm9HA3LKS9Zv6/WF0UrL4hExF4k
         63Gg==
X-Forwarded-Encrypted: i=1; AJvYcCVWjXssPyhp8lcLZqVEO9OKMJcpxblkMebZuIA4cauq/yylcNn0J9hO0hLc9UjU5dmxUrM=@vger.kernel.org
X-Gm-Message-State: AOJu0YybQ+0Wqg9I04K4VPv+or2eIRG4OpmRDyigXv4gzPWicmqqxULr
	fm7enwfnZAqBnQ2a+N01SWhicAIT39RGx3/1JAqmhWqk32SBgFc2wM+pfCQjVThE+Rc=
X-Gm-Gg: ASbGnctuArp6325GLo4X/MlU1AQk13fY4bTUG/VnqCHx8Q3W3HEA427CX8hENsg8k9j
	I23zROivLi9+ZOesXaNp3fcs2s1WjasIddBQ6dAxPGW78holTeD/4ui90rOXGtpwPpcFXMyomsz
	JQHzMUpd1P4DDtBAgnhGL5sXz61I2/IXs2JiBDTD1zDJOK3YG6e3/ugzsE90shyyyQK+PVojcD1
	zHpw8FIiPFzlCj7USp0OiTa5J4kR/BqGY4zwWP4ZxTQD8nWId1AcUC6ijILMcT3IhwRoh2hiKJM
	OSShSASZPgh/7s+rVGGd+sqphRNDsnnGQQkGkmeb4NgVVObMvy08vIm6pIHAHYeyRSTW9EnVygb
	uQDGIFvKKLV8=
X-Google-Smtp-Source: AGHT+IGcickO/WQ33gY9Gyq+jaddIwf7/whYrVsk66+TMl1n3JbF5YhpX2jiMT2tTmqO0asrgEwj+Q==
X-Received: by 2002:a05:600c:5249:b0:453:8bc7:5c9b with SMTP id 5b1f17b1804b1-454a372636bmr65941105e9.24.1751540311639;
        Thu, 03 Jul 2025 03:58:31 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a998aa1dsm23893825e9.21.2025.07.03.03.58.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:58:31 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>
Subject: [PATCH v5 32/69] accel/hvf: Implement get_vcpu_stats()
Date: Thu,  3 Jul 2025 12:54:58 +0200
Message-ID: <20250703105540.67664-33-philmd@linaro.org>
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
 accel/hvf/hvf-accel-ops.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index e7f40888c26..c07ebf8a652 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -358,6 +358,12 @@ static inline int hvf_gdbstub_sstep_flags(AccelState *as)
     return SSTEP_ENABLE | SSTEP_NOIRQ;
 }
 
+static void do_hvf_get_vcpu_exec_time(CPUState *cpu, run_on_cpu_data arg)
+{
+    int r = hv_vcpu_get_exec_time(cpu->accel->fd, arg.host_ptr);
+    assert_hvf_ok(r);
+}
+
 static void hvf_accel_class_init(ObjectClass *oc, const void *data)
 {
     AccelClass *ac = ACCEL_CLASS(oc);
@@ -583,6 +589,16 @@ static void hvf_remove_all_breakpoints(CPUState *cpu)
     }
 }
 
+static void hvf_get_vcpu_stats(CPUState *cpu, GString *buf)
+{
+    uint64_t time_us; /* units of mach_absolute_time() */
+
+    run_on_cpu(cpu, do_hvf_get_vcpu_exec_time, RUN_ON_CPU_HOST_PTR(&time_us));
+
+    g_string_append_printf(buf, "HVF cumulative execution time: %llu.%.3llus\n",
+                                time_us / 1000000, (time_us % 1000000) / 1000);
+}
+
 static void hvf_accel_ops_class_init(ObjectClass *oc, const void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
@@ -601,7 +617,10 @@ static void hvf_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->remove_breakpoint = hvf_remove_breakpoint;
     ops->remove_all_breakpoints = hvf_remove_all_breakpoints;
     ops->update_guest_debug = hvf_update_guest_debug;
+
+    ops->get_vcpu_stats = hvf_get_vcpu_stats;
 };
+
 static const TypeInfo hvf_accel_ops_type = {
     .name = ACCEL_OPS_NAME("hvf"),
 
-- 
2.49.0


