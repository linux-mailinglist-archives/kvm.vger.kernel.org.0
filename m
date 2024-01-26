Return-Path: <kvm+bounces-7216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0358D83E477
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:04:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 817D01F219C1
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4022A25565;
	Fri, 26 Jan 2024 22:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q4lz6Mc8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3952554E
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306666; cv=none; b=XdzD65qpjKqx/4MYabv91/QsttofqTihfxEqBp8OtsQkd7euhpbBVaUBxEoIauN91067KxisrYuhbLRc5YnOocJzYG7Jhx9ZvknU8HIAPa2Wfm7ThrxTOpUs516+nlg22jF1DZPTAfhgtrnbGRvlbTmGhPSXmOTuRJfJDNMmIBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306666; c=relaxed/simple;
	bh=IQH0OTU0GWgk8pZbUIDK4QiGSpI2jJTt5/CXkJdFsPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j9/csngWYjbYhlKzKmcAU4SL9dPqCJZ9Nt6QH1id+Zim/z9ZByu2BgIjGB0l+B04IcB3pVgOFSKb7+2//hNSJqReScbkRhGsICOLclGz/P5nOI/EsfN2TZOTeVXB7VEc15ih3uD5hvk7DIBSaFqoNecF7hDPW1R6zr1ed28oBPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q4lz6Mc8; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-50eac018059so1081730e87.0
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306662; x=1706911462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=44vj1U77cG8ByngsPLkvtVP46j6F/SEPuSA1albtNLM=;
        b=Q4lz6Mc8kTq1seQTJKPDKPlaZdcv7gOVJorbpg3x7UgbI1zhVMtprGU5xbc3K88XbT
         L/pGl3XcuI7b6twHi1dqbaU5M/1cmIhx9jjDQwwI2znlTiihRmR+ERfRzJs4SOlieZpJ
         DubZs//EAx5KE2d2jOlB+bX9NZPOi0mud70+yqyZrWng3xjDtYyEMg0bMTaznj24EYId
         ArzN0PMoQidR7k//cv0j0dLh0nzMGeAgWq40Tcrs+QNG2bD/SUzzmjRKHeSK8Z65JO1a
         THAdymrUHb6jyER1zdg2jkcLVkbhgqbNMx+7Vi7xnen9hq96nTfGU0STvbrJjo6TGYos
         ehwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306662; x=1706911462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=44vj1U77cG8ByngsPLkvtVP46j6F/SEPuSA1albtNLM=;
        b=bWtKblHoXFkTfx0kwqooe9SmuHGLfpBheUtwxFHGiY58RKQZ4df1Yw32zgFOZYGtFW
         T1P7ssKHWUnKunNXtcVIDAAkfY0vJjNGwu2F+cdGrEKCRf5kOMuJ4N03aJBnTOxkS7Si
         A6fgIV4DOdpKe7IGcMqaYcKRCdORPMzkfx/qQ81Ovu3VLWQJ4kdgArGU4ut01NHeKqC6
         2+PLNihqS6yXxQTSrGi5FlGWo6UJWK46vQMN2UCfuysLGq+Cj5QJXcpf+8qVW8rdlcPK
         aZemWNYkdN5JFxOp6ps/VHBdNfITyYbtMxOi7MNKwKjfCQnT+WPmmQp3cHR9T1LOWU4g
         3ZWA==
X-Gm-Message-State: AOJu0Ywrl76STL0dkeFkvnH9vTSB3eJuKGmM06zhVopGgE6cRYgYjlBZ
	B4N5uqtmF3ZM/MyRRfkcqfd+55gL1bSOPAjom/kTyN4NtvhKkcoRLCgkBr/a0//vwIUNKaPqneC
	w
X-Google-Smtp-Source: AGHT+IEnfgWYNd5eOLvLxcXg8k3YinEkfDQvcjv1CL6+umhezAI8wEelphIMVoflH/5EHRA+97EafA==
X-Received: by 2002:a05:651c:1a29:b0:2cf:127d:a79f with SMTP id by41-20020a05651c1a2900b002cf127da79fmr334833ljb.51.1706306662283;
        Fri, 26 Jan 2024 14:04:22 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id g14-20020a056402180e00b0055920196ddesm1004348edy.54.2024.01.26.14.04.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:04:21 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	qemu-riscv@nongnu.org,
	Eduardo Habkost <eduardo@habkost.net>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 02/23] scripts/coccinelle: Add cpu_env.cocci_template script
Date: Fri, 26 Jan 2024 23:03:44 +0100
Message-ID: <20240126220407.95022-3-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240126220407.95022-1-philmd@linaro.org>
References: <20240126220407.95022-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a Coccinelle script to convert the following slow path
(due to the QOM cast macro):

  &ARCH_CPU(..)->env

to the following fast path:

  cpu_env(..)

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 MAINTAINERS                               |  1 +
 scripts/coccinelle/cpu_env.cocci_template | 92 +++++++++++++++++++++++
 2 files changed, 93 insertions(+)
 create mode 100644 scripts/coccinelle/cpu_env.cocci_template

diff --git a/MAINTAINERS b/MAINTAINERS
index dfaca8323e..1d57130ff8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -157,6 +157,7 @@ F: accel/tcg/
 F: accel/stubs/tcg-stub.c
 F: util/cacheinfo.c
 F: util/cacheflush.c
+F: scripts/coccinelle/cpu_env.cocci_template
 F: scripts/decodetree.py
 F: docs/devel/decodetree.rst
 F: docs/devel/tcg*
diff --git a/scripts/coccinelle/cpu_env.cocci_template b/scripts/coccinelle/cpu_env.cocci_template
new file mode 100644
index 0000000000..462ed418bb
--- /dev/null
+++ b/scripts/coccinelle/cpu_env.cocci_template
@@ -0,0 +1,92 @@
+/*
+
+ Convert &ARCH_CPU(..)->env to use cpu_env(..).
+
+ Rationale: ARCH_CPU() might be slow, being a QOM cast macro.
+            cpu_env() is its fast equivalent.
+
+ SPDX-License-Identifier: GPL-2.0-or-later
+ SPDX-FileCopyrightText: Linaro Ltd 2024
+ SPDX-FileContributor: Philippe Mathieu-Daudé
+
+ Usage as of v8.2.0:
+
+ $ for targetdir in target/*; do test -d $targetdir || continue; \
+       export target=${targetdir:7}; \
+       sed \
+           -e "s/__CPUArchState__/$( \
+               git grep -h --no-line-number '@env: #CPU.*State' \
+                   target/$target/cpu.h \
+               | sed -n -e 's/.*\(CPU.*State\).\?/\1/p')/g" \
+           -e "s/__ARCHCPU__/$( \
+               git grep -h --no-line-number OBJECT_DECLARE_CPU_TYPE.*CPU \
+                   target/$target/cpu-qom.h \
+               | sed -n -e 's/.*(\(.*\), .*, .*)/\1/p')/g" \
+           -e "s/__ARCH_CPU__/$( \
+               git grep -h --no-line-number OBJECT_DECLARE_CPU_TYPE.*CPU \
+                   target/$target/cpu-qom.h \
+               | sed -n -e 's/.*(.*, .*, \(.*\))/\1/p')/g" \
+       < scripts/coccinelle/cpu_env.cocci_template \
+       > $TMPDIR/cpu_env_$target.cocci; \
+       for dir in hw target/$target; do \
+           spatch --macro-file scripts/cocci-macro-file.h \
+                  --sp-file $TMPDIR/cpu_env_$target.cocci \
+                  --keep-comments \
+                  --dir $dir \
+                  --in-place; \
+       done; \
+   done
+
+*/
+
+/* Argument is CPUState* */
+@ CPUState_arg_used @
+CPUState *cs;
+identifier cpu;
+identifier env;
+@@
+-    __ARCHCPU__ *cpu = __ARCH_CPU__(cs);
+-    __CPUArchState__ *env = &cpu->env;
++    __CPUArchState__ *env = cpu_env(cs);
+     ... when != cpu
+
+/*
+ * Argument is not CPUState* but a related QOM object.
+ * CPU() is not a QOM macro but a cast (See commit 0d6d1ab499).
+ */
+@ depends on never CPUState_arg_used @
+identifier obj;
+identifier cpu;
+identifier env;
+@@
+-    __ARCHCPU__ *cpu = __ARCH_CPU__(obj);
+-    __CPUArchState__ *env = &cpu->env;
++    __CPUArchState__ *env = cpu_env(CPU(obj));
+     ... when != cpu
+
+/* Both first_cpu/current_cpu are CPUState* */
+@@
+symbol first_cpu;
+symbol current_cpu;
+@@
+(
+-    CPU(first_cpu)
++    first_cpu
+|
+-    CPU(current_cpu)
++    current_cpu
+)
+
+/* When single use of 'env', call cpu_env() in place */
+@@
+type CPUArchState;
+identifier env;
+expression cs;
+@@
+ {
+-    CPUArchState *env = cpu_env(cs);
+     ... when != env
+-     env
++     cpu_env(cs)
+     ... when != env
+ }
-- 
2.41.0


