Return-Path: <kvm+bounces-51457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1CEAAF715C
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80688189CECD
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F1C2E49BE;
	Thu,  3 Jul 2025 11:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m9Q+dpTg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0205E2E173B
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540430; cv=none; b=tFfQ7epsqti7rriMNGO8yHvMdjyR45Dlb6WL94mLyN7ey6bEItk2BeHmYao0riCeOrBPczfImdsQFhlq/ldmaT1q23N2FaKc43uj7w+SrIc/jTF+e2nD4CQ5ik2BXzLDNffvCs2c/lf0S2lfLryJQZeix/w4FHUNrBB8kdf4TsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540430; c=relaxed/simple;
	bh=Q5fOOSoB6QYPMygprsF/FOkjFOIk5QJz+lBdO1fA75I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ijyy63RTDXGtaTzyvS/d9iAzHpH5fgU0mvvZwT8y7Dn5yfM/TwxIuEHvcVql7tC84nicWlTPn8BKN5Q1G8amFyw4/le858NrfZyd1np+RbzhPaKPgGC/nc9OWxGMsLz79ux/oFDWdgBz1qR4XTAwZANcCDcOxFiYq8fal1R8gEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=m9Q+dpTg; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-453608ed113so57071095e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540427; x=1752145227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9v6+HYr/42Y/Iowg1uUW2qQvLw8fBzoanUujYKDMrhU=;
        b=m9Q+dpTguIhqu5StQ7JAxNl3VuKDsqY1AwzMMJ+a+R6y5AjcyUmwwOu7Q7IFGs+mtE
         HtSXcw7LdOkcdu7ip8ZVzp0ABvLqWEjVzFS8fmkTD8LAUI9NkPHKDm2c8nT/81ZOZQE+
         0+eSzHlIAun3ydaRp7fU8HzLoHKZv/wPlUG/W1reVevBh5XoNLEA0aeQsXkJy/m6ck0E
         IiOnt5E97dBJVBIwehhkLvYb9MiiN1DkjWPTXRSjlN8PHCGww5LERttXvICbVLCSzqut
         DqD54VIoQeP+tVEWjSAUqeDb5pN14/7NPAEFbPhJi+fd85R7bpGHKpfFuu9DXRZvfjGC
         QQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540427; x=1752145227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9v6+HYr/42Y/Iowg1uUW2qQvLw8fBzoanUujYKDMrhU=;
        b=dT3u3vNusQsQPcmf1zsUSrJdaz7nji82A0MHz99BmLOnGqSBtGGHbQF4D6E/ajZwaU
         RVYkwkJV5J9glFKtgS2vhlzJzueh36EVF3A8rPGVztUVWLTUCnik7GgzHM4xccTzDTBQ
         PRtJ2LqhzkYycVRhatL8UhFZx/8hxfY29CXBoatwfD05bMsoaWqUJJ3Ym+Gwz9146LEk
         CrtTeDgKTpCH7ydeFHtSPlmgza8zpUuB3L/j62Y/xAdbGpZUeSy2fF/AGv/QIxWv3xSA
         TbxpZxWggIOb/LjX+8uMch7leu21q811oJihRe+EErsAE5IJn1cNz+WktTlEfbbxouma
         lR+g==
X-Forwarded-Encrypted: i=1; AJvYcCXUCwa53qqVhKpXQWDxaGZ31cAfJUrfFjSgUYqpPrglZ5C88Xuo0RB2XpO/DcEP8QnUVxw=@vger.kernel.org
X-Gm-Message-State: AOJu0YymtIylksJTeEb8Cw5gLMQX171F2xxbqCqpIVaogNwh5rOig6z9
	t4iYRQcW+e3YULWd9kWWIQWQ7h9zSZFXVxMKkSlZgQOJGJhltavEqAcqlLudkUtsHSQ=
X-Gm-Gg: ASbGncvf9XmQT3EY1qRz2hnigYatwKhf464Gdo+HnNbeMtgbaMr3leY/xM0b3m5J9Tk
	2K3ler4PTrnGOnYalzdvqVae24AWMWGAfh1MLM3onc5NH1XAH4AJ9y4/hYiXs5WJ7GGD+XkuyNo
	na0owXy9Vrg22fqeARXZRjEeNE8JGEM077IVCL78k1ITTmx6yQzM7/lVQlaftRlSZTFGOtp/TXh
	z3pNHZsQUNsMb0vkUu6m4vZA1JlS3EEjus9txzPnW/UlBOG4iIeGw8NxpJkjNeaYv//cU4Fn+jq
	994nqT6SgIS5bNacTJa80fY1P/JCtGQeLd/jtIylA+25zBjZI++rAaMN9AfKfRyoY91HQPo11f8
	yHVYd/0FwgqE=
X-Google-Smtp-Source: AGHT+IF9CCc+1SyfWjqrX0exoaFSuCvbstf/am9lDh22OfJZZiZvFa6b7FpHEQAXT3qDpYBDuEUQAw==
X-Received: by 2002:a05:600c:3509:b0:453:dbe:7574 with SMTP id 5b1f17b1804b1-454a9c6fe94mr37610555e9.12.1751540427223;
        Thu, 03 Jul 2025 04:00:27 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9967ee7sm24187515e9.8.2025.07.03.04.00.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:00:26 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 54/69] accel/tcg: Convert to AccelOpsClass::cpu_thread_routine
Date: Thu,  3 Jul 2025 12:55:20 +0200
Message-ID: <20250703105540.67664-55-philmd@linaro.org>
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

By converting to AccelOpsClass::cpu_thread_routine we can
let the common accel_create_vcpu_thread() create the thread.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/tcg/tcg-accel-ops-mttcg.h |  3 +--
 accel/tcg/tcg-accel-ops-mttcg.c | 16 +---------------
 accel/tcg/tcg-accel-ops.c       |  3 ++-
 3 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/accel/tcg/tcg-accel-ops-mttcg.h b/accel/tcg/tcg-accel-ops-mttcg.h
index 8ffa7a9a9fe..8bf2452c886 100644
--- a/accel/tcg/tcg-accel-ops-mttcg.h
+++ b/accel/tcg/tcg-accel-ops-mttcg.h
@@ -13,7 +13,6 @@
 /* kick MTTCG vCPU thread */
 void mttcg_kick_vcpu_thread(CPUState *cpu);
 
-/* start an mttcg vCPU thread */
-void mttcg_start_vcpu_thread(CPUState *cpu);
+void *mttcg_cpu_thread_routine(void *arg);
 
 #endif /* TCG_ACCEL_OPS_MTTCG_H */
diff --git a/accel/tcg/tcg-accel-ops-mttcg.c b/accel/tcg/tcg-accel-ops-mttcg.c
index 462be7596b9..96ce065eb59 100644
--- a/accel/tcg/tcg-accel-ops-mttcg.c
+++ b/accel/tcg/tcg-accel-ops-mttcg.c
@@ -61,7 +61,7 @@ static void mttcg_force_rcu(Notifier *notify, void *data)
  * current CPUState for a given thread.
  */
 
-static void *mttcg_cpu_thread_fn(void *arg)
+void *mttcg_cpu_thread_routine(void *arg)
 {
     MttcgForceRcuNotifier force_rcu;
     CPUState *cpu = arg;
@@ -128,17 +128,3 @@ void mttcg_kick_vcpu_thread(CPUState *cpu)
 {
     cpu_exit(cpu);
 }
-
-void mttcg_start_vcpu_thread(CPUState *cpu)
-{
-    char thread_name[VCPU_THREAD_NAME_SIZE];
-
-    tcg_vcpu_thread_precreate(cpu);
-
-    /* create a thread per vCPU with TCG (MTTCG) */
-    snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/TCG",
-             cpu->cpu_index);
-
-    qemu_thread_create(cpu->thread, thread_name, mttcg_cpu_thread_fn,
-                       cpu, QEMU_THREAD_JOINABLE);
-}
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 861996649b7..4931e536beb 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -204,7 +204,7 @@ static void tcg_accel_ops_init(AccelClass *ac)
     AccelOpsClass *ops = ac->ops;
 
     if (qemu_tcg_mttcg_enabled()) {
-        ops->create_vcpu_thread = mttcg_start_vcpu_thread;
+        ops->cpu_thread_routine = mttcg_cpu_thread_routine;
         ops->kick_vcpu_thread = mttcg_kick_vcpu_thread;
         ops->handle_interrupt = tcg_handle_interrupt;
     } else {
@@ -222,6 +222,7 @@ static void tcg_accel_ops_init(AccelClass *ac)
 
     ops->cpu_common_realize = tcg_exec_realizefn;
     ops->cpu_common_unrealize = tcg_exec_unrealizefn;
+    ops->thread_precreate = tcg_vcpu_thread_precreate;
     ops->cpu_reset_hold = tcg_cpu_reset_hold;
     ops->insert_breakpoint = tcg_insert_breakpoint;
     ops->remove_breakpoint = tcg_remove_breakpoint;
-- 
2.49.0


