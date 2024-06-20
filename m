Return-Path: <kvm+bounces-20107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D3129109B2
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:23:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C5BD1C21A2D
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4B51B143F;
	Thu, 20 Jun 2024 15:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EaDFYD8n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651991B142D
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896963; cv=none; b=GrNTMnXeY0PMx8fM+ikwauHboAL+FIuWNjQcYQWhcZcI2w73zDVAO3nrNsNQnMfJoOfzf2eXkJfx8ISvCKkNjhNSuHLwlmvIPFgeXi35bh1YjtIZ2yaGegjbD9iI9b+wF2phPIjv++3olV3xyO6uSg/63mRAPXbwfSERkoHzpYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896963; c=relaxed/simple;
	bh=07cMNi2bfvRha6cTPTGq7oWGEYrUwQEOTDm5bXh8XU4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uwf/QndxlYb04VTHU2AKgp+85h3rBRGYGTk9M6tNM38OaT3ftXeuQbr3L/9IcSw1MSLlniGcfHbedeSfSP0ngtnBO9G3gbMG/hwUx5rSXlcjhkfFtcvh9b7ys9JETmnmcRAHhfpiqp+i0eDp9Xpdb8/gpfBjeyDuButqzR4SbJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EaDFYD8n; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-57d05e0017aso1274448a12.1
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718896960; x=1719501760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mk0X1Wnynj7dOIA6noc/XZNsTzvKKxUiDNUzj/HAsA8=;
        b=EaDFYD8npmyIfq3xcFCWhycZr0di44VrgGFTi1B7Iz8Kmwf/YLeuTck1bHSbaZX7Vx
         l/86rI/tZiCFxGDdjv+Kf6xkZ/IndBFKDflUkinBfGktnqdvVacab9fNwV9hq5pxmRMK
         rC0uGgK9iggij+md16EMIR/nobMZrEaPEqaLSJjD2uxi+2nVJuAUn6TfTejbH+3e8o9T
         yd0d2ysppta6XzX5BXkC6sLxUfBAV6eO3u7YaavfcnBc25iSEkUMdJ9Jcx+VR2QX992G
         Lf/O8KHlwig9RYMBYJLXHocwEqY/ntzzWQ8tQKoGT02ZYqB0wjngR4vWam55BrBYfRv1
         DsJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718896960; x=1719501760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mk0X1Wnynj7dOIA6noc/XZNsTzvKKxUiDNUzj/HAsA8=;
        b=Gw7PD3hkkhCsyn2LJyNnwg4f/jT7b6j48PPC0OSHcDon55Hx0LMWHJ1Z/Y2MzkW1WE
         wwWwIfZoLziDg3Wkrh8r97j+YwYXvF7rAMJUSinAXtQWcHPXM1HKWnjs2K2hrjCaZRgA
         X5VrlD1MSTjySgzsrjpFjHW0Loeo2EJitWXUGaiiw7zzwDP8/4uWHOLr8q0Gu2GxdIzk
         f96kkJAMHgjFingHdq0aU8JVLGzITXoGjYG2o/9kvbanrAnaImxZ4KLzuHqP6IoD/W+G
         QAdMWK/zLqyBaD7hfXum0NIkg6Gylg2xMT0f/4kYzw5FqDXI1q+tEiHrknnqb+b5jYpk
         0I8Q==
X-Forwarded-Encrypted: i=1; AJvYcCX4Jz+IDcN4n3IdC3g9m9vIJuYjjtNcI/Hc9sXLvtc3F3zriloVQYOJkKw8iLatX3vOXx2roi/OBNJVgaRxLiCpBdA6
X-Gm-Message-State: AOJu0YwnbAEdBAj0gBFVPNNdlN5N6+xw9FqFaIajj6xOewzWqsxet3dH
	HVwyKabkEtEpwGaOC7cMaegy/OmK7SPTz84qQaUMBniBOtuSDQZykHUKcxkF384=
X-Google-Smtp-Source: AGHT+IH9pCECdMbMVVhjjvf6u9eh17rATloLp9u6G8EZyVpWPyMAS/cVnhG2jsc1yqsUpAe4BtIosw==
X-Received: by 2002:a50:d595:0:b0:57c:5874:4f74 with SMTP id 4fb4d7f45d1cf-57d07ed24b8mr3437569a12.28.1718896959461;
        Thu, 20 Jun 2024 08:22:39 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb72da156sm9758038a12.22.2024.06.20.08.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:22:36 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 3BD7D5FA0E;
	Thu, 20 Jun 2024 16:22:22 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-arm@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Max Chou <max.chou@sifive.com>,
	Frank Chang <frank.chang@sifive.com>
Subject: [PATCH v2 12/12] accel/tcg: Avoid unnecessary call overhead from qemu_plugin_vcpu_mem_cb
Date: Thu, 20 Jun 2024 16:22:20 +0100
Message-Id: <20240620152220.2192768-13-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240620152220.2192768-1-alex.bennee@linaro.org>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Max Chou <max.chou@sifive.com>

If there are not any QEMU plugin memory callback functions, checking
before calling the qemu_plugin_vcpu_mem_cb function can reduce the
function call overhead.

Signed-off-by: Max Chou <max.chou@sifive.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Frank Chang <frank.chang@sifive.com>
Message-Id: <20240613175122.1299212-2-max.chou@sifive.com>
---
 accel/tcg/ldst_common.c.inc | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/accel/tcg/ldst_common.c.inc b/accel/tcg/ldst_common.c.inc
index c82048e377..87ceb95487 100644
--- a/accel/tcg/ldst_common.c.inc
+++ b/accel/tcg/ldst_common.c.inc
@@ -125,7 +125,9 @@ void helper_st_i128(CPUArchState *env, uint64_t addr, Int128 val, MemOpIdx oi)
 
 static void plugin_load_cb(CPUArchState *env, abi_ptr addr, MemOpIdx oi)
 {
-    qemu_plugin_vcpu_mem_cb(env_cpu(env), addr, oi, QEMU_PLUGIN_MEM_R);
+    if (cpu_plugin_mem_cbs_enabled(env_cpu(env))) {
+        qemu_plugin_vcpu_mem_cb(env_cpu(env), addr, oi, QEMU_PLUGIN_MEM_R);
+    }
 }
 
 uint8_t cpu_ldb_mmu(CPUArchState *env, abi_ptr addr, MemOpIdx oi, uintptr_t ra)
@@ -188,7 +190,9 @@ Int128 cpu_ld16_mmu(CPUArchState *env, abi_ptr addr,
 
 static void plugin_store_cb(CPUArchState *env, abi_ptr addr, MemOpIdx oi)
 {
-    qemu_plugin_vcpu_mem_cb(env_cpu(env), addr, oi, QEMU_PLUGIN_MEM_W);
+    if (cpu_plugin_mem_cbs_enabled(env_cpu(env))) {
+        qemu_plugin_vcpu_mem_cb(env_cpu(env), addr, oi, QEMU_PLUGIN_MEM_W);
+    }
 }
 
 void cpu_stb_mmu(CPUArchState *env, abi_ptr addr, uint8_t val,
-- 
2.39.2


